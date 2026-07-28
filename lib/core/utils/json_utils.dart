double doubleFromJson(dynamic json) {
  if (json == null) return 0.0;
  if (json is num) return json.toDouble();
  if (json is String) return double.tryParse(json) ?? 0.0;
  return 0.0;
}

double? doubleOrNullFromJson(dynamic json) {
  if (json == null) return null;
  if (json is num) return json.toDouble();
  if (json is String) return double.tryParse(json);
  return null;
}

String? stringOrNullFromJson(dynamic json) {
  if (json == null) return null;
  return json.toString();
}

bool boolFromJson(dynamic json) {
  if (json == null) return false;
  if (json is bool) return json;
  if (json is num) return json != 0;
  if (json is String) {
    final lower = json.trim().toLowerCase();
    return lower == 'true' || lower == '1';
  }
  return false;
}
