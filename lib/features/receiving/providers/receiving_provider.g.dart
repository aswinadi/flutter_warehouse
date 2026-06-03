// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receiving_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$receivingPODetailHash() => r'4f29bbb4711bdc20ca83be910b9be8933c687f5e';

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

/// See also [receivingPODetail].
@ProviderFor(receivingPODetail)
const receivingPODetailProvider = ReceivingPODetailFamily();

/// See also [receivingPODetail].
class ReceivingPODetailFamily extends Family<AsyncValue<PurchaseOrder>> {
  /// See also [receivingPODetail].
  const ReceivingPODetailFamily();

  /// See also [receivingPODetail].
  ReceivingPODetailProvider call(
    int poId,
  ) {
    return ReceivingPODetailProvider(
      poId,
    );
  }

  @override
  ReceivingPODetailProvider getProviderOverride(
    covariant ReceivingPODetailProvider provider,
  ) {
    return call(
      provider.poId,
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
  String? get name => r'receivingPODetailProvider';
}

/// See also [receivingPODetail].
class ReceivingPODetailProvider
    extends AutoDisposeFutureProvider<PurchaseOrder> {
  /// See also [receivingPODetail].
  ReceivingPODetailProvider(
    int poId,
  ) : this._internal(
          (ref) => receivingPODetail(
            ref as ReceivingPODetailRef,
            poId,
          ),
          from: receivingPODetailProvider,
          name: r'receivingPODetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$receivingPODetailHash,
          dependencies: ReceivingPODetailFamily._dependencies,
          allTransitiveDependencies:
              ReceivingPODetailFamily._allTransitiveDependencies,
          poId: poId,
        );

  ReceivingPODetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.poId,
  }) : super.internal();

  final int poId;

  @override
  Override overrideWith(
    FutureOr<PurchaseOrder> Function(ReceivingPODetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReceivingPODetailProvider._internal(
        (ref) => create(ref as ReceivingPODetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        poId: poId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PurchaseOrder> createElement() {
    return _ReceivingPODetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReceivingPODetailProvider && other.poId == poId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, poId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ReceivingPODetailRef on AutoDisposeFutureProviderRef<PurchaseOrder> {
  /// The parameter `poId` of this provider.
  int get poId;
}

class _ReceivingPODetailProviderElement
    extends AutoDisposeFutureProviderElement<PurchaseOrder>
    with ReceivingPODetailRef {
  _ReceivingPODetailProviderElement(super.provider);

  @override
  int get poId => (origin as ReceivingPODetailProvider).poId;
}

String _$receivingContainersHash() =>
    r'741a4cd5dee2f58c3c0074e8ec6c1f1bc1f00280';

/// See also [receivingContainers].
@ProviderFor(receivingContainers)
final receivingContainersProvider =
    AutoDisposeFutureProvider<List<ReceivingContainer>>.internal(
  receivingContainers,
  name: r'receivingContainersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$receivingContainersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ReceivingContainersRef
    = AutoDisposeFutureProviderRef<List<ReceivingContainer>>;
String _$containerManifestHash() => r'd5f0e9adc3b6f4bbc0f3b12caae265811534120a';

/// See also [containerManifest].
@ProviderFor(containerManifest)
const containerManifestProvider = ContainerManifestFamily();

/// See also [containerManifest].
class ContainerManifestFamily
    extends Family<AsyncValue<ReceivingContainerManifest>> {
  /// See also [containerManifest].
  const ContainerManifestFamily();

  /// See also [containerManifest].
  ContainerManifestProvider call(
    String number,
  ) {
    return ContainerManifestProvider(
      number,
    );
  }

  @override
  ContainerManifestProvider getProviderOverride(
    covariant ContainerManifestProvider provider,
  ) {
    return call(
      provider.number,
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
  String? get name => r'containerManifestProvider';
}

/// See also [containerManifest].
class ContainerManifestProvider
    extends AutoDisposeFutureProvider<ReceivingContainerManifest> {
  /// See also [containerManifest].
  ContainerManifestProvider(
    String number,
  ) : this._internal(
          (ref) => containerManifest(
            ref as ContainerManifestRef,
            number,
          ),
          from: containerManifestProvider,
          name: r'containerManifestProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$containerManifestHash,
          dependencies: ContainerManifestFamily._dependencies,
          allTransitiveDependencies:
              ContainerManifestFamily._allTransitiveDependencies,
          number: number,
        );

  ContainerManifestProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.number,
  }) : super.internal();

  final String number;

  @override
  Override overrideWith(
    FutureOr<ReceivingContainerManifest> Function(ContainerManifestRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ContainerManifestProvider._internal(
        (ref) => create(ref as ContainerManifestRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        number: number,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ReceivingContainerManifest> createElement() {
    return _ContainerManifestProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ContainerManifestProvider && other.number == number;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, number.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ContainerManifestRef
    on AutoDisposeFutureProviderRef<ReceivingContainerManifest> {
  /// The parameter `number` of this provider.
  String get number;
}

class _ContainerManifestProviderElement
    extends AutoDisposeFutureProviderElement<ReceivingContainerManifest>
    with ContainerManifestRef {
  _ContainerManifestProviderElement(super.provider);

  @override
  String get number => (origin as ContainerManifestProvider).number;
}

String _$receivingsHistoryHash() => r'dc279e9680773eac0015807c8efe3027d0923815';

/// See also [ReceivingsHistory].
@ProviderFor(ReceivingsHistory)
final receivingsHistoryProvider = AutoDisposeAsyncNotifierProvider<
    ReceivingsHistory, List<ReceivingHistoryItem>>.internal(
  ReceivingsHistory.new,
  name: r'receivingsHistoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$receivingsHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReceivingsHistory
    = AutoDisposeAsyncNotifier<List<ReceivingHistoryItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
