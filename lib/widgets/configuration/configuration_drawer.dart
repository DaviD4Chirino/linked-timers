import 'package:flutter/material.dart';
import 'package:linked_timers/models/abstracts/spacing.dart';
import 'package:linked_timers/widgets/configuration/delete_database_button.dart';
import 'package:linked_timers/widgets/configuration/run_in_background_button.dart';
import 'package:linked_timers/widgets/configuration/theme_mode_switch.dart';

class ConfigurationDrawer extends StatelessWidget {
  const ConfigurationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(height: Spacing.xxxl),
              ThemeModeSwitch(),
              Divider(),
              RunInBackgroundButton(),
            ],
          ),

          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.base,
              ),
              child: DeleteDatabaseButton(),
            ),
          ),
        ],
      ),
    );
  }
}
