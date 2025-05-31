import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_timers/models/abstracts/routes.dart';
import 'package:linked_timers/models/abstracts/spacing.dart';
import 'package:linked_timers/models/timer_collection.dart';
import 'package:linked_timers/providers/timer_database.dart';
import 'package:linked_timers/widgets/timer_collection_control.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<TimerCollection> get database =>
      ref.watch(timerDatabaseProvider);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Spacing.xxl),
        child: SafeArea(
          child: ImplicitlyAnimatedList(
            items: database,
            itemBuilder: (context, animation, item, i) {
              return SizeFadeTransition(
                sizeFraction: 0.1,
                curve: Curves.easeInOut,
                animation: animation,
                child: TimerCollectionControl(
                  item,
                  key: Key(item.id),
                ),
              );
            },
            areItemsTheSame: (oldItem, newItem) => oldItem == newItem,
          ),
        ),

        /* AnimatedList.separated(
          initialItemCount: database.length,
          removedSeparatorBuilder:
              (context, i, animation) =>
                  Divider(height: Spacing.xxxl),
          itemBuilder: (context, i, animation) {
            return SlideTransition(
              position: animation.drive(
                Tween(begin: Offset(5, 5), end: Offset(10, 10)),
              ),
              child: TimerCollectionControl(
                database[i],
                key: Key(database[i].id),
              ),
            );
          },
          separatorBuilder:
              (context, i, animation) =>
                  Divider(height: Spacing.xxxl),
        ), */
      ),

      floatingActionButton: FloatingActionButton(
        tooltip: "Create new collection",
        onPressed: () {
          Navigator.of(context).pushNamed(Routes.newCollection);
        },
        child: Icon(Icons.add, size: Spacing.iconXXl),
      ),
    );
  }
}
