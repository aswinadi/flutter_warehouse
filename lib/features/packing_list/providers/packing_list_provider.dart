import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'packing_list_repository.dart';
import '../models/packing_list.dart';
import '../../../core/api/dio_client.dart';

part 'packing_list_provider.g.dart';

@riverpod
PackingListRepository packingListRepository(PackingListRepositoryRef ref) {
  return PackingListRepository(ref.watch(dioProvider));
}

@riverpod
class PackingLists extends _$PackingLists {
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;

  @override
  Future<List<PackingList>> build({
    String? status,
    String? search,
  }) async {
    ref.watch(packingListRepositoryProvider);
    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    return _fetchPage(1);
  }

  Future<List<PackingList>> _fetchPage(int page) async {
    final repository = ref.read(packingListRepositoryProvider);

    final response = await repository.getPackingLists(
      page: page,
      status: status,
      search: search,
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
    state = const AsyncLoading<List<PackingList>>().copyWithPrevious(state);

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
Future<PackingList> packingListDetail(PackingListDetailRef ref, int id) async {
  final repository = ref.watch(packingListRepositoryProvider);
  return await repository.getPackingListDetail(id);
}

@riverpod
Future<List<dynamic>> availablePoItems(AvailablePoItemsRef ref, int id) async {
  final repository = ref.watch(packingListRepositoryProvider);
  return await repository.getAvailablePoItems(id);
}

@riverpod
Future<List<dynamic>> availableInventoryItems(AvailableInventoryItemsRef ref, int id) async {
  final repository = ref.watch(packingListRepositoryProvider);
  return await repository.getAvailableInventoryItems(id);
}
