// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_request_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paymentRequestRepositoryHash() =>
    r'6ab549952c20008043e70c7df112d524e6d184ab';

/// See also [paymentRequestRepository].
@ProviderFor(paymentRequestRepository)
final paymentRequestRepositoryProvider =
    AutoDisposeProvider<PaymentRequestRepository>.internal(
  paymentRequestRepository,
  name: r'paymentRequestRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paymentRequestRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PaymentRequestRepositoryRef
    = AutoDisposeProviderRef<PaymentRequestRepository>;
String _$availableInvoicesHash() => r'f7cec460f7f59f7375d72f2d6e9c05e0632786eb';

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

/// See also [availableInvoices].
@ProviderFor(availableInvoices)
const availableInvoicesProvider = AvailableInvoicesFamily();

/// See also [availableInvoices].
class AvailableInvoicesFamily
    extends Family<AsyncValue<List<AvailableInvoice>>> {
  /// See also [availableInvoices].
  const AvailableInvoicesFamily();

  /// See also [availableInvoices].
  AvailableInvoicesProvider call({
    required int companyId,
  }) {
    return AvailableInvoicesProvider(
      companyId: companyId,
    );
  }

  @override
  AvailableInvoicesProvider getProviderOverride(
    covariant AvailableInvoicesProvider provider,
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
  String? get name => r'availableInvoicesProvider';
}

/// See also [availableInvoices].
class AvailableInvoicesProvider
    extends AutoDisposeFutureProvider<List<AvailableInvoice>> {
  /// See also [availableInvoices].
  AvailableInvoicesProvider({
    required int companyId,
  }) : this._internal(
          (ref) => availableInvoices(
            ref as AvailableInvoicesRef,
            companyId: companyId,
          ),
          from: availableInvoicesProvider,
          name: r'availableInvoicesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$availableInvoicesHash,
          dependencies: AvailableInvoicesFamily._dependencies,
          allTransitiveDependencies:
              AvailableInvoicesFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  AvailableInvoicesProvider._internal(
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
    FutureOr<List<AvailableInvoice>> Function(AvailableInvoicesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AvailableInvoicesProvider._internal(
        (ref) => create(ref as AvailableInvoicesRef),
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
  AutoDisposeFutureProviderElement<List<AvailableInvoice>> createElement() {
    return _AvailableInvoicesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AvailableInvoicesProvider && other.companyId == companyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, companyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AvailableInvoicesRef
    on AutoDisposeFutureProviderRef<List<AvailableInvoice>> {
  /// The parameter `companyId` of this provider.
  int get companyId;
}

class _AvailableInvoicesProviderElement
    extends AutoDisposeFutureProviderElement<List<AvailableInvoice>>
    with AvailableInvoicesRef {
  _AvailableInvoicesProviderElement(super.provider);

  @override
  int get companyId => (origin as AvailableInvoicesProvider).companyId;
}

String _$invoiceDetailPreviewHash() =>
    r'db3e5f606e4896513c1c797fc043d882ee2e7082';

/// See also [invoiceDetailPreview].
@ProviderFor(invoiceDetailPreview)
const invoiceDetailPreviewProvider = InvoiceDetailPreviewFamily();

/// See also [invoiceDetailPreview].
class InvoiceDetailPreviewFamily
    extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [invoiceDetailPreview].
  const InvoiceDetailPreviewFamily();

  /// See also [invoiceDetailPreview].
  InvoiceDetailPreviewProvider call({
    required int id,
    required String type,
  }) {
    return InvoiceDetailPreviewProvider(
      id: id,
      type: type,
    );
  }

  @override
  InvoiceDetailPreviewProvider getProviderOverride(
    covariant InvoiceDetailPreviewProvider provider,
  ) {
    return call(
      id: provider.id,
      type: provider.type,
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
  String? get name => r'invoiceDetailPreviewProvider';
}

/// See also [invoiceDetailPreview].
class InvoiceDetailPreviewProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [invoiceDetailPreview].
  InvoiceDetailPreviewProvider({
    required int id,
    required String type,
  }) : this._internal(
          (ref) => invoiceDetailPreview(
            ref as InvoiceDetailPreviewRef,
            id: id,
            type: type,
          ),
          from: invoiceDetailPreviewProvider,
          name: r'invoiceDetailPreviewProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$invoiceDetailPreviewHash,
          dependencies: InvoiceDetailPreviewFamily._dependencies,
          allTransitiveDependencies:
              InvoiceDetailPreviewFamily._allTransitiveDependencies,
          id: id,
          type: type,
        );

  InvoiceDetailPreviewProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
    required this.type,
  }) : super.internal();

  final int id;
  final String type;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(InvoiceDetailPreviewRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: InvoiceDetailPreviewProvider._internal(
        (ref) => create(ref as InvoiceDetailPreviewRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _InvoiceDetailPreviewProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InvoiceDetailPreviewProvider &&
        other.id == id &&
        other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin InvoiceDetailPreviewRef
    on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `id` of this provider.
  int get id;

  /// The parameter `type` of this provider.
  String get type;
}

class _InvoiceDetailPreviewProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with InvoiceDetailPreviewRef {
  _InvoiceDetailPreviewProviderElement(super.provider);

  @override
  int get id => (origin as InvoiceDetailPreviewProvider).id;
  @override
  String get type => (origin as InvoiceDetailPreviewProvider).type;
}

String _$paymentRequestDetailHash() =>
    r'fe0e6907323eba2fb98b22a65157bbd03811da74';

/// See also [paymentRequestDetail].
@ProviderFor(paymentRequestDetail)
const paymentRequestDetailProvider = PaymentRequestDetailFamily();

/// See also [paymentRequestDetail].
class PaymentRequestDetailFamily extends Family<AsyncValue<PaymentRequest>> {
  /// See also [paymentRequestDetail].
  const PaymentRequestDetailFamily();

  /// See also [paymentRequestDetail].
  PaymentRequestDetailProvider call(
    int id,
  ) {
    return PaymentRequestDetailProvider(
      id,
    );
  }

  @override
  PaymentRequestDetailProvider getProviderOverride(
    covariant PaymentRequestDetailProvider provider,
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
  String? get name => r'paymentRequestDetailProvider';
}

/// See also [paymentRequestDetail].
class PaymentRequestDetailProvider
    extends AutoDisposeFutureProvider<PaymentRequest> {
  /// See also [paymentRequestDetail].
  PaymentRequestDetailProvider(
    int id,
  ) : this._internal(
          (ref) => paymentRequestDetail(
            ref as PaymentRequestDetailRef,
            id,
          ),
          from: paymentRequestDetailProvider,
          name: r'paymentRequestDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$paymentRequestDetailHash,
          dependencies: PaymentRequestDetailFamily._dependencies,
          allTransitiveDependencies:
              PaymentRequestDetailFamily._allTransitiveDependencies,
          id: id,
        );

  PaymentRequestDetailProvider._internal(
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
    FutureOr<PaymentRequest> Function(PaymentRequestDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PaymentRequestDetailProvider._internal(
        (ref) => create(ref as PaymentRequestDetailRef),
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
  AutoDisposeFutureProviderElement<PaymentRequest> createElement() {
    return _PaymentRequestDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PaymentRequestDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PaymentRequestDetailRef on AutoDisposeFutureProviderRef<PaymentRequest> {
  /// The parameter `id` of this provider.
  int get id;
}

class _PaymentRequestDetailProviderElement
    extends AutoDisposeFutureProviderElement<PaymentRequest>
    with PaymentRequestDetailRef {
  _PaymentRequestDetailProviderElement(super.provider);

  @override
  int get id => (origin as PaymentRequestDetailProvider).id;
}

String _$companyBankAccountsHash() =>
    r'5632cb06d7636dba3d6fb5b630436dfb579ae764';

/// See also [companyBankAccounts].
@ProviderFor(companyBankAccounts)
const companyBankAccountsProvider = CompanyBankAccountsFamily();

/// See also [companyBankAccounts].
class CompanyBankAccountsFamily
    extends Family<AsyncValue<List<CompanyBankAccount>>> {
  /// See also [companyBankAccounts].
  const CompanyBankAccountsFamily();

  /// See also [companyBankAccounts].
  CompanyBankAccountsProvider call({
    required int companyId,
  }) {
    return CompanyBankAccountsProvider(
      companyId: companyId,
    );
  }

  @override
  CompanyBankAccountsProvider getProviderOverride(
    covariant CompanyBankAccountsProvider provider,
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
  String? get name => r'companyBankAccountsProvider';
}

/// See also [companyBankAccounts].
class CompanyBankAccountsProvider
    extends AutoDisposeFutureProvider<List<CompanyBankAccount>> {
  /// See also [companyBankAccounts].
  CompanyBankAccountsProvider({
    required int companyId,
  }) : this._internal(
          (ref) => companyBankAccounts(
            ref as CompanyBankAccountsRef,
            companyId: companyId,
          ),
          from: companyBankAccountsProvider,
          name: r'companyBankAccountsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$companyBankAccountsHash,
          dependencies: CompanyBankAccountsFamily._dependencies,
          allTransitiveDependencies:
              CompanyBankAccountsFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  CompanyBankAccountsProvider._internal(
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
    FutureOr<List<CompanyBankAccount>> Function(CompanyBankAccountsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CompanyBankAccountsProvider._internal(
        (ref) => create(ref as CompanyBankAccountsRef),
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
  AutoDisposeFutureProviderElement<List<CompanyBankAccount>> createElement() {
    return _CompanyBankAccountsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CompanyBankAccountsProvider && other.companyId == companyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, companyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CompanyBankAccountsRef
    on AutoDisposeFutureProviderRef<List<CompanyBankAccount>> {
  /// The parameter `companyId` of this provider.
  int get companyId;
}

class _CompanyBankAccountsProviderElement
    extends AutoDisposeFutureProviderElement<List<CompanyBankAccount>>
    with CompanyBankAccountsRef {
  _CompanyBankAccountsProviderElement(super.provider);

  @override
  int get companyId => (origin as CompanyBankAccountsProvider).companyId;
}

String _$supplierByNameHash() => r'd9f9fce7e9ffd10ed03090bea1b6f2d0769801a2';

/// See also [supplierByName].
@ProviderFor(supplierByName)
const supplierByNameProvider = SupplierByNameFamily();

/// See also [supplierByName].
class SupplierByNameFamily extends Family<AsyncValue<Supplier?>> {
  /// See also [supplierByName].
  const SupplierByNameFamily();

  /// See also [supplierByName].
  SupplierByNameProvider call({
    required String name,
    required int companyId,
  }) {
    return SupplierByNameProvider(
      name: name,
      companyId: companyId,
    );
  }

  @override
  SupplierByNameProvider getProviderOverride(
    covariant SupplierByNameProvider provider,
  ) {
    return call(
      name: provider.name,
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
  String? get name => r'supplierByNameProvider';
}

/// See also [supplierByName].
class SupplierByNameProvider extends AutoDisposeFutureProvider<Supplier?> {
  /// See also [supplierByName].
  SupplierByNameProvider({
    required String name,
    required int companyId,
  }) : this._internal(
          (ref) => supplierByName(
            ref as SupplierByNameRef,
            name: name,
            companyId: companyId,
          ),
          from: supplierByNameProvider,
          name: r'supplierByNameProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$supplierByNameHash,
          dependencies: SupplierByNameFamily._dependencies,
          allTransitiveDependencies:
              SupplierByNameFamily._allTransitiveDependencies,
          name: name,
          companyId: companyId,
        );

  SupplierByNameProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.name,
    required this.companyId,
  }) : super.internal();

  final String name;
  final int companyId;

  @override
  Override overrideWith(
    FutureOr<Supplier?> Function(SupplierByNameRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SupplierByNameProvider._internal(
        (ref) => create(ref as SupplierByNameRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        name: name,
        companyId: companyId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Supplier?> createElement() {
    return _SupplierByNameProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SupplierByNameProvider &&
        other.name == name &&
        other.companyId == companyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, name.hashCode);
    hash = _SystemHash.combine(hash, companyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SupplierByNameRef on AutoDisposeFutureProviderRef<Supplier?> {
  /// The parameter `name` of this provider.
  String get name;

  /// The parameter `companyId` of this provider.
  int get companyId;
}

class _SupplierByNameProviderElement
    extends AutoDisposeFutureProviderElement<Supplier?> with SupplierByNameRef {
  _SupplierByNameProviderElement(super.provider);

  @override
  String get name => (origin as SupplierByNameProvider).name;
  @override
  int get companyId => (origin as SupplierByNameProvider).companyId;
}

String _$paymentRequestsHash() => r'9f5b2b6579bf7b21d16c0ce7c2da29ba01af1c54';

abstract class _$PaymentRequests
    extends BuildlessAutoDisposeAsyncNotifier<List<PaymentRequest>> {
  late final String? status;

  FutureOr<List<PaymentRequest>> build({
    String? status,
  });
}

/// See also [PaymentRequests].
@ProviderFor(PaymentRequests)
const paymentRequestsProvider = PaymentRequestsFamily();

/// See also [PaymentRequests].
class PaymentRequestsFamily extends Family<AsyncValue<List<PaymentRequest>>> {
  /// See also [PaymentRequests].
  const PaymentRequestsFamily();

  /// See also [PaymentRequests].
  PaymentRequestsProvider call({
    String? status,
  }) {
    return PaymentRequestsProvider(
      status: status,
    );
  }

  @override
  PaymentRequestsProvider getProviderOverride(
    covariant PaymentRequestsProvider provider,
  ) {
    return call(
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
  String? get name => r'paymentRequestsProvider';
}

/// See also [PaymentRequests].
class PaymentRequestsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    PaymentRequests, List<PaymentRequest>> {
  /// See also [PaymentRequests].
  PaymentRequestsProvider({
    String? status,
  }) : this._internal(
          () => PaymentRequests()..status = status,
          from: paymentRequestsProvider,
          name: r'paymentRequestsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$paymentRequestsHash,
          dependencies: PaymentRequestsFamily._dependencies,
          allTransitiveDependencies:
              PaymentRequestsFamily._allTransitiveDependencies,
          status: status,
        );

  PaymentRequestsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
  }) : super.internal();

  final String? status;

  @override
  FutureOr<List<PaymentRequest>> runNotifierBuild(
    covariant PaymentRequests notifier,
  ) {
    return notifier.build(
      status: status,
    );
  }

  @override
  Override overrideWith(PaymentRequests Function() create) {
    return ProviderOverride(
      origin: this,
      override: PaymentRequestsProvider._internal(
        () => create()..status = status,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<PaymentRequests, List<PaymentRequest>>
      createElement() {
    return _PaymentRequestsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PaymentRequestsProvider && other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PaymentRequestsRef
    on AutoDisposeAsyncNotifierProviderRef<List<PaymentRequest>> {
  /// The parameter `status` of this provider.
  String? get status;
}

class _PaymentRequestsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PaymentRequests,
        List<PaymentRequest>> with PaymentRequestsRef {
  _PaymentRequestsProviderElement(super.provider);

  @override
  String? get status => (origin as PaymentRequestsProvider).status;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
