import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'purchase_request_repository.dart';
import '../models/purchase_request.dart';
import '../models/supplier.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/providers/company_provider.dart';

part 'purchase_request_provider.g.dart';

@riverpod
PurchaseRequestRepository purchaseRequestRepository(PurchaseRequestRepositoryRef ref) {
  return PurchaseRequestRepository(ref.watch(dioProvider));
}

@riverpod
class PurchaseRequests extends _$PurchaseRequests {
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;

  @override
  Future<List<PurchaseRequest>> build({
    String? status,
    String? search,
    String? startDate,
    String? endDate,
    bool history = false,
  }) async {
    ref.watch(purchaseRequestRepositoryProvider);
    ref.watch(selectedCompanyProvider);

    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    return _fetchPage(1);
  }

  Future<List<PurchaseRequest>> _fetchPage(int page) async {
    final repository = ref.read(purchaseRequestRepositoryProvider);
    final selectedCompany = ref.read(selectedCompanyProvider);

    final response = await repository.getPurchaseRequests(
      page: page,
      status: status,
      search: search,
      companyId: selectedCompany?.id,
      startDate: startDate,
      endDate: endDate,
      history: history,
    );

    if (response.meta != null) {
      _hasMore = response.meta!.currentPage < response.meta!.lastPage;
    } else {
      _hasMore = response.data.isNotEmpty;
    }

    return response.data;
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;

    final currentList = state.value ?? [];
    state = const AsyncLoading<List<PurchaseRequest>>().copyWithPrevious(state);

    try {
      final nextPage = _currentPage + 1;
      final response = await _fetchPage(nextPage);

      _currentPage = nextPage;
      state = AsyncValue.data([...currentList, ...response]);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    } finally {
      _isLoadingMore = false;
    }
  }
}

final prItemSuggestionsProvider = FutureProvider.family<List<dynamic>, int>((ref, prId) async {
  final repository = ref.watch(purchaseRequestRepositoryProvider);
  return await repository.getItemSuggestions(prId);
});



/// Searchable supplier list provider.
/// Pass an empty string or null to fetch all suppliers.
final suppliersProvider = FutureProvider.family<List<Supplier>, String?>((ref, search) async {
  final repository = ref.watch(purchaseRequestRepositoryProvider);
  return await repository.getSuppliers(search: search);
});
