// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_database.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(TimerDatabase)
const timerDatabaseProvider = TimerDatabaseProvider._();

final class TimerDatabaseProvider
    extends $NotifierProvider<TimerDatabase, List<TimerCollection>> {
  const TimerDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timerDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timerDatabaseHash();

  @$internal
  @override
  TimerDatabase create() => TimerDatabase();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TimerCollection> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TimerCollection>>(value),
    );
  }
}

String _$timerDatabaseHash() => r'600fcabdaf7667eeb7963f79887ddb2a063d4867';

abstract class _$TimerDatabase extends $Notifier<List<TimerCollection>> {
  List<TimerCollection> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<TimerCollection>, List<TimerCollection>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<TimerCollection>, List<TimerCollection>>,
              List<TimerCollection>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
