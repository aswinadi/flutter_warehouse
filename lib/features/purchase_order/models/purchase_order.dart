import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_utils.dart';

part 'purchase_order.freezed.dart';
part 'purchase_order.g.dart';

@freezed
class PurchaseOrder with _$PurchaseOrder {
  const factory PurchaseOrder({
    required int id,
    @JsonKey(name: 'po_number') required String poNumber,
    @JsonKey(name: 'company_id') required int companyId,
    @JsonKey(name: 'warehouse_id') required int warehouseId,
    @JsonKey(name: 'warehouse_name') String? warehouseName,
    @JsonKey(name: 'supplier_id') int? supplierId,
    @JsonKey(name: 'supplier_name') required String supplierName,
    @JsonKey(name: 'transaction_date') required String transactionDate,
    @JsonKey(name: 'expected_date') required String expectedDate,
    @JsonKey(name: 'payment_term') String? paymentTerm,
    required String status,
    @JsonKey(name: 'total_items') @Default(0) int totalItems,
    @JsonKey(name: 'received_items') @Default(0) int receivedItems,
    @JsonKey(name: 'can_approve') @Default(false) bool canApprove,
    @JsonKey(name: 'pdf_url') String? pdfUrl,
    @JsonKey(name: 'total_amount', fromJson: doubleOrNullFromJson) double? totalAmount,
    @Default([]) List<PurchaseOrderItem> items,
  }) = _PurchaseOrder;

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) =>
      _$PurchaseOrderFromJson(json);
}

@freezed
class PurchaseOrderItem with _$PurchaseOrderItem {
  const factory PurchaseOrderItem({
    required int id,
    required String sku,
    @JsonKey(name: 'product_name') required String productName,
    @JsonKey(name: 'ordered_qty', fromJson: doubleFromJson) required double orderedQty,
    @JsonKey(name: 'received_qty', fromJson: doubleFromJson) required double receivedQty,
    @JsonKey(name: 'remaining_qty', fromJson: doubleFromJson) required double remainingQty,
    required String unit,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'unit_price', fromJson: doubleOrNullFromJson) double? unitPrice,
    @JsonKey(name: 'detail_notes') String? detailNotes,
    @JsonKey(name: 'detail_spec') String? detailSpec,
    @Default(0) int version,
  }) = _PurchaseOrderItem;

  factory PurchaseOrderItem.fromJson(Map<String, dynamic> json) =>
      _$PurchaseOrderItemFromJson(json);
}
