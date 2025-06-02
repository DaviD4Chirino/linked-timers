import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_timers/extensions/string_extensions.dart';
import 'package:linked_timers/models/abstracts/spacing.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:linked_timers/models/timer_collection.dart';
import 'package:linked_timers/providers/timer_database.dart';
import 'package:linked_timers/widgets/edit_timer_form.dart';
import 'package:linked_timers/widgets/timer_circular_percent_indicator.dart';
import 'package:linked_timers/widgets/timer_collection_control.dart';
import 'package:linked_timers/widgets/timers_list.dart';
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
  int? hours;
  int? minutes;
  int? seconds;

  int timersAdded = 0;

  TextEditingController minutesController = TextEditingController();
  TextEditingController secondsController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  TextEditingController timerLabelController =
      TextEditingController();

  TimerCollection collection = TimerCollection(
    timers: [],
    label: "Collection Name",
  );

  Timer? selectedTimer;

  TimerDatabase get timerNotifier =>
      ref.watch(timerDatabaseProvider.notifier);

  void addCollection() {
    timerNotifier.addCollection(collection);
    Navigator.pop(context);
  }

  void onTimerTapped(Timer timer) async {
    List<Timer> timers = [...collection.timers];

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit timer"),
          content: EditTimerForm(
            timer: timer,
            onSubmit: (timer_) {
              setState(() {
                int index = timers.indexWhere(
                  (element) => element.id == timer.id,
                );
                if (index == -1) return;
                timers[index] = timer_;
                collection = collection.copyWith(timers: timers);
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void addTimer(Timer newTimer) {
    setState(() {
      List<Timer> timers = [...collection.timers];

      /* Timer newTimer = Timer(
        label: timerLabel ?? "New Timer ${timersAdded + 1}",
        hours: hours ?? 0,
        minutes: minutes ?? 0,
        seconds: seconds ?? 0,
      ); */

      /* if (selectedTimer != null) {
        int index = timers.indexWhere(
          (element) => element == selectedTimer,
        );
        if (index == -1) return;
        timers[index] = newTimer;
        collection.timers = timers;
        return;
      } */

      timers.add(newTimer);
      collection = collection.copyWith(timers: timers);
      timersAdded++;
    });
  }

  @override
  void dispose() {
    hoursController.dispose();
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              spacing: Spacing.base,
              children: [titleWidget(), lapsWidgets()],
            ),

            //TODO: Make a "custom" timersList so taps works properly, maybe even as buttons?
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: collection.timers.length,
                itemBuilder:
                    (context, index) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TimerCircularPercentIndicator(
                          collection.timers[index].toStopWatchTimer(),
                          onTap: () {
                            onTimerTapped(collection.timers[index]);
                          },
                        ),
                        SizedBox(
                          width: 90,
                          child: Text(
                            collection.timers[index].label,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
              ),
            ),

            Expanded(
              child: SizedBox(
                width: min(mediaQuery.width - Spacing.xl, 350),
                height: double.infinity,
                child: ListView(
                  children: [
                    EditTimerForm(
                      onSubmit: addTimer,
                      /* minutesController: minutesController,
                      secondsController: secondsController,
                      hoursController: hoursController,
                      timerLabelController: timerLabelController, */
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

  TextFormField timerLabelField() {
    return TextFormField(
      controller: timerLabelController,
      onChanged: (value) {
        setState(() {
          timerLabel = value;
        });
      },
      decoration: InputDecoration(label: Text("Insert a Timer Name")),
    );
  }

  Center buttonWidget() {
    return Center(
      child: IconButton.filled(
        onPressed: collection.timers.isEmpty ? null : addCollection,
        icon: Icon(Icons.send),
        iconSize: Spacing.iconXl,
      ),
    );
  }

  Expanded lapsWidgets() {
    return Expanded(
      child: TextFormField(
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          MinValueInputFormatter(0),
        ],
        onChanged: (value) {
          setState(() {
            collectionLaps = value.toInt(fallback: 1);
            collection.laps = value.toInt(fallback: 1);
          });
        },
        decoration: InputDecoration.collapsed(
          border: UnderlineInputBorder(),
          hintText: "Nro of laps",
        ),
      ),
    );
  }

  Expanded titleWidget() {
    return Expanded(
      flex: 2,
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            collectionName = value;
            collection.label = collectionName ?? "New Collection";
          });
        },
        decoration: InputDecoration.collapsed(
          border: UnderlineInputBorder(),
          hintText: collection.label,
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
            controller: hoursController,
            onChanged: (value) {
              setState(() {
                hours = value.toInt(fallback: 0);
              });
            },
            maxChars: 24,
          ), //* Hours
        ),
        Text(
          ":",
          style: TextStyle(
            fontSize: theme.textTheme.displaySmall!.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
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
            fontSize: theme.textTheme.displaySmall!.fontSize,
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
    this.maxChars = 60,
    super.key,
  });
  final Function(String value)? onChanged;
  final TextEditingController? controller;
  final int maxChars;

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
        MaxValueInputFormatter(maxChars),
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
        selection: TextSelection.collapsed(offset: maxStr.length),
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
        selection: TextSelection.collapsed(offset: minStr.length),
      );
    }
    return newValue;
  }
}
