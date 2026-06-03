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
    r'4dadf0a01ea40de47c43cb3060d308aa0fde1bf1';

/// See also [PaymentTransactionsList].
@ProviderFor(PaymentTransactionsList)
final paymentTransactionsListProvider = AutoDisposeAsyncNotifierProvider<
    PaymentTransactionsList, List<PaymentTransaction>>.internal(
  PaymentTransactionsList.new,
  name: r'paymentTransactionsListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paymentTransactionsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PaymentTransactionsList
    = AutoDisposeAsyncNotifier<List<PaymentTransaction>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
