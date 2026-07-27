import '../../../core/utils/json_utils.dart';

class ReturnToVendor {
  final int id;
  final String rtvNumber;
  final int companyId;
  final String? companyName;
  final int supplierId;
  final String? supplierName;
  final int warehouseId;
  final String? warehouseName;
  final int? purchaseOrderId;
  final int? receivingHeaderId;
  final String returnDate;
  final String status;
  final double totalAmount;
  final String? reason;
  final String? notes;
  final int? createdBy;
  final String? createdByName;
  final String? shippedAt;
  final List<ReturnToVendorDetail> details;

  ReturnToVendor({
    required this.id,
    required this.rtvNumber,
    required this.companyId,
    this.companyName,
    required this.supplierId,
    this.supplierName,
    required this.warehouseId,
    this.warehouseName,
    this.purchaseOrderId,
    this.receivingHeaderId,
    required this.returnDate,
    required this.status,
    required this.totalAmount,
    this.reason,
    this.notes,
    this.createdBy,
    this.createdByName,
    this.shippedAt,
    this.details = const [],
  });

  factory ReturnToVendor.fromJson(Map<String, dynamic> json) {
    return ReturnToVendor(
      id: (json['id'] as num).toInt(),
      rtvNumber: json['rtv_number'] as String? ?? '',
      companyId: (json['company_id'] as num).toInt(),
      companyName: json['company'] != null ? json['company']['company_name'] as String? : json['company_name'] as String?,
      supplierId: (json['supplier_id'] as num).toInt(),
      supplierName: json['supplier'] != null ? json['supplier']['name'] as String? : json['supplier_name'] as String?,
      warehouseId: (json['warehouse_id'] as num).toInt(),
      warehouseName: json['warehouse'] != null ? json['warehouse']['name'] as String? : json['warehouse_name'] as String?,
      purchaseOrderId: (json['purchase_order_id'] as num?)?.toInt(),
      receivingHeaderId: (json['receiving_header_id'] as num?)?.toInt(),
      returnDate: json['return_date'] as String? ?? '',
      status: json['status'] as String? ?? 'draft',
      totalAmount: doubleFromJson(json['total_amount']),
      reason: json['reason'] as String?,
      notes: json['notes'] as String?,
      createdBy: (json['created_by'] as num?)?.toInt(),
      createdByName: json['created_by_user'] != null ? json['created_by_user']['name'] as String? : json['created_by_name'] as String?,
      shippedAt: json['shipped_at'] as String?,
      details: (json['details'] as List<dynamic>?)
              ?.map((e) => ReturnToVendorDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'rtv_number': rtvNumber,
        'company_id': companyId,
        'company_name': companyName,
        'supplier_id': supplierId,
        'supplier_name': supplierName,
        'warehouse_id': warehouseId,
        'warehouse_name': warehouseName,
        'purchase_order_id': purchaseOrderId,
        'receiving_header_id': receivingHeaderId,
        'return_date': returnDate,
        'status': status,
        'total_amount': totalAmount,
        'reason': reason,
        'notes': notes,
        'created_by': createdBy,
        'created_by_name': createdByName,
        'shipped_at': shippedAt,
        'details': details.map((e) => e.toJson()).toList(),
      };
}

class ReturnToVendorDetail {
  final int id;
  final int returnToVendorId;
  final int itemId;
  final String? itemName;
  final String? itemCode;
  final double quantity;
  final double unitPrice;
  final double subtotal;
  final String? reason;
  final String condition;

  ReturnToVendorDetail({
    required this.id,
    required this.returnToVendorId,
    required this.itemId,
    this.itemName,
    this.itemCode,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    this.reason,
    this.condition = 'damaged',
  });

  factory ReturnToVendorDetail.fromJson(Map<String, dynamic> json) {
    return ReturnToVendorDetail(
      id: (json['id'] as num).toInt(),
      returnToVendorId: (json['return_to_vendor_id'] as num).toInt(),
      itemId: (json['item_id'] as num).toInt(),
      itemName: json['product'] != null ? json['product']['name'] as String? : json['item_name'] as String?,
      itemCode: json['product'] != null ? json['product']['sku'] as String? : json['item_code'] as String?,
      quantity: doubleFromJson(json['quantity']),
      unitPrice: doubleFromJson(json['unit_price']),
      subtotal: doubleFromJson(json['subtotal']),
      reason: json['reason'] as String?,
      condition: json['condition'] as String? ?? 'damaged',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'return_to_vendor_id': returnToVendorId,
        'item_id': itemId,
        'item_name': itemName,
        'item_code': itemCode,
        'quantity': quantity,
        'unit_price': unitPrice,
        'subtotal': subtotal,
        'reason': reason,
        'condition': condition,
      };
}
