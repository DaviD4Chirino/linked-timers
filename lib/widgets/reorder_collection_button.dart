import 'package:flutter/material.dart';

class ReorderCollectionsButton extends StatefulWidget {
  const ReorderCollectionsButton({
    super.key,
    required this.onPressed,
    this.reordering = false,
  });

  final void Function()? onPressed;

  final bool reordering;

  @override
  State<ReorderCollectionsButton> createState() =>
      _ReorderCollectionsButtonState();
}

class _ReorderCollectionsButtonState
    extends State<ReorderCollectionsButton> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return IconButton(
      onPressed: widget.onPressed,
      color: widget.reordering
          ? theme.colorScheme.primary
          : null,
      icon: Icon(Icons.sort_rounded),
    );
  }
}
