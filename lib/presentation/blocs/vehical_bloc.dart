// Define the states

import 'package:com.tara_driver_application/core/utils/pretty_logger.dart';
import 'package:com.tara_driver_application/data/datasources/get_vehical_remote_data_source.dart';
import 'package:com.tara_driver_application/data/models/vehical_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


// Define the events
abstract class VehicalEvent {}

class GetAllVehicalEvent extends VehicalEvent {}

// State
abstract class VehicalState {}

class CoffeeInitial extends VehicalState {}

class VehicalLoading extends VehicalState {}

class VehicalLoaded extends VehicalState {
  final VehicalTypeEntities vehicalData;

  VehicalLoaded(this.vehicalData);
}

class VehicalError extends VehicalState {
  final String error;

  VehicalError(this.error);
}

class VehicalBloc extends Bloc<VehicalEvent, VehicalState> {
  GetVehicalRemoteDataSource api = GetVehicalRemoteDataSource();

  VehicalBloc(this.api) : super(CoffeeInitial()) {
    on<GetAllVehicalEvent>((event, emit) async {
      try {
        emit(VehicalLoading());
        final vehicalData = await api.getAllVehicalApi();
        emit(VehicalLoaded(vehicalData));

      } catch (e) {
        emit(VehicalError(e.toString()));
      }
    });
  }
}
