// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransferProduct _$TransferProductFromJson(Map<String, dynamic> json) {
  return _TransferProduct.fromJson(json);
}

/// @nodoc
mixin _$TransferProduct {
  int get id => throw _privateConstructorUsedError;
  String get sku => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransferProductCopyWith<TransferProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferProductCopyWith<$Res> {
  factory $TransferProductCopyWith(
          TransferProduct value, $Res Function(TransferProduct) then) =
      _$TransferProductCopyWithImpl<$Res, TransferProduct>;
  @useResult
  $Res call({int id, String sku, String name, String? unit});
}

/// @nodoc
class _$TransferProductCopyWithImpl<$Res, $Val extends TransferProduct>
    implements $TransferProductCopyWith<$Res> {
  _$TransferProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sku = null,
    Object? name = null,
    Object? unit = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransferProductImplCopyWith<$Res>
    implements $TransferProductCopyWith<$Res> {
  factory _$$TransferProductImplCopyWith(_$TransferProductImpl value,
          $Res Function(_$TransferProductImpl) then) =
      __$$TransferProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String sku, String name, String? unit});
}

/// @nodoc
class __$$TransferProductImplCopyWithImpl<$Res>
    extends _$TransferProductCopyWithImpl<$Res, _$TransferProductImpl>
    implements _$$TransferProductImplCopyWith<$Res> {
  __$$TransferProductImplCopyWithImpl(
      _$TransferProductImpl _value, $Res Function(_$TransferProductImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sku = null,
    Object? name = null,
    Object? unit = freezed,
  }) {
    return _then(_$TransferProductImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferProductImpl implements _TransferProduct {
  const _$TransferProductImpl(
      {required this.id, required this.sku, required this.name, this.unit});

  factory _$TransferProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferProductImplFromJson(json);

  @override
  final int id;
  @override
  final String sku;
  @override
  final String name;
  @override
  final String? unit;

  @override
  String toString() {
    return 'TransferProduct(id: $id, sku: $sku, name: $name, unit: $unit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.unit, unit) || other.unit == unit));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, sku, name, unit);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferProductImplCopyWith<_$TransferProductImpl> get copyWith =>
      __$$TransferProductImplCopyWithImpl<_$TransferProductImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferProductImplToJson(
      this,
    );
  }
}

abstract class _TransferProduct implements TransferProduct {
  const factory _TransferProduct(
      {required final int id,
      required final String sku,
      required final String name,
      final String? unit}) = _$TransferProductImpl;

  factory _TransferProduct.fromJson(Map<String, dynamic> json) =
      _$TransferProductImpl.fromJson;

  @override
  int get id;
  @override
  String get sku;
  @override
  String get name;
  @override
  String? get unit;
  @override
  @JsonKey(ignore: true)
  _$$TransferProductImplCopyWith<_$TransferProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransferItem _$TransferItemFromJson(Map<String, dynamic> json) {
  return _TransferItem.fromJson(json);
}

/// @nodoc
mixin _$TransferItem {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'warehouse_transfer_id')
  int get warehouseTransferId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  int? get productId => throw _privateConstructorUsedError;
  TransferProduct? get product => throw _privateConstructorUsedError;
  @JsonKey(name: 'qty_sent', fromJson: doubleFromJson)
  double get qtySent => throw _privateConstructorUsedError;
  @JsonKey(name: 'qty_received', fromJson: doubleOrNullFromJson)
  double? get qtyReceived => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransferItemCopyWith<TransferItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferItemCopyWith<$Res> {
  factory $TransferItemCopyWith(
          TransferItem value, $Res Function(TransferItem) then) =
      _$TransferItemCopyWithImpl<$Res, TransferItem>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'warehouse_transfer_id') int warehouseTransferId,
      @JsonKey(name: 'product_id') int? productId,
      TransferProduct? product,
      @JsonKey(name: 'qty_sent', fromJson: doubleFromJson) double qtySent,
      @JsonKey(name: 'qty_received', fromJson: doubleOrNullFromJson)
      double? qtyReceived,
      String? notes});

  $TransferProductCopyWith<$Res>? get product;
}

/// @nodoc
class _$TransferItemCopyWithImpl<$Res, $Val extends TransferItem>
    implements $TransferItemCopyWith<$Res> {
  _$TransferItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? warehouseTransferId = null,
    Object? productId = freezed,
    Object? product = freezed,
    Object? qtySent = null,
    Object? qtyReceived = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      warehouseTransferId: null == warehouseTransferId
          ? _value.warehouseTransferId
          : warehouseTransferId // ignore: cast_nullable_to_non_nullable
              as int,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
      product: freezed == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as TransferProduct?,
      qtySent: null == qtySent
          ? _value.qtySent
          : qtySent // ignore: cast_nullable_to_non_nullable
              as double,
      qtyReceived: freezed == qtyReceived
          ? _value.qtyReceived
          : qtyReceived // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TransferProductCopyWith<$Res>? get product {
    if (_value.product == null) {
      return null;
    }

    return $TransferProductCopyWith<$Res>(_value.product!, (value) {
      return _then(_value.copyWith(product: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TransferItemImplCopyWith<$Res>
    implements $TransferItemCopyWith<$Res> {
  factory _$$TransferItemImplCopyWith(
          _$TransferItemImpl value, $Res Function(_$TransferItemImpl) then) =
      __$$TransferItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'warehouse_transfer_id') int warehouseTransferId,
      @JsonKey(name: 'product_id') int? productId,
      TransferProduct? product,
      @JsonKey(name: 'qty_sent', fromJson: doubleFromJson) double qtySent,
      @JsonKey(name: 'qty_received', fromJson: doubleOrNullFromJson)
      double? qtyReceived,
      String? notes});

  @override
  $TransferProductCopyWith<$Res>? get product;
}

/// @nodoc
class __$$TransferItemImplCopyWithImpl<$Res>
    extends _$TransferItemCopyWithImpl<$Res, _$TransferItemImpl>
    implements _$$TransferItemImplCopyWith<$Res> {
  __$$TransferItemImplCopyWithImpl(
      _$TransferItemImpl _value, $Res Function(_$TransferItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? warehouseTransferId = null,
    Object? productId = freezed,
    Object? product = freezed,
    Object? qtySent = null,
    Object? qtyReceived = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$TransferItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      warehouseTransferId: null == warehouseTransferId
          ? _value.warehouseTransferId
          : warehouseTransferId // ignore: cast_nullable_to_non_nullable
              as int,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
      product: freezed == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as TransferProduct?,
      qtySent: null == qtySent
          ? _value.qtySent
          : qtySent // ignore: cast_nullable_to_non_nullable
              as double,
      qtyReceived: freezed == qtyReceived
          ? _value.qtyReceived
          : qtyReceived // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferItemImpl implements _TransferItem {
  const _$TransferItemImpl(
      {required this.id,
      @JsonKey(name: 'warehouse_transfer_id') required this.warehouseTransferId,
      @JsonKey(name: 'product_id') this.productId,
      this.product,
      @JsonKey(name: 'qty_sent', fromJson: doubleFromJson)
      required this.qtySent,
      @JsonKey(name: 'qty_received', fromJson: doubleOrNullFromJson)
      this.qtyReceived,
      this.notes});

  factory _$TransferItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferItemImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'warehouse_transfer_id')
  final int warehouseTransferId;
  @override
  @JsonKey(name: 'product_id')
  final int? productId;
  @override
  final TransferProduct? product;
  @override
  @JsonKey(name: 'qty_sent', fromJson: doubleFromJson)
  final double qtySent;
  @override
  @JsonKey(name: 'qty_received', fromJson: doubleOrNullFromJson)
  final double? qtyReceived;
  @override
  final String? notes;

  @override
  String toString() {
    return 'TransferItem(id: $id, warehouseTransferId: $warehouseTransferId, productId: $productId, product: $product, qtySent: $qtySent, qtyReceived: $qtyReceived, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.warehouseTransferId, warehouseTransferId) ||
                other.warehouseTransferId == warehouseTransferId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.qtySent, qtySent) || other.qtySent == qtySent) &&
            (identical(other.qtyReceived, qtyReceived) ||
                other.qtyReceived == qtyReceived) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, warehouseTransferId,
      productId, product, qtySent, qtyReceived, notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferItemImplCopyWith<_$TransferItemImpl> get copyWith =>
      __$$TransferItemImplCopyWithImpl<_$TransferItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferItemImplToJson(
      this,
    );
  }
}

abstract class _TransferItem implements TransferItem {
  const factory _TransferItem(
      {required final int id,
      @JsonKey(name: 'warehouse_transfer_id')
      required final int warehouseTransferId,
      @JsonKey(name: 'product_id') final int? productId,
      final TransferProduct? product,
      @JsonKey(name: 'qty_sent', fromJson: doubleFromJson)
      required final double qtySent,
      @JsonKey(name: 'qty_received', fromJson: doubleOrNullFromJson)
      final double? qtyReceived,
      final String? notes}) = _$TransferItemImpl;

  factory _TransferItem.fromJson(Map<String, dynamic> json) =
      _$TransferItemImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'warehouse_transfer_id')
  int get warehouseTransferId;
  @override
  @JsonKey(name: 'product_id')
  int? get productId;
  @override
  TransferProduct? get product;
  @override
  @JsonKey(name: 'qty_sent', fromJson: doubleFromJson)
  double get qtySent;
  @override
  @JsonKey(name: 'qty_received', fromJson: doubleOrNullFromJson)
  double? get qtyReceived;
  @override
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$TransferItemImplCopyWith<_$TransferItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WarehouseTransfer _$WarehouseTransferFromJson(Map<String, dynamic> json) {
  return _WarehouseTransfer.fromJson(json);
}

/// @nodoc
mixin _$WarehouseTransfer {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'transfer_number')
  String get transferNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'source_warehouse_id')
  int get sourceWarehouseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'source_warehouse')
  Warehouse? get sourceWarehouse => throw _privateConstructorUsedError;
  @JsonKey(name: 'destination_warehouse_id')
  int get destinationWarehouseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'destination_warehouse')
  Warehouse? get destinationWarehouse => throw _privateConstructorUsedError;
  @JsonKey(name: 'transfer_date')
  String get transferDate => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'do_number')
  String? get doNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'driver_name')
  String? get driverName => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_plate')
  String? get vehiclePlate => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'pdf_url')
  String? get pdfUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipped_by')
  dynamic get shippedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipped_at')
  String? get shippedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'received_by')
  dynamic get receivedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'received_at')
  String? get receivedAt => throw _privateConstructorUsedError;
  List<TransferItem>? get items => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WarehouseTransferCopyWith<WarehouseTransfer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WarehouseTransferCopyWith<$Res> {
  factory $WarehouseTransferCopyWith(
          WarehouseTransfer value, $Res Function(WarehouseTransfer) then) =
      _$WarehouseTransferCopyWithImpl<$Res, WarehouseTransfer>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'transfer_number') String transferNumber,
      @JsonKey(name: 'source_warehouse_id') int sourceWarehouseId,
      @JsonKey(name: 'source_warehouse') Warehouse? sourceWarehouse,
      @JsonKey(name: 'destination_warehouse_id') int destinationWarehouseId,
      @JsonKey(name: 'destination_warehouse') Warehouse? destinationWarehouse,
      @JsonKey(name: 'transfer_date') String transferDate,
      String status,
      @JsonKey(name: 'do_number') String? doNumber,
      @JsonKey(name: 'driver_name') String? driverName,
      @JsonKey(name: 'vehicle_plate') String? vehiclePlate,
      String? notes,
      @JsonKey(name: 'pdf_url') String? pdfUrl,
      @JsonKey(name: 'shipped_by') dynamic shippedBy,
      @JsonKey(name: 'shipped_at') String? shippedAt,
      @JsonKey(name: 'received_by') dynamic receivedBy,
      @JsonKey(name: 'received_at') String? receivedAt,
      List<TransferItem>? items});

  $WarehouseCopyWith<$Res>? get sourceWarehouse;
  $WarehouseCopyWith<$Res>? get destinationWarehouse;
}

