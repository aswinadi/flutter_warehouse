// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_breakdown_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$inventoryBreakdownHash() =>
    r'1ecefce0c540b87f4073a4ca4a8986521fe13078';

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

/// See also [inventoryBreakdown].
@ProviderFor(inventoryBreakdown)
const inventoryBreakdownProvider = InventoryBreakdownFamily();

/// See also [inventoryBreakdown].
class InventoryBreakdownFamily extends Family<AsyncValue<InventoryBreakdown>> {
  /// See also [inventoryBreakdown].
  const InventoryBreakdownFamily();

  /// See also [inventoryBreakdown].
  InventoryBreakdownProvider call(
    String barcodeCode,
  ) {
    return InventoryBreakdownProvider(
      barcodeCode,
    );
  }

  @override
  InventoryBreakdownProvider getProviderOverride(
    covariant InventoryBreakdownProvider provider,
  ) {
    return call(
      provider.barcodeCode,
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
  String? get name => r'inventoryBreakdownProvider';
}

/// See also [inventoryBreakdown].
class InventoryBreakdownProvider
    extends AutoDisposeFutureProvider<InventoryBreakdown> {
  /// See also [inventoryBreakdown].
  InventoryBreakdownProvider(
    String barcodeCode,
  ) : this._internal(
          (ref) => inventoryBreakdown(
            ref as InventoryBreakdownRef,
            barcodeCode,
          ),
          from: inventoryBreakdownProvider,
          name: r'inventoryBreakdownProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$inventoryBreakdownHash,
          dependencies: InventoryBreakdownFamily._dependencies,
          allTransitiveDependencies:
              InventoryBreakdownFamily._allTransitiveDependencies,
          barcodeCode: barcodeCode,
        );

  InventoryBreakdownProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.barcodeCode,
  }) : super.internal();

  final String barcodeCode;

  @override
  Override overrideWith(
    FutureOr<InventoryBreakdown> Function(InventoryBreakdownRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: InventoryBreakdownProvider._internal(
        (ref) => create(ref as InventoryBreakdownRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        barcodeCode: barcodeCode,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<InventoryBreakdown> createElement() {
    return _InventoryBreakdownProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InventoryBreakdownProvider &&
        other.barcodeCode == barcodeCode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, barcodeCode.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin InventoryBreakdownRef
    on AutoDisposeFutureProviderRef<InventoryBreakdown> {
  /// The parameter `barcodeCode` of this provider.
  String get barcodeCode;
}

class _InventoryBreakdownProviderElement
    extends AutoDisposeFutureProviderElement<InventoryBreakdown>
    with InventoryBreakdownRef {
  _InventoryBreakdownProviderElement(super.provider);

  @override
  String get barcodeCode => (origin as InventoryBreakdownProvider).barcodeCode;
}

String _$inventoryBreakdownBySkuHash() =>
    r'5a8b5366ac63a80b290b18f414bcc68b8a820e36';

/// See also [inventoryBreakdownBySku].
@ProviderFor(inventoryBreakdownBySku)
const inventoryBreakdownBySkuProvider = InventoryBreakdownBySkuFamily();

/// See also [inventoryBreakdownBySku].
class InventoryBreakdownBySkuFamily
    extends Family<AsyncValue<InventoryBreakdown>> {
  /// See also [inventoryBreakdownBySku].
  const InventoryBreakdownBySkuFamily();

  /// See also [inventoryBreakdownBySku].
  InventoryBreakdownBySkuProvider call(
    String sku,
  ) {
    return InventoryBreakdownBySkuProvider(
      sku,
    );
  }

  @override
  InventoryBreakdownBySkuProvider getProviderOverride(
    covariant InventoryBreakdownBySkuProvider provider,
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
  String? get name => r'inventoryBreakdownBySkuProvider';
}

/// See also [inventoryBreakdownBySku].
class InventoryBreakdownBySkuProvider
    extends AutoDisposeFutureProvider<InventoryBreakdown> {
  /// See also [inventoryBreakdownBySku].
  InventoryBreakdownBySkuProvider(
    String sku,
  ) : this._internal(
          (ref) => inventoryBreakdownBySku(
            ref as InventoryBreakdownBySkuRef,
            sku,
          ),
          from: inventoryBreakdownBySkuProvider,
          name: r'inventoryBreakdownBySkuProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$inventoryBreakdownBySkuHash,
          dependencies: InventoryBreakdownBySkuFamily._dependencies,
          allTransitiveDependencies:
              InventoryBreakdownBySkuFamily._allTransitiveDependencies,
          sku: sku,
        );

  InventoryBreakdownBySkuProvider._internal(
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
  Override overrideWith(
    FutureOr<InventoryBreakdown> Function(InventoryBreakdownBySkuRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: InventoryBreakdownBySkuProvider._internal(
        (ref) => create(ref as InventoryBreakdownBySkuRef),
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
  AutoDisposeFutureProviderElement<InventoryBreakdown> createElement() {
    return _InventoryBreakdownBySkuProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InventoryBreakdownBySkuProvider && other.sku == sku;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sku.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin InventoryBreakdownBySkuRef
    on AutoDisposeFutureProviderRef<InventoryBreakdown> {
  /// The parameter `sku` of this provider.
  String get sku;
}

class _InventoryBreakdownBySkuProviderElement
    extends AutoDisposeFutureProviderElement<InventoryBreakdown>
    with InventoryBreakdownBySkuRef {
  _InventoryBreakdownBySkuProviderElement(super.provider);

  @override
  String get sku => (origin as InventoryBreakdownBySkuProvider).sku;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
