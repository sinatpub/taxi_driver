import 'dart:async';
import 'dart:math';
import 'package:com.tara_driver_application/core/storages/get_storages.dart';
import 'package:com.tara_driver_application/core/storages/set_storages.dart';
import 'package:com.tara_driver_application/core/utils/app_constant.dart';
import 'package:com.tara_driver_application/data/datasources/set_status_api.dart';
import 'package:com.tara_driver_application/data/datasources/update_driver_location_api.dart';
import 'package:com.tara_driver_application/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:com.tara_driver_application/core/helper/local_notification_helper.dart';
import 'package:com.tara_driver_application/core/utils/pretty_logger.dart';
import 'package:com.tara_driver_application/data/models/driver_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
      currentLocation = LatLng(driverLocation!.latitude!, driverLocation!.longitude!);
      driverMarker = Marker(
        markerId: const MarkerId(AppConstant.driverMarker),
        position: currentLocation!,
        infoWindow: const InfoWindow(title: "Driver Location"),
        icon: await loadCustomMarker(imagePath: "assets/marker/car_marker.png",height: 68),
      );
    }

    // tlog(driverLocation.toString());
  }

  setupBackgroundLocationTracking() async {
    await location.enableBackgroundMode(enable: true);
    location.onLocationChanged.listen((locationData) {
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
      driverLocation = locationData;
      
      // notifyBooking();
      _handleLocationChange();
    });
  }

  void _handleLocationChange() {
    //_locationUpdateTimer?.cancel();
    _locationUpdateTimer = Timer(const Duration(seconds: 10), () {
      print("fnasdf");
      if (currentLocation != null) {
        _updateLocationOnServer(currentLocation!);
        notifyBooking();
      }
    });
  }
//  funtion update current location =================
  Future<bool> requestPermissionLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();
    if (!serviceEnabled) {
      return false;
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) { 
        return false;
      }
    }
    print("permission is allowed");
    return true; 
  }

  void updateCurrentLocation() async {
    bool granted = await requestPermissionLocation();
    if(granted == true){
      try { 
        await Geolocator.getCurrentPosition().then((value) {
          print(value.latitude);
           print(value.longitude);
           UpdateDriverLocation().updateDriverLocationApi(
              lat: value.latitude,
              log: value.longitude,
            );
         
        });
      } catch (e) {
        if (e is TimeoutException) {
          print('Location request timed out.');
        } else {
          print('Error fetching location: $e');
        }
      }
    }else{
    }
  }

  // End funtion update current location =================

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

  Future<BitmapDescriptor> loadCustomMarker(
      {required String imagePath, double? width, double? height}) async {
    BitmapDescriptor convertMarkerIcon = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(width ?? 48, height ?? 48)),
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

  List<LatLng> latlng = const [
    LatLng(11.621809, 104.906953),
    LatLng(11.622209, 104.906588),
    LatLng(11.622503, 104.906427),
    LatLng(11.622567, 104.906738),
    LatLng(11.622987, 104.906491),
  ];

  int _currentIndex = 0;
  Timer? _timer;

  void startLooping(void Function(LatLng) onUpdate) {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_currentIndex < latlng.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      onUpdate(latlng[_currentIndex]);
    });
  }

  void connectAndEmitEvent(String url, String eventName, dynamic data) {
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
      tlog('Connected to the socket at $url');

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
