import 'package:com.tara_driver_application/core/utils/pretty_logger.dart';
import 'package:com.tara_driver_application/data/datasources/confirm_booking_api.dart';
import 'package:com.tara_driver_application/taxi_single_ton/init_socket.dart';
import 'package:com.tara_driver_application/taxi_single_ton/taxi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingApi bookingApi = BookingApi();
  final DriverSocketService driverSocketService = DriverSocketService();
  BookingBloc() : super(BookingInitial()) {
    on<CanceBookingEvent>((event, emit) async {
      try {
        emit(BookingLoading());
        var result = await bookingApi.cancelBookingApi(
          rideId: event.rideId,
        );

        tlog("Cancel Request => $result");
        emit(CancelBookingSuccess());
      } catch (e) {
        emit(CancelBookingFail());
      }
    });
    on<ConfirmBookingEvent>((event, emit) async {
      try {
        emit(BookingLoading());
        await bookingApi.confirmBookingApi(
          rideId: event.rideId,
        );
        driverSocketService.acceptRide(
          bookingCode: event.bookingCode,
          driverId: event.driverId,
          passengerId: event.passengerId,
          currentLat: event.currentLat,
          currentLng: event.currentLng,
          destinationLat: event.destinationLat,
          destinationLng: event.destinationLng,
        );

        tlog(
            "Accept Ride: ${event.bookingCode} , ${event.driverId}, ${event.passengerId}, ${event.currentLat}, ${event.currentLng}, ${event.destinationLat}, ${event.destinationLng}");
        Taxi.shared.notifyAcceptBooking();
        emit(ConfirmBookingSuccess());
      } catch (e) {
        emit(ConfirmBookingFail());
      }
    });

    on<StartTripEvent>((event, emit) async {
      try {
        emit(BookingLoading());
        var result = await bookingApi.startDriverApi(
          rideId: event.rideId,
        );

        tlog("Start Trip => $result");
        emit(StartTripSuccess());
        Taxi.shared.notifyBooking();
      } catch (e) {
        emit(StartTripFail());
      }
    });

    on<CompletedTripEvent>((event, emit) async {
      try {
        emit(BookingLoading());
        double distance = await Taxi.shared.calculateFare(
            startLatitude: Taxi.shared.driverLocation!.latitude!,
            startLongitude: Taxi.shared.driverLocation!.longitude!,
            endLatitude: event.endLatitude,
            endLongitude: event.endLongitude);

        var result = await bookingApi.completeDriveApi(
          rideId: event.rideId,
          endLatitude: event.endLatitude,
          endAddress: event.endAddress,
          endLongitude: event.endLongitude,
          distance: distance,
        );

        tlog("Complete Trip => $result");
        emit(CompletedTripSuccess());
        Taxi.shared.notifyBooking();
      } catch (e) {
        emit(CompletedTripFail());
      }
    });
  }
}
