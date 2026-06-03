// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_mutation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stockMutationRepositoryHash() =>
    r'6b85327612f6a1b4c58331e2a344c6fac4e2d53c';

/// See also [stockMutationRepository].
@ProviderFor(stockMutationRepository)
final stockMutationRepositoryProvider =
    AutoDisposeProvider<StockMutationRepository>.internal(
  stockMutationRepository,
  name: r'stockMutationRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$stockMutationRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef StockMutationRepositoryRef
    = AutoDisposeProviderRef<StockMutationRepository>;
String _$selectedWarehouseHash() => r'b831156010f2e85f9a054b6b43bdd3489e4d631e';

/// See also [SelectedWarehouse].
@ProviderFor(SelectedWarehouse)
final selectedWarehouseProvider =
    AutoDisposeNotifierProvider<SelectedWarehouse, Warehouse?>.internal(
  SelectedWarehouse.new,
  name: r'selectedWarehouseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedWarehouseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedWarehouse = AutoDisposeNotifier<Warehouse?>;
String _$stockMutationDateRangeHash() =>
    r'623aa90085205ed7c6b61692a650914b98efd169';

/// See also [StockMutationDateRange].
@ProviderFor(StockMutationDateRange)
final stockMutationDateRangeProvider =
    AutoDisposeNotifierProvider<StockMutationDateRange, DateTimeRange>.internal(
  StockMutationDateRange.new,
  name: r'stockMutationDateRangeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$stockMutationDateRangeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StockMutationDateRange = AutoDisposeNotifier<DateTimeRange>;
String _$stockMutationSearchQueryHash() =>
    r'aa15ae56927a1b69fa7958e80ba122e0033630ed';

/// See also [StockMutationSearchQuery].
@ProviderFor(StockMutationSearchQuery)
final stockMutationSearchQueryProvider =
    AutoDisposeNotifierProvider<StockMutationSearchQuery, String>.internal(
  StockMutationSearchQuery.new,
  name: r'stockMutationSearchQueryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$stockMutationSearchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StockMutationSearchQuery = AutoDisposeNotifier<String>;
String _$stockMutationSummaryListHash() =>
    r'3cf78852f9a9dce16399dad4abba6cdc3478dab4';

/// See also [StockMutationSummaryList].
@ProviderFor(StockMutationSummaryList)
final stockMutationSummaryListProvider = AutoDisposeAsyncNotifierProvider<
    StockMutationSummaryList, List<StockMutationSummary>>.internal(
  StockMutationSummaryList.new,
  name: r'stockMutationSummaryListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$stockMutationSummaryListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StockMutationSummaryList
    = AutoDisposeAsyncNotifier<List<StockMutationSummary>>;
String _$stockCardDetailListHash() =>
    r'd99fc6adab89c386054293c5d4dae93c035280f8';

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

abstract class _$StockCardDetailList
    extends BuildlessAutoDisposeAsyncNotifier<List<StockMutationDetail>> {
  late final String sku;

  FutureOr<List<StockMutationDetail>> build(
    String sku,
  );
}

/// See also [StockCardDetailList].
@ProviderFor(StockCardDetailList)
const stockCardDetailListProvider = StockCardDetailListFamily();

/// See also [StockCardDetailList].
class StockCardDetailListFamily
    extends Family<AsyncValue<List<StockMutationDetail>>> {
  /// See also [StockCardDetailList].
  const StockCardDetailListFamily();

  /// See also [StockCardDetailList].
  StockCardDetailListProvider call(
    String sku,
  ) {
    return StockCardDetailListProvider(
      sku,
    );
  }

  @override
  StockCardDetailListProvider getProviderOverride(
    covariant StockCardDetailListProvider provider,
  ) {
    return call(
      provider.sku,
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
  String? get name => r'stockCardDetailListProvider';
}

/// See also [StockCardDetailList].
class StockCardDetailListProvider extends AutoDisposeAsyncNotifierProviderImpl<
    StockCardDetailList, List<StockMutationDetail>> {
  /// See also [StockCardDetailList].
  StockCardDetailListProvider(
    String sku,
  ) : this._internal(
          () => StockCardDetailList()..sku = sku,
          from: stockCardDetailListProvider,
          name: r'stockCardDetailListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$stockCardDetailListHash,
          dependencies: StockCardDetailListFamily._dependencies,
          allTransitiveDependencies:
              StockCardDetailListFamily._allTransitiveDependencies,
          sku: sku,
        );

  StockCardDetailListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sku,
  }) : super.internal();

  final String sku;

  @override
  FutureOr<List<StockMutationDetail>> runNotifierBuild(
    covariant StockCardDetailList notifier,
  ) {
    return notifier.build(
      sku,
    );
  }

  @override
  Override overrideWith(StockCardDetailList Function() create) {
    return ProviderOverride(
      origin: this,
      override: StockCardDetailListProvider._internal(
        () => create()..sku = sku,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sku: sku,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<StockCardDetailList,
      List<StockMutationDetail>> createElement() {
    return _StockCardDetailListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StockCardDetailListProvider && other.sku == sku;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sku.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin StockCardDetailListRef
    on AutoDisposeAsyncNotifierProviderRef<List<StockMutationDetail>> {
  /// The parameter `sku` of this provider.
  String get sku;
}

class _StockCardDetailListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<StockCardDetailList,
        List<StockMutationDetail>> with StockCardDetailListRef {
  _StockCardDetailListProviderElement(super.provider);

  @override
  String get sku => (origin as StockCardDetailListProvider).sku;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
