import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/models/warehouse.dart';
import '../../../core/utils/json_utils.dart';

part 'transfer.freezed.dart';
part 'transfer.g.dart';

@freezed
class TransferProduct with _$TransferProduct {
  const factory TransferProduct({
    required int id,
    required String sku,
    required String name,
    String? unit,
  }) = _TransferProduct;

  factory TransferProduct.fromJson(Map<String, dynamic> json) =>
      _$TransferProductFromJson(json);
}

@freezed
class TransferItem with _$TransferItem {
  const factory TransferItem({
    required int id,
    @JsonKey(name: 'warehouse_transfer_id') required int warehouseTransferId,
    @JsonKey(name: 'product_id') int? productId,
    TransferProduct? product,
    @JsonKey(name: 'qty_sent', fromJson: doubleFromJson) required double qtySent,
    @JsonKey(name: 'qty_received', fromJson: doubleOrNullFromJson) double? qtyReceived,
    String? notes,
  }) = _TransferItem;

  factory TransferItem.fromJson(Map<String, dynamic> json) =>
      _$TransferItemFromJson(json);
}

@freezed
class WarehouseTransfer with _$WarehouseTransfer {
  const factory WarehouseTransfer({
    required int id,
    @JsonKey(name: 'transfer_number') required String transferNumber,
    @JsonKey(name: 'source_warehouse_id') required int sourceWarehouseId,
    @JsonKey(name: 'source_warehouse') Warehouse? sourceWarehouse,
    @JsonKey(name: 'destination_warehouse_id') required int destinationWarehouseId,
    @JsonKey(name: 'destination_warehouse') Warehouse? destinationWarehouse,
    @JsonKey(name: 'transfer_date') required String transferDate,
    required String status,
    @JsonKey(name: 'do_number') String? doNumber,
    @JsonKey(name: 'driver_name') String? driverName,
    @JsonKey(name: 'vehicle_plate') String? vehiclePlate,
    String? notes,
    @JsonKey(name: 'pdf_url') String? pdfUrl,
    @JsonKey(name: 'shipped_by') dynamic shippedBy,
    @JsonKey(name: 'shipped_at') String? shippedAt,
    @JsonKey(name: 'received_by') dynamic receivedBy,
    @JsonKey(name: 'received_at') String? receivedAt,
    List<TransferItem>? items,
  }) = _WarehouseTransfer;

  factory WarehouseTransfer.fromJson(Map<String, dynamic> json) =>
      _$WarehouseTransferFromJson(json);
}

@freezed
class CreateTransferRequest with _$CreateTransferRequest {
  const factory CreateTransferRequest({
    @JsonKey(name: 'destination_warehouse_id') required int destinationWarehouseId,
    @JsonKey(name: 'driver_name') String? driverName,
    @JsonKey(name: 'vehicle_plate') String? vehiclePlate,
    String? notes,
    required List<CreateTransferItemRequest> items,
  }) = _CreateTransferRequest;

  factory CreateTransferRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTransferRequestFromJson(json);
}

@freezed
class CreateTransferItemRequest with _$CreateTransferItemRequest {
  const factory CreateTransferItemRequest({
    @JsonKey(name: 'inventory_id') required int inventoryId,
    @JsonKey(fromJson: doubleFromJson) required double quantity,
  }) = _CreateTransferItemRequest;

  factory CreateTransferItemRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTransferItemRequestFromJson(json);
}

@freezed
class ReceiveTransferRequest with _$ReceiveTransferRequest {
  const factory ReceiveTransferRequest({
    required List<ReceiveTransferItemRequest> items,
  }) = _ReceiveTransferRequest;

  factory ReceiveTransferRequest.fromJson(Map<String, dynamic> json) =>
      _$ReceiveTransferRequestFromJson(json);
}

@freezed
class ReceiveTransferItemRequest with _$ReceiveTransferItemRequest {
  const factory ReceiveTransferItemRequest({
    @JsonKey(name: 'transfer_item_id') required int transferItemId,
    @JsonKey(name: 'qty_received', fromJson: doubleFromJson) required double qtyReceived,
  }) = _ReceiveTransferItemRequest;

  factory ReceiveTransferItemRequest.fromJson(Map<String, dynamic> json) =>
      _$ReceiveTransferItemRequestFromJson(json);
}
