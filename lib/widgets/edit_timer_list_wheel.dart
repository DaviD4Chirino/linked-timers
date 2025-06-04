import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:linked_timers/widgets/number_scroll_wheel.dart';

class EditTimerListWheel extends StatefulWidget {
  const EditTimerListWheel({super.key, this.onChanged});

  final void Function(
    String label,
    int hours,
    int minutes,
    int seconds,
  )?
  onChanged;

  @override
  State<EditTimerListWheel> createState() =>
      _EditTimerListWheelState();
}

class _EditTimerListWheelState extends State<EditTimerListWheel> {
  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController();
  final TextEditingController _timerNameController =
      TextEditingController();

  Timer timer = Timer();

  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  void _onChanged() {
    if (widget.onChanged == null) return;
    widget.onChanged!(
      _timerNameController.text.isEmpty
          ? "New Timer"
          : _timerNameController.text,
      hours,
      minutes,
      seconds,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timerNameController.dispose();
    super.dispose();
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
          controller: _timerNameController,
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
                      hours = index;
                      timer.hours = index;
                      _onChanged();
                    },
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
                      minutes = index;
                      timer.minutes = index;
                      _onChanged();
                    },
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
                      seconds = index;
                      timer.seconds = index;
                      _onChanged();
                    },
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

    //   Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       Expanded(
    //         child: TextField(
    //           decoration: InputDecoration.collapsed(
    //             hintText: "Edit Timer Name",
    //             border: UnderlineInputBorder(),
    //           ),
    //         ),
    //       ),

    //       Expanded(
    //         flex: 5,
    //         child: Stack(
    //           alignment: Alignment.center,
    //           children: [
    //             Positioned(
    //               child: Container(
    //                 height: 40,
    //                 width: mediaQuery.width,
    //                 decoration: BoxDecoration(
    //                   color: theme.colorScheme.surfaceContainer,
    //                   borderRadius: BorderRadius.all(
    //                     Radius.circular(50),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             Row(
    //               children: [
    //                 Expanded(
    //                   child: NumberScrollWheel(
    //                     onSelectedItemChanged: (index) {
    //                       hours = index;
    //                       timer.hours = index;
    //                       _onChanged();
    //                     },
    //                     zeroBased: true,
    //                     count: 25,
    //                     itemHeight: 60,
    //                     label: Text(
    //                       "Hours",
    //                       style: theme.textTheme.bodyLarge,
    //                     ),
    //                   ),
    //                 ),
    //                 Text(":", style: theme.textTheme.bodyLarge),
    //                 Expanded(
    //                   child: NumberScrollWheel(
    //                     onSelectedItemChanged: (index) {
    //                       minutes = index;
    //                       timer.minutes = index;
    //                       _onChanged();
    //                     },
    //                     zeroBased: true,
    //                     count: 61,
    //                     itemHeight: 60,
    //                     label: Text(
    //                       "Minutes",
    //                       style: theme.textTheme.bodyLarge,
    //                     ),
    //                   ),
    //                 ),
    //                 Text(":", style: theme.textTheme.bodyLarge),
    //                 Expanded(
    //                   child: NumberScrollWheel(
    //                     onSelectedItemChanged: (index) {
    //                       seconds = index;
    //                       timer.seconds = index;
    //                       _onChanged();
    //                     },
    //                     zeroBased: true,
    //                     count: 61,
    //                     itemHeight: 60,
    //                     label: Text(
    //                       "Seconds",
    //                       style: theme.textTheme.bodyLarge,
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   );
    // }
  }
}
