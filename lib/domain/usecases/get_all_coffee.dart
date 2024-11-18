import 'package:com.tara_driver_application/data/models/coffee_model.dart';
import 'package:com.tara_driver_application/domain/repositories/coffee_reposity.dart';

class GetAllCoffee {
  final CoffeeRepository repository;

  GetAllCoffee(this.repository);

  Future<List<CoffeeModel>> execute() async {
    return await repository.getAllCoffee();
  }
}
