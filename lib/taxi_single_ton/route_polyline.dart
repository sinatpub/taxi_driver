import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class RouteTracker {
  static final RouteTracker _instance = RouteTracker._internal();
  late GoogleMapController _mapController;
  final Location _location = Location();
  final List<LatLng> _routePoints = []; // List to store route points (coordinates)
  StreamSubscription<LocationData>? _locationSubscription;
  Polyline _routePolyline = const Polyline(
    polylineId:  PolylineId('route'),
    color: Colors.blue,
    width: 5,
    points: [],
  );

  // Private constructor for Singleton
  RouteTracker._internal();

  // Factory constructor to return the same instance
  factory RouteTracker() {
    return _instance;
  }

  // Initialize Google Map controller
  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  // Method to start route tracking
  Future<void> startRouteTracking() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location services are enabled
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return; // Exit if services are not enabled
      }
    }

    // Check if location permissions are granted
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return; // Exit if permission is denied
      }
    }

    // Start listening for location updates
    _locationSubscription =
        _location.onLocationChanged.listen((LocationData locationData) {
      LatLng newPosition =
          LatLng(locationData.latitude!, locationData.longitude!);

      // Add new position to route points
      _routePoints.add(newPosition);

      // Update the polyline with the new points
      _routePolyline = _routePolyline.copyWith(pointsParam: _routePoints);

      // Move camera to the new location
      _mapController.animateCamera(CameraUpdate.newLatLng(newPosition));
    });
  }

  // Method to stop route tracking
  void stopRouteTracking() {
    _locationSubscription?.cancel();
  }

  // Method to get the current polyline for route drawing
  Polyline getRoutePolyline() {
    return _routePolyline;
  }
}
