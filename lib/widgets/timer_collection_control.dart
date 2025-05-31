import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_timers/models/abstracts/spacing.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:linked_timers/models/timer_collection.dart';
import 'package:linked_timers/widgets/timers_list.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimerCollectionControl extends ConsumerStatefulWidget {
  const TimerCollectionControl(
    this.collection, {
    this.titleWidget,
    this.lapsWidget,
    this.buttonWidget,
    this.onTimerTapped,
    this.onTimerEnd,
    super.key,
  });

  final TimerCollection collection;

  /// This replaces the label at the top
  final Widget? titleWidget;

  /// This replaces the label at the top that marks the laps
  final Widget? lapsWidget;

  final Widget? buttonWidget;

  final Function(StopWatchTimer timer)? onTimerTapped;

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

  bool isInfinite = false;
  int laps = 0;
  int currentTimerIndex = 0;
  double currentTimerVisibleFraction = 1.0;

  StopWatchTimer currentStopWatch = StopWatchTimer();
  Timer currentTimer = Timer(label: "");

  ThemeData get theme => Theme.of(context);
  int get maxLaps => widget.collection.laps;
  List<StopWatchTimer> stopWatches = [];
  bool get finished => laps >= maxLaps && isInfinite == false;

  void maybeScrollToIndex(int index) {
    // Get the currently visible indexes
    final visibleIndexes =
        itemPositionsListener.itemPositions.value
            .map((item) => item.index)
            .toSet();

    final bool invisible = !visibleIndexes.contains(index);

    // Only scroll if the index is not visible
    if (invisible) {
      itemScrollController.scrollTo(
        alignment: 0.1,
        index: index,
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut,
      );
    }
  }

  void reset() {
    if (stopWatches.isEmpty) return;
    setState(() {
      laps = 0;
      currentStopWatch = stopWatches.first;
      currentTimer = widget.collection.timers.first;
      maybeScrollToIndex(0);
    });
  }

  void onTimerEnded(StopWatchTimer timer) {
    timer.onStopTimer();
    setState(() {
      if (stopWatches.isEmpty) return;
      currentTimerIndex =
          (currentTimerIndex + 1) % stopWatches.length;
      if (currentTimerIndex == 0) {
        if (isInfinite == false) {
          laps++;
        }
        if (laps >= maxLaps && isInfinite == false) {
          currentStopWatch = stopWatches[currentTimerIndex];
          for (var timer in stopWatches) {
            timer.onResetTimer();
          }
          return;
        }
        for (var timer in stopWatches) {
          timer.onResetTimer();
        }
      }
      currentStopWatch =
          stopWatches[currentTimerIndex]
            ..onResetTimer()
            ..onStartTimer();
      maybeScrollToIndex(currentTimerIndex);

      // controller.scrollToIndex(timerIndex);
      currentTimer = widget.collection.timers[currentTimerIndex];
    });

    if (widget.onTimerEnd != null) {
      widget.onTimerEnd!(currentTimerIndex);
    }
  }

  void buildStopWatches() {
    setState(() {
      if (widget.collection.timers.isEmpty) return;
      stopWatches =
          widget.collection.timers.map((e) {
            return StopWatchTimer(
              mode: StopWatchMode.countDown,
              presetMillisecond:
                  StopWatchTimer.getMilliSecFromHour(e.hours) +
                  StopWatchTimer.getMilliSecFromMinute(e.minutes) +
                  StopWatchTimer.getMilliSecFromSecond(e.seconds),
            );
          }).toList();
      currentTimer = widget.collection.timers[currentTimerIndex];
    });

    for (StopWatchTimer timer in stopWatches) {
      if (stopWatches.isEmpty) return;
      timer.fetchEnded.listen((data) {
        onTimerEnded(timer);
      });
    }

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

  @override
  void didUpdateWidget(covariant TimerCollectionControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    buildStopWatches();
  }

  @override
  void dispose() async {
    super.dispose();
    for (var timer in stopWatches) {
      await timer.dispose();
    }
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
          height: 90,
          child: LayoutGrid(
            columnSizes: [1.fr, 70.px],
            rowSizes: [1.fr],
            children: [
              Center(
                child: TimersList(
                  stopWatches,
                  itemScrollController: itemScrollController,
                  onTimerTapped: widget.onTimerTapped,
                  currentTimerIndex: currentTimerIndex,
                  itemPositionsListener: itemPositionsListener,
                ),
              ),
              controlButton(),
            ],
          ),
        ),
        SizedBox(height: Spacing.sm),
        Text(currentTimer.label, style: theme.textTheme.bodyLarge),
      ],
    );
  }

  Widget controlButton() {
    void onPressed() {
      if (stopWatches.isEmpty) return;

      if (currentStopWatch.isRunning) {
        currentStopWatch.onStopTimer();
        return;
      }

      if (finished) {
        reset();
        currentStopWatch.onStartTimer();
        return;
      }

      currentStopWatch.onStartTimer();
    }

    IconData getIcon() {
      if (currentStopWatch.isRunning) {
        return Icons.pause;
      }
      if (finished) {
        return Icons.restore;
      }
      return Icons.play_arrow;
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
                onPressed: onPressed,
                icon: Icon(getIcon()),
                iconSize: Spacing.iconXXl,
              ),
            );
          },
        );
  }

  Widget topPart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        if (widget.titleWidget != null) widget.titleWidget as Widget,

        if (widget.titleWidget == null)
          Expanded(
            child: Text(
              widget.collection.label,
              style: theme.textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        if (widget.lapsWidget != null) SizedBox(width: Spacing.lg),
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
              (states) => const Icon(Icons.loop),
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
