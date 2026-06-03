import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'transfer_repository.dart';
import '../models/transfer.dart';
import '../../../core/providers/company_provider.dart';
import '../../inventory/models/inventory.dart';
import '../../inventory/providers/inventory_provider.dart';

part 'transfer_provider.g.dart';

@riverpod
class TransfersList extends _$TransfersList {
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;

  @override
  Future<List<WarehouseTransfer>> build({
    int? sourceWarehouseId,
    int? destinationWarehouseId,
    String? status,
  }) async {
    ref.watch(transferRepositoryProvider);
    ref.watch(selectedCompanyProvider);

    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    return _fetchPage(1);
  }

  Future<List<WarehouseTransfer>> _fetchPage(int page) async {
    final repository = ref.read(transferRepositoryProvider);
    final selectedCompany = ref.read(selectedCompanyProvider);

    final response = await repository.getTransfers(
      page: page,
      companyId: selectedCompany?.id,
      sourceWarehouseId: sourceWarehouseId,
      destinationWarehouseId: destinationWarehouseId,
      status: status,
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
    state = const AsyncLoading<List<WarehouseTransfer>>().copyWithPrevious(state);

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
Future<WarehouseTransfer> transferDetail(TransferDetailRef ref, int id) async {
  final repository = ref.watch(transferRepositoryProvider);
  return repository.getTransferDetail(id);
}

@riverpod
Future<List<Inventory>> warehouseInventory(
  WarehouseInventoryRef ref, {
  required int warehouseId,
  String? search,
}) async {
  final repo = ref.watch(inventoryRepositoryProvider);
  final response = await repo.getInventory(
    page: 1,
    search: search,
    warehouseId: warehouseId,
  );
  return response.data;
}
