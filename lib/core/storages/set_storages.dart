import 'dart:convert';

import 'package:tara_driver_application/core/storages/key_storages.dart';
import 'package:tara_driver_application/core/utils/pretty_logger.dart';
import 'package:tara_driver_application/data/models/register_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageSet {
  static Future<void> setPhoneNumber(String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.phoneNumber, phoneNumber);
    tlog("phone stored in pref $phoneNumber");
  }

  static Future<void> setDriverServicePref(bool isAvailable) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(StorageKeys.driverService, isAvailable);
  }

  static Future<void> saveLocation(double latitude, double longitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', latitude);
    await prefs.setDouble('longitude', longitude);
  }

  // static Future<void> storeOTPData(OtpReponseModel driver) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String driverJson = jsonEncode(driver.toJson());
  //   await prefs.setString(StorageKeys.driverDate, driverJson);
  // }
  static Future<void> storeDriverData(RegisterModel registerModel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String registerJson = jsonEncode(registerModel.toJson());
    await prefs.setString(StorageKeys.registerData, registerJson);
  }
}
