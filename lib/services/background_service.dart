import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:linked_timers/services/notification_service.dart';
import 'package:workmanager/workmanager.dart';

abstract class BackgroundService {
  @pragma('vm:entry-point')
  static Future<void> showBackgroundNotification() async {
    await NotificationService.showAppRunningNotification();
  }

  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      await showBackgroundNotification();

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
