// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_biaya.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InvoiceBiayaImpl _$$InvoiceBiayaImplFromJson(Map<String, dynamic> json) =>
    _$InvoiceBiayaImpl(
      id: (json['id'] as num).toInt(),
      companyId: (json['company_id'] as num).toInt(),
      supplierId: (json['supplier_id'] as num?)?.toInt(),
      supplierCode: json['supplier_code'] as String?,
      supplierName: json['supplier_name'] as String?,
      invoiceNumber: json['invoice_number'] as String,
      vendorInvoiceNumber: json['vendor_invoice_number'] as String?,
      invoiceDate: json['invoice_date'] as String,
      dueDate: json['due_date'] as String?,
      amount: doubleFromJson(json['amount']),
      taxAmount: doubleFromJson(json['tax_amount']),
      totalAmount: doubleFromJson(json['total_amount']),
      currency: json['currency'] as String,
      notes: json['notes'] as String?,
      status: json['status'] as String,
      createdBy: (json['created_by'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      media: (json['media'] as List<dynamic>?)
              ?.map((e) => MediaFile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$InvoiceBiayaImplToJson(_$InvoiceBiayaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_id': instance.companyId,
      'supplier_id': instance.supplierId,
      'supplier_code': instance.supplierCode,
      'supplier_name': instance.supplierName,
      'invoice_number': instance.invoiceNumber,
      'vendor_invoice_number': instance.vendorInvoiceNumber,
      'invoice_date': instance.invoiceDate,
      'due_date': instance.dueDate,
      'amount': instance.amount,
      'tax_amount': instance.taxAmount,
      'total_amount': instance.totalAmount,
      'currency': instance.currency,
      'notes': instance.notes,
      'status': instance.status,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt,
      'media': instance.media,
    };
