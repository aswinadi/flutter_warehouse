import 'package:intl/intl.dart';

class BarcodeUtils {
  /// Encodes a date into a 4-character string format used for compact barcodes.
  /// Year: 2025 -> 'A', 2026 -> 'B', etc.
  /// Month: 1 -> 'A', 2 -> 'B', ..., 12 -> 'L'
  /// Day: 01-31 (padded to 2 digits)
  static String encodeDate(DateTime date) {
    final year = date.year;
    final month = date.month;
    final day = date.day;

    // Year mapping: 2025 -> 'A'
    // 65 is 'A' in ASCII/Unicode
    final yearOffset = (year - 2025).clamp(0, 25);
    final yearChar = String.fromCharCode(65 + yearOffset);

    // Month mapping: 1 -> 'A', 2 -> 'B'...
    final monthOffset = (month - 1).clamp(0, 11);
    final monthChar = String.fromCharCode(65 + monthOffset);

    // Day mapping: Pad with zero if needed
    final dayStr = day.toString().padLeft(2, '0');

    return '$yearChar$monthChar$dayStr';
  }

  /// Builds a complete barcode string based on the provided configuration.
  /// Format: PREFIX-COMPANY-DATE-SEQUENCE
  static String buildBarcode({
    required String prefix,
    required String separator,
    required String companyCode,
    required DateTime date,
    required int sequence,
    required int sequenceLength,
  }) {
    final encodedDate = encodeDate(date);
    final seqStr = sequence.toString().padLeft(sequenceLength, '0');

    return '$prefix$separator$companyCode$separator$encodedDate$separator$seqStr';
  }
}
