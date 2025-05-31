import 'package:flutter/material.dart';
import 'package:linked_timers/models/abstracts/spacing.dart';
import 'package:linked_timers/widgets/timer_circular_percent_indicator.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimersList extends StatelessWidget {
  const TimersList(
    this.stopWatches, {
    super.key,
    this.currentTimerIndex,
    this.itemScrollController,
    this.scrollOffsetController,
    this.itemPositionsListener,
    this.scrollOffsetListener,
    this.onTimerTapped,
    this.onTimerVisibilityChanged,
  });

  final int? currentTimerIndex;

  final List<StopWatchTimer> stopWatches;
  final ItemScrollController? itemScrollController;
  final ScrollOffsetController? scrollOffsetController;
  final ItemPositionsListener? itemPositionsListener;
  final ScrollOffsetListener? scrollOffsetListener;

  final void Function(StopWatchTimer timer)? onTimerTapped;
  final void Function(double visibleFraction, int index)?
  onTimerVisibilityChanged;

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.separated(
      physics: BouncingScrollPhysics(),
      itemCount: stopWatches.length,
      scrollDirection: Axis.horizontal,

      itemScrollController: itemScrollController,
      scrollOffsetController: scrollOffsetController,
      itemPositionsListener: itemPositionsListener,
      scrollOffsetListener: scrollOffsetListener,
      separatorBuilder: (context, index) {
        return SizedBox(width: Spacing.xs);
      },
      itemBuilder: (context, index) {
        return TimerCircularPercentIndicator(
          stopWatches[index],
          onTap:
              onTimerTapped != null
                  ? () {
                    onTimerTapped!(stopWatches[index]);
                  }
                  : null,
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
