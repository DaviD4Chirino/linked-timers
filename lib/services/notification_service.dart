import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:linked_timers/models/timer_collection.dart';

abstract class NotificationService {
  static final notificationPlugin = FlutterLocalNotificationsPlugin();

  static bool isInitialized = false;

  static AndroidNotificationDetails
  androidCollectionRunningDetails() => AndroidNotificationDetails(
    "linked-timers-bg-service",
    "Linked Timers running in the background",
    channelDescription:
        "Shows when a collection is running in the background",
    importance: Importance.min,
    priority: Priority.min,
  );

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
  static AndroidNotificationDetails androidAppRunningDetails() =>
      AndroidNotificationDetails(
        "linked-timers-bg-service",
        "Linked Timers running in the background",
        channelDescription:
            "Shows when the app is running in the background",
        importance: Importance.min,
        priority: Priority.min,
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

  static AndroidNotificationDetails androidCollectionStartedDetails({
    List<AndroidNotificationAction>? actions,
  }) => AndroidNotificationDetails(
    "collection-started",
    "Collection Started",
    channelDescription: "Alerts when any collection start it's run",
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

  static Future<void> showAppRunningNotification() {
    return notificationPlugin.show(
      6969,
      "Linked Timers is Running in the background",
      "Linked Timers is Running in the background",
      NotificationDetails(android: androidAppRunningDetails()),
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

  static Future<void> showCollectionStartedNotification(
    TimerCollection collection, {
    List<AndroidNotificationAction>? actions,
  }) {
    return notificationPlugin.show(
      collection.id.hashCode,
      "Start!",
      "${collection.label} started",
      NotificationDetails(
        android: androidCollectionStartedDetails(actions: actions),
      ),
    );
  }
}
