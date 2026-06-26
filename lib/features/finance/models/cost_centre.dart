import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_utils.dart';

part 'cost_centre.freezed.dart';
part 'cost_centre.g.dart';

@freezed
class CostCentre with _$CostCentre {
  const factory CostCentre({
    required int id,
    required String code,
    required String name,
    @JsonKey(name: 'parent_code') String? parentCode,
    @JsonKey(name: 'luas_m2', fromJson: doubleFromJson) required double luasM2,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'is_parent') @Default(false) bool isParent,
  }) = _CostCentre;

  factory CostCentre.fromJson(Map<String, dynamic> json) => _$CostCentreFromJson(json);
}
