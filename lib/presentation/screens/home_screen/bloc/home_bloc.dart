
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<GetCurrentLocationEvent>((event, emit) {
      try {
        emit(CurrentLocationLoading());
        
      } catch (e) {
        
      }
    });
  }
}
