import 'package:com.tara_driver_application/core/utils/pretty_logger.dart';
import 'package:com.tara_driver_application/data/datasources/confirm_booking_api.dart';
import 'package:com.tara_driver_application/taxi_single_ton/init_socket.dart';
import 'package:com.tara_driver_application/taxi_single_ton/taxi.dart';
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
        var result = await bookingApi.confirmBookingApi(
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

        // var result = await bookingApi.confirmBookingApi(
        //         rideId: event.rideId,
        //       );

        emit(ConfirmBookingSuccess());
        Taxi.shared.notifyAcceptBooking();
      } catch (e) {
        emit(ConfirmBookingFail());
      }
    });
  }
}
