import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_utils.dart';

part 'packing_list.freezed.dart';
part 'packing_list.g.dart';

@freezed
class PackingList with _$PackingList {
  const factory PackingList({
    required int id,
    @JsonKey(name: 'container_number') required String containerNumber,
    @JsonKey(name: 'carrier_name') String? carrierName,
    @JsonKey(name: 'plate_number') String? plateNumber,
    required String status,
    @JsonKey(name: 'source_warehouse_id') int? sourceWarehouseId,
    @JsonKey(name: 'source_warehouse_name') String? sourceWarehouseName,
    @JsonKey(name: 'destination_warehouse_id') int? destinationWarehouseId,
    @JsonKey(name: 'destination_warehouse_name') String? destinationWarehouseName,
    @JsonKey(name: 'supplier_id') int? supplierId,
    @JsonKey(name: 'supplier_name') String? supplierName,
    @JsonKey(name: 'item_count') @Default(0) int itemCount,
    @JsonKey(name: 'estimated_departure') DateTime? estimatedDeparture,
    @JsonKey(name: 'closing_date') DateTime? closingDate,
    @Default([]) List<PackingListItem> items,
  }) = _PackingList;

  factory PackingList.fromJson(Map<String, dynamic> json) =>
      _$PackingListFromJson(json);
}

@freezed
class PackingListItem with _$PackingListItem {
  const factory PackingListItem({
    required String type, // 'po' or 'inventory'
    @JsonKey(name: 'po_detail_id') int? poDetailId,
    @JsonKey(name: 'inventory_id') int? inventoryId,
    @JsonKey(name: 'po_header_id') int? poHeaderId,
    @JsonKey(name: 'po_number') String? poNumber,
    @JsonKey(name: 'supplier_name') String? supplierName,
    required String sku,
    @JsonKey(name: 'product_name') required String productName,
    @JsonKey(name: 'planned_qty', fromJson: doubleFromJson) required double plannedQty,
    required String unit,
  }) = _PackingListItem;

  factory PackingListItem.fromJson(Map<String, dynamic> json) =>
      _$PackingListItemFromJson(json);
}
