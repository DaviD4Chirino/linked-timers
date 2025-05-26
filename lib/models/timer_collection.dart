// I might as well track the isInfinite bool here
import 'package:linked_timers/models/timer.dart';

class TimerCollection {
  TimerCollection({
    required this.timers,
    required this.label,
    this.laps = 1,
    this.isInfinite = false,
  });

  List<Timer> timers = [];
  int laps = 5;
  bool isInfinite = false;

  /// The title works as its id
  String label;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TimerCollection) return false;
    return label == other.label;
  }

  @override
  int get hashCode => label.hashCode;

  TimerCollection copyWith({
    List<Timer>? timers,
    int? laps,
    bool? isInfinite,
    String? title,
  }) {
    return TimerCollection(
      timers: timers ?? this.timers,
      laps: laps ?? this.laps,
      isInfinite: isInfinite ?? this.isInfinite,
      label: title ?? this.label,
    );
  }
}
