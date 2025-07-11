import 'package:linked_timers/models/count_down_timer.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:linked_timers/models/timer_collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

part "stop_watches_notifier.g.dart";

@Riverpod(keepAlive: true)
class StopWatchesNotifier extends _$StopWatchesNotifier {
  @override
  Map<String, List<CountDownTimer>> build() {
    return {};
  }

  List<CountDownTimer> convertToCountDownTimer(
    List<Timer> timers,
  ) {
    return timers.map((timer) {
      for (var collection in state.values) {
        for (var stopWatch in collection) {
          if (stopWatch.id == timer.id) {
            return stopWatch;
          }
        }
      }
      return timer.toCountDownTimer();
    }).toList();
  }

  Map<String, List<CountDownTimer>> buildStopWatches(
    List<TimerCollection> timerCollections,
  ) {
    final map = Map<String, List<CountDownTimer>>.fromEntries(
      timerCollections.map((collection) {
        return MapEntry(
          collection.id,
          convertToCountDownTimer(collection.timers),
        );
      }),
    );
    return map;
  }

  void deleteStopWatches(String id) {
    List<StopWatchTimer>? element = state.remove(id);
    element?.forEach((timer) => timer.dispose());
    state = state;
  }

  void addStopWatches(TimerCollection collection) {
    state[collection.id] = convertToCountDownTimer(
      collection.timers,
    );
    state = state;
  }

  void modifyStopWatches(TimerCollection collection) {
    state[collection.id] = convertToCountDownTimer(
      collection.timers,
    );
    state = state;
  }

  void disposeStopWatches(List<StopWatchTimer> stopWatches) {
    for (var timer in stopWatches) {
      timer.dispose();
    }
  }
}
