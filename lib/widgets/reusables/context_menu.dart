import 'package:contextmenu/contextmenu.dart';
import 'package:flutter/material.dart';

class ContextMenu extends StatelessWidget {
  const ContextMenu({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ContextMenuArea(
      width: 180,
      verticalPadding: 16,
      builder:
          (context) => [
            ListTile(
              title: Text('Option 1'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Whatever')),
                );
              },
            ),
          ],
      child: child,
    );
  }
}
