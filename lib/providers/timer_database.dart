import 'dart:math';

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
    print(state.length);
  }

  @override
  List<TimerCollection> build() {
    return List.generate(100, (i) {
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
}
