// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_opname_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stockOpnameRepositoryHash() =>
    r'1d48c6d9065b9ff53b41a2110e3a01489dda801c';

/// See also [stockOpnameRepository].
@ProviderFor(stockOpnameRepository)
final stockOpnameRepositoryProvider =
    AutoDisposeProvider<StockOpnameRepository>.internal(
  stockOpnameRepository,
  name: r'stockOpnameRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$stockOpnameRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef StockOpnameRepositoryRef
    = AutoDisposeProviderRef<StockOpnameRepository>;
String _$activeStockOpnameSessionsHash() =>
    r'89a16e85028a15b66c9815f611363e3a927799ef';

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

/// See also [activeStockOpnameSessions].
@ProviderFor(activeStockOpnameSessions)
const activeStockOpnameSessionsProvider = ActiveStockOpnameSessionsFamily();

/// See also [activeStockOpnameSessions].
class ActiveStockOpnameSessionsFamily
    extends Family<AsyncValue<List<StockOpname>>> {
  /// See also [activeStockOpnameSessions].
  const ActiveStockOpnameSessionsFamily();

  /// See also [activeStockOpnameSessions].
  ActiveStockOpnameSessionsProvider call({
    int? warehouseId,
  }) {
    return ActiveStockOpnameSessionsProvider(
      warehouseId: warehouseId,
    );
  }

  @override
  ActiveStockOpnameSessionsProvider getProviderOverride(
    covariant ActiveStockOpnameSessionsProvider provider,
  ) {
    return call(
      warehouseId: provider.warehouseId,
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
  String? get name => r'activeStockOpnameSessionsProvider';
}

/// See also [activeStockOpnameSessions].
class ActiveStockOpnameSessionsProvider
    extends AutoDisposeFutureProvider<List<StockOpname>> {
  /// See also [activeStockOpnameSessions].
  ActiveStockOpnameSessionsProvider({
    int? warehouseId,
  }) : this._internal(
          (ref) => activeStockOpnameSessions(
            ref as ActiveStockOpnameSessionsRef,
            warehouseId: warehouseId,
          ),
          from: activeStockOpnameSessionsProvider,
          name: r'activeStockOpnameSessionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$activeStockOpnameSessionsHash,
          dependencies: ActiveStockOpnameSessionsFamily._dependencies,
          allTransitiveDependencies:
              ActiveStockOpnameSessionsFamily._allTransitiveDependencies,
          warehouseId: warehouseId,
        );

  ActiveStockOpnameSessionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.warehouseId,
  }) : super.internal();

  final int? warehouseId;

  @override
  Override overrideWith(
    FutureOr<List<StockOpname>> Function(ActiveStockOpnameSessionsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ActiveStockOpnameSessionsProvider._internal(
        (ref) => create(ref as ActiveStockOpnameSessionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        warehouseId: warehouseId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<StockOpname>> createElement() {
    return _ActiveStockOpnameSessionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveStockOpnameSessionsProvider &&
        other.warehouseId == warehouseId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, warehouseId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ActiveStockOpnameSessionsRef
    on AutoDisposeFutureProviderRef<List<StockOpname>> {
  /// The parameter `warehouseId` of this provider.
  int? get warehouseId;
}

class _ActiveStockOpnameSessionsProviderElement
    extends AutoDisposeFutureProviderElement<List<StockOpname>>
    with ActiveStockOpnameSessionsRef {
  _ActiveStockOpnameSessionsProviderElement(super.provider);

  @override
  int? get warehouseId =>
      (origin as ActiveStockOpnameSessionsProvider).warehouseId;
}

String _$stockOpnameSummaryHash() =>
    r'0e9a17e8575db287a8ab15b2945fd9a845d91c18';

/// See also [stockOpnameSummary].
@ProviderFor(stockOpnameSummary)
const stockOpnameSummaryProvider = StockOpnameSummaryFamily();

/// See also [stockOpnameSummary].
class StockOpnameSummaryFamily
    extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [stockOpnameSummary].
  const StockOpnameSummaryFamily();

  /// See also [stockOpnameSummary].
  StockOpnameSummaryProvider call(
    int id,
  ) {
    return StockOpnameSummaryProvider(
      id,
    );
  }

  @override
  StockOpnameSummaryProvider getProviderOverride(
    covariant StockOpnameSummaryProvider provider,
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
  String? get name => r'stockOpnameSummaryProvider';
}

/// See also [stockOpnameSummary].
class StockOpnameSummaryProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [stockOpnameSummary].
  StockOpnameSummaryProvider(
    int id,
  ) : this._internal(
          (ref) => stockOpnameSummary(
            ref as StockOpnameSummaryRef,
            id,
          ),
          from: stockOpnameSummaryProvider,
          name: r'stockOpnameSummaryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$stockOpnameSummaryHash,
          dependencies: StockOpnameSummaryFamily._dependencies,
          allTransitiveDependencies:
              StockOpnameSummaryFamily._allTransitiveDependencies,
          id: id,
        );

  StockOpnameSummaryProvider._internal(
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
    FutureOr<Map<String, dynamic>> Function(StockOpnameSummaryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StockOpnameSummaryProvider._internal(
        (ref) => create(ref as StockOpnameSummaryRef),
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
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _StockOpnameSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StockOpnameSummaryProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin StockOpnameSummaryRef
    on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `id` of this provider.
  int get id;
}

class _StockOpnameSummaryProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with StockOpnameSummaryRef {
  _StockOpnameSummaryProviderElement(super.provider);

  @override
  int get id => (origin as StockOpnameSummaryProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
