import '../../../core/utils/json_utils.dart';

class SupplierDebtHistory {
  final int id;
  final int companyId;
  final String? companyName;
  final int supplierId;
  final String? supplierName;
  final String ledgerCategory;
  final String transactionDate;
  final String type;
  final double amount;
  final double? balanceBefore;
  final double balanceAfter;
  final String? referenceType;
  final int? referenceId;
  final String? notes;

  SupplierDebtHistory({
    required this.id,
    required this.companyId,
    this.companyName,
    required this.supplierId,
    this.supplierName,
    this.ledgerCategory = 'ap',
    required this.transactionDate,
    required this.type,
    required this.amount,
    this.balanceBefore,
    required this.balanceAfter,
    this.referenceType,
    this.referenceId,
    this.notes,
  });

  factory SupplierDebtHistory.fromJson(Map<String, dynamic> json) {
    return SupplierDebtHistory(
      id: (json['id'] as num).toInt(),
      companyId: (json['company_id'] as num).toInt(),
      companyName: json['company'] != null ? json['company']['company_name'] as String? : json['company_name'] as String?,
      supplierId: (json['supplier_id'] as num).toInt(),
      supplierName: json['supplier'] != null ? json['supplier']['name'] as String? : json['supplier_name'] as String?,
      ledgerCategory: json['ledger_category'] as String? ?? 'ap',
      transactionDate: json['transaction_date'] as String? ?? '',
      type: json['type'] as String? ?? 'increase',
      amount: doubleFromJson(json['amount']),
      balanceBefore: doubleOrNullFromJson(json['balance_before']),
      balanceAfter: doubleFromJson(json['balance_after']),
      referenceType: json['reference_type'] as String?,
      referenceId: (json['reference_id'] as num?)?.toInt(),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'company_id': companyId,
        'company_name': companyName,
        'supplier_id': supplierId,
        'supplier_name': supplierName,
        'ledger_category': ledgerCategory,
        'transaction_date': transactionDate,
        'type': type,
        'amount': amount,
        'balance_before': balanceBefore,
        'balance_after': balanceAfter,
        'reference_type': referenceType,
        'reference_id': referenceId,
        'notes': notes,
      };
}

class SupplierLedgerSummary {
  final double apBalance;
  final double arBalance;
  final double netBalance;

  SupplierLedgerSummary({
    required this.apBalance,
    required this.arBalance,
    required this.netBalance,
  });

  factory SupplierLedgerSummary.fromJson(Map<String, dynamic> json) {
    return SupplierLedgerSummary(
      apBalance: doubleFromJson(json['ap_balance']),
      arBalance: doubleFromJson(json['ar_balance']),
      netBalance: doubleFromJson(json['net_balance']),
    );
  }

  Map<String, dynamic> toJson() => {
        'ap_balance': apBalance,
        'ar_balance': arBalance,
        'net_balance': netBalance,
      };
}
