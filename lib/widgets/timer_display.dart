import 'package:flutter/material.dart';
import 'package:myapp/models/abstracts/utils.dart';
import 'package:myapp/timer.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimerDisplay extends StatelessWidget {
  const TimerDisplay(this.timer, {super.key});

  final Timer timer;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: timer.rawTime,
      builder: (context, data) {
        if (data.hasData == false) {
          return Container();
        }
        return CircularPercentIndicator(
          radius: 32,
          percent: Utils.getPercentage(
            data.data!,
            0.0,
            timer.initialPresetTime,
            // StopWatchTimer.getMilliSecFromSecond(5),
          ),
          lineWidth: 3,
          animation: true,
          animateToInitialPercent: true,
          animateFromLastPercent: true,

          center: Text(
            StopWatchTimer.getDisplayTime(
              data.data!,
              hours: false,
              minute: false,
            ),
            style: TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }
}
