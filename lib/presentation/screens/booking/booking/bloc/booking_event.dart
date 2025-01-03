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

class ArrivedPassengerEvent extends BookingEvent {
  final int rideId;

  ArrivedPassengerEvent({required this.rideId});
}

class CompletedTripEvent extends BookingEvent {
  final int rideId;
  final String endAddress;
  final double endLatitude;
  final double endLongitude;
   double? distance;

  CompletedTripEvent({
    required this.rideId,
    required this.endAddress,
    required this.endLatitude,
    required this.endLongitude,
     this.distance,
  });
}
