// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_transaction_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paymentTransactionRepositoryHash() =>
    r'f53defde788eb05f6346944557845fbc4b12cebe';

/// See also [paymentTransactionRepository].
@ProviderFor(paymentTransactionRepository)
final paymentTransactionRepositoryProvider =
    AutoDisposeProvider<PaymentTransactionRepository>.internal(
  paymentTransactionRepository,
  name: r'paymentTransactionRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paymentTransactionRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PaymentTransactionRepositoryRef
    = AutoDisposeProviderRef<PaymentTransactionRepository>;
String _$paymentTransactionDetailsHash() =>
    r'82197e3bb6bb9135658daf8d6937913631e38fbc';

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

/// See also [paymentTransactionDetails].
@ProviderFor(paymentTransactionDetails)
const paymentTransactionDetailsProvider = PaymentTransactionDetailsFamily();

/// See also [paymentTransactionDetails].
class PaymentTransactionDetailsFamily
    extends Family<AsyncValue<PaymentTransaction>> {
  /// See also [paymentTransactionDetails].
  const PaymentTransactionDetailsFamily();

  /// See also [paymentTransactionDetails].
  PaymentTransactionDetailsProvider call(
    int id,
  ) {
    return PaymentTransactionDetailsProvider(
      id,
    );
  }

  @override
  PaymentTransactionDetailsProvider getProviderOverride(
    covariant PaymentTransactionDetailsProvider provider,
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
  String? get name => r'paymentTransactionDetailsProvider';
}

/// See also [paymentTransactionDetails].
class PaymentTransactionDetailsProvider
    extends AutoDisposeFutureProvider<PaymentTransaction> {
  /// See also [paymentTransactionDetails].
  PaymentTransactionDetailsProvider(
    int id,
  ) : this._internal(
          (ref) => paymentTransactionDetails(
            ref as PaymentTransactionDetailsRef,
            id,
          ),
          from: paymentTransactionDetailsProvider,
          name: r'paymentTransactionDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$paymentTransactionDetailsHash,
          dependencies: PaymentTransactionDetailsFamily._dependencies,
          allTransitiveDependencies:
              PaymentTransactionDetailsFamily._allTransitiveDependencies,
          id: id,
        );

  PaymentTransactionDetailsProvider._internal(
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
    FutureOr<PaymentTransaction> Function(PaymentTransactionDetailsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PaymentTransactionDetailsProvider._internal(
        (ref) => create(ref as PaymentTransactionDetailsRef),
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
  AutoDisposeFutureProviderElement<PaymentTransaction> createElement() {
    return _PaymentTransactionDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PaymentTransactionDetailsProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PaymentTransactionDetailsRef
    on AutoDisposeFutureProviderRef<PaymentTransaction> {
  /// The parameter `id` of this provider.
  int get id;
}

class _PaymentTransactionDetailsProviderElement
    extends AutoDisposeFutureProviderElement<PaymentTransaction>
    with PaymentTransactionDetailsRef {
  _PaymentTransactionDetailsProviderElement(super.provider);

  @override
  int get id => (origin as PaymentTransactionDetailsProvider).id;
}

String _$paymentTransactionsListHash() =>
    r'20e50d6865ddbad81b5410c0c596cd1112b6ec55';

abstract class _$PaymentTransactionsList
    extends BuildlessAutoDisposeAsyncNotifier<List<PaymentTransaction>> {
  late final bool? hasProof;
  late final String? search;
  late final String? startDate;
  late final String? endDate;

  FutureOr<List<PaymentTransaction>> build({
    bool? hasProof,
    String? search,
    String? startDate,
    String? endDate,
  });
}

/// See also [PaymentTransactionsList].
@ProviderFor(PaymentTransactionsList)
const paymentTransactionsListProvider = PaymentTransactionsListFamily();

/// See also [PaymentTransactionsList].
class PaymentTransactionsListFamily
    extends Family<AsyncValue<List<PaymentTransaction>>> {
  /// See also [PaymentTransactionsList].
  const PaymentTransactionsListFamily();

  /// See also [PaymentTransactionsList].
  PaymentTransactionsListProvider call({
    bool? hasProof,
    String? search,
    String? startDate,
    String? endDate,
  }) {
    return PaymentTransactionsListProvider(
      hasProof: hasProof,
      search: search,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  PaymentTransactionsListProvider getProviderOverride(
    covariant PaymentTransactionsListProvider provider,
  ) {
    return call(
      hasProof: provider.hasProof,
      search: provider.search,
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
  String? get name => r'paymentTransactionsListProvider';
}

/// See also [PaymentTransactionsList].
class PaymentTransactionsListProvider
    extends AutoDisposeAsyncNotifierProviderImpl<PaymentTransactionsList,
        List<PaymentTransaction>> {
  /// See also [PaymentTransactionsList].
  PaymentTransactionsListProvider({
    bool? hasProof,
    String? search,
    String? startDate,
    String? endDate,
  }) : this._internal(
          () => PaymentTransactionsList()
            ..hasProof = hasProof
            ..search = search
            ..startDate = startDate
            ..endDate = endDate,
          from: paymentTransactionsListProvider,
          name: r'paymentTransactionsListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$paymentTransactionsListHash,
          dependencies: PaymentTransactionsListFamily._dependencies,
          allTransitiveDependencies:
              PaymentTransactionsListFamily._allTransitiveDependencies,
          hasProof: hasProof,
          search: search,
          startDate: startDate,
          endDate: endDate,
        );

  PaymentTransactionsListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.hasProof,
    required this.search,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final bool? hasProof;
  final String? search;
  final String? startDate;
  final String? endDate;

  @override
  FutureOr<List<PaymentTransaction>> runNotifierBuild(
    covariant PaymentTransactionsList notifier,
  ) {
    return notifier.build(
      hasProof: hasProof,
      search: search,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Override overrideWith(PaymentTransactionsList Function() create) {
    return ProviderOverride(
      origin: this,
      override: PaymentTransactionsListProvider._internal(
        () => create()
          ..hasProof = hasProof
          ..search = search
          ..startDate = startDate
          ..endDate = endDate,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        hasProof: hasProof,
        search: search,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<PaymentTransactionsList,
      List<PaymentTransaction>> createElement() {
    return _PaymentTransactionsListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PaymentTransactionsListProvider &&
        other.hasProof == hasProof &&
        other.search == search &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, hasProof.hashCode);
    hash = _SystemHash.combine(hash, search.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PaymentTransactionsListRef
    on AutoDisposeAsyncNotifierProviderRef<List<PaymentTransaction>> {
  /// The parameter `hasProof` of this provider.
  bool? get hasProof;

  /// The parameter `search` of this provider.
  String? get search;

  /// The parameter `startDate` of this provider.
  String? get startDate;

  /// The parameter `endDate` of this provider.
  String? get endDate;
}

class _PaymentTransactionsListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PaymentTransactionsList,
        List<PaymentTransaction>> with PaymentTransactionsListRef {
  _PaymentTransactionsListProviderElement(super.provider);

  @override
  bool? get hasProof => (origin as PaymentTransactionsListProvider).hasProof;
  @override
  String? get search => (origin as PaymentTransactionsListProvider).search;
  @override
  String? get startDate =>
      (origin as PaymentTransactionsListProvider).startDate;
  @override
  String? get endDate => (origin as PaymentTransactionsListProvider).endDate;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
