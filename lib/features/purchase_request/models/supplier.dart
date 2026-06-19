/// A simple supplier/vendor model used for the vendor comparison assignment feature.
class Supplier {
  final int id;
  final String? code;
  final String name;
  final String? city;
  final String? phone;
  final String? email;
  final String? paymentTerms;
  final bool isActive;
  final String? bankName;
  final String? bankAccount;
  final String? bankAccountName;

  const Supplier({
    required this.id,
    this.code,
    required this.name,
    this.city,
    this.phone,
    this.email,
    this.paymentTerms,
    this.isActive = true,
    this.bankName,
    this.bankAccount,
    this.bankAccountName,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'] is int ? json['id'] as int : (int.tryParse(json['id']?.toString() ?? '') ?? 0),
      code: json['code']?.toString(),
      name: json['name']?.toString() ?? 'Unknown',
      city: json['city']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      paymentTerms: json['payment_terms']?.toString(),
      isActive: json['is_active'] is bool
          ? json['is_active'] as bool
          : (json['is_active']?.toString() == 'true' || json['is_active']?.toString() == '1' || json['is_active'] == null),
      bankName: json['bank_name']?.toString(),
      bankAccount: json['bank_account']?.toString(),
      bankAccountName: json['bank_account_name']?.toString(),
    );
  }
}
