import 'package:flutter/material.dart';
import 'package:linked_timers/models/abstracts/utils.dart';
import 'package:linked_timers/services/notification_service.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CollectionTotalProgress extends StatelessWidget {
  const CollectionTotalProgress(this.stopWatch, {super.key});

  final StopWatchTimer stopWatch;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return StreamBuilder(
      stream: stopWatch.rawTime,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text(snapshot.error.toString());
        }

        return LinearProgressIndicator(
          value: Utils.getPercentage(
            snapshot.data!,
            0,
            stopWatch.initialPresetTime,
          ),
          color: theme.colorScheme.secondary,
        );
      },
    );
  }
}
