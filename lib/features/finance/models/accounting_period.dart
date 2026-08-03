class AccountingPeriod {
  final int id;
  final int companyId;
  final int year;
  final int month;
  final String label;
  final String status;
  final bool isOpen;
  final String? openedAt;
  final String? closedAt;

  AccountingPeriod({
    required this.id,
    required this.companyId,
    required this.year,
    required this.month,
    required this.label,
    required this.status,
    required this.isOpen,
    this.openedAt,
    this.closedAt,
  });

  factory AccountingPeriod.fromJson(Map<String, dynamic> json) {
    return AccountingPeriod(
      id: json['id'] as int,
      companyId: json['company_id'] as int,
      year: json['year'] as int,
      month: json['month'] as int,
      label: json['label'] as String? ?? '${json['month']}/${json['year']}',
      status: json['status'] as String? ?? 'open',
      isOpen: json['is_open'] as bool? ?? (json['status'] == 'open'),
      openedAt: json['opened_at'] as String?,
      closedAt: json['closed_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'company_id': companyId,
        'year': year,
        'month': month,
        'label': label,
        'status': status,
        'is_open': isOpen,
      };
}
