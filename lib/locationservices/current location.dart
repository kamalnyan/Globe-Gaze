
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<String> getCurrentLocation() async {
  String currentLocation = "No location details available";
  // Check location permissions
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    print("Location permission denied.");

    // Request permission
    LocationPermission ask = await Geolocator.requestPermission();

    // If permission is still denied after asking, return without location
    if (ask == LocationPermission.denied || ask == LocationPermission.deniedForever) {
      print("Location permission denied by user.");
    }
  }

  // If permission is granted or already available
  try {
    Position currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 100,
        ));

    // Reverse geocode the coordinates into human-readable place
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.longitude);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      currentLocation = "${place.locality}, ${place.country}";
    }
  } catch (e) {
    print("Error getting location: $e");
  }

  return currentLocation;
}

Future<Map<String, String>> actualLocation(double latitude, double longitude) async {
  String actuallocality = "No location details available";
  String actualcountry = "No location details available";

  List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

  if (placemarks.isNotEmpty) {
    Placemark place = placemarks[0];
    actuallocality = "${place.locality}";
    actualcountry = "${place.country}";
  } else {
    print('Got some error');
  }
  return {
    'locality': actuallocality,
    'country': actualcountry
  };
}
