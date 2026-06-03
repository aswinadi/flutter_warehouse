// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_breakdown.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InventoryBreakdown _$InventoryBreakdownFromJson(Map<String, dynamic> json) {
  return _InventoryBreakdown.fromJson(json);
}

/// @nodoc
mixin _$InventoryBreakdown {
  @JsonKey(name: 'product_name')
  String get productName => throw _privateConstructorUsedError;
  String get sku => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'on_hand')
  List<WarehouseOnHand> get onHand => throw _privateConstructorUsedError;
  @JsonKey(name: 'in_transit')
  List<InTransitStock> get inTransit => throw _privateConstructorUsedError;
  List<OrderedStock> get ordered => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InventoryBreakdownCopyWith<InventoryBreakdown> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryBreakdownCopyWith<$Res> {
  factory $InventoryBreakdownCopyWith(
          InventoryBreakdown value, $Res Function(InventoryBreakdown) then) =
      _$InventoryBreakdownCopyWithImpl<$Res, InventoryBreakdown>;
  @useResult
  $Res call(
      {@JsonKey(name: 'product_name') String productName,
      String sku,
      String unit,
      @JsonKey(name: 'on_hand') List<WarehouseOnHand> onHand,
      @JsonKey(name: 'in_transit') List<InTransitStock> inTransit,
      List<OrderedStock> ordered});
}

/// @nodoc
class _$InventoryBreakdownCopyWithImpl<$Res, $Val extends InventoryBreakdown>
    implements $InventoryBreakdownCopyWith<$Res> {
  _$InventoryBreakdownCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productName = null,
    Object? sku = null,
    Object? unit = null,
    Object? onHand = null,
    Object? inTransit = null,
    Object? ordered = null,
  }) {
    return _then(_value.copyWith(
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      onHand: null == onHand
          ? _value.onHand
          : onHand // ignore: cast_nullable_to_non_nullable
              as List<WarehouseOnHand>,
      inTransit: null == inTransit
          ? _value.inTransit
          : inTransit // ignore: cast_nullable_to_non_nullable
              as List<InTransitStock>,
      ordered: null == ordered
          ? _value.ordered
          : ordered // ignore: cast_nullable_to_non_nullable
              as List<OrderedStock>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InventoryBreakdownImplCopyWith<$Res>
    implements $InventoryBreakdownCopyWith<$Res> {
  factory _$$InventoryBreakdownImplCopyWith(_$InventoryBreakdownImpl value,
          $Res Function(_$InventoryBreakdownImpl) then) =
      __$$InventoryBreakdownImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'product_name') String productName,
      String sku,
      String unit,
      @JsonKey(name: 'on_hand') List<WarehouseOnHand> onHand,
      @JsonKey(name: 'in_transit') List<InTransitStock> inTransit,
      List<OrderedStock> ordered});
}

