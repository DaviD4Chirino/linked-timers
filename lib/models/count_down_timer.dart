import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:uuid/uuid.dart';

String get uuid => Uuid().v4();

class CountDownTimer extends StopWatchTimer {
  CountDownTimer({
    super.mode = StopWatchMode.countDown,
    super.presetMillisecond,
    super.onChange,
    super.onChangeRawSecond,
    super.onChangeRawMinute,
    super.onStopped,
    super.onEnded,
    id = "",
  });

  String id = uuid;
}
