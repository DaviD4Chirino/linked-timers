import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_timers/models/abstracts/spacing.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:linked_timers/models/timer_collection.dart';
import 'package:linked_timers/providers/timer_database.dart';
import 'package:linked_timers/widgets/timer_circular_percent_indicator.dart';

class TimerCollectionControl
    extends ConsumerStatefulWidget {
  const TimerCollectionControl(
    this.collection, {
    this.titleWidget,
    this.lapsWidget,
    this.onTimerTapped,
    super.key,
  });

  final TimerCollection collection;

  /// This replaces the label at the top
  final Widget? titleWidget;

  /// This replaces the label at the top that marks the laps
  final Widget? lapsWidget;

  final Function(Timer timer)? onTimerTapped;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TimerCollectionControlState();
}

class _TimerCollectionControlState
    extends ConsumerState<TimerCollectionControl> {
  ThemeData get theme => Theme.of(context);

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
      if (timers.isEmpty) return;
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
      currentTimer =
          timers[timerIndex]
            ..onResetTimer()
            ..onStartTimer();
    });
  }

  @override
  void initState() {
    super.initState();
    for (Timer timer in timers) {
      if (timers.isEmpty) return;
      timer.fetchEnded.listen((data) {
        onTimerEnded(timer);
      });
    }

    setState(() {
      if (timers.isEmpty) return;
      currentTimer = timers.first;
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (timers.isEmpty) return;
    for (var timer in timers) {
      timer.dispose();
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
            children: [timersList(), controlButton()],
          ),
        ),
        SizedBox(height: Spacing.sm),
        Text(
          currentTimer.label,
          style: theme.textTheme.bodyLarge,
        ),
      ],
    );
  }

  StreamBuilder<int> controlButton() {
    void onPressed() {
      if (timers.isEmpty) return;

      if (currentTimer.isRunning) {
        currentTimer.onStopTimer();
        return;
      }

      if (finished) {
        reset();
        currentTimer.onStartTimer();
        return;
      }

      currentTimer.onStartTimer();
    }

    IconData getIcon() {
      if (currentTimer.isRunning) {
        return Icons.pause;
      }
      if (finished) {
        return Icons.restore;
      }
      return Icons.play_arrow;
    }

    return StreamBuilder(
      stream: currentTimer.rawTime,
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
        if (widget.lapsWidget != null)
          SizedBox(width: Spacing.lg),
        widget.lapsWidget ??
            Text(
              isInfinite ? "∞" : "$laps/$maxLaps",
              style: TextStyle(
                fontSize:
                    theme.textTheme.titleMedium!.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
        SizedBox(width: Spacing.base),
        if (widget.lapsWidget == null)
          TimerCollectionSwitch(widget.collection),
      ],
    );
  }

  Widget timersList() {
    return Center(
      child: ListView.builder(
        itemCount: timers.length,
        scrollDirection: Axis.horizontal,
        // separatorBuilder:
        //     (context, index) => SizedBox(width: Spacing.lg),
        itemBuilder:
            (context, index) =>
                TimerCircularPercentIndicator(
                  timers[index],
                  onTap:
                      widget.onTimerTapped != null
                          ? () {
                            widget.onTimerTapped!(
                              timers[index],
                            );
                          }
                          : null,
                ),
      ),
    );
  }
}

class TimerCollectionSwitch extends ConsumerWidget {
  const TimerCollectionSwitch(this.collection, {super.key});
  final TimerCollection collection;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TimerDatabase notifier = ref.read(
      timerDatabaseProvider.notifier,
    );
    return Switch(
      thumbIcon: WidgetStateProperty.resolveWith(
        (states) => const Icon(Icons.loop),
      ),
      value: collection.isInfinite,
      onChanged: (val) {
        notifier.setCollection(
          collection.copyWith(isInfinite: val),
        );
      },
    );
  }
}
