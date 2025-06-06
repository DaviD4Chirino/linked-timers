import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:linked_timers/models/timer.dart';

abstract class NotificationService {
  static final notificationPlugin = FlutterLocalNotificationsPlugin();

  static bool isInitialized = false;

  static AndroidNotificationDetails androidTimerEndedDetails =
      AndroidNotificationDetails(
        "timer-ended",
        "Timer Ended",
        channelDescription: "Alerts when any timer ends it's run",
        importance: Importance.low,
        priority: Priority.low,
      );

  static Future<void> initialize() async {
    if (isInitialized) return;

    final initSettingsAndroid = AndroidInitializationSettings(
      "@mipmap/ic_launcher",
    );

    final initSettings = InitializationSettings(
      android: initSettingsAndroid,
    );

    await notificationPlugin.initialize(initSettings);
    isInitialized = true;
  }

  static Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    NotificationDetails? details,
    String? payload,
  }) async {
    return notificationPlugin.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  static Future<void> showTimerEndedNotification(Timer timer) {
    return notificationPlugin.show(
      timer.id.hashCode,
      "Timeout",
      "${timer.label} finished",
      NotificationDetails(android: androidTimerEndedDetails),
    );
  }
}
