import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_timers/models/abstracts/utils.dart';
import 'package:linked_timers/providers/timer_database.dart';

class DeleteDatabaseButton extends ConsumerWidget {
  const DeleteDatabaseButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TimerDatabase timerDatabaseNotifier = ref.read(
      timerDatabaseProvider.notifier,
    );

    Future deleteDatabase() async {
      if (await Utils.consentAlert(
        context,
        titleText: "You will delete all your Timers",
        contentText: "This action is irreversible",
      )) {
        timerDatabaseNotifier.flushDatabase();
        Navigator.pop(context);
      }
    }

    return OutlinedButton.icon(
      onPressed: deleteDatabase,
      icon: Icon(Icons.delete_forever_rounded),
      label: Text("Delete ALL Timers?"),
      /* style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          theme.colorScheme.error,
        ),
      ), */
    );
  }
}
