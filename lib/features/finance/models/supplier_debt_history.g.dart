// GENERATED CODE - MANUAL ENTRY

part of 'supplier_debt_history.dart';

_$SupplierDebtHistoryImpl _$$SupplierDebtHistoryImplFromJson(
        Map<String, dynamic> json) =>
    _$SupplierDebtHistoryImpl(
      id: (json['id'] as num).toInt(),
      companyId: (json['company_id'] as num).toInt(),
      companyName: json['company_name'] as String?,
      supplierId: (json['supplier_id'] as num).toInt(),
      supplierName: json['supplier_name'] as String?,
      ledgerCategory: json['ledger_category'] as String? ?? 'ap',
      transactionDate: json['transaction_date'] as String,
      type: json['type'] as String,
      amount: doubleFromJson(json['amount']),
      balanceBefore: doubleOrNullFromJson(json['balance_before']),
      balanceAfter: doubleFromJson(json['balance_after']),
      referenceType: json['reference_type'] as String?,
      referenceId: (json['reference_id'] as num?)?.toInt(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$SupplierDebtHistoryImplToJson(
        _$SupplierDebtHistoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_id': instance.companyId,
      'company_name': instance.companyName,
      'supplier_id': instance.supplierId,
      'supplier_name': instance.supplierName,
      'ledger_category': instance.ledgerCategory,
      'transaction_date': instance.transactionDate,
      'type': instance.type,
      'amount': instance.amount,
      'balance_before': instance.balanceBefore,
      'balance_after': instance.balanceAfter,
      'reference_type': instance.referenceType,
      'reference_id': instance.referenceId,
      'notes': instance.notes,
    };

_$SupplierLedgerSummaryImpl _$$SupplierLedgerSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$SupplierLedgerSummaryImpl(
      apBalance: doubleFromJson(json['ap_balance']),
      arBalance: doubleFromJson(json['ar_balance']),
      netBalance: doubleFromJson(json['net_balance']),
    );

Map<String, dynamic> _$$SupplierLedgerSummaryImplToJson(
        _$SupplierLedgerSummaryImpl instance) =>
    <String, dynamic>{
      'ap_balance': instance.apBalance,
      'ar_balance': instance.arBalance,
      'net_balance': instance.netBalance,
    };
