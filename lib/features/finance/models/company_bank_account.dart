class CompanyBankAccount {
  final int id;
  final int companyId;
  final String bankName;
  final String accountNumber;
  final String accountName;
  final bool isActive;

  CompanyBankAccount({
    required this.id,
    required this.companyId,
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
    required this.isActive,
  });

  factory CompanyBankAccount.fromJson(Map<String, dynamic> json) {
    return CompanyBankAccount(
      id: json['id'] is int ? json['id'] as int : (int.tryParse(json['id']?.toString() ?? '') ?? 0),
      companyId: json['company_id'] is int ? json['company_id'] as int : (int.tryParse(json['company_id']?.toString() ?? '') ?? 0),
      bankName: json['bank_name']?.toString() ?? '',
      accountNumber: json['account_number']?.toString() ?? '',
      accountName: json['account_name']?.toString() ?? '',
      isActive: json['is_active'] is bool
          ? json['is_active'] as bool
          : (json['is_active']?.toString() == 'true' || json['is_active']?.toString() == '1' || json['is_active'] == null),
    );
  }
}
