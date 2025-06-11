import 'package:tara_driver_application/data/datasources/set_status_api.dart';
import 'package:tara_driver_application/data/models/set_status_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SetDriverStatusApi driverStatusApi = SetDriverStatusApi();
  bool isOnline = true;

  HomeBloc() : super(HomeInitial()) {
    // Check driver status
    on<CheckDriverStatusEvent>(_checkDriverStatus);
    on<ToggleOnOffDriverEvent>(_toggleDriverService);

    on<GetCurrentLocationEvent>((event, emit) {
      try {
        emit(CurrentLocationLoading());
      } catch (e) {}
    });
  }
  // private function for each event

  _checkDriverStatus(CheckDriverStatusEvent event, Emitter emit) async {
    try {
      emit(CheckDriverStatusLoadingState());

      SetDriverStatusModel result = await driverStatusApi.getStatusDriver();

      if (result.data != null) {
        isOnline = result.data?.isAvailable == 1;
        emit(CheckDriverStatusLoadedState(
            isDriverOnline: result.data?.isAvailable ?? 0));
      } else {
        emit(CheckRequestInfoErrorState());
      }
    } catch (e) {
      emit(CheckRequestInfoErrorState());
    }
  }

  _toggleDriverService(ToggleOnOffDriverEvent event, Emitter emit) async {
    try {
      emit(CheckDriverStatusLoadingState());
      EasyLoading.show();
      isOnline = event.isTurnOn == 1;
      var result =
          await driverStatusApi.toggleStatusDriver(status: event.isTurnOn);

      emit(ToggleDriverService(isTurnon: result.data?.isAvailable ?? 0));
      Future.delayed(const Duration(milliseconds: 100), () {
        EasyLoading.dismiss();
      });
    } catch (e) {
      Logger().e("Exception e: $e");
    }
  }
}
