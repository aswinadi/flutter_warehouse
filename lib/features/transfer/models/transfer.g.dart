// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransferProductImpl _$$TransferProductImplFromJson(
        Map<String, dynamic> json) =>
    _$TransferProductImpl(
      id: (json['id'] as num).toInt(),
      sku: json['sku'] as String,
      name: json['name'] as String,
      unit: json['unit'] as String?,
    );

Map<String, dynamic> _$$TransferProductImplToJson(
        _$TransferProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'name': instance.name,
      'unit': instance.unit,
    };

_$TransferItemImpl _$$TransferItemImplFromJson(Map<String, dynamic> json) =>
    _$TransferItemImpl(
      id: (json['id'] as num).toInt(),
      warehouseTransferId: (json['warehouse_transfer_id'] as num).toInt(),
      productId: (json['product_id'] as num?)?.toInt(),
      product: json['product'] == null
          ? null
          : TransferProduct.fromJson(json['product'] as Map<String, dynamic>),
      qtySent: doubleFromJson(json['qty_sent']),
      qtyReceived: doubleOrNullFromJson(json['qty_received']),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$TransferItemImplToJson(_$TransferItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'warehouse_transfer_id': instance.warehouseTransferId,
      'product_id': instance.productId,
      'product': instance.product,
      'qty_sent': instance.qtySent,
      'qty_received': instance.qtyReceived,
      'notes': instance.notes,
    };

_$WarehouseTransferImpl _$$WarehouseTransferImplFromJson(
        Map<String, dynamic> json) =>
    _$WarehouseTransferImpl(
      id: (json['id'] as num).toInt(),
      transferNumber: json['transfer_number'] as String,
      sourceWarehouseId: (json['source_warehouse_id'] as num).toInt(),
      sourceWarehouse: json['source_warehouse'] == null
          ? null
          : Warehouse.fromJson(
              json['source_warehouse'] as Map<String, dynamic>),
      destinationWarehouseId: (json['destination_warehouse_id'] as num).toInt(),
      destinationWarehouse: json['destination_warehouse'] == null
          ? null
          : Warehouse.fromJson(
              json['destination_warehouse'] as Map<String, dynamic>),
      transferDate: json['transfer_date'] as String,
      status: json['status'] as String,
      doNumber: json['do_number'] as String?,
      driverName: json['driver_name'] as String?,
      vehiclePlate: json['vehicle_plate'] as String?,
      notes: json['notes'] as String?,
      pdfUrl: json['pdf_url'] as String?,
      shippedBy: json['shipped_by'],
      shippedAt: json['shipped_at'] as String?,
      receivedBy: json['received_by'],
      receivedAt: json['received_at'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => TransferItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$WarehouseTransferImplToJson(
        _$WarehouseTransferImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transfer_number': instance.transferNumber,
      'source_warehouse_id': instance.sourceWarehouseId,
      'source_warehouse': instance.sourceWarehouse,
      'destination_warehouse_id': instance.destinationWarehouseId,
      'destination_warehouse': instance.destinationWarehouse,
      'transfer_date': instance.transferDate,
      'status': instance.status,
      'do_number': instance.doNumber,
      'driver_name': instance.driverName,
      'vehicle_plate': instance.vehiclePlate,
      'notes': instance.notes,
      'pdf_url': instance.pdfUrl,
      'shipped_by': instance.shippedBy,
      'shipped_at': instance.shippedAt,
      'received_by': instance.receivedBy,
      'received_at': instance.receivedAt,
      'items': instance.items,
    };

_$CreateTransferRequestImpl _$$CreateTransferRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateTransferRequestImpl(
      destinationWarehouseId: (json['destination_warehouse_id'] as num).toInt(),
      driverName: json['driver_name'] as String?,
      vehiclePlate: json['vehicle_plate'] as String?,
      notes: json['notes'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) =>
              CreateTransferItemRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CreateTransferRequestImplToJson(
        _$CreateTransferRequestImpl instance) =>
    <String, dynamic>{
      'destination_warehouse_id': instance.destinationWarehouseId,
      'driver_name': instance.driverName,
      'vehicle_plate': instance.vehiclePlate,
      'notes': instance.notes,
      'items': instance.items,
    };

_$CreateTransferItemRequestImpl _$$CreateTransferItemRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateTransferItemRequestImpl(
      inventoryId: (json['inventory_id'] as num).toInt(),
      quantity: doubleFromJson(json['quantity']),
    );

Map<String, dynamic> _$$CreateTransferItemRequestImplToJson(
        _$CreateTransferItemRequestImpl instance) =>
    <String, dynamic>{
      'inventory_id': instance.inventoryId,
      'quantity': instance.quantity,
    };

_$ReceiveTransferRequestImpl _$$ReceiveTransferRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ReceiveTransferRequestImpl(
      items: (json['items'] as List<dynamic>)
          .map((e) =>
              ReceiveTransferItemRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ReceiveTransferRequestImplToJson(
        _$ReceiveTransferRequestImpl instance) =>
    <String, dynamic>{
      'items': instance.items,
    };

_$ReceiveTransferItemRequestImpl _$$ReceiveTransferItemRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ReceiveTransferItemRequestImpl(
      transferItemId: (json['transfer_item_id'] as num).toInt(),
      qtyReceived: doubleFromJson(json['qty_received']),
    );

Map<String, dynamic> _$$ReceiveTransferItemRequestImplToJson(
        _$ReceiveTransferItemRequestImpl instance) =>
    <String, dynamic>{
      'transfer_item_id': instance.transferItemId,
      'qty_received': instance.qtyReceived,
    };
