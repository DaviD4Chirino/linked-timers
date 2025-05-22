import 'package:myapp/models/timer_collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timer_database.g.dart';

@Riverpod(keepAlive: true)
class TimerDatabase extends _$TimerDatabase {
  @override
  List<TimerCollection> build() {
    return [];
  }
}
