import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/feed_log.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/api/paginated_response.dart';
import '../../../core/providers/company_provider.dart';

part 'feed_log_provider.g.dart';

class FeedLogRepository {
  final Dio dio;

  FeedLogRepository(this.dio);

  Future<List<AquacultureCycle>> getCycles(int companyId) async {
    final response = await dio.get('wh/aquaculture/cycles', queryParameters: {
      'company_id': companyId,
    });
    return (response.data['data'] as List)
        .map((e) => AquacultureCycle.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<AquaculturePond>> getPonds({int? cycleId}) async {
    final response = await dio.get('wh/aquaculture/ponds', queryParameters: {
      if (cycleId != null) 'cycle_id': cycleId,
    });
    return (response.data['data'] as List)
        .map((e) => AquaculturePond.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<PaginatedResponse<FeedLog>> getFeedLogs({
    required int companyId,
    int? cycleId,
    int? pondId,
    String? startDate,
    String? endDate,
    int page = 1,
  }) async {
    final response = await dio.get('wh/feed-logs', queryParameters: {
      'company_id': companyId,
      'page': page,
      if (cycleId != null) 'cycle_id': cycleId,
      if (pondId != null) 'pond_id': pondId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
    });

    return PaginatedResponse.fromJson(
      response.data,
      (json) => FeedLog.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<FeedLog> createFeedLog(Map<String, dynamic> data) async {
    final response = await dio.post('wh/feed-logs', data: data);
    return FeedLog.fromJson(response.data['data']);
  }

  Future<FeedLog> updateFeedLog(int id, Map<String, dynamic> data) async {
    final response = await dio.put('wh/feed-logs/$id', data: data);
    return FeedLog.fromJson(response.data['data']);
  }

  Future<void> deleteFeedLog(int id) async {
    await dio.delete('wh/feed-logs/$id');
  }
}

@riverpod
FeedLogRepository feedLogRepository(FeedLogRepositoryRef ref) {
  return FeedLogRepository(ref.watch(dioProvider));
}

@riverpod
Future<List<AquacultureCycle>> feedCycles(FeedCyclesRef ref) async {
  final company = ref.watch(selectedCompanyProvider);
  if (company == null) return [];
  final repository = ref.watch(feedLogRepositoryProvider);
  return repository.getCycles(company.id);
}

@riverpod
Future<List<AquaculturePond>> feedPonds(FeedPondsRef ref, {int? cycleId}) async {
  final repository = ref.watch(feedLogRepositoryProvider);
  return repository.getPonds(cycleId: cycleId);
}

@riverpod
class FeedLogsList extends _$FeedLogsList {
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;

  @override
  Future<List<FeedLog>> build({
    int? cycleId,
    int? pondId,
    String? startDate,
    String? endDate,
  }) async {
    ref.watch(feedLogRepositoryProvider);
    ref.watch(selectedCompanyProvider);

    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    return _fetchPage(1);
  }

  Future<List<FeedLog>> _fetchPage(int page) async {
    final repository = ref.read(feedLogRepositoryProvider);
    final company = ref.read(selectedCompanyProvider);
    if (company == null) return [];

    final response = await repository.getFeedLogs(
      companyId: company.id,
      cycleId: cycleId,
      pondId: pondId,
      startDate: startDate,
      endDate: endDate,
      page: page,
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
    state = const AsyncLoading<List<FeedLog>>().copyWithPrevious(state);

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

  Future<void> refresh() async {
    state = const AsyncLoading<List<FeedLog>>();
    try {
      _currentPage = 1;
      _hasMore = true;
      final data = await _fetchPage(1);
      state = AsyncValue.data(data);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    }
  }
}
