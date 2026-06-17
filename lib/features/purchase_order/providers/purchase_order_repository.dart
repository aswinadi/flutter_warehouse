import 'package:dio/dio.dart';
import '../models/purchase_order.dart';
import '../../../core/api/paginated_response.dart';

class PurchaseOrderRepository {
  final Dio dio;

  PurchaseOrderRepository(this.dio);

  Future<PaginatedResponse<PurchaseOrder>> getPurchaseOrders({
    int page = 1,
    String? status,
    String? search,
    int? supplierId,
    int? companyId,
    String? dateFrom,
    String? dateTo,
  }) async {
    final response = await dio.get('wh/purchase-orders', queryParameters: {
      'page': page,
      'status': status,
      'search': search,
      'supplier_id': supplierId,
      'company_id': companyId,
      'date_from': dateFrom,
      'date_to': dateTo,
    }..removeWhere((key, value) => value == null));

    return PaginatedResponse.fromJson(
      response.data,
      (json) => PurchaseOrder.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<PurchaseOrder> getPurchaseOrderDetail(int id) async {
    final response = await dio.get('wh/purchase-orders/$id');
    return PurchaseOrder.fromJson(response.data['data']);
  }

  Future<void> approvePurchaseOrder(int id) async {
    await dio.post('wh/purchase-orders/$id/approve');
  }

  Future<void> rejectPurchaseOrder(int id, String reason) async {
    await dio.post('wh/purchase-orders/$id/reject', data: {'reason': reason});
  }
}
