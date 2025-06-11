import 'package:tara_driver_application/core/storages/key_storages.dart';
import 'package:tara_driver_application/core/utils/pretty_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageRemove {
  static Future<void> removePhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageKeys.phoneNumber);
  }
  
  static Future<void> removeDriverData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageKeys.registerData);

    tlog("Remove Driver Pref success");
  }
}
