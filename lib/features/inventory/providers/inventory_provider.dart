import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'inventory_repository.dart';
import '../models/inventory.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/providers/company_provider.dart';

part 'inventory_provider.g.dart';

@riverpod
InventoryRepository inventoryRepository(InventoryRepositoryRef ref) {
  return InventoryRepository(ref.watch(dioProvider));
}

@riverpod
class InventoryList extends _$InventoryList {
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;

  @override
  Future<List<Inventory>> build({String? search}) async {
    ref.watch(inventoryRepositoryProvider);
    ref.watch(selectedCompanyProvider);

    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    return _fetchPage(1);
  }

  Future<List<Inventory>> _fetchPage(int page) async {
    final repository = ref.read(inventoryRepositoryProvider);
    final selectedCompany = ref.read(selectedCompanyProvider);
    final response = await repository.getInventory(
      page: page,
      search: search,
      companyId: selectedCompany?.id,
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
    state = const AsyncLoading<List<Inventory>>().copyWithPrevious(state);

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
