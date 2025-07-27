import 'package:flutter/material.dart';
import 'package:linked_timers/models/abstracts/spacing.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:linked_timers/widgets/timer_circular_percent_indicator.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimersList extends StatelessWidget {
  const TimersList(
    this.stopWatches, {
    super.key,
    required this.timers,
    required this.timerListController,
    this.currentTimerIndex,
    /* this.itemScrollController,
    this.scrollOffsetController,
    this.scrollOffsetListener, */
    this.onTimerTapped,
    this.onTimerVisibilityChanged,
  });

  final int? currentTimerIndex;

  final List<StopWatchTimer> stopWatches;
  final List<Timer> timers;
  /* final ItemScrollController? itemScrollController;
  final ScrollOffsetController? scrollOffsetController;
  final ItemPositionsListener? itemPositionsListener;
  final ScrollOffsetListener? scrollOffsetListener; */
  final AutoScrollController timerListController;

  final void Function(StopWatchTimer stopWatch)? onTimerTapped;
  final void Function(double visibleFraction, int index)?
  onTimerVisibilityChanged;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: timers.length,
      scrollDirection: Axis.horizontal,
      controller: timerListController,

      // itemScrollController: itemScrollController,
      // scrollOffsetController: scrollOffsetController,
      // itemPositionsListener: itemPositionsListener,
      // scrollOffsetListener: scrollOffsetListener,
      separatorBuilder: (context, index) {
        return SizedBox(width: Spacing.lg);
      },
      itemBuilder: (context, index) {
        if (index >= timers.length) return SizedBox.shrink();
        return AutoScrollTag(
          key: Key(index.toString()),
          index: index,
          controller: timerListController,
          child: TimerCircularPercentIndicator(
            timers[index].stopWatch,
            key: Key(index.toString()),
            notify: timers[index].notify,
            onTap: onTimerTapped != null
                ? () {
                    onTimerTapped!(stopWatches[index]);
                  }
                : null,
          ),
        );
      },
    );
  }

  static Widget simpleList(List<StopWatchTimer> stopWatches) {
    return ListView.separated(
      itemCount: stopWatches.length,
      scrollDirection: Axis.horizontal,
      separatorBuilder: (context, index) {
        return SizedBox(width: Spacing.lg);
      },
      itemBuilder: (context, index) {
        return TimerCircularPercentIndicator(
          stopWatches[index],
          key: Key(index.toString()),
        );
      },
    );
  }
}

// class TimerCollectionSwitch extends ConsumerWidget {
//   const TimerCollectionSwitch(this.collection, {super.key});
//   final TimerCollection collection;
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Switch(
//       thumbIcon: WidgetStateProperty.resolveWith(
//         (states) => const Icon(Icons.loop),
//       ),
//       value: collection.isInfinite,
//       onChanged: (val) {},
//     );
//   }
// }
