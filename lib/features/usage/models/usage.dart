import 'package:freezed_annotation/freezed_annotation.dart';

part 'usage.freezed.dart';
part 'usage.g.dart';

@freezed
class Pond with _$Pond {
  const factory Pond({
    required int id,
    required String name,
    String? code,
  }) = _Pond;

  factory Pond.fromJson(Map<String, dynamic> json) => _$PondFromJson(json);
}

@freezed
class UsageRequest with _$UsageRequest {
  const factory UsageRequest({
    @JsonKey(name: 'pond_id') required int pondId,
    @JsonKey(name: 'inventory_id') required int inventoryId,
    required double quantity,
    String? notes,
  }) = _UsageRequest;

  factory UsageRequest.fromJson(Map<String, dynamic> json) =>
      _$UsageRequestFromJson(json);
}
