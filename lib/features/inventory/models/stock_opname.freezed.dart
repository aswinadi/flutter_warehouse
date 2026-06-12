// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_opname.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StockOpname _$StockOpnameFromJson(Map<String, dynamic> json) {
  return _StockOpname.fromJson(json);
}

/// @nodoc
mixin _$StockOpname {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  int get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'opname_number')
  String get opnameNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'warehouse_id')
  int get warehouseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'warehouse_name')
  String? get warehouseName => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name')
  String? get companyName => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'started_at')
  String? get startedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  String? get completedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  int? get createdBy => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StockOpnameCopyWith<StockOpname> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockOpnameCopyWith<$Res> {
  factory $StockOpnameCopyWith(
          StockOpname value, $Res Function(StockOpname) then) =
      _$StockOpnameCopyWithImpl<$Res, StockOpname>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'company_id') int companyId,
      @JsonKey(name: 'opname_number') String opnameNumber,
      @JsonKey(name: 'warehouse_id') int warehouseId,
      @JsonKey(name: 'warehouse_name') String? warehouseName,
      @JsonKey(name: 'company_name') String? companyName,
      String status,
      @JsonKey(name: 'started_at') String? startedAt,
      @JsonKey(name: 'completed_at') String? completedAt,
      @JsonKey(name: 'created_by') int? createdBy,
      String? notes});
}

/// @nodoc
class _$StockOpnameCopyWithImpl<$Res, $Val extends StockOpname>
    implements $StockOpnameCopyWith<$Res> {
  _$StockOpnameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? opnameNumber = null,
    Object? warehouseId = null,
    Object? warehouseName = freezed,
    Object? companyName = freezed,
    Object? status = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? createdBy = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int,
      opnameNumber: null == opnameNumber
          ? _value.opnameNumber
          : opnameNumber // ignore: cast_nullable_to_non_nullable
              as String,
      warehouseId: null == warehouseId
          ? _value.warehouseId
          : warehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      warehouseName: freezed == warehouseName
          ? _value.warehouseName
          : warehouseName // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StockOpnameImplCopyWith<$Res>
    implements $StockOpnameCopyWith<$Res> {
  factory _$$StockOpnameImplCopyWith(
          _$StockOpnameImpl value, $Res Function(_$StockOpnameImpl) then) =
      __$$StockOpnameImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'company_id') int companyId,
      @JsonKey(name: 'opname_number') String opnameNumber,
      @JsonKey(name: 'warehouse_id') int warehouseId,
      @JsonKey(name: 'warehouse_name') String? warehouseName,
      @JsonKey(name: 'company_name') String? companyName,
      String status,
      @JsonKey(name: 'started_at') String? startedAt,
      @JsonKey(name: 'completed_at') String? completedAt,
      @JsonKey(name: 'created_by') int? createdBy,
      String? notes});
}

/// @nodoc
class __$$StockOpnameImplCopyWithImpl<$Res>
    extends _$StockOpnameCopyWithImpl<$Res, _$StockOpnameImpl>
    implements _$$StockOpnameImplCopyWith<$Res> {
  __$$StockOpnameImplCopyWithImpl(
      _$StockOpnameImpl _value, $Res Function(_$StockOpnameImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? opnameNumber = null,
    Object? warehouseId = null,
    Object? warehouseName = freezed,
    Object? companyName = freezed,
    Object? status = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? createdBy = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$StockOpnameImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int,
      opnameNumber: null == opnameNumber
          ? _value.opnameNumber
          : opnameNumber // ignore: cast_nullable_to_non_nullable
              as String,
      warehouseId: null == warehouseId
          ? _value.warehouseId
          : warehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      warehouseName: freezed == warehouseName
          ? _value.warehouseName
          : warehouseName // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockOpnameImpl implements _StockOpname {
  const _$StockOpnameImpl(
      {required this.id,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'opname_number') required this.opnameNumber,
      @JsonKey(name: 'warehouse_id') required this.warehouseId,
      @JsonKey(name: 'warehouse_name') this.warehouseName,
      @JsonKey(name: 'company_name') this.companyName,
      required this.status,
      @JsonKey(name: 'started_at') this.startedAt,
      @JsonKey(name: 'completed_at') this.completedAt,
      @JsonKey(name: 'created_by') this.createdBy,
      this.notes});

  factory _$StockOpnameImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockOpnameImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'company_id')
  final int companyId;
  @override
  @JsonKey(name: 'opname_number')
  final String opnameNumber;
  @override
  @JsonKey(name: 'warehouse_id')
  final int warehouseId;
  @override
  @JsonKey(name: 'warehouse_name')
  final String? warehouseName;
  @override
  @JsonKey(name: 'company_name')
  final String? companyName;
  @override
  final String status;
  @override
  @JsonKey(name: 'started_at')
  final String? startedAt;
  @override
  @JsonKey(name: 'completed_at')
  final String? completedAt;
  @override
  @JsonKey(name: 'created_by')
  final int? createdBy;
  @override
  final String? notes;

  @override
  String toString() {
    return 'StockOpname(id: $id, companyId: $companyId, opnameNumber: $opnameNumber, warehouseId: $warehouseId, warehouseName: $warehouseName, companyName: $companyName, status: $status, startedAt: $startedAt, completedAt: $completedAt, createdBy: $createdBy, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockOpnameImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.opnameNumber, opnameNumber) ||
                other.opnameNumber == opnameNumber) &&
            (identical(other.warehouseId, warehouseId) ||
                other.warehouseId == warehouseId) &&
            (identical(other.warehouseName, warehouseName) ||
                other.warehouseName == warehouseName) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      companyId,
      opnameNumber,
      warehouseId,
      warehouseName,
      companyName,
      status,
      startedAt,
      completedAt,
      createdBy,
      notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StockOpnameImplCopyWith<_$StockOpnameImpl> get copyWith =>
      __$$StockOpnameImplCopyWithImpl<_$StockOpnameImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockOpnameImplToJson(
      this,
    );
  }
}

