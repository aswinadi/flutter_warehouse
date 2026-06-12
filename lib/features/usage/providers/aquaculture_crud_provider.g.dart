// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aquaculture_crud_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aquacultureCrudRepositoryHash() =>
    r'f107e3cc46ceb8595c23d47a307128e7ef8d642b';

/// See also [aquacultureCrudRepository].
@ProviderFor(aquacultureCrudRepository)
final aquacultureCrudRepositoryProvider =
    AutoDisposeProvider<AquacultureCrudRepository>.internal(
  aquacultureCrudRepository,
  name: r'aquacultureCrudRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$aquacultureCrudRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AquacultureCrudRepositoryRef
    = AutoDisposeProviderRef<AquacultureCrudRepository>;
String _$aquacultureCrudListHash() =>
    r'08af95d67f61c438755a6b499af56d23a11e173d';

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

abstract class _$AquacultureCrudList
    extends BuildlessAutoDisposeAsyncNotifier<List<dynamic>> {
  late final String resource;
  late final Map<String, dynamic>? params;

  FutureOr<List<dynamic>> build(
    String resource, {
    Map<String, dynamic>? params,
  });
}

/// See also [AquacultureCrudList].
@ProviderFor(AquacultureCrudList)
const aquacultureCrudListProvider = AquacultureCrudListFamily();

/// See also [AquacultureCrudList].
class AquacultureCrudListFamily extends Family<AsyncValue<List<dynamic>>> {
  /// See also [AquacultureCrudList].
  const AquacultureCrudListFamily();

  /// See also [AquacultureCrudList].
  AquacultureCrudListProvider call(
    String resource, {
    Map<String, dynamic>? params,
  }) {
    return AquacultureCrudListProvider(
      resource,
      params: params,
    );
  }

  @override
  AquacultureCrudListProvider getProviderOverride(
    covariant AquacultureCrudListProvider provider,
  ) {
    return call(
      provider.resource,
      params: provider.params,
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
  String? get name => r'aquacultureCrudListProvider';
}

/// See also [AquacultureCrudList].
class AquacultureCrudListProvider extends AutoDisposeAsyncNotifierProviderImpl<
    AquacultureCrudList, List<dynamic>> {
  /// See also [AquacultureCrudList].
  AquacultureCrudListProvider(
    String resource, {
    Map<String, dynamic>? params,
  }) : this._internal(
          () => AquacultureCrudList()
            ..resource = resource
            ..params = params,
          from: aquacultureCrudListProvider,
          name: r'aquacultureCrudListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$aquacultureCrudListHash,
          dependencies: AquacultureCrudListFamily._dependencies,
          allTransitiveDependencies:
              AquacultureCrudListFamily._allTransitiveDependencies,
          resource: resource,
          params: params,
        );

  AquacultureCrudListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.resource,
    required this.params,
  }) : super.internal();

  final String resource;
  final Map<String, dynamic>? params;

  @override
  FutureOr<List<dynamic>> runNotifierBuild(
    covariant AquacultureCrudList notifier,
  ) {
    return notifier.build(
      resource,
      params: params,
    );
  }

  @override
  Override overrideWith(AquacultureCrudList Function() create) {
    return ProviderOverride(
      origin: this,
      override: AquacultureCrudListProvider._internal(
        () => create()
          ..resource = resource
          ..params = params,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        resource: resource,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<AquacultureCrudList, List<dynamic>>
      createElement() {
    return _AquacultureCrudListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AquacultureCrudListProvider &&
        other.resource == resource &&
        other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, resource.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AquacultureCrudListRef
    on AutoDisposeAsyncNotifierProviderRef<List<dynamic>> {
  /// The parameter `resource` of this provider.
  String get resource;

  /// The parameter `params` of this provider.
  Map<String, dynamic>? get params;
}

class _AquacultureCrudListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<AquacultureCrudList,
        List<dynamic>> with AquacultureCrudListRef {
  _AquacultureCrudListProviderElement(super.provider);

  @override
  String get resource => (origin as AquacultureCrudListProvider).resource;
  @override
  Map<String, dynamic>? get params =>
      (origin as AquacultureCrudListProvider).params;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
