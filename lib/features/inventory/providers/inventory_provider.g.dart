// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$inventoryRepositoryHash() =>
    r'b55e186b480cd202fa4efde668828b1b5210587e';

/// See also [inventoryRepository].
@ProviderFor(inventoryRepository)
final inventoryRepositoryProvider =
    AutoDisposeProvider<InventoryRepository>.internal(
  inventoryRepository,
  name: r'inventoryRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inventoryRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef InventoryRepositoryRef = AutoDisposeProviderRef<InventoryRepository>;
String _$inventoryListHash() => r'cfefb3843ac582ba3cf5d8db75e893f4311be10a';

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

abstract class _$InventoryList
    extends BuildlessAutoDisposeAsyncNotifier<List<Inventory>> {
  late final String? search;

  FutureOr<List<Inventory>> build({
    String? search,
  });
}

/// See also [InventoryList].
@ProviderFor(InventoryList)
const inventoryListProvider = InventoryListFamily();

/// See also [InventoryList].
class InventoryListFamily extends Family<AsyncValue<List<Inventory>>> {
  /// See also [InventoryList].
  const InventoryListFamily();

  /// See also [InventoryList].
  InventoryListProvider call({
    String? search,
  }) {
    return InventoryListProvider(
      search: search,
    );
  }

  @override
  InventoryListProvider getProviderOverride(
    covariant InventoryListProvider provider,
  ) {
    return call(
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
  String? get name => r'inventoryListProvider';
}

/// See also [InventoryList].
class InventoryListProvider extends AutoDisposeAsyncNotifierProviderImpl<
    InventoryList, List<Inventory>> {
  /// See also [InventoryList].
  InventoryListProvider({
    String? search,
  }) : this._internal(
          () => InventoryList()..search = search,
          from: inventoryListProvider,
          name: r'inventoryListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$inventoryListHash,
          dependencies: InventoryListFamily._dependencies,
          allTransitiveDependencies:
              InventoryListFamily._allTransitiveDependencies,
          search: search,
        );

  InventoryListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.search,
  }) : super.internal();

  final String? search;

  @override
  FutureOr<List<Inventory>> runNotifierBuild(
    covariant InventoryList notifier,
  ) {
    return notifier.build(
      search: search,
    );
  }

  @override
  Override overrideWith(InventoryList Function() create) {
    return ProviderOverride(
      origin: this,
      override: InventoryListProvider._internal(
        () => create()..search = search,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        search: search,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<InventoryList, List<Inventory>>
      createElement() {
    return _InventoryListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InventoryListProvider && other.search == search;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, search.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin InventoryListRef on AutoDisposeAsyncNotifierProviderRef<List<Inventory>> {
  /// The parameter `search` of this provider.
  String? get search;
}

class _InventoryListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<InventoryList,
        List<Inventory>> with InventoryListRef {
  _InventoryListProviderElement(super.provider);

  @override
  String? get search => (origin as InventoryListProvider).search;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
