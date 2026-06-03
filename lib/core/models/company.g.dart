// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompanyImpl _$$CompanyImplFromJson(Map<String, dynamic> json) =>
    _$CompanyImpl(
      id: (json['id'] as num).toInt(),
      companyName: json['company_name'] as String,
      companyCode: json['company_code'] as String,
    );

Map<String, dynamic> _$$CompanyImplToJson(_$CompanyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_name': instance.companyName,
      'company_code': instance.companyCode,
    };
