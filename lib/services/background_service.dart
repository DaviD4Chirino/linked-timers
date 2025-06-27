import 'package:linked_timers/models/timer_collection.dart';
import 'package:linked_timers/services/notification_service.dart';

abstract class BackgroundService {
  @pragma('vm:entry-point')
  static void debug() {
    NotificationService.showCollectionStartedNotification(
      TimerCollection(timers: [], label: "new"),
    );
  }
}
