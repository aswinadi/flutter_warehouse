import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_breakdown.freezed.dart';
part 'inventory_breakdown.g.dart';

@freezed
class InventoryBreakdown with _$InventoryBreakdown {
  const factory InventoryBreakdown({
    @JsonKey(name: 'product_name') required String productName,
    required String sku,
    required String unit,
    @JsonKey(name: 'on_hand') @Default([]) List<WarehouseOnHand> onHand,
    @JsonKey(name: 'in_transit') @Default([]) List<InTransitStock> inTransit,
    @Default([]) List<OrderedStock> ordered,
  }) = _InventoryBreakdown;

  factory InventoryBreakdown.fromJson(Map<String, dynamic> json) =>
      _$InventoryBreakdownFromJson(json);
}

@freezed
class WarehouseOnHand with _$WarehouseOnHand {
  const factory WarehouseOnHand({
    @JsonKey(name: 'warehouse_id') required int warehouseId,
    @JsonKey(name: 'warehouse_name') required String warehouseName,
    required double quantity,
    @Default([]) List<LocationOnHand> locations,
  }) = _WarehouseOnHand;

  factory WarehouseOnHand.fromJson(Map<String, dynamic> json) =>
      _$WarehouseOnHandFromJson(json);
}

@freezed
class LocationOnHand with _$LocationOnHand {
  const factory LocationOnHand({
    @JsonKey(name: 'location_id') int? locationId,
    @JsonKey(name: 'location_code') required String locationCode,
    required double quantity,
  }) = _LocationOnHand;

  factory LocationOnHand.fromJson(Map<String, dynamic> json) =>
      _$LocationOnHandFromJson(json);
}

@freezed
class InTransitStock with _$InTransitStock {
  const factory InTransitStock({
    @JsonKey(name: 'transfer_number') required String transferNumber,
    @JsonKey(name: 'source_warehouse_name') required String sourceWarehouseName,
    @JsonKey(name: 'destination_warehouse_name') required String destinationWarehouseName,
    @JsonKey(name: 'destination_warehouse_id') required int destinationWarehouseId,
    required double quantity,
  }) = _InTransitStock;

  factory InTransitStock.fromJson(Map<String, dynamic> json) =>
      _$InTransitStockFromJson(json);
}

@freezed
class OrderedStock with _$OrderedStock {
  const factory OrderedStock({
    @JsonKey(name: 'po_number') required String poNumber,
    @JsonKey(name: 'warehouse_name') required String warehouseName,
    @JsonKey(name: 'warehouse_id') required int warehouseId,
    required double quantity,
  }) = _OrderedStock;

  factory OrderedStock.fromJson(Map<String, dynamic> json) =>
      _$OrderedStockFromJson(json);
}
