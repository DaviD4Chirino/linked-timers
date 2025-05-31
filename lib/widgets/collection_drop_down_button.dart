import 'package:flutter/material.dart';
import 'package:linked_timers/models/timer_collection.dart';
import 'package:linked_timers/widgets/reusables/text_icon.dart';

class CollectionDropDownButton extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {},
      itemBuilder: (BuildContext context) => entries,
      offset: Offset(5, 35),
      icon: Icon(Icons.more_horiz),
    );
  }
}
