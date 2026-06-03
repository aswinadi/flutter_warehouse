import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory.freezed.dart';
part 'inventory.g.dart';

@freezed
class Inventory with _$Inventory {
  const factory Inventory({
    required int id,
    @JsonKey(name: 'barcode_code') String? barcodeCode,
    required String sku,
    @JsonKey(name: 'product_name') String? productName,
    required double quantity,
    required String status,
    @JsonKey(name: 'warehouse_name') String? warehouseName,
    @JsonKey(name: 'location_code') String? locationCode,
    String? unit,
  }) = _Inventory;

  factory Inventory.fromJson(Map<String, dynamic> json) =>
      _$InventoryFromJson(json);
}
