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
        child: ListView.separated(
          itemCount: database.length,
          itemBuilder: (context, i) {
            return TimerCollectionControl(database[i]);
          },
          separatorBuilder:
              (context, i) => Divider(height: Spacing.xxxl),
        ),
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
