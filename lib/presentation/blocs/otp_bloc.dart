import 'package:com.tara_driver_application/core/storages/get_storages.dart';
import 'package:com.tara_driver_application/core/storages/set_storages.dart';
import 'package:com.tara_driver_application/data/datasources/otp_verify_api.dart';
import 'package:com.tara_driver_application/data/models/otp_model.dart';
import 'package:com.tara_driver_application/data/models/register_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Event
abstract class OTPEvent {}

class VerifyOTPEvent extends OTPEvent {
  final String phoneNumber;
  final String otpCode;

  VerifyOTPEvent({required this.phoneNumber, required this.otpCode});
}

// State

abstract class OTPState {}

class OTPVerifyInitState extends OTPState {}

class OTPVerifyLoadingState extends OTPState {}

class OTPVerifyLoadedState extends OTPState {
  final RegisterModel otpReponseModel;

  OTPVerifyLoadedState({required this.otpReponseModel});
}

// Driver = null && Token = null
class NewDriverState extends OTPState {}

class OTPVerifyFailState extends OTPState {}

// Bloc Provider

class OTPVerifyBloc extends Bloc<OTPEvent, OTPState> {
  OtpVerifyApi api = OtpVerifyApi();

  OTPVerifyBloc() : super(OTPVerifyInitState()) {
    on<VerifyOTPEvent>((event, emit) async {
      try {
        emit(OTPVerifyLoadingState());
        final phoneResponse = await api.verifyOTPApi(
          phoneNumer: event.phoneNumber.toString(),
          otpCode: event.otpCode.toString(),
        );
        if (phoneResponse.status == true || phoneResponse.data != null) {
          if (phoneResponse.data?.driver == null &&
              phoneResponse.data?.token == null) {
            emit(NewDriverState());
          } else if (phoneResponse.data?.driver != null &&
              phoneResponse.data?.token != null) {
            emit(OTPVerifyLoadedState(otpReponseModel: phoneResponse));
            StorageSet.storeDriverData(phoneResponse);
          } else {
            emit(OTPVerifyFailState());
          }
        }
      } catch (e) {
        emit(OTPVerifyFailState());
      }
    });
  }
}
