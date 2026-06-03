// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventoryImpl _$$InventoryImplFromJson(Map<String, dynamic> json) =>
    _$InventoryImpl(
      id: (json['id'] as num).toInt(),
      barcodeCode: json['barcode_code'] as String?,
      sku: json['sku'] as String,
      productName: json['product_name'] as String?,
      quantity: (json['quantity'] as num).toDouble(),
      status: json['status'] as String,
      warehouseName: json['warehouse_name'] as String?,
      locationCode: json['location_code'] as String?,
      unit: json['unit'] as String?,
    );

Map<String, dynamic> _$$InventoryImplToJson(_$InventoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'barcode_code': instance.barcodeCode,
      'sku': instance.sku,
      'product_name': instance.productName,
      'quantity': instance.quantity,
      'status': instance.status,
      'warehouse_name': instance.warehouseName,
      'location_code': instance.locationCode,
      'unit': instance.unit,
    };
