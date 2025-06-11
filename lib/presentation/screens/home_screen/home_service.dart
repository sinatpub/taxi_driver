import 'package:tara_driver_application/core/utils/pretty_logger.dart';
import 'package:tara_driver_application/core/utils/status_util.dart';
import 'package:tara_driver_application/data/models/current_driver_info_model.dart';

class HomeServe {
  initailHomeServe(context) async {
    await _checkLocationPermission(context);
 
  }

  // 1. Checking Request Permission Loaction
  Future<void> _checkLocationPermission(context) async { 
    // await Taxi.shared.requestLocationPermission(context);
  }

  // 2. Get Current Driver Info (checking status of driver)
  Future<CurrentDriverInfoModel?>? checkingCurrentDriverStatus(context,
      {CurrentDriverInfoModel? data}) async {
    try {
      // // FcmType.riding = 3;
      if (data?.data?.status == FcmType.riding) {
        tlog("message");
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => const BookingScreen()));
      } else {
        tlog("Driver available for booking");
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  // 3. Init Socket
  initSocket() async {
    tlog("Init socket");
    await Future.delayed(const Duration(seconds: 5));
  }

  // 4. Update Location Driver
  updateLocationDriver() async {
    tlog("Update Location driver");
    await Future.delayed(const Duration(seconds: 5));
  }

  // 5. Drawing Marker Driver

  generateMarker() async {
    tlog("Generate Marker");
  }
}
