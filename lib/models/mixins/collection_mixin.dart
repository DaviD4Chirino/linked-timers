import 'package:linked_timers/models/timer.dart';
import 'package:linked_timers/models/timer_collection.dart';

mixin CollectionMixin {
  void removeTimer(TimerCollection collection, Timer timer) {
    collection.timers =
        collection.timers
            .where((timer_) => timer_ != timer)
            .toList();
  }
}
