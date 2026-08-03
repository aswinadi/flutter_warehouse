class JournalDetailItem {
  final int? id;
  final String coaCode;
  final String coaName;
  final String? costCentreCode;
  final String? description;
  final double debit;
  final double credit;

  JournalDetailItem({
    this.id,
    required this.coaCode,
    required this.coaName,
    this.costCentreCode,
    this.description,
    required this.debit,
    required this.credit,
  });

  factory JournalDetailItem.fromJson(Map<String, dynamic> json) {
    return JournalDetailItem(
      id: json['id'] as int?,
      coaCode: json['coa_code'] as String,
      coaName: json['coa_name'] as String? ?? json['coa_code'] as String,
      costCentreCode: json['cost_centre_code'] as String?,
      description: json['description'] as String?,
      debit: (json['debit'] as num).toDouble(),
      credit: (json['credit'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'coa_code': coaCode,
        'coa_name': coaName,
        'cost_centre_code': costCentreCode,
        'description': description,
        'debit': debit,
        'credit': credit,
      };
}

class JournalMaster {
  final int id;
  final int companyId;
  final int? accountingPeriodId;
  final String journalNumber;
  final String journalDate;
  final String journalType;
  final String? description;
  final String status;
  final double totalDebit;
  final double totalCredit;
  final bool isBalanced;
  final bool isEditable;
  final List<JournalDetailItem> details;
  final String? createdAt;

  JournalMaster({
    required this.id,
    required this.companyId,
    this.accountingPeriodId,
    required this.journalNumber,
    required this.journalDate,
    required this.journalType,
    this.description,
    required this.status,
    required this.totalDebit,
    required this.totalCredit,
    required this.isBalanced,
    required this.isEditable,
    required this.details,
    this.createdAt,
  });

  factory JournalMaster.fromJson(Map<String, dynamic> json) {
    var rawDetails = json['details'] as List<dynamic>? ?? [];
    List<JournalDetailItem> detailList =
        rawDetails.map((d) => JournalDetailItem.fromJson(d as Map<String, dynamic>)).toList();

    return JournalMaster(
      id: json['id'] as int,
      companyId: json['company_id'] as int,
      accountingPeriodId: json['accounting_period_id'] as int?,
      journalNumber: json['journal_number'] as String,
      journalDate: json['journal_date'] as String,
      journalType: json['journal_type'] as String? ?? 'AUTO',
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'posted',
      totalDebit: (json['total_debit'] as num? ?? 0.0).toDouble(),
      totalCredit: (json['total_credit'] as num? ?? 0.0).toDouble(),
      isBalanced: json['is_balanced'] as bool? ?? true,
      isEditable: json['is_editable'] as bool? ?? false,
      details: detailList,
      createdAt: json['created_at'] as String?,
    );
  }
}
