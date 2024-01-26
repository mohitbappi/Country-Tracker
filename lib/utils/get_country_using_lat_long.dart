import 'package:geocoding/geocoding.dart';

Future<String> getCountryName(double latitude, double longitude) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

    Placemark place = placemarks[0];

    return '${place.street}, ${place.subAdministrativeArea}, ${place.locality}, ${place.administrativeArea}, ${place.country}, ${place.postalCode}';
  } catch (e) {
    return '';
  }
}

Future<String> getCountry(double latitude, double longitude) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

    Placemark place = placemarks[0];

    return place.country ?? '';
  } catch (e) {
    return '';
  }
}
