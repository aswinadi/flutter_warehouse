// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WarehouseImpl _$$WarehouseImplFromJson(Map<String, dynamic> json) =>
    _$WarehouseImpl(
      id: (json['id'] as num).toInt(),
      companyId: (json['company_id'] as num).toInt(),
      code: json['code'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      isActive: json['is_active'] as bool,
    );

Map<String, dynamic> _$$WarehouseImplToJson(_$WarehouseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_id': instance.companyId,
      'code': instance.code,
      'name': instance.name,
      'address': instance.address,
      'is_active': instance.isActive,
    };
