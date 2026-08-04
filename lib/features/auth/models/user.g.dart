// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      username: json['username'] as String?,
      employeeCode: json['employee_id'] as String?,
      positionName: json['position_name'] as String?,
      photoUrl: json['photoUrl'] as String?,
      signatureUrl: json['signature_url'] as String?,
      companyId: (json['company_id'] as num?)?.toInt(),
      approvalTypes: (json['approval_types'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'username': instance.username,
      'employee_id': instance.employeeCode,
      'position_name': instance.positionName,
      'photoUrl': instance.photoUrl,
      'signature_url': instance.signatureUrl,
      'company_id': instance.companyId,
      'approval_types': instance.approvalTypes,
      'roles': instance.roles,
      'permissions': instance.permissions,
    };
