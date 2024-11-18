// import 'dart:async';
// import 'dart:math';
// import 'package:com.tara_driver_application/core/storages/get_storages.dart';
// import 'package:com.tara_driver_application/core/storages/set_storages.dart';
// import 'package:com.tara_driver_application/data/datasources/set_status_api.dart';
// import 'package:com.tara_driver_application/data/datasources/update_driver_location_api.dart';
// import 'package:com.tara_driver_application/main.dart';
// import 'package:com.tara_driver_application/taxi_single_ton/init_socket.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:location/location.dart';
// import 'package:com.tara_driver_application/core/helper/local_notification_helper.dart';
// import 'package:com.tara_driver_application/core/utils/pretty_logger.dart';
// import 'package:com.tara_driver_application/data/models/driver_model.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class Taxi {
//   Taxi._internal();
//   static Taxi? _singleton = Taxi._internal();

//   static Taxi get shared {
//     _singleton ??= Taxi._internal();
//     return _singleton!;
//   }

//   // Channel
//   static const MethodChannel openSettingchannel =
//       MethodChannel('com.com.tara_driver_application/settings');

//   SetDriverStatusApi statusApi = SetDriverStatusApi();
//   Driver? driver;
//   PermissionStatus locationPermissionStatus = PermissionStatus.granted;
//   Location location = Location();

//   DriverSocketService socketController = DriverSocketService();

//   LatLng? currentLocation; // Store the current location

//   LocationData? driverLocation;

//   LatLng? passengerLocation;

//   Timer? _locationUpdateTimer;
//   // Google Map Properties
//   double maxAccuracy = 1000;
//   double maxSpeed = 40;
//   double maxBestAccuracy = 80;

//   // Marker
//   Marker? driverMaker;
//   Marker? passengerMaker;

//   // Driver Status
//   int? driverStatus;
//   int? driverId;

//   bool isDriverActive = true;

//   // Here is place for assign value to driver ID, After assigned we can use in anywhere
//   checkDriverData() async {
//     var data = await StorageGet.getDriverData();
//     driverId = data?.data?.driver?.id;
//   }

//   void requestIOSPermissions(
//       FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//   }

//   Future<void> showNotification(
//       {required String driverId, required String bookingCode}) async {
//     String channelId =
//         'driver_channel_$driverId'; // Unique channel ID for each driver
//     String channelName =
//         'Notifications for $bookingCode'; // User-friendly channel name

//     AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       channelId,
//       channelName,
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: false,
//     );

//     NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//     );

//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'Passenger Booking: $bookingCode',
//       'This is a test notification $driverId',
//       platformChannelSpecifics,
//     );
//   }

//   Future<void> getCurrentLocation(BuildContext context) async {
//     final location = Location();
//     bool serviceEnabled;
//     PermissionStatus permissionGranted;

//     serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         return;
//       }
//     }

//     permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         _showPermissionDeniedDialog(context);
//         return;
//       }
//     }

//     driverLocation = await location.getLocation();
//   }

//   // Function for requesting location permission and getting the current location
//   Future<void> requestLocationPermission(BuildContext context) async {
//     bool serviceEnabled;
//     PermissionStatus permissionGranted;

//     // Check if location services are enabled
//     serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         return; // If services are not enabled, stop here
//       }
//     }

//     // Check the current permission status
//     permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         // If permission is still denied, show the dialog to open settings
//         _showPermissionDeniedDialog(context);
//         return;
//       }
//     }

//     if (permissionGranted == PermissionStatus.granted) {
//       tlog('Location permission granted');
//       checkDriverData();
//       await getCurrentLocationAndCreateMarker();
//     }
//   }

//   // Function to show an alert dialog if permission is denied
//   void _showPermissionDeniedDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Location Permission Required'),
//           content: const Text(
//             'Location permission is required to use this feature. Please enable it in your app settings.',
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//             ),
//             TextButton(
//               child: const Text('Open Settings'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 // Open settings manually
//                 openAppSettings();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Set up background location tracking
//   void setupBackgroundChange() async {
//     // Enable background mode
//     await location.enableBackgroundMode(enable: true);
//     location.onLocationChanged.listen((LocationData locationData) {
//       currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
//       // _handleLocationChange();
//     });
//   }

