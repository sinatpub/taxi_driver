part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

// check driver status

class CheckDriverStatusEvent extends HomeEvent {}

class ToggleOnOffDriverEvent extends HomeEvent {
  final int isTurnOn;

  ToggleOnOffDriverEvent({required this.isTurnOn});
}

class GetCurrentLocationEvent extends HomeEvent {}

class GenerateMarker extends HomeEvent {}
