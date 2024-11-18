import 'package:com.tara_driver_application/data/models/coffee_model.dart';

abstract class CoffeeRepository {
  Future<List<CoffeeModel>> getAllCoffee();
}
