import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:linked_timers/localization/app_locale.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  void onTap(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => LanguageSelectAlert(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListTile(
      onTap: () => onTap(context),
      title: Text("Switch language"),
      leading: Text(
        FlutterLocalization.instance.currentLocale?.languageCode
                .toUpperCase() ??
            "",
        style: TextStyle(
          fontSize: theme.textTheme.bodyMedium?.fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class LanguageSelectAlert extends StatelessWidget {
  const LanguageSelectAlert({super.key});

  @override
  Widget build(BuildContext context) {
    var localization = FlutterLocalization.instance;
    return AlertDialog(
      title: Text("Select language"),
      content: ListView.builder(
        itemCount: localization.supportedLocales.length,
        itemBuilder: (context, index) {
          var languageCode =
              localization.supportedLocales
                  .toList()[index]
                  .languageCode;

          return ListTile(
            onTap: () {
              Navigator.of(context).pop();
              localization.translate(
                localization.supportedLocales
                    .toList()[index]
                    .languageCode,
              );
            },
            title: Text(
              localization.getLanguageName(
                languageCode: languageCode,
              ),
            ),
          );
        },
      ),
    );
  }
}
