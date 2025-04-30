import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:com.tara_driver_application/presentation/screens/home_screen/home_screen.dart';
import 'package:com.tara_driver_application/services/location_bloc/location_event.dart';
import 'package:com.tara_driver_application/services/location_bloc/location_state.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:com.tara_driver_application/data/datasources/update_driver_location_api.dart';
import 'package:com.tara_driver_application/core/utils/app_constant.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final UpdateDriverLocation updateLocationRepo = UpdateDriverLocation();
  GoogleMapController? mapController;
  Set<Marker>? setMarker;
  BitmapDescriptor? passengerMarker;
  BitmapDescriptor? driverMarker;

  LocationBloc() : super(LocationInitial()) {
    on<LoadInitialLocation>(_onLoadInitialLocation);
    on<UpdateLocation>(_onUpdateLocation);
    on<RequestLocationPermission>(_onRequestLocationPermission);
  }

  Future<void> _onLoadInitialLocation(
      LoadInitialLocation event, Emitter<LocationState> emit) async {
    emit(LocationLoadInProgress());

    bool hasPermission = await requestPermissionLocation();
    if (hasPermission) {
      Position? position = await getCurrentLocation();
      if (position != null) {
        emit(
            LocationLoadSuccess(LatLng(position.latitude, position.longitude)));
        centerMapOnCurrentLocation();
        await generateMarker(LatLng(position.latitude, position.longitude));
      } else {
        emit(LocationLoadFailure("Failed to get current location"));
      }
    } else {
      emit(LocationPermissionDenied());
    }
  }

  Future<void> _onUpdateLocation(
      UpdateLocation event, Emitter<LocationState> emit) async {
    try {
      StreamSubscription<Position>? positionStream =
          Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((Position position) async {
        LatLng currentLocation = LatLng(position.latitude, position.longitude);
        Logger().i(
            "📍 Updated user location: ${position.latitude}, ${position.longitude}");
        updateMarkerPosition(currentLocation);
        centerMapOnCurrentLocation();

        await updateLocationRepo.updateDriverLocationApi(
          lat: position.latitude,
          log: position.longitude,
        );

        emit(LocationLoadSuccess(currentLocation));
      });
    } catch (e) {
      Logger().e(e);
      emit(LocationLoadFailure(e.toString()));
    }
  }

  Future<void> _onRequestLocationPermission(
      RequestLocationPermission event, Emitter<LocationState> emit) async {
    bool hasPermission = await requestPermissionLocation();
    if (hasPermission) {
      add(LoadInitialLocation());
    } else {
      emit(LocationPermissionDenied());
    }
  }

  Future<bool> requestPermissionLocation() async {
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

      return true;
    } catch (e) {
      Logger().e("Error requesting location permission: $e");
      return false;
    }
  }

  Future<Position?> getCurrentLocation() async {
    try {
      Position? result = await Geolocator.getLastKnownPosition() ??
          await Geolocator.getCurrentPosition(
            timeLimit: const Duration(seconds: 15),
            desiredAccuracy: LocationAccuracy.best,
          );
      return result;
    } catch (e) {
      Logger().e("Error fetching current location: $e");
      return null;
    }
  }

  void centerMapOnCurrentLocation() {
    if (mapController != null && setMarker != null && setMarker!.isNotEmpty) {
      LatLng currentLocation = setMarker!.first.position;
      mapController!.animateCamera(CameraUpdate.newLatLng(currentLocation));
    }
  }

  void updateMarkerPosition(LatLng currentLocation) {
    if (setMarker != null) {
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

  Future<void> generateMarker(LatLng currentLocation) async {
    driverMarker =
        await loadCustomMarker(imagePath: "assets/marker/car_marker.png");
    passengerMarker =
        await loadCustomMarker(imagePath: 'assets/marker/passenger_marker.png');

    // Initialize the marker set
    setMarker = {
      Marker(
        markerId: const MarkerId(AppConstant.driverMarker),
        position: currentLocation,
        infoWindow: const InfoWindow(title: "Driver Location"),
        icon: driverMarker!,
      ),
    };
  }
}