//   void _handleLocationChange() {
//     if (_locationUpdateTimer != null && _locationUpdateTimer!.isActive) return;
//     _locationUpdateTimer = Timer(const Duration(seconds: 30), () {
//       if (currentLocation != null) {
//         _updateLocationOnServer(currentLocation!);
//         notifyBooking();
//       }
//     });
//   }

//   // Update location on server
//   Future<void> _updateLocationOnServer(LatLng currentLocation) async {
//     try {
//       await UpdateDriverLocation().updateDriverLocationApi(
//         lat: currentLocation.latitude,
//         log: currentLocation.longitude,
//       );
//       tlog('Location successfully updated on server', level: LogLevel.info);
//     } catch (error) {
//       tlog('Error updating location on server: $error', level: LogLevel.error);
//     }
//   }

//   // Calculate Distance
//   double calculateDistance(lat1, lon1, lat2, lon2) {
//     var R = 6371.01; // Radius of the earth in km
//     var dLat = deg2rad(lat2 - lat1); // deg2rad below
//     var dLon = deg2rad(lon2 - lon1);
//     var a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
//     var c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return R * c * 1000.0;
//   }

//   double deg2rad(double deg) {
//     return (deg * pi / 180.0);
//   }

//   double rad2deg(double rad) {
//     return (rad * 180.0 / pi);
//   }

//   // Function to open app settings
//   static Future<void> openAppSettings() async {
//     try {
//       await openSettingchannel.invokeMethod('openAppSettings');
//     } on PlatformException catch (e) {
//       tlog("Failed to open app settings: '${e.message}'.");
//     }
//   }

//   /// Notification
//   void notifyBooking() async {
//     try {
//       await NotificationLocal.notificationBooking(
//         channel: NotificationLocal.channel,
//         plugin: NotificationLocal.notifications,
//       );
//       tlog('Notification triggered successfully.', level: LogLevel.debug);
//     } catch (e) {
//       tlog('Error triggering notification: $e', level: LogLevel.error);
//     }
//   }

//   // Accept Notiication
//   void notifyAcceptBooking() async {
//     try {
//       await NotificationLocal.notificationBooking(
//         channel: NotificationLocal.channel,
//         plugin: NotificationLocal.notifications,
//       );
//       tlog('Notification triggered successfully.', level: LogLevel.debug);
//     } catch (e) {
//       tlog('Error triggering notification: $e', level: LogLevel.error);
//     }
//   }

//   // Check Driver availability on app open
//   Future<void> checkDriverAvailability() async {
//     bool? storedAvailability = await StorageGet.getDriverServicePref();
//     if (storedAvailability == null) {
//       var response = await statusApi.getStatusDriver();
//       bool isAvailable = response.data?.isAvailable == 1;
//       await StorageSet.setDriverServicePref(isAvailable);
//       Taxi.shared.isDriverActive = isAvailable;
//     } else {
//       Taxi.shared.isDriverActive = storedAvailability;
//     }

//   }

//   // Turn On/Off Service
//   Future toggleService() async {
//     await statusApi.toggleStatusDriver(status: 1);
//   }

//   Future<void> getCurrentLocationAndCreateMarker() async {
//     driverLocation = await location.getLocation();
//     if (driverLocation != null) {
//       currentLocation =
//           LatLng(driverLocation!.latitude!, driverLocation!.longitude!);

//       // Create and set the driver marker
//       driverMaker = Marker(
//         markerId: const MarkerId('driverMarker'),
//         position: currentLocation!,
//         infoWindow: const InfoWindow(title: "Driver Location"),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
//       );
//     }
//   }

//   Future<void> getPassengerMarker() async {
//     passengerMaker = Marker(
//       markerId: const MarkerId("passengerMarker"),
//       position:
//           LatLng(passengerLocation!.latitude!, passengerLocation!.longitude!),
//       infoWindow: const InfoWindow(title: "Passenger Location"),
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
//     );
//   }

