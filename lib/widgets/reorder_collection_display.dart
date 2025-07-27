import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_timers/models/abstracts/spacing.dart';
import 'package:linked_timers/models/timer_collection.dart';
import 'package:linked_timers/providers/timer_database.dart';
import 'package:linked_timers/widgets/timer_collection_control.dart';

class ReorderCollectionDisplay extends ConsumerStatefulWidget {
  const ReorderCollectionDisplay({super.key});

  @override
  ConsumerState<ReorderCollectionDisplay> createState() =>
      _ReorderCollectionDisplayState();
}

class _ReorderCollectionDisplayState
    extends ConsumerState<ReorderCollectionDisplay> {
  List<TimerCollection> get timerDatabase =>
      ref.watch(timerDatabaseProvider);
  TimerDatabase get timerDatabaseNotifier =>
      ref.read(timerDatabaseProvider.notifier);

  @override
  Widget build(BuildContext context) {
    return ImplicitlyAnimatedReorderableList.separated(
      items: timerDatabase,
      padding: EdgeInsets.symmetric(horizontal: Spacing.xxl),
      itemBuilder: (context, animation, item, i) {
        return Reorderable(
          key: Key(item.id),
          child: TimerCollectionControl(
            item,
            buttonWidget: Handle(
              child: Center(
                child: IconButton.outlined(
                  onPressed: () {},
                  icon: Icon(Icons.drag_handle),
                  iconSize: Spacing.iconXXl,
                ),
              ),
            ),
          ),
        );
      },
      areItemsTheSame: (oldItem, newItem) => oldItem == newItem,
      separatorBuilder: (context, index) => Divider(),
      onReorderFinished: onReorderFinished,
    );
  }

  void onReorderFinished(
    TimerCollection item,
    int from,
    int to,
    List<TimerCollection> newItems,
  ) {}
}
