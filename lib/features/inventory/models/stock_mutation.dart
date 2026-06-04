import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_utils.dart';

part 'stock_mutation.freezed.dart';
part 'stock_mutation.g.dart';

@freezed
class StockMutationSummary with _$StockMutationSummary {
  const factory StockMutationSummary({
    required String sku,
    @JsonKey(name: 'product_name') required String productName,
    required String unit,
    @JsonKey(name: 'initial_balance') required int initialBalance,
    @JsonKey(name: 'period_in') required int periodIn,
    @JsonKey(name: 'period_out') required int periodOut,
    @JsonKey(name: 'ending_balance') required int endingBalance,
    @Default([]) List<dynamic> packagings,
  }) = _StockMutationSummary;

  factory StockMutationSummary.fromJson(Map<String, dynamic> json) =>
      _$StockMutationSummaryFromJson(json);
}

@freezed
class StockMutationDetail with _$StockMutationDetail {
  const factory StockMutationDetail({
    required int id,
    required String date,
    required String type,
    required String sku,
    @JsonKey(name: 'product_name') required String productName,
    required String unit,
    @JsonKey(fromJson: stringOrNullFromJson) String? description,
    @JsonKey(name: 'ref_number', fromJson: stringOrNullFromJson) String? refNumber,
    @JsonKey(name: 'in_qty', fromJson: doubleFromJson) required double inQty,
    @JsonKey(name: 'out_qty', fromJson: doubleFromJson) required double outQty,
  }) = _StockMutationDetail;

  factory StockMutationDetail.fromJson(Map<String, dynamic> json) =>
      _$StockMutationDetailFromJson(json);
}

@freezed
class StockMutationHeader with _$StockMutationHeader {
  const factory StockMutationHeader({
    @JsonKey(name: 'initial_balance') required int initialBalance,
    @JsonKey(name: 'total_in') required int totalIn,
    @JsonKey(name: 'total_out') required int totalOut,
    @JsonKey(name: 'ending_balance') required int endingBalance,
  }) = _StockMutationHeader;

  factory StockMutationHeader.fromJson(Map<String, dynamic> json) =>
      _$StockMutationHeaderFromJson(json);
}
