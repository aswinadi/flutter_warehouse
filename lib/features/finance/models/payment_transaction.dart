import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_utils.dart';

part 'payment_transaction.freezed.dart';
part 'payment_transaction.g.dart';

@freezed
class PaymentTransaction with _$PaymentTransaction {
  const factory PaymentTransaction({
    required int id,
    @JsonKey(name: 'company_id') required int companyId,
    @JsonKey(name: 'company_name') String? companyName,
    @JsonKey(name: 'supplier_id') required int supplierId,
    @JsonKey(name: 'supplier_name') String? supplierName,
    @JsonKey(name: 'company_bank_account_id') int? companyBankAccountId,
    @JsonKey(name: 'payment_request_id') int? paymentRequestId,
    @JsonKey(name: 'transaction_number') required String transactionNumber,
    @JsonKey(name: 'transaction_date') required String transactionDate,
    @JsonKey(name: 'total_amount', fromJson: doubleFromJson) required double totalAmount,
    @JsonKey(name: 'bank_name') String? bankName,
    @JsonKey(name: 'bank_account') String? bankAccount,
    @JsonKey(name: 'transfer_reference') String? transferReference,
    @JsonKey(name: 'receipt_path') String? receiptPath,
    @JsonKey(name: 'receipt_url') String? receiptUrl,
    @JsonKey(name: 'supplier_bank_name') String? supplierBankName,
    @JsonKey(name: 'supplier_bank_account') String? supplierBankAccount,
    @JsonKey(name: 'supplier_bank_account_name') String? supplierBankAccountName,
    String? notes,
    @JsonKey(name: 'paid_by') int? paidBy,
    @JsonKey(name: 'paid_by_name') String? paidByName,
    @JsonKey(name: 'formatted_invoices') @Default([]) List<PaymentTransactionInvoice> invoices,
  }) = _PaymentTransaction;

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) =>
      _$PaymentTransactionFromJson(json);
}

@freezed
class PaymentTransactionInvoice with _$PaymentTransactionInvoice {
  const factory PaymentTransactionInvoice({
    required int id,
    @JsonKey(name: 'invoice_id') required int invoiceId,
    @JsonKey(name: 'invoice_number') required String invoiceNumber,
    @JsonKey(name: 'invoice_date') String? invoiceDate,
    @JsonKey(name: 'due_date') String? dueDate,
    @JsonKey(name: 'supplier_name') String? supplierName,
    @JsonKey(name: 'amount_paid', fromJson: doubleFromJson) required double amountPaid,
  }) = _PaymentTransactionInvoice;

  factory PaymentTransactionInvoice.fromJson(Map<String, dynamic> json) =>
      _$PaymentTransactionInvoiceFromJson(json);
}
