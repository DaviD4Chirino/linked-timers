import 'package:flutter/material.dart';
import 'package:linked_timers/models/abstracts/spacing.dart';

class TextIcon extends StatelessWidget {
  const TextIcon({required this.icon, required this.text, super.key});
  final Icon icon;
  final Text text;

  @override
  Widget build(BuildContext context) {
    return Row(children: [icon, SizedBox(width: Spacing.sm), text]);
  }
}
