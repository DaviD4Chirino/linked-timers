import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_timers/models/abstracts/routes.dart';
import 'package:linked_timers/models/abstracts/spacing.dart';
import 'package:linked_timers/models/abstracts/utils.dart';
import 'package:linked_timers/models/timer_collection.dart';
import 'package:linked_timers/providers/timer_database.dart';
import 'package:linked_timers/widgets/home_screen/instructions.dart';
import 'package:linked_timers/widgets/reusables/vertical_scroll_listener.dart';
import 'package:linked_timers/widgets/theme_mode_switch.dart';
import 'package:linked_timers/widgets/timer_collection_control.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<TimerCollection> get timerDatabase =>
      ref.watch(timerDatabaseProvider);
  TimerDatabase get timerDatabaseNotifier =>
      ref.read(timerDatabaseProvider.notifier);

  late final verticalScrollController = VerticalScrollController();
  late final scrollController = ScrollController();

  bool scrollingDown = false;

  listenVerticalScroll() {
    setState(() {
      scrollingDown = verticalScrollController.scrollingDown;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      if (!mounted) return;
      ref.read(timerDatabaseProvider.notifier).fetchDatabase();
    });
    verticalScrollController.addListener(listenVerticalScroll);
    super.initState();
  }

  @override
  void dispose() {
    verticalScrollController.removeListener(listenVerticalScroll);
    verticalScrollController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: drawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: SafeArea(
          child: VerticalScrollListener(
            controller: verticalScrollController,
            child:
                timerDatabase.isEmpty
                    ? Instructions()
                    : TimerListDisplay(timerDatabase: timerDatabase),
          ),
        ),
      ),

      floatingActionButton: floatingActionButton(context),
    );
  }

  Drawer drawer() {
    void onAccept() {
      timerDatabaseNotifier.flushDatabase();
      Navigator.pop(context);
    }

    Future deleteDatabase() async {
      if (await Utils.consentAlert(
        context,
        titleText: "You will delete all your Timers",
        contentText: "This action is irreversible",
      )) {
        onAccept();
      }
    }

    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(height: Spacing.xxxl),
              ThemeModeSwitch(),
              Divider(),
            ],
          ),

          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Spacing.base),
              child: OutlinedButton.icon(
                onPressed: deleteDatabase,
                icon: Icon(Icons.delete_forever_rounded),
                label: Text("Delete ALL Timers?"),
                /* style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    theme.colorScheme.error,
                  ),
                ), */
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(title: Text("Linked Timers"));
  }

  Widget floatingActionButton(BuildContext context) {
    const offset = Offset(2, 0);
    const duration = Duration(milliseconds: 700);
    return AnimatedSlide(
      offset: scrollingDown ? offset : Offset.zero,
      curve: Curves.easeInOut,
      duration: duration,
      child: AnimatedOpacity(
        opacity: scrollingDown ? 0 : 1,
        duration: duration,
        curve: Curves.easeInOut,
        child: FloatingActionButton(
          tooltip: "Create new collection",
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.manageCollection);
          },
          child: Icon(Icons.add_rounded, size: Spacing.iconXXl),
        ),
      ),
    );
  }
}

class TimerListDisplay extends StatelessWidget {
  const TimerListDisplay({super.key, required this.timerDatabase});

  final List<TimerCollection> timerDatabase;

  @override
  Widget build(BuildContext context) {
    return ImplicitlyAnimatedList(
      items: timerDatabase,
      itemBuilder: (context, animation, item, i) {
        return SizeFadeTransition(
          key: Key(item.id),
          sizeFraction: 0.1,
          curve: Curves.easeInOut,
          animation: animation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.xxl,
                ),
                child: TimerCollectionControl(
                  item,
                  key: Key(item.id),
                ),
              ),
              if ((i + 1) != timerDatabase.length)
                Divider(height: Spacing.xl),
            ],
          ),
        );
      },
      areItemsTheSame: (oldItem, newItem) => oldItem == newItem,
    );
  }
}
