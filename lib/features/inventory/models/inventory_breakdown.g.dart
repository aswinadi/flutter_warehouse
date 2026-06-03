// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_breakdown.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventoryBreakdownImpl _$$InventoryBreakdownImplFromJson(
        Map<String, dynamic> json) =>
    _$InventoryBreakdownImpl(
      productName: json['product_name'] as String,
      sku: json['sku'] as String,
      unit: json['unit'] as String,
      onHand: (json['on_hand'] as List<dynamic>?)
              ?.map((e) => WarehouseOnHand.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      inTransit: (json['in_transit'] as List<dynamic>?)
              ?.map((e) => InTransitStock.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      ordered: (json['ordered'] as List<dynamic>?)
              ?.map((e) => OrderedStock.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$InventoryBreakdownImplToJson(
        _$InventoryBreakdownImpl instance) =>
    <String, dynamic>{
      'product_name': instance.productName,
      'sku': instance.sku,
      'unit': instance.unit,
      'on_hand': instance.onHand,
      'in_transit': instance.inTransit,
      'ordered': instance.ordered,
    };

_$WarehouseOnHandImpl _$$WarehouseOnHandImplFromJson(
        Map<String, dynamic> json) =>
    _$WarehouseOnHandImpl(
      warehouseId: (json['warehouse_id'] as num).toInt(),
      warehouseName: json['warehouse_name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      locations: (json['locations'] as List<dynamic>?)
              ?.map((e) => LocationOnHand.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$WarehouseOnHandImplToJson(
        _$WarehouseOnHandImpl instance) =>
    <String, dynamic>{
      'warehouse_id': instance.warehouseId,
      'warehouse_name': instance.warehouseName,
      'quantity': instance.quantity,
      'locations': instance.locations,
    };

_$LocationOnHandImpl _$$LocationOnHandImplFromJson(Map<String, dynamic> json) =>
    _$LocationOnHandImpl(
      locationId: (json['location_id'] as num?)?.toInt(),
      locationCode: json['location_code'] as String,
      quantity: (json['quantity'] as num).toDouble(),
    );

Map<String, dynamic> _$$LocationOnHandImplToJson(
        _$LocationOnHandImpl instance) =>
    <String, dynamic>{
      'location_id': instance.locationId,
      'location_code': instance.locationCode,
      'quantity': instance.quantity,
    };

_$InTransitStockImpl _$$InTransitStockImplFromJson(Map<String, dynamic> json) =>
    _$InTransitStockImpl(
      transferNumber: json['transfer_number'] as String,
      sourceWarehouseName: json['source_warehouse_name'] as String,
      destinationWarehouseName: json['destination_warehouse_name'] as String,
      destinationWarehouseId: (json['destination_warehouse_id'] as num).toInt(),
      quantity: (json['quantity'] as num).toDouble(),
    );

Map<String, dynamic> _$$InTransitStockImplToJson(
        _$InTransitStockImpl instance) =>
    <String, dynamic>{
      'transfer_number': instance.transferNumber,
      'source_warehouse_name': instance.sourceWarehouseName,
      'destination_warehouse_name': instance.destinationWarehouseName,
      'destination_warehouse_id': instance.destinationWarehouseId,
      'quantity': instance.quantity,
    };

_$OrderedStockImpl _$$OrderedStockImplFromJson(Map<String, dynamic> json) =>
    _$OrderedStockImpl(
      poNumber: json['po_number'] as String,
      warehouseName: json['warehouse_name'] as String,
      warehouseId: (json['warehouse_id'] as num).toInt(),
      quantity: (json['quantity'] as num).toDouble(),
    );

Map<String, dynamic> _$$OrderedStockImplToJson(_$OrderedStockImpl instance) =>
    <String, dynamic>{
      'po_number': instance.poNumber,
      'warehouse_name': instance.warehouseName,
      'warehouse_id': instance.warehouseId,
      'quantity': instance.quantity,
    };
