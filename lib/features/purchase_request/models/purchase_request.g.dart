// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PurchaseRequestImpl _$$PurchaseRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$PurchaseRequestImpl(
      id: (json['id'] as num).toInt(),
      companyId: (json['company_id'] as num?)?.toInt(),
      companyName: json['company_name'] as String?,
      code: json['code'] as String,
      requestDate: json['request_date'] as String,
      notes: json['notes'] as String?,
      requestByName: json['request_by_name'] as String?,
      status: json['status'] as String,
      canApprove: json['can_approve'] as bool? ?? false,
      approvedBy: json['approved_by'] as String?,
      approvedAt: json['approved_at'] as String?,
      details: (json['details'] as List<dynamic>?)
              ?.map((e) =>
                  PurchaseRequestItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      comparisons: (json['comparisons'] as List<dynamic>?)
              ?.map((e) =>
                  PurchaseRequestComparison.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      purchaseOrders: (json['purchase_orders'] as List<dynamic>?)
              ?.map((e) => PRAssociatedPO.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PurchaseRequestImplToJson(
        _$PurchaseRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_id': instance.companyId,
      'company_name': instance.companyName,
      'code': instance.code,
      'request_date': instance.requestDate,
      'notes': instance.notes,
      'request_by_name': instance.requestByName,
      'status': instance.status,
      'can_approve': instance.canApprove,
      'approved_by': instance.approvedBy,
      'approved_at': instance.approvedAt,
      'details': instance.details,
      'comparisons': instance.comparisons,
      'purchase_orders': instance.purchaseOrders,
    };

_$PurchaseRequestComparisonImpl _$$PurchaseRequestComparisonImplFromJson(
        Map<String, dynamic> json) =>
    _$PurchaseRequestComparisonImpl(
      id: (json['id'] as num).toInt(),
      supplierId: (json['supplier_id'] as num).toInt(),
      supplierName: json['supplier_name'] as String,
      totalAmount: doubleFromJson(json['total_amount']),
      leadTimeDays: (json['lead_time_days'] as num).toInt(),
      status: json['status'] as String?,
      notes: json['notes'] as String?,
      details: (json['details'] as List<dynamic>?)
              ?.map((e) => ComparisonDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PurchaseRequestComparisonImplToJson(
        _$PurchaseRequestComparisonImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'supplier_id': instance.supplierId,
      'supplier_name': instance.supplierName,
      'total_amount': instance.totalAmount,
      'lead_time_days': instance.leadTimeDays,
      'status': instance.status,
      'notes': instance.notes,
      'details': instance.details,
    };

_$ComparisonDetailImpl _$$ComparisonDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$ComparisonDetailImpl(
      id: (json['id'] as num).toInt(),
      purchaseRequestDetailId:
          (json['purchase_request_detail_id'] as num).toInt(),
      offeredUnitPrice: doubleFromJson(json['offered_unit_price']),
    );

Map<String, dynamic> _$$ComparisonDetailImplToJson(
        _$ComparisonDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'purchase_request_detail_id': instance.purchaseRequestDetailId,
      'offered_unit_price': instance.offeredUnitPrice,
    };

_$PurchaseRequestItemImpl _$$PurchaseRequestItemImplFromJson(
        Map<String, dynamic> json) =>
    _$PurchaseRequestItemImpl(
      id: (json['id'] as num).toInt(),
      itemName: json['item_name'] as String,
      itemCode: json['item_code'] as String,
      qtyRequested: doubleFromJson(json['qty_requested']),
      uom: json['uom_order'] as String,
      status: json['status'] as String?,
      currentStock: json['current_stock'] == null
          ? 0.0
          : doubleFromJson(json['current_stock']),
      dtNotes: json['dt_notes'] as String?,
      dtSpec: json['dt_spec'] as String?,
      costCode: json['cost_code'] as String?,
      canApprove: json['can_approve'] as bool? ?? false,
      prCode: json['pr_code'] as String?,
      companyName: json['company_name'] as String?,
      prId: (json['pr_id'] as num?)?.toInt(),
      approvedQty: doubleFromJson(json['approved_qty']),
      selectedComparisonId: (json['selected_comparison_id'] as num?)?.toInt(),
      warehouseCode: json['warehouse_code'] as String?,
      warehouseName: json['warehouse_name'] as String?,
      poNumber: json['po_number'] as String?,
    );

Map<String, dynamic> _$$PurchaseRequestItemImplToJson(
        _$PurchaseRequestItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'item_name': instance.itemName,
      'item_code': instance.itemCode,
      'qty_requested': instance.qtyRequested,
      'uom_order': instance.uom,
      'status': instance.status,
      'current_stock': instance.currentStock,
      'dt_notes': instance.dtNotes,
      'dt_spec': instance.dtSpec,
      'cost_code': instance.costCode,
      'can_approve': instance.canApprove,
      'pr_code': instance.prCode,
      'company_name': instance.companyName,
      'pr_id': instance.prId,
      'approved_qty': instance.approvedQty,
      'selected_comparison_id': instance.selectedComparisonId,
      'warehouse_code': instance.warehouseCode,
      'warehouse_name': instance.warehouseName,
      'po_number': instance.poNumber,
    };

_$PRAssociatedPOImpl _$$PRAssociatedPOImplFromJson(Map<String, dynamic> json) =>
    _$PRAssociatedPOImpl(
      id: (json['id'] as num).toInt(),
      poNumber: json['po_number'] as String,
      supplierName: json['supplier_name'] as String,
      pdfUrl: json['pdf_url'] as String?,
      status: json['status'] as String,
    );

Map<String, dynamic> _$$PRAssociatedPOImplToJson(
        _$PRAssociatedPOImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'po_number': instance.poNumber,
      'supplier_name': instance.supplierName,
      'pdf_url': instance.pdfUrl,
      'status': instance.status,
    };
