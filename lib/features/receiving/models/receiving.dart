import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_utils.dart';

part 'receiving.freezed.dart';
part 'receiving.g.dart';

@freezed
class ReceivingItem with _$ReceivingItem {
  const factory ReceivingItem({
    required int id,
    @JsonKey(name: 'product_name') required String productName,
    required String sku,
    @JsonKey(fromJson: doubleFromJson) required double quantity,
    @JsonKey(name: 'ordered_qty', fromJson: doubleOrNullFromJson) double? orderedQty,
    @JsonKey(name: 'remaining_qty', fromJson: doubleOrNullFromJson) double? remainingQty,
    @JsonKey(name: 'location_id') int? locationId,
    @JsonKey(name: 'location_name') String? locationName,
  }) = _ReceivingItem;

  factory ReceivingItem.fromJson(Map<String, dynamic> json) =>
      _$ReceivingItemFromJson(json);
}

@freezed
class CreateReceivingRequest with _$CreateReceivingRequest {
  const factory CreateReceivingRequest({
    @JsonKey(name: 'po_header_id') required int poHeaderId,
    String? notes,
    @JsonKey(name: 'truck_number') String? truckNumber,
    @JsonKey(name: 'delivery_order_number') String? deliveryOrderNumber,
    required List<ReceivingItemRequest> items,
  }) = _CreateReceivingRequest;

  factory CreateReceivingRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateReceivingRequestFromJson(json);
}

@freezed
class ReceivingItemRequest with _$ReceivingItemRequest {
  const factory ReceivingItemRequest({
    @JsonKey(name: 'po_detail_id') required int poDetailId,
    @JsonKey(name: 'received_qty', fromJson: doubleFromJson) required double receivedQty,
    required int version,
    @JsonKey(name: 'location_id') int? locationId,
    @JsonKey(name: 'discrepancy_type') @Default('none') String discrepancyType,
    @JsonKey(name: 'discrepancy_note') String? discrepancyNote,
    @JsonKey(name: 'discrepancy_qty', fromJson: doubleOrNullFromJson) double? discrepancyQty,
    @JsonKey(name: 'photo_path') String? photoPath,
  }) = _ReceivingItemRequest;

  factory ReceivingItemRequest.fromJson(Map<String, dynamic> json) =>
      _$ReceivingItemRequestFromJson(json);
}

@freezed
class ReceivingHistoryItem with _$ReceivingHistoryItem {
  const factory ReceivingHistoryItem({
    required int id,
    @JsonKey(name: 'receiving_number') required String receivingNumber,
    @JsonKey(name: 'pdf_url') String? pdfUrl,
    @JsonKey(name: 'po_header_id') required int poHeaderId,
    @JsonKey(name: 'po_number') String? poNumber,
    @JsonKey(name: 'company_id') required int companyId,
    @JsonKey(name: 'transaction_date') required String transactionDate,
    @JsonKey(name: 'received_at') required String receivedAt,
    required String status,
    @JsonKey(name: 'truck_number') String? truckNumber,
    @JsonKey(name: 'delivery_order_number') String? deliveryOrderNumber,
    @JsonKey(name: 'supplier_name') required String supplierName,
    @JsonKey(name: 'details_count') required int detailsCount,
    @JsonKey(name: 'warehouse_name') String? warehouseName,
  }) = _ReceivingHistoryItem;

  factory ReceivingHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$ReceivingHistoryItemFromJson(json);
}

@freezed
class ReceivingContainer with _$ReceivingContainer {
  const factory ReceivingContainer({
    required int id,
    @JsonKey(name: 'container_number') required String containerNumber,
    @JsonKey(name: 'plate_number') String? plateNumber,
    required String status,
    @JsonKey(name: 'source_warehouse_id') required int sourceWarehouseId,
    @JsonKey(name: 'source_warehouse_name') String? sourceWarehouseName,
    @JsonKey(name: 'destination_warehouse_id') required int destinationWarehouseId,
    @JsonKey(name: 'destination_warehouse_name') String? destinationWarehouseName,
    @JsonKey(name: 'supplier_id') int? supplierId,
    @JsonKey(name: 'supplier_name') required String supplierName,
  }) = _ReceivingContainer;

  factory ReceivingContainer.fromJson(Map<String, dynamic> json) =>
      _$ReceivingContainerFromJson(json);
}

@freezed
class ReceivingContainerManifest with _$ReceivingContainerManifest {
  const factory ReceivingContainerManifest({
    @JsonKey(name: 'container_id') required int containerId,
    @JsonKey(name: 'container_number') required String containerNumber,
    @JsonKey(name: 'plate_number') String? plateNumber,
    required String status,
    @JsonKey(name: 'source_warehouse_id') required int sourceWarehouseId,
    @JsonKey(name: 'destination_warehouse_id') required int destinationWarehouseId,
    @JsonKey(name: 'destination_warehouse_name') String? destinationWarehouseName,
    @JsonKey(name: 'supplier_id') int? supplierId,
    @JsonKey(name: 'supplier_name') required String supplierName,
    required List<ReceivingContainerManifestItem> items,
  }) = _ReceivingContainerManifest;

  factory ReceivingContainerManifest.fromJson(Map<String, dynamic> json) =>
      _$ReceivingContainerManifestFromJson(json);
}

@freezed
class ReceivingContainerManifestItem with _$ReceivingContainerManifestItem {
  const factory ReceivingContainerManifestItem({
    @JsonKey(name: 'po_detail_id') required int poDetailId,
    @JsonKey(name: 'po_header_id') required int poHeaderId,
    @JsonKey(name: 'po_number') required String poNumber,
    required String sku,
    @JsonKey(name: 'product_name') required String productName,
    @JsonKey(name: 'planned_qty') required double plannedQty,
    required String unit,
  }) = _ReceivingContainerManifestItem;

  factory ReceivingContainerManifestItem.fromJson(Map<String, dynamic> json) =>
      _$ReceivingContainerManifestItemFromJson(json);
}

@freezed
class ContainerReceivingRequest with _$ContainerReceivingRequest {
  const factory ContainerReceivingRequest({
    @JsonKey(name: 'source_warehouse_id') required int sourceWarehouseId,
    @JsonKey(name: 'destination_warehouse_id') required int destinationWarehouseId,
    @JsonKey(name: 'container_number') required String containerNumber,
    @JsonKey(name: 'plate_number') String? plateNumber,
    @JsonKey(name: 'driver_name') String? driverName,
    required List<ContainerGroupedManifest> manifest,
  }) = _ContainerReceivingRequest;

  factory ContainerReceivingRequest.fromJson(Map<String, dynamic> json) =>
      _$ContainerReceivingRequestFromJson(json);
}

@freezed
class ContainerGroupedManifest with _$ContainerGroupedManifest {
  const factory ContainerGroupedManifest({
    @JsonKey(name: 'po_header_id') required int poHeaderId,
    required List<ContainerReceivingItemRequest> items,
  }) = _ContainerGroupedManifest;

  factory ContainerGroupedManifest.fromJson(Map<String, dynamic> json) =>
      _$ContainerGroupedManifestFromJson(json);
}

@freezed
class ContainerReceivingItemRequest with _$ContainerReceivingItemRequest {
  const factory ContainerReceivingItemRequest({
    @JsonKey(name: 'po_detail_id') required int poDetailId,
    @JsonKey(name: 'received_qty') required double receivedQty,
    required String unit,
    @Default(1) int conversion,
  }) = _ContainerReceivingItemRequest;

  factory ContainerReceivingItemRequest.fromJson(Map<String, dynamic> json) =>
      _$ContainerReceivingItemRequestFromJson(json);
}

