// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WarehouseAreaImpl _$$WarehouseAreaImplFromJson(Map<String, dynamic> json) =>
    _$WarehouseAreaImpl(
      id: (json['id'] as num).toInt(),
      warehouseId: (json['warehouse_id'] as num?)?.toInt(),
      name: json['name'] as String,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$WarehouseAreaImplToJson(_$WarehouseAreaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'warehouse_id': instance.warehouseId,
      'name': instance.name,
      'is_active': instance.isActive,
    };

_$WarehouseImpl _$$WarehouseImplFromJson(Map<String, dynamic> json) =>
    _$WarehouseImpl(
      id: (json['id'] as num).toInt(),
      companyId: (json['company_id'] as num).toInt(),
      code: json['code'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      isActive: json['is_active'] as bool,
      areas: (json['areas'] as List<dynamic>?)
              ?.map((e) => WarehouseArea.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$WarehouseImplToJson(_$WarehouseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_id': instance.companyId,
      'code': instance.code,
      'name': instance.name,
      'address': instance.address,
      'is_active': instance.isActive,
      'areas': instance.areas,
    };
