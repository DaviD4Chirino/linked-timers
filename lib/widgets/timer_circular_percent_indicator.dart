import 'package:flutter/material.dart';
import 'package:linked_timers/models/abstracts/utils.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimerCircularPercentIndicator extends StatelessWidget {
  const TimerCircularPercentIndicator(
    this.timer, {
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.displayLabel = true,
    super.key,
  });

  final Timer timer;
  final VoidCallback? onTap;
  final void Function()? onLongPress;
  final bool selected;
  final bool displayLabel;

  @override
  Widget build(BuildContext context) {
    bool hasMinute = timer.stopWatch.initialPresetTime >= 60000;
    bool hasSecond = timer.stopWatch.initialPresetTime >= 1000;
    bool hasHour = timer.stopWatch.initialPresetTime >= 3600000;

    final ThemeData theme = Theme.of(context);

    return TextButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(EdgeInsets.all(0)),
      ),
      clipBehavior: Clip.none,
      onPressed: onTap,
      onLongPress: onLongPress,
      child: StreamBuilder(
        stream: timer.stopWatch.rawTime,
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
                  timer.stopWatch.initialPresetTime,
                ),

                lineWidth: 4,
                animation: true,
                animateToInitialPercent: true,
                animateFromLastPercent: true,

                /// A stack is better than a column because the text is centered
                center: Text(
                  StopWatchTimer.getDisplayTime(
                    data.data!,
                    hours: hasHour,
                    minute: hasMinute,
                    second: hasSecond && !hasHour,
                    milliSecond: !hasHour && !hasMinute,
                    // hoursRightBreak: "h ",
                    // minuteRightBreak: "m ",
                    // secondRightBreak: "s ",
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              if (displayLabel)
                Positioned.fill(
                  top: 30,
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 50,
                      child: timerLabel(theme),
                    ),
                  ),
                ),
              /* if (displayLabel)
                Positioned.fill(
                  top: 40,
                  child: Align(
                    alignment: Alignment.center,
                    child: timerLabel(theme),
                  ),
                ), */
              if (timer.notify)
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

  Text timerLabel(ThemeData theme) {
    return Text(
      timer.label,
      style: TextStyle(
        fontSize: 8,
        fontWeight: FontWeight.w900,
        color: theme.colorScheme.onSurface,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      textAlign: TextAlign.center,
    );
  }
}
