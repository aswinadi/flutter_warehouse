import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_utils.dart';

part 'landed_cost.freezed.dart';
part 'landed_cost.g.dart';

@freezed
class LandedCost with _$LandedCost {
  const factory LandedCost({
    required int id,
    @JsonKey(name: 'company_id') required int companyId,
    @JsonKey(name: 'reference_number') required String referenceNumber,
    @JsonKey(name: 'posting_date') required String postingDate,
    @JsonKey(name: 'total_amount', fromJson: doubleFromJson) required double totalAmount,
    required String currency,
    @JsonKey(name: 'supplier_code') required String supplierCode,
    @JsonKey(name: 'supplier_name') required String supplierName,
    String? description,
    required String status,
    @JsonKey(name: 'approved_at') String? approvedAt,
    @JsonKey(name: 'approved_by') int? approvedBy,
    @JsonKey(name: 'approved_by_user') UserDto? approvedByUser,
    List<LandedCostComponent>? components,
    List<LandedCostShipment>? shipments,
  }) = _LandedCost;

  factory LandedCost.fromJson(Map<String, dynamic> json) =>
      _$LandedCostFromJson(json);
}

@freezed
class LandedCostComponent with _$LandedCostComponent {
  const factory LandedCostComponent({
    required int id,
    @JsonKey(name: 'landed_cost_id') required int landedCostId,
    required String category,
    @JsonKey(name: 'invoice_id') int? invoiceId,
    @JsonKey(name: 'receiving_header_id') int? receivingHeaderId,
    @JsonKey(name: 'container_id') int? containerId,
    @JsonKey(fromJson: doubleFromJson) required double amount,
    ContainerDto? container,
    InvoiceDto? invoice,
  }) = _LandedCostComponent;

  factory LandedCostComponent.fromJson(Map<String, dynamic> json) =>
      _$LandedCostComponentFromJson(json);
}

@freezed
class ContainerDto with _$ContainerDto {
  const factory ContainerDto({
    required int id,
    @JsonKey(name: 'container_number') required String containerNumber,
  }) = _ContainerDto;

  factory ContainerDto.fromJson(Map<String, dynamic> json) =>
      _$ContainerDtoFromJson(json);
}

@freezed
class InvoiceDto with _$InvoiceDto {
  const factory InvoiceDto({
    required int id,
    @JsonKey(name: 'invoice_number') required String invoiceNumber,
  }) = _InvoiceDto;

  factory InvoiceDto.fromJson(Map<String, dynamic> json) =>
      _$InvoiceDtoFromJson(json);
}

@freezed
class LandedCostShipment with _$LandedCostShipment {
  const factory LandedCostShipment({
    required int id,
    @JsonKey(name: 'landed_cost_id') required int landedCostId,
    @JsonKey(name: 'receiving_header_id') required int receivingHeaderId,
    @JsonKey(name: 'shipment_percentage', fromJson: doubleFromJson) required double shipmentPercentage,
    @JsonKey(name: 'receiving_header') ReceivingHeaderDto? receivingHeader,
    List<LandedCostItem>? items,
  }) = _LandedCostShipment;

  factory LandedCostShipment.fromJson(Map<String, dynamic> json) =>
      _$LandedCostShipmentFromJson(json);
}

@freezed
class ReceivingHeaderDto with _$ReceivingHeaderDto {
  const factory ReceivingHeaderDto({
    required int id,
    @JsonKey(name: 'receiving_number') required String receivingNumber,
    @JsonKey(name: 'delivery_order_number') String? deliveryOrderNumber,
    @JsonKey(name: 'purchase_order') PurchaseOrderDto? purchaseOrder,
  }) = _ReceivingHeaderDto;

  factory ReceivingHeaderDto.fromJson(Map<String, dynamic> json) =>
      _$ReceivingHeaderDtoFromJson(json);
}

@freezed
class PurchaseOrderDto with _$PurchaseOrderDto {
  const factory PurchaseOrderDto({
    required int id,
    @JsonKey(name: 'supplier_name') required String supplierName,
  }) = _PurchaseOrderDto;

  factory PurchaseOrderDto.fromJson(Map<String, dynamic> json) =>
      _$PurchaseOrderDtoFromJson(json);
}

@freezed
class LandedCostItem with _$LandedCostItem {
  const factory LandedCostItem({
    required int id,
    @JsonKey(name: 'landed_cost_shipment_id') required int landedCostShipmentId,
    @JsonKey(name: 'receiving_detail_id') required int receivingDetailId,
    @JsonKey(name: 'is_selected') required bool isSelected,
    @JsonKey(name: 'item_percentage', fromJson: doubleFromJson) required double itemPercentage,
    @JsonKey(name: 'allocated_amount', fromJson: doubleFromJson) required double allocatedAmount,
    @JsonKey(name: 'receiving_detail') ReceivingDetailDto? receivingDetail,
  }) = _LandedCostItem;

  factory LandedCostItem.fromJson(Map<String, dynamic> json) =>
      _$LandedCostItemFromJson(json);
}

@freezed
class ReceivingDetailDto with _$ReceivingDetailDto {
  const factory ReceivingDetailDto({
    required int id,
    @JsonKey(name: 'received_qty', fromJson: doubleFromJson) required double receivedQty,
    required String unit,
    ProductDto? product,
    @JsonKey(name: 'po_detail') PoDetailDto? poDetail,
  }) = _ReceivingDetailDto;

  factory ReceivingDetailDto.fromJson(Map<String, dynamic> json) =>
      _$ReceivingDetailDtoFromJson(json);
}

@freezed
class ProductDto with _$ProductDto {
  const factory ProductDto({
    required int id,
    required String name,
    required String sku,
  }) = _ProductDto;

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);
}

@freezed
class PoDetailDto with _$PoDetailDto {
  const factory PoDetailDto({
    required int id,
    @JsonKey(name: 'unit_price', fromJson: doubleFromJson) required double unitPrice,
  }) = _PoDetailDto;

  factory PoDetailDto.fromJson(Map<String, dynamic> json) =>
      _$PoDetailDtoFromJson(json);
}

extension LandedCostItemExtension on LandedCostItem {
  double get originalPrice => receivingDetail?.poDetail?.unitPrice ?? 0.0;
  double get receivedQty => receivingDetail?.receivedQty ?? 0.0;
}

extension LandedCostComponentExtension on LandedCostComponent {
  String get refType => containerId != null ? 'packing_list' : 'invoice';
}

@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required int id,
    required String name,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}


