import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_timers/models/timer_collection.dart';
import 'package:linked_timers/providers/timer_database.dart';
import 'package:linked_timers/widgets/timer_collection_display.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<TimerCollection> database = ref.watch(timerDatabaseProvider);

    return Scaffold(
      body: ListView.separated(
        itemCount: database.length,
        itemBuilder: (context, i) {
          return TimerCollectionDisplay(database[i]);
        },
        separatorBuilder: (context, i) => const Divider(),
      ),
    );
  }
}
