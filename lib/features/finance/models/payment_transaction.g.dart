// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentTransactionImpl _$$PaymentTransactionImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentTransactionImpl(
      id: (json['id'] as num).toInt(),
      companyId: (json['company_id'] as num).toInt(),
      companyName: json['company_name'] as String?,
      supplierId: (json['supplier_id'] as num).toInt(),
      supplierName: json['supplier_name'] as String?,
      companyBankAccountId: (json['company_bank_account_id'] as num?)?.toInt(),
      paymentRequestId: (json['payment_request_id'] as num?)?.toInt(),
      transactionNumber: json['transaction_number'] as String,
      transactionDate: json['transaction_date'] as String,
      totalAmount: doubleFromJson(json['total_amount']),
      bankName: json['bank_name'] as String?,
      bankAccount: json['bank_account'] as String?,
      transferReference: json['transfer_reference'] as String?,
      receiptPath: json['receipt_path'] as String?,
      receiptUrl: json['receipt_url'] as String?,
      notes: json['notes'] as String?,
      paidBy: (json['paid_by'] as num?)?.toInt(),
      paidByName: json['paid_by_name'] as String?,
      invoices: (json['formatted_invoices'] as List<dynamic>?)
              ?.map((e) =>
                  PaymentTransactionInvoice.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PaymentTransactionImplToJson(
        _$PaymentTransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_id': instance.companyId,
      'company_name': instance.companyName,
      'supplier_id': instance.supplierId,
      'supplier_name': instance.supplierName,
      'company_bank_account_id': instance.companyBankAccountId,
      'payment_request_id': instance.paymentRequestId,
      'transaction_number': instance.transactionNumber,
      'transaction_date': instance.transactionDate,
      'total_amount': instance.totalAmount,
      'bank_name': instance.bankName,
      'bank_account': instance.bankAccount,
      'transfer_reference': instance.transferReference,
      'receipt_path': instance.receiptPath,
      'receipt_url': instance.receiptUrl,
      'notes': instance.notes,
      'paid_by': instance.paidBy,
      'paid_by_name': instance.paidByName,
      'formatted_invoices': instance.invoices,
    };

_$PaymentTransactionInvoiceImpl _$$PaymentTransactionInvoiceImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentTransactionInvoiceImpl(
      id: (json['id'] as num).toInt(),
      invoiceId: (json['invoice_id'] as num).toInt(),
      invoiceNumber: json['invoice_number'] as String,
      invoiceDate: json['invoice_date'] as String?,
      dueDate: json['due_date'] as String?,
      supplierName: json['supplier_name'] as String?,
      amountPaid: doubleFromJson(json['amount_paid']),
    );

Map<String, dynamic> _$$PaymentTransactionInvoiceImplToJson(
        _$PaymentTransactionInvoiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'invoice_id': instance.invoiceId,
      'invoice_number': instance.invoiceNumber,
      'invoice_date': instance.invoiceDate,
      'due_date': instance.dueDate,
      'supplier_name': instance.supplierName,
      'amount_paid': instance.amountPaid,
    };
