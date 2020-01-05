import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsPlugin {
  var _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationsPlugin() {
    _initailizeNotifications();
  }

  void _initailizeNotifications() {
    final android = AndroidInitializationSettings('app_icon');
    final iOS = IOSInitializationSettings(onDidReceiveLocalNotification: (
      id,
      title,
      descripsion,
      payload,
    ) async {
      await onSelectNotification(payload);
    });
    final initializationSettings = InitializationSettings(
      android,
      iOS,
    );
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
  }

  Future onSelectNotification(String payload) async {}

  Future<void> showWhenTransAddedInBackrownd({
    int id,
    String title,
    String description,
  }) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.Max,
      priority: Priority.High,
      style: AndroidNotificationStyle.Inbox,
      ongoing: true,
      playSound: true,
      visibility: NotificationVisibility.Public,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      description,
      platformChannelSpecifics,
    );
  }
}
