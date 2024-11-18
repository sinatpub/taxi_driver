import 'package:com.tara_driver_application/core/storages/set_storages.dart';
import 'package:com.tara_driver_application/core/utils/pretty_logger.dart';
import 'package:com.tara_driver_application/data/datasources/phone_num_remote_data_source.dart';
import 'package:com.tara_driver_application/data/models/phone_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Event
abstract class PhoneEvent {}

class PhoneNumLoginEvent extends PhoneEvent {
  final String phoneNumber;

  PhoneNumLoginEvent({required this.phoneNumber});
}

// State

abstract class PhoneLoginState {}

class PhoneLoginInitState extends PhoneLoginState {}

class PhoneLoginLoadingState extends PhoneLoginState {}

class PhoneLoginLoadedState extends PhoneLoginState {
  final PhoneNumberModel phoneNumberModel;

  PhoneLoginLoadedState({required this.phoneNumberModel});
}

class PhoneLoginFailState extends PhoneLoginState {}

// Bloc Provider

class PhoneLoginBloc extends Bloc<PhoneEvent, PhoneLoginState> {
  PhoneNumerRemoteDataSource api = PhoneNumerRemoteDataSource();

  PhoneLoginBloc() : super(PhoneLoginInitState()) {
    on<PhoneNumLoginEvent>((event, emit) async {
      try {
        emit(PhoneLoginLoadingState());
        final phoneResponse = await api.postPhoneNumberApi(
            phoneNumer: event.phoneNumber.toString());

        emit(PhoneLoginLoadedState(phoneNumberModel: phoneResponse));

        // store phone number into local pref
        StorageSet.setPhoneNumber(event.phoneNumber.toString());
      } catch (e) {
        emit(PhoneLoginFailState());
      }
    });
  }
}
