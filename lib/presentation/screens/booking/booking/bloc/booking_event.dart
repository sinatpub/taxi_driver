part of 'booking_bloc.dart';

@immutable
sealed class BookingEvent {}

class ConfirmBookingEvent extends BookingEvent {
  final int rideId;
  // Param for Accept Ride Socket

  final String driverId;
  final String bookingCode;
  final String passengerId;
  final double currentLat;
  final double currentLng;
  double? destinationLat;
  double? destinationLng;

  ConfirmBookingEvent(
      {required this.rideId,
      required this.driverId,
      required this.bookingCode,
      required this.passengerId,
      required this.currentLat,
      required this.currentLng,
      this.destinationLat,
      this.destinationLng});
}

class CanceBookingEvent extends BookingEvent {
  final int rideId;

  CanceBookingEvent({required this.rideId});
}

class StartTripEvent extends BookingEvent {
  final int rideId;

  StartTripEvent({required this.rideId});
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
