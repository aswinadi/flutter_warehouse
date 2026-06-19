// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentRequestImpl _$$PaymentRequestImplFromJson(Map<String, dynamic> json) =>
    _$PaymentRequestImpl(
      id: (json['id'] as num).toInt(),
      requestNumber: json['request_number'] as String,
      requestDate: json['request_date'] as String,
      requestorName: json['requestor_name'] as String,
      totalAmount: doubleFromJson(json['total_amount']),
      currency: json['currency'] as String,
      status: json['status'] as String,
      description: json['description'] as String?,
      companyId: (json['company_id'] as num).toInt(),
      canApprove: json['can_approve'] as bool? ?? false,
      pdfUrl: json['pdf_url'] as String?,
      supplierNames: json['supplier_names'] as String?,
      dueDate: json['due_date'] as String?,
      invoices: (json['invoices'] as List<dynamic>?)
              ?.map((e) =>
                  PaymentRequestInvoice.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PaymentRequestImplToJson(
        _$PaymentRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'request_number': instance.requestNumber,
      'request_date': instance.requestDate,
      'requestor_name': instance.requestorName,
      'total_amount': instance.totalAmount,
      'currency': instance.currency,
      'status': instance.status,
      'description': instance.description,
      'company_id': instance.companyId,
      'can_approve': instance.canApprove,
      'pdf_url': instance.pdfUrl,
      'supplier_names': instance.supplierNames,
      'due_date': instance.dueDate,
      'invoices': instance.invoices,
    };

_$PaymentRequestInvoiceImpl _$$PaymentRequestInvoiceImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentRequestInvoiceImpl(
      id: (json['id'] as num).toInt(),
      paymentRequestId: (json['payment_request_id'] as num).toInt(),
      type: json['type'] as String,
      invoiceNumber: json['invoice_number'] as String,
      invoiceDate: json['invoice_date'] as String,
      dueDate: json['due_date'] as String?,
      supplierName: json['supplier_name'] as String?,
      amount: doubleFromJson(json['amount']),
      taxAmount: doubleFromJson(json['tax_amount']),
      paidAmount: doubleFromJson(json['paid_amount']),
      paymentStatus: json['payment_status'] as String,
      description: json['description'] as String?,
      supplier: json['supplier'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PaymentRequestInvoiceImplToJson(
        _$PaymentRequestInvoiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'payment_request_id': instance.paymentRequestId,
      'type': instance.type,
      'invoice_number': instance.invoiceNumber,
      'invoice_date': instance.invoiceDate,
      'due_date': instance.dueDate,
      'supplier_name': instance.supplierName,
      'amount': instance.amount,
      'tax_amount': instance.taxAmount,
      'paid_amount': instance.paidAmount,
      'payment_status': instance.paymentStatus,
      'description': instance.description,
      'supplier': instance.supplier,
    };

_$AvailableInvoiceImpl _$$AvailableInvoiceImplFromJson(
        Map<String, dynamic> json) =>
    _$AvailableInvoiceImpl(
      id: (json['id'] as num).toInt(),
      invoiceNumber: json['invoice_number'] as String,
      invoiceDate: json['invoice_date'] as String,
      dueDate: json['due_date'] as String?,
      supplierId: (json['supplier_id'] as num?)?.toInt(),
      supplierName: json['supplier_name'] as String,
      amount: doubleFromJson(json['amount']),
      type: json['type'] as String,
    );

Map<String, dynamic> _$$AvailableInvoiceImplToJson(
        _$AvailableInvoiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'invoice_number': instance.invoiceNumber,
      'invoice_date': instance.invoiceDate,
      'due_date': instance.dueDate,
      'supplier_id': instance.supplierId,
      'supplier_name': instance.supplierName,
      'amount': instance.amount,
      'type': instance.type,
    };
