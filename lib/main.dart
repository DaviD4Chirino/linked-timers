import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linked_timers/config/theme.dart';
import 'package:linked_timers/models/abstracts/routes.dart';
import 'package:linked_timers/screens/home_screen.dart';
import 'package:linked_timers/screens/manage_collection_screen.dart';

//! We Have problems with the identifying operation, add uuid immediately
void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Linked Timers",
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routes: {
        Routes.home: (context) => const HomeScreen(),
        Routes.manageCollection:
            (context) => const ManageCollectionScreen(),
      },
      initialRoute: Routes.home,
    );
  }
}

extension ListExtensions on List {
  next(Object element) {
    int index = indexOf(element);
    int nextIndex = index + 1;
    if (nextIndex > length) {
      return first;
    }
    return this[index + 1];
  }
}
