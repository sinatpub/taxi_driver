import 'dart:async';
import 'dart:typed_data';
import 'package:com.tara_driver_application/core/utils/app_constant.dart';
import 'package:com.tara_driver_application/core/utils/load_custom_marker.dart';
import 'package:com.tara_driver_application/data/datasources/update_driver_location_api.dart';
import 'package:com.tara_driver_application/presentation/screens/home_screen/home_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

class TaxiLocation {
  TaxiLocation._internal();
  static TaxiLocation? _singleton = TaxiLocation._internal();

  static TaxiLocation get shared {
    _singleton ??= TaxiLocation._internal();
    return _singleton!;
  }

  // repo update current driver
  UpdateDriverLocation updateLocationRepo = UpdateDriverLocation();

  bool isGranted = false;
  LatLng currentLocation = const LatLng(0, 0);
  bool _isRequestingPermission = false; // Track ongoing permission requests
  StreamSubscription<Position>? positionStream;

  // marker
  Set<Marker>? setMarker;
  BitmapDescriptor? passengerMarker;
  BitmapDescriptor? driverMarker;
  GoogleMapController? mapController;

  void onInit() async {
    generateMarker();
    await checkLocationPermission();
    await getCurrentLocation();
    await loadMarker();
    centerMapOnCurrentLocation();
  }

  // Check location permission
  Future<bool> checkLocationPermission() async {
    if (_isRequestingPermission) {
      Logger().d("A permission request is already in progress.");
      return false;
    }
    bool hasPermission = await requestPermissionLocation();
    return hasPermission;
  }

  // Request permission location
  Future<bool> requestPermissionLocation() async {
    _isRequestingPermission = true;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      LocationPermission permission = await Geolocator.checkPermission();

      if (!serviceEnabled) {
        Logger().e("Location services are disabled.");
        return false;
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Logger().e("Location permission denied.");
          return false;
        }
      }

      isGranted = true; // Update permission state
      return true;
    } catch (e) {
      Logger().e("Error requesting location permission: $e");
      return false;
    } finally {
      _isRequestingPermission = false; // Reset the flag after completion
    }
  }

  // Get current location
  Future<Position?> getCurrentLocation() async {
    if (await checkLocationPermission() == false) {
      return null;
    }
    try {
      Position? result = await Geolocator.getLastKnownPosition() ??
          await Geolocator.getCurrentPosition(
            timeLimit: const Duration(seconds: 15),
            desiredAccuracy: LocationAccuracy.best,
          );
      currentLocation = LatLng(result.latitude, result.longitude);
      Logger().d(
          "Current Location: ${currentLocation.latitude} - ${currentLocation.longitude}");
      return result;
    } catch (e) {
      Logger().e("Error fetching current location: $e");
      return null;
    }
  }

  // Get address from coordinates
  Future<String> getAddressLocation(
      {required LatLng latlng, bool localeKhmer = true}) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latlng.latitude, latlng.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

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
      Logger().e("Error decoding address: $e");
      return "Address not found";
    }
  }

  // Update current location of driver in 10 meters
  Future<LatLng> updateCurrentLocationDriver() async {
    try {
      positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((Position position) async {
        currentLocation = LatLng(position.latitude, position.longitude);
        Logger().i(
            "📍 Updated user location: ${position.latitude}, ${position.longitude}");
        updateMarkerPosition();
        centerMapOnCurrentLocation();

        // ! update current location to api
        await updateLocationRepo.updateDriverLocationApi(
          lat: position.latitude,
          log: position.longitude,
        );
      });
      return currentLocation;
    } catch (e) {
      Logger().e(e);
      return currentLocation;
    }
  }

  void centerMapOnCurrentLocation() {
    if (mapController != null && currentLocation != const LatLng(0, 0)) {
      mapController!.animateCamera(CameraUpdate.newLatLng(currentLocation));
    }
  }

  void updateMarkerPosition() {
    if (setMarker != null && setMarker!.isNotEmpty) {
      setMarker!.removeWhere(
          (marker) => marker.markerId.value == AppConstant.driverMarker);
      setMarker!.add(Marker(
        markerId: const MarkerId(AppConstant.driverMarker),
        position: currentLocation,
        infoWindow: const InfoWindow(title: "Driver Location"),
        icon: driverMarker!,
      ));
    }
  }

  Future<void> generateMarker() async {
    final Uint8List markerDriverImage =
        await loadImageFromAssets('assets/marker/car_marker.png');
    final Uint8List markerPassengerImage =
        await loadImageFromAssets('assets/marker/passenger_marker.png');

    passengerMarker = BitmapDescriptor.fromBytes(markerPassengerImage);
    driverMarker = BitmapDescriptor.fromBytes(markerDriverImage);
  }

  Future<void> loadMarker() async {
    // Load the custom marker icon
    BitmapDescriptor driverIcon = await loadCustomMarker(
      imagePath: "assets/marker/car_marker.png",
    );

    // Create the Marker object with the loaded icon
    Marker driverMarkerObject = Marker(
      markerId: const MarkerId(AppConstant.driverMarker),
      position: currentLocation,
      infoWindow: const InfoWindow(title: "Driver Location"),
      icon: driverIcon, // Use the loaded BitmapDescriptor here
    );

    // Add the marker to the set of markers
    setMarker ??= <Marker>{};
    setMarker!.add(driverMarkerObject);

    // Optionally, store the BitmapDescriptor if needed elsewhere
    driverMarker = driverIcon;
  }
}
