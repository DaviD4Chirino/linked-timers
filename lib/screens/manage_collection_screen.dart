import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_timers/extensions/string_extensions.dart';
import 'package:linked_timers/models/abstracts/spacing.dart';
import 'package:linked_timers/models/timer.dart';
import 'package:linked_timers/models/timer_collection.dart';
import 'package:linked_timers/providers/timer_database.dart';
import 'package:linked_timers/widgets/collection_drop_down_button.dart';
import 'package:linked_timers/widgets/edit_timer_list_wheel.dart';
import 'package:linked_timers/widgets/reusables/text_icon.dart';
import 'package:linked_timers/widgets/timer_circular_percent_indicator.dart';

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

  int timersAdded = 0;

  TextEditingController minutesController =
      TextEditingController();
  TextEditingController secondsController =
      TextEditingController();
  TextEditingController hoursController =
      TextEditingController();
  TextEditingController timerLabelController =
      TextEditingController();

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
              onChanged: (
                label,
                hours,
                minutes,
                seconds,
                notify,
              ) {
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
                onPressed: () {
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

                  setState(() {
                    List<Timer> timers = [...collection.timers];
                    int index = timers.indexWhere(
                      (element) => element.id == timer.id,
                    );
                    if (index == -1) return;
                    timers[index] = newTimer;

                    collection = collection.copyWith(
                      timers: timers,
                    );
                  });
                  Navigator.pop(context);
                },
                child: Text("Accept"),
              ),
            ),
          ],
        );
      },
    );
  }

  void addTimer() {
    Timer newTimer = Timer(
      label: timerLabel,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      notify: notify,
    );
    if (newTimer.timeAsMilliseconds < 1000) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Make sure the timer is at leas 1 second long",
          ),
        ),
      );
      return;
    }

    setState(() {
      collection.timers.add(newTimer);
      timersAdded++;
    });
  }

  @override
  void dispose() {
    hoursController.dispose();
    minutesController.dispose();
    secondsController.dispose();
    timerLabelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    List<Widget> persistentFooterButtons = [
      SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          label: Text("Add Timer"),
          onPressed: addTimer,
          icon: Icon(Icons.timer),

          // color: theme.colorScheme.onTertiary,
          /*  style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                theme.colorScheme.tertiary,
              ),
            ), */
        ),
      ),
    ];

    return Scaffold(
      appBar: appBar(theme),
      persistentFooterButtons: persistentFooterButtons,
      body: Padding(
        padding: EdgeInsets.only(
          right: Spacing.xl,
          left: Spacing.xl,
          top: Spacing.xxxl,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (collection.timers.isNotEmpty)
              Row(
                spacing: Spacing.base,
                children: [titleWidget(), lapsWidgets()],
              ),
            if (collection.timers.isNotEmpty)
              SizedBox(height: Spacing.lg),
            if (collection.timers.isNotEmpty)
              SizedBox(
                height: 100,
                child: Row(
                  children: [
                    Expanded(child: timersDisplay(context)),
                    SizedBox(width: Spacing.lg),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: Spacing.iconXl + 16,
                          height: Spacing.iconXl + 16,
                          child: IconButton.filled(
                            onPressed:
                                editing
                                    ? editCollection
                                    : addCollection,
                            icon: Icon(Icons.add_alarm_rounded),
                            iconSize: Spacing.iconXl,
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(8),
                                ),
                              ),
                              padding: WidgetStateProperty.all(
                                EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: Spacing.sm),
                        Text(
                          "Add Collection",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            Expanded(
              child: EditTimerListWheel(
                onChanged: (
                  label,
                  hours,
                  minutes,
                  seconds,
                  notify,
                ) {
                  timerLabel = label;
                  this.hours = hours;
                  this.minutes = minutes;
                  this.seconds = seconds;
                  this.notify = notify;
                },
              ),
            ),
          ],
        ),
      ),
      /* floatingActionButton: FloatingActionButton.extended(
        onPressed: editing ? editCollection : addCollection,
        label: Row(
          children: [
            Icon(Icons.add),
            Text(
              editing ? "Modify Collection" : "Add Collection",
            ),
          ],
        ),
      ), */
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
      /* actions: [
        IconButton.filled(
          tooltip: editing ? "Apply changes" : "Add Collection",
          onPressed: editing ? editCollection : addCollection,
          icon: Icon(Icons.alarm_on_rounded),
          color: theme.colorScheme.onTertiary,
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              theme.colorScheme.tertiary,
            ),
          ),
        ),
        SizedBox(width: 5),
      ], */
    );
  }

  ListView timersDisplay(BuildContext context) {
    void onLongPress(
      LongPressStartDetails details,
      Timer timer,
    ) async {
      final overlay =
          Overlay.of(context).context.findRenderObject()
              as RenderBox;
      final selected = await showMenu(
        context: context,
        position: RelativeRect.fromRect(
          details.globalPosition & const Size(40, 40),
          Offset.zero & overlay.size,
        ),
        items: [
          ThemedPopupMenuItem(
            value: "toggle-notify",
            child: TextIcon(
              icon: Icon(
                timer.notify
                    ? Icons.notifications_off_rounded
                    : Icons.notification_add_rounded,
              ),
              text: Text(
                timer.notify
                    ? "Don't notify when it ends"
                    : "Notify when it ends",
              ),
            ),
          ),
          ThemedPopupMenuItem(
            themeStyle: ThemedPopupMenuStyle.error,
            value: "remove",
            child: TextIcon(
              icon: Icon(Icons.remove_circle_rounded),
              text: Text("Remove this timer"),
            ),
          ),
        ],
      );

      if (selected == "remove") {
        collection.removeTimer(timer);
      }
      if (selected == "toggle-notify") {
        var timers = collection.timers;
        int index = timers.indexOf(timer);
        Timer collTimer = timers[index];
        timers[index] = collTimer.copyWith(
          notify: !collTimer.notify,
        );

        setState(() {
          collection = collection.copyWith(timers: timers);
        });
      }
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: collection.timers.length,
      itemBuilder: (context, index) {
        Timer timer = collection.timers[index];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onLongPressStart: (details) {
                onLongPress(details, timer);
              },
              child: TimerCircularPercentIndicator(
                collection.timers[index].toStopWatchTimer(),
                notify: collection.timers[index].notify,
                onTap: () {
                  onTimerTapped(timer);
                },
              ),
            ),
            SizedBox(
              width: 90,
              child: Text(
                timer.label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }

  TextFormField timerLabelField() {
    return TextFormField(
      controller: timerLabelController,
      onChanged: (value) {
        setState(() {
          timerLabel = value;
        });
      },
      decoration: InputDecoration(
        label: Text("Insert a Timer Name"),
      ),
    );
  }

  Expanded lapsWidgets() {
    return Expanded(
      child: TextFormField(
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          MinValueInputFormatter(1),
        ],
        keyboardType: TextInputType.numberWithOptions(),

        onChanged: (value) {
          setState(() {
            collectionLaps = value.toInt(fallback: 1);
            collection.laps = value.toInt(fallback: 1);
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
            collectionName = value;
            collection.label =
                collectionName ?? "New Collection";
          });
        },
        decoration: InputDecoration.collapsed(
          border: UnderlineInputBorder(),
          hintText: collection.label,
        ),
      ),
    );
  }

  Row timersInputs(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      spacing: Spacing.base,
      children: [
        Expanded(
          child: NumberTextField(
            controller: hoursController,
            onChanged: (value) {
              setState(() {
                hours = value.toInt(fallback: 0);
              });
            },
            maxChars: 24,
          ), //* Hours
        ),
        Text(
          ":",
          style: TextStyle(
            fontSize: theme.textTheme.displaySmall!.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: NumberTextField(
            controller: minutesController,
            onChanged: (value) {
              setState(() {
                minutes = value.toInt(fallback: 0);
              });
            },
          ), //* Minutes
        ),
        Text(
          ":",
          style: TextStyle(
            fontSize: theme.textTheme.displaySmall!.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: NumberTextField(
            controller: secondsController,
            onChanged: (value) {
              setState(() {
                seconds = value.toInt(fallback: 0);
              });
            },
          ),
        ), //* Seconds
      ],
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
