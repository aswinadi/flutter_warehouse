import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_utils.dart';
import '../../invoice/models/invoice.dart';

part 'invoice_biaya.freezed.dart';
part 'invoice_biaya.g.dart';

@freezed
class InvoiceBiaya with _$InvoiceBiaya {
  const factory InvoiceBiaya({
    required int id,
    @JsonKey(name: 'company_id') required int companyId,
    @JsonKey(name: 'supplier_id') int? supplierId,
    @JsonKey(name: 'supplier_code') String? supplierCode,
    @JsonKey(name: 'supplier_name') String? supplierName,
    @JsonKey(name: 'invoice_number') required String invoiceNumber,
    @JsonKey(name: 'vendor_invoice_number') String? vendorInvoiceNumber,
    @JsonKey(name: 'invoice_date') required String invoiceDate,
    @JsonKey(name: 'due_date') String? dueDate,
    @JsonKey(fromJson: doubleFromJson) required double amount,
    @JsonKey(name: 'tax_amount', fromJson: doubleFromJson) required double taxAmount,
    @JsonKey(name: 'total_amount', fromJson: doubleFromJson) required double totalAmount,
    required String currency,
    String? notes,
    required String status,
    @JsonKey(name: 'created_by') int? createdBy,
    @JsonKey(name: 'created_at') String? createdAt,
    @Default([]) List<MediaFile> media,
  }) = _InvoiceBiaya;

  factory InvoiceBiaya.fromJson(Map<String, dynamic> json) =>
      _$InvoiceBiayaFromJson(json);
}
