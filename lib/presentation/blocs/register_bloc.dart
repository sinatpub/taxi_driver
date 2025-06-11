import 'dart:io';
import 'package:tara_driver_application/core/helper/get_device_info.dart';
import 'package:tara_driver_application/core/storages/get_storages.dart';
import 'package:tara_driver_application/core/storages/set_storages.dart';
import 'package:tara_driver_application/data/datasources/register_remote_data_source.dart';
import 'package:tara_driver_application/data/models/register_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Event
abstract class RegisterEvent {}

class DriverRegisterEvent extends RegisterEvent {
  final String fullname;
  String? phoneNumber;
  final String vehicalId;
  final String vehicalColor;
  final String deviceToken;
  final String plateNumber;
  final File cardImage;
  final File profileImage;
  final File driverLicenseImage;

  DriverRegisterEvent({
    required this.fullname,
    this.phoneNumber,
    required this.vehicalId,
    required this.vehicalColor,
    required this.deviceToken,
    required this.plateNumber,
    required this.cardImage,
    required this.profileImage,
    required this.driverLicenseImage,
  });
}

// State
abstract class RegisterState {}

class DriverRegisterInitail extends RegisterState {}

class DriverRegisterLoading extends RegisterState {}

class DriverRegisterLoaded extends RegisterState {
  final RegisterModel registerModel;

  DriverRegisterLoaded({required this.registerModel});
}

class DriverRegisterFail extends RegisterState {}

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRegisterRemoteDataSource registerApi =
      UserRegisterRemoteDataSource();
  final DeviceInfoHelper deviceInfo = DeviceInfoHelper();
  RegisterBloc() : super(DriverRegisterInitail()) {
    on<DriverRegisterEvent>((event, emit) async {
      try {
        emit(DriverRegisterLoading());
        var platformInfo = await deviceInfo.getDeviceInfo();
        var phonePref = await StorageGet.getPhoneNumber();
        var response = await registerApi.driverRegister(
            fullName: event.fullname,
            phoneNumber: "$phonePref",
            vehicalId: event.vehicalId,
            plateNumber: event.plateNumber,
            vehicalColor: event.vehicalColor,
            deviceToken: event.deviceToken,
            platform: platformInfo['model'],
            cardImage: event.cardImage,
            profileImage: event.profileImage,
            driverLicenseImage: event.driverLicenseImage);
        emit(DriverRegisterLoaded(registerModel: response));
        StorageSet.storeDriverData(response);
      } catch (e) {
        emit(DriverRegisterFail());
      }
    });
  }
}
