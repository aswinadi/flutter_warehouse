import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/landed_cost.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/api/paginated_response.dart';
import '../../../core/providers/company_provider.dart';

part 'landed_cost_repository.g.dart';

class LandedCostRepository {
  final Dio dio;

  LandedCostRepository(this.dio);

  Future<PaginatedResponse<LandedCost>> getLandedCosts({
    int page = 1,
    int? companyId,
    String? status,
    String? startDate,
    String? endDate,
  }) async {
    final response = await dio.get('wh/landed-costs', queryParameters: {
      'page': page,
      if (companyId != null) 'company_id': companyId,
      if (status != null && status != 'all') 'status': status,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
    });

    return PaginatedResponse.fromJson(
      response.data,
      (json) => LandedCost.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<LandedCost> getLandedCostDetail(int id) async {
    final response = await dio.get('wh/landed-costs/$id');
    return LandedCost.fromJson(response.data['data']);
  }

  Future<LandedCost> createLandedCost(Map<String, dynamic> data) async {
    final response = await dio.post('wh/landed-costs', data: data);
    return LandedCost.fromJson(response.data['data']);
  }

  Future<LandedCost> updateLandedCost(int id, Map<String, dynamic> data) async {
    final response = await dio.post('wh/landed-costs/$id', data: data);
    return LandedCost.fromJson(response.data['data']);
  }

  Future<void> allocateLandedCost(int id, Map<String, dynamic> data) async {
    await dio.post('wh/landed-costs/$id/allocate', data: data);
  }

  Future<void> approveLandedCost(int id) async {
    await dio.post('wh/landed-costs/$id/approve');
  }
}

@riverpod
LandedCostRepository landedCostRepository(LandedCostRepositoryRef ref) {
  return LandedCostRepository(ref.watch(dioProvider));
}

@riverpod
class LandedCostList extends _$LandedCostList {
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;

  @override
  Future<List<LandedCost>> build({
    String? status,
    String? startDate,
    String? endDate,
  }) async {
    ref.watch(landedCostRepositoryProvider);
    ref.watch(selectedCompanyProvider);

    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    return _fetchPage(1);
  }

  Future<List<LandedCost>> _fetchPage(int page) async {
    final repository = ref.read(landedCostRepositoryProvider);
    final selectedCompany = ref.read(selectedCompanyProvider);
    final response = await repository.getLandedCosts(
      page: page,
      companyId: selectedCompany?.id,
      status: status,
      startDate: startDate,
      endDate: endDate,
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
    state = const AsyncLoading<List<LandedCost>>().copyWithPrevious(state);

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
Future<LandedCost> landedCostDetail(LandedCostDetailRef ref, int id) async {
  return ref.watch(landedCostRepositoryProvider).getLandedCostDetail(id);
}
