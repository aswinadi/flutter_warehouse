// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pr_approval.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApproveRequestImpl _$$ApproveRequestImplFromJson(Map<String, dynamic> json) =>
    _$ApproveRequestImpl(
      notes: json['notes'] as String?,
      selectedItemIds: (json['selected_item_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      details: (json['details'] as List<dynamic>?)
          ?.map((e) => ApproveRequestDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ApproveRequestImplToJson(
        _$ApproveRequestImpl instance) =>
    <String, dynamic>{
      'notes': instance.notes,
      'selected_item_ids': instance.selectedItemIds,
      'details': instance.details,
    };

_$ApproveRequestDetailImpl _$$ApproveRequestDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$ApproveRequestDetailImpl(
      id: (json['id'] as num).toInt(),
      approvedQty: (json['approved_qty'] as num).toDouble(),
      approvalNotes: json['approval_notes'] as String?,
    );

Map<String, dynamic> _$$ApproveRequestDetailImplToJson(
        _$ApproveRequestDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'approved_qty': instance.approvedQty,
      'approval_notes': instance.approvalNotes,
    };
