// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cost_centre_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$costCentreRepositoryHash() =>
    r'7d2bf4100b1b8e764456a5904ba85c2f4d35bf4d';

/// See also [costCentreRepository].
@ProviderFor(costCentreRepository)
final costCentreRepositoryProvider =
    AutoDisposeProvider<CostCentreRepository>.internal(
  costCentreRepository,
  name: r'costCentreRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$costCentreRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CostCentreRepositoryRef = AutoDisposeProviderRef<CostCentreRepository>;
String _$costCentresHash() => r'8f7d8f289c86b4977a55909ebe9e65cb81736340';

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

/// See also [costCentres].
@ProviderFor(costCentres)
const costCentresProvider = CostCentresFamily();

/// See also [costCentres].
class CostCentresFamily extends Family<AsyncValue<List<CostCentre>>> {
  /// See also [costCentres].
  const CostCentresFamily();

  /// See also [costCentres].
  CostCentresProvider call({
    required int companyId,
  }) {
    return CostCentresProvider(
      companyId: companyId,
    );
  }

  @override
  CostCentresProvider getProviderOverride(
    covariant CostCentresProvider provider,
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
  String? get name => r'costCentresProvider';
}

/// See also [costCentres].
class CostCentresProvider extends AutoDisposeFutureProvider<List<CostCentre>> {
  /// See also [costCentres].
  CostCentresProvider({
    required int companyId,
  }) : this._internal(
          (ref) => costCentres(
            ref as CostCentresRef,
            companyId: companyId,
          ),
          from: costCentresProvider,
          name: r'costCentresProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$costCentresHash,
          dependencies: CostCentresFamily._dependencies,
          allTransitiveDependencies:
              CostCentresFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  CostCentresProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.companyId,
  }) : super.internal();

  final int companyId;

  @override
  Override overrideWith(
    FutureOr<List<CostCentre>> Function(CostCentresRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CostCentresProvider._internal(
        (ref) => create(ref as CostCentresRef),
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
  AutoDisposeFutureProviderElement<List<CostCentre>> createElement() {
    return _CostCentresProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CostCentresProvider && other.companyId == companyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, companyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CostCentresRef on AutoDisposeFutureProviderRef<List<CostCentre>> {
  /// The parameter `companyId` of this provider.
  int get companyId;
}

class _CostCentresProviderElement
    extends AutoDisposeFutureProviderElement<List<CostCentre>>
    with CostCentresRef {
  _CostCentresProviderElement(super.provider);

  @override
  int get companyId => (origin as CostCentresProvider).companyId;
}

String _$costCodesHash() => r'eb3d4ca15e2b30fa848f69d11c962e9ed0cb5346';

/// See also [costCodes].
@ProviderFor(costCodes)
const costCodesProvider = CostCodesFamily();

/// See also [costCodes].
class CostCodesFamily extends Family<AsyncValue<List<CostCode>>> {
  /// See also [costCodes].
  const CostCodesFamily();

  /// See also [costCodes].
  CostCodesProvider call({
    required int companyId,
  }) {
    return CostCodesProvider(
      companyId: companyId,
    );
  }

  @override
  CostCodesProvider getProviderOverride(
    covariant CostCodesProvider provider,
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
  String? get name => r'costCodesProvider';
}

/// See also [costCodes].
class CostCodesProvider extends AutoDisposeFutureProvider<List<CostCode>> {
  /// See also [costCodes].
  CostCodesProvider({
    required int companyId,
  }) : this._internal(
          (ref) => costCodes(
            ref as CostCodesRef,
            companyId: companyId,
          ),
          from: costCodesProvider,
          name: r'costCodesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$costCodesHash,
          dependencies: CostCodesFamily._dependencies,
          allTransitiveDependencies: CostCodesFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  CostCodesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.companyId,
  }) : super.internal();

  final int companyId;

  @override
  Override overrideWith(
    FutureOr<List<CostCode>> Function(CostCodesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CostCodesProvider._internal(
        (ref) => create(ref as CostCodesRef),
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
  AutoDisposeFutureProviderElement<List<CostCode>> createElement() {
    return _CostCodesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CostCodesProvider && other.companyId == companyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, companyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CostCodesRef on AutoDisposeFutureProviderRef<List<CostCode>> {
  /// The parameter `companyId` of this provider.
  int get companyId;
}

class _CostCodesProviderElement
    extends AutoDisposeFutureProviderElement<List<CostCode>> with CostCodesRef {
  _CostCodesProviderElement(super.provider);

  @override
  int get companyId => (origin as CostCodesProvider).companyId;
}

String _$proratedPreviewHash() => r'e9c06060d362b0f777e4010f9840d38ab74b6ca9';

/// See also [proratedPreview].
@ProviderFor(proratedPreview)
const proratedPreviewProvider = ProratedPreviewFamily();

/// See also [proratedPreview].
class ProratedPreviewFamily extends Family<AsyncValue<List<dynamic>>> {
  /// See also [proratedPreview].
  const ProratedPreviewFamily();

  /// See also [proratedPreview].
  ProratedPreviewProvider call({
    required String parentCode,
    required double qty,
  }) {
    return ProratedPreviewProvider(
      parentCode: parentCode,
      qty: qty,
    );
  }

  @override
  ProratedPreviewProvider getProviderOverride(
    covariant ProratedPreviewProvider provider,
  ) {
    return call(
      parentCode: provider.parentCode,
      qty: provider.qty,
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
  String? get name => r'proratedPreviewProvider';
}

/// See also [proratedPreview].
class ProratedPreviewProvider extends AutoDisposeFutureProvider<List<dynamic>> {
  /// See also [proratedPreview].
  ProratedPreviewProvider({
    required String parentCode,
    required double qty,
  }) : this._internal(
          (ref) => proratedPreview(
            ref as ProratedPreviewRef,
            parentCode: parentCode,
            qty: qty,
          ),
          from: proratedPreviewProvider,
          name: r'proratedPreviewProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$proratedPreviewHash,
          dependencies: ProratedPreviewFamily._dependencies,
          allTransitiveDependencies:
              ProratedPreviewFamily._allTransitiveDependencies,
          parentCode: parentCode,
          qty: qty,
        );

  ProratedPreviewProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.parentCode,
    required this.qty,
  }) : super.internal();

  final String parentCode;
  final double qty;

  @override
  Override overrideWith(
    FutureOr<List<dynamic>> Function(ProratedPreviewRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProratedPreviewProvider._internal(
        (ref) => create(ref as ProratedPreviewRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        parentCode: parentCode,
        qty: qty,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<dynamic>> createElement() {
    return _ProratedPreviewProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProratedPreviewProvider &&
        other.parentCode == parentCode &&
        other.qty == qty;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, parentCode.hashCode);
    hash = _SystemHash.combine(hash, qty.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProratedPreviewRef on AutoDisposeFutureProviderRef<List<dynamic>> {
  /// The parameter `parentCode` of this provider.
  String get parentCode;

  /// The parameter `qty` of this provider.
  double get qty;
}

class _ProratedPreviewProviderElement
    extends AutoDisposeFutureProviderElement<List<dynamic>>
    with ProratedPreviewRef {
  _ProratedPreviewProviderElement(super.provider);

  @override
  String get parentCode => (origin as ProratedPreviewProvider).parentCode;
  @override
  double get qty => (origin as ProratedPreviewProvider).qty;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
