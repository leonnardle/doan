import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void initLocalnotification(BuildContext context,RemoteMessage message) async {
    var androidinitlization = const AndroidInitializationSettings(
        '@mipmap/ic_launcher');
    var initializationSetings = InitializationSettings(
        android: androidinitlization
    );
    await _flutterLocalNotificationsPlugin.initialize(
        initializationSetings,
        onDidReceiveNotificationResponse: (payload) {

        }
    );
  }

  void FirebaseInit() {
    FirebaseMessaging.onMessage.listen((event) {
      if (kDebugMode) {
        print(event.notification!.title.toString());
        print(event.notification!.body.toString());
      }
      showNotification(event);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(), 'thong bao quan trong'
        , importance: Importance.max);

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
        channelDescription: 'dat lich hen',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        ticker: 'ticker'
    );
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails
    );
    Future.delayed(Duration.zero,
    () {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }
  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('nguoi dung da cap quyen ');
    } else if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('nguoi dung da tam cap quyen ');
    }
    else {
      print('nguoi dung da tu choi cap quyen ');
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefesh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print('refesh');
    });
  }
}