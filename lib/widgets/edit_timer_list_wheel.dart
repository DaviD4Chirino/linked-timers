import 'package:flutter/material.dart';
import 'package:linked_timers/widgets/number_scroll_wheel.dart';

class EditTimerListWheel extends StatefulWidget {
  const EditTimerListWheel({super.key});

  @override
  State<EditTimerListWheel> createState() =>
      _EditTimerListWheelState();
}

class _EditTimerListWheelState extends State<EditTimerListWheel> {
  final _scrollController = FixedExtentScrollController();

  final List<Text> list = List.generate(
    60,
    (index) =>
        Text("${index + 1}", style: const TextStyle(fontSize: 24)),
  );

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size mediaQuery = MediaQuery.sizeOf(context);
    return Stack(
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
                zeroBased: true,
                count: 24,
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
                zeroBased: true,
                count: 60,
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
                zeroBased: true,
                count: 60,
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
    );
  }
}
