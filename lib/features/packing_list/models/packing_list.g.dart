// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packing_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PackingListImpl _$$PackingListImplFromJson(Map<String, dynamic> json) =>
    _$PackingListImpl(
      id: (json['id'] as num).toInt(),
      containerNumber: json['container_number'] as String,
      carrierName: json['carrier_name'] as String?,
      plateNumber: json['plate_number'] as String?,
      status: json['status'] as String,
      sourceWarehouseId: (json['source_warehouse_id'] as num?)?.toInt(),
      sourceWarehouseName: json['source_warehouse_name'] as String?,
      destinationWarehouseId:
          (json['destination_warehouse_id'] as num?)?.toInt(),
      destinationWarehouseName: json['destination_warehouse_name'] as String?,
      supplierId: (json['supplier_id'] as num?)?.toInt(),
      supplierName: json['supplier_name'] as String?,
      itemCount: (json['item_count'] as num?)?.toInt() ?? 0,
      estimatedDeparture: json['estimated_departure'] == null
          ? null
          : DateTime.parse(json['estimated_departure'] as String),
      closingDate: json['closing_date'] == null
          ? null
          : DateTime.parse(json['closing_date'] as String),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => PackingListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PackingListImplToJson(_$PackingListImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'container_number': instance.containerNumber,
      'carrier_name': instance.carrierName,
      'plate_number': instance.plateNumber,
      'status': instance.status,
      'source_warehouse_id': instance.sourceWarehouseId,
      'source_warehouse_name': instance.sourceWarehouseName,
      'destination_warehouse_id': instance.destinationWarehouseId,
      'destination_warehouse_name': instance.destinationWarehouseName,
      'supplier_id': instance.supplierId,
      'supplier_name': instance.supplierName,
      'item_count': instance.itemCount,
      'estimated_departure': instance.estimatedDeparture?.toIso8601String(),
      'closing_date': instance.closingDate?.toIso8601String(),
      'items': instance.items,
    };

_$PackingListItemImpl _$$PackingListItemImplFromJson(
        Map<String, dynamic> json) =>
    _$PackingListItemImpl(
      type: json['type'] as String,
      poDetailId: (json['po_detail_id'] as num?)?.toInt(),
      inventoryId: (json['inventory_id'] as num?)?.toInt(),
      poHeaderId: (json['po_header_id'] as num?)?.toInt(),
      poNumber: json['po_number'] as String?,
      supplierName: json['supplier_name'] as String?,
      sku: json['sku'] as String,
      productName: json['product_name'] as String,
      plannedQty: doubleFromJson(json['planned_qty']),
      unit: json['unit'] as String,
    );

Map<String, dynamic> _$$PackingListItemImplToJson(
        _$PackingListItemImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'po_detail_id': instance.poDetailId,
      'inventory_id': instance.inventoryId,
      'po_header_id': instance.poHeaderId,
      'po_number': instance.poNumber,
      'supplier_name': instance.supplierName,
      'sku': instance.sku,
      'product_name': instance.productName,
      'planned_qty': instance.plannedQty,
      'unit': instance.unit,
    };
