import 'package:com.tara_driver_application/core/utils/pretty_logger.dart';
import 'package:com.tara_driver_application/core/utils/status_util.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationLocal {
  static final notifications = FlutterLocalNotificationsPlugin();
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'PASSANGER_notification',
    'Tara PASSANGER',
    description: 'Channel for PASSANGER notifications',
    importance: Importance.high,
    sound: RawResourceAndroidNotificationSound('booking_sound'),
  );

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

  static Future<void> notificationBooking(
      {required AndroidNotificationChannel channel,
      required FlutterLocalNotificationsPlugin plugin,
      required String title,
      bool useCustomSound = true,
      String? description}) async {
    // Android Notification Details
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      playSound: true,
      sound: useCustomSound
          ? const RawResourceAndroidNotificationSound('booking_sound')
          : null,
      priority: Priority.high,
      importance: Importance.high,
      showProgress: true,
      icon: "@mipmap/ic_launcher",
      enableLights: true,
      enableVibration: true,
    );

    // iOS Notification Details
    DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      sound: useCustomSound
          ? 'booking_sound.wav'
          : null, // Include the file extension
      presentSound: useCustomSound, // Ensure the sound is played
    );

    // Notification details for both platforms
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // Show the notification
    await plugin.show(
      FcmType.request,
      title,
      description,
      platformChannelSpecifics,
    );
  }
}
