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

  const Supplier({
    required this.id,
    this.code,
    required this.name,
    this.city,
    this.phone,
    this.email,
    this.paymentTerms,
    this.isActive = true,
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
    );
  }
}
