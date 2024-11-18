import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

Future<BitmapDescriptor> _loadCustomMarker(String markerPath) async {
  // Load the BitmapDescriptor from an asset image
  BitmapDescriptor customIcon = await BitmapDescriptor.asset(
    const ImageConfiguration(size: Size(38, 38)),
    markerPath,
  );
  return customIcon;
}

Future<Marker> generatingMarker({
  required double lat,
  required double long,
  required String markerPath,
  required String markerId,
  String? title,
}) async {
  // Await the BitmapDescriptor creation
  BitmapDescriptor icon = await _loadCustomMarker(markerPath);

  // Create the Marker with the resolved icon
  Marker marker = Marker(
    markerId:  MarkerId(markerId),
    position: LatLng(lat, long),
    icon: icon, // Use the resolved BitmapDescriptor here
    infoWindow: InfoWindow(
      title: title ?? 'Your Current Location',
    ),
  );
  return marker;
}
