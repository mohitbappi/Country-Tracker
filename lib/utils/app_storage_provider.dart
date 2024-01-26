import 'package:country_tracker/screens/constants/index.dart';
import 'package:country_tracker/utils/local_storage.dart';

class AppStorageProvider {
  final _storage = LocalStorage();

  Future<String> readHistory() async {
    return await _storage.readString(key: locationHistory);
  }

  void saveHistory(String value) async {
    await _storage.saveString(key: locationHistory, value: value);
  }

  Future<String> readCountryCount() async {
    return await _storage.readString(key: countryCount);
  }

  void saveCountryCount(String value) async {
    await _storage.saveString(key: countryCount, value: value);
  }
}
