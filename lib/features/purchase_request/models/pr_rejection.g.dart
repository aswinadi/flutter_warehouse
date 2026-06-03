// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pr_rejection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RejectRequestImpl _$$RejectRequestImplFromJson(Map<String, dynamic> json) =>
    _$RejectRequestImpl(
      reason: json['reason'] as String,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$RejectRequestImplToJson(_$RejectRequestImpl instance) =>
    <String, dynamic>{
      'reason': instance.reason,
      'notes': instance.notes,
    };