/// @nodoc
class __$$InventoryBreakdownImplCopyWithImpl<$Res>
    extends _$InventoryBreakdownCopyWithImpl<$Res, _$InventoryBreakdownImpl>
    implements _$$InventoryBreakdownImplCopyWith<$Res> {
  __$$InventoryBreakdownImplCopyWithImpl(_$InventoryBreakdownImpl _value,
      $Res Function(_$InventoryBreakdownImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productName = null,
    Object? sku = null,
    Object? unit = null,
    Object? onHand = null,
    Object? inTransit = null,
    Object? ordered = null,
  }) {
    return _then(_$InventoryBreakdownImpl(
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      onHand: null == onHand
          ? _value._onHand
          : onHand // ignore: cast_nullable_to_non_nullable
              as List<WarehouseOnHand>,
      inTransit: null == inTransit
          ? _value._inTransit
          : inTransit // ignore: cast_nullable_to_non_nullable
              as List<InTransitStock>,
      ordered: null == ordered
          ? _value._ordered
          : ordered // ignore: cast_nullable_to_non_nullable
              as List<OrderedStock>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryBreakdownImpl implements _InventoryBreakdown {
  const _$InventoryBreakdownImpl(
      {@JsonKey(name: 'product_name') required this.productName,
      required this.sku,
      required this.unit,
      @JsonKey(name: 'on_hand') final List<WarehouseOnHand> onHand = const [],
      @JsonKey(name: 'in_transit')
      final List<InTransitStock> inTransit = const [],
      final List<OrderedStock> ordered = const []})
      : _onHand = onHand,
        _inTransit = inTransit,
        _ordered = ordered;

  factory _$InventoryBreakdownImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryBreakdownImplFromJson(json);

  @override
  @JsonKey(name: 'product_name')
  final String productName;
  @override
  final String sku;
  @override
  final String unit;
  final List<WarehouseOnHand> _onHand;
  @override
  @JsonKey(name: 'on_hand')
  List<WarehouseOnHand> get onHand {
    if (_onHand is EqualUnmodifiableListView) return _onHand;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_onHand);
  }

  final List<InTransitStock> _inTransit;
  @override
  @JsonKey(name: 'in_transit')
  List<InTransitStock> get inTransit {
    if (_inTransit is EqualUnmodifiableListView) return _inTransit;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inTransit);
  }

  final List<OrderedStock> _ordered;
  @override
  @JsonKey()
  List<OrderedStock> get ordered {
    if (_ordered is EqualUnmodifiableListView) return _ordered;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ordered);
  }

  @override
  String toString() {
    return 'InventoryBreakdown(productName: $productName, sku: $sku, unit: $unit, onHand: $onHand, inTransit: $inTransit, ordered: $ordered)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryBreakdownImpl &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            const DeepCollectionEquality().equals(other._onHand, _onHand) &&
            const DeepCollectionEquality()
                .equals(other._inTransit, _inTransit) &&
            const DeepCollectionEquality().equals(other._ordered, _ordered));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      productName,
      sku,
      unit,
      const DeepCollectionEquality().hash(_onHand),
      const DeepCollectionEquality().hash(_inTransit),
      const DeepCollectionEquality().hash(_ordered));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryBreakdownImplCopyWith<_$InventoryBreakdownImpl> get copyWith =>
      __$$InventoryBreakdownImplCopyWithImpl<_$InventoryBreakdownImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryBreakdownImplToJson(
      this,
    );
  }
}

abstract class _InventoryBreakdown implements InventoryBreakdown {
  const factory _InventoryBreakdown(
      {@JsonKey(name: 'product_name') required final String productName,
      required final String sku,
      required final String unit,
      @JsonKey(name: 'on_hand') final List<WarehouseOnHand> onHand,
      @JsonKey(name: 'in_transit') final List<InTransitStock> inTransit,
      final List<OrderedStock> ordered}) = _$InventoryBreakdownImpl;

  factory _InventoryBreakdown.fromJson(Map<String, dynamic> json) =
      _$InventoryBreakdownImpl.fromJson;

  @override
  @JsonKey(name: 'product_name')
  String get productName;
  @override
  String get sku;
  @override
  String get unit;
  @override
  @JsonKey(name: 'on_hand')
  List<WarehouseOnHand> get onHand;
  @override
  @JsonKey(name: 'in_transit')
  List<InTransitStock> get inTransit;
  @override
  List<OrderedStock> get ordered;
  @override
  @JsonKey(ignore: true)
  _$$InventoryBreakdownImplCopyWith<_$InventoryBreakdownImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WarehouseOnHand _$WarehouseOnHandFromJson(Map<String, dynamic> json) {
  return _WarehouseOnHand.fromJson(json);
}

/// @nodoc
mixin _$WarehouseOnHand {
  @JsonKey(name: 'warehouse_id')
  int get warehouseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'warehouse_name')
  String get warehouseName => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  List<LocationOnHand> get locations => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WarehouseOnHandCopyWith<WarehouseOnHand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WarehouseOnHandCopyWith<$Res> {
  factory $WarehouseOnHandCopyWith(
          WarehouseOnHand value, $Res Function(WarehouseOnHand) then) =
      _$WarehouseOnHandCopyWithImpl<$Res, WarehouseOnHand>;
  @useResult
  $Res call(
      {@JsonKey(name: 'warehouse_id') int warehouseId,
      @JsonKey(name: 'warehouse_name') String warehouseName,
      double quantity,
      List<LocationOnHand> locations});
}

/// @nodoc
class _$WarehouseOnHandCopyWithImpl<$Res, $Val extends WarehouseOnHand>
    implements $WarehouseOnHandCopyWith<$Res> {
  _$WarehouseOnHandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? warehouseId = null,
    Object? warehouseName = null,
    Object? quantity = null,
    Object? locations = null,
  }) {
    return _then(_value.copyWith(
      warehouseId: null == warehouseId
          ? _value.warehouseId
          : warehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      warehouseName: null == warehouseName
          ? _value.warehouseName
          : warehouseName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      locations: null == locations
          ? _value.locations
          : locations // ignore: cast_nullable_to_non_nullable
              as List<LocationOnHand>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WarehouseOnHandImplCopyWith<$Res>
    implements $WarehouseOnHandCopyWith<$Res> {
  factory _$$WarehouseOnHandImplCopyWith(_$WarehouseOnHandImpl value,
          $Res Function(_$WarehouseOnHandImpl) then) =
      __$$WarehouseOnHandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'warehouse_id') int warehouseId,
      @JsonKey(name: 'warehouse_name') String warehouseName,
      double quantity,
      List<LocationOnHand> locations});
}

