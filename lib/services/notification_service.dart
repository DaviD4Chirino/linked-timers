import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:linked_timers/models/timer_collection.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

enum NotificationIds {
  linkedTimersBgService,
  timerEnded,
  collectionEnded,
}

abstract class NotificationService {
  static final notificationPlugin =
      FlutterLocalNotificationsPlugin();

  static bool isInitialized = false;

  static collectionInProgressDetails({
    /// In seconds
    int progress = 0,

    /// In seconds
    int maxProgress = 100,

    bool isRunning = false,
  }) {
    return AndroidNotificationDetails(
      "collection-in-progress",
      "Collection In Progress",
      channelDescription:
          "Alerts when any collection start it's currently running",
      importance: Importance.high,
      priority: Priority.high,
      playSound: false,
      enableVibration: true,
      showProgress: true,
      progress: progress,
      maxProgress: maxProgress,
      onlyAlertOnce: true,
      icon: isRunning
          ? "@drawable/ic_stat_icon_play"
          : "@drawable/ic_stat_icon_paused",
      // icon: "@drawable/ic_collection_play_icon",
    );
  }

  static collectionPausedDetails() {
    return AndroidNotificationDetails(
      "collection-paused",
      "Collection Paused",
      channelDescription:
          "Alerts when any collection has paused it's run",
      importance: Importance.low,
      priority: Priority.low,
      playSound: false,
      enableVibration: false,
      icon: "@drawable/ic_stat_icon_paused",
    );
  }

  static collectionEndedDetails() {
    return AndroidNotificationDetails(
      "collection-ended",
      "Collection Ended",
      channelDescription:
          "Alerts when any collection has ended it's run",
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      onlyAlertOnce: true,
      // icon: "@drawable/ic_icon_stop",
    );
  }

  static AndroidNotificationDetails androidTimerEndedDetails({
    String collectionId = "collection-id",
    List<AndroidNotificationAction>? actions,
  }) => AndroidNotificationDetails(
    "timer-ended",
    "Timer Ended",
    channelDescription: "Alerts when any timer ends it's run",
    importance: Importance.high,
    priority: Priority.high,
    actions: actions,
    groupKey: collectionId,
  );

  static var androidAppRunningDetails =
      FlutterBackgroundAndroidConfig(
        notificationTitle: "Linked Timers",
        notificationText:
            "Linked Timers is running in the background",
        shouldRequestBatteryOptimizationsOff: true,
        notificationImportance:
            AndroidNotificationImportance.normal,
        notificationIcon: AndroidResource(
          name: 'ic_stat_notification',
          defType: 'drawable',
        ), // Default is ic_launcher from folder mipmap
      );

  static AndroidNotificationDetails
  androidCollectionEndedDetails({
    List<AndroidNotificationAction>? actions,
  }) => AndroidNotificationDetails(
    "collection-ended",
    "Collection Ended",
    channelDescription:
        "Alerts when any collection ends it's run",
    importance: Importance.high,
    priority: Priority.high,
    actions: actions,
    playSound: true,
  );

  static Future<void> initialize() async {
    if (isInitialized) return;

    final initSettingsAndroid = AndroidInitializationSettings(
      "@drawable/ic_stat_notification",
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

  static Future<void> cancelCollectionNotification(
    TimerCollection collection,
  ) {
    return notificationPlugin.cancel(collection.id.hashCode);
  }

  static Future<void> collectionInProgressNotification(
    TimerCollection collection, {

    /// In seconds
    int progress = 0,
    List<AndroidNotificationAction>? actions,
  }) {
    String remainingTime = StopWatchTimer.getDisplayTime(
      progress * 1000,
      milliSecond: false,
    );
    bool isRunning = collection.globalStopWatch.isRunning;

    return notificationPlugin.show(
      collection.id.hashCode,
      "${collection.label} is ${isRunning ? "running" : "paused"}",
      "$remainingTime left",
      NotificationDetails(
        android: collectionInProgressDetails(
          progress: progress,
          maxProgress:
              collection.globalStopWatch.initialPresetTime ~/
              1000,
          isRunning: isRunning,
        ),
      ),
    );
  }

  static Future<void> collectionPausedNotification(
    TimerCollection collection,
  ) {
    return notificationPlugin.show(
      collection.id.hashCode,
      "${collection.label} paused",
      "",
      NotificationDetails(android: collectionPausedDetails()),
    );
  }

  static Future<void> showCollectionEndedNotification(
    TimerCollection collection, {
    List<AndroidNotificationAction>? actions,
  }) {
    return notificationPlugin.show(
      collection.id.hashCode,
      "${collection.label} finished",
      "",
      NotificationDetails(
        android: androidCollectionEndedDetails(actions: actions),
      ),
    );
  }

  static Future<void> showTimerEndedNotification(
    Timer timer,
    String collectionId,
  ) {
    return notificationPlugin.show(
      "$collectionId-timer".hashCode,
      "${timer.label} ended",
      "",
      NotificationDetails(
        android: androidTimerEndedDetails(
          collectionId: collectionId,
        ),
      ),
    );
  }

  static cancelTimerNotification(String collectionId) {
    return notificationPlugin.cancel(
      "$collectionId-timer".hashCode,
    );
  }
}
