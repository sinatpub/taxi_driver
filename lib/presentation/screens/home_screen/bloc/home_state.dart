part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}



// Get Current Location

class CurrentLocationLoading extends HomeState{}
class CurrentLocationLoaded extends HomeState{
  final LatLng currentLatLng;

  CurrentLocationLoaded({required this.currentLatLng});

}