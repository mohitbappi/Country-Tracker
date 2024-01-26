import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:country_tracker/models/country_count_model.dart';
import 'package:country_tracker/models/history_model.dart';
import 'package:country_tracker/strings/index.dart';
import 'package:country_tracker/utils/app_storage_provider.dart';
import 'package:country_tracker/utils/get_country_using_lat_long.dart';
import 'package:country_tracker/widgets/exo2_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GeolocatorPage extends StatefulWidget {
  const GeolocatorPage({Key? key}) : super(key: key);

  @override
  State<GeolocatorPage> createState() => _GeolocatorPageState();
}

class _GeolocatorPageState extends State<GeolocatorPage> {
  static const String _kLocationServicesDisabledMessage = Strings.locationServicesAreDisabled;
  static const String _kPermissionDeniedMessage = Strings.permissionDenied;
  static const String _kPermissionDeniedForeverMessage = Strings.permissionDeniedForever;
  static const String _kPermissionGrantedMessage = Strings.permissionGranted;
  final _appStorageProvider = AppStorageProvider();

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  String _currentLocation = '';
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isEnabled = false;

  @override
  void initState() {
    super.initState();
    _toggleListening();
    _getCurrentPosition();
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
      _positionStreamSubscription = null;
    }

    super.dispose();
  }

  void showToast(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.blueAccent,
        content: Exo2Text(
          text: message,
          color: Colors.white,
        ),
      ),
    );
  }

  PopupMenuButton _createActions() {
    return PopupMenuButton(
      elevation: 40,
      onSelected: (value) async {
        switch (value) {
          case 1:
            _getLocationAccuracy();
            break;
          case 2:
            _requestTemporaryFullAccuracy();
            break;
          case 3:
            _openAppSettings();
            break;
          case 4:
            _openLocationSettings();
            break;
          default:
            break;
        }
      },
      itemBuilder: (context) => [
        if (Platform.isIOS)
          const PopupMenuItem(
            value: 1,
            child: Text(Strings.getLocationAccuracy),
          ),
        if (Platform.isIOS)
          const PopupMenuItem(
            value: 2,
            child: Text(Strings.requestTemporaryFullAccuracy),
          ),
        const PopupMenuItem(
          value: 3,
          child: Text(Strings.openAppSettings),
        ),
        if (Platform.isAndroid || Platform.isWindows)
          const PopupMenuItem(
            value: 4,
            child: Text(Strings.openLocationSettings),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [_createActions()],
        title: const Text(Strings.countryPicker),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Exo2Text(
              text: Strings.currentLocation,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: MediaQuery.of(context).size.width - 100,
              child: Exo2Text(
                text: _currentLocation,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    final position = await _geolocatorPlatform.getCurrentPosition();
    final location = await getCountryName(position.latitude, position.longitude);
    setState(() {
      _currentLocation = location;
    });
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      showToast(_kLocationServicesDisabledMessage);

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        showToast(_kPermissionDeniedMessage);

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      showToast(_kPermissionDeniedForeverMessage);

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    showToast(_kPermissionGrantedMessage);

    return true;
  }

  void _toggleListening() {
    if (_isEnabled) {
      late LocationSettings locationSettings;

      if (defaultTargetPlatform == TargetPlatform.android) {
        locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
          forceLocationManager: true,
        );
      } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
        locationSettings = AppleSettings(
          accuracy: LocationAccuracy.high,
          activityType: ActivityType.otherNavigation,
          distanceFilter: 0,
          pauseLocationUpdatesAutomatically: true,
          showBackgroundLocationIndicator: true,
        );
      } else {
        locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
        );
      }

      final positionStream = _geolocatorPlatform.getPositionStream(
        locationSettings: locationSettings,
      );
      _positionStreamSubscription = positionStream.handleError((error) {
        _positionStreamSubscription?.cancel();
        _positionStreamSubscription = null;
      }).listen((position) async {
        try {
          await saveHistory(position);
          await saveCountryCount(position);

          setState(() {
            _isEnabled = false;
          });
        } catch (err) {
          showToast(err.toString());
        }
      });
    } else if (isMidnight()) {
      setState(() {
        _isEnabled = true;
      });
    }
  }

  bool isMidnight() {
    DateTime now = DateTime.now();
    return now.hour == 0 && now.minute == 0 && now.second == 0;
  }

  Future<void> saveHistory(Position position) async {
    final res = await _appStorageProvider.readHistory();
    List<dynamic> jsonData = res.isNotEmpty ? jsonDecode(res) : [];
    List<HistoryModel> historyFromJson = jsonData.map((item) => HistoryModel.fromJson(item)).toList();

    final List<HistoryModel> newHistory = [...historyFromJson];
    final location = await getCountryName(position.latitude, position.longitude);
    newHistory.add(HistoryModel(date: DateTime.now().toString(), address: location));
    String jsonString = jsonEncode(newHistory.map((user) => user.toJson()).toList());

    _appStorageProvider.saveHistory(jsonString);
  }

  Future<void> saveCountryCount(Position position) async {
    final countryCountRes = await _appStorageProvider.readCountryCount();
    List<dynamic> countryCountJsonData = countryCountRes.isNotEmpty ? jsonDecode(countryCountRes) : [];
    List<CountryCountModel> countryCountFromJson =
        countryCountJsonData.map((item) => CountryCountModel.fromJson(item)).toList();

    final List<CountryCountModel> newcountryCount = [...countryCountFromJson];
    final country = await getCountry(position.latitude, position.longitude);
    final countryAlreadyAdded = newcountryCount.indexWhere((element) => element.name == country);
    if (countryAlreadyAdded != -1) {
      newcountryCount[countryAlreadyAdded].count += 1;
    } else {
      newcountryCount.add(CountryCountModel(name: country, count: 1));
    }

    String countryCountJsonString = jsonEncode(newcountryCount.map((country) => country.toJson()).toList());

    _appStorageProvider.saveCountryCount(countryCountJsonString);
  }

  void _getLocationAccuracy() async {
    final status = await _geolocatorPlatform.getLocationAccuracy();
    _handleLocationAccuracyStatus(status);
  }

  void _requestTemporaryFullAccuracy() async {
    final status = await _geolocatorPlatform.requestTemporaryFullAccuracy(
      purposeKey: "TemporaryPreciseAccuracy",
    );
    _handleLocationAccuracyStatus(status);
  }

  void _handleLocationAccuracyStatus(LocationAccuracyStatus status) {
    String locationAccuracyStatusValue;
    if (status == LocationAccuracyStatus.precise) {
      locationAccuracyStatusValue = 'Precise';
    } else if (status == LocationAccuracyStatus.reduced) {
      locationAccuracyStatusValue = 'Reduced';
    } else {
      locationAccuracyStatusValue = 'Unknown';
    }

    showToast('$locationAccuracyStatusValue ${Strings.locationAccuracy}.');
  }

  void _openAppSettings() async {
    final opened = await _geolocatorPlatform.openAppSettings();
    String displayValue;

    if (opened) {
      displayValue = Strings.openAppSettings;
    } else {
      displayValue = Strings.errorOpeningApplicationSettings;
    }

    showToast(displayValue);
  }

  void _openLocationSettings() async {
    final opened = await _geolocatorPlatform.openLocationSettings();
    String displayValue;

    if (opened) {
      displayValue = Strings.openLocationSettings;
    } else {
      displayValue = Strings.errorOpeningLocationSettings;
    }

    showToast(displayValue);
  }
}
