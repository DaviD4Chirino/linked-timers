import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:linked_timers/services/notification_service.dart';
import 'package:workmanager/workmanager.dart';

abstract class BackgroundService {
  @pragma('vm:entry-point')
  static Future<void> showCollectionRunningNotification(
    String label,
  ) async {
    await NotificationService.showNotification(
      id: 6969,
      title: "$label is Running in the background",
      body: "$label is Running in the background",
      details: NotificationDetails(
        android: NotificationService.androidAppRunningDetails(),
      ),
    );
  }

  @pragma('vm:entry-point')
  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      /* final label = inputData?['collectionLabel'] ?? "A Collection";
      await showCollectionRunningNotification(label); */
      return Future.value(true);
    });
  }

  static void initialize() {
    Workmanager().initialize(
      callbackDispatcher, // The top-level function
      isInDebugMode: kDebugMode, // Set to false in production
    );
  }
}
