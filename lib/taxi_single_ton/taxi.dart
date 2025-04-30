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
    });
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

  Future<void> notifyBooking(
      {required String title, String? description, bool isSound = true}) async {
    try {
      await NotificationLocal.notificationBooking(
          channel: NotificationLocal.channel,
          plugin: NotificationLocal.notifications,
          title: title,
          useCustomSound: isSound,
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
