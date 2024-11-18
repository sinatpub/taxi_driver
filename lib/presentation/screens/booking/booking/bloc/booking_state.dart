part of 'booking_bloc.dart';

@immutable
sealed class BookingState {}

final class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class ConfirmBookingSuccess extends BookingState {}

class ConfirmBookingFail extends BookingState {}

class CancelBookingSuccess extends BookingState {}

class CancelBookingFail extends BookingState {}
