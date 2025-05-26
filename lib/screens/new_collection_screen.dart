import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_timers/models/abstracts/spacing.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:linked_timers/models/timer_collection.dart';
import 'package:linked_timers/widgets/timer_collection_control.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class NewCollectionScreen extends ConsumerStatefulWidget {
  const NewCollectionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewCollectionScreenState();
}

class _NewCollectionScreenState
    extends ConsumerState<NewCollectionScreen> {
  TimerCollection collection = TimerCollection(
    timers: [
      Timer(
        label: "Timer Label",
        mode: StopWatchMode.countDown,
        presetMillisecond:
            StopWatchTimer.getMilliSecFromSecond(5),
      ),
    ],
    label: "Collection Name",
  );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size mediaQuery = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(title: Text("Add a new Collection")),
      body: Padding(
        padding: EdgeInsets.only(
          right: Spacing.xl,
          left: Spacing.xl,
          top: Spacing.lg,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TimerCollectionControl(
              collection,
              titleWidget: Expanded(
                flex: 3,
                child: TextField(
                  decoration: InputDecoration.collapsed(
                    border: UnderlineInputBorder(),
                    hintText: collection.label,
                  ),
                ),
              ),
              lapsWidget: Expanded(
                child: TextField(
                  decoration: InputDecoration.collapsed(
                    border: UnderlineInputBorder(),
                    hintText: "${collection.laps} Lap(s)",
                  ),
                ),
              ),
            ),

            Expanded(
              child: Center(
                child: SizedBox(
                  width: min(
                    mediaQuery.width - Spacing.xl,
                    250,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    crossAxisAlignment:
                        CrossAxisAlignment.center,
                    spacing: Spacing.base,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          label: Text(
                            "Insert a Timer Name",
                          ),
                        ),
                      ),
                      timersInputs(theme),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {},
                          child: Text("Add"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row timersInputs(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      spacing: Spacing.base,
      children: [
        Expanded(child: NumberTextField()),
        Text(
          ":",
          style: TextStyle(
            fontSize:
                theme.textTheme.displaySmall!.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(child: NumberTextField()),
      ],
    );
  }
}

class NumberTextField extends StatelessWidget {
  const NumberTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return TextField(
      style: theme.textTheme.displayMedium,
      textAlign: TextAlign.center,
      decoration: InputDecoration(hintText: "00"),
    );
  }
}
