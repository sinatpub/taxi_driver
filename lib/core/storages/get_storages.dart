import 'dart:convert';

import 'package:tara_driver_application/core/storages/key_storages.dart';
import 'package:tara_driver_application/core/utils/pretty_logger.dart';
import 'package:tara_driver_application/data/models/otp_model.dart';
import 'package:tara_driver_application/data/models/register_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageGet {
  static Future<String?> getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var phonePreg = prefs.getString(StorageKeys.phoneNumber);
    tlog("get pref phone number $phonePreg");
    return phonePreg;
  }

  static Future<bool?> getDriverServicePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(StorageKeys.driverService);
  }

  static Future<RegisterModel?> getDriverData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? driverJson = prefs.getString(StorageKeys.registerData);
    if (driverJson != null) {
      Map<String, dynamic> driverMap = jsonDecode(driverJson);

      tlog("Get Storage Driver: $driverMap");
      return RegisterModel.fromJson(driverMap);
    }
    return null;
  }

  static Future<LatLng?> getSavedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? latitude = prefs.getDouble('latitude');
    double? longitude = prefs.getDouble('longitude');

    if (latitude != null && longitude != null) {
      return LatLng(latitude, longitude);
    }
    return null;
  }
}
