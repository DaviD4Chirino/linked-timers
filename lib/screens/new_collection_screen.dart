import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_timers/extensions/string_extensions.dart';
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
  String? collectionName;
  int? collectionLaps;
  String? timerLabel;
  int? minutes;
  int? seconds;

  TextEditingController minutesController =
      TextEditingController();
  TextEditingController secondsController =
      TextEditingController();
  TextEditingController timerLabelController =
      TextEditingController();

  TimerCollection collection = TimerCollection(
    timers: [
      /* Timer(
        label: "Timer Label",
        mode: StopWatchMode.countDown,
        presetMillisecond: StopWatchTimer.getMilliSecFromSecond(5),
      ), */
    ],
    label: "Collection Name",
  );

  Timer? selectedTimer;

  onTimerTapped(Timer timer) {
    setState(() {
      selectedTimer = timer;
      int initialPresetTime = timer.initialPresetTime;

      int totalSeconds = initialPresetTime ~/ 1000;
      int hours = totalSeconds ~/ 3600;
      int minutes = (totalSeconds % 3600) ~/ 60;
      int seconds = totalSeconds % 60;

      minutesController.text = minutes.toString();
      secondsController.text = seconds.toString();
      timerLabelController.text = timer.label;
    });
  }

  @override
  void dispose() {
    minutesController.dispose();
    secondsController.dispose();
    timerLabelController.dispose();
    super.dispose();
  }

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
          top: Spacing.xxxl,
        ),
        child: Column(
          children: [
            TimerCollectionControl(
              collection,
              onTimerTapped: onTimerTapped,
              titleWidget: Expanded(
                flex: 2,
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      collectionName = value;
                    });
                  },
                  decoration: InputDecoration.collapsed(
                    border: UnderlineInputBorder(),
                    hintText: collection.label,
                  ),
                ),
              ),
              lapsWidget: Expanded(
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      collectionLaps = value.toInt(
                        fallback: 1,
                      );
                    });
                  },
                  decoration: InputDecoration.collapsed(
                    border: UnderlineInputBorder(),
                    hintText: "Nro of laps",
                  ),
                ),
              ),
            ),

            Expanded(
              child: SizedBox(
                width: min(
                  mediaQuery.width - Spacing.xl,
                  250,
                ),
                child: ListView(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment:
                          CrossAxisAlignment.center,
                      spacing: Spacing.base,
                      children: [
                        TextFormField(
                          controller: timerLabelController,
                          onChanged: (value) {
                            setState(() {
                              timerLabel = value;
                            });
                          },
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
                            onPressed: () {
                              setState(() {
                                Timer newTimer = Timer(
                                  label: timerLabel ?? "",
                                  mode:
                                      StopWatchMode
                                          .countDown,
                                  presetMillisecond:
                                      StopWatchTimer.getMilliSecFromMinute(
                                        minutes ?? 0,
                                      ) +
                                      StopWatchTimer.getMilliSecFromSecond(
                                        seconds ?? 0,
                                      ),
                                );

                                collection.timers.add(
                                  newTimer,
                                );
                              });
                            },
                            child: Text("Add"),
                          ),
                        ),
                      ],
                    ),
                  ],
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
        Expanded(
          child: NumberTextField(
            controller: minutesController,
            onChanged: (value) {
              setState(() {
                minutes = value.toInt(fallback: 0);
              });
            },
          ), //* Minutes
        ),
        Text(
          ":",
          style: TextStyle(
            fontSize:
                theme.textTheme.displaySmall!.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: NumberTextField(
            controller: secondsController,
            onChanged: (value) {
              setState(() {
                seconds = value.toInt(fallback: 0);
              });
            },
          ),
        ), //* Seconds
      ],
    );
  }
}

class NumberTextField extends StatelessWidget {
  const NumberTextField({
    this.onChanged,
    this.controller,
    super.key,
  });
  final Function(String value)? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      textAlign: TextAlign.center,
      decoration: InputDecoration(hintText: "00"),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(2),
        MaxValueInputFormatter(60),
        MinValueInputFormatter(0),
      ],
      style: theme.textTheme.displayMedium,
    );
  }
}

class MaxValueInputFormatter extends TextInputFormatter {
  final int max;

  MaxValueInputFormatter(this.max);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    final int? value = int.tryParse(newValue.text);
    if (value != null && value > max) {
      // Return the max value
      final String maxStr = max.toString();
      return TextEditingValue(
        text: maxStr,
        selection: TextSelection.collapsed(
          offset: maxStr.length,
        ),
      );
    }
    return newValue;
  }
}

class MinValueInputFormatter extends TextInputFormatter {
  final int min;

  MinValueInputFormatter(this.min);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    final int? value = int.tryParse(newValue.text);
    if (value != null && value < min) {
      // Return the min value
      final String minStr = min.toString();
      return TextEditingValue(
        text: minStr,
        selection: TextSelection.collapsed(
          offset: minStr.length,
        ),
      );
    }
    return newValue;
  }
}
