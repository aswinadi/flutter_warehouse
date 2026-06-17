import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_utils.dart';

part 'feed_log.freezed.dart';
part 'feed_log.g.dart';

@freezed
class AquacultureCycle with _$AquacultureCycle {
  const factory AquacultureCycle({
    required int id,
    @JsonKey(name: 'company_id') required int companyId,
    required String name,
    @JsonKey(name: 'stocking_date') String? stockingDate,
    @JsonKey(name: 'is_active') required bool isActive,
  }) = _AquacultureCycle;

  factory AquacultureCycle.fromJson(Map<String, dynamic> json) =>
      _$AquacultureCycleFromJson(json);
}

@freezed
class AquaculturePond with _$AquaculturePond {
  const factory AquaculturePond({
    required int id,
    required String name,
    String? code,
    @JsonKey(fromJson: doubleOrNullFromJson) double? length,
    @JsonKey(fromJson: doubleOrNullFromJson) double? width,
    @JsonKey(fromJson: doubleOrNullFromJson) double? depth,
    @JsonKey(name: 'modul_id') int? modulId,
  }) = _AquaculturePond;

  factory AquaculturePond.fromJson(Map<String, dynamic> json) =>
      _$AquaculturePondFromJson(json);
}

@freezed
class FeedLog with _$FeedLog {
  const factory FeedLog({
    required int id,
    @JsonKey(name: 'cycle_id') required int cycleId,
    @JsonKey(name: 'cycle_name') String? cycleName,
    @JsonKey(name: 'pond_id') required int pondId,
    @JsonKey(name: 'pond_name') String? pondName,
    @JsonKey(name: 'tambak_name') String? tambakName,
    @JsonKey(name: 'blok_name') String? blokName,
    @JsonKey(name: 'modul_name') String? modulName,
    required String date,
    @JsonKey(name: 'feed_code') String? feedCode,
    @JsonKey(name: 'amount_kg', fromJson: doubleFromJson) required double amountKg,
    int? doc,
    String? notes,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _FeedLog;

  factory FeedLog.fromJson(Map<String, dynamic> json) =>
      _$FeedLogFromJson(json);
}
