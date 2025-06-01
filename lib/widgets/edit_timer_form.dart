import 'package:flutter/material.dart';
import 'package:linked_timers/extensions/string_extensions.dart';
import 'package:linked_timers/models/abstracts/spacing.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:linked_timers/screens/new_collection_screen.dart';

class EditTimerForm extends StatefulWidget {
  const EditTimerForm({
    super.key,
    required this.onSubmit,
    this.timerLabelController,
    this.hoursController,
    this.minutesController,
    this.secondsController,
    this.initialLabel = "New Timer",
    this.initialHours = 0,
    this.initialMinutes = 0,
    this.initialSeconds = 0,
  });

  /* final void Function(
    String label,
    int hours,
    int minutes,
    int seconds,
  )
  onSubmit; */
  final void Function(Timer timer) onSubmit;

  final TextEditingController? timerLabelController;
  final TextEditingController? hoursController;
  final TextEditingController? minutesController;
  final TextEditingController? secondsController;

  final String initialLabel;
  final int initialHours;
  final int initialMinutes;
  final int initialSeconds;

  @override
  State<EditTimerForm> createState() => _EditTimerFormState();
}

class _EditTimerFormState extends State<EditTimerForm> {
  String quickControllerTernary(
    TextEditingController? controller,
    String fallback,
  ) {
    if (controller != null) {
      return controller.text;
    }
    return fallback;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: Spacing.base,
      children: [
        TextFormField(
          controller: widget.timerLabelController,
          decoration: InputDecoration(
            label: Text("Insert a Timer Name"),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          spacing: Spacing.base,
          children: [
            Expanded(
              child: NumberTextField(
                controller: widget.hoursController,
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
                controller: widget.minutesController,
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
                controller: widget.secondsController,
              ),
            ), //* Seconds
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {
              widget.onSubmit(
                Timer(
                  label: quickControllerTernary(
                    widget.timerLabelController,
                    "News Timer",
                  ),
                  hours:
                      quickControllerTernary(
                        widget.hoursController,
                        "0",
                      ).toInt(),

                  minutes:
                      quickControllerTernary(
                        widget.minutesController,
                        "0",
                      ).toInt(),

                  seconds:
                      quickControllerTernary(
                        widget.secondsController,
                        "0",
                      ).toInt(),
                ),
              );
            },
            child: Text("Add Timer"),
          ),
        ),
      ],
    );
  }
}
