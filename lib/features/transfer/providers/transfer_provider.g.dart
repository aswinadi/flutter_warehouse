// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transferDetailHash() => r'740e2f86ee6d70df20bff07a1e9bac8b361fbd0b';

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

/// See also [transferDetail].
@ProviderFor(transferDetail)
const transferDetailProvider = TransferDetailFamily();

/// See also [transferDetail].
class TransferDetailFamily extends Family<AsyncValue<WarehouseTransfer>> {
  /// See also [transferDetail].
  const TransferDetailFamily();

  /// See also [transferDetail].
  TransferDetailProvider call(
    int id,
  ) {
    return TransferDetailProvider(
      id,
    );
  }

  @override
  TransferDetailProvider getProviderOverride(
    covariant TransferDetailProvider provider,
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
  String? get name => r'transferDetailProvider';
}

/// See also [transferDetail].
class TransferDetailProvider
    extends AutoDisposeFutureProvider<WarehouseTransfer> {
  /// See also [transferDetail].
  TransferDetailProvider(
    int id,
  ) : this._internal(
          (ref) => transferDetail(
            ref as TransferDetailRef,
            id,
          ),
          from: transferDetailProvider,
          name: r'transferDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$transferDetailHash,
          dependencies: TransferDetailFamily._dependencies,
          allTransitiveDependencies:
              TransferDetailFamily._allTransitiveDependencies,
          id: id,
        );

  TransferDetailProvider._internal(
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
    FutureOr<WarehouseTransfer> Function(TransferDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TransferDetailProvider._internal(
        (ref) => create(ref as TransferDetailRef),
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
  AutoDisposeFutureProviderElement<WarehouseTransfer> createElement() {
    return _TransferDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransferDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TransferDetailRef on AutoDisposeFutureProviderRef<WarehouseTransfer> {
  /// The parameter `id` of this provider.
  int get id;
}

class _TransferDetailProviderElement
    extends AutoDisposeFutureProviderElement<WarehouseTransfer>
    with TransferDetailRef {
  _TransferDetailProviderElement(super.provider);

  @override
  int get id => (origin as TransferDetailProvider).id;
}

String _$warehouseInventoryHash() =>
    r'41b20ff58903096d6e773f326a9d0ddd53a9cdd4';

/// See also [warehouseInventory].
@ProviderFor(warehouseInventory)
const warehouseInventoryProvider = WarehouseInventoryFamily();

/// See also [warehouseInventory].
class WarehouseInventoryFamily extends Family<AsyncValue<List<Inventory>>> {
  /// See also [warehouseInventory].
  const WarehouseInventoryFamily();

  /// See also [warehouseInventory].
  WarehouseInventoryProvider call({
    required int warehouseId,
    String? search,
  }) {
    return WarehouseInventoryProvider(
      warehouseId: warehouseId,
      search: search,
    );
  }

  @override
  WarehouseInventoryProvider getProviderOverride(
    covariant WarehouseInventoryProvider provider,
  ) {
    return call(
      warehouseId: provider.warehouseId,
      search: provider.search,
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
  String? get name => r'warehouseInventoryProvider';
}

/// See also [warehouseInventory].
class WarehouseInventoryProvider
    extends AutoDisposeFutureProvider<List<Inventory>> {
  /// See also [warehouseInventory].
  WarehouseInventoryProvider({
    required int warehouseId,
    String? search,
  }) : this._internal(
          (ref) => warehouseInventory(
            ref as WarehouseInventoryRef,
            warehouseId: warehouseId,
            search: search,
          ),
          from: warehouseInventoryProvider,
          name: r'warehouseInventoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$warehouseInventoryHash,
          dependencies: WarehouseInventoryFamily._dependencies,
          allTransitiveDependencies:
              WarehouseInventoryFamily._allTransitiveDependencies,
          warehouseId: warehouseId,
          search: search,
        );

  WarehouseInventoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.warehouseId,
    required this.search,
  }) : super.internal();

  final int warehouseId;
  final String? search;

  @override
  Override overrideWith(
    FutureOr<List<Inventory>> Function(WarehouseInventoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WarehouseInventoryProvider._internal(
        (ref) => create(ref as WarehouseInventoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        warehouseId: warehouseId,
        search: search,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Inventory>> createElement() {
    return _WarehouseInventoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WarehouseInventoryProvider &&
        other.warehouseId == warehouseId &&
        other.search == search;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, warehouseId.hashCode);
    hash = _SystemHash.combine(hash, search.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WarehouseInventoryRef on AutoDisposeFutureProviderRef<List<Inventory>> {
  /// The parameter `warehouseId` of this provider.
  int get warehouseId;

  /// The parameter `search` of this provider.
  String? get search;
}

class _WarehouseInventoryProviderElement
    extends AutoDisposeFutureProviderElement<List<Inventory>>
    with WarehouseInventoryRef {
  _WarehouseInventoryProviderElement(super.provider);

  @override
  int get warehouseId => (origin as WarehouseInventoryProvider).warehouseId;
  @override
  String? get search => (origin as WarehouseInventoryProvider).search;
}

String _$transfersListHash() => r'a39f0d7e2f55d64256a4bab4b26caf0a1a2725a7';

abstract class _$TransfersList
    extends BuildlessAutoDisposeAsyncNotifier<List<WarehouseTransfer>> {
  late final int? sourceWarehouseId;
  late final int? destinationWarehouseId;
  late final String? status;

  FutureOr<List<WarehouseTransfer>> build({
    int? sourceWarehouseId,
    int? destinationWarehouseId,
    String? status,
  });
}

/// See also [TransfersList].
@ProviderFor(TransfersList)
const transfersListProvider = TransfersListFamily();

/// See also [TransfersList].
class TransfersListFamily extends Family<AsyncValue<List<WarehouseTransfer>>> {
  /// See also [TransfersList].
  const TransfersListFamily();

  /// See also [TransfersList].
  TransfersListProvider call({
    int? sourceWarehouseId,
    int? destinationWarehouseId,
    String? status,
  }) {
    return TransfersListProvider(
      sourceWarehouseId: sourceWarehouseId,
      destinationWarehouseId: destinationWarehouseId,
      status: status,
    );
  }

  @override
  TransfersListProvider getProviderOverride(
    covariant TransfersListProvider provider,
  ) {
    return call(
      sourceWarehouseId: provider.sourceWarehouseId,
      destinationWarehouseId: provider.destinationWarehouseId,
      status: provider.status,
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
  String? get name => r'transfersListProvider';
}

/// See also [TransfersList].
class TransfersListProvider extends AutoDisposeAsyncNotifierProviderImpl<
    TransfersList, List<WarehouseTransfer>> {
  /// See also [TransfersList].
  TransfersListProvider({
    int? sourceWarehouseId,
    int? destinationWarehouseId,
    String? status,
  }) : this._internal(
          () => TransfersList()
            ..sourceWarehouseId = sourceWarehouseId
            ..destinationWarehouseId = destinationWarehouseId
            ..status = status,
          from: transfersListProvider,
          name: r'transfersListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$transfersListHash,
          dependencies: TransfersListFamily._dependencies,
          allTransitiveDependencies:
              TransfersListFamily._allTransitiveDependencies,
          sourceWarehouseId: sourceWarehouseId,
          destinationWarehouseId: destinationWarehouseId,
          status: status,
        );

  TransfersListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sourceWarehouseId,
    required this.destinationWarehouseId,
    required this.status,
  }) : super.internal();

  final int? sourceWarehouseId;
  final int? destinationWarehouseId;
  final String? status;

  @override
  FutureOr<List<WarehouseTransfer>> runNotifierBuild(
    covariant TransfersList notifier,
  ) {
    return notifier.build(
      sourceWarehouseId: sourceWarehouseId,
      destinationWarehouseId: destinationWarehouseId,
      status: status,
    );
  }

  @override
  Override overrideWith(TransfersList Function() create) {
    return ProviderOverride(
      origin: this,
      override: TransfersListProvider._internal(
        () => create()
          ..sourceWarehouseId = sourceWarehouseId
          ..destinationWarehouseId = destinationWarehouseId
          ..status = status,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sourceWarehouseId: sourceWarehouseId,
        destinationWarehouseId: destinationWarehouseId,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<TransfersList,
      List<WarehouseTransfer>> createElement() {
    return _TransfersListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransfersListProvider &&
        other.sourceWarehouseId == sourceWarehouseId &&
        other.destinationWarehouseId == destinationWarehouseId &&
        other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sourceWarehouseId.hashCode);
    hash = _SystemHash.combine(hash, destinationWarehouseId.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TransfersListRef
    on AutoDisposeAsyncNotifierProviderRef<List<WarehouseTransfer>> {
  /// The parameter `sourceWarehouseId` of this provider.
  int? get sourceWarehouseId;

  /// The parameter `destinationWarehouseId` of this provider.
  int? get destinationWarehouseId;

  /// The parameter `status` of this provider.
  String? get status;
}

class _TransfersListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<TransfersList,
        List<WarehouseTransfer>> with TransfersListRef {
  _TransfersListProviderElement(super.provider);

  @override
  int? get sourceWarehouseId =>
      (origin as TransfersListProvider).sourceWarehouseId;
  @override
  int? get destinationWarehouseId =>
      (origin as TransfersListProvider).destinationWarehouseId;
  @override
  String? get status => (origin as TransfersListProvider).status;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
