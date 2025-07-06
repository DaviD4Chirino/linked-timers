// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_watches_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(StopWatchesProvider)
const stopWatchesProviderProvider = StopWatchesProviderProvider._();

final class StopWatchesProviderProvider
    extends
        $NotifierProvider<
          StopWatchesProvider,
          List<Map<String, List<StopWatchTimer>>>
        > {
  const StopWatchesProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stopWatchesProviderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stopWatchesProviderHash();

  @$internal
  @override
  StopWatchesProvider create() => StopWatchesProvider();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Map<String, List<StopWatchTimer>>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<List<Map<String, List<StopWatchTimer>>>>(value),
    );
  }
}

String _$stopWatchesProviderHash() =>
    r'a4b01963f536637ee46e3379c298afe7baf73907';

abstract class _$StopWatchesProvider
    extends $Notifier<List<Map<String, List<StopWatchTimer>>>> {
  List<Map<String, List<StopWatchTimer>>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              List<Map<String, List<StopWatchTimer>>>,
              List<Map<String, List<StopWatchTimer>>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                List<Map<String, List<StopWatchTimer>>>,
                List<Map<String, List<StopWatchTimer>>>
              >,
              List<Map<String, List<StopWatchTimer>>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
