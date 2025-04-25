import 'package:com.tara_driver_application/core/storages/set_storages.dart';
import 'package:com.tara_driver_application/core/utils/pretty_logger.dart';
import 'package:com.tara_driver_application/data/datasources/phone_num_remote_data_source.dart';
import 'package:com.tara_driver_application/data/models/phone_model.dart';
import 'package:com.tara_driver_application/presentation/widgets/shake_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

// Event
abstract class PhoneEvent {}

class PhoneNumLoginEvent extends PhoneEvent {
  final String phoneNumber;

  PhoneNumLoginEvent({required this.phoneNumber});
}

class PhoneNumValidateEvent extends PhoneEvent {
  final String phoneNumber;

  PhoneNumValidateEvent({required this.phoneNumber});
}

// State

abstract class PhoneLoginState {}

class PhoneLoginInitState extends PhoneLoginState {}

class PhoneLoginLoadingState extends PhoneLoginState {}

class PhoneLoginLoadedState extends PhoneLoginState {
  final PhoneNumberModel phoneNumberModel;

  PhoneLoginLoadedState({required this.phoneNumberModel});
}

class PhoneLoginValidationErrorState extends PhoneLoginState {
  final String errorMessage;

  PhoneLoginValidationErrorState(this.errorMessage);
}

class PhoneLoginFailState extends PhoneLoginState {}

// Bloc Provider

class PhoneLoginBloc extends Bloc<PhoneEvent, PhoneLoginState> {
  PhoneNumerRemoteDataSource api = PhoneNumerRemoteDataSource();
  final phoneShake = GlobalKey<ShakeWidgetState>();

  PhoneLoginBloc() : super(PhoneLoginInitState()) {
    // phone validation
    on<PhoneNumValidateEvent>((event, emit) async {
      var phoneNumber = event.phoneNumber;
      Logger().e(phoneNumber.length);
      if (phoneNumber.isEmpty) {
        phoneShake.currentState?.shake();
        emit(PhoneLoginValidationErrorState("Please check your phone number"));
      } else if (phoneNumber.length < 11) {
        phoneShake.currentState?.shake();
        emit(
            PhoneLoginValidationErrorState("Phone number must be 8 digits up"));
      } else {
        emit(PhoneLoginInitState());
      }
    });
    // phone submit => otp
    on<PhoneNumLoginEvent>((event, emit) async {
      try {
        add(PhoneNumValidateEvent(phoneNumber: event.phoneNumber));

        await Future.delayed(Duration
            .zero); // noted: it will throw after event add above not return this
        if (state is PhoneLoginValidationErrorState) {
          return;
        }
        emit(PhoneLoginLoadingState());

        final phoneResponse = await api.postPhoneNumberApi(
            phoneNumer: event.phoneNumber.toString());

        Logger().e("phoneResponse: $phoneResponse");
        emit(PhoneLoginLoadedState(phoneNumberModel: phoneResponse));

        // store phone number into local pref
        StorageSet.setPhoneNumber(event.phoneNumber.toString());
      } catch (e) {
        phoneShake.currentState?.shake();
        emit(PhoneLoginValidationErrorState("Please check your phone number"));
        emit(PhoneLoginFailState());
      }
    });
  }
}
