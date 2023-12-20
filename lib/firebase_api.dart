import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Khởi tạo đối tượng FlutterLocalNotificationsPlugin
  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> showNotification(String title, String body) async {
    if (title != null && body != null) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
      await _flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        platformChannelSpecifics,
        payload: 'item x',
      );
    }
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print('title: ${message.notification?.title}');
    print('body: ${message.notification?.body}');
    print('Payload: ${message.data}');

    // Hiển thị thông báo khi nhận được message từ Firebase
    await showNotification(
      message.notification?.title ?? 'Notification',
      message.notification?.body ?? 'You have a new notification',
    );
  }

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final FCMToken = await _firebaseMessaging.getToken();
    print('token: $FCMToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
