import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:com.tara_driver_application/core/utils/status_util.dart';
import 'package:com.tara_driver_application/taxi_single_ton/taxi.dart';

class NotificationLocal {
  static final notifications = FlutterLocalNotificationsPlugin();
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'driver_notification',
    'Tara Driver',
    description: 'Channel for driver notifications',
    importance: Importance.high,
    sound: RawResourceAndroidNotificationSound('booking_sound'), 
  );

  static Future<void> initLocalNotification(
      {required FlutterLocalNotificationsPlugin plugin}) async {
    const android = AndroidInitializationSettings("@mipmap/ic_launcher");
    const iOS = DarwinInitializationSettings();
    const InitializationSettings initializationsSettings =
        InitializationSettings(android: android, iOS: iOS);
    bool? initialized = await plugin.initialize(initializationsSettings);
    print(
        "Notification initialized: $initialized"); // Check if initialization is successful
  }

  final androidPlatformChannelSpecifics = AndroidNotificationDetails(
    channel.id,
    channel.name,
    channelDescription: channel.description,
    playSound: true,
    sound: const RawResourceAndroidNotificationSound(
        'booking_sound'), // no .wav extension here
    priority: Priority.high,
    importance: Importance.high,
  );

  static Future<void> notificationBooking(
      {required AndroidNotificationChannel channel,
      required FlutterLocalNotificationsPlugin plugin}) async {
    // Android Notification Details
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound(
          'booking_sound'), // 'booking_sound' refers to the .wav file in res/raw
      priority: Priority.high,
      importance: Importance.high,
      showProgress: true,
      icon: "@mipmap/ic_launcher",
      enableLights: true,
      enableVibration: true,
    );

    // iOS Notification Details
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
            sound: 'booking_sound.wav', // Path from assets/sounds
            presentSound: true);

    // Notification details for both platforms
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    // Show the notification
    await plugin.show(
        FcmType.request,
        "${tr('request_title')} ${Taxi.shared.driver?.name} ",
        tr('request_desc'),
        platformChannelSpecifics);
  }
}
