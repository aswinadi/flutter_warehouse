// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'packing_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PackingList _$PackingListFromJson(Map<String, dynamic> json) {
  return _PackingList.fromJson(json);
}

/// @nodoc
mixin _$PackingList {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'container_number')
  String get containerNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'carrier_name')
  String? get carrierName => throw _privateConstructorUsedError;
  @JsonKey(name: 'plate_number')
  String? get plateNumber => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'source_warehouse_id')
  int? get sourceWarehouseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'source_warehouse_name')
  String? get sourceWarehouseName => throw _privateConstructorUsedError;
  @JsonKey(name: 'destination_warehouse_id')
  int? get destinationWarehouseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'destination_warehouse_name')
  String? get destinationWarehouseName => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_id')
  int? get supplierId => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_name')
  String? get supplierName => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_count')
  int get itemCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'estimated_departure')
  DateTime? get estimatedDeparture => throw _privateConstructorUsedError;
  @JsonKey(name: 'closing_date')
  DateTime? get closingDate => throw _privateConstructorUsedError;
  List<PackingListItem> get items => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PackingListCopyWith<PackingList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PackingListCopyWith<$Res> {
  factory $PackingListCopyWith(
          PackingList value, $Res Function(PackingList) then) =
      _$PackingListCopyWithImpl<$Res, PackingList>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'container_number') String containerNumber,
      @JsonKey(name: 'carrier_name') String? carrierName,
      @JsonKey(name: 'plate_number') String? plateNumber,
      String status,
      @JsonKey(name: 'source_warehouse_id') int? sourceWarehouseId,
      @JsonKey(name: 'source_warehouse_name') String? sourceWarehouseName,
      @JsonKey(name: 'destination_warehouse_id') int? destinationWarehouseId,
      @JsonKey(name: 'destination_warehouse_name')
      String? destinationWarehouseName,
      @JsonKey(name: 'supplier_id') int? supplierId,
      @JsonKey(name: 'supplier_name') String? supplierName,
      @JsonKey(name: 'item_count') int itemCount,
      @JsonKey(name: 'estimated_departure') DateTime? estimatedDeparture,
      @JsonKey(name: 'closing_date') DateTime? closingDate,
      List<PackingListItem> items});
}

/// @nodoc
class _$PackingListCopyWithImpl<$Res, $Val extends PackingList>
    implements $PackingListCopyWith<$Res> {
  _$PackingListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? containerNumber = null,
    Object? carrierName = freezed,
    Object? plateNumber = freezed,
    Object? status = null,
    Object? sourceWarehouseId = freezed,
    Object? sourceWarehouseName = freezed,
    Object? destinationWarehouseId = freezed,
    Object? destinationWarehouseName = freezed,
    Object? supplierId = freezed,
    Object? supplierName = freezed,
    Object? itemCount = null,
    Object? estimatedDeparture = freezed,
    Object? closingDate = freezed,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      containerNumber: null == containerNumber
          ? _value.containerNumber
          : containerNumber // ignore: cast_nullable_to_non_nullable
              as String,
      carrierName: freezed == carrierName
          ? _value.carrierName
          : carrierName // ignore: cast_nullable_to_non_nullable
              as String?,
      plateNumber: freezed == plateNumber
          ? _value.plateNumber
          : plateNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      sourceWarehouseId: freezed == sourceWarehouseId
          ? _value.sourceWarehouseId
          : sourceWarehouseId // ignore: cast_nullable_to_non_nullable
              as int?,
      sourceWarehouseName: freezed == sourceWarehouseName
          ? _value.sourceWarehouseName
          : sourceWarehouseName // ignore: cast_nullable_to_non_nullable
              as String?,
      destinationWarehouseId: freezed == destinationWarehouseId
          ? _value.destinationWarehouseId
          : destinationWarehouseId // ignore: cast_nullable_to_non_nullable
              as int?,
      destinationWarehouseName: freezed == destinationWarehouseName
          ? _value.destinationWarehouseName
          : destinationWarehouseName // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      itemCount: null == itemCount
          ? _value.itemCount
          : itemCount // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedDeparture: freezed == estimatedDeparture
          ? _value.estimatedDeparture
          : estimatedDeparture // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      closingDate: freezed == closingDate
          ? _value.closingDate
          : closingDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<PackingListItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PackingListImplCopyWith<$Res>
    implements $PackingListCopyWith<$Res> {
  factory _$$PackingListImplCopyWith(
          _$PackingListImpl value, $Res Function(_$PackingListImpl) then) =
      __$$PackingListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'container_number') String containerNumber,
      @JsonKey(name: 'carrier_name') String? carrierName,
      @JsonKey(name: 'plate_number') String? plateNumber,
      String status,
      @JsonKey(name: 'source_warehouse_id') int? sourceWarehouseId,
      @JsonKey(name: 'source_warehouse_name') String? sourceWarehouseName,
      @JsonKey(name: 'destination_warehouse_id') int? destinationWarehouseId,
      @JsonKey(name: 'destination_warehouse_name')
      String? destinationWarehouseName,
      @JsonKey(name: 'supplier_id') int? supplierId,
      @JsonKey(name: 'supplier_name') String? supplierName,
      @JsonKey(name: 'item_count') int itemCount,
      @JsonKey(name: 'estimated_departure') DateTime? estimatedDeparture,
      @JsonKey(name: 'closing_date') DateTime? closingDate,
      List<PackingListItem> items});
}

