import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:tara_driver_application/core/utils/pretty_logger.dart';

class DeviceInfoHelper {
  Future<Map<String, dynamic>> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = {};

    try {
      if (Platform.isAndroid) {
        // Android device info
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceData = {
          'device': 'Android',
          'model': androidInfo.model,
          'brand': androidInfo.brand,
          'androidVersion': androidInfo.version.release,
          'sdkVersion': androidInfo.version.sdkInt,
          'manufacturer': androidInfo.manufacturer,
          'deviceId': androidInfo.id,
        };
      } else if (Platform.isIOS) {
        // iOS device info
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceData = {
          'device': 'iOS',
          'model': iosInfo.utsname.machine,
          'systemVersion': iosInfo.systemVersion,
          'name': iosInfo.name,
          'identifierForVendor': iosInfo.identifierForVendor,
        };
      }
    } catch (e) {
      tlog("Error getting device info: $e",level: LogLevel.error);
    }

    return deviceData;
  }
}
