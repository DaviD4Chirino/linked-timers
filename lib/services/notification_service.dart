import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:linked_timers/models/timer_collection.dart';

abstract class NotificationService {
  static final notificationPlugin = FlutterLocalNotificationsPlugin();

  static bool isInitialized = false;

  static AndroidNotificationDetails androidTimerEndedDetails({
    List<AndroidNotificationAction>? actions,
  }) => AndroidNotificationDetails(
    "timer-ended",
    "Timer Ended",
    channelDescription: "Alerts when any timer ends it's run",
    importance: Importance.low,
    priority: Priority.low,
    actions: actions,
  );
  static AndroidNotificationDetails androidCollectionEndedDetails({
    List<AndroidNotificationAction>? actions,
  }) => AndroidNotificationDetails(
    "collection-ended",
    "Collection Ended",
    channelDescription: "Alerts when any collection ends it's run",
    importance: Importance.high,
    priority: Priority.high,
    actions: actions,
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
      NotificationDetails(android: androidTimerEndedDetails()),
    );
  }

  static Future<void> showCollectionEndedNotification(
    TimerCollection collection, {
    List<AndroidNotificationAction>? actions,
  }) {
    return notificationPlugin.show(
      collection.id.hashCode,
      "Timeout",
      "${collection.label} finished",
      NotificationDetails(
        android: androidCollectionEndedDetails(actions: actions),
      ),
    );
  }
}
