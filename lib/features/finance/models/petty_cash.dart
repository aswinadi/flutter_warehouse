class PettyCashTransaction {
  final int id;
  final int companyId;
  final int? warehouseId;
  final String transactionDate;
  final String description;
  final double amount;
  final String coaCode;
  final String? costCentreCode;
  final String status;
  final String? submittedByName;
  final String? approvedByName;
  final String? approvedAt;

  PettyCashTransaction({
    required this.id,
    required this.companyId,
    this.warehouseId,
    required this.transactionDate,
    required this.description,
    required this.amount,
    required this.coaCode,
    this.costCentreCode,
    required this.status,
    this.submittedByName,
    this.approvedByName,
    this.approvedAt,
  });

  factory PettyCashTransaction.fromJson(Map<String, dynamic> json) {
    return PettyCashTransaction(
      id: json['id'] as int,
      companyId: json['company_id'] as int,
      warehouseId: json['warehouse_id'] as int?,
      transactionDate: json['transaction_date'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      coaCode: json['coa_code'] as String,
      costCentreCode: json['cost_centre_code'] as String?,
      status: json['status'] as String? ?? 'pending',
      submittedByName: json['submitted_by_user']?['name'] as String?,
      approvedByName: json['approved_by_user']?['name'] as String?,
      approvedAt: json['approved_at'] as String?,
    );
  }
}