/// @nodoc
class __$$PackingListImplCopyWithImpl<$Res>
    extends _$PackingListCopyWithImpl<$Res, _$PackingListImpl>
    implements _$$PackingListImplCopyWith<$Res> {
  __$$PackingListImplCopyWithImpl(
      _$PackingListImpl _value, $Res Function(_$PackingListImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? containerNumber = null,
    Object? carrierName = freezed,
    Object? plateNumber = freezed,
    Object? status = null,
    Object? sourceWarehouseId = freezed,
    Object? sourceWarehouseName = freezed,
    Object? destinationWarehouseId = freezed,
    Object? destinationWarehouseName = freezed,
    Object? supplierId = freezed,
    Object? supplierName = freezed,
    Object? itemCount = null,
    Object? estimatedDeparture = freezed,
    Object? closingDate = freezed,
    Object? items = null,
  }) {
    return _then(_$PackingListImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      containerNumber: null == containerNumber
          ? _value.containerNumber
          : containerNumber // ignore: cast_nullable_to_non_nullable
              as String,
      carrierName: freezed == carrierName
          ? _value.carrierName
          : carrierName // ignore: cast_nullable_to_non_nullable
              as String?,
      plateNumber: freezed == plateNumber
          ? _value.plateNumber
          : plateNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      sourceWarehouseId: freezed == sourceWarehouseId
          ? _value.sourceWarehouseId
          : sourceWarehouseId // ignore: cast_nullable_to_non_nullable
              as int?,
      sourceWarehouseName: freezed == sourceWarehouseName
          ? _value.sourceWarehouseName
          : sourceWarehouseName // ignore: cast_nullable_to_non_nullable
              as String?,
      destinationWarehouseId: freezed == destinationWarehouseId
          ? _value.destinationWarehouseId
          : destinationWarehouseId // ignore: cast_nullable_to_non_nullable
              as int?,
      destinationWarehouseName: freezed == destinationWarehouseName
          ? _value.destinationWarehouseName
          : destinationWarehouseName // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      itemCount: null == itemCount
          ? _value.itemCount
          : itemCount // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedDeparture: freezed == estimatedDeparture
          ? _value.estimatedDeparture
          : estimatedDeparture // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      closingDate: freezed == closingDate
          ? _value.closingDate
          : closingDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<PackingListItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PackingListImpl implements _PackingList {
  const _$PackingListImpl(
      {required this.id,
      @JsonKey(name: 'container_number') required this.containerNumber,
      @JsonKey(name: 'carrier_name') this.carrierName,
      @JsonKey(name: 'plate_number') this.plateNumber,
      required this.status,
      @JsonKey(name: 'source_warehouse_id') this.sourceWarehouseId,
      @JsonKey(name: 'source_warehouse_name') this.sourceWarehouseName,
      @JsonKey(name: 'destination_warehouse_id') this.destinationWarehouseId,
      @JsonKey(name: 'destination_warehouse_name')
      this.destinationWarehouseName,
      @JsonKey(name: 'supplier_id') this.supplierId,
      @JsonKey(name: 'supplier_name') this.supplierName,
      @JsonKey(name: 'item_count') this.itemCount = 0,
      @JsonKey(name: 'estimated_departure') this.estimatedDeparture,
      @JsonKey(name: 'closing_date') this.closingDate,
      final List<PackingListItem> items = const []})
      : _items = items;

  factory _$PackingListImpl.fromJson(Map<String, dynamic> json) =>
      _$$PackingListImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'container_number')
  final String containerNumber;
  @override
  @JsonKey(name: 'carrier_name')
  final String? carrierName;
  @override
  @JsonKey(name: 'plate_number')
  final String? plateNumber;
  @override
  final String status;
  @override
  @JsonKey(name: 'source_warehouse_id')
  final int? sourceWarehouseId;
  @override
  @JsonKey(name: 'source_warehouse_name')
  final String? sourceWarehouseName;
  @override
  @JsonKey(name: 'destination_warehouse_id')
  final int? destinationWarehouseId;
  @override
  @JsonKey(name: 'destination_warehouse_name')
  final String? destinationWarehouseName;
  @override
  @JsonKey(name: 'supplier_id')
  final int? supplierId;
  @override
  @JsonKey(name: 'supplier_name')
  final String? supplierName;
  @override
  @JsonKey(name: 'item_count')
  final int itemCount;
  @override
  @JsonKey(name: 'estimated_departure')
  final DateTime? estimatedDeparture;
  @override
  @JsonKey(name: 'closing_date')
  final DateTime? closingDate;
  final List<PackingListItem> _items;
  @override
  @JsonKey()
  List<PackingListItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'PackingList(id: $id, containerNumber: $containerNumber, carrierName: $carrierName, plateNumber: $plateNumber, status: $status, sourceWarehouseId: $sourceWarehouseId, sourceWarehouseName: $sourceWarehouseName, destinationWarehouseId: $destinationWarehouseId, destinationWarehouseName: $destinationWarehouseName, supplierId: $supplierId, supplierName: $supplierName, itemCount: $itemCount, estimatedDeparture: $estimatedDeparture, closingDate: $closingDate, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PackingListImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.containerNumber, containerNumber) ||
                other.containerNumber == containerNumber) &&
            (identical(other.carrierName, carrierName) ||
                other.carrierName == carrierName) &&
            (identical(other.plateNumber, plateNumber) ||
                other.plateNumber == plateNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.sourceWarehouseId, sourceWarehouseId) ||
                other.sourceWarehouseId == sourceWarehouseId) &&
            (identical(other.sourceWarehouseName, sourceWarehouseName) ||
                other.sourceWarehouseName == sourceWarehouseName) &&
            (identical(other.destinationWarehouseId, destinationWarehouseId) ||
                other.destinationWarehouseId == destinationWarehouseId) &&
            (identical(
                    other.destinationWarehouseName, destinationWarehouseName) ||
                other.destinationWarehouseName == destinationWarehouseName) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount) &&
            (identical(other.estimatedDeparture, estimatedDeparture) ||
                other.estimatedDeparture == estimatedDeparture) &&
            (identical(other.closingDate, closingDate) ||
                other.closingDate == closingDate) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      containerNumber,
      carrierName,
      plateNumber,
      status,
      sourceWarehouseId,
      sourceWarehouseName,
      destinationWarehouseId,
      destinationWarehouseName,
      supplierId,
      supplierName,
      itemCount,
      estimatedDeparture,
      closingDate,
      const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PackingListImplCopyWith<_$PackingListImpl> get copyWith =>
      __$$PackingListImplCopyWithImpl<_$PackingListImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PackingListImplToJson(
      this,
    );
  }
}

