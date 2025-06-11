import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tara_driver_application/core/utils/pretty_logger.dart';

// Function to convert PNG to BitmapDescriptor
Future<BitmapDescriptor> generateMarker(String assetPath, {required lat}) async {
  try {
    BitmapDescriptor markerIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      assetPath,
    );
    return markerIcon;
  } catch (e) {
    tlog("Error loading marker icon: $e", level: LogLevel.error);
    throw Exception('Error loading marker icon');
  }
}
