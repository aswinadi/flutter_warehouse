// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Inventory _$InventoryFromJson(Map<String, dynamic> json) {
  return _Inventory.fromJson(json);
}

/// @nodoc
mixin _$Inventory {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'barcode_code')
  String? get barcodeCode => throw _privateConstructorUsedError;
  String get sku => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name')
  String? get productName => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'warehouse_name')
  String? get warehouseName => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_code')
  String? get locationCode => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InventoryCopyWith<Inventory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryCopyWith<$Res> {
  factory $InventoryCopyWith(Inventory value, $Res Function(Inventory) then) =
      _$InventoryCopyWithImpl<$Res, Inventory>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'barcode_code') String? barcodeCode,
      String sku,
      @JsonKey(name: 'product_name') String? productName,
      double quantity,
      String status,
      @JsonKey(name: 'warehouse_name') String? warehouseName,
      @JsonKey(name: 'location_code') String? locationCode,
      String? unit});
}

/// @nodoc
class _$InventoryCopyWithImpl<$Res, $Val extends Inventory>
    implements $InventoryCopyWith<$Res> {
  _$InventoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? barcodeCode = freezed,
    Object? sku = null,
    Object? productName = freezed,
    Object? quantity = null,
    Object? status = null,
    Object? warehouseName = freezed,
    Object? locationCode = freezed,
    Object? unit = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      barcodeCode: freezed == barcodeCode
          ? _value.barcodeCode
          : barcodeCode // ignore: cast_nullable_to_non_nullable
              as String?,
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      warehouseName: freezed == warehouseName
          ? _value.warehouseName
          : warehouseName // ignore: cast_nullable_to_non_nullable
              as String?,
      locationCode: freezed == locationCode
          ? _value.locationCode
          : locationCode // ignore: cast_nullable_to_non_nullable
              as String?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InventoryImplCopyWith<$Res>
    implements $InventoryCopyWith<$Res> {
  factory _$$InventoryImplCopyWith(
          _$InventoryImpl value, $Res Function(_$InventoryImpl) then) =
      __$$InventoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'barcode_code') String? barcodeCode,
      String sku,
      @JsonKey(name: 'product_name') String? productName,
      double quantity,
      String status,
      @JsonKey(name: 'warehouse_name') String? warehouseName,
      @JsonKey(name: 'location_code') String? locationCode,
      String? unit});
}

/// @nodoc
class __$$InventoryImplCopyWithImpl<$Res>
    extends _$InventoryCopyWithImpl<$Res, _$InventoryImpl>
    implements _$$InventoryImplCopyWith<$Res> {
  __$$InventoryImplCopyWithImpl(
      _$InventoryImpl _value, $Res Function(_$InventoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? barcodeCode = freezed,
    Object? sku = null,
    Object? productName = freezed,
    Object? quantity = null,
    Object? status = null,
    Object? warehouseName = freezed,
    Object? locationCode = freezed,
    Object? unit = freezed,
  }) {
    return _then(_$InventoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      barcodeCode: freezed == barcodeCode
          ? _value.barcodeCode
          : barcodeCode // ignore: cast_nullable_to_non_nullable
              as String?,
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      warehouseName: freezed == warehouseName
          ? _value.warehouseName
          : warehouseName // ignore: cast_nullable_to_non_nullable
              as String?,
      locationCode: freezed == locationCode
          ? _value.locationCode
          : locationCode // ignore: cast_nullable_to_non_nullable
              as String?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryImpl implements _Inventory {
  const _$InventoryImpl(
      {required this.id,
      @JsonKey(name: 'barcode_code') this.barcodeCode,
      required this.sku,
      @JsonKey(name: 'product_name') this.productName,
      required this.quantity,
      required this.status,
      @JsonKey(name: 'warehouse_name') this.warehouseName,
      @JsonKey(name: 'location_code') this.locationCode,
      this.unit});

  factory _$InventoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'barcode_code')
  final String? barcodeCode;
  @override
  final String sku;
  @override
  @JsonKey(name: 'product_name')
  final String? productName;
  @override
  final double quantity;
  @override
  final String status;
  @override
  @JsonKey(name: 'warehouse_name')
  final String? warehouseName;
  @override
  @JsonKey(name: 'location_code')
  final String? locationCode;
  @override
  final String? unit;

  @override
  String toString() {
    return 'Inventory(id: $id, barcodeCode: $barcodeCode, sku: $sku, productName: $productName, quantity: $quantity, status: $status, warehouseName: $warehouseName, locationCode: $locationCode, unit: $unit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.barcodeCode, barcodeCode) ||
                other.barcodeCode == barcodeCode) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.warehouseName, warehouseName) ||
                other.warehouseName == warehouseName) &&
            (identical(other.locationCode, locationCode) ||
                other.locationCode == locationCode) &&
            (identical(other.unit, unit) || other.unit == unit));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, barcodeCode, sku,
      productName, quantity, status, warehouseName, locationCode, unit);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryImplCopyWith<_$InventoryImpl> get copyWith =>
      __$$InventoryImplCopyWithImpl<_$InventoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryImplToJson(
      this,
    );
  }
}

abstract class _Inventory implements Inventory {
  const factory _Inventory(
      {required final int id,
      @JsonKey(name: 'barcode_code') final String? barcodeCode,
      required final String sku,
      @JsonKey(name: 'product_name') final String? productName,
      required final double quantity,
      required final String status,
      @JsonKey(name: 'warehouse_name') final String? warehouseName,
      @JsonKey(name: 'location_code') final String? locationCode,
      final String? unit}) = _$InventoryImpl;

  factory _Inventory.fromJson(Map<String, dynamic> json) =
      _$InventoryImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'barcode_code')
  String? get barcodeCode;
  @override
  String get sku;
  @override
  @JsonKey(name: 'product_name')
  String? get productName;
  @override
  double get quantity;
  @override
  String get status;
  @override
  @JsonKey(name: 'warehouse_name')
  String? get warehouseName;
  @override
  @JsonKey(name: 'location_code')
  String? get locationCode;
  @override
  String? get unit;
  @override
  @JsonKey(ignore: true)
  _$$InventoryImplCopyWith<_$InventoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
