import 'package:com.tara_driver_application/core/utils/pretty_logger.dart';
import 'package:com.tara_driver_application/data/datasources/confirm_booking_api.dart';
import 'package:com.tara_driver_application/data/models/complete_driver_model.dart';
import 'package:com.tara_driver_application/data/models/confirm_booking_model.dart';
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
        var dataResporn = await bookingApi.confirmBookingApi(rideId: event.rideId,);
        tlog("Accept Ride: ${event.rideId}");
        Taxi.shared.notifyAcceptBooking();
        emit(ConfirmBookingSuccess(confirmBookingModel: dataResporn));
      } catch (e) {
        emit(ConfirmBookingFail());
      }
    });

    on<ArrivedPassengerEvent>((event, emit) async {
      try {
        emit(BookingLoading());
        var result = await bookingApi.startDriverApi(
          rideId: event.rideId,
        );
        driverSocketService.arrivedSocket();

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
        // double distance = await Taxi.shared.calculateFare(
        //     startLatitude: Taxi.shared.driverLocation!.latitude!,
        //     startLongitude: Taxi.shared.driverLocation!.longitude!,
        //     endLatitude: event.endLatitude,
        //     endLongitude: event.endLongitude);

        CompleteDriverModel result = await bookingApi.completeDriveApi(
          rideId: event.rideId,
          endLatitude: event.endLatitude,
          endAddress: event.endAddress,
          endLongitude: event.endLongitude,
          distance: 10,
        );

        tlog("Complete Trip => $result");
        emit(CompletedTripSuccess(completeDriver: result));
        Taxi.shared.notifyBooking();
      } catch (e) {
        tlog("Complete Trip => $e");
        emit(CompletedTripFail());
      }
    });
  }
}
