// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$invoiceRepositoryHash() => r'03f06cd32f139b711b06ca6100481ace8f0c7c24';

/// See also [invoiceRepository].
@ProviderFor(invoiceRepository)
final invoiceRepositoryProvider =
    AutoDisposeProvider<InvoiceRepository>.internal(
  invoiceRepository,
  name: r'invoiceRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$invoiceRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef InvoiceRepositoryRef = AutoDisposeProviderRef<InvoiceRepository>;
String _$invoiceDetailHash() => r'0624e6b2990bfd048984741c96f345efa9cc06d3';

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

/// See also [invoiceDetail].
@ProviderFor(invoiceDetail)
const invoiceDetailProvider = InvoiceDetailFamily();

/// See also [invoiceDetail].
class InvoiceDetailFamily extends Family<AsyncValue<Invoice>> {
  /// See also [invoiceDetail].
  const InvoiceDetailFamily();

  /// See also [invoiceDetail].
  InvoiceDetailProvider call(
    int id,
  ) {
    return InvoiceDetailProvider(
      id,
    );
  }

  @override
  InvoiceDetailProvider getProviderOverride(
    covariant InvoiceDetailProvider provider,
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
  String? get name => r'invoiceDetailProvider';
}

/// See also [invoiceDetail].
class InvoiceDetailProvider extends AutoDisposeFutureProvider<Invoice> {
  /// See also [invoiceDetail].
  InvoiceDetailProvider(
    int id,
  ) : this._internal(
          (ref) => invoiceDetail(
            ref as InvoiceDetailRef,
            id,
          ),
          from: invoiceDetailProvider,
          name: r'invoiceDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$invoiceDetailHash,
          dependencies: InvoiceDetailFamily._dependencies,
          allTransitiveDependencies:
              InvoiceDetailFamily._allTransitiveDependencies,
          id: id,
        );

  InvoiceDetailProvider._internal(
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
    FutureOr<Invoice> Function(InvoiceDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: InvoiceDetailProvider._internal(
        (ref) => create(ref as InvoiceDetailRef),
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
  AutoDisposeFutureProviderElement<Invoice> createElement() {
    return _InvoiceDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InvoiceDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin InvoiceDetailRef on AutoDisposeFutureProviderRef<Invoice> {
  /// The parameter `id` of this provider.
  int get id;
}

class _InvoiceDetailProviderElement
    extends AutoDisposeFutureProviderElement<Invoice> with InvoiceDetailRef {
  _InvoiceDetailProviderElement(super.provider);

  @override
  int get id => (origin as InvoiceDetailProvider).id;
}

String _$invoicesHash() => r'f43188918fa7e57f1d2c6d6cb4abebaf60c17141';

abstract class _$Invoices
    extends BuildlessAutoDisposeAsyncNotifier<List<Invoice>> {
  late final String? status;
  late final String? startDate;
  late final String? endDate;

  FutureOr<List<Invoice>> build({
    String? status,
    String? startDate,
    String? endDate,
  });
}

/// See also [Invoices].
@ProviderFor(Invoices)
const invoicesProvider = InvoicesFamily();

/// See also [Invoices].
class InvoicesFamily extends Family<AsyncValue<List<Invoice>>> {
  /// See also [Invoices].
  const InvoicesFamily();

  /// See also [Invoices].
  InvoicesProvider call({
    String? status,
    String? startDate,
    String? endDate,
  }) {
    return InvoicesProvider(
      status: status,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  InvoicesProvider getProviderOverride(
    covariant InvoicesProvider provider,
  ) {
    return call(
      status: provider.status,
      startDate: provider.startDate,
      endDate: provider.endDate,
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
  String? get name => r'invoicesProvider';
}

/// See also [Invoices].
class InvoicesProvider
    extends AutoDisposeAsyncNotifierProviderImpl<Invoices, List<Invoice>> {
  /// See also [Invoices].
  InvoicesProvider({
    String? status,
    String? startDate,
    String? endDate,
  }) : this._internal(
          () => Invoices()
            ..status = status
            ..startDate = startDate
            ..endDate = endDate,
          from: invoicesProvider,
          name: r'invoicesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$invoicesHash,
          dependencies: InvoicesFamily._dependencies,
          allTransitiveDependencies: InvoicesFamily._allTransitiveDependencies,
          status: status,
          startDate: startDate,
          endDate: endDate,
        );

  InvoicesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final String? status;
  final String? startDate;
  final String? endDate;

  @override
  FutureOr<List<Invoice>> runNotifierBuild(
    covariant Invoices notifier,
  ) {
    return notifier.build(
      status: status,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Override overrideWith(Invoices Function() create) {
    return ProviderOverride(
      origin: this,
      override: InvoicesProvider._internal(
        () => create()
          ..status = status
          ..startDate = startDate
          ..endDate = endDate,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<Invoices, List<Invoice>>
      createElement() {
    return _InvoicesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InvoicesProvider &&
        other.status == status &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin InvoicesRef on AutoDisposeAsyncNotifierProviderRef<List<Invoice>> {
  /// The parameter `status` of this provider.
  String? get status;

  /// The parameter `startDate` of this provider.
  String? get startDate;

  /// The parameter `endDate` of this provider.
  String? get endDate;
}

class _InvoicesProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<Invoices, List<Invoice>>
    with InvoicesRef {
  _InvoicesProviderElement(super.provider);

  @override
  String? get status => (origin as InvoicesProvider).status;
  @override
  String? get startDate => (origin as InvoicesProvider).startDate;
  @override
  String? get endDate => (origin as InvoicesProvider).endDate;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
