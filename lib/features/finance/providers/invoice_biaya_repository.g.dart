// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_biaya_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$invoiceBiayaRepositoryHash() =>
    r'8db8cabf51ce73e8d11dc8be8e5906807181d9a7';

/// See also [invoiceBiayaRepository].
@ProviderFor(invoiceBiayaRepository)
final invoiceBiayaRepositoryProvider =
    AutoDisposeProvider<InvoiceBiayaRepository>.internal(
  invoiceBiayaRepository,
  name: r'invoiceBiayaRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$invoiceBiayaRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef InvoiceBiayaRepositoryRef
    = AutoDisposeProviderRef<InvoiceBiayaRepository>;
String _$invoiceBiayaDetailHash() =>
    r'3ea5d931bdf5a8df4370aa11b3afef2c56492f1a';

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

/// See also [invoiceBiayaDetail].
@ProviderFor(invoiceBiayaDetail)
const invoiceBiayaDetailProvider = InvoiceBiayaDetailFamily();

/// See also [invoiceBiayaDetail].
class InvoiceBiayaDetailFamily extends Family<AsyncValue<InvoiceBiaya>> {
  /// See also [invoiceBiayaDetail].
  const InvoiceBiayaDetailFamily();

  /// See also [invoiceBiayaDetail].
  InvoiceBiayaDetailProvider call(
    int id,
  ) {
    return InvoiceBiayaDetailProvider(
      id,
    );
  }

  @override
  InvoiceBiayaDetailProvider getProviderOverride(
    covariant InvoiceBiayaDetailProvider provider,
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
  String? get name => r'invoiceBiayaDetailProvider';
}

/// See also [invoiceBiayaDetail].
class InvoiceBiayaDetailProvider
    extends AutoDisposeFutureProvider<InvoiceBiaya> {
  /// See also [invoiceBiayaDetail].
  InvoiceBiayaDetailProvider(
    int id,
  ) : this._internal(
          (ref) => invoiceBiayaDetail(
            ref as InvoiceBiayaDetailRef,
            id,
          ),
          from: invoiceBiayaDetailProvider,
          name: r'invoiceBiayaDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$invoiceBiayaDetailHash,
          dependencies: InvoiceBiayaDetailFamily._dependencies,
          allTransitiveDependencies:
              InvoiceBiayaDetailFamily._allTransitiveDependencies,
          id: id,
        );

  InvoiceBiayaDetailProvider._internal(
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
    FutureOr<InvoiceBiaya> Function(InvoiceBiayaDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: InvoiceBiayaDetailProvider._internal(
        (ref) => create(ref as InvoiceBiayaDetailRef),
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
  AutoDisposeFutureProviderElement<InvoiceBiaya> createElement() {
    return _InvoiceBiayaDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InvoiceBiayaDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin InvoiceBiayaDetailRef on AutoDisposeFutureProviderRef<InvoiceBiaya> {
  /// The parameter `id` of this provider.
  int get id;
}

class _InvoiceBiayaDetailProviderElement
    extends AutoDisposeFutureProviderElement<InvoiceBiaya>
    with InvoiceBiayaDetailRef {
  _InvoiceBiayaDetailProviderElement(super.provider);

  @override
  int get id => (origin as InvoiceBiayaDetailProvider).id;
}

String _$invoiceBiayasHash() => r'6b99b9c286aa8a204d43ac24c584d17cf32e17fd';

abstract class _$InvoiceBiayas
    extends BuildlessAutoDisposeAsyncNotifier<List<InvoiceBiaya>> {
  late final String? status;
  late final String? startDate;
  late final String? endDate;
  late final bool? unpaidOnly;

  FutureOr<List<InvoiceBiaya>> build({
    String? status,
    String? startDate,
    String? endDate,
    bool? unpaidOnly,
  });
}

/// See also [InvoiceBiayas].
@ProviderFor(InvoiceBiayas)
const invoiceBiayasProvider = InvoiceBiayasFamily();

/// See also [InvoiceBiayas].
class InvoiceBiayasFamily extends Family<AsyncValue<List<InvoiceBiaya>>> {
  /// See also [InvoiceBiayas].
  const InvoiceBiayasFamily();

  /// See also [InvoiceBiayas].
  InvoiceBiayasProvider call({
    String? status,
    String? startDate,
    String? endDate,
    bool? unpaidOnly,
  }) {
    return InvoiceBiayasProvider(
      status: status,
      startDate: startDate,
      endDate: endDate,
      unpaidOnly: unpaidOnly,
    );
  }

  @override
  InvoiceBiayasProvider getProviderOverride(
    covariant InvoiceBiayasProvider provider,
  ) {
    return call(
      status: provider.status,
      startDate: provider.startDate,
      endDate: provider.endDate,
      unpaidOnly: provider.unpaidOnly,
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
  String? get name => r'invoiceBiayasProvider';
}

/// See also [InvoiceBiayas].
class InvoiceBiayasProvider extends AutoDisposeAsyncNotifierProviderImpl<
    InvoiceBiayas, List<InvoiceBiaya>> {
  /// See also [InvoiceBiayas].
  InvoiceBiayasProvider({
    String? status,
    String? startDate,
    String? endDate,
    bool? unpaidOnly,
  }) : this._internal(
          () => InvoiceBiayas()
            ..status = status
            ..startDate = startDate
            ..endDate = endDate
            ..unpaidOnly = unpaidOnly,
          from: invoiceBiayasProvider,
          name: r'invoiceBiayasProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$invoiceBiayasHash,
          dependencies: InvoiceBiayasFamily._dependencies,
          allTransitiveDependencies:
              InvoiceBiayasFamily._allTransitiveDependencies,
          status: status,
          startDate: startDate,
          endDate: endDate,
          unpaidOnly: unpaidOnly,
        );

  InvoiceBiayasProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.unpaidOnly,
  }) : super.internal();

  final String? status;
  final String? startDate;
  final String? endDate;
  final bool? unpaidOnly;

  @override
  FutureOr<List<InvoiceBiaya>> runNotifierBuild(
    covariant InvoiceBiayas notifier,
  ) {
    return notifier.build(
      status: status,
      startDate: startDate,
      endDate: endDate,
      unpaidOnly: unpaidOnly,
    );
  }

  @override
  Override overrideWith(InvoiceBiayas Function() create) {
    return ProviderOverride(
      origin: this,
      override: InvoiceBiayasProvider._internal(
        () => create()
          ..status = status
          ..startDate = startDate
          ..endDate = endDate
          ..unpaidOnly = unpaidOnly,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
        startDate: startDate,
        endDate: endDate,
        unpaidOnly: unpaidOnly,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<InvoiceBiayas, List<InvoiceBiaya>>
      createElement() {
    return _InvoiceBiayasProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InvoiceBiayasProvider &&
        other.status == status &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.unpaidOnly == unpaidOnly;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);
    hash = _SystemHash.combine(hash, unpaidOnly.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin InvoiceBiayasRef
    on AutoDisposeAsyncNotifierProviderRef<List<InvoiceBiaya>> {
  /// The parameter `status` of this provider.
  String? get status;

  /// The parameter `startDate` of this provider.
  String? get startDate;

  /// The parameter `endDate` of this provider.
  String? get endDate;

  /// The parameter `unpaidOnly` of this provider.
  bool? get unpaidOnly;
}

class _InvoiceBiayasProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<InvoiceBiayas,
        List<InvoiceBiaya>> with InvoiceBiayasRef {
  _InvoiceBiayasProviderElement(super.provider);

  @override
  String? get status => (origin as InvoiceBiayasProvider).status;
  @override
  String? get startDate => (origin as InvoiceBiayasProvider).startDate;
  @override
  String? get endDate => (origin as InvoiceBiayasProvider).endDate;
  @override
  bool? get unpaidOnly => (origin as InvoiceBiayasProvider).unpaidOnly;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
