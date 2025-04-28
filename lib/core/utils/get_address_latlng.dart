import 'package:geocoding/geocoding.dart';

Future<String> getAddressFromLatLng(double latitude, double longitude) async {
  try {
    // Get the list of placemarks from the provided lat, lng
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude,);
    
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first; // Get the first placemark

      // Construct the address
      String address = "${placemark.name}, ${placemark.locality}, ${placemark.country}";
      return address;
    } else {
      return "Address not found";
    }
  } catch (e) {
    return "Error: $e";
  }
}