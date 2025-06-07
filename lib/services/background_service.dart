import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:linked_timers/models/timer_collection.dart';
import 'package:linked_timers/services/notification_service.dart';

abstract class BackgroundService {
  @pragma('vm:entry-point')
  static void debug() {
    print("debug");
    final DateTime now = DateTime.now();
    final int isolateId = Isolate.current.hashCode;
    NotificationService.showCollectionStartedNotification(
      TimerCollection(timers: [], label: "new"),
    );
    if (kDebugMode) {
      print(
        "[$now] Hello, world! isolate=$isolateId function='$debug'",
      );
    }
  }
}
