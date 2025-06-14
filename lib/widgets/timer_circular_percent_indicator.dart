import 'package:flutter/material.dart';
import 'package:linked_timers/models/abstracts/utils.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimerCircularPercentIndicator extends StatelessWidget {
  const TimerCircularPercentIndicator(
    this.timer, {
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.notify = false,
    super.key,
  });

  final StopWatchTimer timer;
  final VoidCallback? onTap;
  final void Function()? onLongPress;
  final bool selected;
  final bool notify;

  @override
  Widget build(BuildContext context) {
    bool hasMinute = timer.initialPresetTime >= 60000;
    bool hasSecond = timer.initialPresetTime >= 1000;
    bool hasHour = timer.initialPresetTime >= 3600000;

    final ThemeData theme = Theme.of(context);

    return TextButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(EdgeInsets.all(0)),
      ),
      onPressed: onTap,
      onLongPress: onLongPress,
      child: StreamBuilder(
        stream: timer.rawTime,
        builder: (context, data) {
          if (data.hasData == false) {
            return Container();
          }
          return Stack(
            clipBehavior: Clip.none,
            children: [
              CircularPercentIndicator(
                radius: 34,
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: theme.colorScheme.secondary,
                backgroundColor: Colors.transparent,
                percent: Utils.getPercentage(
                  data.data!,
                  0.0,
                  timer.initialPresetTime,
                ),
                header: selected ? Text("Selected") : null,
                lineWidth: 4,
                animation: true,
                animateToInitialPercent: true,
                animateFromLastPercent: true,
                center: Text(
                  StopWatchTimer.getDisplayTime(
                    data.data!,
                    hours: hasHour,
                    minute: hasMinute,
                    second: hasSecond && !hasHour,
                    milliSecond: !hasHour && !hasMinute,
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (notify)
                Positioned(
                  right: -10,
                  child: Icon(
                    Icons.notifications_rounded,
                    size: 16,
                    color: theme.colorScheme.secondary,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
