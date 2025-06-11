import 'package:flutter/material.dart';

class TimerEditMenu<T> extends StatelessWidget {
  const TimerEditMenu({
    super.key,
    required this.itemBuilder,
    this.onSelected,
    this.offset,
    this.icon,
  });

  final void Function(T)? onSelected;
  final List<PopupMenuEntry<T>> Function(BuildContext)
  itemBuilder;
  final Offset? offset;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      onSelected: onSelected,
      itemBuilder: itemBuilder,
      offset: offset ?? Offset(5, 35),
      icon: icon ?? Icon(Icons.more_horiz),
    );
  }
}
