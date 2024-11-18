import 'package:com.tara_driver_application/data/datasources/coffee_remote_data_source.dart';
import 'package:com.tara_driver_application/domain/repositories/coffee_reposity.dart';
import 'package:flutter/foundation.dart';

import '../models/coffee_model.dart';

class CoffeeRepositoryImpl implements CoffeeRepository {
  final CoffeeRemoteDataSource remoteDataSource;

  CoffeeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CoffeeModel>> getAllCoffee() async {
    final coffeeModels = await remoteDataSource.getAllCoffee();

    if (kDebugMode) {
      print('Impl $coffeeModels');
    }

    return coffeeModels.toList();
  }
}
