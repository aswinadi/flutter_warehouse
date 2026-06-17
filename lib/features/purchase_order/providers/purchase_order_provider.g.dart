// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_order_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$purchaseOrderRepositoryHash() =>
    r'2a860f7df614b9ab22512605d5294547792dda9f';

/// See also [purchaseOrderRepository].
@ProviderFor(purchaseOrderRepository)
final purchaseOrderRepositoryProvider =
    AutoDisposeProvider<PurchaseOrderRepository>.internal(
  purchaseOrderRepository,
  name: r'purchaseOrderRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$purchaseOrderRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PurchaseOrderRepositoryRef
    = AutoDisposeProviderRef<PurchaseOrderRepository>;
String _$purchaseOrderDetailHash() =>
    r'c8de504d56962147f03bfa68ca2f991c287f6dcf';

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

/// See also [purchaseOrderDetail].
@ProviderFor(purchaseOrderDetail)
const purchaseOrderDetailProvider = PurchaseOrderDetailFamily();

/// See also [purchaseOrderDetail].
class PurchaseOrderDetailFamily extends Family<AsyncValue<PurchaseOrder>> {
  /// See also [purchaseOrderDetail].
  const PurchaseOrderDetailFamily();

  /// See also [purchaseOrderDetail].
  PurchaseOrderDetailProvider call(
    int id,
  ) {
    return PurchaseOrderDetailProvider(
      id,
    );
  }

  @override
  PurchaseOrderDetailProvider getProviderOverride(
    covariant PurchaseOrderDetailProvider provider,
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
  String? get name => r'purchaseOrderDetailProvider';
}

/// See also [purchaseOrderDetail].
class PurchaseOrderDetailProvider
    extends AutoDisposeFutureProvider<PurchaseOrder> {
  /// See also [purchaseOrderDetail].
  PurchaseOrderDetailProvider(
    int id,
  ) : this._internal(
          (ref) => purchaseOrderDetail(
            ref as PurchaseOrderDetailRef,
            id,
          ),
          from: purchaseOrderDetailProvider,
          name: r'purchaseOrderDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$purchaseOrderDetailHash,
          dependencies: PurchaseOrderDetailFamily._dependencies,
          allTransitiveDependencies:
              PurchaseOrderDetailFamily._allTransitiveDependencies,
          id: id,
        );

  PurchaseOrderDetailProvider._internal(
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
    FutureOr<PurchaseOrder> Function(PurchaseOrderDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PurchaseOrderDetailProvider._internal(
        (ref) => create(ref as PurchaseOrderDetailRef),
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
  AutoDisposeFutureProviderElement<PurchaseOrder> createElement() {
    return _PurchaseOrderDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PurchaseOrderDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PurchaseOrderDetailRef on AutoDisposeFutureProviderRef<PurchaseOrder> {
  /// The parameter `id` of this provider.
  int get id;
}

class _PurchaseOrderDetailProviderElement
    extends AutoDisposeFutureProviderElement<PurchaseOrder>
    with PurchaseOrderDetailRef {
  _PurchaseOrderDetailProviderElement(super.provider);

  @override
  int get id => (origin as PurchaseOrderDetailProvider).id;
}

String _$purchaseOrdersHash() => r'580aa5cedaa05193f6f7bc48eaa5b33bcb812101';

abstract class _$PurchaseOrders
    extends BuildlessAutoDisposeAsyncNotifier<List<PurchaseOrder>> {
  late final String? status;
  late final String? search;
  late final String? dateFrom;
  late final String? dateTo;

  FutureOr<List<PurchaseOrder>> build({
    String? status,
    String? search,
    String? dateFrom,
    String? dateTo,
  });
}

/// See also [PurchaseOrders].
@ProviderFor(PurchaseOrders)
const purchaseOrdersProvider = PurchaseOrdersFamily();

/// See also [PurchaseOrders].
class PurchaseOrdersFamily extends Family<AsyncValue<List<PurchaseOrder>>> {
  /// See also [PurchaseOrders].
  const PurchaseOrdersFamily();

  /// See also [PurchaseOrders].
  PurchaseOrdersProvider call({
    String? status,
    String? search,
    String? dateFrom,
    String? dateTo,
  }) {
    return PurchaseOrdersProvider(
      status: status,
      search: search,
      dateFrom: dateFrom,
      dateTo: dateTo,
    );
  }

  @override
  PurchaseOrdersProvider getProviderOverride(
    covariant PurchaseOrdersProvider provider,
  ) {
    return call(
      status: provider.status,
      search: provider.search,
      dateFrom: provider.dateFrom,
      dateTo: provider.dateTo,
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
  String? get name => r'purchaseOrdersProvider';
}

/// See also [PurchaseOrders].
class PurchaseOrdersProvider extends AutoDisposeAsyncNotifierProviderImpl<
    PurchaseOrders, List<PurchaseOrder>> {
  /// See also [PurchaseOrders].
  PurchaseOrdersProvider({
    String? status,
    String? search,
    String? dateFrom,
    String? dateTo,
  }) : this._internal(
          () => PurchaseOrders()
            ..status = status
            ..search = search
            ..dateFrom = dateFrom
            ..dateTo = dateTo,
          from: purchaseOrdersProvider,
          name: r'purchaseOrdersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$purchaseOrdersHash,
          dependencies: PurchaseOrdersFamily._dependencies,
          allTransitiveDependencies:
              PurchaseOrdersFamily._allTransitiveDependencies,
          status: status,
          search: search,
          dateFrom: dateFrom,
          dateTo: dateTo,
        );

  PurchaseOrdersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
    required this.search,
    required this.dateFrom,
    required this.dateTo,
  }) : super.internal();

  final String? status;
  final String? search;
  final String? dateFrom;
  final String? dateTo;

  @override
  FutureOr<List<PurchaseOrder>> runNotifierBuild(
    covariant PurchaseOrders notifier,
  ) {
    return notifier.build(
      status: status,
      search: search,
      dateFrom: dateFrom,
      dateTo: dateTo,
    );
  }

  @override
  Override overrideWith(PurchaseOrders Function() create) {
    return ProviderOverride(
      origin: this,
      override: PurchaseOrdersProvider._internal(
        () => create()
          ..status = status
          ..search = search
          ..dateFrom = dateFrom
          ..dateTo = dateTo,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
        search: search,
        dateFrom: dateFrom,
        dateTo: dateTo,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<PurchaseOrders, List<PurchaseOrder>>
      createElement() {
    return _PurchaseOrdersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PurchaseOrdersProvider &&
        other.status == status &&
        other.search == search &&
        other.dateFrom == dateFrom &&
        other.dateTo == dateTo;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);
    hash = _SystemHash.combine(hash, search.hashCode);
    hash = _SystemHash.combine(hash, dateFrom.hashCode);
    hash = _SystemHash.combine(hash, dateTo.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PurchaseOrdersRef
    on AutoDisposeAsyncNotifierProviderRef<List<PurchaseOrder>> {
  /// The parameter `status` of this provider.
  String? get status;

  /// The parameter `search` of this provider.
  String? get search;

  /// The parameter `dateFrom` of this provider.
  String? get dateFrom;

  /// The parameter `dateTo` of this provider.
  String? get dateTo;
}

class _PurchaseOrdersProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PurchaseOrders,
        List<PurchaseOrder>> with PurchaseOrdersRef {
  _PurchaseOrdersProviderElement(super.provider);

  @override
  String? get status => (origin as PurchaseOrdersProvider).status;
  @override
  String? get search => (origin as PurchaseOrdersProvider).search;
  @override
  String? get dateFrom => (origin as PurchaseOrdersProvider).dateFrom;
  @override
  String? get dateTo => (origin as PurchaseOrdersProvider).dateTo;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
