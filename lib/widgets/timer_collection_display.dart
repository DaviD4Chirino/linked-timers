import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/models/timer_collection.dart';
import 'package:myapp/widgets/timer_display.dart';

class TimerCollectionDisplay extends StatefulWidget {
  const TimerCollectionDisplay(this.collection, {super.key});

  final TimerCollection collection;

  @override
  State<TimerCollectionDisplay> createState() => _TimerCollectionDisplayState();
}

class _TimerCollectionDisplayState extends State<TimerCollectionDisplay> {
  int laps = 0;

  bool get isInfinite => widget.collection.isInfinite;
  int get maxLaps => widget.collection.laps;
  List<Timer> get timers => widget.collection.timers;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isInfinite ? "Laps: ∞" : "Laps: $laps/$maxLaps",
                style: theme.textTheme.titleLarge,
              ),
              Switch(
                thumbIcon: WidgetStateProperty.resolveWith(
                  (states) => const Icon(Icons.loop),
                ),
                value: isInfinite,
                onChanged: (val) {
                  widget.collection.isInfinite = val;
                  // setState(() {
                  //   infiniteLoops = val;
                  // });
                },
              ),
            ],
          ),
          Wrap(
            spacing: 12,
            runSpacing: 16,
            children:
                timers.map((timer) {
                  return TimerDisplay(timer);
                }).toList(),
          ),
        ],
      ),
    );
  }
}