abstract class _PackingList implements PackingList {
  const factory _PackingList(
      {required final int id,
      @JsonKey(name: 'container_number') required final String containerNumber,
      @JsonKey(name: 'carrier_name') final String? carrierName,
      @JsonKey(name: 'plate_number') final String? plateNumber,
      required final String status,
      @JsonKey(name: 'source_warehouse_id') final int? sourceWarehouseId,
      @JsonKey(name: 'source_warehouse_name') final String? sourceWarehouseName,
      @JsonKey(name: 'destination_warehouse_id')
      final int? destinationWarehouseId,
      @JsonKey(name: 'destination_warehouse_name')
      final String? destinationWarehouseName,
      @JsonKey(name: 'supplier_id') final int? supplierId,
      @JsonKey(name: 'supplier_name') final String? supplierName,
      @JsonKey(name: 'item_count') final int itemCount,
      @JsonKey(name: 'estimated_departure') final DateTime? estimatedDeparture,
      @JsonKey(name: 'closing_date') final DateTime? closingDate,
      final List<PackingListItem> items}) = _$PackingListImpl;

  factory _PackingList.fromJson(Map<String, dynamic> json) =
      _$PackingListImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'container_number')
  String get containerNumber;
  @override
  @JsonKey(name: 'carrier_name')
  String? get carrierName;
  @override
  @JsonKey(name: 'plate_number')
  String? get plateNumber;
  @override
  String get status;
  @override
  @JsonKey(name: 'source_warehouse_id')
  int? get sourceWarehouseId;
  @override
  @JsonKey(name: 'source_warehouse_name')
  String? get sourceWarehouseName;
  @override
  @JsonKey(name: 'destination_warehouse_id')
  int? get destinationWarehouseId;
  @override
  @JsonKey(name: 'destination_warehouse_name')
  String? get destinationWarehouseName;
  @override
  @JsonKey(name: 'supplier_id')
  int? get supplierId;
  @override
  @JsonKey(name: 'supplier_name')
  String? get supplierName;
  @override
  @JsonKey(name: 'item_count')
  int get itemCount;
  @override
  @JsonKey(name: 'estimated_departure')
  DateTime? get estimatedDeparture;
  @override
  @JsonKey(name: 'closing_date')
  DateTime? get closingDate;
  @override
  List<PackingListItem> get items;
  @override
  @JsonKey(ignore: true)
  _$$PackingListImplCopyWith<_$PackingListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PackingListItem _$PackingListItemFromJson(Map<String, dynamic> json) {
  return _PackingListItem.fromJson(json);
}

