// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packing_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$packingListRepositoryHash() =>
    r'8962e2d6c53283285f47eac7a4c74ae2c81d89fb';

/// See also [packingListRepository].
@ProviderFor(packingListRepository)
final packingListRepositoryProvider =
    AutoDisposeProvider<PackingListRepository>.internal(
  packingListRepository,
  name: r'packingListRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$packingListRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PackingListRepositoryRef
    = AutoDisposeProviderRef<PackingListRepository>;
String _$packingListDetailHash() => r'f0d826163286ca0196ac96c9f589692cc44c66a4';

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

/// See also [packingListDetail].
@ProviderFor(packingListDetail)
const packingListDetailProvider = PackingListDetailFamily();

/// See also [packingListDetail].
class PackingListDetailFamily extends Family<AsyncValue<PackingList>> {
  /// See also [packingListDetail].
  const PackingListDetailFamily();

  /// See also [packingListDetail].
  PackingListDetailProvider call(
    int id,
  ) {
    return PackingListDetailProvider(
      id,
    );
  }

  @override
  PackingListDetailProvider getProviderOverride(
    covariant PackingListDetailProvider provider,
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
  String? get name => r'packingListDetailProvider';
}

/// See also [packingListDetail].
class PackingListDetailProvider extends AutoDisposeFutureProvider<PackingList> {
  /// See also [packingListDetail].
  PackingListDetailProvider(
    int id,
  ) : this._internal(
          (ref) => packingListDetail(
            ref as PackingListDetailRef,
            id,
          ),
          from: packingListDetailProvider,
          name: r'packingListDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$packingListDetailHash,
          dependencies: PackingListDetailFamily._dependencies,
          allTransitiveDependencies:
              PackingListDetailFamily._allTransitiveDependencies,
          id: id,
        );

  PackingListDetailProvider._internal(
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
    FutureOr<PackingList> Function(PackingListDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PackingListDetailProvider._internal(
        (ref) => create(ref as PackingListDetailRef),
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
  AutoDisposeFutureProviderElement<PackingList> createElement() {
    return _PackingListDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PackingListDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PackingListDetailRef on AutoDisposeFutureProviderRef<PackingList> {
  /// The parameter `id` of this provider.
  int get id;
}

class _PackingListDetailProviderElement
    extends AutoDisposeFutureProviderElement<PackingList>
    with PackingListDetailRef {
  _PackingListDetailProviderElement(super.provider);

  @override
  int get id => (origin as PackingListDetailProvider).id;
}

String _$availablePoItemsHash() => r'0d66e80201f62bedfe8a8931956983b72af0a594';

/// See also [availablePoItems].
@ProviderFor(availablePoItems)
const availablePoItemsProvider = AvailablePoItemsFamily();

/// See also [availablePoItems].
class AvailablePoItemsFamily extends Family<AsyncValue<List<dynamic>>> {
  /// See also [availablePoItems].
  const AvailablePoItemsFamily();

  /// See also [availablePoItems].
  AvailablePoItemsProvider call(
    int id,
  ) {
    return AvailablePoItemsProvider(
      id,
    );
  }

  @override
  AvailablePoItemsProvider getProviderOverride(
    covariant AvailablePoItemsProvider provider,
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
  String? get name => r'availablePoItemsProvider';
}

/// See also [availablePoItems].
class AvailablePoItemsProvider
    extends AutoDisposeFutureProvider<List<dynamic>> {
  /// See also [availablePoItems].
  AvailablePoItemsProvider(
    int id,
  ) : this._internal(
          (ref) => availablePoItems(
            ref as AvailablePoItemsRef,
            id,
          ),
          from: availablePoItemsProvider,
          name: r'availablePoItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$availablePoItemsHash,
          dependencies: AvailablePoItemsFamily._dependencies,
          allTransitiveDependencies:
              AvailablePoItemsFamily._allTransitiveDependencies,
          id: id,
        );

  AvailablePoItemsProvider._internal(
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
    FutureOr<List<dynamic>> Function(AvailablePoItemsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AvailablePoItemsProvider._internal(
        (ref) => create(ref as AvailablePoItemsRef),
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
  AutoDisposeFutureProviderElement<List<dynamic>> createElement() {
    return _AvailablePoItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AvailablePoItemsProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AvailablePoItemsRef on AutoDisposeFutureProviderRef<List<dynamic>> {
  /// The parameter `id` of this provider.
  int get id;
}

class _AvailablePoItemsProviderElement
    extends AutoDisposeFutureProviderElement<List<dynamic>>
    with AvailablePoItemsRef {
  _AvailablePoItemsProviderElement(super.provider);

  @override
  int get id => (origin as AvailablePoItemsProvider).id;
}

String _$availableInventoryItemsHash() =>
    r'7a0c6dbd36aa733958513539e7cd0cddbe341313';

/// See also [availableInventoryItems].
@ProviderFor(availableInventoryItems)
const availableInventoryItemsProvider = AvailableInventoryItemsFamily();

/// See also [availableInventoryItems].
class AvailableInventoryItemsFamily extends Family<AsyncValue<List<dynamic>>> {
  /// See also [availableInventoryItems].
  const AvailableInventoryItemsFamily();

  /// See also [availableInventoryItems].
  AvailableInventoryItemsProvider call(
    int id,
  ) {
    return AvailableInventoryItemsProvider(
      id,
    );
  }

  @override
  AvailableInventoryItemsProvider getProviderOverride(
    covariant AvailableInventoryItemsProvider provider,
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
  String? get name => r'availableInventoryItemsProvider';
}

/// See also [availableInventoryItems].
class AvailableInventoryItemsProvider
    extends AutoDisposeFutureProvider<List<dynamic>> {
  /// See also [availableInventoryItems].
  AvailableInventoryItemsProvider(
    int id,
  ) : this._internal(
          (ref) => availableInventoryItems(
            ref as AvailableInventoryItemsRef,
            id,
          ),
          from: availableInventoryItemsProvider,
          name: r'availableInventoryItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$availableInventoryItemsHash,
          dependencies: AvailableInventoryItemsFamily._dependencies,
          allTransitiveDependencies:
              AvailableInventoryItemsFamily._allTransitiveDependencies,
          id: id,
        );

  AvailableInventoryItemsProvider._internal(
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
    FutureOr<List<dynamic>> Function(AvailableInventoryItemsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AvailableInventoryItemsProvider._internal(
        (ref) => create(ref as AvailableInventoryItemsRef),
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
  AutoDisposeFutureProviderElement<List<dynamic>> createElement() {
    return _AvailableInventoryItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AvailableInventoryItemsProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AvailableInventoryItemsRef
    on AutoDisposeFutureProviderRef<List<dynamic>> {
  /// The parameter `id` of this provider.
  int get id;
}

class _AvailableInventoryItemsProviderElement
    extends AutoDisposeFutureProviderElement<List<dynamic>>
    with AvailableInventoryItemsRef {
  _AvailableInventoryItemsProviderElement(super.provider);

  @override
  int get id => (origin as AvailableInventoryItemsProvider).id;
}

String _$packingListsHash() => r'f9fb56c3b274beeb0adea4415e62a128e2cd3b58';

abstract class _$PackingLists
    extends BuildlessAutoDisposeAsyncNotifier<List<PackingList>> {
  late final String? status;
  late final String? search;

  FutureOr<List<PackingList>> build({
    String? status,
    String? search,
  });
}

/// See also [PackingLists].
@ProviderFor(PackingLists)
const packingListsProvider = PackingListsFamily();

/// See also [PackingLists].
class PackingListsFamily extends Family<AsyncValue<List<PackingList>>> {
  /// See also [PackingLists].
  const PackingListsFamily();

  /// See also [PackingLists].
  PackingListsProvider call({
    String? status,
    String? search,
  }) {
    return PackingListsProvider(
      status: status,
      search: search,
    );
  }

  @override
  PackingListsProvider getProviderOverride(
    covariant PackingListsProvider provider,
  ) {
    return call(
      status: provider.status,
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
  String? get name => r'packingListsProvider';
}

/// See also [PackingLists].
class PackingListsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    PackingLists, List<PackingList>> {
  /// See also [PackingLists].
  PackingListsProvider({
    String? status,
    String? search,
  }) : this._internal(
          () => PackingLists()
            ..status = status
            ..search = search,
          from: packingListsProvider,
          name: r'packingListsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$packingListsHash,
          dependencies: PackingListsFamily._dependencies,
          allTransitiveDependencies:
              PackingListsFamily._allTransitiveDependencies,
          status: status,
          search: search,
        );

  PackingListsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
    required this.search,
  }) : super.internal();

  final String? status;
  final String? search;

  @override
  FutureOr<List<PackingList>> runNotifierBuild(
    covariant PackingLists notifier,
  ) {
    return notifier.build(
      status: status,
      search: search,
    );
  }

  @override
  Override overrideWith(PackingLists Function() create) {
    return ProviderOverride(
      origin: this,
      override: PackingListsProvider._internal(
        () => create()
          ..status = status
          ..search = search,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
        search: search,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<PackingLists, List<PackingList>>
      createElement() {
    return _PackingListsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PackingListsProvider &&
        other.status == status &&
        other.search == search;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);
    hash = _SystemHash.combine(hash, search.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PackingListsRef
    on AutoDisposeAsyncNotifierProviderRef<List<PackingList>> {
  /// The parameter `status` of this provider.
  String? get status;

  /// The parameter `search` of this provider.
  String? get search;
}

class _PackingListsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PackingLists,
        List<PackingList>> with PackingListsRef {
  _PackingListsProviderElement(super.provider);

  @override
  String? get status => (origin as PackingListsProvider).status;
  @override
  String? get search => (origin as PackingListsProvider).search;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
