import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoadInProgress extends LocationState {}

class LocationLoadSuccess extends LocationState {
  final LatLng currentLocation;

  LocationLoadSuccess(this.currentLocation);
}

class LocationPermissionDenied extends LocationState {}

class LocationLoadFailure extends LocationState {
  final String error;

  LocationLoadFailure(this.error);
}
