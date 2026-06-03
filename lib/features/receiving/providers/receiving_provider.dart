import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'receiving_repository.dart';
import '../models/receiving.dart';
import '../../../core/providers/company_provider.dart';
import '../../purchase_order/models/purchase_order.dart';

part 'receiving_provider.g.dart';

@riverpod
class ReceivingsHistory extends _$ReceivingsHistory {
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;

  @override
  Future<List<ReceivingHistoryItem>> build() async {
    ref.watch(receivingRepositoryProvider);
    ref.watch(selectedCompanyProvider);

    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    return _fetchPage(1);
  }

  Future<List<ReceivingHistoryItem>> _fetchPage(int page) async {
    final repository = ref.read(receivingRepositoryProvider);
    final selectedCompany = ref.read(selectedCompanyProvider);

    final response = await repository.getReceivingHistory(
      page: page,
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
    state = const AsyncLoading<List<ReceivingHistoryItem>>().copyWithPrevious(state);

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
Future<PurchaseOrder> receivingPODetail(ReceivingPODetailRef ref, int poId) async {
  final repo = ref.watch(receivingRepositoryProvider);
  return repo.getPurchaseOrderDetail(poId);
}

@riverpod
Future<List<ReceivingContainer>> receivingContainers(ReceivingContainersRef ref) async {
  final repo = ref.watch(receivingRepositoryProvider);
  return repo.getReceivingContainers();
}

@riverpod
Future<ReceivingContainerManifest> containerManifest(ContainerManifestRef ref, String number) async {
  final repo = ref.watch(receivingRepositoryProvider);
  return repo.getContainerManifest(number);
}

