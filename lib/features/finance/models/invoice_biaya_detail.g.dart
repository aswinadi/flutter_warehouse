// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_biaya_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InvoiceBiayaDetailImpl _$$InvoiceBiayaDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$InvoiceBiayaDetailImpl(
      id: (json['id'] as num?)?.toInt(),
      invoiceBiayaId: (json['invoice_biaya_id'] as num?)?.toInt(),
      coaCode: json['coa_code'] as String,
      coaName: json['coa_name'] as String?,
      projectCode: json['project_code'] as String?,
      costCode: json['cost_code'] as String?,
      debit: json['debit'] == null ? 0.0 : doubleFromJson(json['debit']),
      credit: json['credit'] == null ? 0.0 : doubleFromJson(json['credit']),
      staffName: json['staff_name'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$InvoiceBiayaDetailImplToJson(
        _$InvoiceBiayaDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'invoice_biaya_id': instance.invoiceBiayaId,
      'coa_code': instance.coaCode,
      'coa_name': instance.coaName,
      'project_code': instance.projectCode,
      'cost_code': instance.costCode,
      'debit': instance.debit,
      'credit': instance.credit,
      'staff_name': instance.staffName,
      'notes': instance.notes,
    };
