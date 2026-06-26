// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PurchaseOrderImpl _$$PurchaseOrderImplFromJson(Map<String, dynamic> json) =>
    _$PurchaseOrderImpl(
      id: (json['id'] as num).toInt(),
      poNumber: json['po_number'] as String,
      companyId: (json['company_id'] as num).toInt(),
      warehouseId: (json['warehouse_id'] as num).toInt(),
      warehouseName: json['warehouse_name'] as String?,
      supplierId: (json['supplier_id'] as num?)?.toInt(),
      supplierName: json['supplier_name'] as String,
      transactionDate: json['transaction_date'] as String,
      expectedDate: json['expected_date'] as String,
      paymentTerm: json['payment_term'] as String?,
      status: json['status'] as String,
      totalItems: (json['total_items'] as num?)?.toInt() ?? 0,
      receivedItems: (json['received_items'] as num?)?.toInt() ?? 0,
      canApprove: json['can_approve'] as bool? ?? false,
      pdfUrl: json['pdf_url'] as String?,
      totalAmount: doubleOrNullFromJson(json['total_amount']),
      items: (json['items'] as List<dynamic>?)
              ?.map(
                  (e) => PurchaseOrderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PurchaseOrderImplToJson(_$PurchaseOrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'po_number': instance.poNumber,
      'company_id': instance.companyId,
      'warehouse_id': instance.warehouseId,
      'warehouse_name': instance.warehouseName,
      'supplier_id': instance.supplierId,
      'supplier_name': instance.supplierName,
      'transaction_date': instance.transactionDate,
      'expected_date': instance.expectedDate,
      'payment_term': instance.paymentTerm,
      'status': instance.status,
      'total_items': instance.totalItems,
      'received_items': instance.receivedItems,
      'can_approve': instance.canApprove,
      'pdf_url': instance.pdfUrl,
      'total_amount': instance.totalAmount,
      'items': instance.items,
    };

_$PurchaseOrderItemImpl _$$PurchaseOrderItemImplFromJson(
        Map<String, dynamic> json) =>
    _$PurchaseOrderItemImpl(
      id: (json['id'] as num).toInt(),
      sku: json['sku'] as String,
      productName: json['product_name'] as String,
      orderedQty: doubleFromJson(json['ordered_qty']),
      receivedQty: doubleFromJson(json['received_qty']),
      remainingQty: doubleFromJson(json['remaining_qty']),
      unit: json['unit'] as String,
      imageUrl: json['image_url'] as String?,
      unitPrice: doubleOrNullFromJson(json['unit_price']),
      detailNotes: json['detail_notes'] as String?,
      detailSpec: json['detail_spec'] as String?,
      warehouseCode: json['warehouse_code'] as String?,
      warehouseName: json['warehouse_name'] as String?,
      version: (json['version'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PurchaseOrderItemImplToJson(
        _$PurchaseOrderItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'product_name': instance.productName,
      'ordered_qty': instance.orderedQty,
      'received_qty': instance.receivedQty,
      'remaining_qty': instance.remainingQty,
      'unit': instance.unit,
      'image_url': instance.imageUrl,
      'unit_price': instance.unitPrice,
      'detail_notes': instance.detailNotes,
      'detail_spec': instance.detailSpec,
      'warehouse_code': instance.warehouseCode,
      'warehouse_name': instance.warehouseName,
      'version': instance.version,
    };
