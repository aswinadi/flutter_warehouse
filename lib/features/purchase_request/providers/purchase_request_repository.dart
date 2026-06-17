import 'package:dio/dio.dart';
import '../models/purchase_request.dart';
import '../models/pr_approval.dart';
import '../models/pr_rejection.dart';
import '../models/supplier.dart';
import '../../../core/api/paginated_response.dart';

class PurchaseRequestRepository {
  final Dio dio;

  PurchaseRequestRepository(this.dio);

  Future<void> approvePurchaseRequest(int id, ApproveRequest request) async {
    await dio.post('wh/purchase-requests/$id/approve', data: request.toJson());
  }

  Future<void> rejectPurchaseRequest(int id, RejectRequest request) async {
    await dio.post('wh/purchase-requests/$id/reject', data: request.toJson());
  }

  Future<void> approvePurchaseRequestComparisons(int id, List<Map<String, int>> selections) async {
    await dio.post('wh/purchase-requests/$id/approve-comparisons', data: {
      'selections': selections,
    });
  }

  Future<void> autoAssignVendors(int id, {required String strategy}) async {
    await dio.post('wh/purchase-requests/$id/auto-assign', data: {
      'strategy': strategy,
    });
  }

  Future<void> submitToBod(int id, {List<int>? itemIds}) async {
    await dio.post('wh/purchase-requests/$id/submit-to-bod', data: {
      if (itemIds != null) 'item_ids': itemIds,
    });
  }

  Future<List<dynamic>> getItemSuggestions(int prId) async {
    final response = await dio.get('wh/purchase-requests/$prId/item-suggestions');
    return response.data['data'] as List<dynamic>;
  }

  Future<PaginatedResponse<PurchaseRequest>> getPurchaseRequests({
    int page = 1,
    String? status,
    String? search,
    int? companyId,
    String? startDate,
    String? endDate,
  }) async {
    final response = await dio.get('wh/purchase-requests', queryParameters: {
      'page': page,
      if (status != null) 'status': status,
      if (search != null) 'search': search,
      if (companyId != null) 'company_id': companyId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
    });

    return PaginatedResponse.fromJson(
      response.data,
      (json) => PurchaseRequest.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<PurchaseRequest> getPurchaseRequestDetail(int id) async {
    final response = await dio.get('wh/purchase-requests/$id');
    return PurchaseRequest.fromJson(response.data['data']);
  }

  /// Fetches the active supplier list. Optionally filter by [search] query or [companyId].
  Future<List<Supplier>> getSuppliers({String? search, int? companyId}) async {
    final response = await dio.get('wh/suppliers', queryParameters: {
      if (search != null && search.isNotEmpty) 'search': search,
      if (companyId != null) 'company_id': companyId,
    });
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => Supplier.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Creates or updates a vendor comparison for a PR.
  ///
  /// [supplierId]    — the vendor being assigned
  /// [leadTimeDays]  — delivery estimate in days
  /// [notes]         — optional free-text notes
  /// [items]         — list of `{ 'pr_detail_id': int, 'price': double }` entries
  Future<void> assignVendorComparison(
    int prId, {
    required int supplierId,
    int leadTimeDays = 7,
    String? notes,
    required List<Map<String, dynamic>> items,
  }) async {
    await dio.post('wh/purchase-requests/$prId/comparisons', data: {
      'supplier_id': supplierId,
      'lead_time_days': leadTimeDays,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
      'items': items,
    });
  }

  Future<void> removeVendorComparison(int prId, int comparisonId) async {
    await dio.delete('wh/purchase-requests/$prId/comparisons/$comparisonId');
  }

  /// Generates POs from BOD acknowledged vendor selections.
  /// Optionally filter by [comparisonIds] and [itemIds] to generate POs only for those selections/items.
  Future<List<dynamic>> generatePOs(int prId, {List<int>? comparisonIds, List<int>? itemIds}) async {
    final response = await dio.post('wh/purchase-requests/$prId/generate-pos', data: {
      if (comparisonIds != null) 'comparison_ids': comparisonIds,
      if (itemIds != null) 'item_ids': itemIds,
    });
    return response.data['purchase_orders'] as List<dynamic>;
  }
}
