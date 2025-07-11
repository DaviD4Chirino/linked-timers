import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_timers/models/abstracts/utils.dart';
import 'package:linked_timers/models/count_down_timer.dart';
import 'package:linked_timers/services/alarm_service.dart';
import 'package:linked_timers/widgets/collection_total_progress.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
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
    required this.stopWatches,
    this.showMore = true,
    this.titleWidget,
    this.lapsWidget,
    this.buttonWidget,
    this.onTimerTapped,
    this.onTimerEnd,
    super.key,
  });

  final List<CountDownTimer> stopWatches;

  final bool showMore;

  final TimerCollection collection;

  /// This replaces the label at the top
  final Widget? titleWidget;

  /// This replaces the label at the top that marks the laps
  final Widget? lapsWidget;

  final Widget? buttonWidget;

  final Function(CountDownTimer timer, String label)?
  onTimerTapped;

  final void Function(int timerIndex)? onTimerEnd;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TimerCollectionControlState();
}

class _TimerCollectionControlState
    extends ConsumerState<TimerCollectionControl> {
  final ItemScrollController itemScrollController =
      ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  bool _isInfinite = false;

  bool schedulingAlarm = false;
  int laps = 0;
  int currentTimerIndex = 0;
  double currentTimerVisibleFraction = 1.0;

  CountDownTimer currentStopWatch = CountDownTimer();
  StopWatchTimer globalStopWatch = StopWatchTimer();
  Timer currentTimer = Timer(label: "");

  Timer? notificationUpdateTimer;

  ThemeData get theme => Theme.of(context);
  int get maxLaps => widget.collection.laps;

  bool get isInfinite => _isInfinite;

  set isInfinite(bool value) {
    if (value) {
      stopAlarm();
    } else {
      if (currentStopWatch.isRunning) {
        setAlarm();
      }
    }
    _isInfinite = value;
  }

  bool get finished => laps >= maxLaps && isInfinite == false;

  int remainingTime = 0;

  void maybeScrollToIndex(int index) {
    // Get the currently visible indexes
    final visibleIndexes =
        itemPositionsListener.itemPositions.value
            .map((item) => item.index)
            .toSet();

    final bool invisible = !visibleIndexes.contains(index);

    // Only scroll if the index is not visible and controller is attached
    if (invisible && itemScrollController.isAttached) {
      itemScrollController.scrollTo(
        alignment: 0.1,
        index: index,
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut,
      );
    }
  }

  void reset() {
    if (widget.stopWatches.isEmpty) return;
    setState(() {
      laps = 0;
      currentStopWatch = widget.stopWatches.first;
      currentTimer = widget.collection.timers.first;
      globalStopWatch.onResetTimer();
      maybeScrollToIndex(0);
      resetAllTimers();
      stopAlarm();
    });
  }

  void onTimerEnded(CountDownTimer timer) {
    timer.onStopTimer();
    setState(() {
      if (widget.stopWatches.isEmpty) return;
      currentTimer;

      if (widget.collection.timers[currentTimerIndex].notify) {
        NotificationService.showTimerEndedNotification(
          widget.collection.timers[currentTimerIndex],
          widget.collection.id,
        );
      }

      currentTimerIndex =
          (currentTimerIndex + 1) % widget.stopWatches.length;

      if (currentTimerIndex == 0) {
        // globalStopWatch.onResetTimer();

        if (isInfinite == false) {
          laps++;
        }
        if (finished) {
          currentStopWatch =
              widget.stopWatches[currentTimerIndex];

          resetAllTimers();

          if (!widget.collection.alert) {
            NotificationService.showCollectionProgressNotification(
              widget.collection,
              milliSeconds: 0,
              displayCollectionEnded: true,
            );
          }

          return;
        }
        resetAllTimers();

        // globalStopWatch.onStartTimer();
      }
      currentStopWatch =
          widget.stopWatches[currentTimerIndex]
            ..onResetTimer()
            ..onStartTimer();
      maybeScrollToIndex(currentTimerIndex);

      currentTimer = widget.collection.timers[currentTimerIndex];
    });

    if (widget.onTimerEnd != null) {
      widget.onTimerEnd!(currentTimerIndex);
    }
  }

  void resetAllTimers() {
    for (var timer in widget.stopWatches) {
      timer.onResetTimer();
    }
  }

  void buildStopWatches() {
    reset();
    setState(() {
      if (widget.collection.timers.isEmpty) return;
      /* widget.stopWatches =
          widget.collection.timers.map((e) {
            return StopWatchTimer(
              mode: StopWatchMode.countDown,
              presetMillisecond: e.timeAsMilliseconds,
            );
          }).toList(); */
      currentTimer = widget.collection.timers.first;
    });

    for (CountDownTimer timer in widget.stopWatches) {
      if (widget.stopWatches.isEmpty) return;
      timer.fetchEnded.listen((data) {
        onTimerEnded(timer);
      });
    }
    int totalMillis =
        (widget.stopWatches
            .map((sw) => sw.initialPresetTime)
            .reduce((a, b) => a + b)) *
        maxLaps;

    globalStopWatch = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: totalMillis,
      onChangeRawSecond: onGlobalSecondTimer,
      onChange: (int millis) {
        remainingTime = millis;
        // print(remainingTime);
      },
    );

    remainingTime = totalMillis;

    setState(() {
      if (widget.stopWatches.isEmpty) return;
      currentStopWatch = widget.stopWatches.first;
    });
  }

  @override
  void initState() {
    super.initState();
    // currentTimer = widget.collection.timers.first;
    // currentStopWatch = widget.stopWatches.first;
    buildStopWatches();
  }

  /* @override
  void didUpdateWidget(
    covariant TimerCollectionControl oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.collection != widget.collection) {
      buildStopWatches();
    }
  } */

  /* @override
  void dispose() async {
    super.dispose();
    stopAlarm();
    globalStopWatch.dispose();
    for (var timer in widget.stopWatches) {
      await timer.dispose();
    }
  } */

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
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
                  widget.stopWatches,
                  timers: widget.collection.timers,
                  itemScrollController: itemScrollController,
                  onTimerTapped: (stopWatch) {
                    if (widget.onTimerTapped != null) {
                      widget.onTimerTapped!(
                        stopWatch,
                        currentTimer.label,
                      );
                    }
                  },
                  currentTimerIndex: currentTimerIndex,
                  itemPositionsListener: itemPositionsListener,
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

  Widget controlButton() {
    void onPressed() {
      if (widget.stopWatches.isEmpty) {
        return;
      }

      if (currentStopWatch.isRunning) {
        globalStopWatch.onStopTimer();
        currentStopWatch.onStopTimer();
        stopAlarm();
        return;
      }

      if (finished) {
        reset();
        currentStopWatch.onStartTimer();
        globalStopWatch.onStartTimer();
        if (!isInfinite) {
          setAlarm();
        }
        return;
      }
      if (laps >= widget.collection.laps) {
        setState(() {
          laps = 0;
        });
      }
      globalStopWatch.onStartTimer();
      currentStopWatch.onStartTimer();
      if (!isInfinite) {
        setAlarm();
      }
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

  Future<void> stopAlarm() async {
    if (!widget.collection.alert) return;
    AlarmService.stopCollectionAlarm(widget.collection.id);
    Utils.log([
      "Alert of id:",
      "${widget.collection.id}-alarm".hashCode,
      "Stopped",
    ]);
  }

  Future<void> setAlarm() async {
    if (!widget.collection.alert) return;
    AlarmService.startCollectionAlarm(
      widget.collection,
      dateTime: DateTime.now().add(
        Duration(milliseconds: remainingTime),
      ),
    );

    Utils.log([
      "Alert Set for: ${(DateTime.now().add(Duration(milliseconds: remainingTime)).toIso8601String())}",
    ]);
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
              isInfinite ? "∞" : "$laps/$maxLaps",
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

  void onGlobalSecondTimer(int value) {
    // If its at the start do not show notification
    if ((value * 1000) == globalStopWatch.initialPresetTime) {
      return;
    }
    NotificationService.showCollectionProgressNotification(
      widget.collection,
      milliSeconds: value * 1000,
    );
  }

  void onGlobalStopWatchEnded(bool val) {
    NotificationService.showCollectionProgressNotification(
      widget.collection,
      milliSeconds: 0,
      displayCollectionEnded: finished,
    );
  }
}
