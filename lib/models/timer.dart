import 'package:stop_watch_timer/stop_watch_timer.dart';

class Timer extends StopWatchTimer {
  Timer({
    // required this.title,
    required this.label,
    this.nextTimer,
    super.isLapHours,
    super.mode,
    super.presetMillisecond,
    super.refreshTime,
    super.onChange,
    super.onChangeRawSecond,
    super.onChangeRawMinute,
    super.onStopped,
    super.onEnded,
  });
  Timer? nextTimer;
  String label;
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