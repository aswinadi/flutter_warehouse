import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/stock_mutation.dart';
import '../../../core/models/warehouse.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/api/paginated_response.dart';
import '../../../core/providers/company_provider.dart';
import '../../../core/providers/warehouse_provider.dart';

part 'stock_mutation_provider.g.dart';

class StockCardResponse {
  final StockMutationHeader summary;
  final PaginatedResponse<StockMutationDetail> detail;

  StockCardResponse({
    required this.summary,
    required this.detail,
  });
}

class StockMutationRepository {
  final Dio dio;

  StockMutationRepository(this.dio);

  Future<PaginatedResponse<StockMutationSummary>> getMutationSummary({
    required int companyId,
    required int warehouseId,
    required String dateFrom,
    required String dateTo,
    String? search,
    int page = 1,
  }) async {
    final response = await dio.get('wh/inventory-report/summary', queryParameters: {
      'company_id': companyId,
      'warehouse_id': warehouseId,
      'date_from': dateFrom,
      'date_to': dateTo,
      'page': page,
      if (search != null) 'search': search,
    });

    return PaginatedResponse.fromJson(
      response.data,
      (json) => StockMutationSummary.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<StockCardResponse> getMutationDetail({
    required int companyId,
    required int warehouseId,
    required String dateFrom,
    required String dateTo,
    required String sku,
    int page = 1,
  }) async {
    final response = await dio.get('wh/inventory-report/detail', queryParameters: {
      'company_id': companyId,
      'warehouse_id': warehouseId,
      'date_from': dateFrom,
      'date_to': dateTo,
      'sku': sku,
      'page': page,
    });

    final summary = StockMutationHeader.fromJson(response.data['summary'] as Map<String, dynamic>);
    final detail = PaginatedResponse.fromJson(
      response.data,
      (json) => StockMutationDetail.fromJson(json as Map<String, dynamic>),
    );

    return StockCardResponse(summary: summary, detail: detail);
  }
}

@riverpod
StockMutationRepository stockMutationRepository(StockMutationRepositoryRef ref) {
  return StockMutationRepository(ref.watch(dioProvider));
}

@riverpod
class SelectedWarehouse extends _$SelectedWarehouse {
  @override
  Warehouse? build() {
    final company = ref.watch(selectedCompanyProvider);
    if (company == null) return null;

    final warehousesAsync = ref.watch(warehousesProvider);
    return warehousesAsync.when(
      data: (list) {
        final companyWarehouses = list.where((w) => w.companyId == company.id).toList();
        return companyWarehouses.isNotEmpty ? companyWarehouses.first : null;
      },
      loading: () => null,
      error: (_, __) => null,
    );
  }

  void selectWarehouse(Warehouse? warehouse) {
    state = warehouse;
  }
}

@riverpod
class StockMutationDateRange extends _$StockMutationDateRange {
  @override
  DateTimeRange build() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    return DateTimeRange(start: start, end: now);
  }

  void selectRange(DateTimeRange range) {
    state = range;
  }
}

@riverpod
class StockMutationSearchQuery extends _$StockMutationSearchQuery {
  @override
  String build() {
    return '';
  }

  void setQuery(String query) {
    state = query;
  }
}

@riverpod
class StockMutationSummaryList extends _$StockMutationSummaryList {
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;

  @override
  Future<List<StockMutationSummary>> build() async {
    ref.watch(selectedCompanyProvider);
    final warehouse = ref.watch(selectedWarehouseProvider);
    ref.watch(stockMutationDateRangeProvider);
    ref.watch(stockMutationSearchQueryProvider);

    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;

    if (warehouse == null) return [];

    return _fetchPage(1);
  }

  Future<List<StockMutationSummary>> _fetchPage(int page) async {
    final repository = ref.read(stockMutationRepositoryProvider);
    final company = ref.read(selectedCompanyProvider);
    final warehouse = ref.read(selectedWarehouseProvider);
    final range = ref.read(stockMutationDateRangeProvider);
    final query = ref.read(stockMutationSearchQueryProvider);

    if (company == null || warehouse == null) return [];

    final dateFrom = range.start.toIso8601String().split('T').first;
    final dateTo = range.end.toIso8601String().split('T').first;

    final response = await repository.getMutationSummary(
      companyId: company.id,
      warehouseId: warehouse.id,
      dateFrom: dateFrom,
      dateTo: dateTo,
      search: query.isEmpty ? null : query,
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
    state = const AsyncLoading<List<StockMutationSummary>>().copyWithPrevious(state);

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
class StockCardDetailList extends _$StockCardDetailList {
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  StockMutationHeader? _summaryHeader;

  bool get hasMore => _hasMore;
  StockMutationHeader? get summaryHeader => _summaryHeader;

  @override
  Future<List<StockMutationDetail>> build(String sku) async {
    ref.watch(selectedCompanyProvider);
    ref.watch(selectedWarehouseProvider);
    ref.watch(stockMutationDateRangeProvider);

    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    _summaryHeader = null;

    final company = ref.read(selectedCompanyProvider);
    final warehouse = ref.read(selectedWarehouseProvider);

    if (company == null || warehouse == null) return [];

    return _fetchPage(1);
  }

  Future<List<StockMutationDetail>> _fetchPage(int page) async {
    final repository = ref.read(stockMutationRepositoryProvider);
    final company = ref.read(selectedCompanyProvider);
    final warehouse = ref.read(selectedWarehouseProvider);
    final range = ref.read(stockMutationDateRangeProvider);

    if (company == null || warehouse == null) return [];

    final dateFrom = range.start.toIso8601String().split('T').first;
    final dateTo = range.end.toIso8601String().split('T').first;

    final response = await repository.getMutationDetail(
      companyId: company.id,
      warehouseId: warehouse.id,
      dateFrom: dateFrom,
      dateTo: dateTo,
      sku: sku,
      page: page,
    );

    _summaryHeader = response.summary;

    if (response.detail.meta != null) {
      _hasMore = response.detail.meta!.currentPage < response.detail.meta!.lastPage;
    } else {
      _hasMore = response.detail.data.isNotEmpty;
    }

    return response.detail.data;
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;

    final currentList = state.value ?? [];
    state = const AsyncLoading<List<StockMutationDetail>>().copyWithPrevious(state);

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
