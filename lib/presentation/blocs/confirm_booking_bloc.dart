// Define the states

import 'package:tara_driver_application/core/utils/pretty_logger.dart';
import 'package:tara_driver_application/data/datasources/confirm_booking_api.dart';
import 'package:tara_driver_application/data/models/confirm_booking_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Define the events
abstract class ConfirmBookingEvent {}

class ConfirmPassengerBookingEvent extends ConfirmBookingEvent {
  final int rideId;

  ConfirmPassengerBookingEvent({required this.rideId});
}

// State
abstract class ConfirmBookingState {}

class ConfirmBookingInitial extends ConfirmBookingState {}

class ConfirmBookingLoading extends ConfirmBookingState {}

class ConfirmBookingLoaded extends ConfirmBookingState {
  final ConfirmBookingModel confirmBookingModel;

  ConfirmBookingLoaded(this.confirmBookingModel);
}

class ConfirmError extends ConfirmBookingState {
  final String error;
  ConfirmError(this.error);
}

class ConfirmBookingBloc
    extends Bloc<ConfirmBookingEvent, ConfirmBookingState> {
  final BookingApi confirmBooking = BookingApi();
  ConfirmBookingBloc() : super(ConfirmBookingInitial()) {
    on<ConfirmPassengerBookingEvent>((event, emit) async {
      try {
        emit(ConfirmBookingLoading());
        final confirmData =
            await confirmBooking.confirmBookingApi(rideId: event.rideId);

        emit(ConfirmBookingLoaded(confirmData));
      } catch (e) {
        emit(ConfirmError(e.toString()));
      }
    });
  }
}
