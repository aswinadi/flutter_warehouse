// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cost_centre.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CostCentreImpl _$$CostCentreImplFromJson(Map<String, dynamic> json) =>
    _$CostCentreImpl(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String,
      name: json['name'] as String,
      parentCode: json['parent_code'] as String?,
      luasM2: doubleFromJson(json['luas_m2']),
      isActive: json['is_active'] as bool,
      isParent: json['is_parent'] as bool? ?? false,
    );

Map<String, dynamic> _$$CostCentreImplToJson(_$CostCentreImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'parent_code': instance.parentCode,
      'luas_m2': instance.luasM2,
      'is_active': instance.isActive,
      'is_parent': instance.isParent,
    };
