import 'dart:convert';
import 'dart:math';

import 'package:linked_timers/models/abstracts/local_storage.dart';
import 'package:linked_timers/models/abstracts/local_storage_routes.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:linked_timers/models/timer_collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timer_database.g.dart';

@Riverpod(keepAlive: true)
class TimerDatabase extends _$TimerDatabase {
  void setCollection(TimerCollection newCollection) {
    List<TimerCollection> list = [...state];
    int index = list.indexWhere(
      (element) => element.id == newCollection.id,
    );
    list[index] = newCollection;
    state = list;
  }

  void addCollection(TimerCollection newCollection) {
    state = [newCollection, ...state];
  }

  /// Returns whether or it it suceded to edit the timer
  bool editTimer({
    required String collectionId,
    required String timerId,
    required Timer newTimer,
  }) {
    final list = [...state];
    final collectionIndex = list.indexWhere(
      (c) => c.id == collectionId,
    );
    if (collectionIndex == -1) return false; // Collection not found

    final collection = list[collectionIndex];

    final timers = [...collection.timers];
    final timerIndex = timers.indexWhere((t) => t.id == timerId);
    if (timerIndex == -1) return false; // Timer not found

    timers[timerIndex] = newTimer;

    final updatedCollection = collection.copyWith(timers: timers);
    list[collectionIndex] = updatedCollection;
    state = list;
    return true;
  }

  bool editCollection(
    String collectionId,
    TimerCollection newCollection,
  ) {
    final list = [...state];
    final index = list.indexWhere((c) => c.id == collectionId);
    if (index == -1) return false; // Collection not found

    list[index] = newCollection;
    state = list;

    return true;
  }

  void deleteCollection(String collectionId) {
    state = state.where((c) => c.id != collectionId).toList();
  }

  TimerCollection? getCollection(String collectionId) {
    final collectionIndex = state.indexWhere(
      (c) => c.id == collectionId,
    );
    if (collectionIndex == -1) return null;
    return state[collectionIndex];
  }

  void fetchDatabase() async {
    List<String>? existingDatabase = await LocalStorage.getStringList(
      LocalStorageRoutes.database,
    );
    if (existingDatabase == null) {
      return;
    }
    state =
        existingDatabase
            .map(
              (e) => TimerCollection.fromMap(JsonCodec().decode(e)),
            )
            .toList();
  }

  void saveDatabase() {
    LocalStorage.setStringList(
      LocalStorageRoutes.database,
      state.map((e) => JsonCodec().encode(e.toMap())).toList(),
    );
  }

  @override
  List<TimerCollection> build() {
    return generateListDebug();
  }

  List<TimerCollection> generateListDebug() => List.generate(15, (i) {
    return TimerCollection(
      label: "Timer collection Nro: ${i + 1}",
      timers: List.generate(
        Random().nextInt(10) + 1,
        (j) => Timer(label: "Timer Nro: ${j + 1}", seconds: 2),
      ),
      laps: 2,
    );
  });
}
