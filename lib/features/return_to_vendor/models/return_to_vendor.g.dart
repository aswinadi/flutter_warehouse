// GENERATED CODE - MANUAL ENTRY

part of 'return_to_vendor.dart';

_$ReturnToVendorImpl _$$ReturnToVendorImplFromJson(Map<String, dynamic> json) =>
    _$ReturnToVendorImpl(
      id: (json['id'] as num).toInt(),
      rtvNumber: json['rtv_number'] as String,
      companyId: (json['company_id'] as num).toInt(),
      companyName: json['company'] != null ? json['company']['company_name'] as String? : json['company_name'] as String?,
      supplierId: (json['supplier_id'] as num).toInt(),
      supplierName: json['supplier'] != null ? json['supplier']['name'] as String? : json['supplier_name'] as String?,
      warehouseId: (json['warehouse_id'] as num).toInt(),
      warehouseName: json['warehouse'] != null ? json['warehouse']['name'] as String? : json['warehouse_name'] as String?,
      purchaseOrderId: (json['purchase_order_id'] as num?)?.toInt(),
      receivingHeaderId: (json['receiving_header_id'] as num?)?.toInt(),
      returnDate: json['return_date'] as String,
      status: json['status'] as String,
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

Map<String, dynamic> _$$ReturnToVendorImplToJson(_$ReturnToVendorImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rtv_number': instance.rtvNumber,
      'company_id': instance.companyId,
      'company_name': instance.companyName,
      'supplier_id': instance.supplierId,
      'supplier_name': instance.supplierName,
      'warehouse_id': instance.warehouseId,
      'warehouse_name': instance.warehouseName,
      'purchase_order_id': instance.purchaseOrderId,
      'receiving_header_id': instance.receivingHeaderId,
      'return_date': instance.returnDate,
      'status': instance.status,
      'total_amount': instance.totalAmount,
      'reason': instance.reason,
      'notes': instance.notes,
      'created_by': instance.createdBy,
      'created_by_name': instance.createdByName,
      'shipped_at': instance.shippedAt,
      'details': instance.details,
    };

_$ReturnToVendorDetailImpl _$$ReturnToVendorDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$ReturnToVendorDetailImpl(
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

Map<String, dynamic> _$$ReturnToVendorDetailImplToJson(
        _$ReturnToVendorDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'return_to_vendor_id': instance.returnToVendorId,
      'item_id': instance.itemId,
      'item_name': instance.itemName,
      'item_code': instance.itemCode,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'subtotal': instance.subtotal,
      'reason': instance.reason,
      'condition': instance.condition,
    };
