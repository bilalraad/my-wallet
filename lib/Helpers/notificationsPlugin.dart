import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsPlugin {
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationsPlugin() {
    _initailizeNotifications();
  }

  void _initailizeNotifications() {
    const android = AndroidInitializationSettings('app_icon');
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

  Future<void> remindTheUserToOpenTheApp({
    int id,
    String title,
    String description,
  }) async {
     final List<String> lines = <String>[];
    lines.add(description.substring(0,45));
    lines.add(description.substring(45));

    // lines.add(title);

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.High,
      priority: Priority.High,
      style: AndroidNotificationStyle.Inbox,
      playSound: true,
      visibility: NotificationVisibility.Public,
      styleInformation: InboxStyleInformation(lines)

    );
    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
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
