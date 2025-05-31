import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_timers/models/abstracts/utils.dart';
import 'package:linked_timers/models/timer_collection.dart';
import 'package:linked_timers/providers/timer_database.dart';
import 'package:linked_timers/widgets/reusables/text_icon.dart';

class CollectionDropDownButton extends ConsumerWidget {
  CollectionDropDownButton(this.collection, {super.key});

  final TimerCollection collection;

  final entries = [
    PopupMenuItem(
      value: "edit",
      child: TextIcon(icon: Icon(Icons.edit), text: Text("Edit")),
    ),
    PopupMenuItem(
      value: "delete",
      child: TextIcon(icon: Icon(Icons.delete), text: Text("Delete")),
    ),
  ];

  void onDelete(
    BuildContext context,
    TimerDatabase databaseNotifier,
  ) async {
    bool consented = await Utils.consentAlert(
      context,
      titleText: "${collection.label} will be removed",
      contentText: "This action cannot be undone",
    );
    if (!consented) return;

    databaseNotifier.deleteCollection(collection.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final databaseNotifier = ref.read(timerDatabaseProvider.notifier);

    return PopupMenuButton<String>(
      onSelected: (String value) async {
        if (value == "delete") {
          onDelete(context, databaseNotifier);
        }
      },
      itemBuilder: (BuildContext context) => entries,
      offset: Offset(5, 35),
      icon: Icon(Icons.more_horiz),
    );
  }
}
