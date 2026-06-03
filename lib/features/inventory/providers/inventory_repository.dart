import 'package:dio/dio.dart';
import '../models/inventory.dart';
import '../models/inventory_breakdown.dart';
import '../../../core/api/paginated_response.dart';

class InventoryRepository {
  final Dio dio;

  InventoryRepository(this.dio);

  Future<PaginatedResponse<Inventory>> getInventory({
    int page = 1,
    String? search,
    int? warehouseId,
    int? companyId,
  }) async {
    final response = await dio.get('wh/inventories', queryParameters: {
      'page': page,
      if (search != null) 'search': search,
      if (warehouseId != null) 'warehouse_id': warehouseId,
      if (companyId != null) 'company_id': companyId,
    });

    return PaginatedResponse.fromJson(
      response.data,
      (json) => Inventory.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Inventory> getInventoryByBarcode(String barcodeCode) async {
    final response = await dio.get('wh/inventories/$barcodeCode');
    return Inventory.fromJson(response.data['data']);
  }

  Future<InventoryBreakdown> getInventoryBreakdown(String barcodeCode) async {
    final response = await dio.get('wh/inventories/barcode/$barcodeCode/breakdown');
    return InventoryBreakdown.fromJson(response.data['data']);
  }

  Future<InventoryBreakdown> getInventoryBreakdownBySku(String sku) async {
    final response = await dio.get('wh/inventories/sku/$sku/breakdown');
    return InventoryBreakdown.fromJson(response.data['data']);
  }
}
