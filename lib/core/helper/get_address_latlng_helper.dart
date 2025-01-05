import 'package:com.tara_driver_application/core/utils/pretty_logger.dart';
import 'package:geocoding/geocoding.dart';

Future<String> getAddressFromLatLng(double latitude, double longitude) async {
  try {
    await setLocaleIdentifier("km");
    List<Placemark> placemarks = await placemarkFromCoordinates(
      latitude,
      longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];

      //tlog("PlaceMarker: $placemarks");
      String address = '';
      address += place.name != null ? "${place.name}, " : '';
      address += place.street != null ? "${place.street}, " : '';
      address += place.subLocality != null ? "${place.subLocality}, " : '';
      address += place.locality != null ? "${place.locality}, " : '';
      address += place.postalCode != null ? "${place.postalCode}, " : '';
      address += place.country != null ? "${place.country}" : '';
      return address.trim().replaceAll(RegExp(r',\s*$'), '');
    } else {
      return "Address not found";
    }
  } catch (e) {
    print("Error: $e");
    return "Address not found";
  }
}
