import 'package:intl/intl.dart';

String formatCurrency(num amount, String currencyCode) {
  // Enforce dot for thousand separator and comma for decimal separator
  final formatter = NumberFormat('#,##0.##', 'id_ID');
  return formatter.format(amount);
}

String formatWithCurrency(num amount, String currencyCode) {
  final cleanCode = currencyCode.trim().toUpperCase();
  return '$cleanCode ${formatCurrency(amount, cleanCode)}';
}
