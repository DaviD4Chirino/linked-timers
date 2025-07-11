import 'package:linked_timers/models/timer.dart';
import 'package:linked_timers/models/timer_collection.dart';
import 'package:linked_timers/providers/timer_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

part "stop_watches_notifier.g.dart";

@Riverpod(keepAlive: true)
/// Despite being a keep a live, a manual dispose could be beneficial
class StopWatchesNotifier extends _$StopWatchesNotifier {
  @override
  Map<String, List<StopWatchTimer>> build() {
    final timerCollections = ref.watch(timerDatabaseProvider);

    return buildStopWatches(timerCollections);
  }

  List<StopWatchTimer> convertToStopWatches(List<Timer> timers) {
    return timers
        .map((timer) => timer.toStopWatchTimer())
        .toList();
  }

  Map<String, List<StopWatchTimer>> buildStopWatches(
    List<TimerCollection> timerCollections,
  ) {
    final map = Map<String, List<StopWatchTimer>>.fromEntries(
      timerCollections.map((collection) {
        return MapEntry(
          collection.id,
          convertToStopWatches(collection.timers),
        );
      }),
    );
    return map;
  }

  List<StopWatchTimer>? deleteStopWatches(String id) {
    List<StopWatchTimer>? element = state.remove(id);
    state = state;
    return element;
  }

  void addStopWatches(TimerCollection collection) {
    state[collection.id] = convertToStopWatches(
      collection.timers,
    );
    state = state;
  }

  /// The same as addStopWatches, but it doesn't delete the old StopWatchTimers
  void modifyStopWatches(TimerCollection collection) {
    addStopWatches(collection);
  }
}