/// @nodoc
mixin _$PackingListItem {
  String get type => throw _privateConstructorUsedError; // 'po' or 'inventory'
  @JsonKey(name: 'po_detail_id')
  int? get poDetailId => throw _privateConstructorUsedError;
  @JsonKey(name: 'inventory_id')
  int? get inventoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'po_header_id')
  int? get poHeaderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'po_number')
  String? get poNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_name')
  String? get supplierName => throw _privateConstructorUsedError;
  String get sku => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name')
  String get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'planned_qty', fromJson: doubleFromJson)
  double get plannedQty => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PackingListItemCopyWith<PackingListItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PackingListItemCopyWith<$Res> {
  factory $PackingListItemCopyWith(
          PackingListItem value, $Res Function(PackingListItem) then) =
      _$PackingListItemCopyWithImpl<$Res, PackingListItem>;
  @useResult
  $Res call(
      {String type,
      @JsonKey(name: 'po_detail_id') int? poDetailId,
      @JsonKey(name: 'inventory_id') int? inventoryId,
      @JsonKey(name: 'po_header_id') int? poHeaderId,
      @JsonKey(name: 'po_number') String? poNumber,
      @JsonKey(name: 'supplier_name') String? supplierName,
      String sku,
      @JsonKey(name: 'product_name') String productName,
      @JsonKey(name: 'planned_qty', fromJson: doubleFromJson) double plannedQty,
      String unit});
}

