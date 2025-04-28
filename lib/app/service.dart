import 'package:com.tara_driver_application/core/helper/local_notification_helper.dart';
import 'package:com.tara_driver_application/taxi_single_ton/taxi_location.dart';

initialService() {
  // * register notification in local_notification_helper.dart
  NotificationLocal().initLocationNotification();
  // * register taxi locaiton
  // * 1. generate marker, 2. check permission location
  TaxiLocation.shared.onInit();
}
