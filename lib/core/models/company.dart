import 'package:freezed_annotation/freezed_annotation.dart';

part 'company.freezed.dart';
part 'company.g.dart';

@freezed
class Company with _$Company {
  const factory Company({
    required int id,
    @JsonKey(name: 'company_name') required String companyName,
    @JsonKey(name: 'company_code') required String companyCode,
  }) = _Company;

  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);
}
