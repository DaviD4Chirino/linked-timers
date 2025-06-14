// I might as well track the isInfinite bool here
import 'package:flutter/foundation.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:uuid/uuid.dart';

class TimerCollection {
  TimerCollection({
    required this.timers,
    required this.label,
    this.laps = 1,
    this.isInfinite = false,
    this.alert = false,
  });

  List<Timer> timers = [];
  int laps = 5;
  bool isInfinite = false;

  /// A flag that starts an alert when this collection ends
  bool alert = false;

  /// The title works as its id
  String label;
  String id = Uuid().v4();

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
    );
  }

  void removeTimer(Timer timer) {
    timers = timers.where((timer_) => timer_ != timer).toList();
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
