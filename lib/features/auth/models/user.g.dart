// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
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
          const [
            'view_dashboard',
            'view_pr',
            'view_po',
            'view_receiving',
            'view_inventory',
            'view_usage'
          ],
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'photoUrl': instance.photoUrl,
      'company_id': instance.companyId,
      'approval_types': instance.approvalTypes,
      'roles': instance.roles,
      'permissions': instance.permissions,
    };
