import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/api/paginated_response.dart';
import '../../../core/providers/company_provider.dart';

part 'aquaculture_crud_provider.g.dart';

class AquacultureCrudRepository {
  final Dio dio;

  AquacultureCrudRepository(this.dio);

  Future<List<dynamic>> listAll(String resource, {Map<String, dynamic>? params}) async {
    final response = await dio.get('wh/aquaculture/crud/$resource', queryParameters: {
      'all': true,
      ...?params,
    });
    return response.data['data'] as List;
  }

  Future<PaginatedResponse<dynamic>> listPaginated(
    String resource, {
    required int page,
    Map<String, dynamic>? params,
  }) async {
    final response = await dio.get('wh/aquaculture/crud/$resource', queryParameters: {
      'page': page,
      ...?params,
    });
    return PaginatedResponse.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );
  }

  Future<dynamic> create(String resource, Map<String, dynamic> data) async {
    final response = await dio.post('wh/aquaculture/crud/$resource', data: data);
    return response.data['data'];
  }

  Future<dynamic> show(String resource, int id) async {
    final response = await dio.get('wh/aquaculture/crud/$resource/$id');
    return response.data['data'];
  }

  Future<dynamic> update(String resource, int id, Map<String, dynamic> data) async {
    final response = await dio.put('wh/aquaculture/crud/$resource/$id', data: data);
    return response.data['data'];
  }

  Future<void> delete(String resource, int id) async {
    await dio.delete('wh/aquaculture/crud/$resource/$id');
  }
}

@riverpod
AquacultureCrudRepository aquacultureCrudRepository(AquacultureCrudRepositoryRef ref) {
  return AquacultureCrudRepository(ref.watch(dioProvider));
}

@riverpod
class AquacultureCrudList extends _$AquacultureCrudList {
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;

  @override
  Future<List<dynamic>> build(String resource, {Map<String, dynamic>? params}) async {
    ref.watch(aquacultureCrudRepositoryProvider);
    ref.watch(selectedCompanyProvider);
    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    return _fetchPage(1);
  }

  Future<List<dynamic>> _fetchPage(int page) async {
    final repository = ref.read(aquacultureCrudRepositoryProvider);
    final company = ref.read(selectedCompanyProvider);

    final Map<String, dynamic> queryParams = {};
    if (params != null) {
      queryParams.addAll(params!);
    }
    if (company != null) {
      queryParams['company_id'] = company.id;
    }

    final response = await repository.listPaginated(
      resource,
      page: page,
      params: queryParams,
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
    state = const AsyncLoading<List<dynamic>>().copyWithPrevious(state);

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
    state = const AsyncLoading<List<dynamic>>();
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
