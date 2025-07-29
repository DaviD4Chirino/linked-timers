import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_timers/models/abstracts/utils.dart';
import 'package:linked_timers/widgets/collection_total_progress.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'package:linked_timers/models/abstracts/spacing.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:linked_timers/models/timer_collection.dart';
import 'package:linked_timers/services/notification_service.dart';
import 'package:linked_timers/widgets/collection_drop_down_button.dart';
import 'package:linked_timers/widgets/timers_list.dart';

class TimerCollectionControl extends ConsumerStatefulWidget {
  const TimerCollectionControl(
    this.collection, {
    this.showMore = true,
    this.titleWidget,
    this.lapsWidget,
    this.buttonWidget,
    this.onTimerTapped,
    this.onTimerEnd,
    super.key,
  });

  final bool showMore;

  final TimerCollection collection;

  /// This replaces the label at the top
  final Widget? titleWidget;

  /// This replaces the label at the top that marks the laps
  final Widget? lapsWidget;

  final Widget? buttonWidget;

  final Function(StopWatchTimer timer, String label)?
  onTimerTapped;

  final void Function(int timerIndex)? onTimerEnd;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TimerCollectionControlState();
}

class _TimerCollectionControlState
    extends ConsumerState<TimerCollectionControl> {
  late final AutoScrollController itemScrollController =
      AutoScrollController();

  bool schedulingAlarm = false;
  int laps = 0;
  int currentTimerIndex = 0;
  double currentTimerVisibleFraction = 1.0;

  StopWatchTimer get globalStopWatch =>
      widget.collection.globalStopWatch;

  Timer? notificationUpdateTimer;

  ThemeData get theme => Theme.of(context);
  int get maxLaps => widget.collection.laps;
  List<StopWatchTimer> stopWatches = [];

  late bool _isInfinite = widget.collection.isInfinite;

  Timer get currentTimer =>
      widget.collection.timers[currentTimerIndex];
  StopWatchTimer get currentStopWatch =>
      stopWatches[currentTimerIndex];

  bool get isInfinite => _isInfinite;

  /// The number of laps that have been completed and is not infinite
  bool get finished => laps >= maxLaps && isInfinite == false;

  int remainingTime = 0;

  set isInfinite(bool val) {
    setState(() {
      _isInfinite = val;
      widget.collection.isInfinite = val;
    });

    if (val) {
      setState(() {
        widget.collection.isInfinite = val;
      });
    }
    if (!val && laps >= maxLaps) {
      setState(() {
        // get the current laps by calculating the remaining time
        // and subtracting the current time
        laps = maxLaps - ((remainingTime ~/ 1000) + 1);
      });
    }
  }

  void scrollToIndex(int index) {
    itemScrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
      duration: Duration(milliseconds: 400),
    );
  }

  void reset() {
    if (stopWatches.isEmpty) return;
    setState(() {
      laps = 0;
      currentTimerIndex = 0;
      // currentStopWatch = stopWatches.first;
      // currentTimer = widget.collection.timers.first;
      globalStopWatch.onResetTimer();
      scrollToIndex(0);
      resetAllTimers();
      globalStopWatch.setPresetTime(
        mSec: widget.collection.totalTime,
        add: false,
      );
      // stopAlarm();
    });
    NotificationService.cancelCollectionNotification(
      widget.collection,
    );
  }

  void onTimerEnded(StopWatchTimer timer) {
    Utils.log(["onTimerEnded"]);
    timer.onStopTimer();
    setState(() {
      if (stopWatches.isEmpty) return;
      currentTimer;

      currentTimerIndex =
          (currentTimerIndex + 1) % stopWatches.length;

      // On lap
      if (currentTimerIndex == 0) {
        /* globalStopWatch.setPresetTime(
          mSec: widget.collection.totalTime,
          add: false,
        ); */

        laps++;

        if (finished) {
          // currentStopWatch = stopWatches[currentTimerIndex];

          resetAllTimers();
          return;
        }
        resetAllTimers();

        // globalStopWatch.onStartTimer();
      }
      // currentStopWatch = stopWatches[currentTimerIndex]
      currentStopWatch
        ..onResetTimer()
        ..onStartTimer();
      scrollToIndex(currentTimerIndex);

      // currentTimer = widget.collection.timers[currentTimerIndex];
    });

    if (widget.onTimerEnd != null) {
      widget.onTimerEnd!(currentTimerIndex);
    }
  }

  void resetAllTimers() {
    for (var timer in stopWatches) {
      timer.onResetTimer();
    }
  }

  void buildStopWatches() {
    reset();
    setState(() {
      if (widget.collection.timers.isEmpty) return;
      stopWatches = widget.collection.timers.map((e) {
        return e.stopWatch;
      }).toList();
      // currentTimer = widget.collection.timers.first;
    });

    for (StopWatchTimer timer in stopWatches) {
      if (stopWatches.isEmpty) return;
      timer.fetchEnded.listen((data) {
        onTimerEnded(timer);
      });
    }

    globalStopWatch.rawTime.listen((millis) {
      remainingTime = millis;
    });

    setState(() {
      if (stopWatches.isEmpty) return;
      // currentStopWatch = stopWatches.first;
    });
  }

  @override
  void initState() {
    super.initState();
    buildStopWatches();
  }

  @override
  void dispose() async {
    super.dispose();
    itemScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 0,
      children: [
        topPart(),
        // Layout
        SizedBox(
          height: 77,
          child: LayoutGrid(
            columnSizes: [1.fr, 70.px],
            rowSizes: [1.fr],
            children: [
              Center(
                child: TimersList(
                  stopWatches,
                  timers: widget.collection.timers,
                  timerListController: itemScrollController,
                  onTimerTapped: widget.onTimerTapped != null
                      ? (stopWatch) {
                          widget.onTimerTapped!(
                            stopWatch,
                            currentTimer.label,
                          );
                        }
                      : null,
                  onTimerLongPressed: (index) {
                    playAt(index);
                  },

                  currentTimerIndex: currentTimerIndex,
                ),
              ),
              controlButton(),
            ],
          ),
        ),
        SizedBox(height: Spacing.lg),
        CollectionTotalProgress(globalStopWatch),
        LayoutGrid(
          columnSizes: [1.fr, 40.px],
          rowSizes: [40.px],
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  currentTimer.label,
                  style: theme.textTheme.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            CollectionDropDownButton(widget.collection),
          ],
        ),
        /*  Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                currentTimer.label,
                style: theme.textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.showMore)
              Expanded(
                flex: 1,
                child: CollectionDropDownButton(
                  widget.collection,
                ),
              ),
          ],
        ), */
      ],
    );
  }

  void playAt(int index) {
    setState(() {
      pause();
      currentTimerIndex = index;
      currentStopWatch.onResetTimer();
      globalStopWatch.onResetTimer();

      int prevTimes = 0;

      for (int i = 0; i <= laps; i++) {
        for (
          int j = 0;
          j < widget.collection.timers.length;
          j++
        ) {
          if (j == index && i == laps) break;

          var t = widget.collection.timers[j];
          prevTimes += t.timeAsMilliseconds;
        }
      }

      // Subtract the value from the global timer
      var mSec = widget.collection.totalTime - prevTimes;

      globalStopWatch.setPresetTime(mSec: mSec, add: false);

      play();
      scrollToIndex(index);
    });
  }

  Widget controlButton() {
    void onPressed() {
      if (stopWatches.isEmpty) {
        return;
      }

      if (currentStopWatch.isRunning) {
        pause();
        // stopAlarm();
        return;
      }

      if (finished) {
        reset();
        play();
        /* if (!isInfinite) {
          setAlarm();
        } */
        return;
      }
      if (laps >= widget.collection.laps) {
        setState(() {
          laps = 0;
        });
      }
      play();
      /* if (!isInfinite) {
        setAlarm();
      } */
    }

    IconData getIcon() {
      if (currentStopWatch.isRunning) {
        return Icons.pause_rounded;
      }
      if (finished) {
        return Icons.restore_rounded;
      }
      return Icons.play_arrow_rounded;
    }

    return widget.buttonWidget ??
        StreamBuilder(
          stream: currentStopWatch.rawTime,
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return Container();
            }

            return Center(
              child: IconButton.filled(
                enableFeedback: true,
                onPressed: onPressed,
                onLongPress: reset,
                icon: Icon(getIcon()),
                iconSize: Spacing.iconXXl,
              ),
            );
          },
        );
  }

  void play() {
    globalStopWatch.onStartTimer();
    currentStopWatch.onStartTimer();
  }

  void pause() {
    globalStopWatch.onStopTimer();
    currentStopWatch.onStopTimer();
  }

  Widget topPart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        if (widget.titleWidget != null)
          widget.titleWidget as Widget,

        if (widget.titleWidget == null)
          Expanded(
            child: Text(
              widget.collection.label,
              style: theme.textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        if (widget.collection.alert)
          Icon(Icons.notifications_active_rounded, size: 20),
        if (widget.collection.alert) SizedBox(width: Spacing.sm),
        if (widget.lapsWidget != null)
          SizedBox(width: Spacing.lg),
        widget.lapsWidget ??
            Text(
              isInfinite ? "$laps" : "$laps/$maxLaps",
              style: TextStyle(
                fontSize: theme.textTheme.titleMedium!.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
        SizedBox(width: Spacing.base),
        if (widget.lapsWidget == null)
          Switch(
            thumbIcon: WidgetStateProperty.resolveWith(
              (states) => const Icon(Icons.loop_rounded),
            ),
            value: isInfinite,
            onChanged: (val) {
              setState(() {
                isInfinite = val;
              });
            },
          ),
      ],
    );
  }
}
