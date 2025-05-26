import 'package:flutter/material.dart';
import 'package:linked_timers/models/abstracts/spacing.dart';

class Section extends StatelessWidget {
  const Section({
    super.key,
    required this.children,
    this.title,
    this.actions,
  });

  final List<Widget> children;
  final Widget? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: Spacing.base,
        right: Spacing.base,
        bottom: Spacing.xxl,
      ),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.baseline,
        mainAxisSize: MainAxisSize.min,

        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        textBaseline: TextBaseline.alphabetic,
        /*
        spacing: Spacing.base, */
        children: [
          Header(title: title, actions: actions),
          ...children,
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.title,
    required this.actions,
  });

  final Widget? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Row(
      textBaseline: TextBaseline.alphabetic,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      spacing: Spacing.base,
      children: [
        if (title != null) Expanded(child: title as Widget),
        ...?actions,
      ],
    );
  }
}
