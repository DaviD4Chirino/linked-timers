import 'package:myapp/models/timer.dart';
import 'package:myapp/models/timer_collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

part 'timer_database.g.dart';

@Riverpod(keepAlive: true)
class TimerDatabase extends _$TimerDatabase {
  @override
  List<TimerCollection> build() {
    return List.generate(10, (i) {
      return TimerCollection(
        title: "Timer collection Nro $i",
        timers: List.generate(
          2,
          (i) => Timer(
            mode: StopWatchMode.countDown,
            presetMillisecond: StopWatchTimer.getMilliSecFromSecond(2),
          ),
        ),
        laps: 2,
      );
    });
  }
}