/// @nodoc
class _$WarehouseTransferCopyWithImpl<$Res, $Val extends WarehouseTransfer>
    implements $WarehouseTransferCopyWith<$Res> {
  _$WarehouseTransferCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? transferNumber = null,
    Object? sourceWarehouseId = null,
    Object? sourceWarehouse = freezed,
    Object? destinationWarehouseId = null,
    Object? destinationWarehouse = freezed,
    Object? transferDate = null,
    Object? status = null,
    Object? doNumber = freezed,
    Object? driverName = freezed,
    Object? vehiclePlate = freezed,
    Object? notes = freezed,
    Object? pdfUrl = freezed,
    Object? shippedBy = freezed,
    Object? shippedAt = freezed,
    Object? receivedBy = freezed,
    Object? receivedAt = freezed,
    Object? items = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      transferNumber: null == transferNumber
          ? _value.transferNumber
          : transferNumber // ignore: cast_nullable_to_non_nullable
              as String,
      sourceWarehouseId: null == sourceWarehouseId
          ? _value.sourceWarehouseId
          : sourceWarehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      sourceWarehouse: freezed == sourceWarehouse
          ? _value.sourceWarehouse
          : sourceWarehouse // ignore: cast_nullable_to_non_nullable
              as Warehouse?,
      destinationWarehouseId: null == destinationWarehouseId
          ? _value.destinationWarehouseId
          : destinationWarehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      destinationWarehouse: freezed == destinationWarehouse
          ? _value.destinationWarehouse
          : destinationWarehouse // ignore: cast_nullable_to_non_nullable
              as Warehouse?,
      transferDate: null == transferDate
          ? _value.transferDate
          : transferDate // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      doNumber: freezed == doNumber
          ? _value.doNumber
          : doNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      driverName: freezed == driverName
          ? _value.driverName
          : driverName // ignore: cast_nullable_to_non_nullable
              as String?,
      vehiclePlate: freezed == vehiclePlate
          ? _value.vehiclePlate
          : vehiclePlate // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      pdfUrl: freezed == pdfUrl
          ? _value.pdfUrl
          : pdfUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      shippedBy: freezed == shippedBy
          ? _value.shippedBy
          : shippedBy // ignore: cast_nullable_to_non_nullable
              as dynamic,
      shippedAt: freezed == shippedAt
          ? _value.shippedAt
          : shippedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      receivedBy: freezed == receivedBy
          ? _value.receivedBy
          : receivedBy // ignore: cast_nullable_to_non_nullable
              as dynamic,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      items: freezed == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TransferItem>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $WarehouseCopyWith<$Res>? get sourceWarehouse {
    if (_value.sourceWarehouse == null) {
      return null;
    }

    return $WarehouseCopyWith<$Res>(_value.sourceWarehouse!, (value) {
      return _then(_value.copyWith(sourceWarehouse: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $WarehouseCopyWith<$Res>? get destinationWarehouse {
    if (_value.destinationWarehouse == null) {
      return null;
    }

    return $WarehouseCopyWith<$Res>(_value.destinationWarehouse!, (value) {
      return _then(_value.copyWith(destinationWarehouse: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WarehouseTransferImplCopyWith<$Res>
    implements $WarehouseTransferCopyWith<$Res> {
  factory _$$WarehouseTransferImplCopyWith(_$WarehouseTransferImpl value,
          $Res Function(_$WarehouseTransferImpl) then) =
      __$$WarehouseTransferImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'transfer_number') String transferNumber,
      @JsonKey(name: 'source_warehouse_id') int sourceWarehouseId,
      @JsonKey(name: 'source_warehouse') Warehouse? sourceWarehouse,
      @JsonKey(name: 'destination_warehouse_id') int destinationWarehouseId,
      @JsonKey(name: 'destination_warehouse') Warehouse? destinationWarehouse,
      @JsonKey(name: 'transfer_date') String transferDate,
      String status,
      @JsonKey(name: 'do_number') String? doNumber,
      @JsonKey(name: 'driver_name') String? driverName,
      @JsonKey(name: 'vehicle_plate') String? vehiclePlate,
      String? notes,
      @JsonKey(name: 'pdf_url') String? pdfUrl,
      @JsonKey(name: 'shipped_by') dynamic shippedBy,
      @JsonKey(name: 'shipped_at') String? shippedAt,
      @JsonKey(name: 'received_by') dynamic receivedBy,
      @JsonKey(name: 'received_at') String? receivedAt,
      List<TransferItem>? items});

  @override
  $WarehouseCopyWith<$Res>? get sourceWarehouse;
  @override
  $WarehouseCopyWith<$Res>? get destinationWarehouse;
}

/// @nodoc
class __$$WarehouseTransferImplCopyWithImpl<$Res>
    extends _$WarehouseTransferCopyWithImpl<$Res, _$WarehouseTransferImpl>
    implements _$$WarehouseTransferImplCopyWith<$Res> {
  __$$WarehouseTransferImplCopyWithImpl(_$WarehouseTransferImpl _value,
      $Res Function(_$WarehouseTransferImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? transferNumber = null,
    Object? sourceWarehouseId = null,
    Object? sourceWarehouse = freezed,
    Object? destinationWarehouseId = null,
    Object? destinationWarehouse = freezed,
    Object? transferDate = null,
    Object? status = null,
    Object? doNumber = freezed,
    Object? driverName = freezed,
    Object? vehiclePlate = freezed,
    Object? notes = freezed,
    Object? pdfUrl = freezed,
    Object? shippedBy = freezed,
    Object? shippedAt = freezed,
    Object? receivedBy = freezed,
    Object? receivedAt = freezed,
    Object? items = freezed,
  }) {
    return _then(_$WarehouseTransferImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      transferNumber: null == transferNumber
          ? _value.transferNumber
          : transferNumber // ignore: cast_nullable_to_non_nullable
              as String,
      sourceWarehouseId: null == sourceWarehouseId
          ? _value.sourceWarehouseId
          : sourceWarehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      sourceWarehouse: freezed == sourceWarehouse
          ? _value.sourceWarehouse
          : sourceWarehouse // ignore: cast_nullable_to_non_nullable
              as Warehouse?,
      destinationWarehouseId: null == destinationWarehouseId
          ? _value.destinationWarehouseId
          : destinationWarehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      destinationWarehouse: freezed == destinationWarehouse
          ? _value.destinationWarehouse
          : destinationWarehouse // ignore: cast_nullable_to_non_nullable
              as Warehouse?,
      transferDate: null == transferDate
          ? _value.transferDate
          : transferDate // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      doNumber: freezed == doNumber
          ? _value.doNumber
          : doNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      driverName: freezed == driverName
          ? _value.driverName
          : driverName // ignore: cast_nullable_to_non_nullable
              as String?,
      vehiclePlate: freezed == vehiclePlate
          ? _value.vehiclePlate
          : vehiclePlate // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      pdfUrl: freezed == pdfUrl
          ? _value.pdfUrl
          : pdfUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      shippedBy: freezed == shippedBy
          ? _value.shippedBy
          : shippedBy // ignore: cast_nullable_to_non_nullable
              as dynamic,
      shippedAt: freezed == shippedAt
          ? _value.shippedAt
          : shippedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      receivedBy: freezed == receivedBy
          ? _value.receivedBy
          : receivedBy // ignore: cast_nullable_to_non_nullable
              as dynamic,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      items: freezed == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TransferItem>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WarehouseTransferImpl implements _WarehouseTransfer {
  const _$WarehouseTransferImpl(
      {required this.id,
      @JsonKey(name: 'transfer_number') required this.transferNumber,
      @JsonKey(name: 'source_warehouse_id') required this.sourceWarehouseId,
      @JsonKey(name: 'source_warehouse') this.sourceWarehouse,
      @JsonKey(name: 'destination_warehouse_id')
      required this.destinationWarehouseId,
      @JsonKey(name: 'destination_warehouse') this.destinationWarehouse,
      @JsonKey(name: 'transfer_date') required this.transferDate,
      required this.status,
      @JsonKey(name: 'do_number') this.doNumber,
      @JsonKey(name: 'driver_name') this.driverName,
      @JsonKey(name: 'vehicle_plate') this.vehiclePlate,
      this.notes,
      @JsonKey(name: 'pdf_url') this.pdfUrl,
      @JsonKey(name: 'shipped_by') this.shippedBy,
      @JsonKey(name: 'shipped_at') this.shippedAt,
      @JsonKey(name: 'received_by') this.receivedBy,
      @JsonKey(name: 'received_at') this.receivedAt,
      final List<TransferItem>? items})
      : _items = items;

  factory _$WarehouseTransferImpl.fromJson(Map<String, dynamic> json) =>
      _$$WarehouseTransferImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'transfer_number')
  final String transferNumber;
  @override
  @JsonKey(name: 'source_warehouse_id')
  final int sourceWarehouseId;
  @override
  @JsonKey(name: 'source_warehouse')
  final Warehouse? sourceWarehouse;
  @override
  @JsonKey(name: 'destination_warehouse_id')
  final int destinationWarehouseId;
  @override
  @JsonKey(name: 'destination_warehouse')
  final Warehouse? destinationWarehouse;
  @override
  @JsonKey(name: 'transfer_date')
  final String transferDate;
  @override
  final String status;
  @override
  @JsonKey(name: 'do_number')
  final String? doNumber;
  @override
  @JsonKey(name: 'driver_name')
  final String? driverName;
  @override
  @JsonKey(name: 'vehicle_plate')
  final String? vehiclePlate;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'pdf_url')
  final String? pdfUrl;
  @override
  @JsonKey(name: 'shipped_by')
  final dynamic shippedBy;
  @override
  @JsonKey(name: 'shipped_at')
  final String? shippedAt;
  @override
  @JsonKey(name: 'received_by')
  final dynamic receivedBy;
  @override
  @JsonKey(name: 'received_at')
  final String? receivedAt;
  final List<TransferItem>? _items;
  @override
  List<TransferItem>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'WarehouseTransfer(id: $id, transferNumber: $transferNumber, sourceWarehouseId: $sourceWarehouseId, sourceWarehouse: $sourceWarehouse, destinationWarehouseId: $destinationWarehouseId, destinationWarehouse: $destinationWarehouse, transferDate: $transferDate, status: $status, doNumber: $doNumber, driverName: $driverName, vehiclePlate: $vehiclePlate, notes: $notes, pdfUrl: $pdfUrl, shippedBy: $shippedBy, shippedAt: $shippedAt, receivedBy: $receivedBy, receivedAt: $receivedAt, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WarehouseTransferImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.transferNumber, transferNumber) ||
                other.transferNumber == transferNumber) &&
            (identical(other.sourceWarehouseId, sourceWarehouseId) ||
                other.sourceWarehouseId == sourceWarehouseId) &&
            (identical(other.sourceWarehouse, sourceWarehouse) ||
                other.sourceWarehouse == sourceWarehouse) &&
            (identical(other.destinationWarehouseId, destinationWarehouseId) ||
                other.destinationWarehouseId == destinationWarehouseId) &&
            (identical(other.destinationWarehouse, destinationWarehouse) ||
                other.destinationWarehouse == destinationWarehouse) &&
            (identical(other.transferDate, transferDate) ||
                other.transferDate == transferDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.doNumber, doNumber) ||
                other.doNumber == doNumber) &&
            (identical(other.driverName, driverName) ||
                other.driverName == driverName) &&
            (identical(other.vehiclePlate, vehiclePlate) ||
                other.vehiclePlate == vehiclePlate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.pdfUrl, pdfUrl) || other.pdfUrl == pdfUrl) &&
            const DeepCollectionEquality().equals(other.shippedBy, shippedBy) &&
            (identical(other.shippedAt, shippedAt) ||
                other.shippedAt == shippedAt) &&
            const DeepCollectionEquality()
                .equals(other.receivedBy, receivedBy) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      transferNumber,
      sourceWarehouseId,
      sourceWarehouse,
      destinationWarehouseId,
      destinationWarehouse,
      transferDate,
      status,
      doNumber,
      driverName,
      vehiclePlate,
      notes,
      pdfUrl,
      const DeepCollectionEquality().hash(shippedBy),
      shippedAt,
      const DeepCollectionEquality().hash(receivedBy),
      receivedAt,
      const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WarehouseTransferImplCopyWith<_$WarehouseTransferImpl> get copyWith =>
      __$$WarehouseTransferImplCopyWithImpl<_$WarehouseTransferImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WarehouseTransferImplToJson(
      this,
    );
  }
}

abstract class _WarehouseTransfer implements WarehouseTransfer {
  const factory _WarehouseTransfer(
      {required final int id,
      @JsonKey(name: 'transfer_number') required final String transferNumber,
      @JsonKey(name: 'source_warehouse_id')
      required final int sourceWarehouseId,
      @JsonKey(name: 'source_warehouse') final Warehouse? sourceWarehouse,
      @JsonKey(name: 'destination_warehouse_id')
      required final int destinationWarehouseId,
      @JsonKey(name: 'destination_warehouse')
      final Warehouse? destinationWarehouse,
      @JsonKey(name: 'transfer_date') required final String transferDate,
      required final String status,
      @JsonKey(name: 'do_number') final String? doNumber,
      @JsonKey(name: 'driver_name') final String? driverName,
      @JsonKey(name: 'vehicle_plate') final String? vehiclePlate,
      final String? notes,
      @JsonKey(name: 'pdf_url') final String? pdfUrl,
      @JsonKey(name: 'shipped_by') final dynamic shippedBy,
      @JsonKey(name: 'shipped_at') final String? shippedAt,
      @JsonKey(name: 'received_by') final dynamic receivedBy,
      @JsonKey(name: 'received_at') final String? receivedAt,
      final List<TransferItem>? items}) = _$WarehouseTransferImpl;

  factory _WarehouseTransfer.fromJson(Map<String, dynamic> json) =
      _$WarehouseTransferImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'transfer_number')
  String get transferNumber;
  @override
  @JsonKey(name: 'source_warehouse_id')
  int get sourceWarehouseId;
  @override
  @JsonKey(name: 'source_warehouse')
  Warehouse? get sourceWarehouse;
  @override
  @JsonKey(name: 'destination_warehouse_id')
  int get destinationWarehouseId;
  @override
  @JsonKey(name: 'destination_warehouse')
  Warehouse? get destinationWarehouse;
  @override
  @JsonKey(name: 'transfer_date')
  String get transferDate;
  @override
  String get status;
  @override
  @JsonKey(name: 'do_number')
  String? get doNumber;
  @override
  @JsonKey(name: 'driver_name')
  String? get driverName;
  @override
  @JsonKey(name: 'vehicle_plate')
  String? get vehiclePlate;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'pdf_url')
  String? get pdfUrl;
  @override
  @JsonKey(name: 'shipped_by')
  dynamic get shippedBy;
  @override
  @JsonKey(name: 'shipped_at')
  String? get shippedAt;
  @override
  @JsonKey(name: 'received_by')
  dynamic get receivedBy;
  @override
  @JsonKey(name: 'received_at')
  String? get receivedAt;
  @override
  List<TransferItem>? get items;
  @override
  @JsonKey(ignore: true)
  _$$WarehouseTransferImplCopyWith<_$WarehouseTransferImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateTransferRequest _$CreateTransferRequestFromJson(
    Map<String, dynamic> json) {
  return _CreateTransferRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateTransferRequest {
  @JsonKey(name: 'destination_warehouse_id')
  int get destinationWarehouseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'driver_name')
  String? get driverName => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_plate')
  String? get vehiclePlate => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<CreateTransferItemRequest> get items =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateTransferRequestCopyWith<CreateTransferRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateTransferRequestCopyWith<$Res> {
  factory $CreateTransferRequestCopyWith(CreateTransferRequest value,
          $Res Function(CreateTransferRequest) then) =
      _$CreateTransferRequestCopyWithImpl<$Res, CreateTransferRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'destination_warehouse_id') int destinationWarehouseId,
      @JsonKey(name: 'driver_name') String? driverName,
      @JsonKey(name: 'vehicle_plate') String? vehiclePlate,
      String? notes,
      List<CreateTransferItemRequest> items});
}

/// @nodoc
class _$CreateTransferRequestCopyWithImpl<$Res,
        $Val extends CreateTransferRequest>
    implements $CreateTransferRequestCopyWith<$Res> {
  _$CreateTransferRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? destinationWarehouseId = null,
    Object? driverName = freezed,
    Object? vehiclePlate = freezed,
    Object? notes = freezed,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      destinationWarehouseId: null == destinationWarehouseId
          ? _value.destinationWarehouseId
          : destinationWarehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      driverName: freezed == driverName
          ? _value.driverName
          : driverName // ignore: cast_nullable_to_non_nullable
              as String?,
      vehiclePlate: freezed == vehiclePlate
          ? _value.vehiclePlate
          : vehiclePlate // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CreateTransferItemRequest>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateTransferRequestImplCopyWith<$Res>
    implements $CreateTransferRequestCopyWith<$Res> {
  factory _$$CreateTransferRequestImplCopyWith(
          _$CreateTransferRequestImpl value,
          $Res Function(_$CreateTransferRequestImpl) then) =
      __$$CreateTransferRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'destination_warehouse_id') int destinationWarehouseId,
      @JsonKey(name: 'driver_name') String? driverName,
      @JsonKey(name: 'vehicle_plate') String? vehiclePlate,
      String? notes,
      List<CreateTransferItemRequest> items});
}

