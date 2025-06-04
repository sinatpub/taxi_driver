import 'dart:convert';

import 'package:com.tara_driver_application/core/utils/app_constant.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

class AsyncDistance {
  /// calculate distance
  Future<double> calculateDistance(LatLng driver, LatLng destination) async {
    final url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${driver.latitude},${driver.longitude}&destination=${destination.latitude},${destination.longitude}&mode=driving&key=${AppConstant.googleKeyApi}";

    final response = await get(Uri.parse(url));
    final data = jsonDecode(response.body);

    if (data["status"] == "OK") {
      var distance = data["routes"][0]["legs"][0]["distance"]["value"];
      var duration = data["routes"][0]["legs"][0]["duration"]["value"];
      Logger().d("Driving Distance: ${convertDistanceToKM(distance)}");
      Logger().d("Estimated Time: ${convertSecondsToHoursMinutes(duration)}");
      return convertDistanceToKM(distance);
    } else {
      Logger().d("Error fetching distance: ${data['status']}");
      return convertDistanceToKM(0000);
    }
  }

  double convertDistanceToKM(int meters) {
    double kilometers = meters / 1000;
    return kilometers;
  }

  String convertSecondsToHoursMinutes(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;

    return '${hours}h ${minutes}m';
  }
}