/// @nodoc
class _$PackingListItemCopyWithImpl<$Res, $Val extends PackingListItem>
    implements $PackingListItemCopyWith<$Res> {
  _$PackingListItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? poDetailId = freezed,
    Object? inventoryId = freezed,
    Object? poHeaderId = freezed,
    Object? poNumber = freezed,
    Object? supplierName = freezed,
    Object? sku = null,
    Object? productName = null,
    Object? plannedQty = null,
    Object? unit = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      poDetailId: freezed == poDetailId
          ? _value.poDetailId
          : poDetailId // ignore: cast_nullable_to_non_nullable
              as int?,
      inventoryId: freezed == inventoryId
          ? _value.inventoryId
          : inventoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      poHeaderId: freezed == poHeaderId
          ? _value.poHeaderId
          : poHeaderId // ignore: cast_nullable_to_non_nullable
              as int?,
      poNumber: freezed == poNumber
          ? _value.poNumber
          : poNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      plannedQty: null == plannedQty
          ? _value.plannedQty
          : plannedQty // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PackingListItemImplCopyWith<$Res>
    implements $PackingListItemCopyWith<$Res> {
  factory _$$PackingListItemImplCopyWith(_$PackingListItemImpl value,
          $Res Function(_$PackingListItemImpl) then) =
      __$$PackingListItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      @JsonKey(name: 'po_detail_id') int? poDetailId,
      @JsonKey(name: 'inventory_id') int? inventoryId,
      @JsonKey(name: 'po_header_id') int? poHeaderId,
      @JsonKey(name: 'po_number') String? poNumber,
      @JsonKey(name: 'supplier_name') String? supplierName,
      String sku,
      @JsonKey(name: 'product_name') String productName,
      @JsonKey(name: 'planned_qty', fromJson: doubleFromJson) double plannedQty,
      String unit});
}

