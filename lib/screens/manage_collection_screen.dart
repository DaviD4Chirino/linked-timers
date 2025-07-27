import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:linked_timers/extensions/string_extensions.dart';
import 'package:linked_timers/models/abstracts/spacing.dart';
import 'package:linked_timers/models/abstracts/utils.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:linked_timers/models/timer_collection.dart';
import 'package:linked_timers/providers/timer_database.dart';
import 'package:linked_timers/widgets/edit_timer_list_wheel.dart';
import 'package:linked_timers/widgets/timer_display_tile.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:uuid/uuid.dart';

class ManageCollectionScreen extends ConsumerStatefulWidget {
  const ManageCollectionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewCollectionScreenState();
}

class _NewCollectionScreenState
    extends ConsumerState<ManageCollectionScreen> {
  String? collectionName;
  int? collectionLaps;
  String timerLabel = "";
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  bool notify = false;

  /// If the user exits the edit screen without entering the collection
  /// to the database, this will be set to true
  bool collectionAdded = false;

  int timersAdded = 0;

  late TimerCollection collection =
      ModalRoute.of(context)?.settings.arguments == null
      ? TimerCollection(timers: [], label: "Collection Name")
      : (ModalRoute.of(context)!.settings.arguments
                as TimerCollection)
            .copyWith();

  late String? replacementId =
      (ModalRoute.of(context)?.settings.arguments
              as TimerCollection)
          .id;

  Timer? selectedTimer;

  late bool editing =
      ModalRoute.of(context)?.settings.arguments == null
      ? false
      : true;

  TimerDatabase get timerNotifier =>
      ref.watch(timerDatabaseProvider.notifier);

  void addCollection() {
    if (collection.timers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Add at least one timer to the collection",
          ),
        ),
      );
      return;
    }
    timerNotifier.addCollection(collection);
    collectionAdded = true;
    Navigator.pop(context);
  }

  void editCollection() {
    if (replacementId == null) return;
    timerNotifier.editCollection(replacementId!, collection);
    Navigator.pop(context);
  }

  void onTimerTapped(Timer timer) async {
    Timer newTimer = Timer()..id = timer.id;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit timer"),
          content: Container(
            constraints: BoxConstraints(maxHeight: 500),
            child: EditTimerListWheel(
              timer: timer,
              onChanged:
                  (label, hours, minutes, seconds, notify) {
                    newTimer.label = label;
                    newTimer.hours = hours;
                    newTimer.minutes = minutes;
                    newTimer.seconds = seconds;
                    newTimer.notify = notify;
                  },
            ),
          ),

          actions: [
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  if (newTimer.timeAsMilliseconds < 1000) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Make sure the timer is at least 1 second long",
                        ),
                      ),
                    );
                    return;
                  }

                  Navigator.pop(context);

                  List<Timer> timers = [...collection.timers];
                  int index = timers.indexWhere(
                    (element) => element.id == timer.id,
                  );
                  if (index == -1) return;
                  await timers[index].dispose();

                  setState(() {
                    timers[index] = newTimer;
                    collection = collection.copyWith(
                      timers: timers,
                    );
                  });
                },
                child: Text("Accept"),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    /* // If the user exits the edit screen with a new collection, dispose it
    if (!editing && collectionAdded) {
      collection.dispose();
    } */
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: appBar(theme),
      persistentFooterButtons: [addTimerButton()],
      body: Padding(
        padding: EdgeInsets.only(
          right: Spacing.xl,
          left: Spacing.xl,
          top: Spacing.xxxl,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              spacing: Spacing.base,
              children: [titleWidget(), lapsWidgets()],
            ),
            SizedBox(height: Spacing.lg),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Total time: ${StopWatchTimer.getDisplayTime(collection.totalTime, milliSecond: false)}",
                  ),
                ),
                sendCollectionButton(),
              ],
            ),
            Divider(),
            SizedBox(height: Spacing.xxl),
            Expanded(child: timersReorderableList()),
          ],
        ),
      ),
    );
  }

  ImplicitlyAnimatedReorderableList<Timer>
  timersReorderableList() {
    return ImplicitlyAnimatedReorderableList.separated(
      areItemsTheSame: (a, b) => a == b,
      items: collection.timers,
      separatorBuilder: (context, index) =>
          Divider(height: Spacing.xxxl),
      itemBuilder: (context, animation, item, i) {
        final ThemeData theme = Theme.of(context);
        return Reorderable(
          key: Key(item.id),
          child: Slidable(
            startActionPane: ActionPane(
              extentRatio: 0.3,
              motion: DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    setState(() {
                      collection.timers.removeAt(i).dispose();
                    });
                  },

                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                  icon: Icons.delete,
                  label: "Delete",
                ),
              ],
            ),
            child: TimerDisplayTile(
              item,
              onTap: (timer) async {
                Timer? editedTimer = await Utils.timerAlert(
                  timerToEdit: item,
                  context: context,
                  titleText: "Edit timer",
                );
                setState(() {
                  if (editedTimer == null) return;
                  collection.timers[i] = editedTimer
                    ..id = Uuid().v4();
                });
              },
            ),
          ),
        );
      },
      onReorderFinished: (item, from, to, newItems) {
        setState(() {
          collection.timers.removeAt(from);
          collection.timers.insert(to, item);
        });
      },
    );
  }

  SizedBox addTimerButton() {
    return SizedBox(
      key: Key("addTimerButton"),
      width: double.infinity,
      child: FilledButton.icon(
        label: Text("Add Timer"),
        onPressed: () async {
          Timer? timer = await Utils.timerAlert(
            context: context,
          );
          if (timer != null) {
            setState(() {
              collection.timers.add(timer);
              timersAdded++;
            });
          }
        },
        icon: Icon(Icons.timer),
      ),
    );
  }

  Widget sendCollectionButton() {
    return Column(
      children: [
        IconButton.filled(
          onPressed: collection.timers.isNotEmpty
              ? editing
                    ? editCollection
                    : addCollection
              : null,
          icon: Icon(
            editing
                ? Icons.send_rounded
                : Icons.add_alarm_rounded,
          ),
          iconSize: Spacing.iconXXl,
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            /* padding: WidgetStateProperty.all(
                EdgeInsets.all(Spacing.base),
              ), */
          ),
        ),
        SizedBox(height: Spacing.sm),
        Text(
          editing ? "Apply Changes" : "Add Collection",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  AppBar appBar(ThemeData theme) {
    return AppBar(
      title: Text(
        editing
            ? "Editing ${collection.label}"
            : "Add a new Collection",
      ),
      actions: [
        Switch(
          value: collection.alert,
          thumbIcon: WidgetStatePropertyAll(
            Icon(Icons.notifications_active_rounded),
          ),
          onChanged: (value) {
            setState(() {
              collection = collection.copyWith(alert: value);
            });
          },
        ),
      ],
    );
  }

  Expanded lapsWidgets() {
    return Expanded(
      child: TextFormField(
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        keyboardType: TextInputType.numberWithOptions(),

        onChanged: (value) {
          if (value.isEmpty) return;
          setState(() {
            collection = collection.copyWith(
              laps: value.toInt(fallback: 1),
            );
          });
        },
        decoration: InputDecoration.collapsed(
          border: UnderlineInputBorder(),
          hintText: "Nro of laps",
        ),
      ),
    );
  }

  Expanded titleWidget() {
    return Expanded(
      flex: 2,
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            collectionName = value.isEmpty
                ? "New Collection"
                : value;
          });
        },
        decoration: InputDecoration.collapsed(
          border: UnderlineInputBorder(),
          hintText: collection.label,
        ),
      ),
    );
  }
}

