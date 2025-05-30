import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:uuid/uuid.dart';

class Timer {
  Timer({
    // required this.title,
    required this.label,
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