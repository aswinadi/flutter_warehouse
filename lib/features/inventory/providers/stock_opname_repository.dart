import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/stock_opname.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/providers/company_provider.dart';

part 'stock_opname_repository.g.dart';

class StockOpnameRepository {
  final Dio dio;

  StockOpnameRepository(this.dio);

  Future<List<StockOpname>> getActiveSessions({
    required int companyId,
    int? warehouseId,
  }) async {
    final response = await dio.get('wh/stock-opname', queryParameters: {
      'company_id': companyId,
      if (warehouseId != null) 'warehouse_id': warehouseId,
    });

    final list = response.data['data'] as List? ?? [];
    return list.map((json) => StockOpname.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<Map<String, dynamic>> getSessionSummary(int id) async {
    final response = await dio.get('wh/stock-opname/$id/summary');
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> lookupBarcode(String barcodeCode) async {
    final response = await dio.post('wh/barcodes/scan', data: {
      'barcode_code': barcodeCode,
    });
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> submitScan({
    required int sessionId,
    required String barcode,
    int? qty,
  }) async {
    final response = await dio.post('wh/stock-opname/$sessionId/scan', data: {
      'barcode': barcode,
      if (qty != null) 'qty': qty,
    });
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<StockOpname> createSession({
    required int warehouseId,
    String? notes,
  }) async {
    final response = await dio.post('wh/stock-opname', data: {
      'warehouse_id': warehouseId,
      if (notes != null) 'notes': notes,
    });
    return StockOpname.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<StockOpname> startSession(int id) async {
    final response = await dio.post('wh/stock-opname/$id/start');
    return StockOpname.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<StockOpname> completeSession(int id) async {
    final response = await dio.post('wh/stock-opname/$id/complete');
    return StockOpname.fromJson(response.data['data'] as Map<String, dynamic>);
  }
}

@riverpod
StockOpnameRepository stockOpnameRepository(StockOpnameRepositoryRef ref) {
  return StockOpnameRepository(ref.watch(dioProvider));
}

@riverpod
Future<List<StockOpname>> activeStockOpnameSessions(ActiveStockOpnameSessionsRef ref, {int? warehouseId}) async {
  final selectedCompany = ref.watch(selectedCompanyProvider);
  if (selectedCompany == null) return [];
  
  return ref.watch(stockOpnameRepositoryProvider).getActiveSessions(
    companyId: selectedCompany.id,
    warehouseId: warehouseId,
  );
}

@riverpod
Future<Map<String, dynamic>> stockOpnameSummary(StockOpnameSummaryRef ref, int id) async {
  return ref.watch(stockOpnameRepositoryProvider).getSessionSummary(id);
}
