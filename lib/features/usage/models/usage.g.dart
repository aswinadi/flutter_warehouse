// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PondImpl _$$PondImplFromJson(Map<String, dynamic> json) => _$PondImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      code: json['code'] as String?,
    );

Map<String, dynamic> _$$PondImplToJson(_$PondImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
    };

_$UsageRequestImpl _$$UsageRequestImplFromJson(Map<String, dynamic> json) =>
    _$UsageRequestImpl(
      pondId: (json['pond_id'] as num).toInt(),
      inventoryId: (json['inventory_id'] as num).toInt(),
      quantity: (json['quantity'] as num).toDouble(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$UsageRequestImplToJson(_$UsageRequestImpl instance) =>
    <String, dynamic>{
      'pond_id': instance.pondId,
      'inventory_id': instance.inventoryId,
      'quantity': instance.quantity,
      'notes': instance.notes,
    };
