import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_utils.dart';

part 'invoice_biaya_detail.freezed.dart';
part 'invoice_biaya_detail.g.dart';

@freezed
class InvoiceBiayaDetail with _$InvoiceBiayaDetail {
  const factory InvoiceBiayaDetail({
    int? id,
    @JsonKey(name: 'invoice_biaya_id') int? invoiceBiayaId,
    @JsonKey(name: 'coa_code') required String coaCode,
    @JsonKey(name: 'coa_name') String? coaName,
    @JsonKey(name: 'project_code') String? projectCode,
    @JsonKey(name: 'cost_code') String? costCode,
    @JsonKey(fromJson: doubleFromJson) @Default(0.0) double debit,
    @JsonKey(fromJson: doubleFromJson) @Default(0.0) double credit,
    @JsonKey(name: 'staff_name') String? staffName,
    String? notes,
  }) = _InvoiceBiayaDetail;

  factory InvoiceBiayaDetail.fromJson(Map<String, dynamic> json) =>
      _$InvoiceBiayaDetailFromJson(json);
}
