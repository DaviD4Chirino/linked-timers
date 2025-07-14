import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:uuid/uuid.dart';

class Timer {
  Timer({
    this.label = "New Timer",
    this.hours = 0,
    this.minutes = 0,
    this.seconds = 0,
    this.notify = false,
    this.nextTimer,
    String? id,
  }) : id = id ?? Uuid().v4(),
       stopWatch = StopWatchTimer(
         mode: StopWatchMode.countDown,
         presetMillisecond:
             StopWatchTimer.getMilliSecFromHour(hours) +
             StopWatchTimer.getMilliSecFromMinute(minutes) +
             StopWatchTimer.getMilliSecFromSecond(seconds),
       );

  /// A flag that shows a notification when this timer specifically ends
  bool notify = false;

  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  Timer? nextTimer;
  String label;
  String id;

  late StopWatchTimer stopWatch;

  int get timeAsMilliseconds =>
      ((hours * 60 * 60) + (minutes * 60) + seconds) * 1000;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Timer &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return "$hours:$minutes:$seconds";
  }

  Future<void> dispose() async => stopWatch.dispose();

  Map<String, dynamic> toMap() => {
    "id": id,
    "label": label,
    "hours": hours,
    "minutes": minutes,
    "seconds": seconds,
    "notify": notify,
    // "nextTimer": nextTimer?.toJson(),
  };

  Timer.fromMap(Map<String, dynamic> json)
    : id = json["id"],
      label = json["label"],
      hours = json["hours"] ?? 0,
      minutes = json["minutes"] ?? 0,
      seconds = json["seconds"] ?? 0,
      notify = json["notify"] ?? false;

  factory Timer.fromStopWatchTimer(
    StopWatchTimer swt, {
    String label = "New Timer",
    Timer? nextTimer,
  }) {
    final ms = swt.initialPresetTime;
    final totalSeconds = ms ~/ 1000;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    return Timer(
      label: label,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      nextTimer: nextTimer,
    );
  }

  StopWatchTimer toStopWatchTimer() {
    return StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: timeAsMilliseconds,
    );
  }

  /// Returns a copy of this Timer with the given fields replaced by new values.
  Timer copyWith({
    String? label,
    int? hours,
    int? minutes,
    int? seconds,
    bool? notify,
    Timer? nextTimer,
    String? id,
  }) {
    return Timer(
      label: label ?? this.label,
      hours: hours ?? this.hours,
      minutes: minutes ?? this.minutes,
      seconds: seconds ?? this.seconds,
      notify: notify ?? this.notify,
      nextTimer: nextTimer ?? this.nextTimer,
      id: id ?? this.id,
    );
  }
}