//   // Future<void> drawPolyline ({double? startLat,double? startLng, double? desLat, double? desLng})async{
//   //       PolylineResult result = await PolylinePoints.getRouteBetweenCoordinates(
//   //     googleApiKey: AppConstant.googleKeyApi,
//   //     request: PolylineRequest(
//   //       origin: PointLatLng(startLat, startLng),
//   //       destination: PointLatLng(desLat, desLng),
//   //       mode: TravelMode.driving,
//   //     ),
//   //   );

//   // }
// }

// List<LatLng> latLngList = [
//   const LatLng(12.9715987, 77.594566),
//   // LatLng(12.2958104, 76.6393805),
//   // LatLng(13.0826802, 80.2707184),
//   // Add more LatLng points as needed
// ];

import 'dart:async';
import 'dart:math';
import 'package:com.tara_driver_application/core/storages/get_storages.dart';
import 'package:com.tara_driver_application/core/storages/set_storages.dart';
import 'package:com.tara_driver_application/core/utils/app_constant.dart';
import 'package:com.tara_driver_application/data/datasources/set_status_api.dart';
import 'package:com.tara_driver_application/data/datasources/update_driver_location_api.dart';
import 'package:com.tara_driver_application/main.dart';
import 'package:com.tara_driver_application/taxi_single_ton/init_socket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:com.tara_driver_application/core/helper/local_notification_helper.dart';
import 'package:com.tara_driver_application/core/utils/pretty_logger.dart';
import 'package:com.tara_driver_application/data/models/driver_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Taxi {
  Taxi._internal();
  static Taxi? _singleton = Taxi._internal();

  static Taxi get shared {
    _singleton ??= Taxi._internal();
    return _singleton!;
  }

  // Channels and APIs
  static const MethodChannel settingsChannel =
      MethodChannel('com.com.tara_driver_application/settings');
  final SetDriverStatusApi statusApi = SetDriverStatusApi();
  final DriverSocketService socketController = DriverSocketService();

  // Properties
  Driver? driver;
  Location location = Location();
  PermissionStatus locationPermissionStatus = PermissionStatus.granted;
  LocationData? driverLocation;
  LatLng? currentLocation;
  LatLng? passengerLocation;

  Timer? _locationUpdateTimer;
  bool isDriverActive = true;
  int? driverStatus;
  int? driverId;
  double maxAccuracy = 1000, maxSpeed = 40, maxBestAccuracy = 80;

  // Markers
  Marker? driverMarker;
  Marker? passengerMarker;

  Future<void> init() async {
    await checkDriverData();
    await requestLocationPermission();
    await setupBackgroundLocationTracking();
    await checkDriverAvailability();
  }

  Future<void> checkDriverData() async {
    var data = await StorageGet.getDriverData();
    driverId = data?.data?.driver?.id;
  }

  Future<void> requestLocationPermission([BuildContext? context]) async {
    if (await location.serviceEnabled() || await location.requestService()) {
      locationPermissionStatus = await location.requestPermission();
      if (locationPermissionStatus == PermissionStatus.granted) {
        tlog('Location permission granted');
        await getCurrentLocationAndCreateMarker();
      } else if (context != null) {
        _showPermissionDeniedDialog(context);
      }
    }
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content:
            const Text('Please enable location permission in app settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> getCurrentLocationAndCreateMarker() async {
    driverLocation = await location.getLocation();
    if (driverLocation != null) {
      currentLocation =
          LatLng(driverLocation!.latitude!, driverLocation!.longitude!);
      driverMarker = Marker(
        markerId: const MarkerId(AppConstant.driverMarker),
        position: currentLocation!,
        infoWindow: const InfoWindow(title: "Driver Location"),
        icon: await loadCustomMarker(imagePath: "assets/marker/car_marker.png"),
      );
    }

    // tlog(driverLocation.toString());
  }

  Future<void> setupBackgroundLocationTracking() async {
    await location.enableBackgroundMode(enable: true);
    location.onLocationChanged.listen((locationData) {
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);

      tlog("messagessss $currentLocation");

    
      // notifyBooking();
      _handleLocationChange();
    });
  }

  void _handleLocationChange() {
    _locationUpdateTimer?.cancel();
    _locationUpdateTimer = Timer(const Duration(seconds: 30), () {
      if (currentLocation != null) {
        _updateLocationOnServer(currentLocation!);
        notifyBooking();
      }
    });
  }

  Future<void> _updateLocationOnServer(LatLng location) async {
    try {
      await UpdateDriverLocation().updateDriverLocationApi(
        lat: location.latitude,
        log: location.longitude,
      );
      tlog('Location updated on server', level: LogLevel.info);
    } catch (error) {
      tlog('Error updating location on server: $error', level: LogLevel.error);
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.01; // Radius of Earth in km
    final dLat = deg2rad(lat2 - lat1), dLon = deg2rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    return R * 2 * atan2(sqrt(a), sqrt(1 - a)) * 1000.0; // Return in meters
  }

  double deg2rad(double deg) => deg * pi / 180.0;

  static Future<void> openAppSettings() async {
    try {
      await settingsChannel.invokeMethod('openAppSettings');
    } on PlatformException catch (e) {
      tlog("Failed to open app settings: '${e.message}'.");
    }
  }

  Future<void> checkDriverAvailability() async {
    bool? storedAvailability = await StorageGet.getDriverServicePref();
    if (storedAvailability == null) {
      var response = await statusApi.getStatusDriver();
      isDriverActive = response.data?.isAvailable == 1;
      await StorageSet.setDriverServicePref(isDriverActive);
    } else {
      isDriverActive = storedAvailability;
    }
  }

  Future<void> toggleService() async =>
      await statusApi.toggleStatusDriver(status: 1);

  Future<void> notifyBooking() async {
    try {
      await NotificationLocal.notificationBooking(
        channel: NotificationLocal.channel,
        plugin: NotificationLocal.notifications,
      );
      tlog('Notification triggered', level: LogLevel.debug);
    } catch (e) {
      tlog('Error triggering notification: $e', level: LogLevel.error);
    }
  }

  void requestIOSPermissions(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  //   // Accept Notiication
  void notifyAcceptBooking() async {
    try {
      await NotificationLocal.notificationBooking(
        channel: NotificationLocal.channel,
        plugin: NotificationLocal.notifications,
      );
      tlog('Notification triggered successfully.', level: LogLevel.debug);
    } catch (e) {
      tlog('Error triggering notification: $e', level: LogLevel.error);
    }
  }

  Future<void> showNotification(
      {required String driverId, required String bookingCode}) async {
    String channelId =
        'driver_channel_$driverId'; // Unique channel ID for each driver
    String channelName =
        'Notifications for $bookingCode'; // User-friendly channel name

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Passenger Booking: $bookingCode',
      'This is a test notification $driverId',
      platformChannelSpecifics,
    );
  }

  Future<BitmapDescriptor> loadCustomMarker({required String imagePath}) async {
    BitmapDescriptor convertMarkerIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      imagePath,
    );
    return convertMarkerIcon;
  }

  Future<double> calculateFare({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) async {
    // Define fare rules
    const double costPerKm = 2500.0;
    const double minimumDistanceInKm = 1.0;

    try {
      // Calculate distance between start and end locations in meters
      double distanceInMeters = Geolocator.distanceBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );

      // Convert distance to kilometers
      double distanceInKm = distanceInMeters / 1000;

      // Ensure minimum distance of 1 kilometer
      if (distanceInKm < minimumDistanceInKm) {
        distanceInKm = minimumDistanceInKm;
      }

      // Calculate the fare based on the distance
      double fare = distanceInKm * costPerKm;

      tlog("Calculate Fare: $fare ៛");
      return fare;
    } catch (e) {
      print("Error calculating fare: $e");
      return 0.0; // Return 0 in case of error
    }
  }
}
