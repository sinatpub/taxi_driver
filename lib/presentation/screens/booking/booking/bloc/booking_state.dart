part of 'booking_bloc.dart';

@immutable
sealed class BookingState {}

final class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class ConfirmBookingSuccess extends BookingState {
  final ConfirmBookingModel confirmBookingModel;
  ConfirmBookingSuccess({required this.confirmBookingModel});
}

class ConfirmBookingFail extends BookingState {}

class CancelBookingSuccess extends BookingState {}

class CancelBookingFail extends BookingState {}

// Start Trip

class StartTripSuccess extends BookingState {}

class StartTripFail extends BookingState {}

// Complete Trip
class CompletedTripSuccess extends BookingState{
  final CompleteDriverModel completeDriver;
  CompletedTripSuccess({required this.completeDriver});
}
class CompletedTripFail extends BookingState{}