abstract class _StockOpname implements StockOpname {
  const factory _StockOpname(
      {required final int id,
      @JsonKey(name: 'company_id') required final int companyId,
      @JsonKey(name: 'opname_number') required final String opnameNumber,
      @JsonKey(name: 'warehouse_id') required final int warehouseId,
      @JsonKey(name: 'warehouse_name') final String? warehouseName,
      @JsonKey(name: 'company_name') final String? companyName,
      required final String status,
      @JsonKey(name: 'started_at') final String? startedAt,
      @JsonKey(name: 'completed_at') final String? completedAt,
      @JsonKey(name: 'created_by') final int? createdBy,
      final String? notes}) = _$StockOpnameImpl;

  factory _StockOpname.fromJson(Map<String, dynamic> json) =
      _$StockOpnameImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'company_id')
  int get companyId;
  @override
  @JsonKey(name: 'opname_number')
  String get opnameNumber;
  @override
  @JsonKey(name: 'warehouse_id')
  int get warehouseId;
  @override
  @JsonKey(name: 'warehouse_name')
  String? get warehouseName;
  @override
  @JsonKey(name: 'company_name')
  String? get companyName;
  @override
  String get status;
  @override
  @JsonKey(name: 'started_at')
  String? get startedAt;
  @override
  @JsonKey(name: 'completed_at')
  String? get completedAt;
  @override
  @JsonKey(name: 'created_by')
  int? get createdBy;
  @override
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$StockOpnameImplCopyWith<_$StockOpnameImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StockOpnameItem _$StockOpnameItemFromJson(Map<String, dynamic> json) {
  return _StockOpnameItem.fromJson(json);
}

