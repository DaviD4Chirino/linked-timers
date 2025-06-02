import 'package:flutter/material.dart';
import 'package:linked_timers/extensions/string_extensions.dart';
import 'package:linked_timers/models/abstracts/spacing.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:linked_timers/screens/new_collection_screen.dart';

class EditTimerForm extends StatefulWidget {
  const EditTimerForm({
    super.key,
    required this.onSubmit,
    this.timer,
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

  final Timer? timer;

  final String initialLabel;
  final int initialHours;
  final int initialMinutes;
  final int initialSeconds;

  @override
  State<EditTimerForm> createState() => _EditTimerFormState();
}

class _EditTimerFormState extends State<EditTimerForm> {
  late TextEditingController timerLabelController =
      TextEditingController(text: widget.timer?.label);
  late TextEditingController hoursController = TextEditingController(
    text: widget.timer?.hours.toString(),
  );
  late TextEditingController minutesController =
      TextEditingController(text: widget.timer?.minutes.toString());
  late TextEditingController secondsController =
      TextEditingController(text: widget.timer?.seconds.toString());

  String quickControllerTernary(
    TextEditingController? controller,
    String fallback,
  ) {
    print(controller);
    print(fallback);
    if (controller != null && controller.text.isNotEmpty) {
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
    timerLabelController.dispose();
    hoursController.dispose();
    minutesController.dispose();
    secondsController.dispose();
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
          controller:
              widget.timerLabelController ?? timerLabelController,
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
                controller: widget.hoursController ?? hoursController,
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
                controller:
                    widget.minutesController ?? minutesController,
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
                controller:
                    widget.secondsController ?? secondsController,
              ),
            ), //* Seconds
          ],
        ),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {
              if (widget.timer != null) {
                widget.onSubmit(
                  Timer(
                    label: quickControllerTernary(
                      timerLabelController,
                      widget.timer!.label,
                    ),
                    hours:
                        quickControllerTernary(
                          hoursController,
                          widget.timer!.hours.toString(),
                        ).toInt(),

                    minutes:
                        quickControllerTernary(
                          minutesController,
                          widget.timer!.minutes.toString(),
                        ).toInt(),

                    seconds:
                        quickControllerTernary(
                          secondsController,
                          widget.timer!.seconds.toString(),
                        ).toInt(),
                  ),
                );
                return;
              }

              widget.onSubmit(
                Timer(
                  label: quickControllerTernary(
                    widget.timerLabelController ??
                        timerLabelController,
                    "News Timer",
                  ),
                  hours:
                      quickControllerTernary(
                        widget.hoursController ?? hoursController,
                        "0",
                      ).toInt(),

                  minutes:
                      quickControllerTernary(
                        widget.minutesController ?? minutesController,
                        "0",
                      ).toInt(),

                  seconds:
                      quickControllerTernary(
                        widget.secondsController ?? secondsController,
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
