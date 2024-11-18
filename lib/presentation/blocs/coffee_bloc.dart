import 'package:com.tara_driver_application/data/models/coffee_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_all_coffee.dart';

// Define the events
abstract class CoffeeEvent {}

class GetAllCoffeeEvent extends CoffeeEvent {}

// Define the states
abstract class CoffeeState {}

class CoffeeInitial extends CoffeeState {}

class CoffeeLoading extends CoffeeState {}

class CoffeeLoaded extends CoffeeState {
  final List<CoffeeModel> coffees;

  CoffeeLoaded(this.coffees);
}

class CoffeeError extends CoffeeState {
  final String error;

  CoffeeError(this.error);
}

class CoffeeBloc extends Bloc<CoffeeEvent, CoffeeState> {
  final GetAllCoffee getAllCoffee;
  CoffeeBloc(this.getAllCoffee) : super(CoffeeInitial()) {
    on<CoffeeEvent>((event, emit) async {
      try {
        emit(CoffeeLoading());
        final coffees = await getAllCoffee.execute();
        emit(CoffeeLoaded(coffees));
      } catch (e) {
        emit(CoffeeError(e.toString()));
      }
    });
  }
}
