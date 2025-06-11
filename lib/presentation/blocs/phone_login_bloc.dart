import 'package:tara_driver_application/core/storages/set_storages.dart';
import 'package:tara_driver_application/core/utils/pretty_logger.dart';
import 'package:tara_driver_application/data/datasources/phone_num_remote_data_source.dart';
import 'package:tara_driver_application/data/models/phone_model.dart';
import 'package:tara_driver_application/main.dart';
import 'package:tara_driver_application/presentation/widgets/shake_widget.dart';
import 'package:easy_localization/easy_localization.dart';
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
  final bool? isInvalid;
  final bool? isRequired8DigitError;

  PhoneLoginValidationErrorState({this.isInvalid, this.isRequired8DigitError});
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
        emit(PhoneLoginValidationErrorState(
            isInvalid: true, isRequired8DigitError: false));
      } else if (phoneNumber.length < 11) {
        phoneShake.currentState?.shake();
        emit(PhoneLoginValidationErrorState(
            isInvalid: false, isRequired8DigitError: true));
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
        emit(PhoneLoginLoadedState(phoneNumberModel: phoneResponse));
        StorageSet.setPhoneNumber(event.phoneNumber.toString());
      } catch (e) {
        phoneShake.currentState?.shake();
        emit(PhoneLoginValidationErrorState(isInvalid: true, isRequired8DigitError: false));
        emit(PhoneLoginFailState());
      }
    });
  }
}
