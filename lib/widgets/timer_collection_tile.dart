import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:linked_timers/models/timer_collection.dart';
import 'package:linked_timers/widgets/timers_list.dart';

class TimerCollectionTile extends StatelessWidget {
  const TimerCollectionTile(this.collection, {super.key});
  final TimerCollection collection;

  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      columnSizes: [1.fr],
      rowSizes: [40.px, 1.fr],
      children: [
        Text(
          collection.label,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        TimersList.simpleList(collection.timers),
      ],
    );
  }
}
