// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_of_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChartOfAccountImpl _$$ChartOfAccountImplFromJson(Map<String, dynamic> json) =>
    _$ChartOfAccountImpl(
      id: (json['id'] as num).toInt(),
      companyId: (json['company_id'] as num).toInt(),
      coaCode: json['coa_code'] as String,
      coaName: json['coa_name'] as String,
      parentCode: json['parent_code'] as String?,
      isActive: json['is_active'] as bool,
    );

Map<String, dynamic> _$$ChartOfAccountImplToJson(
        _$ChartOfAccountImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_id': instance.companyId,
      'coa_code': instance.coaCode,
      'coa_name': instance.coaName,
      'parent_code': instance.parentCode,
      'is_active': instance.isActive,
    };
