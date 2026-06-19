import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_utils.dart';

part 'payment_request.freezed.dart';
part 'payment_request.g.dart';

@freezed
class PaymentRequest with _$PaymentRequest {
  const factory PaymentRequest({
    required int id,
    @JsonKey(name: 'request_number') required String requestNumber,
    @JsonKey(name: 'request_date') required String requestDate,
    @JsonKey(name: 'requestor_name') required String requestorName,
    @JsonKey(name: 'total_amount', fromJson: doubleFromJson) required double totalAmount,
    required String currency,
    required String status,
    String? description,
    @JsonKey(name: 'company_id') required int companyId,
    @JsonKey(name: 'can_approve') @Default(false) bool canApprove,
    @JsonKey(name: 'pdf_url') String? pdfUrl,
    @JsonKey(name: 'supplier_names') String? supplierNames,
    @JsonKey(name: 'due_date') String? dueDate,
    @Default([]) List<PaymentRequestInvoice> invoices,
  }) = _PaymentRequest;

  factory PaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentRequestFromJson(json);
}

@freezed
class PaymentRequestInvoice with _$PaymentRequestInvoice {
  const factory PaymentRequestInvoice({
    required int id,
    @JsonKey(name: 'payment_request_id') required int paymentRequestId,
    required String type,
    @JsonKey(name: 'invoice_number') required String invoiceNumber,
    @JsonKey(name: 'invoice_date') required String invoiceDate,
    @JsonKey(name: 'due_date') String? dueDate,
    @JsonKey(name: 'supplier_name') String? supplierName,
    @JsonKey(fromJson: doubleFromJson) required double amount,
    @JsonKey(name: 'tax_amount', fromJson: doubleFromJson) required double taxAmount,
    @JsonKey(name: 'paid_amount', fromJson: doubleFromJson) required double paidAmount,
    @JsonKey(name: 'payment_status') required String paymentStatus,
    String? description,
  }) = _PaymentRequestInvoice;

  factory PaymentRequestInvoice.fromJson(Map<String, dynamic> json) =>
      _$PaymentRequestInvoiceFromJson(json);
}

@freezed
class AvailableInvoice with _$AvailableInvoice {
  const factory AvailableInvoice({
    required int id,
    @JsonKey(name: 'invoice_number') required String invoiceNumber,
    @JsonKey(name: 'invoice_date') required String invoiceDate,
    @JsonKey(name: 'due_date') String? dueDate,
    @JsonKey(name: 'supplier_id') int? supplierId,
    @JsonKey(name: 'supplier_name') required String supplierName,
    @JsonKey(fromJson: doubleFromJson) required double amount,
    required String type, // 'supplier' | 'biaya' | 'landed_cost'
  }) = _AvailableInvoice;

  factory AvailableInvoice.fromJson(Map<String, dynamic> json) =>
      _$AvailableInvoiceFromJson(json);

  factory AvailableInvoice.fromSupplierInvoice(Map<String, dynamic> json) {
    return AvailableInvoice(
      id: json['id'] as int,
      invoiceNumber: json['invoice_number'] as String,
      invoiceDate: json['invoice_date'] as String,
      dueDate: json['due_date'] as String?,
      supplierId: json['supplier_id'] as int?,
      supplierName: json['supplier_name'] as String? ?? (json['supplier']?['name'] as String? ?? 'Unknown'),
      amount: doubleFromJson(json['total_amount']),
      type: 'supplier',
    );
  }

  factory AvailableInvoice.fromBiayaInvoice(Map<String, dynamic> json) {
    return AvailableInvoice(
      id: json['id'] as int,
      invoiceNumber: json['invoice_number'] as String,
      invoiceDate: json['invoice_date'] as String,
      dueDate: json['due_date'] as String?,
      supplierId: json['supplier_id'] as int?,
      supplierName: json['supplier_name'] as String? ?? (json['supplier']?['name'] as String? ?? 'Unknown'),
      amount: doubleFromJson(json['total_amount']),
      type: 'biaya',
    );
  }

  factory AvailableInvoice.fromLandedCost(Map<String, dynamic> json) {
    return AvailableInvoice(
      id: json['id'] as int,
      invoiceNumber: json['reference_number'] as String,
      invoiceDate: json['posting_date'] as String,
      dueDate: json['posting_date'] as String?,
      supplierId: null,
      supplierName: json['supplier_name'] as String? ?? 'Unknown',
      amount: doubleFromJson(json['total_amount']),
      type: 'landed_cost',
    );
  }
}

