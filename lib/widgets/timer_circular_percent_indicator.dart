import 'package:flutter/material.dart';
import 'package:linked_timers/models/abstracts/spacing.dart';
import 'package:linked_timers/models/abstracts/utils.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimerCircularPercentIndicator
    extends StatelessWidget {
  const TimerCircularPercentIndicator(
    this.timer, {
    this.onTap,
    super.key,
  });

  final Timer timer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    bool hasMinute = timer.initialPresetTime >= 60000;
    bool hasSecond = timer.initialPresetTime >= 1000;
    bool hasHour = timer.initialPresetTime >= 3600000;
    // 3600000

    return TextButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          EdgeInsets.all(Spacing.sm),
        ),
      ),
      onPressed: onTap,
      child: StreamBuilder(
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
                hours: hasHour,
                minute: hasMinute,
                second: hasSecond && !hasHour,
                milliSecond:
                    hasSecond && !hasMinute && !hasHour,
              ),
              style: TextStyle(fontSize: 16),
            ),
          );
        },
      ),
    );
  }
}
