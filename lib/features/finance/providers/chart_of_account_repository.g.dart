// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_of_account_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chartOfAccountRepositoryHash() =>
    r'99b1b09d78203e0e559ebd7bff2937817befd8bd';

/// See also [chartOfAccountRepository].
@ProviderFor(chartOfAccountRepository)
final chartOfAccountRepositoryProvider =
    AutoDisposeProvider<ChartOfAccountRepository>.internal(
  chartOfAccountRepository,
  name: r'chartOfAccountRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chartOfAccountRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ChartOfAccountRepositoryRef
    = AutoDisposeProviderRef<ChartOfAccountRepository>;
String _$chartOfAccountsHash() => r'11802df299dabb6d26895e10dec69d74aa2fa8c7';

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

/// See also [chartOfAccounts].
@ProviderFor(chartOfAccounts)
const chartOfAccountsProvider = ChartOfAccountsFamily();

/// See also [chartOfAccounts].
class ChartOfAccountsFamily extends Family<AsyncValue<List<ChartOfAccount>>> {
  /// See also [chartOfAccounts].
  const ChartOfAccountsFamily();

  /// See also [chartOfAccounts].
  ChartOfAccountsProvider call({
    required int companyId,
  }) {
    return ChartOfAccountsProvider(
      companyId: companyId,
    );
  }

  @override
  ChartOfAccountsProvider getProviderOverride(
    covariant ChartOfAccountsProvider provider,
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
  String? get name => r'chartOfAccountsProvider';
}

/// See also [chartOfAccounts].
class ChartOfAccountsProvider
    extends AutoDisposeFutureProvider<List<ChartOfAccount>> {
  /// See also [chartOfAccounts].
  ChartOfAccountsProvider({
    required int companyId,
  }) : this._internal(
          (ref) => chartOfAccounts(
            ref as ChartOfAccountsRef,
            companyId: companyId,
          ),
          from: chartOfAccountsProvider,
          name: r'chartOfAccountsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chartOfAccountsHash,
          dependencies: ChartOfAccountsFamily._dependencies,
          allTransitiveDependencies:
              ChartOfAccountsFamily._allTransitiveDependencies,
          companyId: companyId,
        );

  ChartOfAccountsProvider._internal(
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
    FutureOr<List<ChartOfAccount>> Function(ChartOfAccountsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChartOfAccountsProvider._internal(
        (ref) => create(ref as ChartOfAccountsRef),
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
  AutoDisposeFutureProviderElement<List<ChartOfAccount>> createElement() {
    return _ChartOfAccountsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChartOfAccountsProvider && other.companyId == companyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, companyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChartOfAccountsRef on AutoDisposeFutureProviderRef<List<ChartOfAccount>> {
  /// The parameter `companyId` of this provider.
  int get companyId;
}

class _ChartOfAccountsProviderElement
    extends AutoDisposeFutureProviderElement<List<ChartOfAccount>>
    with ChartOfAccountsRef {
  _ChartOfAccountsProviderElement(super.provider);

  @override
  int get companyId => (origin as ChartOfAccountsProvider).companyId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
