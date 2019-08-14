import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:newsletter_reader/business/notification/notifier.dart';

class LocalNotifier extends Notifier {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  LocalNotifier() {
    initializeNotifications();
  }

  @override
  Future showSimpleTextNotification(String title, String text) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'DefaultChannelId',
      'Default',
      'All notifications',
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker',
      color: Color.fromARGB(255, 76, 176, 80),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      Random().nextInt(999999),
      title ?? "",
      text ?? "",
      platformChannelSpecifics,
      payload: "",
    );
  }

  void initializeNotifications() {
    _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid = new AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
  }

  // ignore: missing_return
  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) {}

  // ignore: missing_return
  Future onSelectNotification(String payload) {}
}
