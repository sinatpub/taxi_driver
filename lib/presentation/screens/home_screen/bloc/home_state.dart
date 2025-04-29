part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

// Get Current Location
class CurrentLocationLoading extends HomeState {}

class CurrentLocationLoaded extends HomeState {
  final LatLng currentLatLng;

  CurrentLocationLoaded({required this.currentLatLng});
}

// check offline and online
class CheckDriverStatusLoadingState extends HomeState {}

class CheckDriverStatusLoadedState extends HomeState {
  final int isDriverOnline;

  CheckDriverStatusLoadedState({required this.isDriverOnline});
}

class CheckDriverStatusErrorState extends HomeState {}

// toggle online - offline service

class ToggleDriverService extends HomeState {
  int isTurnon;

  ToggleDriverService({this.isTurnon = 1}); // 1= on, 2= off
}

// check request info
class CheckRequestInfoLoadingState extends HomeState {}

class CheckRequestInfoLoadedState extends HomeState {}

class CheckRequestInfoErrorState extends HomeState {}


// 