class NumberTextField extends StatelessWidget {
  const NumberTextField({
    this.onChanged,
    this.controller,
    this.maxChars = 60,
    super.key,
  });
  final Function(String value)? onChanged;
  final TextEditingController? controller;
  final int maxChars;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      textAlign: TextAlign.center,
      decoration: InputDecoration(hintText: "00"),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(2),
        MaxValueInputFormatter(maxChars),
        MinValueInputFormatter(0),
      ],
      style: theme.textTheme.displayMedium,
    );
  }
}

class MaxValueInputFormatter extends TextInputFormatter {
  final int max;

  MaxValueInputFormatter(this.max);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    final int? value = int.tryParse(newValue.text);
    if (value != null && value > max) {
      // Return the max value
      final String maxStr = max.toString();
      return TextEditingValue(
        text: maxStr,
        selection: TextSelection.collapsed(
          offset: maxStr.length,
        ),
      );
    }
    return newValue;
  }
}

class MinValueInputFormatter extends TextInputFormatter {
  final int min;

  MinValueInputFormatter(this.min);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    final int? value = int.tryParse(newValue.text);
    if (value != null && value < min) {
      // Return the min value
      final String minStr = min.toString();
      return TextEditingValue(
        text: minStr,
        selection: TextSelection.collapsed(
          offset: minStr.length,
        ),
      );
    }
    return newValue;
  }
}
