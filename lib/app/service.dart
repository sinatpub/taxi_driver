import 'package:com.tara_driver_application/taxi_single_ton/taxi.dart';
import 'package:com.tara_driver_application/taxi_single_ton/taxi_location.dart';

initialService() {
  // * register notification
  Taxi.shared.initLocationNotification();
  // * register taxi locaiton
  // * 1. generate marker, 2. check permission location
  TaxiLocation.shared.onInit();
}
