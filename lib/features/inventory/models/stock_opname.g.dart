// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_opname.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StockOpnameImpl _$$StockOpnameImplFromJson(Map<String, dynamic> json) =>
    _$StockOpnameImpl(
      id: (json['id'] as num).toInt(),
      companyId: (json['company_id'] as num).toInt(),
      opnameNumber: json['opname_number'] as String,
      warehouseId: (json['warehouse_id'] as num).toInt(),
      warehouseName: json['warehouse_name'] as String?,
      companyName: json['company_name'] as String?,
      status: json['status'] as String,
      startedAt: json['started_at'] as String?,
      completedAt: json['completed_at'] as String?,
      createdBy: (json['created_by'] as num?)?.toInt(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$StockOpnameImplToJson(_$StockOpnameImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_id': instance.companyId,
      'opname_number': instance.opnameNumber,
      'warehouse_id': instance.warehouseId,
      'warehouse_name': instance.warehouseName,
      'company_name': instance.companyName,
      'status': instance.status,
      'started_at': instance.startedAt,
      'completed_at': instance.completedAt,
      'created_by': instance.createdBy,
      'notes': instance.notes,
    };

_$StockOpnameItemImpl _$$StockOpnameItemImplFromJson(
        Map<String, dynamic> json) =>
    _$StockOpnameItemImpl(
      sku: json['sku'] as String,
      productName: json['product_name'] as String,
      productUnit: json['product_unit'] as String? ?? 'pcs',
      systemQty: doubleFromJson(json['system_qty']),
      countedQty: doubleFromJson(json['counted_qty']),
      discrepancy: doubleFromJson(json['discrepancy']),
    );

Map<String, dynamic> _$$StockOpnameItemImplToJson(
        _$StockOpnameItemImpl instance) =>
    <String, dynamic>{
      'sku': instance.sku,
      'product_name': instance.productName,
      'product_unit': instance.productUnit,
      'system_qty': instance.systemQty,
      'counted_qty': instance.countedQty,
      'discrepancy': instance.discrepancy,
    };
