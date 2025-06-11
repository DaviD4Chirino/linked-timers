import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_timers/models/abstracts/routes.dart';
import 'package:linked_timers/models/abstracts/utils.dart';
import 'package:linked_timers/models/timer_collection.dart';
import 'package:linked_timers/providers/timer_database.dart';
import 'package:linked_timers/widgets/reusables/text_icon.dart';

class CollectionDropDownButton extends ConsumerWidget {
  CollectionDropDownButton(this.collection, {super.key});

  final TimerCollection collection;

  final entries = [
    ThemedPopupMenuItem(
      value: "edit",
      child: TextIcon(
        icon: Icon(Icons.edit),
        text: Text("Edit"),
      ),
    ),
    ThemedPopupMenuItem(
      themeStyle: ThemedPopupMenuStyle.error,
      value: "delete",
      child: TextIcon(
        icon: Icon(Icons.delete),
        text: Text("Delete"),
      ),
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

  void onEdit(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamed(Routes.manageCollection, arguments: collection);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final databaseNotifier = ref.read(
      timerDatabaseProvider.notifier,
    );

    return PopupMenuButton<String>(
      onSelected: (String value) async {
        if (value == "delete") {
          onDelete(context, databaseNotifier);
        }
        if (value == "edit") {
          onEdit(context);
        }
      },
      itemBuilder: (BuildContext context) => entries,
      offset: Offset(5, 35),
      icon: Icon(Icons.more_horiz),
    );
  }
}

enum ThemedPopupMenuStyle {
  none,
  primary,
  secondary,
  tertiary,
  error,
}

class ThemedPopupMenuItem<T> extends PopupMenuItem<T> {
  ThemedPopupMenuItem({
    super.key,
    required super.value,
    required Widget child,
    ThemedPopupMenuStyle themeStyle = ThemedPopupMenuStyle.none,
    super.enabled,
    super.height,
    TextStyle? textStyle,
  }) : super(
         child: Builder(
           builder: (context) {
             final color = _resolveColor(context, themeStyle);
             return IconTheme.merge(
               data: IconThemeData(color: color),
               child: DefaultTextStyle(
                 style:
                     textStyle ??
                     Theme.of(context).textTheme.titleMedium!
                         .copyWith(color: color),
                 child: child,
               ),
             );
           },
         ),
       );

  static Color _resolveColor(
    BuildContext context,
    ThemedPopupMenuStyle style,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (style) {
      case ThemedPopupMenuStyle.none:
        return colorScheme.onSurface;
      case ThemedPopupMenuStyle.primary:
        return colorScheme.primary;
      case ThemedPopupMenuStyle.secondary:
        return colorScheme.secondary;
      case ThemedPopupMenuStyle.tertiary:
        return colorScheme.tertiary;
      case ThemedPopupMenuStyle.error:
        return colorScheme.error;
    }
  }
}
