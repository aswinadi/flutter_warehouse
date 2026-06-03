import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_utils.dart';

part 'invoice.freezed.dart';
part 'invoice.g.dart';

@freezed
class Invoice with _$Invoice {
  const factory Invoice({
    required int id,
    @JsonKey(name: 'invoice_number') required String invoiceNumber,
    @JsonKey(name: 'vendor_invoice_number') String? vendorInvoiceNumber,
    @JsonKey(name: 'invoice_date') required String invoiceDate,
    @JsonKey(name: 'due_date') String? dueDate,
    @JsonKey(fromJson: doubleFromJson) required double subtotal,
    @JsonKey(name: 'tax_amount', fromJson: doubleFromJson) required double taxAmount,
    @JsonKey(name: 'discount_amount', fromJson: doubleFromJson) required double discountAmount,
    @JsonKey(name: 'total_amount', fromJson: doubleFromJson) required double totalAmount,
    required String currency,
    String? description,
    String? notes,
    required String status,
    @JsonKey(name: 'company_id') required int companyId,
    @JsonKey(name: 'supplier_id') int? supplierId,
    @JsonKey(name: 'supplier_name') String? supplierName,
    @JsonKey(name: 'receiving_number') String? receivingNumber,
    @JsonKey(name: 'can_approve') @Default(false) bool canApprove,
    @JsonKey(name: 'pdf_url') String? pdfUrl,
    @Default([]) List<InvoiceItem> items,
    @Default([]) List<MediaFile> media,
  }) = _Invoice;

  factory Invoice.fromJson(Map<String, dynamic> json) => _$InvoiceFromJson(json);
}

@freezed
class InvoiceItem with _$InvoiceItem {
  const factory InvoiceItem({
    required int id,
    @JsonKey(name: 'invoice_id') required int invoiceId,
    @JsonKey(name: 'product_id') int? productId,
    @JsonKey(name: 'product_code') required String productCode,
    @JsonKey(name: 'product_name') required String productName,
    String? description,
    @JsonKey(fromJson: doubleFromJson) required double quantity,
    required String unit,
    @JsonKey(name: 'unit_price', fromJson: doubleFromJson) required double unitPrice,
    @JsonKey(fromJson: doubleFromJson) required double discount,
    @JsonKey(name: 'tax_rate', fromJson: doubleFromJson) required double taxRate,
    @JsonKey(name: 'tax_amount', fromJson: doubleFromJson) required double taxAmount,
    @JsonKey(fromJson: doubleFromJson) required double subtotal,
  }) = _InvoiceItem;

  factory InvoiceItem.fromJson(Map<String, dynamic> json) => _$InvoiceItemFromJson(json);
}

@freezed
class MediaFile with _$MediaFile {
  const factory MediaFile({
    required int id,
    required String name,
    @JsonKey(name: 'file_name') required String fileName,
    @JsonKey(name: 'mime_type') required String mimeType,
    @JsonKey(name: 'original_url') required String originalUrl,
  }) = _MediaFile;

  factory MediaFile.fromJson(Map<String, dynamic> json) => _$MediaFileFromJson(json);
}
