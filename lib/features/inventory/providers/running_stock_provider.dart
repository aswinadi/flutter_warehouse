import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'inventory_provider.dart';
import '../models/running_stock.dart';
import '../../../core/providers/company_provider.dart';

final runningStockFilterProvider = StateProvider<RunningStockFilterState>((ref) {
  return const RunningStockFilterState(
    filterOnHand: true,
    filterInTransit: true,
    filterOrdered: true,
    showEmpty: false,
  );
});

final runningStockSearchProvider = StateProvider<String?>((ref) => null);

class RunningStockNotifier extends StateNotifier<AsyncValue<List<RunningStockItem>>> {
  final Ref ref;
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  RunningStockNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchInitial();
  }

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> fetchInitial() async {
    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    state = const AsyncValue.loading();

    try {
      final repo = ref.read(inventoryRepositoryProvider);
      final company = ref.read(selectedCompanyProvider);
      final filter = ref.read(runningStockFilterProvider);
      final search = ref.read(runningStockSearchProvider);

      final response = await repo.getRunningStockReport(
        companyId: company?.id,
        search: search,
        filterOnHand: filter.filterOnHand,
        filterInTransit: filter.filterInTransit,
        filterOrdered: filter.filterOrdered,
        showEmpty: filter.showEmpty,
        page: 1,
        perPage: 20,
      );

      if (response.meta != null) {
        _hasMore = response.meta!.currentPage < response.meta!.lastPage;
      } else {
        _hasMore = response.data.isNotEmpty;
      }

      state = AsyncValue.data(response.data);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;

    final currentItems = state.value ?? [];

    try {
      final nextPage = _currentPage + 1;
      final repo = ref.read(inventoryRepositoryProvider);
      final company = ref.read(selectedCompanyProvider);
      final filter = ref.read(runningStockFilterProvider);
      final search = ref.read(runningStockSearchProvider);

      final response = await repo.getRunningStockReport(
        companyId: company?.id,
        search: search,
        filterOnHand: filter.filterOnHand,
        filterInTransit: filter.filterInTransit,
        filterOrdered: filter.filterOrdered,
        showEmpty: filter.showEmpty,
        page: nextPage,
        perPage: 20,
      );

      _currentPage = nextPage;
      if (response.meta != null) {
        _hasMore = response.meta!.currentPage < response.meta!.lastPage;
      } else {
        _hasMore = response.data.isNotEmpty;
      }

      state = AsyncValue.data([...currentItems, ...response.data]);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    } finally {
      _isLoadingMore = false;
    }
  }
}

final runningStockListProvider = StateNotifierProvider.autoDispose<RunningStockNotifier, AsyncValue<List<RunningStockItem>>>((ref) {
  ref.watch(selectedCompanyProvider);
  ref.watch(runningStockFilterProvider);
  ref.watch(runningStockSearchProvider);
  return RunningStockNotifier(ref);
});
