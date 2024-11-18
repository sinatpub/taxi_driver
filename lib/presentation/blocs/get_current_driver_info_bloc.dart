// Define the states
import 'package:com.tara_driver_application/core/utils/status_util.dart';
import 'package:com.tara_driver_application/data/datasources/current_driver_info_api.dart';
import 'package:com.tara_driver_application/data/models/current_driver_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Define the events
abstract class CurrentDriverInfoEvent {}

class GetCurrentInfoEvent extends CurrentDriverInfoEvent {
  GetCurrentInfoEvent();
}

// State
abstract class CurrentDriverInfoState {}

class CurrentDriverInfoInit extends CurrentDriverInfoState {}

class CurrentDriverLoading extends CurrentDriverInfoState {}

class CurrentDriverInfoLoaded extends CurrentDriverInfoState {
  final CurrentDriverInfoModel currentDriverInfoModel;

  CurrentDriverInfoLoaded(this.currentDriverInfoModel);
}

class CurrentInfoError extends CurrentDriverInfoState {
  final String error;
  CurrentInfoError(this.error);
}

class CurrentDriverInfoBloc
    extends Bloc<CurrentDriverInfoEvent, CurrentDriverInfoState> {
  GetCurrentDriverInfo getCurrentDriverInfo = GetCurrentDriverInfo();
   bool isLoading = false;
   bool isError = false;
  CurrentDriverInfoBloc() : super(CurrentDriverInfoInit()) {
    on<GetCurrentInfoEvent>((event, emit) async {
      try {
        emit(CurrentDriverLoading());
        isLoading= true;
        final driverData = await getCurrentDriverInfo.getCurrentDriverInfoApi();
        emit(CurrentDriverInfoLoaded(driverData));
        isLoading = false;
      } catch (e) {
        isError=true;
        emit(CurrentInfoError(e.toString()));
      }
    });
  }
}
