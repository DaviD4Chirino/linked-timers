import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:uuid/uuid.dart';

class Timer {
  Timer({
    // required this.title,
    this.label = "New Timer",
    this.hours = 0,
    this.minutes = 0,
    this.seconds = 0,
    this.nextTimer,
  });

  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  Timer? nextTimer;
  String label;
  String id = Uuid().v4();

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

  Map<String, dynamic> toMap() => {
    "id": id,
    "label": label,
    "hours": hours,
    "minutes": minutes,
    "seconds": seconds,
    // "nextTimer": nextTimer?.toJson(),
  };

  Timer.fromMap(Map<String, dynamic> json)
    : id = json["id"],
      label = json["label"],
      hours = json["hours"] ?? 0,
      minutes = json["minutes"] ?? 0,
      seconds = json["seconds"] ?? 0;

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

  /* nextTimer =
          json["nextTimer"] != null
              ? Timer.fromJson(json["nextTimer"])
              : null; */
}
// bool isLapHours = true,
//   StopWatchMode mode = StopWatchMode.countUp,
//   int presetMillisecond = 0,
//   int refreshTime = 1,
//   void Function(int)? onChange,
//   void Function(int)? onChangeRawSecond,
//   void Function(int)? onChangeRawMinute,
//   void Function()? onStopped,
//   void Function()? onEnded,