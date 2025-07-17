import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:linked_timers/models/abstracts/spacing.dart';
import 'package:linked_timers/models/abstracts/utils.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:linked_timers/widgets/timer_circular_percent_indicator.dart';

/// Not actually a ListTile
class TimerDisplayTile extends StatefulWidget {
  const TimerDisplayTile(
    this.timer, {
    super.key,
    this.editable = false,
    this.onTap,
  });
  final bool editable;
  final Timer timer;
  final void Function(Timer timer)? onTap;

  @override
  State<TimerDisplayTile> createState() =>
      _TimerDisplayTileState();
}

class _TimerDisplayTileState extends State<TimerDisplayTile> {
  @override
  void didUpdateWidget(covariant TimerDisplayTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Compare the old and new timer's timeAsMilliseconds
    if (oldWidget.timer.timeAsMilliseconds !=
        widget.timer.timeAsMilliseconds) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      child: SizedBox(
        height: 70,
        child: LayoutGrid(
          areas: """
      leading title trailing
      leading switch trailing
      """,
          columnSizes: [80.px, 1.fr, 70.px],
          rowSizes: [1.fr, 1.fr],
          children: [
            TimerCircularPercentIndicator(
              widget.timer.stopWatch,
              onTap:
                  widget.onTap != null
                      ? () {
                        widget.onTap!(widget.timer);
                        setState(() {});
                      }
                      : null,
            ).inGridArea("leading"),
            TextField(
              onChanged: (value) {
                widget.timer.label = value;
              },
              decoration: InputDecoration.collapsed(
                border: UnderlineInputBorder(),
                hintText: widget.timer.label,
              ),
            ).inGridArea("title"),
            Switch(
              value: widget.timer.notify,
              onChanged: (value) {
                setState(() {
                  widget.timer.notify = value;
                });
              },
              thumbIcon: WidgetStatePropertyAll(
                Icon(Icons.notifications_active_rounded),
              ),
            ).inGridArea("switch"),
            Center(
              child: Handle(
                child: Icon(
                  Icons.drag_handle_rounded,
                  size: Spacing.iconXXl,
                ),
              ),
            ).inGridArea("trailing"),
          ],
        ),
      ),
    );

    /* SizedBox(
      height: 80,
      child: Row(
        children: [
          TimerCircularPercentIndicator(widget.timer.stopWatch),
          SizedBox(width: Spacing.base),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.timer.label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
              Switch(value: false, onChanged: (value) {}),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu_rounded),
          ),
        ],
      ),
    ); */
  }
}