/// @nodoc
class __$$WarehouseOnHandImplCopyWithImpl<$Res>
    extends _$WarehouseOnHandCopyWithImpl<$Res, _$WarehouseOnHandImpl>
    implements _$$WarehouseOnHandImplCopyWith<$Res> {
  __$$WarehouseOnHandImplCopyWithImpl(
      _$WarehouseOnHandImpl _value, $Res Function(_$WarehouseOnHandImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? warehouseId = null,
    Object? warehouseName = null,
    Object? quantity = null,
    Object? locations = null,
  }) {
    return _then(_$WarehouseOnHandImpl(
      warehouseId: null == warehouseId
          ? _value.warehouseId
          : warehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      warehouseName: null == warehouseName
          ? _value.warehouseName
          : warehouseName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      locations: null == locations
          ? _value._locations
          : locations // ignore: cast_nullable_to_non_nullable
              as List<LocationOnHand>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WarehouseOnHandImpl implements _WarehouseOnHand {
  const _$WarehouseOnHandImpl(
      {@JsonKey(name: 'warehouse_id') required this.warehouseId,
      @JsonKey(name: 'warehouse_name') required this.warehouseName,
      required this.quantity,
      final List<LocationOnHand> locations = const []})
      : _locations = locations;

  factory _$WarehouseOnHandImpl.fromJson(Map<String, dynamic> json) =>
      _$$WarehouseOnHandImplFromJson(json);

  @override
  @JsonKey(name: 'warehouse_id')
  final int warehouseId;
  @override
  @JsonKey(name: 'warehouse_name')
  final String warehouseName;
  @override
  final double quantity;
  final List<LocationOnHand> _locations;
  @override
  @JsonKey()
  List<LocationOnHand> get locations {
    if (_locations is EqualUnmodifiableListView) return _locations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_locations);
  }

  @override
  String toString() {
    return 'WarehouseOnHand(warehouseId: $warehouseId, warehouseName: $warehouseName, quantity: $quantity, locations: $locations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WarehouseOnHandImpl &&
            (identical(other.warehouseId, warehouseId) ||
                other.warehouseId == warehouseId) &&
            (identical(other.warehouseName, warehouseName) ||
                other.warehouseName == warehouseName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            const DeepCollectionEquality()
                .equals(other._locations, _locations));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, warehouseId, warehouseName,
      quantity, const DeepCollectionEquality().hash(_locations));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WarehouseOnHandImplCopyWith<_$WarehouseOnHandImpl> get copyWith =>
      __$$WarehouseOnHandImplCopyWithImpl<_$WarehouseOnHandImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WarehouseOnHandImplToJson(
      this,
    );
  }
}

abstract class _WarehouseOnHand implements WarehouseOnHand {
  const factory _WarehouseOnHand(
      {@JsonKey(name: 'warehouse_id') required final int warehouseId,
      @JsonKey(name: 'warehouse_name') required final String warehouseName,
      required final double quantity,
      final List<LocationOnHand> locations}) = _$WarehouseOnHandImpl;

  factory _WarehouseOnHand.fromJson(Map<String, dynamic> json) =
      _$WarehouseOnHandImpl.fromJson;

  @override
  @JsonKey(name: 'warehouse_id')
  int get warehouseId;
  @override
  @JsonKey(name: 'warehouse_name')
  String get warehouseName;
  @override
  double get quantity;
  @override
  List<LocationOnHand> get locations;
  @override
  @JsonKey(ignore: true)
  _$$WarehouseOnHandImplCopyWith<_$WarehouseOnHandImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LocationOnHand _$LocationOnHandFromJson(Map<String, dynamic> json) {
  return _LocationOnHand.fromJson(json);
}

/// @nodoc
mixin _$LocationOnHand {
  @JsonKey(name: 'location_id')
  int? get locationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_code')
  String get locationCode => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LocationOnHandCopyWith<LocationOnHand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationOnHandCopyWith<$Res> {
  factory $LocationOnHandCopyWith(
          LocationOnHand value, $Res Function(LocationOnHand) then) =
      _$LocationOnHandCopyWithImpl<$Res, LocationOnHand>;
  @useResult
  $Res call(
      {@JsonKey(name: 'location_id') int? locationId,
      @JsonKey(name: 'location_code') String locationCode,
      double quantity});
}

/// @nodoc
class _$LocationOnHandCopyWithImpl<$Res, $Val extends LocationOnHand>
    implements $LocationOnHandCopyWith<$Res> {
  _$LocationOnHandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationId = freezed,
    Object? locationCode = null,
    Object? quantity = null,
  }) {
    return _then(_value.copyWith(
      locationId: freezed == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as int?,
      locationCode: null == locationCode
          ? _value.locationCode
          : locationCode // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocationOnHandImplCopyWith<$Res>
    implements $LocationOnHandCopyWith<$Res> {
  factory _$$LocationOnHandImplCopyWith(_$LocationOnHandImpl value,
          $Res Function(_$LocationOnHandImpl) then) =
      __$$LocationOnHandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'location_id') int? locationId,
      @JsonKey(name: 'location_code') String locationCode,
      double quantity});
}

/// @nodoc
class __$$LocationOnHandImplCopyWithImpl<$Res>
    extends _$LocationOnHandCopyWithImpl<$Res, _$LocationOnHandImpl>
    implements _$$LocationOnHandImplCopyWith<$Res> {
  __$$LocationOnHandImplCopyWithImpl(
      _$LocationOnHandImpl _value, $Res Function(_$LocationOnHandImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationId = freezed,
    Object? locationCode = null,
    Object? quantity = null,
  }) {
    return _then(_$LocationOnHandImpl(
      locationId: freezed == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as int?,
      locationCode: null == locationCode
          ? _value.locationCode
          : locationCode // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationOnHandImpl implements _LocationOnHand {
  const _$LocationOnHandImpl(
      {@JsonKey(name: 'location_id') this.locationId,
      @JsonKey(name: 'location_code') required this.locationCode,
      required this.quantity});

  factory _$LocationOnHandImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationOnHandImplFromJson(json);

  @override
  @JsonKey(name: 'location_id')
  final int? locationId;
  @override
  @JsonKey(name: 'location_code')
  final String locationCode;
  @override
  final double quantity;

  @override
  String toString() {
    return 'LocationOnHand(locationId: $locationId, locationCode: $locationCode, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationOnHandImpl &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.locationCode, locationCode) ||
                other.locationCode == locationCode) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, locationId, locationCode, quantity);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationOnHandImplCopyWith<_$LocationOnHandImpl> get copyWith =>
      __$$LocationOnHandImplCopyWithImpl<_$LocationOnHandImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationOnHandImplToJson(
      this,
    );
  }
}

abstract class _LocationOnHand implements LocationOnHand {
  const factory _LocationOnHand(
      {@JsonKey(name: 'location_id') final int? locationId,
      @JsonKey(name: 'location_code') required final String locationCode,
      required final double quantity}) = _$LocationOnHandImpl;

  factory _LocationOnHand.fromJson(Map<String, dynamic> json) =
      _$LocationOnHandImpl.fromJson;

  @override
  @JsonKey(name: 'location_id')
  int? get locationId;
  @override
  @JsonKey(name: 'location_code')
  String get locationCode;
  @override
  double get quantity;
  @override
  @JsonKey(ignore: true)
  _$$LocationOnHandImplCopyWith<_$LocationOnHandImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InTransitStock _$InTransitStockFromJson(Map<String, dynamic> json) {
  return _InTransitStock.fromJson(json);
}

/// @nodoc
mixin _$InTransitStock {
  @JsonKey(name: 'transfer_number')
  String get transferNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'source_warehouse_name')
  String get sourceWarehouseName => throw _privateConstructorUsedError;
  @JsonKey(name: 'destination_warehouse_name')
  String get destinationWarehouseName => throw _privateConstructorUsedError;
  @JsonKey(name: 'destination_warehouse_id')
  int get destinationWarehouseId => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InTransitStockCopyWith<InTransitStock> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InTransitStockCopyWith<$Res> {
  factory $InTransitStockCopyWith(
          InTransitStock value, $Res Function(InTransitStock) then) =
      _$InTransitStockCopyWithImpl<$Res, InTransitStock>;
  @useResult
  $Res call(
      {@JsonKey(name: 'transfer_number') String transferNumber,
      @JsonKey(name: 'source_warehouse_name') String sourceWarehouseName,
      @JsonKey(name: 'destination_warehouse_name')
      String destinationWarehouseName,
      @JsonKey(name: 'destination_warehouse_id') int destinationWarehouseId,
      double quantity});
}

/// @nodoc
class _$InTransitStockCopyWithImpl<$Res, $Val extends InTransitStock>
    implements $InTransitStockCopyWith<$Res> {
  _$InTransitStockCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transferNumber = null,
    Object? sourceWarehouseName = null,
    Object? destinationWarehouseName = null,
    Object? destinationWarehouseId = null,
    Object? quantity = null,
  }) {
    return _then(_value.copyWith(
      transferNumber: null == transferNumber
          ? _value.transferNumber
          : transferNumber // ignore: cast_nullable_to_non_nullable
              as String,
      sourceWarehouseName: null == sourceWarehouseName
          ? _value.sourceWarehouseName
          : sourceWarehouseName // ignore: cast_nullable_to_non_nullable
              as String,
      destinationWarehouseName: null == destinationWarehouseName
          ? _value.destinationWarehouseName
          : destinationWarehouseName // ignore: cast_nullable_to_non_nullable
              as String,
      destinationWarehouseId: null == destinationWarehouseId
          ? _value.destinationWarehouseId
          : destinationWarehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InTransitStockImplCopyWith<$Res>
    implements $InTransitStockCopyWith<$Res> {
  factory _$$InTransitStockImplCopyWith(_$InTransitStockImpl value,
          $Res Function(_$InTransitStockImpl) then) =
      __$$InTransitStockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'transfer_number') String transferNumber,
      @JsonKey(name: 'source_warehouse_name') String sourceWarehouseName,
      @JsonKey(name: 'destination_warehouse_name')
      String destinationWarehouseName,
      @JsonKey(name: 'destination_warehouse_id') int destinationWarehouseId,
      double quantity});
}

/// @nodoc
class __$$InTransitStockImplCopyWithImpl<$Res>
    extends _$InTransitStockCopyWithImpl<$Res, _$InTransitStockImpl>
    implements _$$InTransitStockImplCopyWith<$Res> {
  __$$InTransitStockImplCopyWithImpl(
      _$InTransitStockImpl _value, $Res Function(_$InTransitStockImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transferNumber = null,
    Object? sourceWarehouseName = null,
    Object? destinationWarehouseName = null,
    Object? destinationWarehouseId = null,
    Object? quantity = null,
  }) {
    return _then(_$InTransitStockImpl(
      transferNumber: null == transferNumber
          ? _value.transferNumber
          : transferNumber // ignore: cast_nullable_to_non_nullable
              as String,
      sourceWarehouseName: null == sourceWarehouseName
          ? _value.sourceWarehouseName
          : sourceWarehouseName // ignore: cast_nullable_to_non_nullable
              as String,
      destinationWarehouseName: null == destinationWarehouseName
          ? _value.destinationWarehouseName
          : destinationWarehouseName // ignore: cast_nullable_to_non_nullable
              as String,
      destinationWarehouseId: null == destinationWarehouseId
          ? _value.destinationWarehouseId
          : destinationWarehouseId // ignore: cast_nullable_to_non_nullable
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
class _$InTransitStockImpl implements _InTransitStock {
  const _$InTransitStockImpl(
      {@JsonKey(name: 'transfer_number') required this.transferNumber,
      @JsonKey(name: 'source_warehouse_name') required this.sourceWarehouseName,
      @JsonKey(name: 'destination_warehouse_name')
      required this.destinationWarehouseName,
      @JsonKey(name: 'destination_warehouse_id')
      required this.destinationWarehouseId,
      required this.quantity});

  factory _$InTransitStockImpl.fromJson(Map<String, dynamic> json) =>
      _$$InTransitStockImplFromJson(json);

  @override
  @JsonKey(name: 'transfer_number')
  final String transferNumber;
  @override
  @JsonKey(name: 'source_warehouse_name')
  final String sourceWarehouseName;
  @override
  @JsonKey(name: 'destination_warehouse_name')
  final String destinationWarehouseName;
  @override
  @JsonKey(name: 'destination_warehouse_id')
  final int destinationWarehouseId;
  @override
  final double quantity;

  @override
  String toString() {
    return 'InTransitStock(transferNumber: $transferNumber, sourceWarehouseName: $sourceWarehouseName, destinationWarehouseName: $destinationWarehouseName, destinationWarehouseId: $destinationWarehouseId, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InTransitStockImpl &&
            (identical(other.transferNumber, transferNumber) ||
                other.transferNumber == transferNumber) &&
            (identical(other.sourceWarehouseName, sourceWarehouseName) ||
                other.sourceWarehouseName == sourceWarehouseName) &&
            (identical(
                    other.destinationWarehouseName, destinationWarehouseName) ||
                other.destinationWarehouseName == destinationWarehouseName) &&
            (identical(other.destinationWarehouseId, destinationWarehouseId) ||
                other.destinationWarehouseId == destinationWarehouseId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      transferNumber,
      sourceWarehouseName,
      destinationWarehouseName,
      destinationWarehouseId,
      quantity);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InTransitStockImplCopyWith<_$InTransitStockImpl> get copyWith =>
      __$$InTransitStockImplCopyWithImpl<_$InTransitStockImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InTransitStockImplToJson(
      this,
    );
  }
}

abstract class _InTransitStock implements InTransitStock {
  const factory _InTransitStock(
      {@JsonKey(name: 'transfer_number') required final String transferNumber,
      @JsonKey(name: 'source_warehouse_name')
      required final String sourceWarehouseName,
      @JsonKey(name: 'destination_warehouse_name')
      required final String destinationWarehouseName,
      @JsonKey(name: 'destination_warehouse_id')
      required final int destinationWarehouseId,
      required final double quantity}) = _$InTransitStockImpl;

  factory _InTransitStock.fromJson(Map<String, dynamic> json) =
      _$InTransitStockImpl.fromJson;

  @override
  @JsonKey(name: 'transfer_number')
  String get transferNumber;
  @override
  @JsonKey(name: 'source_warehouse_name')
  String get sourceWarehouseName;
  @override
  @JsonKey(name: 'destination_warehouse_name')
  String get destinationWarehouseName;
  @override
  @JsonKey(name: 'destination_warehouse_id')
  int get destinationWarehouseId;
  @override
  double get quantity;
  @override
  @JsonKey(ignore: true)
  _$$InTransitStockImplCopyWith<_$InTransitStockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderedStock _$OrderedStockFromJson(Map<String, dynamic> json) {
  return _OrderedStock.fromJson(json);
}

/// @nodoc
mixin _$OrderedStock {
  @JsonKey(name: 'po_number')
  String get poNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'warehouse_name')
  String get warehouseName => throw _privateConstructorUsedError;
  @JsonKey(name: 'warehouse_id')
  int get warehouseId => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderedStockCopyWith<OrderedStock> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderedStockCopyWith<$Res> {
  factory $OrderedStockCopyWith(
          OrderedStock value, $Res Function(OrderedStock) then) =
      _$OrderedStockCopyWithImpl<$Res, OrderedStock>;
  @useResult
  $Res call(
      {@JsonKey(name: 'po_number') String poNumber,
      @JsonKey(name: 'warehouse_name') String warehouseName,
      @JsonKey(name: 'warehouse_id') int warehouseId,
      double quantity});
}

/// @nodoc
class _$OrderedStockCopyWithImpl<$Res, $Val extends OrderedStock>
    implements $OrderedStockCopyWith<$Res> {
  _$OrderedStockCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poNumber = null,
    Object? warehouseName = null,
    Object? warehouseId = null,
    Object? quantity = null,
  }) {
    return _then(_value.copyWith(
      poNumber: null == poNumber
          ? _value.poNumber
          : poNumber // ignore: cast_nullable_to_non_nullable
              as String,
      warehouseName: null == warehouseName
          ? _value.warehouseName
          : warehouseName // ignore: cast_nullable_to_non_nullable
              as String,
      warehouseId: null == warehouseId
          ? _value.warehouseId
          : warehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderedStockImplCopyWith<$Res>
    implements $OrderedStockCopyWith<$Res> {
  factory _$$OrderedStockImplCopyWith(
          _$OrderedStockImpl value, $Res Function(_$OrderedStockImpl) then) =
      __$$OrderedStockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'po_number') String poNumber,
      @JsonKey(name: 'warehouse_name') String warehouseName,
      @JsonKey(name: 'warehouse_id') int warehouseId,
      double quantity});
}

/// @nodoc
class __$$OrderedStockImplCopyWithImpl<$Res>
    extends _$OrderedStockCopyWithImpl<$Res, _$OrderedStockImpl>
    implements _$$OrderedStockImplCopyWith<$Res> {
  __$$OrderedStockImplCopyWithImpl(
      _$OrderedStockImpl _value, $Res Function(_$OrderedStockImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poNumber = null,
    Object? warehouseName = null,
    Object? warehouseId = null,
    Object? quantity = null,
  }) {
    return _then(_$OrderedStockImpl(
      poNumber: null == poNumber
          ? _value.poNumber
          : poNumber // ignore: cast_nullable_to_non_nullable
              as String,
      warehouseName: null == warehouseName
          ? _value.warehouseName
          : warehouseName // ignore: cast_nullable_to_non_nullable
              as String,
      warehouseId: null == warehouseId
          ? _value.warehouseId
          : warehouseId // ignore: cast_nullable_to_non_nullable
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
class _$OrderedStockImpl implements _OrderedStock {
  const _$OrderedStockImpl(
      {@JsonKey(name: 'po_number') required this.poNumber,
      @JsonKey(name: 'warehouse_name') required this.warehouseName,
      @JsonKey(name: 'warehouse_id') required this.warehouseId,
      required this.quantity});

  factory _$OrderedStockImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderedStockImplFromJson(json);

  @override
  @JsonKey(name: 'po_number')
  final String poNumber;
  @override
  @JsonKey(name: 'warehouse_name')
  final String warehouseName;
  @override
  @JsonKey(name: 'warehouse_id')
  final int warehouseId;
  @override
  final double quantity;

  @override
  String toString() {
    return 'OrderedStock(poNumber: $poNumber, warehouseName: $warehouseName, warehouseId: $warehouseId, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderedStockImpl &&
            (identical(other.poNumber, poNumber) ||
                other.poNumber == poNumber) &&
            (identical(other.warehouseName, warehouseName) ||
                other.warehouseName == warehouseName) &&
            (identical(other.warehouseId, warehouseId) ||
                other.warehouseId == warehouseId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, poNumber, warehouseName, warehouseId, quantity);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderedStockImplCopyWith<_$OrderedStockImpl> get copyWith =>
      __$$OrderedStockImplCopyWithImpl<_$OrderedStockImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderedStockImplToJson(
      this,
    );
  }
}

abstract class _OrderedStock implements OrderedStock {
  const factory _OrderedStock(
      {@JsonKey(name: 'po_number') required final String poNumber,
      @JsonKey(name: 'warehouse_name') required final String warehouseName,
      @JsonKey(name: 'warehouse_id') required final int warehouseId,
      required final double quantity}) = _$OrderedStockImpl;

  factory _OrderedStock.fromJson(Map<String, dynamic> json) =
      _$OrderedStockImpl.fromJson;

  @override
  @JsonKey(name: 'po_number')
  String get poNumber;
  @override
  @JsonKey(name: 'warehouse_name')
  String get warehouseName;
  @override
  @JsonKey(name: 'warehouse_id')
  int get warehouseId;
  @override
  double get quantity;
  @override
  @JsonKey(ignore: true)
  _$$OrderedStockImplCopyWith<_$OrderedStockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
