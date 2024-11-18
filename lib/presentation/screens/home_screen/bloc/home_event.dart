part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}


class GetCurrentLocationEvent extends HomeEvent{
  
}

class GenerateMarker extends HomeEvent{}