import 'package:freezed_annotation/freezed_annotation.dart';

part 'chart_of_account.freezed.dart';
part 'chart_of_account.g.dart';

@freezed
class ChartOfAccount with _$ChartOfAccount {
  const factory ChartOfAccount({
    required int id,
    @JsonKey(name: 'company_id') required int companyId,
    @JsonKey(name: 'coa_code') required String coaCode,
    @JsonKey(name: 'coa_name') required String coaName,
    @JsonKey(name: 'parent_code') String? parentCode,
    @JsonKey(name: 'is_active') required bool isActive,
  }) = _ChartOfAccount;

  factory ChartOfAccount.fromJson(Map<String, dynamic> json) =>
      _$ChartOfAccountFromJson(json);
}
