// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_log_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$feedLogRepositoryHash() => r'1c2bc981e8aaf6a42c0e4d4c1a54a03c6b088dbd';

/// See also [feedLogRepository].
@ProviderFor(feedLogRepository)
final feedLogRepositoryProvider =
    AutoDisposeProvider<FeedLogRepository>.internal(
  feedLogRepository,
  name: r'feedLogRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$feedLogRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FeedLogRepositoryRef = AutoDisposeProviderRef<FeedLogRepository>;
String _$feedCyclesHash() => r'e52d285dcc060945820fd2176c144a224349984e';

/// See also [feedCycles].
@ProviderFor(feedCycles)
final feedCyclesProvider =
    AutoDisposeFutureProvider<List<AquacultureCycle>>.internal(
  feedCycles,
  name: r'feedCyclesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$feedCyclesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FeedCyclesRef = AutoDisposeFutureProviderRef<List<AquacultureCycle>>;
String _$feedPondsHash() => r'19bb6d898c6a2617c69831e75e5c2fc76baaa904';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [feedPonds].
@ProviderFor(feedPonds)
const feedPondsProvider = FeedPondsFamily();

/// See also [feedPonds].
class FeedPondsFamily extends Family<AsyncValue<List<AquaculturePond>>> {
  /// See also [feedPonds].
  const FeedPondsFamily();

  /// See also [feedPonds].
  FeedPondsProvider call({
    int? cycleId,
  }) {
    return FeedPondsProvider(
      cycleId: cycleId,
    );
  }

  @override
  FeedPondsProvider getProviderOverride(
    covariant FeedPondsProvider provider,
  ) {
    return call(
      cycleId: provider.cycleId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'feedPondsProvider';
}

/// See also [feedPonds].
class FeedPondsProvider
    extends AutoDisposeFutureProvider<List<AquaculturePond>> {
  /// See also [feedPonds].
  FeedPondsProvider({
    int? cycleId,
  }) : this._internal(
          (ref) => feedPonds(
            ref as FeedPondsRef,
            cycleId: cycleId,
          ),
          from: feedPondsProvider,
          name: r'feedPondsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$feedPondsHash,
          dependencies: FeedPondsFamily._dependencies,
          allTransitiveDependencies: FeedPondsFamily._allTransitiveDependencies,
          cycleId: cycleId,
        );

  FeedPondsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cycleId,
  }) : super.internal();

  final int? cycleId;

  @override
  Override overrideWith(
    FutureOr<List<AquaculturePond>> Function(FeedPondsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FeedPondsProvider._internal(
        (ref) => create(ref as FeedPondsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cycleId: cycleId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<AquaculturePond>> createElement() {
    return _FeedPondsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FeedPondsProvider && other.cycleId == cycleId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cycleId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FeedPondsRef on AutoDisposeFutureProviderRef<List<AquaculturePond>> {
  /// The parameter `cycleId` of this provider.
  int? get cycleId;
}

class _FeedPondsProviderElement
    extends AutoDisposeFutureProviderElement<List<AquaculturePond>>
    with FeedPondsRef {
  _FeedPondsProviderElement(super.provider);

  @override
  int? get cycleId => (origin as FeedPondsProvider).cycleId;
}

String _$feedLogsListHash() => r'44a95840975b6d21f95b68160327af95415c600b';

abstract class _$FeedLogsList
    extends BuildlessAutoDisposeAsyncNotifier<List<FeedLog>> {
  late final int? cycleId;
  late final int? pondId;
  late final String? startDate;
  late final String? endDate;

  FutureOr<List<FeedLog>> build({
    int? cycleId,
    int? pondId,
    String? startDate,
    String? endDate,
  });
}

/// See also [FeedLogsList].
@ProviderFor(FeedLogsList)
const feedLogsListProvider = FeedLogsListFamily();

/// See also [FeedLogsList].
class FeedLogsListFamily extends Family<AsyncValue<List<FeedLog>>> {
  /// See also [FeedLogsList].
  const FeedLogsListFamily();

  /// See also [FeedLogsList].
  FeedLogsListProvider call({
    int? cycleId,
    int? pondId,
    String? startDate,
    String? endDate,
  }) {
    return FeedLogsListProvider(
      cycleId: cycleId,
      pondId: pondId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  FeedLogsListProvider getProviderOverride(
    covariant FeedLogsListProvider provider,
  ) {
    return call(
      cycleId: provider.cycleId,
      pondId: provider.pondId,
      startDate: provider.startDate,
      endDate: provider.endDate,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'feedLogsListProvider';
}

/// See also [FeedLogsList].
class FeedLogsListProvider
    extends AutoDisposeAsyncNotifierProviderImpl<FeedLogsList, List<FeedLog>> {
  /// See also [FeedLogsList].
  FeedLogsListProvider({
    int? cycleId,
    int? pondId,
    String? startDate,
    String? endDate,
  }) : this._internal(
          () => FeedLogsList()
            ..cycleId = cycleId
            ..pondId = pondId
            ..startDate = startDate
            ..endDate = endDate,
          from: feedLogsListProvider,
          name: r'feedLogsListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$feedLogsListHash,
          dependencies: FeedLogsListFamily._dependencies,
          allTransitiveDependencies:
              FeedLogsListFamily._allTransitiveDependencies,
          cycleId: cycleId,
          pondId: pondId,
          startDate: startDate,
          endDate: endDate,
        );

  FeedLogsListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cycleId,
    required this.pondId,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final int? cycleId;
  final int? pondId;
  final String? startDate;
  final String? endDate;

  @override
  FutureOr<List<FeedLog>> runNotifierBuild(
    covariant FeedLogsList notifier,
  ) {
    return notifier.build(
      cycleId: cycleId,
      pondId: pondId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Override overrideWith(FeedLogsList Function() create) {
    return ProviderOverride(
      origin: this,
      override: FeedLogsListProvider._internal(
        () => create()
          ..cycleId = cycleId
          ..pondId = pondId
          ..startDate = startDate
          ..endDate = endDate,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cycleId: cycleId,
        pondId: pondId,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FeedLogsList, List<FeedLog>>
      createElement() {
    return _FeedLogsListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FeedLogsListProvider &&
        other.cycleId == cycleId &&
        other.pondId == pondId &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cycleId.hashCode);
    hash = _SystemHash.combine(hash, pondId.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FeedLogsListRef on AutoDisposeAsyncNotifierProviderRef<List<FeedLog>> {
  /// The parameter `cycleId` of this provider.
  int? get cycleId;

  /// The parameter `pondId` of this provider.
  int? get pondId;

  /// The parameter `startDate` of this provider.
  String? get startDate;

  /// The parameter `endDate` of this provider.
  String? get endDate;
}

class _FeedLogsListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FeedLogsList, List<FeedLog>>
    with FeedLogsListRef {
  _FeedLogsListProviderElement(super.provider);

  @override
  int? get cycleId => (origin as FeedLogsListProvider).cycleId;
  @override
  int? get pondId => (origin as FeedLogsListProvider).pondId;
  @override
  String? get startDate => (origin as FeedLogsListProvider).startDate;
  @override
  String? get endDate => (origin as FeedLogsListProvider).endDate;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