/// @nodoc
class __$$PackingListItemImplCopyWithImpl<$Res>
    extends _$PackingListItemCopyWithImpl<$Res, _$PackingListItemImpl>
    implements _$$PackingListItemImplCopyWith<$Res> {
  __$$PackingListItemImplCopyWithImpl(
      _$PackingListItemImpl _value, $Res Function(_$PackingListItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? poDetailId = freezed,
    Object? inventoryId = freezed,
    Object? poHeaderId = freezed,
    Object? poNumber = freezed,
    Object? supplierName = freezed,
    Object? sku = null,
    Object? productName = null,
    Object? plannedQty = null,
    Object? unit = null,
  }) {
    return _then(_$PackingListItemImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      poDetailId: freezed == poDetailId
          ? _value.poDetailId
          : poDetailId // ignore: cast_nullable_to_non_nullable
              as int?,
      inventoryId: freezed == inventoryId
          ? _value.inventoryId
          : inventoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      poHeaderId: freezed == poHeaderId
          ? _value.poHeaderId
          : poHeaderId // ignore: cast_nullable_to_non_nullable
              as int?,
      poNumber: freezed == poNumber
          ? _value.poNumber
          : poNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      plannedQty: null == plannedQty
          ? _value.plannedQty
          : plannedQty // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PackingListItemImpl implements _PackingListItem {
  const _$PackingListItemImpl(
      {required this.type,
      @JsonKey(name: 'po_detail_id') this.poDetailId,
      @JsonKey(name: 'inventory_id') this.inventoryId,
      @JsonKey(name: 'po_header_id') this.poHeaderId,
      @JsonKey(name: 'po_number') this.poNumber,
      @JsonKey(name: 'supplier_name') this.supplierName,
      required this.sku,
      @JsonKey(name: 'product_name') required this.productName,
      @JsonKey(name: 'planned_qty', fromJson: doubleFromJson)
      required this.plannedQty,
      required this.unit});

  factory _$PackingListItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PackingListItemImplFromJson(json);

  @override
  final String type;
// 'po' or 'inventory'
  @override
  @JsonKey(name: 'po_detail_id')
  final int? poDetailId;
  @override
  @JsonKey(name: 'inventory_id')
  final int? inventoryId;
  @override
  @JsonKey(name: 'po_header_id')
  final int? poHeaderId;
  @override
  @JsonKey(name: 'po_number')
  final String? poNumber;
  @override
  @JsonKey(name: 'supplier_name')
  final String? supplierName;
  @override
  final String sku;
  @override
  @JsonKey(name: 'product_name')
  final String productName;
  @override
  @JsonKey(name: 'planned_qty', fromJson: doubleFromJson)
  final double plannedQty;
  @override
  final String unit;

  @override
  String toString() {
    return 'PackingListItem(type: $type, poDetailId: $poDetailId, inventoryId: $inventoryId, poHeaderId: $poHeaderId, poNumber: $poNumber, supplierName: $supplierName, sku: $sku, productName: $productName, plannedQty: $plannedQty, unit: $unit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PackingListItemImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.poDetailId, poDetailId) ||
                other.poDetailId == poDetailId) &&
            (identical(other.inventoryId, inventoryId) ||
                other.inventoryId == inventoryId) &&
            (identical(other.poHeaderId, poHeaderId) ||
                other.poHeaderId == poHeaderId) &&
            (identical(other.poNumber, poNumber) ||
                other.poNumber == poNumber) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.plannedQty, plannedQty) ||
                other.plannedQty == plannedQty) &&
            (identical(other.unit, unit) || other.unit == unit));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, poDetailId, inventoryId,
      poHeaderId, poNumber, supplierName, sku, productName, plannedQty, unit);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PackingListItemImplCopyWith<_$PackingListItemImpl> get copyWith =>
      __$$PackingListItemImplCopyWithImpl<_$PackingListItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PackingListItemImplToJson(
      this,
    );
  }
}

abstract class _PackingListItem implements PackingListItem {
  const factory _PackingListItem(
      {required final String type,
      @JsonKey(name: 'po_detail_id') final int? poDetailId,
      @JsonKey(name: 'inventory_id') final int? inventoryId,
      @JsonKey(name: 'po_header_id') final int? poHeaderId,
      @JsonKey(name: 'po_number') final String? poNumber,
      @JsonKey(name: 'supplier_name') final String? supplierName,
      required final String sku,
      @JsonKey(name: 'product_name') required final String productName,
      @JsonKey(name: 'planned_qty', fromJson: doubleFromJson)
      required final double plannedQty,
      required final String unit}) = _$PackingListItemImpl;

  factory _PackingListItem.fromJson(Map<String, dynamic> json) =
      _$PackingListItemImpl.fromJson;

  @override
  String get type;
  @override // 'po' or 'inventory'
  @JsonKey(name: 'po_detail_id')
  int? get poDetailId;
  @override
  @JsonKey(name: 'inventory_id')
  int? get inventoryId;
  @override
  @JsonKey(name: 'po_header_id')
  int? get poHeaderId;
  @override
  @JsonKey(name: 'po_number')
  String? get poNumber;
  @override
  @JsonKey(name: 'supplier_name')
  String? get supplierName;
  @override
  String get sku;
  @override
  @JsonKey(name: 'product_name')
  String get productName;
  @override
  @JsonKey(name: 'planned_qty', fromJson: doubleFromJson)
  double get plannedQty;
  @override
  String get unit;
  @override
  @JsonKey(ignore: true)
  _$$PackingListItemImplCopyWith<_$PackingListItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