/// @nodoc
mixin _$StockOpnameItem {
  String get sku => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name')
  String get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_unit')
  String get productUnit => throw _privateConstructorUsedError;
  @JsonKey(name: 'system_qty', fromJson: doubleFromJson)
  double get systemQty => throw _privateConstructorUsedError;
  @JsonKey(name: 'counted_qty', fromJson: doubleFromJson)
  double get countedQty => throw _privateConstructorUsedError;
  @JsonKey(fromJson: doubleFromJson)
  double get discrepancy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StockOpnameItemCopyWith<StockOpnameItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockOpnameItemCopyWith<$Res> {
  factory $StockOpnameItemCopyWith(
          StockOpnameItem value, $Res Function(StockOpnameItem) then) =
      _$StockOpnameItemCopyWithImpl<$Res, StockOpnameItem>;
  @useResult
  $Res call(
      {String sku,
      @JsonKey(name: 'product_name') String productName,
      @JsonKey(name: 'product_unit') String productUnit,
      @JsonKey(name: 'system_qty', fromJson: doubleFromJson) double systemQty,
      @JsonKey(name: 'counted_qty', fromJson: doubleFromJson) double countedQty,
      @JsonKey(fromJson: doubleFromJson) double discrepancy});
}

/// @nodoc
class _$StockOpnameItemCopyWithImpl<$Res, $Val extends StockOpnameItem>
    implements $StockOpnameItemCopyWith<$Res> {
  _$StockOpnameItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sku = null,
    Object? productName = null,
    Object? productUnit = null,
    Object? systemQty = null,
    Object? countedQty = null,
    Object? discrepancy = null,
  }) {
    return _then(_value.copyWith(
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      productUnit: null == productUnit
          ? _value.productUnit
          : productUnit // ignore: cast_nullable_to_non_nullable
              as String,
      systemQty: null == systemQty
          ? _value.systemQty
          : systemQty // ignore: cast_nullable_to_non_nullable
              as double,
      countedQty: null == countedQty
          ? _value.countedQty
          : countedQty // ignore: cast_nullable_to_non_nullable
              as double,
      discrepancy: null == discrepancy
          ? _value.discrepancy
          : discrepancy // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StockOpnameItemImplCopyWith<$Res>
    implements $StockOpnameItemCopyWith<$Res> {
  factory _$$StockOpnameItemImplCopyWith(_$StockOpnameItemImpl value,
          $Res Function(_$StockOpnameItemImpl) then) =
      __$$StockOpnameItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sku,
      @JsonKey(name: 'product_name') String productName,
      @JsonKey(name: 'product_unit') String productUnit,
      @JsonKey(name: 'system_qty', fromJson: doubleFromJson) double systemQty,
      @JsonKey(name: 'counted_qty', fromJson: doubleFromJson) double countedQty,
      @JsonKey(fromJson: doubleFromJson) double discrepancy});
}

/// @nodoc
class __$$StockOpnameItemImplCopyWithImpl<$Res>
    extends _$StockOpnameItemCopyWithImpl<$Res, _$StockOpnameItemImpl>
    implements _$$StockOpnameItemImplCopyWith<$Res> {
  __$$StockOpnameItemImplCopyWithImpl(
      _$StockOpnameItemImpl _value, $Res Function(_$StockOpnameItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sku = null,
    Object? productName = null,
    Object? productUnit = null,
    Object? systemQty = null,
    Object? countedQty = null,
    Object? discrepancy = null,
  }) {
    return _then(_$StockOpnameItemImpl(
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      productUnit: null == productUnit
          ? _value.productUnit
          : productUnit // ignore: cast_nullable_to_non_nullable
              as String,
      systemQty: null == systemQty
          ? _value.systemQty
          : systemQty // ignore: cast_nullable_to_non_nullable
              as double,
      countedQty: null == countedQty
          ? _value.countedQty
          : countedQty // ignore: cast_nullable_to_non_nullable
              as double,
      discrepancy: null == discrepancy
          ? _value.discrepancy
          : discrepancy // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockOpnameItemImpl implements _StockOpnameItem {
  const _$StockOpnameItemImpl(
      {required this.sku,
      @JsonKey(name: 'product_name') required this.productName,
      @JsonKey(name: 'product_unit') this.productUnit = 'pcs',
      @JsonKey(name: 'system_qty', fromJson: doubleFromJson)
      required this.systemQty,
      @JsonKey(name: 'counted_qty', fromJson: doubleFromJson)
      required this.countedQty,
      @JsonKey(fromJson: doubleFromJson) required this.discrepancy});

  factory _$StockOpnameItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockOpnameItemImplFromJson(json);

  @override
  final String sku;
  @override
  @JsonKey(name: 'product_name')
  final String productName;
  @override
  @JsonKey(name: 'product_unit')
  final String productUnit;
  @override
  @JsonKey(name: 'system_qty', fromJson: doubleFromJson)
  final double systemQty;
  @override
  @JsonKey(name: 'counted_qty', fromJson: doubleFromJson)
  final double countedQty;
  @override
  @JsonKey(fromJson: doubleFromJson)
  final double discrepancy;

  @override
  String toString() {
    return 'StockOpnameItem(sku: $sku, productName: $productName, productUnit: $productUnit, systemQty: $systemQty, countedQty: $countedQty, discrepancy: $discrepancy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockOpnameItemImpl &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productUnit, productUnit) ||
                other.productUnit == productUnit) &&
            (identical(other.systemQty, systemQty) ||
                other.systemQty == systemQty) &&
            (identical(other.countedQty, countedQty) ||
                other.countedQty == countedQty) &&
            (identical(other.discrepancy, discrepancy) ||
                other.discrepancy == discrepancy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, sku, productName, productUnit,
      systemQty, countedQty, discrepancy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StockOpnameItemImplCopyWith<_$StockOpnameItemImpl> get copyWith =>
      __$$StockOpnameItemImplCopyWithImpl<_$StockOpnameItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockOpnameItemImplToJson(
      this,
    );
  }
}

abstract class _StockOpnameItem implements StockOpnameItem {
  const factory _StockOpnameItem(
      {required final String sku,
      @JsonKey(name: 'product_name') required final String productName,
      @JsonKey(name: 'product_unit') final String productUnit,
      @JsonKey(name: 'system_qty', fromJson: doubleFromJson)
      required final double systemQty,
      @JsonKey(name: 'counted_qty', fromJson: doubleFromJson)
      required final double countedQty,
      @JsonKey(fromJson: doubleFromJson)
      required final double discrepancy}) = _$StockOpnameItemImpl;

  factory _StockOpnameItem.fromJson(Map<String, dynamic> json) =
      _$StockOpnameItemImpl.fromJson;

  @override
  String get sku;
  @override
  @JsonKey(name: 'product_name')
  String get productName;
  @override
  @JsonKey(name: 'product_unit')
  String get productUnit;
  @override
  @JsonKey(name: 'system_qty', fromJson: doubleFromJson)
  double get systemQty;
  @override
  @JsonKey(name: 'counted_qty', fromJson: doubleFromJson)
  double get countedQty;
  @override
  @JsonKey(fromJson: doubleFromJson)
  double get discrepancy;
  @override
  @JsonKey(ignore: true)
  _$$StockOpnameItemImplCopyWith<_$StockOpnameItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
