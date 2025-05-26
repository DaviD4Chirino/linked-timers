import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:linked_timers/models/timer_collection.dart';
import 'package:linked_timers/providers/timer_database.dart';
import 'package:linked_timers/widgets/timer_display.dart';

class TimerCollectionDisplay
    extends ConsumerStatefulWidget {
  const TimerCollectionDisplay(
    this.collection, {
    super.key,
  });

  final TimerCollection collection;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TimerCollectionDisplayState();
}

class _TimerCollectionDisplayState
    extends ConsumerState<TimerCollectionDisplay> {
  bool get isInfinite => widget.collection.isInfinite;
  int get maxLaps => widget.collection.laps;
  List<Timer> get timers => widget.collection.timers;
  bool get finished =>
      laps >= maxLaps && isInfinite == false;

  TimerDatabase get notifier =>
      ref.read(timerDatabaseProvider.notifier);

  int laps = 0;
  int timerIndex = 0;
  Timer currentTimer = Timer(label: "");

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
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.collection.label,
                  style: theme.textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Text(
                isInfinite ? "∞" : "$laps/$maxLaps",
                style: TextStyle(
                  fontSize:
                      theme.textTheme.titleMedium!.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Switch(
                thumbIcon: WidgetStateProperty.resolveWith(
                  (states) => const Icon(Icons.loop),
                ),
                value: isInfinite,
                onChanged: (val) {
                  notifier.setCollection(
                    widget.collection.copyWith(
                      isInfinite: val,
                    ),
                  );
                },
              ),
            ],
          ),
          // Layout
          SizedBox(
            height: 70,
            child: LayoutGrid(
              columnSizes: [1.fr, 70.px],
              rowSizes: [1.fr],
              children: [
                Center(
                  child: ListView.separated(
                    itemCount: timers.length,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder:
                        (context, index) =>
                            SizedBox(width: 8),
                    itemBuilder:
                        (context, index) =>
                            TimerDisplay(timers[index]),
                  ),
                ),
                StreamBuilder(
                  stream: currentTimer.rawTime,
                  builder: (context, snapshot) {
                    if (snapshot.hasData == false) {
                      return Container();
                    }

                    return Center(
                      child: IconButton.filled(
                        onPressed:
                            currentTimer.isRunning
                                ? currentTimer.onStopTimer
                                : finished
                                ? () {
                                  reset();
                                  currentTimer
                                      .onStartTimer();
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
        ],
      ),
    );
  }
}
