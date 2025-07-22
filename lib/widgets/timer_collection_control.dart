import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_timers/widgets/collection_total_progress.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
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
  late final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  bool _isInfinite = false;

  bool schedulingAlarm = false;
  int laps = 0;
  int currentTimerIndex = 0;
  double currentTimerVisibleFraction = 1.0;

  StopWatchTimer currentStopWatch = StopWatchTimer();
  StopWatchTimer globalStopWatch = StopWatchTimer();
  Timer currentTimer = Timer(label: "");

  Timer? notificationUpdateTimer;

  ThemeData get theme => Theme.of(context);
  int get maxLaps => widget.collection.laps;
  List<StopWatchTimer> stopWatches = [];

  bool get isInfinite => _isInfinite;

  set isInfinite(bool value) {
    if (value) {
      // stopAlarm();
    } else {
      /* if (currentStopWatch.isRunning) {
        setAlarm();
      } */
    }
    _isInfinite = value;
  }

  bool get finished => laps >= maxLaps && isInfinite == false;

  int remainingTime = 0;

  void startNotificationUpdates() {}

  void scrollToIndex(int index) {
    // Get the currently visible indexes
    /* final visibleIndexes = itemPositionsListener
        .itemPositions
        .value
        .map((item) => item.index)
        .toSet();

    final bool invisible = !visibleIndexes.contains(index); */

    // Only scroll if the index is not visible
    /*  if (invisible) {
      itemScrollController.scrollToIndex(
        index,
        preferPosition: AutoScrollPosition.begin,
      );
    } */
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
      currentStopWatch = stopWatches.first;
      currentTimer = widget.collection.timers.first;
      widget.collection.globalStopWatch.onResetTimer();
      scrollToIndex(0);
      resetAllTimers();
      // stopAlarm();
    });
  }

  void onTimerEnded(StopWatchTimer timer) {
    timer.onStopTimer();
    setState(() {
      if (stopWatches.isEmpty) return;
      currentTimer;

      /* if (widget.collection.timers[currentTimerIndex].notify) {
        NotificationService.showTimerEndedNotification(
          widget.collection.timers[currentTimerIndex],
          widget.collection.id,
        );
      } */

      currentTimerIndex =
          (currentTimerIndex + 1) % stopWatches.length;

      if (currentTimerIndex == 0) {
        // globalStopWatch.onResetTimer();

        if (isInfinite == false) {
          laps++;
        }
        if (finished) {
          currentStopWatch = stopWatches[currentTimerIndex];

          resetAllTimers();

          /* if (!widget.collection.alert) {
            NotificationService.showCollectionProgressNotification(
              widget.collection,
              milliSeconds: 0,
              displayCollectionEnded: true,
            );
          } */

          return;
        }
        resetAllTimers();

        // globalStopWatch.onStartTimer();
      }
      currentStopWatch = stopWatches[currentTimerIndex]
        ..onResetTimer()
        ..onStartTimer();
      scrollToIndex(currentTimerIndex);

      currentTimer = widget.collection.timers[currentTimerIndex];
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
      currentTimer = widget.collection.timers.first;
    });

    for (StopWatchTimer timer in stopWatches) {
      if (stopWatches.isEmpty) return;
      timer.fetchEnded.listen((data) {
        onTimerEnded(timer);
      });
    }
    /* int totalMillis =
        (stopWatches
            .map((sw) => sw.initialPresetTime)
            .reduce((a, b) => a + b)) *
        maxLaps; */

    /* widget.collection.globalStopWatch.secondTime.listen(
      onGlobalSecondTimer,
    ); */
    widget.collection.globalStopWatch.rawTime.listen((millis) {
      remainingTime = millis;
    });

    /* globalStopWatch = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: totalMillis,
      onChangeRawSecond: onGlobalSecondTimer,
      onChange: (int millis) {
        remainingTime = millis;
        // print(remainingTime);
      },
    ); */

    // remainingTime = totalMillis;

    setState(() {
      if (stopWatches.isEmpty) return;
      currentStopWatch = stopWatches.first;
    });
  }

  @override
  void initState() {
    super.initState();
    buildStopWatches();
  }

  /*  @override
  void didUpdateWidget(
    covariant TimerCollectionControl oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.collection != widget.collection) {
      buildStopWatches();
    }
  } */

  @override
  void dispose() async {
    super.dispose();
    itemScrollController.dispose();

    // stopAlarm();
    // globalStopWatch.dispose();
    /* for (var timer in stopWatches) {
      await timer.dispose();
    } */
  }

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
                  currentTimerIndex: currentTimerIndex,
                  itemPositionsListener: itemPositionsListener,
                ),
              ),
              controlButton(),
            ],
          ),
        ),
        SizedBox(height: Spacing.lg),
        CollectionTotalProgress(
          widget.collection.globalStopWatch,
        ),
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
      if (stopWatches.isEmpty) {
        return;
      }

      if (currentStopWatch.isRunning) {
        widget.collection.globalStopWatch.onStopTimer();
        currentStopWatch.onStopTimer();
        // stopAlarm();
        return;
      }

      if (finished) {
        reset();
        currentStopWatch.onStartTimer();
        widget.collection.globalStopWatch.onStartTimer();
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
      widget.collection.globalStopWatch.onStartTimer();
      currentStopWatch.onStartTimer();
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

  // Future<void> stopAlarm() async {
  //   if (!widget.collection.alert) return;
  //   AlarmService.stopCollectionAlarm(widget.collection.id);
  //   Utils.log([
  //     "Alert of id:",
  //     "${widget.collection.id}-alarm".hashCode,
  //     "Stopped",
  //   ]);
  // }

  // Future<void> setAlarm() async {
  //   if (!widget.collection.alert) return;
  //   AlarmService.startCollectionAlarm(
  //     widget.collection,
  //     dateTime: DateTime.now().add(
  //       Duration(milliseconds: remainingTime),
  //     ),
  //   );

  //   Utils.log([
  //     "Alert Set for: ${(DateTime.now().add(Duration(milliseconds: remainingTime)).toIso8601String())}",
  //   ]);
  // }

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

  /* void onGlobalSecondTimer(int value) {
    // If its at the start do not show notification
    if ((value * 1000) == globalStopWatch.initialPresetTime) {
      return;
    }
    NotificationService.showCollectionProgressNotification(
      widget.collection,
      milliSeconds: value * 1000,
    );
  } */

  /*  void onGlobalStopWatchEnded(bool val) {
    NotificationService.showCollectionProgressNotification(
      widget.collection,
      milliSeconds: 0,
      displayCollectionEnded: finished,
    );
  } */
}
