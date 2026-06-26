import 'package:freezed_annotation/freezed_annotation.dart';

part 'cost_code.freezed.dart';
part 'cost_code.g.dart';

@freezed
class CostCode with _$CostCode {
  const factory CostCode({
    required int id,
    @JsonKey(name: 'company_id') required int companyId,
    required String code,
    required String name,
    @JsonKey(name: 'tipe_cost_name') String? tipeCostName,
    @JsonKey(name: 'group_name') String? groupName,
    @JsonKey(name: 'group_tipe') String? groupTipe,
    String? codecoa,
    String? namecoa,
    @JsonKey(name: 'is_active') required bool isActive,
  }) = _CostCode;

  factory CostCode.fromJson(Map<String, dynamic> json) => _$CostCodeFromJson(json);
}
