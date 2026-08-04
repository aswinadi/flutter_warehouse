// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cost_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CostCodeImpl _$$CostCodeImplFromJson(Map<String, dynamic> json) =>
    _$CostCodeImpl(
      id: (json['id'] as num).toInt(),
      companyId: (json['company_id'] as num).toInt(),
      code: json['code'] as String,
      name: json['name'] as String,
      tipeCostName: json['tipe_cost_name'] as String?,
      groupName: json['group_name'] as String?,
      groupTipe: json['group_tipe'] as String?,
      codecoa: json['codecoa'] as String?,
      namecoa: json['namecoa'] as String?,
      isActive: json['is_active'] as bool,
    );

Map<String, dynamic> _$$CostCodeImplToJson(_$CostCodeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_id': instance.companyId,
      'code': instance.code,
      'name': instance.name,
      'tipe_cost_name': instance.tipeCostName,
      'group_name': instance.groupName,
      'group_tipe': instance.groupTipe,
      'codecoa': instance.codecoa,
      'namecoa': instance.namecoa,
      'is_active': instance.isActive,
    };
