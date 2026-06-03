// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AquacultureCycleImpl _$$AquacultureCycleImplFromJson(
        Map<String, dynamic> json) =>
    _$AquacultureCycleImpl(
      id: (json['id'] as num).toInt(),
      companyId: (json['company_id'] as num).toInt(),
      name: json['name'] as String,
      stockingDate: json['stocking_date'] as String?,
      isActive: json['is_active'] as bool,
    );

Map<String, dynamic> _$$AquacultureCycleImplToJson(
        _$AquacultureCycleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_id': instance.companyId,
      'name': instance.name,
      'stocking_date': instance.stockingDate,
      'is_active': instance.isActive,
    };

_$AquaculturePondImpl _$$AquaculturePondImplFromJson(
        Map<String, dynamic> json) =>
    _$AquaculturePondImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      code: json['code'] as String?,
      length: (json['length'] as num?)?.toDouble(),
      width: (json['width'] as num?)?.toDouble(),
      depth: (json['depth'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$AquaculturePondImplToJson(
        _$AquaculturePondImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'length': instance.length,
      'width': instance.width,
      'depth': instance.depth,
    };

_$FeedLogImpl _$$FeedLogImplFromJson(Map<String, dynamic> json) =>
    _$FeedLogImpl(
      id: (json['id'] as num).toInt(),
      cycleId: (json['cycle_id'] as num).toInt(),
      cycleName: json['cycle_name'] as String?,
      pondId: (json['pond_id'] as num).toInt(),
      pondName: json['pond_name'] as String?,
      date: json['date'] as String,
      feedCode: json['feed_code'] as String?,
      amountKg: (json['amount_kg'] as num).toDouble(),
      doc: (json['doc'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$FeedLogImplToJson(_$FeedLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cycle_id': instance.cycleId,
      'cycle_name': instance.cycleName,
      'pond_id': instance.pondId,
      'pond_name': instance.pondName,
      'date': instance.date,
      'feed_code': instance.feedCode,
      'amount_kg': instance.amountKg,
      'doc': instance.doc,
      'notes': instance.notes,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
