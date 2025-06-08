import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:linked_timers/widgets/number_scroll_wheel.dart';

class EditTimerListWheel extends StatefulWidget {
  const EditTimerListWheel({super.key, this.onChanged, this.timer});

  final void Function(
    String label,
    int hours,
    int minutes,
    int seconds,
  )?
  onChanged;

  /// If you pass a timer, it will use it as a base for the values.
  /// Perfect for editing.
  final Timer? timer;

  @override
  State<EditTimerListWheel> createState() =>
      _EditTimerListWheelState();
}

class _EditTimerListWheelState extends State<EditTimerListWheel> {
  late final TextEditingController timerNameController;
  late final FixedExtentScrollController hoursController;
  late final FixedExtentScrollController minutesController;
  late final FixedExtentScrollController secondsController;

  late Timer timer;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer(
      label: widget.timer?.label ?? "New Timer",
      hours: widget.timer?.hours ?? 0,
      minutes: widget.timer?.minutes ?? 0,
      seconds: widget.timer?.seconds ?? 0,
    );
    hours = timer.hours;
    minutes = timer.minutes;
    seconds = timer.seconds;

    timerNameController = TextEditingController(text: timer.label);

    hoursController = FixedExtentScrollController(initialItem: hours);
    minutesController = FixedExtentScrollController(
      initialItem: minutes,
    );
    secondsController = FixedExtentScrollController(
      initialItem: seconds,
    );
  }

  /*  @override
  void didUpdateWidget(EditTimerListWheel oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the timer changes, update values & controller positions
    if (widget.timer != oldWidget.timer && widget.timer != null) {
      timer = Timer(
        label: widget.timer!.label,
        hours: widget.timer!.hours,
        minutes: widget.timer!.minutes,
        seconds: widget.timer!.seconds,
      );
      timerNameController.text = widget.timer!.label;

      hoursController.jumpToItem(widget.timer!.hours);
      minutesController.jumpToItem(widget.timer!.minutes);
      secondsController.jumpToItem(widget.timer!.seconds);

      hours = timer.hours;
      minutes = timer.minutes;
      seconds = timer.seconds;
    }
  }
 */
  @override
  void dispose() {
    hoursController.dispose();
    minutesController.dispose();
    secondsController.dispose();
    timerNameController.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (widget.onChanged == null) return;
    widget.onChanged!(
      timerNameController.text.isEmpty
          ? "New Timer"
          : timerNameController.text,
      hours,
      minutes,
      seconds,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size mediaQuery = MediaQuery.sizeOf(context);

    return LayoutGrid(
      columnSizes: [1.fr],
      rowSizes: [25.px, 1.fr],
      children: [
        TextField(
          controller: timerNameController,
          onChanged: (value) {
            _onChanged();
          },
          decoration: InputDecoration.collapsed(
            hintText: "Edit Timer Name",
            border: UnderlineInputBorder(),
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              child: Container(
                height: 40,
                width: mediaQuery.width,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: NumberScrollWheel(
                    onSelectedItemChanged: (index) {
                      setState(() {
                        hours = index;
                        timer.hours = index;
                        _onChanged();
                      });
                    },
                    scrollController: hoursController,
                    zeroBased: true,
                    count: 25,
                    itemHeight: 60,
                    label: Text(
                      "Hours",
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ),
                Text(":", style: theme.textTheme.bodyLarge),
                Expanded(
                  child: NumberScrollWheel(
                    onSelectedItemChanged: (index) {
                      setState(() {
                        minutes = index;
                        timer.minutes = index;
                        _onChanged();
                      });
                    },
                    scrollController: minutesController,
                    zeroBased: true,
                    count: 61,
                    itemHeight: 60,
                    label: Text(
                      "Minutes",
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ),
                Text(":", style: theme.textTheme.bodyLarge),
                Expanded(
                  child: NumberScrollWheel(
                    onSelectedItemChanged: (index) {
                      setState(() {
                        seconds = index;
                        timer.seconds = index;
                        _onChanged();
                      });
                    },
                    scrollController: secondsController,
                    zeroBased: true,
                    count: 61,
                    itemHeight: 60,
                    label: Text(
                      "Seconds",
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
