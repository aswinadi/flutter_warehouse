// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InvoiceImpl _$$InvoiceImplFromJson(Map<String, dynamic> json) =>
    _$InvoiceImpl(
      id: (json['id'] as num).toInt(),
      invoiceNumber: json['invoice_number'] as String,
      vendorInvoiceNumber: json['vendor_invoice_number'] as String?,
      invoiceDate: json['invoice_date'] as String,
      dueDate: json['due_date'] as String?,
      subtotal: doubleFromJson(json['subtotal']),
      taxAmount: doubleFromJson(json['tax_amount']),
      discountAmount: doubleFromJson(json['discount_amount']),
      totalAmount: doubleFromJson(json['total_amount']),
      currency: json['currency'] as String,
      description: json['description'] as String?,
      notes: json['notes'] as String?,
      status: json['status'] as String,
      companyId: (json['company_id'] as num).toInt(),
      supplierId: (json['supplier_id'] as num?)?.toInt(),
      supplierName: json['supplier_name'] as String?,
      receivingNumber: json['receiving_number'] as String?,
      canApprove: json['can_approve'] as bool? ?? false,
      pdfUrl: json['pdf_url'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => InvoiceItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      media: (json['media'] as List<dynamic>?)
              ?.map((e) => MediaFile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$InvoiceImplToJson(_$InvoiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'invoice_number': instance.invoiceNumber,
      'vendor_invoice_number': instance.vendorInvoiceNumber,
      'invoice_date': instance.invoiceDate,
      'due_date': instance.dueDate,
      'subtotal': instance.subtotal,
      'tax_amount': instance.taxAmount,
      'discount_amount': instance.discountAmount,
      'total_amount': instance.totalAmount,
      'currency': instance.currency,
      'description': instance.description,
      'notes': instance.notes,
      'status': instance.status,
      'company_id': instance.companyId,
      'supplier_id': instance.supplierId,
      'supplier_name': instance.supplierName,
      'receiving_number': instance.receivingNumber,
      'can_approve': instance.canApprove,
      'pdf_url': instance.pdfUrl,
      'items': instance.items,
      'media': instance.media,
    };

_$InvoiceItemImpl _$$InvoiceItemImplFromJson(Map<String, dynamic> json) =>
    _$InvoiceItemImpl(
      id: (json['id'] as num).toInt(),
      invoiceId: (json['invoice_id'] as num).toInt(),
      productId: (json['product_id'] as num?)?.toInt(),
      productCode: json['product_code'] as String,
      productName: json['product_name'] as String,
      description: json['description'] as String?,
      quantity: doubleFromJson(json['quantity']),
      unit: json['unit'] as String,
      unitPrice: doubleFromJson(json['unit_price']),
      discount: doubleFromJson(json['discount']),
      taxRate: doubleFromJson(json['tax_rate']),
      taxAmount: doubleFromJson(json['tax_amount']),
      subtotal: doubleFromJson(json['subtotal']),
    );

Map<String, dynamic> _$$InvoiceItemImplToJson(_$InvoiceItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'invoice_id': instance.invoiceId,
      'product_id': instance.productId,
      'product_code': instance.productCode,
      'product_name': instance.productName,
      'description': instance.description,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'unit_price': instance.unitPrice,
      'discount': instance.discount,
      'tax_rate': instance.taxRate,
      'tax_amount': instance.taxAmount,
      'subtotal': instance.subtotal,
    };

_$MediaFileImpl _$$MediaFileImplFromJson(Map<String, dynamic> json) =>
    _$MediaFileImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      fileName: json['file_name'] as String,
      mimeType: json['mime_type'] as String,
      originalUrl: json['original_url'] as String,
    );

Map<String, dynamic> _$$MediaFileImplToJson(_$MediaFileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'file_name': instance.fileName,
      'mime_type': instance.mimeType,
      'original_url': instance.originalUrl,
    };
