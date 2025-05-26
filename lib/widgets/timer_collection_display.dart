import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:linked_timers/models/timer_collection.dart';
import 'package:linked_timers/widgets/timer_display.dart';

//TODO: A swipe resets the whole collection
class TimerCollectionDisplay extends StatefulWidget {
  const TimerCollectionDisplay(this.collection, {super.key});

  final TimerCollection collection;

  @override
  State<TimerCollectionDisplay> createState() => _TimerCollectionDisplayState();
}

class _TimerCollectionDisplayState extends State<TimerCollectionDisplay> {
  int laps = 0;

  bool get isInfinite => widget.collection.isInfinite;
  int get maxLaps => widget.collection.laps;
  List<Timer> get timers => widget.collection.timers;
  bool get finished => laps >= maxLaps && isInfinite == false;

  int timerIndex = 0;
  Timer currentTimer = Timer();

  void reset() {
    setState(() {
      laps = 0;
      currentTimer = timers.first;
    });
  }

  void onTimerEnded(Timer timer) {
    timer.onStopTimer();
    setState(() {
      timerIndex = (timerIndex + 1) % timers.length;
      if (timerIndex == 0) {
        if (isInfinite == false) {
          laps++;
        }
        if (laps >= maxLaps && isInfinite == false) {
          currentTimer = timers[timerIndex];
          for (var timer in timers) {
            timer.onResetTimer();
          }
          return;
        }
        for (var timer in timers) {
          timer.onResetTimer();
        }
      }
      currentTimer = timers[timerIndex];
      currentTimer.onResetTimer();
      currentTimer.onStartTimer();
    });
  }

  @override
  void initState() {
    super.initState();
    for (Timer timer in timers) {
      timer.fetchEnded.listen((data) {
        onTimerEnded(timer);
      });
    }

    setState(() {
      currentTimer = timers.first;
    });
  }

  @override
  void dispose() {
    super.dispose();
    for (var timer in timers) {
      timer.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 0,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.collection.title,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              Text(
                isInfinite ? "∞" : "$laps/$maxLaps",
                style: theme.textTheme.titleMedium,
              ),
              Switch(
                thumbIcon: WidgetStateProperty.resolveWith(
                  (states) => const Icon(Icons.loop),
                ),
                value: isInfinite,
                onChanged: (val) {
                  widget.collection.isInfinite = val;
                  // setState(() {
                  //   infiniteLoops = val;
                  // });
                },
              ),
            ],
          ),
          // Layout
          SizedBox(
            height: 65,
            child: LayoutGrid(
              columnSizes: [1.fr, 70.px],
              rowSizes: [1.fr],
              children: [
                Center(
                  child: ListView.separated(
                    itemCount: timers.length,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => SizedBox(width: 8),
                    itemBuilder:
                        (context, index) => TimerDisplay(timers[index]),
                    /* children:
                        timers.map((timer) {
                          return TimerDisplay(timer);
                        }).toList(), */
                  ),
                ),
                StreamBuilder(
                  stream: currentTimer.rawTime,
                  builder: (context, snapshot) {
                    if (snapshot.hasData == false) return Container();

                    return Center(
                      child: IconButton.filled(
                        onPressed:
                            currentTimer.isRunning
                                ? currentTimer.onStopTimer
                                : finished
                                ? () {
                                  reset();
                                  currentTimer.onStartTimer();
                                }
                                : currentTimer.onStartTimer,
                        icon: Icon(
                          currentTimer.isRunning
                              ? Icons.pause
                              : finished
                              ? Icons.restart_alt
                              : Icons.play_arrow,
                        ),
                        iconSize: 34,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          /* Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 16,
                  children:
                      timers.map((timer) {
                        return TimerDisplay(timer);
                      }).toList(),
                ),
              ),
              StreamBuilder(
                stream: currentTimer.rawTime,
                builder: (context, snapshot) {
                  if (snapshot.hasData == false) return Container();

                  return IconButton.filled(
                    onPressed:
                        currentTimer.isRunning
                            ? currentTimer.onStopTimer
                            : finished
                            ? () {
                              reset();
                              currentTimer.onStartTimer();
                            }
                            : currentTimer.onStartTimer,
                    icon: Icon(
                      currentTimer.isRunning
                          ? Icons.pause
                          : finished
                          ? Icons.restart_alt
                          : Icons.play_arrow,
                    ),
                    iconSize: 34,
                  );
                },
              ),
            ],
          ), */
        ],
      ),
    );
  }
}