/// @nodoc
class __$$CreateTransferRequestImplCopyWithImpl<$Res>
    extends _$CreateTransferRequestCopyWithImpl<$Res,
        _$CreateTransferRequestImpl>
    implements _$$CreateTransferRequestImplCopyWith<$Res> {
  __$$CreateTransferRequestImplCopyWithImpl(_$CreateTransferRequestImpl _value,
      $Res Function(_$CreateTransferRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? destinationWarehouseId = null,
    Object? driverName = freezed,
    Object? vehiclePlate = freezed,
    Object? notes = freezed,
    Object? items = null,
  }) {
    return _then(_$CreateTransferRequestImpl(
      destinationWarehouseId: null == destinationWarehouseId
          ? _value.destinationWarehouseId
          : destinationWarehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      driverName: freezed == driverName
          ? _value.driverName
          : driverName // ignore: cast_nullable_to_non_nullable
              as String?,
      vehiclePlate: freezed == vehiclePlate
          ? _value.vehiclePlate
          : vehiclePlate // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CreateTransferItemRequest>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateTransferRequestImpl implements _CreateTransferRequest {
  const _$CreateTransferRequestImpl(
      {@JsonKey(name: 'destination_warehouse_id')
      required this.destinationWarehouseId,
      @JsonKey(name: 'driver_name') this.driverName,
      @JsonKey(name: 'vehicle_plate') this.vehiclePlate,
      this.notes,
      required final List<CreateTransferItemRequest> items})
      : _items = items;

  factory _$CreateTransferRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateTransferRequestImplFromJson(json);

  @override
  @JsonKey(name: 'destination_warehouse_id')
  final int destinationWarehouseId;
  @override
  @JsonKey(name: 'driver_name')
  final String? driverName;
  @override
  @JsonKey(name: 'vehicle_plate')
  final String? vehiclePlate;
  @override
  final String? notes;
  final List<CreateTransferItemRequest> _items;
  @override
  List<CreateTransferItemRequest> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'CreateTransferRequest(destinationWarehouseId: $destinationWarehouseId, driverName: $driverName, vehiclePlate: $vehiclePlate, notes: $notes, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateTransferRequestImpl &&
            (identical(other.destinationWarehouseId, destinationWarehouseId) ||
                other.destinationWarehouseId == destinationWarehouseId) &&
            (identical(other.driverName, driverName) ||
                other.driverName == driverName) &&
            (identical(other.vehiclePlate, vehiclePlate) ||
                other.vehiclePlate == vehiclePlate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      destinationWarehouseId,
      driverName,
      vehiclePlate,
      notes,
      const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateTransferRequestImplCopyWith<_$CreateTransferRequestImpl>
      get copyWith => __$$CreateTransferRequestImplCopyWithImpl<
          _$CreateTransferRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateTransferRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateTransferRequest implements CreateTransferRequest {
  const factory _CreateTransferRequest(
          {@JsonKey(name: 'destination_warehouse_id')
          required final int destinationWarehouseId,
          @JsonKey(name: 'driver_name') final String? driverName,
          @JsonKey(name: 'vehicle_plate') final String? vehiclePlate,
          final String? notes,
          required final List<CreateTransferItemRequest> items}) =
      _$CreateTransferRequestImpl;

  factory _CreateTransferRequest.fromJson(Map<String, dynamic> json) =
      _$CreateTransferRequestImpl.fromJson;

  @override
  @JsonKey(name: 'destination_warehouse_id')
  int get destinationWarehouseId;
  @override
  @JsonKey(name: 'driver_name')
  String? get driverName;
  @override
  @JsonKey(name: 'vehicle_plate')
  String? get vehiclePlate;
  @override
  String? get notes;
  @override
  List<CreateTransferItemRequest> get items;
  @override
  @JsonKey(ignore: true)
  _$$CreateTransferRequestImplCopyWith<_$CreateTransferRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CreateTransferItemRequest _$CreateTransferItemRequestFromJson(
    Map<String, dynamic> json) {
  return _CreateTransferItemRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateTransferItemRequest {
  @JsonKey(name: 'inventory_id')
  int get inventoryId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: doubleFromJson)
  double get quantity => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateTransferItemRequestCopyWith<CreateTransferItemRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateTransferItemRequestCopyWith<$Res> {
  factory $CreateTransferItemRequestCopyWith(CreateTransferItemRequest value,
          $Res Function(CreateTransferItemRequest) then) =
      _$CreateTransferItemRequestCopyWithImpl<$Res, CreateTransferItemRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'inventory_id') int inventoryId,
      @JsonKey(fromJson: doubleFromJson) double quantity});
}

/// @nodoc
class _$CreateTransferItemRequestCopyWithImpl<$Res,
        $Val extends CreateTransferItemRequest>
    implements $CreateTransferItemRequestCopyWith<$Res> {
  _$CreateTransferItemRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inventoryId = null,
    Object? quantity = null,
  }) {
    return _then(_value.copyWith(
      inventoryId: null == inventoryId
          ? _value.inventoryId
          : inventoryId // ignore: cast_nullable_to_non_nullable
              as int,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateTransferItemRequestImplCopyWith<$Res>
    implements $CreateTransferItemRequestCopyWith<$Res> {
  factory _$$CreateTransferItemRequestImplCopyWith(
          _$CreateTransferItemRequestImpl value,
          $Res Function(_$CreateTransferItemRequestImpl) then) =
      __$$CreateTransferItemRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'inventory_id') int inventoryId,
      @JsonKey(fromJson: doubleFromJson) double quantity});
}

/// @nodoc
class __$$CreateTransferItemRequestImplCopyWithImpl<$Res>
    extends _$CreateTransferItemRequestCopyWithImpl<$Res,
        _$CreateTransferItemRequestImpl>
    implements _$$CreateTransferItemRequestImplCopyWith<$Res> {
  __$$CreateTransferItemRequestImplCopyWithImpl(
      _$CreateTransferItemRequestImpl _value,
      $Res Function(_$CreateTransferItemRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inventoryId = null,
    Object? quantity = null,
  }) {
    return _then(_$CreateTransferItemRequestImpl(
      inventoryId: null == inventoryId
          ? _value.inventoryId
          : inventoryId // ignore: cast_nullable_to_non_nullable
              as int,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateTransferItemRequestImpl implements _CreateTransferItemRequest {
  const _$CreateTransferItemRequestImpl(
      {@JsonKey(name: 'inventory_id') required this.inventoryId,
      @JsonKey(fromJson: doubleFromJson) required this.quantity});

  factory _$CreateTransferItemRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateTransferItemRequestImplFromJson(json);

  @override
  @JsonKey(name: 'inventory_id')
  final int inventoryId;
  @override
  @JsonKey(fromJson: doubleFromJson)
  final double quantity;

  @override
  String toString() {
    return 'CreateTransferItemRequest(inventoryId: $inventoryId, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateTransferItemRequestImpl &&
            (identical(other.inventoryId, inventoryId) ||
                other.inventoryId == inventoryId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, inventoryId, quantity);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateTransferItemRequestImplCopyWith<_$CreateTransferItemRequestImpl>
      get copyWith => __$$CreateTransferItemRequestImplCopyWithImpl<
          _$CreateTransferItemRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateTransferItemRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateTransferItemRequest implements CreateTransferItemRequest {
  const factory _CreateTransferItemRequest(
          {@JsonKey(name: 'inventory_id') required final int inventoryId,
          @JsonKey(fromJson: doubleFromJson) required final double quantity}) =
      _$CreateTransferItemRequestImpl;

  factory _CreateTransferItemRequest.fromJson(Map<String, dynamic> json) =
      _$CreateTransferItemRequestImpl.fromJson;

  @override
  @JsonKey(name: 'inventory_id')
  int get inventoryId;
  @override
  @JsonKey(fromJson: doubleFromJson)
  double get quantity;
  @override
  @JsonKey(ignore: true)
  _$$CreateTransferItemRequestImplCopyWith<_$CreateTransferItemRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ReceiveTransferRequest _$ReceiveTransferRequestFromJson(
    Map<String, dynamic> json) {
  return _ReceiveTransferRequest.fromJson(json);
}

/// @nodoc
mixin _$ReceiveTransferRequest {
  List<ReceiveTransferItemRequest> get items =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReceiveTransferRequestCopyWith<ReceiveTransferRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceiveTransferRequestCopyWith<$Res> {
  factory $ReceiveTransferRequestCopyWith(ReceiveTransferRequest value,
          $Res Function(ReceiveTransferRequest) then) =
      _$ReceiveTransferRequestCopyWithImpl<$Res, ReceiveTransferRequest>;
  @useResult
  $Res call({List<ReceiveTransferItemRequest> items});
}

/// @nodoc
class _$ReceiveTransferRequestCopyWithImpl<$Res,
        $Val extends ReceiveTransferRequest>
    implements $ReceiveTransferRequestCopyWith<$Res> {
  _$ReceiveTransferRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ReceiveTransferItemRequest>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReceiveTransferRequestImplCopyWith<$Res>
    implements $ReceiveTransferRequestCopyWith<$Res> {
  factory _$$ReceiveTransferRequestImplCopyWith(
          _$ReceiveTransferRequestImpl value,
          $Res Function(_$ReceiveTransferRequestImpl) then) =
      __$$ReceiveTransferRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ReceiveTransferItemRequest> items});
}

/// @nodoc
class __$$ReceiveTransferRequestImplCopyWithImpl<$Res>
    extends _$ReceiveTransferRequestCopyWithImpl<$Res,
        _$ReceiveTransferRequestImpl>
    implements _$$ReceiveTransferRequestImplCopyWith<$Res> {
  __$$ReceiveTransferRequestImplCopyWithImpl(
      _$ReceiveTransferRequestImpl _value,
      $Res Function(_$ReceiveTransferRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
  }) {
    return _then(_$ReceiveTransferRequestImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ReceiveTransferItemRequest>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReceiveTransferRequestImpl implements _ReceiveTransferRequest {
  const _$ReceiveTransferRequestImpl(
      {required final List<ReceiveTransferItemRequest> items})
      : _items = items;

  factory _$ReceiveTransferRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReceiveTransferRequestImplFromJson(json);

  final List<ReceiveTransferItemRequest> _items;
  @override
  List<ReceiveTransferItemRequest> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'ReceiveTransferRequest(items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceiveTransferRequestImpl &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceiveTransferRequestImplCopyWith<_$ReceiveTransferRequestImpl>
      get copyWith => __$$ReceiveTransferRequestImplCopyWithImpl<
          _$ReceiveTransferRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReceiveTransferRequestImplToJson(
      this,
    );
  }
}

abstract class _ReceiveTransferRequest implements ReceiveTransferRequest {
  const factory _ReceiveTransferRequest(
          {required final List<ReceiveTransferItemRequest> items}) =
      _$ReceiveTransferRequestImpl;

  factory _ReceiveTransferRequest.fromJson(Map<String, dynamic> json) =
      _$ReceiveTransferRequestImpl.fromJson;

  @override
  List<ReceiveTransferItemRequest> get items;
  @override
  @JsonKey(ignore: true)
  _$$ReceiveTransferRequestImplCopyWith<_$ReceiveTransferRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ReceiveTransferItemRequest _$ReceiveTransferItemRequestFromJson(
    Map<String, dynamic> json) {
  return _ReceiveTransferItemRequest.fromJson(json);
}

/// @nodoc
mixin _$ReceiveTransferItemRequest {
  @JsonKey(name: 'transfer_item_id')
  int get transferItemId => throw _privateConstructorUsedError;
  @JsonKey(name: 'qty_received', fromJson: doubleFromJson)
  double get qtyReceived => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReceiveTransferItemRequestCopyWith<ReceiveTransferItemRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceiveTransferItemRequestCopyWith<$Res> {
  factory $ReceiveTransferItemRequestCopyWith(ReceiveTransferItemRequest value,
          $Res Function(ReceiveTransferItemRequest) then) =
      _$ReceiveTransferItemRequestCopyWithImpl<$Res,
          ReceiveTransferItemRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'transfer_item_id') int transferItemId,
      @JsonKey(name: 'qty_received', fromJson: doubleFromJson)
      double qtyReceived});
}

/// @nodoc
class _$ReceiveTransferItemRequestCopyWithImpl<$Res,
        $Val extends ReceiveTransferItemRequest>
    implements $ReceiveTransferItemRequestCopyWith<$Res> {
  _$ReceiveTransferItemRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transferItemId = null,
    Object? qtyReceived = null,
  }) {
    return _then(_value.copyWith(
      transferItemId: null == transferItemId
          ? _value.transferItemId
          : transferItemId // ignore: cast_nullable_to_non_nullable
              as int,
      qtyReceived: null == qtyReceived
          ? _value.qtyReceived
          : qtyReceived // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReceiveTransferItemRequestImplCopyWith<$Res>
    implements $ReceiveTransferItemRequestCopyWith<$Res> {
  factory _$$ReceiveTransferItemRequestImplCopyWith(
          _$ReceiveTransferItemRequestImpl value,
          $Res Function(_$ReceiveTransferItemRequestImpl) then) =
      __$$ReceiveTransferItemRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'transfer_item_id') int transferItemId,
      @JsonKey(name: 'qty_received', fromJson: doubleFromJson)
      double qtyReceived});
}

/// @nodoc
class __$$ReceiveTransferItemRequestImplCopyWithImpl<$Res>
    extends _$ReceiveTransferItemRequestCopyWithImpl<$Res,
        _$ReceiveTransferItemRequestImpl>
    implements _$$ReceiveTransferItemRequestImplCopyWith<$Res> {
  __$$ReceiveTransferItemRequestImplCopyWithImpl(
      _$ReceiveTransferItemRequestImpl _value,
      $Res Function(_$ReceiveTransferItemRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transferItemId = null,
    Object? qtyReceived = null,
  }) {
    return _then(_$ReceiveTransferItemRequestImpl(
      transferItemId: null == transferItemId
          ? _value.transferItemId
          : transferItemId // ignore: cast_nullable_to_non_nullable
              as int,
      qtyReceived: null == qtyReceived
          ? _value.qtyReceived
          : qtyReceived // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReceiveTransferItemRequestImpl implements _ReceiveTransferItemRequest {
  const _$ReceiveTransferItemRequestImpl(
      {@JsonKey(name: 'transfer_item_id') required this.transferItemId,
      @JsonKey(name: 'qty_received', fromJson: doubleFromJson)
      required this.qtyReceived});

  factory _$ReceiveTransferItemRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ReceiveTransferItemRequestImplFromJson(json);

  @override
  @JsonKey(name: 'transfer_item_id')
  final int transferItemId;
  @override
  @JsonKey(name: 'qty_received', fromJson: doubleFromJson)
  final double qtyReceived;

  @override
  String toString() {
    return 'ReceiveTransferItemRequest(transferItemId: $transferItemId, qtyReceived: $qtyReceived)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceiveTransferItemRequestImpl &&
            (identical(other.transferItemId, transferItemId) ||
                other.transferItemId == transferItemId) &&
            (identical(other.qtyReceived, qtyReceived) ||
                other.qtyReceived == qtyReceived));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, transferItemId, qtyReceived);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceiveTransferItemRequestImplCopyWith<_$ReceiveTransferItemRequestImpl>
      get copyWith => __$$ReceiveTransferItemRequestImplCopyWithImpl<
          _$ReceiveTransferItemRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReceiveTransferItemRequestImplToJson(
      this,
    );
  }
}

abstract class _ReceiveTransferItemRequest
    implements ReceiveTransferItemRequest {
  const factory _ReceiveTransferItemRequest(
      {@JsonKey(name: 'transfer_item_id') required final int transferItemId,
      @JsonKey(name: 'qty_received', fromJson: doubleFromJson)
      required final double qtyReceived}) = _$ReceiveTransferItemRequestImpl;

  factory _ReceiveTransferItemRequest.fromJson(Map<String, dynamic> json) =
      _$ReceiveTransferItemRequestImpl.fromJson;

  @override
  @JsonKey(name: 'transfer_item_id')
  int get transferItemId;
  @override
  @JsonKey(name: 'qty_received', fromJson: doubleFromJson)
  double get qtyReceived;
  @override
  @JsonKey(ignore: true)
  _$$ReceiveTransferItemRequestImplCopyWith<_$ReceiveTransferItemRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
