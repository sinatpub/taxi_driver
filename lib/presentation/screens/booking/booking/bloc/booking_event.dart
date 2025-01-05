part of 'booking_bloc.dart';

@immutable
sealed class BookingEvent {}

class ConfirmBookingEvent extends BookingEvent {
  final int rideId;
  ConfirmBookingEvent({required this.rideId,});
}

class CanceBookingEvent extends BookingEvent {
  final int rideId;

  CanceBookingEvent({required this.rideId});
}

class StartTripEvent extends BookingEvent {
  final int rideId;

  StartTripEvent({required this.rideId});
}

class ArrivedEvent extends BookingEvent {
  final int rideId;

  ArrivedEvent({required this.rideId});
}

class CompletedTripEvent extends BookingEvent {
  final int rideId;
  final String endAddress;
  final double endLatitude;
  final double endLongitude;
  final double distance;

  CompletedTripEvent({
    required this.rideId,
    required this.endAddress,
    required this.endLatitude,
    required this.endLongitude,
    required this.distance,
  });
}
