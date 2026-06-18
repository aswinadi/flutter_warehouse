// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'landed_cost.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LandedCostImpl _$$LandedCostImplFromJson(Map<String, dynamic> json) =>
    _$LandedCostImpl(
      id: (json['id'] as num).toInt(),
      companyId: (json['company_id'] as num).toInt(),
      referenceNumber: json['reference_number'] as String,
      postingDate: json['posting_date'] as String,
      totalAmount: doubleFromJson(json['total_amount']),
      currency: json['currency'] as String,
      supplierCode: json['supplier_code'] as String,
      supplierName: json['supplier_name'] as String,
      description: json['description'] as String?,
      status: json['status'] as String,
      approvedAt: json['approved_at'] as String?,
      approvedBy: (json['approved_by'] as num?)?.toInt(),
      approvedByUser: json['approved_by_user'] == null
          ? null
          : UserDto.fromJson(json['approved_by_user'] as Map<String, dynamic>),
      components: (json['components'] as List<dynamic>?)
          ?.map((e) => LandedCostComponent.fromJson(e as Map<String, dynamic>))
          .toList(),
      shipments: (json['shipments'] as List<dynamic>?)
          ?.map((e) => LandedCostShipment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$LandedCostImplToJson(_$LandedCostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_id': instance.companyId,
      'reference_number': instance.referenceNumber,
      'posting_date': instance.postingDate,
      'total_amount': instance.totalAmount,
      'currency': instance.currency,
      'supplier_code': instance.supplierCode,
      'supplier_name': instance.supplierName,
      'description': instance.description,
      'status': instance.status,
      'approved_at': instance.approvedAt,
      'approved_by': instance.approvedBy,
      'approved_by_user': instance.approvedByUser,
      'components': instance.components,
      'shipments': instance.shipments,
    };

_$LandedCostComponentImpl _$$LandedCostComponentImplFromJson(
        Map<String, dynamic> json) =>
    _$LandedCostComponentImpl(
      id: (json['id'] as num).toInt(),
      landedCostId: (json['landed_cost_id'] as num).toInt(),
      category: json['category'] as String,
      invoiceId: (json['invoice_id'] as num?)?.toInt(),
      receivingHeaderId: (json['receiving_header_id'] as num?)?.toInt(),
      containerId: (json['container_id'] as num?)?.toInt(),
      amount: doubleFromJson(json['amount']),
      container: json['container'] == null
          ? null
          : ContainerDto.fromJson(json['container'] as Map<String, dynamic>),
      invoice: json['invoice'] == null
          ? null
          : InvoiceDto.fromJson(json['invoice'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$LandedCostComponentImplToJson(
        _$LandedCostComponentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'landed_cost_id': instance.landedCostId,
      'category': instance.category,
      'invoice_id': instance.invoiceId,
      'receiving_header_id': instance.receivingHeaderId,
      'container_id': instance.containerId,
      'amount': instance.amount,
      'container': instance.container,
      'invoice': instance.invoice,
    };

_$ContainerDtoImpl _$$ContainerDtoImplFromJson(Map<String, dynamic> json) =>
    _$ContainerDtoImpl(
      id: (json['id'] as num).toInt(),
      containerNumber: json['container_number'] as String,
    );

Map<String, dynamic> _$$ContainerDtoImplToJson(_$ContainerDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'container_number': instance.containerNumber,
    };

_$InvoiceDtoImpl _$$InvoiceDtoImplFromJson(Map<String, dynamic> json) =>
    _$InvoiceDtoImpl(
      id: (json['id'] as num).toInt(),
      invoiceNumber: json['invoice_number'] as String,
    );

Map<String, dynamic> _$$InvoiceDtoImplToJson(_$InvoiceDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'invoice_number': instance.invoiceNumber,
    };

_$LandedCostShipmentImpl _$$LandedCostShipmentImplFromJson(
        Map<String, dynamic> json) =>
    _$LandedCostShipmentImpl(
      id: (json['id'] as num).toInt(),
      landedCostId: (json['landed_cost_id'] as num).toInt(),
      receivingHeaderId: (json['receiving_header_id'] as num).toInt(),
      shipmentPercentage: doubleFromJson(json['shipment_percentage']),
      receivingHeader: json['receiving_header'] == null
          ? null
          : ReceivingHeaderDto.fromJson(
              json['receiving_header'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => LandedCostItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$LandedCostShipmentImplToJson(
        _$LandedCostShipmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'landed_cost_id': instance.landedCostId,
      'receiving_header_id': instance.receivingHeaderId,
      'shipment_percentage': instance.shipmentPercentage,
      'receiving_header': instance.receivingHeader,
      'items': instance.items,
    };

_$ReceivingHeaderDtoImpl _$$ReceivingHeaderDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ReceivingHeaderDtoImpl(
      id: (json['id'] as num).toInt(),
      receivingNumber: json['receiving_number'] as String,
      deliveryOrderNumber: json['delivery_order_number'] as String?,
      purchaseOrder: json['purchase_order'] == null
          ? null
          : PurchaseOrderDto.fromJson(
              json['purchase_order'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ReceivingHeaderDtoImplToJson(
        _$ReceivingHeaderDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'receiving_number': instance.receivingNumber,
      'delivery_order_number': instance.deliveryOrderNumber,
      'purchase_order': instance.purchaseOrder,
    };

_$PurchaseOrderDtoImpl _$$PurchaseOrderDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PurchaseOrderDtoImpl(
      id: (json['id'] as num).toInt(),
      supplierName: json['supplier_name'] as String,
    );

Map<String, dynamic> _$$PurchaseOrderDtoImplToJson(
        _$PurchaseOrderDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'supplier_name': instance.supplierName,
    };

_$LandedCostItemImpl _$$LandedCostItemImplFromJson(Map<String, dynamic> json) =>
    _$LandedCostItemImpl(
      id: (json['id'] as num).toInt(),
      landedCostShipmentId: (json['landed_cost_shipment_id'] as num).toInt(),
      receivingDetailId: (json['receiving_detail_id'] as num).toInt(),
      isSelected: json['is_selected'] as bool,
      itemPercentage: doubleFromJson(json['item_percentage']),
      allocatedAmount: doubleFromJson(json['allocated_amount']),
      receivingDetail: json['receiving_detail'] == null
          ? null
          : ReceivingDetailDto.fromJson(
              json['receiving_detail'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$LandedCostItemImplToJson(
        _$LandedCostItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'landed_cost_shipment_id': instance.landedCostShipmentId,
      'receiving_detail_id': instance.receivingDetailId,
      'is_selected': instance.isSelected,
      'item_percentage': instance.itemPercentage,
      'allocated_amount': instance.allocatedAmount,
      'receiving_detail': instance.receivingDetail,
    };

_$ReceivingDetailDtoImpl _$$ReceivingDetailDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ReceivingDetailDtoImpl(
      id: (json['id'] as num).toInt(),
      receivedQty: doubleFromJson(json['received_qty']),
      unit: json['unit'] as String,
      product: json['product'] == null
          ? null
          : ProductDto.fromJson(json['product'] as Map<String, dynamic>),
      poDetail: json['po_detail'] == null
          ? null
          : PoDetailDto.fromJson(json['po_detail'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ReceivingDetailDtoImplToJson(
        _$ReceivingDetailDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'received_qty': instance.receivedQty,
      'unit': instance.unit,
      'product': instance.product,
      'po_detail': instance.poDetail,
    };

_$ProductDtoImpl _$$ProductDtoImplFromJson(Map<String, dynamic> json) =>
    _$ProductDtoImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      sku: json['sku'] as String,
    );

Map<String, dynamic> _$$ProductDtoImplToJson(_$ProductDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sku': instance.sku,
    };

_$PoDetailDtoImpl _$$PoDetailDtoImplFromJson(Map<String, dynamic> json) =>
    _$PoDetailDtoImpl(
      id: (json['id'] as num).toInt(),
      unitPrice: doubleFromJson(json['unit_price']),
    );

Map<String, dynamic> _$$PoDetailDtoImplToJson(_$PoDetailDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'unit_price': instance.unitPrice,
    };

_$UserDtoImpl _$$UserDtoImplFromJson(Map<String, dynamic> json) =>
    _$UserDtoImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$$UserDtoImplToJson(_$UserDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
