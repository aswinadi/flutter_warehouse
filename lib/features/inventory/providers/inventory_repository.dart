import 'package:dio/dio.dart';
import '../models/inventory.dart';
import '../models/inventory_breakdown.dart';
import '../models/running_stock.dart';
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

  Future<PaginatedResponse<RunningStockItem>> getRunningStockReport({
    int? companyId,
    String? search,
    bool filterOnHand = true,
    bool filterInTransit = true,
    bool filterOrdered = true,
    bool showEmpty = false,
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await dio.get('wh/inventory-report/running-stock', queryParameters: {
      'page': page,
      'per_page': perPage,
      if (companyId != null) 'company_id': companyId,
      if (search != null && search.isNotEmpty) 'search': search,
      'filter_on_hand': filterOnHand ? 1 : 0,
      'filter_in_transit': filterInTransit ? 1 : 0,
      'filter_ordered': filterOrdered ? 1 : 0,
      'show_empty': showEmpty ? 1 : 0,
    });

    return PaginatedResponse.fromJson(
      response.data,
      (json) => RunningStockItem.fromJson(json as Map<String, dynamic>),
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

