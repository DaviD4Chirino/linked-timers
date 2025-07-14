// I might as well track the isInfinite bool here
import 'package:flutter/foundation.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:uuid/uuid.dart';

class TimerCollection {
  TimerCollection({
    required this.timers,
    required this.label,
    this.laps = 1,
    this.isInfinite = false,
    this.alert = true,
  }) /*  : globalStopWatch = StopWatchTimer(
         mode: StopWatchMode.countDown,
         presetMillisecond: timers
             .map((e) => e.timeAsMilliseconds)
             .reduce((a, b) => a + b),
       ) */;

  List<Timer> timers = [];
  int laps = 5;
  bool isInfinite = false;

  /// A flag that starts an alert when this collection ends
  bool alert = true;

  /// The title works as its id
  String label;
  String id = Uuid().v4();

  late StopWatchTimer globalStopWatch = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: timers
        .map((e) => e.timeAsMilliseconds)
        .reduce((a, b) => a + b),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerCollection &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          listEquals(timers, other.timers);

  @override
  int get hashCode => id.hashCode;

  TimerCollection copyWith({
    List<Timer>? timers,
    int? laps,
    bool? isInfinite,
    bool? alert,
    String? label,
  }) {
    return TimerCollection(
      timers:
          (timers ?? this.timers)
              .map((t) => t.copyWith())
              .toList(), // deep copy
      laps: laps ?? this.laps,
      isInfinite: isInfinite ?? this.isInfinite,
      label: label ?? this.label,
      alert: alert ?? this.alert,
    );
  }

  void removeTimer(String timerId) {
    var timerIndex = timers.indexWhere((t) => t.id == timerId);
    if (timerIndex == -1) return;
    var removedTimer = timers.removeAt(timerIndex);
    removedTimer.dispose();
  }

  Future<void> dispose() async {
    for (var timer in timers) {
      timer.dispose();
    }
    globalStopWatch.dispose();
  }

  Map<String, dynamic> toMap() => {
    "timers": timers.map((e) => e.toMap()).toList(),
    "laps": laps,
    "isInfinite": isInfinite,
    "alert": alert,
    "label": label,
    "id": id,
  };
  factory TimerCollection.fromMap(Map<String, dynamic> map) =>
      TimerCollection(
        timers:
            (map["timers"] as List)
                .map((e) => Timer.fromMap(e))
                .toList(),
        laps: map["laps"],
        isInfinite: map["isInfinite"],
        alert: map["alert"] ?? false,
        label: map["label"],
      )..id = map["id"];
}
