// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_request_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$purchaseRequestRepositoryHash() =>
    r'948791bd4117c0c88f5b38774c3f60c55ededf3d';

/// See also [purchaseRequestRepository].
@ProviderFor(purchaseRequestRepository)
final purchaseRequestRepositoryProvider =
    AutoDisposeProvider<PurchaseRequestRepository>.internal(
  purchaseRequestRepository,
  name: r'purchaseRequestRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$purchaseRequestRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PurchaseRequestRepositoryRef
    = AutoDisposeProviderRef<PurchaseRequestRepository>;
String _$purchaseRequestsHash() => r'e7d27fa0f43378735f53c290bfca2f456dbffb9d';

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

abstract class _$PurchaseRequests
    extends BuildlessAutoDisposeAsyncNotifier<List<PurchaseRequest>> {
  late final String? status;
  late final String? search;
  late final String? startDate;
  late final String? endDate;

  FutureOr<List<PurchaseRequest>> build({
    String? status,
    String? search,
    String? startDate,
    String? endDate,
  });
}

/// See also [PurchaseRequests].
@ProviderFor(PurchaseRequests)
const purchaseRequestsProvider = PurchaseRequestsFamily();

/// See also [PurchaseRequests].
class PurchaseRequestsFamily extends Family<AsyncValue<List<PurchaseRequest>>> {
  /// See also [PurchaseRequests].
  const PurchaseRequestsFamily();

  /// See also [PurchaseRequests].
  PurchaseRequestsProvider call({
    String? status,
    String? search,
    String? startDate,
    String? endDate,
  }) {
    return PurchaseRequestsProvider(
      status: status,
      search: search,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  PurchaseRequestsProvider getProviderOverride(
    covariant PurchaseRequestsProvider provider,
  ) {
    return call(
      status: provider.status,
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
  String? get name => r'purchaseRequestsProvider';
}

/// See also [PurchaseRequests].
class PurchaseRequestsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    PurchaseRequests, List<PurchaseRequest>> {
  /// See also [PurchaseRequests].
  PurchaseRequestsProvider({
    String? status,
    String? search,
    String? startDate,
    String? endDate,
  }) : this._internal(
          () => PurchaseRequests()
            ..status = status
            ..search = search
            ..startDate = startDate
            ..endDate = endDate,
          from: purchaseRequestsProvider,
          name: r'purchaseRequestsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$purchaseRequestsHash,
          dependencies: PurchaseRequestsFamily._dependencies,
          allTransitiveDependencies:
              PurchaseRequestsFamily._allTransitiveDependencies,
          status: status,
          search: search,
          startDate: startDate,
          endDate: endDate,
        );

  PurchaseRequestsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
    required this.search,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final String? status;
  final String? search;
  final String? startDate;
  final String? endDate;

  @override
  FutureOr<List<PurchaseRequest>> runNotifierBuild(
    covariant PurchaseRequests notifier,
  ) {
    return notifier.build(
      status: status,
      search: search,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Override overrideWith(PurchaseRequests Function() create) {
    return ProviderOverride(
      origin: this,
      override: PurchaseRequestsProvider._internal(
        () => create()
          ..status = status
          ..search = search
          ..startDate = startDate
          ..endDate = endDate,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
        search: search,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<PurchaseRequests,
      List<PurchaseRequest>> createElement() {
    return _PurchaseRequestsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PurchaseRequestsProvider &&
        other.status == status &&
        other.search == search &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);
    hash = _SystemHash.combine(hash, search.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PurchaseRequestsRef
    on AutoDisposeAsyncNotifierProviderRef<List<PurchaseRequest>> {
  /// The parameter `status` of this provider.
  String? get status;

  /// The parameter `search` of this provider.
  String? get search;

  /// The parameter `startDate` of this provider.
  String? get startDate;

  /// The parameter `endDate` of this provider.
  String? get endDate;
}

class _PurchaseRequestsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PurchaseRequests,
        List<PurchaseRequest>> with PurchaseRequestsRef {
  _PurchaseRequestsProviderElement(super.provider);

  @override
  String? get status => (origin as PurchaseRequestsProvider).status;
  @override
  String? get search => (origin as PurchaseRequestsProvider).search;
  @override
  String? get startDate => (origin as PurchaseRequestsProvider).startDate;
  @override
  String? get endDate => (origin as PurchaseRequestsProvider).endDate;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
