// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_watches_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(StopWatchesNotifier)
const stopWatchesNotifierProvider = StopWatchesNotifierProvider._();

final class StopWatchesNotifierProvider
    extends
        $NotifierProvider<
          StopWatchesNotifier,
          Map<String, List<StopWatchTimer>>
        > {
  const StopWatchesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stopWatchesNotifierProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stopWatchesNotifierHash();

  @$internal
  @override
  StopWatchesNotifier create() => StopWatchesNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, List<StopWatchTimer>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, List<StopWatchTimer>>>(
        value,
      ),
    );
  }
}

String _$stopWatchesNotifierHash() =>
    r'40c93c500efe2a80c00bb8775a804de48e3ca51a';

abstract class _$StopWatchesNotifier
    extends $Notifier<Map<String, List<StopWatchTimer>>> {
  Map<String, List<StopWatchTimer>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              Map<String, List<StopWatchTimer>>,
              Map<String, List<StopWatchTimer>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, List<StopWatchTimer>>,
                Map<String, List<StopWatchTimer>>
              >,
              Map<String, List<StopWatchTimer>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
