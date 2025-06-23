import 'package:flutter/material.dart';
import 'package:linked_timers/models/abstracts/spacing.dart';

class Instructions extends StatelessWidget {
  const Instructions({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: Spacing.xxxl,
            left: Spacing.xxxl,
            right: Spacing.xxxl,
          ),
          child: Center(
            child: Text(
              "Use the button below to start adding collections of timers",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ),
        Image.asset(
          "assets/images/overhead.png",
          width: 150,
          height: 150,
          color: theme.colorScheme.onSurface.withAlpha(100),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
