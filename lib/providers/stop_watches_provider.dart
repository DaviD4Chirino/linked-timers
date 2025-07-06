import 'package:linked_timers/models/timer_collection.dart';
import 'package:linked_timers/providers/timer_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

part "stop_watches_provider.g.dart";

@Riverpod(keepAlive: true)
class StopWatchesProvider extends _$StopWatchesProvider {
  // Store the previous list of timerCollection ids and their stopwatches
  List<Map<String, List<StopWatchTimer>>> _previous = [];

  List<StopWatchTimer> buildStopWatches(
    List<TimerCollection> collections,
  ) {
    List<StopWatchTimer> list = [];

    for (var collection in collections) {
      for (var timer in collection.timers) {}
    }

    return list;
  }

  @override
  List<Map<String, List<StopWatchTimer>>> build() {
    final timerCollections = ref.watch(timerDatabaseProvider);

    // Build the new list
    final newList =
        timerCollections.map((timerCollection) {
          return {
            timerCollection.id:
                timerCollection.timers
                    .map((timer) => timer.toStopWatchTimer())
                    .toList(),
          };
        }).toList();

    // Collect all ids from previous and current
    final previousIds =
        _previous.map((e) => e.keys.first).toSet();
    final currentIds = newList.map((e) => e.keys.first).toSet();

    // Find removed ids
    final removedIds = previousIds.difference(currentIds);

    // Dispose stopwatches for removed collections
    for (final map in _previous) {
      final id = map.keys.first;
      if (removedIds.contains(id)) {
        for (final sw in map[id]!) {
          sw.dispose();
        }
      }
    }

    // Update previous
    _previous = newList;

    return newList;
  }

  void dispose() {
    for (final map in _previous) {
      for (final sw in map.values.expand((list) => list)) {
        sw.dispose();
      }
    }
  }
}
