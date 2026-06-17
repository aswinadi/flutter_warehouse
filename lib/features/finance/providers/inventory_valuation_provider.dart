import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/inventory_valuation.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/providers/company_provider.dart';

final showEmptyValuationStockProvider = StateProvider<bool>((ref) => false);

class InventoryValuationRepository {
  final Dio dio;

  InventoryValuationRepository(this.dio);

  Future<List<InventoryValuation>> getValuations({
    int? companyId,
    String? search,
    bool? showEmpty,
  }) async {
    final response = await dio.get('wh/inventory-report/valuation', queryParameters: {
      if (companyId != null) 'company_id': companyId,
      if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      if (showEmpty != null) 'show_empty': showEmpty ? 1 : 0,
      'per_page': 1000,
    });

    final list = response.data['data'] as List? ?? [];
    return list.map((json) => InventoryValuation.fromJson(json)).toList();
  }

  Future<List<InventoryValuationBreakdown>> getBreakdown({
    required String sku,
    int? companyId,
  }) async {
    final response = await dio.get('wh/inventory-report/valuation/$sku', queryParameters: {
      if (companyId != null) 'company_id': companyId,
    });

    final list = response.data['data'] as List? ?? [];
    return list.map((json) => InventoryValuationBreakdown.fromJson(json)).toList();
  }
}

final inventoryValuationRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return InventoryValuationRepository(dio);
});

final inventoryValuationListProvider = FutureProvider.family<List<InventoryValuation>, String?>((ref, search) async {
  final repository = ref.watch(inventoryValuationRepositoryProvider);
  final selectedCompany = ref.watch(selectedCompanyProvider);
  final showEmpty = ref.watch(showEmptyValuationStockProvider);
  
  return repository.getValuations(
    companyId: selectedCompany?.id,
    search: search,
    showEmpty: showEmpty,
  );
});

final inventoryValuationBreakdownProvider = FutureProvider.family<List<InventoryValuationBreakdown>, String>((ref, sku) async {
  final repository = ref.watch(inventoryValuationRepositoryProvider);
  final selectedCompany = ref.watch(selectedCompanyProvider);
  
  return repository.getBreakdown(
    sku: sku,
    companyId: selectedCompany?.id,
  );
});
