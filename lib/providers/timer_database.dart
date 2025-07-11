import 'dart:convert';
import 'dart:math';

import 'package:linked_timers/models/abstracts/local_storage.dart';
import 'package:linked_timers/models/abstracts/local_storage_routes.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:linked_timers/models/timer_collection.dart';
import 'package:linked_timers/providers/stop_watches_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timer_database.g.dart';

@Riverpod(keepAlive: true)
class TimerDatabase extends _$TimerDatabase {
  final jsonCodec = JsonCodec();

  void setCollection(TimerCollection newCollection) {
    final stopWatchesNotifier = ref.read(
      stopWatchesNotifierProvider.notifier,
    );
    List<TimerCollection> list = [...state];
    int index = list.indexWhere(
      (element) => element.id == newCollection.id,
    );
    list[index] = newCollection;
    state = list;
    stopWatchesNotifier.addStopWatches(newCollection);
    saveDatabase();
  }

  void addCollection(TimerCollection newCollection) {
    var stopWatchesNotifier = ref.read(
      stopWatchesNotifierProvider.notifier,
    );

    state = [newCollection, ...state];
    stopWatchesNotifier.addStopWatches(newCollection);
    saveDatabase();
  }

  /// Returns whether or it it suceded to edit the timer
  /// Also it updates StopWatchesProvider
  bool editTimer({
    required String collectionId,
    required String timerId,
    required Timer newTimer,
  }) {
    final list = [...state];
    final collectionIndex = list.indexWhere(
      (c) => c.id == collectionId,
    );
    if (collectionIndex == -1) {
      return false; // Collection not found
    }

    final collection = list[collectionIndex];

    final timers = [...collection.timers];
    final timerIndex = timers.indexWhere((t) => t.id == timerId);
    if (timerIndex == -1) return false; // Timer not found

    timers[timerIndex] = newTimer;

    final stopWatchesNotifier = ref.read(
      stopWatchesNotifierProvider.notifier,
    );

    final updatedCollection = collection.copyWith(
      timers: timers,
    );
    list[collectionIndex] = updatedCollection;
    state = list;

    stopWatchesNotifier.modifyStopWatches(updatedCollection);

    saveDatabase();

    return true;
  }

  bool editCollection(
    String collectionId,
    TimerCollection newCollection,
  ) {
    final list = [...state];
    final index = list.indexWhere((c) => c.id == collectionId);
    if (index == -1) return false; // Collection not found

    final stopWatchesNotifier = ref.read(
      stopWatchesNotifierProvider.notifier,
    );

    list[index] = newCollection;
    state = list;
    saveDatabase();
    stopWatchesNotifier.addStopWatches(newCollection);
    return true;
  }

  void deleteCollection(String collectionId) {
    final stopWatchesNotifier = ref.read(
      stopWatchesNotifierProvider.notifier,
    );
    state = state.where((c) => c.id != collectionId).toList();
    saveDatabase();

    stopWatchesNotifier.deleteStopWatches(collectionId);
  }

  TimerCollection? getCollection(String collectionId) {
    final collectionIndex = state.indexWhere(
      (c) => c.id == collectionId,
    );
    if (collectionIndex == -1) return null;
    return state[collectionIndex];
  }

  Future<void> fetchDatabase() async {
    List<String>? existingDatabase =
        await LocalStorage.getStringList(
          LocalStorageRoutes.database,
        );
    if (existingDatabase == null) {
      return;
    }
    state =
        existingDatabase.map((e) {
          return TimerCollection.fromMap(jsonCodec.decode(e));
        }).toList();
  }

  void saveDatabase() {
    LocalStorage.setStringList(
      LocalStorageRoutes.database,
      state.map((e) => jsonCodec.encode(e.toMap())).toList(),
    );
  }

  /// Deletes all timers, permanently
  void flushDatabase() {
    state = [];
    saveDatabase();
  }

  @override
  List<TimerCollection> build() {
    return [];
  }

  List<TimerCollection> generateListDebug() => List.generate(
    15,
    (i) {
      return TimerCollection(
        label: "Timer collection Nro: ${i + 1}",
        timers: List.generate(
          Random().nextInt(10) + 1,
          (j) => Timer(label: "Timer Nro: ${j + 1}", seconds: 2),
        ),
        laps: 2,
      );
    },
  );
}
