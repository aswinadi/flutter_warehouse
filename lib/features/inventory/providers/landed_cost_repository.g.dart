// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'landed_cost_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$landedCostRepositoryHash() =>
    r'b14cf6944412da40830c0df9f39aaffcb0f00425';

/// See also [landedCostRepository].
@ProviderFor(landedCostRepository)
final landedCostRepositoryProvider =
    AutoDisposeProvider<LandedCostRepository>.internal(
  landedCostRepository,
  name: r'landedCostRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$landedCostRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LandedCostRepositoryRef = AutoDisposeProviderRef<LandedCostRepository>;
String _$landedCostDetailHash() => r'b4a79a6e2798c38e6c95c204b4ca753277e99f3a';

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

/// See also [landedCostDetail].
@ProviderFor(landedCostDetail)
const landedCostDetailProvider = LandedCostDetailFamily();

/// See also [landedCostDetail].
class LandedCostDetailFamily extends Family<AsyncValue<LandedCost>> {
  /// See also [landedCostDetail].
  const LandedCostDetailFamily();

  /// See also [landedCostDetail].
  LandedCostDetailProvider call(
    int id,
  ) {
    return LandedCostDetailProvider(
      id,
    );
  }

  @override
  LandedCostDetailProvider getProviderOverride(
    covariant LandedCostDetailProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'landedCostDetailProvider';
}

/// See also [landedCostDetail].
class LandedCostDetailProvider extends AutoDisposeFutureProvider<LandedCost> {
  /// See also [landedCostDetail].
  LandedCostDetailProvider(
    int id,
  ) : this._internal(
          (ref) => landedCostDetail(
            ref as LandedCostDetailRef,
            id,
          ),
          from: landedCostDetailProvider,
          name: r'landedCostDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$landedCostDetailHash,
          dependencies: LandedCostDetailFamily._dependencies,
          allTransitiveDependencies:
              LandedCostDetailFamily._allTransitiveDependencies,
          id: id,
        );

  LandedCostDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<LandedCost> Function(LandedCostDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LandedCostDetailProvider._internal(
        (ref) => create(ref as LandedCostDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<LandedCost> createElement() {
    return _LandedCostDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LandedCostDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LandedCostDetailRef on AutoDisposeFutureProviderRef<LandedCost> {
  /// The parameter `id` of this provider.
  int get id;
}

class _LandedCostDetailProviderElement
    extends AutoDisposeFutureProviderElement<LandedCost>
    with LandedCostDetailRef {
  _LandedCostDetailProviderElement(super.provider);

  @override
  int get id => (origin as LandedCostDetailProvider).id;
}

String _$landedCostListHash() => r'1f476a6e927ae2abc859cea7c9f9b5fda237297c';

abstract class _$LandedCostList
    extends BuildlessAutoDisposeAsyncNotifier<List<LandedCost>> {
  late final String? status;
  late final String? startDate;
  late final String? endDate;

  FutureOr<List<LandedCost>> build({
    String? status,
    String? startDate,
    String? endDate,
  });
}

/// See also [LandedCostList].
@ProviderFor(LandedCostList)
const landedCostListProvider = LandedCostListFamily();

/// See also [LandedCostList].
class LandedCostListFamily extends Family<AsyncValue<List<LandedCost>>> {
  /// See also [LandedCostList].
  const LandedCostListFamily();

  /// See also [LandedCostList].
  LandedCostListProvider call({
    String? status,
    String? startDate,
    String? endDate,
  }) {
    return LandedCostListProvider(
      status: status,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  LandedCostListProvider getProviderOverride(
    covariant LandedCostListProvider provider,
  ) {
    return call(
      status: provider.status,
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
  String? get name => r'landedCostListProvider';
}

/// See also [LandedCostList].
class LandedCostListProvider extends AutoDisposeAsyncNotifierProviderImpl<
    LandedCostList, List<LandedCost>> {
  /// See also [LandedCostList].
  LandedCostListProvider({
    String? status,
    String? startDate,
    String? endDate,
  }) : this._internal(
          () => LandedCostList()
            ..status = status
            ..startDate = startDate
            ..endDate = endDate,
          from: landedCostListProvider,
          name: r'landedCostListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$landedCostListHash,
          dependencies: LandedCostListFamily._dependencies,
          allTransitiveDependencies:
              LandedCostListFamily._allTransitiveDependencies,
          status: status,
          startDate: startDate,
          endDate: endDate,
        );

  LandedCostListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final String? status;
  final String? startDate;
  final String? endDate;

  @override
  FutureOr<List<LandedCost>> runNotifierBuild(
    covariant LandedCostList notifier,
  ) {
    return notifier.build(
      status: status,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Override overrideWith(LandedCostList Function() create) {
    return ProviderOverride(
      origin: this,
      override: LandedCostListProvider._internal(
        () => create()
          ..status = status
          ..startDate = startDate
          ..endDate = endDate,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<LandedCostList, List<LandedCost>>
      createElement() {
    return _LandedCostListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LandedCostListProvider &&
        other.status == status &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LandedCostListRef
    on AutoDisposeAsyncNotifierProviderRef<List<LandedCost>> {
  /// The parameter `status` of this provider.
  String? get status;

  /// The parameter `startDate` of this provider.
  String? get startDate;

  /// The parameter `endDate` of this provider.
  String? get endDate;
}

class _LandedCostListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<LandedCostList,
        List<LandedCost>> with LandedCostListRef {
  _LandedCostListProviderElement(super.provider);

  @override
  String? get status => (origin as LandedCostListProvider).status;
  @override
  String? get startDate => (origin as LandedCostListProvider).startDate;
  @override
  String? get endDate => (origin as LandedCostListProvider).endDate;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
