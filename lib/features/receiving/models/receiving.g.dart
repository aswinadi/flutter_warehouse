// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receiving.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReceivingItemImpl _$$ReceivingItemImplFromJson(Map<String, dynamic> json) =>
    _$ReceivingItemImpl(
      id: (json['id'] as num).toInt(),
      productName: json['product_name'] as String,
      sku: json['sku'] as String,
      quantity: doubleFromJson(json['quantity']),
      orderedQty: doubleOrNullFromJson(json['ordered_qty']),
      remainingQty: doubleOrNullFromJson(json['remaining_qty']),
      locationId: (json['location_id'] as num?)?.toInt(),
      locationName: json['location_name'] as String?,
    );

Map<String, dynamic> _$$ReceivingItemImplToJson(_$ReceivingItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_name': instance.productName,
      'sku': instance.sku,
      'quantity': instance.quantity,
      'ordered_qty': instance.orderedQty,
      'remaining_qty': instance.remainingQty,
      'location_id': instance.locationId,
      'location_name': instance.locationName,
    };

_$CreateReceivingRequestImpl _$$CreateReceivingRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateReceivingRequestImpl(
      poHeaderId: (json['po_header_id'] as num).toInt(),
      notes: json['notes'] as String?,
      truckNumber: json['truck_number'] as String?,
      deliveryOrderNumber: json['delivery_order_number'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => ReceivingItemRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CreateReceivingRequestImplToJson(
        _$CreateReceivingRequestImpl instance) =>
    <String, dynamic>{
      'po_header_id': instance.poHeaderId,
      'notes': instance.notes,
      'truck_number': instance.truckNumber,
      'delivery_order_number': instance.deliveryOrderNumber,
      'items': instance.items,
    };

_$ReceivingItemRequestImpl _$$ReceivingItemRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ReceivingItemRequestImpl(
      poDetailId: (json['po_detail_id'] as num).toInt(),
      receivedQty: doubleFromJson(json['received_qty']),
      version: (json['version'] as num).toInt(),
      locationId: (json['location_id'] as num?)?.toInt(),
      discrepancyType: json['discrepancy_type'] as String? ?? 'none',
      discrepancyNote: json['discrepancy_note'] as String?,
      discrepancyQty: doubleOrNullFromJson(json['discrepancy_qty']),
      photoPath: json['photo_path'] as String?,
    );

Map<String, dynamic> _$$ReceivingItemRequestImplToJson(
        _$ReceivingItemRequestImpl instance) =>
    <String, dynamic>{
      'po_detail_id': instance.poDetailId,
      'received_qty': instance.receivedQty,
      'version': instance.version,
      'location_id': instance.locationId,
      'discrepancy_type': instance.discrepancyType,
      'discrepancy_note': instance.discrepancyNote,
      'discrepancy_qty': instance.discrepancyQty,
      'photo_path': instance.photoPath,
    };

_$ReceivingHistoryItemImpl _$$ReceivingHistoryItemImplFromJson(
        Map<String, dynamic> json) =>
    _$ReceivingHistoryItemImpl(
      id: (json['id'] as num).toInt(),
      receivingNumber: json['receiving_number'] as String,
      pdfUrl: json['pdf_url'] as String?,
      poHeaderId: (json['po_header_id'] as num).toInt(),
      poNumber: json['po_number'] as String?,
      companyId: (json['company_id'] as num).toInt(),
      transactionDate: json['transaction_date'] as String,
      receivedAt: json['received_at'] as String,
      status: json['status'] as String,
      truckNumber: json['truck_number'] as String?,
      deliveryOrderNumber: json['delivery_order_number'] as String?,
      supplierName: json['supplier_name'] as String,
      detailsCount: (json['details_count'] as num).toInt(),
      warehouseName: json['warehouse_name'] as String?,
    );

Map<String, dynamic> _$$ReceivingHistoryItemImplToJson(
        _$ReceivingHistoryItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'receiving_number': instance.receivingNumber,
      'pdf_url': instance.pdfUrl,
      'po_header_id': instance.poHeaderId,
      'po_number': instance.poNumber,
      'company_id': instance.companyId,
      'transaction_date': instance.transactionDate,
      'received_at': instance.receivedAt,
      'status': instance.status,
      'truck_number': instance.truckNumber,
      'delivery_order_number': instance.deliveryOrderNumber,
      'supplier_name': instance.supplierName,
      'details_count': instance.detailsCount,
      'warehouse_name': instance.warehouseName,
    };

_$ReceivingContainerImpl _$$ReceivingContainerImplFromJson(
        Map<String, dynamic> json) =>
    _$ReceivingContainerImpl(
      id: (json['id'] as num).toInt(),
      containerNumber: json['container_number'] as String,
      plateNumber: json['plate_number'] as String?,
      status: json['status'] as String,
      sourceWarehouseId: (json['source_warehouse_id'] as num).toInt(),
      sourceWarehouseName: json['source_warehouse_name'] as String?,
      destinationWarehouseId: (json['destination_warehouse_id'] as num).toInt(),
      destinationWarehouseName: json['destination_warehouse_name'] as String?,
      supplierId: (json['supplier_id'] as num?)?.toInt(),
      supplierName: json['supplier_name'] as String,
    );

Map<String, dynamic> _$$ReceivingContainerImplToJson(
        _$ReceivingContainerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'container_number': instance.containerNumber,
      'plate_number': instance.plateNumber,
      'status': instance.status,
      'source_warehouse_id': instance.sourceWarehouseId,
      'source_warehouse_name': instance.sourceWarehouseName,
      'destination_warehouse_id': instance.destinationWarehouseId,
      'destination_warehouse_name': instance.destinationWarehouseName,
      'supplier_id': instance.supplierId,
      'supplier_name': instance.supplierName,
    };

_$ReceivingContainerManifestImpl _$$ReceivingContainerManifestImplFromJson(
        Map<String, dynamic> json) =>
    _$ReceivingContainerManifestImpl(
      containerId: (json['container_id'] as num).toInt(),
      containerNumber: json['container_number'] as String,
      plateNumber: json['plate_number'] as String?,
      status: json['status'] as String,
      sourceWarehouseId: (json['source_warehouse_id'] as num).toInt(),
      destinationWarehouseId: (json['destination_warehouse_id'] as num).toInt(),
      destinationWarehouseName: json['destination_warehouse_name'] as String?,
      supplierId: (json['supplier_id'] as num?)?.toInt(),
      supplierName: json['supplier_name'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => ReceivingContainerManifestItem.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ReceivingContainerManifestImplToJson(
        _$ReceivingContainerManifestImpl instance) =>
    <String, dynamic>{
      'container_id': instance.containerId,
      'container_number': instance.containerNumber,
      'plate_number': instance.plateNumber,
      'status': instance.status,
      'source_warehouse_id': instance.sourceWarehouseId,
      'destination_warehouse_id': instance.destinationWarehouseId,
      'destination_warehouse_name': instance.destinationWarehouseName,
      'supplier_id': instance.supplierId,
      'supplier_name': instance.supplierName,
      'items': instance.items,
    };

_$ReceivingContainerManifestItemImpl
    _$$ReceivingContainerManifestItemImplFromJson(Map<String, dynamic> json) =>
        _$ReceivingContainerManifestItemImpl(
          poDetailId: (json['po_detail_id'] as num).toInt(),
          poHeaderId: (json['po_header_id'] as num).toInt(),
          poNumber: json['po_number'] as String,
          sku: json['sku'] as String,
          productName: json['product_name'] as String,
          plannedQty: (json['planned_qty'] as num).toDouble(),
          unit: json['unit'] as String,
        );

Map<String, dynamic> _$$ReceivingContainerManifestItemImplToJson(
        _$ReceivingContainerManifestItemImpl instance) =>
    <String, dynamic>{
      'po_detail_id': instance.poDetailId,
      'po_header_id': instance.poHeaderId,
      'po_number': instance.poNumber,
      'sku': instance.sku,
      'product_name': instance.productName,
      'planned_qty': instance.plannedQty,
      'unit': instance.unit,
    };

_$ContainerReceivingRequestImpl _$$ContainerReceivingRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ContainerReceivingRequestImpl(
      sourceWarehouseId: (json['source_warehouse_id'] as num).toInt(),
      destinationWarehouseId: (json['destination_warehouse_id'] as num).toInt(),
      containerNumber: json['container_number'] as String,
      plateNumber: json['plate_number'] as String?,
      driverName: json['driver_name'] as String?,
      manifest: (json['manifest'] as List<dynamic>)
          .map((e) =>
              ContainerGroupedManifest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ContainerReceivingRequestImplToJson(
        _$ContainerReceivingRequestImpl instance) =>
    <String, dynamic>{
      'source_warehouse_id': instance.sourceWarehouseId,
      'destination_warehouse_id': instance.destinationWarehouseId,
      'container_number': instance.containerNumber,
      'plate_number': instance.plateNumber,
      'driver_name': instance.driverName,
      'manifest': instance.manifest,
    };

_$ContainerGroupedManifestImpl _$$ContainerGroupedManifestImplFromJson(
        Map<String, dynamic> json) =>
    _$ContainerGroupedManifestImpl(
      poHeaderId: (json['po_header_id'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) =>
              ContainerReceivingItemRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ContainerGroupedManifestImplToJson(
        _$ContainerGroupedManifestImpl instance) =>
    <String, dynamic>{
      'po_header_id': instance.poHeaderId,
      'items': instance.items,
    };

_$ContainerReceivingItemRequestImpl
    _$$ContainerReceivingItemRequestImplFromJson(Map<String, dynamic> json) =>
        _$ContainerReceivingItemRequestImpl(
          poDetailId: (json['po_detail_id'] as num).toInt(),
          receivedQty: (json['received_qty'] as num).toDouble(),
          unit: json['unit'] as String,
          conversion: (json['conversion'] as num?)?.toInt() ?? 1,
        );

Map<String, dynamic> _$$ContainerReceivingItemRequestImplToJson(
        _$ContainerReceivingItemRequestImpl instance) =>
    <String, dynamic>{
      'po_detail_id': instance.poDetailId,
      'received_qty': instance.receivedQty,
      'unit': instance.unit,
      'conversion': instance.conversion,
    };
