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

  @$internal
  @override
  $NotifierProviderElement<TimerDatabase, List<TimerCollection>> $createElement(
    $ProviderPointer pointer,
  ) => $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TimerCollection> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<List<TimerCollection>>(value),
    );
  }
}

String _$timerDatabaseHash() => r'da084d0df1ccd12490f30d6473203eba9f3f78e4';

abstract class _$TimerDatabase extends $Notifier<List<TimerCollection>> {
  List<TimerCollection> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<TimerCollection>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<TimerCollection>>,
              List<TimerCollection>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
