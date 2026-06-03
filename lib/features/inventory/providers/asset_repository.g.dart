// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$assetRepositoryHash() => r'370ea822de81a4d2957424da6b75151fe8d39834';

/// See also [assetRepository].
@ProviderFor(assetRepository)
final assetRepositoryProvider = AutoDisposeProvider<AssetRepository>.internal(
  assetRepository,
  name: r'assetRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$assetRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AssetRepositoryRef = AutoDisposeProviderRef<AssetRepository>;
String _$assetDetailHash() => r'dbeee96ee59502e4ef8b837ecb28770b671e9234';

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

/// See also [assetDetail].
@ProviderFor(assetDetail)
const assetDetailProvider = AssetDetailFamily();

/// See also [assetDetail].
class AssetDetailFamily extends Family<AsyncValue<Asset>> {
  /// See also [assetDetail].
  const AssetDetailFamily();

  /// See also [assetDetail].
  AssetDetailProvider call(
    int id,
  ) {
    return AssetDetailProvider(
      id,
    );
  }

  @override
  AssetDetailProvider getProviderOverride(
    covariant AssetDetailProvider provider,
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
  String? get name => r'assetDetailProvider';
}

/// See also [assetDetail].
class AssetDetailProvider extends AutoDisposeFutureProvider<Asset> {
  /// See also [assetDetail].
  AssetDetailProvider(
    int id,
  ) : this._internal(
          (ref) => assetDetail(
            ref as AssetDetailRef,
            id,
          ),
          from: assetDetailProvider,
          name: r'assetDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$assetDetailHash,
          dependencies: AssetDetailFamily._dependencies,
          allTransitiveDependencies:
              AssetDetailFamily._allTransitiveDependencies,
          id: id,
        );

  AssetDetailProvider._internal(
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
    FutureOr<Asset> Function(AssetDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AssetDetailProvider._internal(
        (ref) => create(ref as AssetDetailRef),
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
  AutoDisposeFutureProviderElement<Asset> createElement() {
    return _AssetDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AssetDetailRef on AutoDisposeFutureProviderRef<Asset> {
  /// The parameter `id` of this provider.
  int get id;
}

class _AssetDetailProviderElement
    extends AutoDisposeFutureProviderElement<Asset> with AssetDetailRef {
  _AssetDetailProviderElement(super.provider);

  @override
  int get id => (origin as AssetDetailProvider).id;
}

String _$assetOfficesHash() => r'87ea5af833a96ef9b2920161d6f714acad6f7597';

/// See also [assetOffices].
@ProviderFor(assetOffices)
const assetOfficesProvider = AssetOfficesFamily();

/// See also [assetOffices].
class AssetOfficesFamily extends Family<AsyncValue<List<AssetOffice>>> {
  /// See also [assetOffices].
  const AssetOfficesFamily();

  /// See also [assetOffices].
  AssetOfficesProvider call({
    int? companyId,
  }) {
    return AssetOfficesProvider(
      companyId: companyId,
    );
  }

  @override
  AssetOfficesProvider getProviderOverride(
    covariant AssetOfficesProvider provider,
  ) {
    return call(
      companyId: provider.companyId,
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
  String? get name => r'assetOfficesProvider';
}

/// See also [assetOffices].
class AssetOfficesProvider
    extends AutoDisposeFutureProvider<List<AssetOffice>> {
  /// See also [assetOffices].
  AssetOfficesProvider({
    int? companyId,
  }) : this._internal(
          (ref) => assetOffices(
            ref as AssetOfficesRef,
            companyId: companyId,
          ),
          from: assetOfficesProvider,
          name: r'assetOfficesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$assetOfficesHash,
          dependencies: AssetOfficesFamily._dependencies,
          allTransitiveDependencies:
              AssetOfficesFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  AssetOfficesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.companyId,
  }) : super.internal();

  final int? companyId;

  @override
  Override overrideWith(
    FutureOr<List<AssetOffice>> Function(AssetOfficesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AssetOfficesProvider._internal(
        (ref) => create(ref as AssetOfficesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        companyId: companyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<AssetOffice>> createElement() {
    return _AssetOfficesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetOfficesProvider && other.companyId == companyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, companyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AssetOfficesRef on AutoDisposeFutureProviderRef<List<AssetOffice>> {
  /// The parameter `companyId` of this provider.
  int? get companyId;
}

class _AssetOfficesProviderElement
    extends AutoDisposeFutureProviderElement<List<AssetOffice>>
    with AssetOfficesRef {
  _AssetOfficesProviderElement(super.provider);

  @override
  int? get companyId => (origin as AssetOfficesProvider).companyId;
}

String _$assetEmployeesHash() => r'a61ccfd4634acda6aaddff33eda56c5c468ffb6a';

/// See also [assetEmployees].
@ProviderFor(assetEmployees)
const assetEmployeesProvider = AssetEmployeesFamily();

/// See also [assetEmployees].
class AssetEmployeesFamily extends Family<AsyncValue<List<AssetEmployee>>> {
  /// See also [assetEmployees].
  const AssetEmployeesFamily();

  /// See also [assetEmployees].
  AssetEmployeesProvider call({
    int? companyId,
  }) {
    return AssetEmployeesProvider(
      companyId: companyId,
    );
  }

  @override
  AssetEmployeesProvider getProviderOverride(
    covariant AssetEmployeesProvider provider,
  ) {
    return call(
      companyId: provider.companyId,
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
  String? get name => r'assetEmployeesProvider';
}

/// See also [assetEmployees].
class AssetEmployeesProvider
    extends AutoDisposeFutureProvider<List<AssetEmployee>> {
  /// See also [assetEmployees].
  AssetEmployeesProvider({
    int? companyId,
  }) : this._internal(
          (ref) => assetEmployees(
            ref as AssetEmployeesRef,
            companyId: companyId,
          ),
          from: assetEmployeesProvider,
          name: r'assetEmployeesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$assetEmployeesHash,
          dependencies: AssetEmployeesFamily._dependencies,
          allTransitiveDependencies:
              AssetEmployeesFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  AssetEmployeesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.companyId,
  }) : super.internal();

  final int? companyId;

  @override
  Override overrideWith(
    FutureOr<List<AssetEmployee>> Function(AssetEmployeesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AssetEmployeesProvider._internal(
        (ref) => create(ref as AssetEmployeesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        companyId: companyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<AssetEmployee>> createElement() {
    return _AssetEmployeesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetEmployeesProvider && other.companyId == companyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, companyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AssetEmployeesRef on AutoDisposeFutureProviderRef<List<AssetEmployee>> {
  /// The parameter `companyId` of this provider.
  int? get companyId;
}

class _AssetEmployeesProviderElement
    extends AutoDisposeFutureProviderElement<List<AssetEmployee>>
    with AssetEmployeesRef {
  _AssetEmployeesProviderElement(super.provider);

  @override
  int? get companyId => (origin as AssetEmployeesProvider).companyId;
}

String _$assetSuppliersHash() => r'8dd2db64f4ecf70757d9d5440a71f89ae1debdf6';

/// See also [assetSuppliers].
@ProviderFor(assetSuppliers)
const assetSuppliersProvider = AssetSuppliersFamily();

/// See also [assetSuppliers].
class AssetSuppliersFamily extends Family<AsyncValue<List<Supplier>>> {
  /// See also [assetSuppliers].
  const AssetSuppliersFamily();

  /// See also [assetSuppliers].
  AssetSuppliersProvider call({
    int? companyId,
  }) {
    return AssetSuppliersProvider(
      companyId: companyId,
    );
  }

  @override
  AssetSuppliersProvider getProviderOverride(
    covariant AssetSuppliersProvider provider,
  ) {
    return call(
      companyId: provider.companyId,
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
  String? get name => r'assetSuppliersProvider';
}

/// See also [assetSuppliers].
class AssetSuppliersProvider extends AutoDisposeFutureProvider<List<Supplier>> {
  /// See also [assetSuppliers].
  AssetSuppliersProvider({
    int? companyId,
  }) : this._internal(
          (ref) => assetSuppliers(
            ref as AssetSuppliersRef,
            companyId: companyId,
          ),
          from: assetSuppliersProvider,
          name: r'assetSuppliersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$assetSuppliersHash,
          dependencies: AssetSuppliersFamily._dependencies,
          allTransitiveDependencies:
              AssetSuppliersFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  AssetSuppliersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.companyId,
  }) : super.internal();

  final int? companyId;

  @override
  Override overrideWith(
    FutureOr<List<Supplier>> Function(AssetSuppliersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AssetSuppliersProvider._internal(
        (ref) => create(ref as AssetSuppliersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        companyId: companyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Supplier>> createElement() {
    return _AssetSuppliersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetSuppliersProvider && other.companyId == companyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, companyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AssetSuppliersRef on AutoDisposeFutureProviderRef<List<Supplier>> {
  /// The parameter `companyId` of this provider.
  int? get companyId;
}

class _AssetSuppliersProviderElement
    extends AutoDisposeFutureProviderElement<List<Supplier>>
    with AssetSuppliersRef {
  _AssetSuppliersProviderElement(super.provider);

  @override
  int? get companyId => (origin as AssetSuppliersProvider).companyId;
}

String _$assetListHash() => r'a47aa29051517656ed4d440767a6588c526b0b07';

abstract class _$AssetList
    extends BuildlessAutoDisposeAsyncNotifier<List<Asset>> {
  late final String? search;
  late final String? category;
  late final String? status;

  FutureOr<List<Asset>> build({
    String? search,
    String? category,
    String? status,
  });
}

/// See also [AssetList].
@ProviderFor(AssetList)
const assetListProvider = AssetListFamily();

/// See also [AssetList].
class AssetListFamily extends Family<AsyncValue<List<Asset>>> {
  /// See also [AssetList].
  const AssetListFamily();

  /// See also [AssetList].
  AssetListProvider call({
    String? search,
    String? category,
    String? status,
  }) {
    return AssetListProvider(
      search: search,
      category: category,
      status: status,
    );
  }

  @override
  AssetListProvider getProviderOverride(
    covariant AssetListProvider provider,
  ) {
    return call(
      search: provider.search,
      category: provider.category,
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
  String? get name => r'assetListProvider';
}

/// See also [AssetList].
class AssetListProvider
    extends AutoDisposeAsyncNotifierProviderImpl<AssetList, List<Asset>> {
  /// See also [AssetList].
  AssetListProvider({
    String? search,
    String? category,
    String? status,
  }) : this._internal(
          () => AssetList()
            ..search = search
            ..category = category
            ..status = status,
          from: assetListProvider,
          name: r'assetListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$assetListHash,
          dependencies: AssetListFamily._dependencies,
          allTransitiveDependencies: AssetListFamily._allTransitiveDependencies,
          search: search,
          category: category,
          status: status,
        );

  AssetListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.search,
    required this.category,
    required this.status,
  }) : super.internal();

  final String? search;
  final String? category;
  final String? status;

  @override
  FutureOr<List<Asset>> runNotifierBuild(
    covariant AssetList notifier,
  ) {
    return notifier.build(
      search: search,
      category: category,
      status: status,
    );
  }

  @override
  Override overrideWith(AssetList Function() create) {
    return ProviderOverride(
      origin: this,
      override: AssetListProvider._internal(
        () => create()
          ..search = search
          ..category = category
          ..status = status,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        search: search,
        category: category,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<AssetList, List<Asset>>
      createElement() {
    return _AssetListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetListProvider &&
        other.search == search &&
        other.category == category &&
        other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, search.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AssetListRef on AutoDisposeAsyncNotifierProviderRef<List<Asset>> {
  /// The parameter `search` of this provider.
  String? get search;

  /// The parameter `category` of this provider.
  String? get category;

  /// The parameter `status` of this provider.
  String? get status;
}

class _AssetListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<AssetList, List<Asset>>
    with AssetListRef {
  _AssetListProviderElement(super.provider);

  @override
  String? get search => (origin as AssetListProvider).search;
  @override
  String? get category => (origin as AssetListProvider).category;
  @override
  String? get status => (origin as AssetListProvider).status;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
