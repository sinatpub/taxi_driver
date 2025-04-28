import 'dart:async';
import 'dart:math';
import 'package:com.tara_driver_application/core/storages/get_storages.dart';
import 'package:com.tara_driver_application/core/storages/set_storages.dart';
import 'package:com.tara_driver_application/core/utils/app_constant.dart';
import 'package:com.tara_driver_application/data/datasources/set_status_api.dart';
import 'package:com.tara_driver_application/data/models/register_model.dart';
import 'package:com.tara_driver_application/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location/location.dart';
import 'package:com.tara_driver_application/core/helper/local_notification_helper.dart';
import 'package:com.tara_driver_application/core/utils/pretty_logger.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geoLocator;
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
    // await requestLocationPermission();
    // await setupBackgroundLocationTracking();
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
        icon: await loadCustomMarker(
            imagePath: "assets/marker/car_marker.png", height: 68),
      );
    }
  }

  setupBackgroundLocationTracking() async {
    await location.enableBackgroundMode(enable: true);
    location.onLocationChanged.listen((locationData) {
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
      driverLocation = locationData;
      _handleLocationChange();
    });
  }

  void _handleLocationChange() {
    _locationUpdateTimer = Timer(const Duration(seconds: 10), () {
      if (currentLocation != null) {
        _updateLocationOnServer(currentLocation!);
        // notifyBooking();
      }
    });
  }

// //  funtion update current location =================
//   Future<bool> requestPermissionLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (!serviceEnabled) {
//       return false;
//     }
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return false;
//       }
//     }
//     return true;
//   }

//   Future<Position?> checkCurrentLocation() async {
//     Position? locationCurrent;
//     bool granted = await requestPermissionLocation();
//     if (granted == true) {
//       try {
//         await Geolocator.getCurrentPosition().then((value) {
//           locationCurrent = value;
//         });
//         return locationCurrent!;
//       } catch (e) {
//         if (e is TimeoutException) {
//           tlog('Location request timed out.');
//         } else {
//           tlog('Error fetching location: $e');
//         }
//         return locationCurrent!;
//       }
//     } else {
//       return locationCurrent!;
//     }
//   }

  void updateDriverLocation() async {
    // await requestPermissionLocation();
    // await Geolocator.getCurrentPosition().then(
    //   (value) {
    //     UpdateDriverLocation().updateDriverLocationApi(
    //       lat: value.latitude,
    //       log: value.longitude,
    //     );
    //   },
    // );
  }

  // End funtion update current location =================

  Future<void> _updateLocationOnServer(LatLng location) async {
    try {
      // await UpdateDriverLocation().updateDriverLocationApi(
      //   lat: location.latitude,
      //   log: location.longitude,
      // );
      // tlog('Location updated on server', level: LogLevel.info);
    } catch (error) {
      tlog('Error updating location on server: $error', level: LogLevel.error);
    }
  }

  double calculateDistance(
      double latStart, double lonStart, double latEnd, double lonEnd) {
    const R = 6371.01; // Radius of Earth in km
    final dLat = deg2rad(latEnd - latStart), dLon = deg2rad(lonEnd - lonStart);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(deg2rad(latStart)) *
            cos(deg2rad(latEnd)) *
            sin(dLon / 2) *
            sin(dLon / 2);
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
    try {
      var response = await statusApi.getStatusDriver();
      if (response.data != null) {
        isDriverActive = response.data?.isAvailable == 1;
        await StorageSet.setDriverServicePref(isDriverActive);
      } else {
        isDriverActive = false;
      }
    } catch (e) {
      tlog("Driver Status: $e");
    }
  }

  Future<void> toggleDriverAvailable({bool isAvailable = true}) async {
    await statusApi.toggleStatusDriver(status: isAvailable == true ? 1 : 0);
    checkDriverAvailability();
  }

// * Init Local Notification
  initLocationNotification() async {
    // Initialize the plugin for both iOS and Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tlog("Init Local Notification");
  }

  Future<void> notifyBooking(
      {required String title, String? description, bool? isSound}) async {
    try {
      await NotificationLocal.notificationBooking(
          channel: NotificationLocal.channel,
          plugin: NotificationLocal.notifications,
          title: title,
          useCustomSound: isSound == null ? false : true,
          description: description);
      tlog('Notification triggered', level: LogLevel.debug);
    } catch (e) {
      tlog('Error triggering notification: $e', level: LogLevel.error);
    }
  }

  // * Total Distance
  double totalDistance = 0.0;

  // Last known position
  geoLocator.Position? lastPosition;

  // * Simulate Tracking Distance
  void simulateTrackingDistance() {
    getRealTimePassengerLocation()
        .listen((geoLocator.Position currentLocation) async {
      if (lastPosition != null) {
        // Calculate the distance between last and current positions
        double distance = await trackDistance(lastPosition, currentLocation);
        if (distance > 0) {
          totalDistance += distance;
        }

        Logger().e('Distance for this update: $distance meters');
        Logger().e('Total Distance: ${totalDistance / 1000} km');
      }

      lastPosition = currentLocation;
    });
  }

  // * Update Real time Location in Google Map
  Stream<geoLocator.Position> getRealTimePassengerLocation() {
    return geoLocator.Geolocator.getPositionStream(
        locationSettings: const geoLocator.LocationSettings(
      accuracy: geoLocator.LocationAccuracy.high,
      distanceFilter: 10,
    ));
  }

  // * Function to Track Distance
  Future<double> trackDistance(geoLocator.Position? lastPosition,
      geoLocator.Position currentPosition) async {
    if (lastPosition != null) {
      // Calculate the distance between last and current positions
      return geoLocator.Geolocator.distanceBetween(
        lastPosition.latitude,
        lastPosition.longitude,
        currentPosition.latitude,
        currentPosition.longitude,
      );
    }
    return 0.0; // Return 0 if lastPosition is null
  }

  Future<BitmapDescriptor> loadCustomMarker(
      {required String imagePath, double? width, double? height}) async {
    BitmapDescriptor convertMarkerIcon = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(width ?? 48, height ?? 48)),
      imagePath,
    );
    return convertMarkerIcon;
  }

  void connectAndEmitEvent({required String eventName, dynamic data}) {
    // Create the socket instance and connect to the server
    IO.Socket socket = IO.io(
      AppConstant.socketBasedUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    // Handle socket connection
    socket.onConnect((_) {
      tlog('Connected to the socket at ${AppConstant.socketBasedUrl}');

      // Emit the event once connected
      socket.emit(eventName, data);
      tlog('Emitted event $eventName with data: $data');
    });

    // Handle connection error
    socket.onConnectError((err) {
      tlog('Connection Error: $err');
    });

    // Handle socket disconnect
    socket.onDisconnect((_) {
      tlog('Socket disconnected');
    });
  }
}
