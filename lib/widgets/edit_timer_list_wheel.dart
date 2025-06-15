import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:linked_timers/widgets/number_scroll_wheel.dart';

class EditTimerListWheel extends StatefulWidget {
  const EditTimerListWheel({
    super.key,
    this.onChanged,
    this.timer,
  });

  final void Function(
    String label,
    int hours,
    int minutes,
    int seconds,
    bool notify,
  )?
  onChanged;

  /// If you pass a timer, it will use it as a base for the values.
  /// Perfect for editing.
  final Timer? timer;

  @override
  State<EditTimerListWheel> createState() =>
      _EditTimerListWheelState();
}

class _EditTimerListWheelState
    extends State<EditTimerListWheel> {
  late final TextEditingController timerNameController;
  late final FixedExtentScrollController hoursController;
  late final FixedExtentScrollController minutesController;
  late final FixedExtentScrollController secondsController;

  late Timer timer;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  bool notify = true;

  final double itemHeight = 50;

  @override
  void initState() {
    super.initState();
    setState(() {
      timer = Timer(
        label: widget.timer?.label ?? "New Timer",
        hours: widget.timer?.hours ?? 0,
        minutes: widget.timer?.minutes ?? 0,
        seconds: widget.timer?.seconds ?? 0,
        notify: widget.timer?.notify ?? false,
      );
      hours = timer.hours;
      minutes = timer.minutes;
      seconds = timer.seconds;

      notify = timer.notify;

      timerNameController = TextEditingController(
        text: timer.label,
      );

      hoursController = FixedExtentScrollController(
        initialItem: hours,
      );
      minutesController = FixedExtentScrollController(
        initialItem: minutes,
      );
      secondsController = FixedExtentScrollController(
        initialItem: seconds,
      );
    });
    _onChanged();
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
      notify,
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
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: timerNameController,
                onChanged: (value) {
                  _onChanged();
                },
                decoration: InputDecoration.collapsed(
                  hintText: "Edit Timer Name",
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
            Switch(
              value: notify,
              onChanged: (value) {
                setState(() {
                  notify = value;
                });
                _onChanged();
              },
              thumbIcon: WidgetStateProperty.resolveWith(
                (states) =>
                    const Icon(Icons.notifications_active),
              ),
            ),
          ],
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              child: Container(
                height: 30,
                width: mediaQuery.width,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
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
                    itemHeight: itemHeight,
                    label: Text(
                      "Hours",
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ),
                Text(":", style: theme.textTheme.titleLarge),
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
                    itemHeight: itemHeight,
                    label: Text(
                      "Minutes",
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ),
                Text(":", style: theme.textTheme.titleLarge),
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
                    itemHeight: itemHeight,
                    label: Text(
                      "Seconds",
                      style: theme.textTheme.bodySmall,
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
