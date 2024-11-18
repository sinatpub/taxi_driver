import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/coffee_model.dart';
import 'dart:convert';

class CoffeeRemoteDataSource {
  final http.Client client;

  CoffeeRemoteDataSource(this.client);

  Future<List<CoffeeModel>> getAllCoffee() async {
    final response =
        await client.get(Uri.parse('https://api.sampleapis.com/coffee/hot'));

    if (kDebugMode) {
      print(response);
    }

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      final List<CoffeeModel> coffeeList =
          jsonList.map((json) => CoffeeModel.fromJson(json)).toList();
      return coffeeList;
    } else {
      throw Exception('Failed to load coffee');
    }
  }
}
