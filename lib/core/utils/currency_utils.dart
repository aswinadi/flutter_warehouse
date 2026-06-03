import 'package:intl/intl.dart';

String formatCurrency(num amount, String currencyCode) {
  // Enforce comma for thousand separator and dot for decimal separator
  final formatter = NumberFormat('#,##0.##', 'en_US');
  return formatter.format(amount);
}

String formatWithCurrency(num amount, String currencyCode) {
  final cleanCode = currencyCode.trim().toUpperCase();
  return '$cleanCode ${formatCurrency(amount, cleanCode)}';
}
