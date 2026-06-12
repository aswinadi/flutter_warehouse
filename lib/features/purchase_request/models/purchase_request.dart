import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_utils.dart';

part 'purchase_request.freezed.dart';
part 'purchase_request.g.dart';

@freezed
class PurchaseRequest with _$PurchaseRequest {
  const factory PurchaseRequest({
    required int id,
    @JsonKey(name: 'company_id') int? companyId,
    @JsonKey(name: 'company_name') String? companyName,
    required String code,
    @JsonKey(name: 'request_date') required String requestDate,
    String? notes,
    @JsonKey(name: 'request_by_name') String? requestByName,
    required String status,
    @JsonKey(name: 'can_approve') @Default(false) bool canApprove,
    @JsonKey(name: 'approved_by') String? approvedBy,
    @JsonKey(name: 'approved_at') String? approvedAt,
    @Default([]) List<PurchaseRequestItem> details,
    @Default([]) List<PurchaseRequestComparison> comparisons,
    @JsonKey(name: 'purchase_orders') @Default([]) List<PRAssociatedPO> purchaseOrders,
  }) = _PurchaseRequest;

  factory PurchaseRequest.fromJson(Map<String, dynamic> json) =>
      _$PurchaseRequestFromJson(json);
}

@freezed
class PurchaseRequestComparison with _$PurchaseRequestComparison {
  const factory PurchaseRequestComparison({
    required int id,
    @JsonKey(name: 'supplier_id') required int supplierId,
    @JsonKey(name: 'supplier_name') required String supplierName,
    @JsonKey(name: 'total_amount', fromJson: doubleFromJson) required double totalAmount,
    @JsonKey(name: 'lead_time_days') required int leadTimeDays,
    String? status,
    String? notes,
    @Default([]) List<ComparisonDetail> details,
  }) = _PurchaseRequestComparison;

  factory PurchaseRequestComparison.fromJson(Map<String, dynamic> json) =>
      _$PurchaseRequestComparisonFromJson(json);
}

@freezed
class ComparisonDetail with _$ComparisonDetail {
  const factory ComparisonDetail({
    required int id,
    @JsonKey(name: 'purchase_request_detail_id') required int purchaseRequestDetailId,
    @JsonKey(name: 'offered_unit_price', fromJson: doubleFromJson) required double offeredUnitPrice,
  }) = _ComparisonDetail;

  factory ComparisonDetail.fromJson(Map<String, dynamic> json) =>
      _$ComparisonDetailFromJson(json);
}

@freezed
class PurchaseRequestItem with _$PurchaseRequestItem {
  const factory PurchaseRequestItem({
    required int id,
    @JsonKey(name: 'item_name') required String itemName,
    @JsonKey(name: 'item_code') required String itemCode,
    @JsonKey(name: 'qty_requested', fromJson: doubleFromJson) required double qtyRequested,
    @JsonKey(name: 'uom_order') required String uom,
    String? status,
    @JsonKey(name: 'current_stock', fromJson: doubleFromJson) @Default(0.0) double currentStock,
    @JsonKey(name: 'dt_notes') String? dtNotes,
    @JsonKey(name: 'dt_spec') String? dtSpec,
    @JsonKey(name: 'cost_code') String? costCode,
    @JsonKey(name: 'can_approve') @Default(false) bool canApprove,
    @JsonKey(name: 'pr_code') String? prCode,
    @JsonKey(name: 'company_name') String? companyName,
    @JsonKey(name: 'pr_id') int? prId,
    @JsonKey(name: 'approved_qty', fromJson: doubleOrNullFromJson) double? approvedQty,
    @JsonKey(name: 'selected_comparison_id') int? selectedComparisonId,
    @JsonKey(name: 'warehouse_code') String? warehouseCode,
    @JsonKey(name: 'warehouse_name') String? warehouseName,
    @JsonKey(name: 'po_number') String? poNumber,
  }) = _PurchaseRequestItem;

  factory PurchaseRequestItem.fromJson(Map<String, dynamic> json) =>
      _$PurchaseRequestItemFromJson(json);
}

@freezed
class PRAssociatedPO with _$PRAssociatedPO {
  const factory PRAssociatedPO({
    required int id,
    @JsonKey(name: 'po_number') required String poNumber,
    @JsonKey(name: 'supplier_name') required String supplierName,
    @JsonKey(name: 'pdf_url') String? pdfUrl,
    required String status,
  }) = _PRAssociatedPO;

  factory PRAssociatedPO.fromJson(Map<String, dynamic> json) =>
      _$PRAssociatedPOFromJson(json);
}

