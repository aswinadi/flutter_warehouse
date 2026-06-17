import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'purchase_order_repository.dart';
import '../models/purchase_order.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/providers/company_provider.dart';

part 'purchase_order_provider.g.dart';

@riverpod
PurchaseOrderRepository purchaseOrderRepository(PurchaseOrderRepositoryRef ref) {
  return PurchaseOrderRepository(ref.watch(dioProvider));
}

@riverpod
class PurchaseOrders extends _$PurchaseOrders {
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;

  @override
  Future<List<PurchaseOrder>> build({
    String? status,
    String? search,
    String? dateFrom,
    String? dateTo,
  }) async {
    ref.watch(purchaseOrderRepositoryProvider);
    ref.watch(selectedCompanyProvider);

    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    return _fetchPage(1);
  }

  Future<List<PurchaseOrder>> _fetchPage(int page) async {
    final repository = ref.read(purchaseOrderRepositoryProvider);
    final selectedCompany = ref.read(selectedCompanyProvider);

    final response = await repository.getPurchaseOrders(
      page: page,
      status: status,
      search: search,
      companyId: selectedCompany?.id,
      dateFrom: dateFrom,
      dateTo: dateTo,
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
    state = const AsyncLoading<List<PurchaseOrder>>().copyWithPrevious(state);

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

@riverpod
Future<PurchaseOrder> purchaseOrderDetail(PurchaseOrderDetailRef ref, int id) {
  return ref.watch(purchaseOrderRepositoryProvider).getPurchaseOrderDetail(id);
}
