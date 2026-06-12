import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_utils.dart';

part 'stock_opname.freezed.dart';
part 'stock_opname.g.dart';

@freezed
class StockOpname with _$StockOpname {
  const factory StockOpname({
    required int id,
    @JsonKey(name: 'company_id') required int companyId,
    @JsonKey(name: 'opname_number') required String opnameNumber,
    @JsonKey(name: 'warehouse_id') required int warehouseId,
    @JsonKey(name: 'warehouse_name') String? warehouseName,
    @JsonKey(name: 'company_name') String? companyName,
    required String status,
    @JsonKey(name: 'started_at') String? startedAt,
    @JsonKey(name: 'completed_at') String? completedAt,
    @JsonKey(name: 'created_by') int? createdBy,
    String? notes,
  }) = _StockOpname;

  factory StockOpname.fromJson(Map<String, dynamic> json) =>
      _$StockOpnameFromJson(json);
}

@freezed
class StockOpnameItem with _$StockOpnameItem {
  const factory StockOpnameItem({
    required String sku,
    @JsonKey(name: 'product_name') required String productName,
    @JsonKey(name: 'product_unit') @Default('pcs') String productUnit,
    @JsonKey(name: 'system_qty', fromJson: doubleFromJson) required double systemQty,
    @JsonKey(name: 'counted_qty', fromJson: doubleFromJson) required double countedQty,
    @JsonKey(fromJson: doubleFromJson) required double discrepancy,
  }) = _StockOpnameItem;

  factory StockOpnameItem.fromJson(Map<String, dynamic> json) =>
      _$StockOpnameItemFromJson(json);
}
