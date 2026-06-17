// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receiving.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReceivingItem _$ReceivingItemFromJson(Map<String, dynamic> json) {
  return _ReceivingItem.fromJson(json);
}

/// @nodoc
mixin _$ReceivingItem {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name')
  String get productName => throw _privateConstructorUsedError;
  String get sku => throw _privateConstructorUsedError;
  @JsonKey(fromJson: doubleFromJson)
  double get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'ordered_qty', fromJson: doubleOrNullFromJson)
  double? get orderedQty => throw _privateConstructorUsedError;
  @JsonKey(name: 'remaining_qty', fromJson: doubleOrNullFromJson)
  double? get remainingQty => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_id')
  int? get locationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_name')
  String? get locationName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReceivingItemCopyWith<ReceivingItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceivingItemCopyWith<$Res> {
  factory $ReceivingItemCopyWith(
          ReceivingItem value, $Res Function(ReceivingItem) then) =
      _$ReceivingItemCopyWithImpl<$Res, ReceivingItem>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'product_name') String productName,
      String sku,
      @JsonKey(fromJson: doubleFromJson) double quantity,
      @JsonKey(name: 'ordered_qty', fromJson: doubleOrNullFromJson)
      double? orderedQty,
      @JsonKey(name: 'remaining_qty', fromJson: doubleOrNullFromJson)
      double? remainingQty,
      @JsonKey(name: 'location_id') int? locationId,
      @JsonKey(name: 'location_name') String? locationName});
}

/// @nodoc
class _$ReceivingItemCopyWithImpl<$Res, $Val extends ReceivingItem>
    implements $ReceivingItemCopyWith<$Res> {
  _$ReceivingItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productName = null,
    Object? sku = null,
    Object? quantity = null,
    Object? orderedQty = freezed,
    Object? remainingQty = freezed,
    Object? locationId = freezed,
    Object? locationName = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      orderedQty: freezed == orderedQty
          ? _value.orderedQty
          : orderedQty // ignore: cast_nullable_to_non_nullable
              as double?,
      remainingQty: freezed == remainingQty
          ? _value.remainingQty
          : remainingQty // ignore: cast_nullable_to_non_nullable
              as double?,
      locationId: freezed == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as int?,
      locationName: freezed == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReceivingItemImplCopyWith<$Res>
    implements $ReceivingItemCopyWith<$Res> {
  factory _$$ReceivingItemImplCopyWith(
          _$ReceivingItemImpl value, $Res Function(_$ReceivingItemImpl) then) =
      __$$ReceivingItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'product_name') String productName,
      String sku,
      @JsonKey(fromJson: doubleFromJson) double quantity,
      @JsonKey(name: 'ordered_qty', fromJson: doubleOrNullFromJson)
      double? orderedQty,
      @JsonKey(name: 'remaining_qty', fromJson: doubleOrNullFromJson)
      double? remainingQty,
      @JsonKey(name: 'location_id') int? locationId,
      @JsonKey(name: 'location_name') String? locationName});
}

/// @nodoc
class __$$ReceivingItemImplCopyWithImpl<$Res>
    extends _$ReceivingItemCopyWithImpl<$Res, _$ReceivingItemImpl>
    implements _$$ReceivingItemImplCopyWith<$Res> {
  __$$ReceivingItemImplCopyWithImpl(
      _$ReceivingItemImpl _value, $Res Function(_$ReceivingItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productName = null,
    Object? sku = null,
    Object? quantity = null,
    Object? orderedQty = freezed,
    Object? remainingQty = freezed,
    Object? locationId = freezed,
    Object? locationName = freezed,
  }) {
    return _then(_$ReceivingItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      orderedQty: freezed == orderedQty
          ? _value.orderedQty
          : orderedQty // ignore: cast_nullable_to_non_nullable
              as double?,
      remainingQty: freezed == remainingQty
          ? _value.remainingQty
          : remainingQty // ignore: cast_nullable_to_non_nullable
              as double?,
      locationId: freezed == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as int?,
      locationName: freezed == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReceivingItemImpl implements _ReceivingItem {
  const _$ReceivingItemImpl(
      {required this.id,
      @JsonKey(name: 'product_name') required this.productName,
      required this.sku,
      @JsonKey(fromJson: doubleFromJson) required this.quantity,
      @JsonKey(name: 'ordered_qty', fromJson: doubleOrNullFromJson)
      this.orderedQty,
      @JsonKey(name: 'remaining_qty', fromJson: doubleOrNullFromJson)
      this.remainingQty,
      @JsonKey(name: 'location_id') this.locationId,
      @JsonKey(name: 'location_name') this.locationName});

  factory _$ReceivingItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReceivingItemImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'product_name')
  final String productName;
  @override
  final String sku;
  @override
  @JsonKey(fromJson: doubleFromJson)
  final double quantity;
  @override
  @JsonKey(name: 'ordered_qty', fromJson: doubleOrNullFromJson)
  final double? orderedQty;
  @override
  @JsonKey(name: 'remaining_qty', fromJson: doubleOrNullFromJson)
  final double? remainingQty;
  @override
  @JsonKey(name: 'location_id')
  final int? locationId;
  @override
  @JsonKey(name: 'location_name')
  final String? locationName;

  @override
  String toString() {
    return 'ReceivingItem(id: $id, productName: $productName, sku: $sku, quantity: $quantity, orderedQty: $orderedQty, remainingQty: $remainingQty, locationId: $locationId, locationName: $locationName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceivingItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.orderedQty, orderedQty) ||
                other.orderedQty == orderedQty) &&
            (identical(other.remainingQty, remainingQty) ||
                other.remainingQty == remainingQty) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, productName, sku, quantity,
      orderedQty, remainingQty, locationId, locationName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceivingItemImplCopyWith<_$ReceivingItemImpl> get copyWith =>
      __$$ReceivingItemImplCopyWithImpl<_$ReceivingItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReceivingItemImplToJson(
      this,
    );
  }
}

abstract class _ReceivingItem implements ReceivingItem {
  const factory _ReceivingItem(
          {required final int id,
          @JsonKey(name: 'product_name') required final String productName,
          required final String sku,
          @JsonKey(fromJson: doubleFromJson) required final double quantity,
          @JsonKey(name: 'ordered_qty', fromJson: doubleOrNullFromJson)
          final double? orderedQty,
          @JsonKey(name: 'remaining_qty', fromJson: doubleOrNullFromJson)
          final double? remainingQty,
          @JsonKey(name: 'location_id') final int? locationId,
          @JsonKey(name: 'location_name') final String? locationName}) =
      _$ReceivingItemImpl;

  factory _ReceivingItem.fromJson(Map<String, dynamic> json) =
      _$ReceivingItemImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'product_name')
  String get productName;
  @override
  String get sku;
  @override
  @JsonKey(fromJson: doubleFromJson)
  double get quantity;
  @override
  @JsonKey(name: 'ordered_qty', fromJson: doubleOrNullFromJson)
  double? get orderedQty;
  @override
  @JsonKey(name: 'remaining_qty', fromJson: doubleOrNullFromJson)
  double? get remainingQty;
  @override
  @JsonKey(name: 'location_id')
  int? get locationId;
  @override
  @JsonKey(name: 'location_name')
  String? get locationName;
  @override
  @JsonKey(ignore: true)
  _$$ReceivingItemImplCopyWith<_$ReceivingItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateReceivingRequest _$CreateReceivingRequestFromJson(
    Map<String, dynamic> json) {
  return _CreateReceivingRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateReceivingRequest {
  @JsonKey(name: 'po_header_id')
  int get poHeaderId => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'truck_number')
  String? get truckNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_order_number')
  String? get deliveryOrderNumber => throw _privateConstructorUsedError;
  List<ReceivingItemRequest> get items => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreateReceivingRequestCopyWith<CreateReceivingRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateReceivingRequestCopyWith<$Res> {
  factory $CreateReceivingRequestCopyWith(CreateReceivingRequest value,
          $Res Function(CreateReceivingRequest) then) =
      _$CreateReceivingRequestCopyWithImpl<$Res, CreateReceivingRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'po_header_id') int poHeaderId,
      String? notes,
      @JsonKey(name: 'truck_number') String? truckNumber,
      @JsonKey(name: 'delivery_order_number') String? deliveryOrderNumber,
      List<ReceivingItemRequest> items});
}

/// @nodoc
class _$CreateReceivingRequestCopyWithImpl<$Res,
        $Val extends CreateReceivingRequest>
    implements $CreateReceivingRequestCopyWith<$Res> {
  _$CreateReceivingRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poHeaderId = null,
    Object? notes = freezed,
    Object? truckNumber = freezed,
    Object? deliveryOrderNumber = freezed,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      poHeaderId: null == poHeaderId
          ? _value.poHeaderId
          : poHeaderId // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      truckNumber: freezed == truckNumber
          ? _value.truckNumber
          : truckNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryOrderNumber: freezed == deliveryOrderNumber
          ? _value.deliveryOrderNumber
          : deliveryOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ReceivingItemRequest>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateReceivingRequestImplCopyWith<$Res>
    implements $CreateReceivingRequestCopyWith<$Res> {
  factory _$$CreateReceivingRequestImplCopyWith(
          _$CreateReceivingRequestImpl value,
          $Res Function(_$CreateReceivingRequestImpl) then) =
      __$$CreateReceivingRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'po_header_id') int poHeaderId,
      String? notes,
      @JsonKey(name: 'truck_number') String? truckNumber,
      @JsonKey(name: 'delivery_order_number') String? deliveryOrderNumber,
      List<ReceivingItemRequest> items});
}

/// @nodoc
class __$$CreateReceivingRequestImplCopyWithImpl<$Res>
    extends _$CreateReceivingRequestCopyWithImpl<$Res,
        _$CreateReceivingRequestImpl>
    implements _$$CreateReceivingRequestImplCopyWith<$Res> {
  __$$CreateReceivingRequestImplCopyWithImpl(
      _$CreateReceivingRequestImpl _value,
      $Res Function(_$CreateReceivingRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poHeaderId = null,
    Object? notes = freezed,
    Object? truckNumber = freezed,
    Object? deliveryOrderNumber = freezed,
    Object? items = null,
  }) {
    return _then(_$CreateReceivingRequestImpl(
      poHeaderId: null == poHeaderId
          ? _value.poHeaderId
          : poHeaderId // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      truckNumber: freezed == truckNumber
          ? _value.truckNumber
          : truckNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryOrderNumber: freezed == deliveryOrderNumber
          ? _value.deliveryOrderNumber
          : deliveryOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ReceivingItemRequest>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateReceivingRequestImpl implements _CreateReceivingRequest {
  const _$CreateReceivingRequestImpl(
      {@JsonKey(name: 'po_header_id') required this.poHeaderId,
      this.notes,
      @JsonKey(name: 'truck_number') this.truckNumber,
      @JsonKey(name: 'delivery_order_number') this.deliveryOrderNumber,
      required final List<ReceivingItemRequest> items})
      : _items = items;

  factory _$CreateReceivingRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateReceivingRequestImplFromJson(json);

  @override
  @JsonKey(name: 'po_header_id')
  final int poHeaderId;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'truck_number')
  final String? truckNumber;
  @override
  @JsonKey(name: 'delivery_order_number')
  final String? deliveryOrderNumber;
  final List<ReceivingItemRequest> _items;
  @override
  List<ReceivingItemRequest> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'CreateReceivingRequest(poHeaderId: $poHeaderId, notes: $notes, truckNumber: $truckNumber, deliveryOrderNumber: $deliveryOrderNumber, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateReceivingRequestImpl &&
            (identical(other.poHeaderId, poHeaderId) ||
                other.poHeaderId == poHeaderId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.truckNumber, truckNumber) ||
                other.truckNumber == truckNumber) &&
            (identical(other.deliveryOrderNumber, deliveryOrderNumber) ||
                other.deliveryOrderNumber == deliveryOrderNumber) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, poHeaderId, notes, truckNumber,
      deliveryOrderNumber, const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateReceivingRequestImplCopyWith<_$CreateReceivingRequestImpl>
      get copyWith => __$$CreateReceivingRequestImplCopyWithImpl<
          _$CreateReceivingRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateReceivingRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateReceivingRequest implements CreateReceivingRequest {
  const factory _CreateReceivingRequest(
      {@JsonKey(name: 'po_header_id') required final int poHeaderId,
      final String? notes,
      @JsonKey(name: 'truck_number') final String? truckNumber,
      @JsonKey(name: 'delivery_order_number') final String? deliveryOrderNumber,
      required final List<ReceivingItemRequest>
          items}) = _$CreateReceivingRequestImpl;

  factory _CreateReceivingRequest.fromJson(Map<String, dynamic> json) =
      _$CreateReceivingRequestImpl.fromJson;

  @override
  @JsonKey(name: 'po_header_id')
  int get poHeaderId;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'truck_number')
  String? get truckNumber;
  @override
  @JsonKey(name: 'delivery_order_number')
  String? get deliveryOrderNumber;
  @override
  List<ReceivingItemRequest> get items;
  @override
  @JsonKey(ignore: true)
  _$$CreateReceivingRequestImplCopyWith<_$CreateReceivingRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ReceivingItemRequest _$ReceivingItemRequestFromJson(Map<String, dynamic> json) {
  return _ReceivingItemRequest.fromJson(json);
}

/// @nodoc
mixin _$ReceivingItemRequest {
  @JsonKey(name: 'po_detail_id')
  int get poDetailId => throw _privateConstructorUsedError;
  @JsonKey(name: 'received_qty', fromJson: doubleFromJson)
  double get receivedQty => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_id')
  int? get locationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'discrepancy_type')
  String get discrepancyType => throw _privateConstructorUsedError;
  @JsonKey(name: 'discrepancy_note')
  String? get discrepancyNote => throw _privateConstructorUsedError;
  @JsonKey(name: 'discrepancy_qty', fromJson: doubleOrNullFromJson)
  double? get discrepancyQty => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_path')
  String? get photoPath => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReceivingItemRequestCopyWith<ReceivingItemRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceivingItemRequestCopyWith<$Res> {
  factory $ReceivingItemRequestCopyWith(ReceivingItemRequest value,
          $Res Function(ReceivingItemRequest) then) =
      _$ReceivingItemRequestCopyWithImpl<$Res, ReceivingItemRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'po_detail_id') int poDetailId,
      @JsonKey(name: 'received_qty', fromJson: doubleFromJson)
      double receivedQty,
      int version,
      @JsonKey(name: 'location_id') int? locationId,
      @JsonKey(name: 'discrepancy_type') String discrepancyType,
      @JsonKey(name: 'discrepancy_note') String? discrepancyNote,
      @JsonKey(name: 'discrepancy_qty', fromJson: doubleOrNullFromJson)
      double? discrepancyQty,
      @JsonKey(name: 'photo_path') String? photoPath});
}

/// @nodoc
class _$ReceivingItemRequestCopyWithImpl<$Res,
        $Val extends ReceivingItemRequest>
    implements $ReceivingItemRequestCopyWith<$Res> {
  _$ReceivingItemRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poDetailId = null,
    Object? receivedQty = null,
    Object? version = null,
    Object? locationId = freezed,
    Object? discrepancyType = null,
    Object? discrepancyNote = freezed,
    Object? discrepancyQty = freezed,
    Object? photoPath = freezed,
  }) {
    return _then(_value.copyWith(
      poDetailId: null == poDetailId
          ? _value.poDetailId
          : poDetailId // ignore: cast_nullable_to_non_nullable
              as int,
      receivedQty: null == receivedQty
          ? _value.receivedQty
          : receivedQty // ignore: cast_nullable_to_non_nullable
              as double,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      locationId: freezed == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as int?,
      discrepancyType: null == discrepancyType
          ? _value.discrepancyType
          : discrepancyType // ignore: cast_nullable_to_non_nullable
              as String,
      discrepancyNote: freezed == discrepancyNote
          ? _value.discrepancyNote
          : discrepancyNote // ignore: cast_nullable_to_non_nullable
              as String?,
      discrepancyQty: freezed == discrepancyQty
          ? _value.discrepancyQty
          : discrepancyQty // ignore: cast_nullable_to_non_nullable
              as double?,
      photoPath: freezed == photoPath
          ? _value.photoPath
          : photoPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReceivingItemRequestImplCopyWith<$Res>
    implements $ReceivingItemRequestCopyWith<$Res> {
  factory _$$ReceivingItemRequestImplCopyWith(_$ReceivingItemRequestImpl value,
          $Res Function(_$ReceivingItemRequestImpl) then) =
      __$$ReceivingItemRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'po_detail_id') int poDetailId,
      @JsonKey(name: 'received_qty', fromJson: doubleFromJson)
      double receivedQty,
      int version,
      @JsonKey(name: 'location_id') int? locationId,
      @JsonKey(name: 'discrepancy_type') String discrepancyType,
      @JsonKey(name: 'discrepancy_note') String? discrepancyNote,
      @JsonKey(name: 'discrepancy_qty', fromJson: doubleOrNullFromJson)
      double? discrepancyQty,
      @JsonKey(name: 'photo_path') String? photoPath});
}

/// @nodoc
class __$$ReceivingItemRequestImplCopyWithImpl<$Res>
    extends _$ReceivingItemRequestCopyWithImpl<$Res, _$ReceivingItemRequestImpl>
    implements _$$ReceivingItemRequestImplCopyWith<$Res> {
  __$$ReceivingItemRequestImplCopyWithImpl(_$ReceivingItemRequestImpl _value,
      $Res Function(_$ReceivingItemRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poDetailId = null,
    Object? receivedQty = null,
    Object? version = null,
    Object? locationId = freezed,
    Object? discrepancyType = null,
    Object? discrepancyNote = freezed,
    Object? discrepancyQty = freezed,
    Object? photoPath = freezed,
  }) {
    return _then(_$ReceivingItemRequestImpl(
      poDetailId: null == poDetailId
          ? _value.poDetailId
          : poDetailId // ignore: cast_nullable_to_non_nullable
              as int,
      receivedQty: null == receivedQty
          ? _value.receivedQty
          : receivedQty // ignore: cast_nullable_to_non_nullable
              as double,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      locationId: freezed == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as int?,
      discrepancyType: null == discrepancyType
          ? _value.discrepancyType
          : discrepancyType // ignore: cast_nullable_to_non_nullable
              as String,
      discrepancyNote: freezed == discrepancyNote
          ? _value.discrepancyNote
          : discrepancyNote // ignore: cast_nullable_to_non_nullable
              as String?,
      discrepancyQty: freezed == discrepancyQty
          ? _value.discrepancyQty
          : discrepancyQty // ignore: cast_nullable_to_non_nullable
              as double?,
      photoPath: freezed == photoPath
          ? _value.photoPath
          : photoPath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReceivingItemRequestImpl implements _ReceivingItemRequest {
  const _$ReceivingItemRequestImpl(
      {@JsonKey(name: 'po_detail_id') required this.poDetailId,
      @JsonKey(name: 'received_qty', fromJson: doubleFromJson)
      required this.receivedQty,
      required this.version,
      @JsonKey(name: 'location_id') this.locationId,
      @JsonKey(name: 'discrepancy_type') this.discrepancyType = 'none',
      @JsonKey(name: 'discrepancy_note') this.discrepancyNote,
      @JsonKey(name: 'discrepancy_qty', fromJson: doubleOrNullFromJson)
      this.discrepancyQty,
      @JsonKey(name: 'photo_path') this.photoPath});

  factory _$ReceivingItemRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReceivingItemRequestImplFromJson(json);

  @override
  @JsonKey(name: 'po_detail_id')
  final int poDetailId;
  @override
  @JsonKey(name: 'received_qty', fromJson: doubleFromJson)
  final double receivedQty;
  @override
  final int version;
  @override
  @JsonKey(name: 'location_id')
  final int? locationId;
  @override
  @JsonKey(name: 'discrepancy_type')
  final String discrepancyType;
  @override
  @JsonKey(name: 'discrepancy_note')
  final String? discrepancyNote;
  @override
  @JsonKey(name: 'discrepancy_qty', fromJson: doubleOrNullFromJson)
  final double? discrepancyQty;
  @override
  @JsonKey(name: 'photo_path')
  final String? photoPath;

  @override
  String toString() {
    return 'ReceivingItemRequest(poDetailId: $poDetailId, receivedQty: $receivedQty, version: $version, locationId: $locationId, discrepancyType: $discrepancyType, discrepancyNote: $discrepancyNote, discrepancyQty: $discrepancyQty, photoPath: $photoPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceivingItemRequestImpl &&
            (identical(other.poDetailId, poDetailId) ||
                other.poDetailId == poDetailId) &&
            (identical(other.receivedQty, receivedQty) ||
                other.receivedQty == receivedQty) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.discrepancyType, discrepancyType) ||
                other.discrepancyType == discrepancyType) &&
            (identical(other.discrepancyNote, discrepancyNote) ||
                other.discrepancyNote == discrepancyNote) &&
            (identical(other.discrepancyQty, discrepancyQty) ||
                other.discrepancyQty == discrepancyQty) &&
            (identical(other.photoPath, photoPath) ||
                other.photoPath == photoPath));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, poDetailId, receivedQty, version,
      locationId, discrepancyType, discrepancyNote, discrepancyQty, photoPath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceivingItemRequestImplCopyWith<_$ReceivingItemRequestImpl>
      get copyWith =>
          __$$ReceivingItemRequestImplCopyWithImpl<_$ReceivingItemRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReceivingItemRequestImplToJson(
      this,
    );
  }
}

abstract class _ReceivingItemRequest implements ReceivingItemRequest {
  const factory _ReceivingItemRequest(
          {@JsonKey(name: 'po_detail_id') required final int poDetailId,
          @JsonKey(name: 'received_qty', fromJson: doubleFromJson)
          required final double receivedQty,
          required final int version,
          @JsonKey(name: 'location_id') final int? locationId,
          @JsonKey(name: 'discrepancy_type') final String discrepancyType,
          @JsonKey(name: 'discrepancy_note') final String? discrepancyNote,
          @JsonKey(name: 'discrepancy_qty', fromJson: doubleOrNullFromJson)
          final double? discrepancyQty,
          @JsonKey(name: 'photo_path') final String? photoPath}) =
      _$ReceivingItemRequestImpl;

  factory _ReceivingItemRequest.fromJson(Map<String, dynamic> json) =
      _$ReceivingItemRequestImpl.fromJson;

  @override
  @JsonKey(name: 'po_detail_id')
  int get poDetailId;
  @override
  @JsonKey(name: 'received_qty', fromJson: doubleFromJson)
  double get receivedQty;
  @override
  int get version;
  @override
  @JsonKey(name: 'location_id')
  int? get locationId;
  @override
  @JsonKey(name: 'discrepancy_type')
  String get discrepancyType;
  @override
  @JsonKey(name: 'discrepancy_note')
  String? get discrepancyNote;
  @override
  @JsonKey(name: 'discrepancy_qty', fromJson: doubleOrNullFromJson)
  double? get discrepancyQty;
  @override
  @JsonKey(name: 'photo_path')
  String? get photoPath;
  @override
  @JsonKey(ignore: true)
  _$$ReceivingItemRequestImplCopyWith<_$ReceivingItemRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ReceivingHistoryItem _$ReceivingHistoryItemFromJson(Map<String, dynamic> json) {
  return _ReceivingHistoryItem.fromJson(json);
}

/// @nodoc
mixin _$ReceivingHistoryItem {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'receiving_number')
  String get receivingNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'pdf_url')
  String? get pdfUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'po_header_id')
  int get poHeaderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'po_number')
  String? get poNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  int get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'transaction_date')
  String get transactionDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'received_at')
  String get receivedAt => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'truck_number')
  String? get truckNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_order_number')
  String? get deliveryOrderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_name')
  String get supplierName => throw _privateConstructorUsedError;
  @JsonKey(name: 'details_count')
  int get detailsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'warehouse_name')
  String? get warehouseName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReceivingHistoryItemCopyWith<ReceivingHistoryItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceivingHistoryItemCopyWith<$Res> {
  factory $ReceivingHistoryItemCopyWith(ReceivingHistoryItem value,
          $Res Function(ReceivingHistoryItem) then) =
      _$ReceivingHistoryItemCopyWithImpl<$Res, ReceivingHistoryItem>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'receiving_number') String receivingNumber,
      @JsonKey(name: 'pdf_url') String? pdfUrl,
      @JsonKey(name: 'po_header_id') int poHeaderId,
      @JsonKey(name: 'po_number') String? poNumber,
      @JsonKey(name: 'company_id') int companyId,
      @JsonKey(name: 'transaction_date') String transactionDate,
      @JsonKey(name: 'received_at') String receivedAt,
      String status,
      @JsonKey(name: 'truck_number') String? truckNumber,
      @JsonKey(name: 'delivery_order_number') String? deliveryOrderNumber,
      @JsonKey(name: 'supplier_name') String supplierName,
      @JsonKey(name: 'details_count') int detailsCount,
      @JsonKey(name: 'warehouse_name') String? warehouseName});
}

/// @nodoc
class _$ReceivingHistoryItemCopyWithImpl<$Res,
        $Val extends ReceivingHistoryItem>
    implements $ReceivingHistoryItemCopyWith<$Res> {
  _$ReceivingHistoryItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? receivingNumber = null,
    Object? pdfUrl = freezed,
    Object? poHeaderId = null,
    Object? poNumber = freezed,
    Object? companyId = null,
    Object? transactionDate = null,
    Object? receivedAt = null,
    Object? status = null,
    Object? truckNumber = freezed,
    Object? deliveryOrderNumber = freezed,
    Object? supplierName = null,
    Object? detailsCount = null,
    Object? warehouseName = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      receivingNumber: null == receivingNumber
          ? _value.receivingNumber
          : receivingNumber // ignore: cast_nullable_to_non_nullable
              as String,
      pdfUrl: freezed == pdfUrl
          ? _value.pdfUrl
          : pdfUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      poHeaderId: null == poHeaderId
          ? _value.poHeaderId
          : poHeaderId // ignore: cast_nullable_to_non_nullable
              as int,
      poNumber: freezed == poNumber
          ? _value.poNumber
          : poNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int,
      transactionDate: null == transactionDate
          ? _value.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as String,
      receivedAt: null == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      truckNumber: freezed == truckNumber
          ? _value.truckNumber
          : truckNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryOrderNumber: freezed == deliveryOrderNumber
          ? _value.deliveryOrderNumber
          : deliveryOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierName: null == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String,
      detailsCount: null == detailsCount
          ? _value.detailsCount
          : detailsCount // ignore: cast_nullable_to_non_nullable
              as int,
      warehouseName: freezed == warehouseName
          ? _value.warehouseName
          : warehouseName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReceivingHistoryItemImplCopyWith<$Res>
    implements $ReceivingHistoryItemCopyWith<$Res> {
  factory _$$ReceivingHistoryItemImplCopyWith(_$ReceivingHistoryItemImpl value,
          $Res Function(_$ReceivingHistoryItemImpl) then) =
      __$$ReceivingHistoryItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'receiving_number') String receivingNumber,
      @JsonKey(name: 'pdf_url') String? pdfUrl,
      @JsonKey(name: 'po_header_id') int poHeaderId,
      @JsonKey(name: 'po_number') String? poNumber,
      @JsonKey(name: 'company_id') int companyId,
      @JsonKey(name: 'transaction_date') String transactionDate,
      @JsonKey(name: 'received_at') String receivedAt,
      String status,
      @JsonKey(name: 'truck_number') String? truckNumber,
      @JsonKey(name: 'delivery_order_number') String? deliveryOrderNumber,
      @JsonKey(name: 'supplier_name') String supplierName,
      @JsonKey(name: 'details_count') int detailsCount,
      @JsonKey(name: 'warehouse_name') String? warehouseName});
}

/// @nodoc
class __$$ReceivingHistoryItemImplCopyWithImpl<$Res>
    extends _$ReceivingHistoryItemCopyWithImpl<$Res, _$ReceivingHistoryItemImpl>
    implements _$$ReceivingHistoryItemImplCopyWith<$Res> {
  __$$ReceivingHistoryItemImplCopyWithImpl(_$ReceivingHistoryItemImpl _value,
      $Res Function(_$ReceivingHistoryItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? receivingNumber = null,
    Object? pdfUrl = freezed,
    Object? poHeaderId = null,
    Object? poNumber = freezed,
    Object? companyId = null,
    Object? transactionDate = null,
    Object? receivedAt = null,
    Object? status = null,
    Object? truckNumber = freezed,
    Object? deliveryOrderNumber = freezed,
    Object? supplierName = null,
    Object? detailsCount = null,
    Object? warehouseName = freezed,
  }) {
    return _then(_$ReceivingHistoryItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      receivingNumber: null == receivingNumber
          ? _value.receivingNumber
          : receivingNumber // ignore: cast_nullable_to_non_nullable
              as String,
      pdfUrl: freezed == pdfUrl
          ? _value.pdfUrl
          : pdfUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      poHeaderId: null == poHeaderId
          ? _value.poHeaderId
          : poHeaderId // ignore: cast_nullable_to_non_nullable
              as int,
      poNumber: freezed == poNumber
          ? _value.poNumber
          : poNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int,
      transactionDate: null == transactionDate
          ? _value.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as String,
      receivedAt: null == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      truckNumber: freezed == truckNumber
          ? _value.truckNumber
          : truckNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryOrderNumber: freezed == deliveryOrderNumber
          ? _value.deliveryOrderNumber
          : deliveryOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierName: null == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String,
      detailsCount: null == detailsCount
          ? _value.detailsCount
          : detailsCount // ignore: cast_nullable_to_non_nullable
              as int,
      warehouseName: freezed == warehouseName
          ? _value.warehouseName
          : warehouseName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReceivingHistoryItemImpl implements _ReceivingHistoryItem {
  const _$ReceivingHistoryItemImpl(
      {required this.id,
      @JsonKey(name: 'receiving_number') required this.receivingNumber,
      @JsonKey(name: 'pdf_url') this.pdfUrl,
      @JsonKey(name: 'po_header_id') required this.poHeaderId,
      @JsonKey(name: 'po_number') this.poNumber,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'transaction_date') required this.transactionDate,
      @JsonKey(name: 'received_at') required this.receivedAt,
      required this.status,
      @JsonKey(name: 'truck_number') this.truckNumber,
      @JsonKey(name: 'delivery_order_number') this.deliveryOrderNumber,
      @JsonKey(name: 'supplier_name') required this.supplierName,
      @JsonKey(name: 'details_count') required this.detailsCount,
      @JsonKey(name: 'warehouse_name') this.warehouseName});

  factory _$ReceivingHistoryItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReceivingHistoryItemImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'receiving_number')
  final String receivingNumber;
  @override
  @JsonKey(name: 'pdf_url')
  final String? pdfUrl;
  @override
  @JsonKey(name: 'po_header_id')
  final int poHeaderId;
  @override
  @JsonKey(name: 'po_number')
  final String? poNumber;
  @override
  @JsonKey(name: 'company_id')
  final int companyId;
  @override
  @JsonKey(name: 'transaction_date')
  final String transactionDate;
  @override
  @JsonKey(name: 'received_at')
  final String receivedAt;
  @override
  final String status;
  @override
  @JsonKey(name: 'truck_number')
  final String? truckNumber;
  @override
  @JsonKey(name: 'delivery_order_number')
  final String? deliveryOrderNumber;
  @override
  @JsonKey(name: 'supplier_name')
  final String supplierName;
  @override
  @JsonKey(name: 'details_count')
  final int detailsCount;
  @override
  @JsonKey(name: 'warehouse_name')
  final String? warehouseName;

  @override
  String toString() {
    return 'ReceivingHistoryItem(id: $id, receivingNumber: $receivingNumber, pdfUrl: $pdfUrl, poHeaderId: $poHeaderId, poNumber: $poNumber, companyId: $companyId, transactionDate: $transactionDate, receivedAt: $receivedAt, status: $status, truckNumber: $truckNumber, deliveryOrderNumber: $deliveryOrderNumber, supplierName: $supplierName, detailsCount: $detailsCount, warehouseName: $warehouseName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceivingHistoryItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.receivingNumber, receivingNumber) ||
                other.receivingNumber == receivingNumber) &&
            (identical(other.pdfUrl, pdfUrl) || other.pdfUrl == pdfUrl) &&
            (identical(other.poHeaderId, poHeaderId) ||
                other.poHeaderId == poHeaderId) &&
            (identical(other.poNumber, poNumber) ||
                other.poNumber == poNumber) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.truckNumber, truckNumber) ||
                other.truckNumber == truckNumber) &&
            (identical(other.deliveryOrderNumber, deliveryOrderNumber) ||
                other.deliveryOrderNumber == deliveryOrderNumber) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            (identical(other.detailsCount, detailsCount) ||
                other.detailsCount == detailsCount) &&
            (identical(other.warehouseName, warehouseName) ||
                other.warehouseName == warehouseName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      receivingNumber,
      pdfUrl,
      poHeaderId,
      poNumber,
      companyId,
      transactionDate,
      receivedAt,
      status,
      truckNumber,
      deliveryOrderNumber,
      supplierName,
      detailsCount,
      warehouseName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceivingHistoryItemImplCopyWith<_$ReceivingHistoryItemImpl>
      get copyWith =>
          __$$ReceivingHistoryItemImplCopyWithImpl<_$ReceivingHistoryItemImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReceivingHistoryItemImplToJson(
      this,
    );
  }
}

abstract class _ReceivingHistoryItem implements ReceivingHistoryItem {
  const factory _ReceivingHistoryItem(
      {required final int id,
      @JsonKey(name: 'receiving_number') required final String receivingNumber,
      @JsonKey(name: 'pdf_url') final String? pdfUrl,
      @JsonKey(name: 'po_header_id') required final int poHeaderId,
      @JsonKey(name: 'po_number') final String? poNumber,
      @JsonKey(name: 'company_id') required final int companyId,
      @JsonKey(name: 'transaction_date') required final String transactionDate,
      @JsonKey(name: 'received_at') required final String receivedAt,
      required final String status,
      @JsonKey(name: 'truck_number') final String? truckNumber,
      @JsonKey(name: 'delivery_order_number') final String? deliveryOrderNumber,
      @JsonKey(name: 'supplier_name') required final String supplierName,
      @JsonKey(name: 'details_count') required final int detailsCount,
      @JsonKey(name: 'warehouse_name')
      final String? warehouseName}) = _$ReceivingHistoryItemImpl;

  factory _ReceivingHistoryItem.fromJson(Map<String, dynamic> json) =
      _$ReceivingHistoryItemImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'receiving_number')
  String get receivingNumber;
  @override
  @JsonKey(name: 'pdf_url')
  String? get pdfUrl;
  @override
  @JsonKey(name: 'po_header_id')
  int get poHeaderId;
  @override
  @JsonKey(name: 'po_number')
  String? get poNumber;
  @override
  @JsonKey(name: 'company_id')
  int get companyId;
  @override
  @JsonKey(name: 'transaction_date')
  String get transactionDate;
  @override
  @JsonKey(name: 'received_at')
  String get receivedAt;
  @override
  String get status;
  @override
  @JsonKey(name: 'truck_number')
  String? get truckNumber;
  @override
  @JsonKey(name: 'delivery_order_number')
  String? get deliveryOrderNumber;
  @override
  @JsonKey(name: 'supplier_name')
  String get supplierName;
  @override
  @JsonKey(name: 'details_count')
  int get detailsCount;
  @override
  @JsonKey(name: 'warehouse_name')
  String? get warehouseName;
  @override
  @JsonKey(ignore: true)
  _$$ReceivingHistoryItemImplCopyWith<_$ReceivingHistoryItemImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ReceivingContainer _$ReceivingContainerFromJson(Map<String, dynamic> json) {
  return _ReceivingContainer.fromJson(json);
}

/// @nodoc
mixin _$ReceivingContainer {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'container_number')
  String get containerNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'plate_number')
  String? get plateNumber => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'source_warehouse_id')
  int get sourceWarehouseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'source_warehouse_name')
  String? get sourceWarehouseName => throw _privateConstructorUsedError;
  @JsonKey(name: 'destination_warehouse_id')
  int get destinationWarehouseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'destination_warehouse_name')
  String? get destinationWarehouseName => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_id')
  int? get supplierId => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_name')
  String get supplierName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReceivingContainerCopyWith<ReceivingContainer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceivingContainerCopyWith<$Res> {
  factory $ReceivingContainerCopyWith(
          ReceivingContainer value, $Res Function(ReceivingContainer) then) =
      _$ReceivingContainerCopyWithImpl<$Res, ReceivingContainer>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'container_number') String containerNumber,
      @JsonKey(name: 'plate_number') String? plateNumber,
      String status,
      @JsonKey(name: 'source_warehouse_id') int sourceWarehouseId,
      @JsonKey(name: 'source_warehouse_name') String? sourceWarehouseName,
      @JsonKey(name: 'destination_warehouse_id') int destinationWarehouseId,
      @JsonKey(name: 'destination_warehouse_name')
      String? destinationWarehouseName,
      @JsonKey(name: 'supplier_id') int? supplierId,
      @JsonKey(name: 'supplier_name') String supplierName});
}

/// @nodoc
class _$ReceivingContainerCopyWithImpl<$Res, $Val extends ReceivingContainer>
    implements $ReceivingContainerCopyWith<$Res> {
  _$ReceivingContainerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? containerNumber = null,
    Object? plateNumber = freezed,
    Object? status = null,
    Object? sourceWarehouseId = null,
    Object? sourceWarehouseName = freezed,
    Object? destinationWarehouseId = null,
    Object? destinationWarehouseName = freezed,
    Object? supplierId = freezed,
    Object? supplierName = null,
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
      plateNumber: freezed == plateNumber
          ? _value.plateNumber
          : plateNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      sourceWarehouseId: null == sourceWarehouseId
          ? _value.sourceWarehouseId
          : sourceWarehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      sourceWarehouseName: freezed == sourceWarehouseName
          ? _value.sourceWarehouseName
          : sourceWarehouseName // ignore: cast_nullable_to_non_nullable
              as String?,
      destinationWarehouseId: null == destinationWarehouseId
          ? _value.destinationWarehouseId
          : destinationWarehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      destinationWarehouseName: freezed == destinationWarehouseName
          ? _value.destinationWarehouseName
          : destinationWarehouseName // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int?,
      supplierName: null == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReceivingContainerImplCopyWith<$Res>
    implements $ReceivingContainerCopyWith<$Res> {
  factory _$$ReceivingContainerImplCopyWith(_$ReceivingContainerImpl value,
          $Res Function(_$ReceivingContainerImpl) then) =
      __$$ReceivingContainerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'container_number') String containerNumber,
      @JsonKey(name: 'plate_number') String? plateNumber,
      String status,
      @JsonKey(name: 'source_warehouse_id') int sourceWarehouseId,
      @JsonKey(name: 'source_warehouse_name') String? sourceWarehouseName,
      @JsonKey(name: 'destination_warehouse_id') int destinationWarehouseId,
      @JsonKey(name: 'destination_warehouse_name')
      String? destinationWarehouseName,
      @JsonKey(name: 'supplier_id') int? supplierId,
      @JsonKey(name: 'supplier_name') String supplierName});
}

/// @nodoc
class __$$ReceivingContainerImplCopyWithImpl<$Res>
    extends _$ReceivingContainerCopyWithImpl<$Res, _$ReceivingContainerImpl>
    implements _$$ReceivingContainerImplCopyWith<$Res> {
  __$$ReceivingContainerImplCopyWithImpl(_$ReceivingContainerImpl _value,
      $Res Function(_$ReceivingContainerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? containerNumber = null,
    Object? plateNumber = freezed,
    Object? status = null,
    Object? sourceWarehouseId = null,
    Object? sourceWarehouseName = freezed,
    Object? destinationWarehouseId = null,
    Object? destinationWarehouseName = freezed,
    Object? supplierId = freezed,
    Object? supplierName = null,
  }) {
    return _then(_$ReceivingContainerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      containerNumber: null == containerNumber
          ? _value.containerNumber
          : containerNumber // ignore: cast_nullable_to_non_nullable
              as String,
      plateNumber: freezed == plateNumber
          ? _value.plateNumber
          : plateNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      sourceWarehouseId: null == sourceWarehouseId
          ? _value.sourceWarehouseId
          : sourceWarehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      sourceWarehouseName: freezed == sourceWarehouseName
          ? _value.sourceWarehouseName
          : sourceWarehouseName // ignore: cast_nullable_to_non_nullable
              as String?,
      destinationWarehouseId: null == destinationWarehouseId
          ? _value.destinationWarehouseId
          : destinationWarehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      destinationWarehouseName: freezed == destinationWarehouseName
          ? _value.destinationWarehouseName
          : destinationWarehouseName // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int?,
      supplierName: null == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReceivingContainerImpl implements _ReceivingContainer {
  const _$ReceivingContainerImpl(
      {required this.id,
      @JsonKey(name: 'container_number') required this.containerNumber,
      @JsonKey(name: 'plate_number') this.plateNumber,
      required this.status,
      @JsonKey(name: 'source_warehouse_id') required this.sourceWarehouseId,
      @JsonKey(name: 'source_warehouse_name') this.sourceWarehouseName,
      @JsonKey(name: 'destination_warehouse_id')
      required this.destinationWarehouseId,
      @JsonKey(name: 'destination_warehouse_name')
      this.destinationWarehouseName,
      @JsonKey(name: 'supplier_id') this.supplierId,
      @JsonKey(name: 'supplier_name') required this.supplierName});

  factory _$ReceivingContainerImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReceivingContainerImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'container_number')
  final String containerNumber;
  @override
  @JsonKey(name: 'plate_number')
  final String? plateNumber;
  @override
  final String status;
  @override
  @JsonKey(name: 'source_warehouse_id')
  final int sourceWarehouseId;
  @override
  @JsonKey(name: 'source_warehouse_name')
  final String? sourceWarehouseName;
  @override
  @JsonKey(name: 'destination_warehouse_id')
  final int destinationWarehouseId;
  @override
  @JsonKey(name: 'destination_warehouse_name')
  final String? destinationWarehouseName;
  @override
  @JsonKey(name: 'supplier_id')
  final int? supplierId;
  @override
  @JsonKey(name: 'supplier_name')
  final String supplierName;

  @override
  String toString() {
    return 'ReceivingContainer(id: $id, containerNumber: $containerNumber, plateNumber: $plateNumber, status: $status, sourceWarehouseId: $sourceWarehouseId, sourceWarehouseName: $sourceWarehouseName, destinationWarehouseId: $destinationWarehouseId, destinationWarehouseName: $destinationWarehouseName, supplierId: $supplierId, supplierName: $supplierName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceivingContainerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.containerNumber, containerNumber) ||
                other.containerNumber == containerNumber) &&
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
                other.supplierName == supplierName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      containerNumber,
      plateNumber,
      status,
      sourceWarehouseId,
      sourceWarehouseName,
      destinationWarehouseId,
      destinationWarehouseName,
      supplierId,
      supplierName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceivingContainerImplCopyWith<_$ReceivingContainerImpl> get copyWith =>
      __$$ReceivingContainerImplCopyWithImpl<_$ReceivingContainerImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReceivingContainerImplToJson(
      this,
    );
  }
}

abstract class _ReceivingContainer implements ReceivingContainer {
  const factory _ReceivingContainer(
      {required final int id,
      @JsonKey(name: 'container_number') required final String containerNumber,
      @JsonKey(name: 'plate_number') final String? plateNumber,
      required final String status,
      @JsonKey(name: 'source_warehouse_id')
      required final int sourceWarehouseId,
      @JsonKey(name: 'source_warehouse_name') final String? sourceWarehouseName,
      @JsonKey(name: 'destination_warehouse_id')
      required final int destinationWarehouseId,
      @JsonKey(name: 'destination_warehouse_name')
      final String? destinationWarehouseName,
      @JsonKey(name: 'supplier_id') final int? supplierId,
      @JsonKey(name: 'supplier_name')
      required final String supplierName}) = _$ReceivingContainerImpl;

  factory _ReceivingContainer.fromJson(Map<String, dynamic> json) =
      _$ReceivingContainerImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'container_number')
  String get containerNumber;
  @override
  @JsonKey(name: 'plate_number')
  String? get plateNumber;
  @override
  String get status;
  @override
  @JsonKey(name: 'source_warehouse_id')
  int get sourceWarehouseId;
  @override
  @JsonKey(name: 'source_warehouse_name')
  String? get sourceWarehouseName;
  @override
  @JsonKey(name: 'destination_warehouse_id')
  int get destinationWarehouseId;
  @override
  @JsonKey(name: 'destination_warehouse_name')
  String? get destinationWarehouseName;
  @override
  @JsonKey(name: 'supplier_id')
  int? get supplierId;
  @override
  @JsonKey(name: 'supplier_name')
  String get supplierName;
  @override
  @JsonKey(ignore: true)
  _$$ReceivingContainerImplCopyWith<_$ReceivingContainerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReceivingContainerManifest _$ReceivingContainerManifestFromJson(
    Map<String, dynamic> json) {
  return _ReceivingContainerManifest.fromJson(json);
}

/// @nodoc
mixin _$ReceivingContainerManifest {
  @JsonKey(name: 'container_id')
  int get containerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'container_number')
  String get containerNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'plate_number')
  String? get plateNumber => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'source_warehouse_id')
  int get sourceWarehouseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'destination_warehouse_id')
  int get destinationWarehouseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'destination_warehouse_name')
  String? get destinationWarehouseName => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_id')
  int? get supplierId => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_name')
  String get supplierName => throw _privateConstructorUsedError;
  List<ReceivingContainerManifestItem> get items =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReceivingContainerManifestCopyWith<ReceivingContainerManifest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceivingContainerManifestCopyWith<$Res> {
  factory $ReceivingContainerManifestCopyWith(ReceivingContainerManifest value,
          $Res Function(ReceivingContainerManifest) then) =
      _$ReceivingContainerManifestCopyWithImpl<$Res,
          ReceivingContainerManifest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'container_id') int containerId,
      @JsonKey(name: 'container_number') String containerNumber,
      @JsonKey(name: 'plate_number') String? plateNumber,
      String status,
      @JsonKey(name: 'source_warehouse_id') int sourceWarehouseId,
      @JsonKey(name: 'destination_warehouse_id') int destinationWarehouseId,
      @JsonKey(name: 'destination_warehouse_name')
      String? destinationWarehouseName,
      @JsonKey(name: 'supplier_id') int? supplierId,
      @JsonKey(name: 'supplier_name') String supplierName,
      List<ReceivingContainerManifestItem> items});
}

/// @nodoc
class _$ReceivingContainerManifestCopyWithImpl<$Res,
        $Val extends ReceivingContainerManifest>
    implements $ReceivingContainerManifestCopyWith<$Res> {
  _$ReceivingContainerManifestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? containerId = null,
    Object? containerNumber = null,
    Object? plateNumber = freezed,
    Object? status = null,
    Object? sourceWarehouseId = null,
    Object? destinationWarehouseId = null,
    Object? destinationWarehouseName = freezed,
    Object? supplierId = freezed,
    Object? supplierName = null,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      containerId: null == containerId
          ? _value.containerId
          : containerId // ignore: cast_nullable_to_non_nullable
              as int,
      containerNumber: null == containerNumber
          ? _value.containerNumber
          : containerNumber // ignore: cast_nullable_to_non_nullable
              as String,
      plateNumber: freezed == plateNumber
          ? _value.plateNumber
          : plateNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      sourceWarehouseId: null == sourceWarehouseId
          ? _value.sourceWarehouseId
          : sourceWarehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      destinationWarehouseId: null == destinationWarehouseId
          ? _value.destinationWarehouseId
          : destinationWarehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      destinationWarehouseName: freezed == destinationWarehouseName
          ? _value.destinationWarehouseName
          : destinationWarehouseName // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int?,
      supplierName: null == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ReceivingContainerManifestItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReceivingContainerManifestImplCopyWith<$Res>
    implements $ReceivingContainerManifestCopyWith<$Res> {
  factory _$$ReceivingContainerManifestImplCopyWith(
          _$ReceivingContainerManifestImpl value,
          $Res Function(_$ReceivingContainerManifestImpl) then) =
      __$$ReceivingContainerManifestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'container_id') int containerId,
      @JsonKey(name: 'container_number') String containerNumber,
      @JsonKey(name: 'plate_number') String? plateNumber,
      String status,
      @JsonKey(name: 'source_warehouse_id') int sourceWarehouseId,
      @JsonKey(name: 'destination_warehouse_id') int destinationWarehouseId,
      @JsonKey(name: 'destination_warehouse_name')
      String? destinationWarehouseName,
      @JsonKey(name: 'supplier_id') int? supplierId,
      @JsonKey(name: 'supplier_name') String supplierName,
      List<ReceivingContainerManifestItem> items});
}

/// @nodoc
class __$$ReceivingContainerManifestImplCopyWithImpl<$Res>
    extends _$ReceivingContainerManifestCopyWithImpl<$Res,
        _$ReceivingContainerManifestImpl>
    implements _$$ReceivingContainerManifestImplCopyWith<$Res> {
  __$$ReceivingContainerManifestImplCopyWithImpl(
      _$ReceivingContainerManifestImpl _value,
      $Res Function(_$ReceivingContainerManifestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? containerId = null,
    Object? containerNumber = null,
    Object? plateNumber = freezed,
    Object? status = null,
    Object? sourceWarehouseId = null,
    Object? destinationWarehouseId = null,
    Object? destinationWarehouseName = freezed,
    Object? supplierId = freezed,
    Object? supplierName = null,
    Object? items = null,
  }) {
    return _then(_$ReceivingContainerManifestImpl(
      containerId: null == containerId
          ? _value.containerId
          : containerId // ignore: cast_nullable_to_non_nullable
              as int,
      containerNumber: null == containerNumber
          ? _value.containerNumber
          : containerNumber // ignore: cast_nullable_to_non_nullable
              as String,
      plateNumber: freezed == plateNumber
          ? _value.plateNumber
          : plateNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      sourceWarehouseId: null == sourceWarehouseId
          ? _value.sourceWarehouseId
          : sourceWarehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      destinationWarehouseId: null == destinationWarehouseId
          ? _value.destinationWarehouseId
          : destinationWarehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      destinationWarehouseName: freezed == destinationWarehouseName
          ? _value.destinationWarehouseName
          : destinationWarehouseName // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int?,
      supplierName: null == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ReceivingContainerManifestItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReceivingContainerManifestImpl implements _ReceivingContainerManifest {
  const _$ReceivingContainerManifestImpl(
      {@JsonKey(name: 'container_id') required this.containerId,
      @JsonKey(name: 'container_number') required this.containerNumber,
      @JsonKey(name: 'plate_number') this.plateNumber,
      required this.status,
      @JsonKey(name: 'source_warehouse_id') required this.sourceWarehouseId,
      @JsonKey(name: 'destination_warehouse_id')
      required this.destinationWarehouseId,
      @JsonKey(name: 'destination_warehouse_name')
      this.destinationWarehouseName,
      @JsonKey(name: 'supplier_id') this.supplierId,
      @JsonKey(name: 'supplier_name') required this.supplierName,
      required final List<ReceivingContainerManifestItem> items})
      : _items = items;

  factory _$ReceivingContainerManifestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ReceivingContainerManifestImplFromJson(json);

  @override
  @JsonKey(name: 'container_id')
  final int containerId;
  @override
  @JsonKey(name: 'container_number')
  final String containerNumber;
  @override
  @JsonKey(name: 'plate_number')
  final String? plateNumber;
  @override
  final String status;
  @override
  @JsonKey(name: 'source_warehouse_id')
  final int sourceWarehouseId;
  @override
  @JsonKey(name: 'destination_warehouse_id')
  final int destinationWarehouseId;
  @override
  @JsonKey(name: 'destination_warehouse_name')
  final String? destinationWarehouseName;
  @override
  @JsonKey(name: 'supplier_id')
  final int? supplierId;
  @override
  @JsonKey(name: 'supplier_name')
  final String supplierName;
  final List<ReceivingContainerManifestItem> _items;
  @override
  List<ReceivingContainerManifestItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'ReceivingContainerManifest(containerId: $containerId, containerNumber: $containerNumber, plateNumber: $plateNumber, status: $status, sourceWarehouseId: $sourceWarehouseId, destinationWarehouseId: $destinationWarehouseId, destinationWarehouseName: $destinationWarehouseName, supplierId: $supplierId, supplierName: $supplierName, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceivingContainerManifestImpl &&
            (identical(other.containerId, containerId) ||
                other.containerId == containerId) &&
            (identical(other.containerNumber, containerNumber) ||
                other.containerNumber == containerNumber) &&
            (identical(other.plateNumber, plateNumber) ||
                other.plateNumber == plateNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.sourceWarehouseId, sourceWarehouseId) ||
                other.sourceWarehouseId == sourceWarehouseId) &&
            (identical(other.destinationWarehouseId, destinationWarehouseId) ||
                other.destinationWarehouseId == destinationWarehouseId) &&
            (identical(
                    other.destinationWarehouseName, destinationWarehouseName) ||
                other.destinationWarehouseName == destinationWarehouseName) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      containerId,
      containerNumber,
      plateNumber,
      status,
      sourceWarehouseId,
      destinationWarehouseId,
      destinationWarehouseName,
      supplierId,
      supplierName,
      const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceivingContainerManifestImplCopyWith<_$ReceivingContainerManifestImpl>
      get copyWith => __$$ReceivingContainerManifestImplCopyWithImpl<
          _$ReceivingContainerManifestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReceivingContainerManifestImplToJson(
      this,
    );
  }
}

abstract class _ReceivingContainerManifest
    implements ReceivingContainerManifest {
  const factory _ReceivingContainerManifest(
      {@JsonKey(name: 'container_id') required final int containerId,
      @JsonKey(name: 'container_number') required final String containerNumber,
      @JsonKey(name: 'plate_number') final String? plateNumber,
      required final String status,
      @JsonKey(name: 'source_warehouse_id')
      required final int sourceWarehouseId,
      @JsonKey(name: 'destination_warehouse_id')
      required final int destinationWarehouseId,
      @JsonKey(name: 'destination_warehouse_name')
      final String? destinationWarehouseName,
      @JsonKey(name: 'supplier_id') final int? supplierId,
      @JsonKey(name: 'supplier_name') required final String supplierName,
      required final List<ReceivingContainerManifestItem>
          items}) = _$ReceivingContainerManifestImpl;

  factory _ReceivingContainerManifest.fromJson(Map<String, dynamic> json) =
      _$ReceivingContainerManifestImpl.fromJson;

  @override
  @JsonKey(name: 'container_id')
  int get containerId;
  @override
  @JsonKey(name: 'container_number')
  String get containerNumber;
  @override
  @JsonKey(name: 'plate_number')
  String? get plateNumber;
  @override
  String get status;
  @override
  @JsonKey(name: 'source_warehouse_id')
  int get sourceWarehouseId;
  @override
  @JsonKey(name: 'destination_warehouse_id')
  int get destinationWarehouseId;
  @override
  @JsonKey(name: 'destination_warehouse_name')
  String? get destinationWarehouseName;
  @override
  @JsonKey(name: 'supplier_id')
  int? get supplierId;
  @override
  @JsonKey(name: 'supplier_name')
  String get supplierName;
  @override
  List<ReceivingContainerManifestItem> get items;
  @override
  @JsonKey(ignore: true)
  _$$ReceivingContainerManifestImplCopyWith<_$ReceivingContainerManifestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ReceivingContainerManifestItem _$ReceivingContainerManifestItemFromJson(
    Map<String, dynamic> json) {
  return _ReceivingContainerManifestItem.fromJson(json);
}

/// @nodoc
mixin _$ReceivingContainerManifestItem {
  @JsonKey(name: 'po_detail_id')
  int get poDetailId => throw _privateConstructorUsedError;
  @JsonKey(name: 'po_header_id')
  int get poHeaderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'po_number')
  String get poNumber => throw _privateConstructorUsedError;
  String get sku => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name')
  String get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'planned_qty')
  double get plannedQty => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReceivingContainerManifestItemCopyWith<ReceivingContainerManifestItem>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceivingContainerManifestItemCopyWith<$Res> {
  factory $ReceivingContainerManifestItemCopyWith(
          ReceivingContainerManifestItem value,
          $Res Function(ReceivingContainerManifestItem) then) =
      _$ReceivingContainerManifestItemCopyWithImpl<$Res,
          ReceivingContainerManifestItem>;
  @useResult
  $Res call(
      {@JsonKey(name: 'po_detail_id') int poDetailId,
      @JsonKey(name: 'po_header_id') int poHeaderId,
      @JsonKey(name: 'po_number') String poNumber,
      String sku,
      @JsonKey(name: 'product_name') String productName,
      @JsonKey(name: 'planned_qty') double plannedQty,
      String unit});
}

/// @nodoc
class _$ReceivingContainerManifestItemCopyWithImpl<$Res,
        $Val extends ReceivingContainerManifestItem>
    implements $ReceivingContainerManifestItemCopyWith<$Res> {
  _$ReceivingContainerManifestItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poDetailId = null,
    Object? poHeaderId = null,
    Object? poNumber = null,
    Object? sku = null,
    Object? productName = null,
    Object? plannedQty = null,
    Object? unit = null,
  }) {
    return _then(_value.copyWith(
      poDetailId: null == poDetailId
          ? _value.poDetailId
          : poDetailId // ignore: cast_nullable_to_non_nullable
              as int,
      poHeaderId: null == poHeaderId
          ? _value.poHeaderId
          : poHeaderId // ignore: cast_nullable_to_non_nullable
              as int,
      poNumber: null == poNumber
          ? _value.poNumber
          : poNumber // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$ReceivingContainerManifestItemImplCopyWith<$Res>
    implements $ReceivingContainerManifestItemCopyWith<$Res> {
  factory _$$ReceivingContainerManifestItemImplCopyWith(
          _$ReceivingContainerManifestItemImpl value,
          $Res Function(_$ReceivingContainerManifestItemImpl) then) =
      __$$ReceivingContainerManifestItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'po_detail_id') int poDetailId,
      @JsonKey(name: 'po_header_id') int poHeaderId,
      @JsonKey(name: 'po_number') String poNumber,
      String sku,
      @JsonKey(name: 'product_name') String productName,
      @JsonKey(name: 'planned_qty') double plannedQty,
      String unit});
}

/// @nodoc
class __$$ReceivingContainerManifestItemImplCopyWithImpl<$Res>
    extends _$ReceivingContainerManifestItemCopyWithImpl<$Res,
        _$ReceivingContainerManifestItemImpl>
    implements _$$ReceivingContainerManifestItemImplCopyWith<$Res> {
  __$$ReceivingContainerManifestItemImplCopyWithImpl(
      _$ReceivingContainerManifestItemImpl _value,
      $Res Function(_$ReceivingContainerManifestItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poDetailId = null,
    Object? poHeaderId = null,
    Object? poNumber = null,
    Object? sku = null,
    Object? productName = null,
    Object? plannedQty = null,
    Object? unit = null,
  }) {
    return _then(_$ReceivingContainerManifestItemImpl(
      poDetailId: null == poDetailId
          ? _value.poDetailId
          : poDetailId // ignore: cast_nullable_to_non_nullable
              as int,
      poHeaderId: null == poHeaderId
          ? _value.poHeaderId
          : poHeaderId // ignore: cast_nullable_to_non_nullable
              as int,
      poNumber: null == poNumber
          ? _value.poNumber
          : poNumber // ignore: cast_nullable_to_non_nullable
              as String,
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
class _$ReceivingContainerManifestItemImpl
    implements _ReceivingContainerManifestItem {
  const _$ReceivingContainerManifestItemImpl(
      {@JsonKey(name: 'po_detail_id') required this.poDetailId,
      @JsonKey(name: 'po_header_id') required this.poHeaderId,
      @JsonKey(name: 'po_number') required this.poNumber,
      required this.sku,
      @JsonKey(name: 'product_name') required this.productName,
      @JsonKey(name: 'planned_qty') required this.plannedQty,
      required this.unit});

  factory _$ReceivingContainerManifestItemImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ReceivingContainerManifestItemImplFromJson(json);

  @override
  @JsonKey(name: 'po_detail_id')
  final int poDetailId;
  @override
  @JsonKey(name: 'po_header_id')
  final int poHeaderId;
  @override
  @JsonKey(name: 'po_number')
  final String poNumber;
  @override
  final String sku;
  @override
  @JsonKey(name: 'product_name')
  final String productName;
  @override
  @JsonKey(name: 'planned_qty')
  final double plannedQty;
  @override
  final String unit;

  @override
  String toString() {
    return 'ReceivingContainerManifestItem(poDetailId: $poDetailId, poHeaderId: $poHeaderId, poNumber: $poNumber, sku: $sku, productName: $productName, plannedQty: $plannedQty, unit: $unit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceivingContainerManifestItemImpl &&
            (identical(other.poDetailId, poDetailId) ||
                other.poDetailId == poDetailId) &&
            (identical(other.poHeaderId, poHeaderId) ||
                other.poHeaderId == poHeaderId) &&
            (identical(other.poNumber, poNumber) ||
                other.poNumber == poNumber) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.plannedQty, plannedQty) ||
                other.plannedQty == plannedQty) &&
            (identical(other.unit, unit) || other.unit == unit));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, poDetailId, poHeaderId, poNumber,
      sku, productName, plannedQty, unit);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceivingContainerManifestItemImplCopyWith<
          _$ReceivingContainerManifestItemImpl>
      get copyWith => __$$ReceivingContainerManifestItemImplCopyWithImpl<
          _$ReceivingContainerManifestItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReceivingContainerManifestItemImplToJson(
      this,
    );
  }
}

abstract class _ReceivingContainerManifestItem
    implements ReceivingContainerManifestItem {
  const factory _ReceivingContainerManifestItem(
      {@JsonKey(name: 'po_detail_id') required final int poDetailId,
      @JsonKey(name: 'po_header_id') required final int poHeaderId,
      @JsonKey(name: 'po_number') required final String poNumber,
      required final String sku,
      @JsonKey(name: 'product_name') required final String productName,
      @JsonKey(name: 'planned_qty') required final double plannedQty,
      required final String unit}) = _$ReceivingContainerManifestItemImpl;

  factory _ReceivingContainerManifestItem.fromJson(Map<String, dynamic> json) =
      _$ReceivingContainerManifestItemImpl.fromJson;

  @override
  @JsonKey(name: 'po_detail_id')
  int get poDetailId;
  @override
  @JsonKey(name: 'po_header_id')
  int get poHeaderId;
  @override
  @JsonKey(name: 'po_number')
  String get poNumber;
  @override
  String get sku;
  @override
  @JsonKey(name: 'product_name')
  String get productName;
  @override
  @JsonKey(name: 'planned_qty')
  double get plannedQty;
  @override
  String get unit;
  @override
  @JsonKey(ignore: true)
  _$$ReceivingContainerManifestItemImplCopyWith<
          _$ReceivingContainerManifestItemImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ContainerReceivingRequest _$ContainerReceivingRequestFromJson(
    Map<String, dynamic> json) {
  return _ContainerReceivingRequest.fromJson(json);
}

/// @nodoc
mixin _$ContainerReceivingRequest {
  @JsonKey(name: 'source_warehouse_id')
  int get sourceWarehouseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'destination_warehouse_id')
  int get destinationWarehouseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'container_number')
  String get containerNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'plate_number')
  String? get plateNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'driver_name')
  String? get driverName => throw _privateConstructorUsedError;
  List<ContainerGroupedManifest> get manifest =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContainerReceivingRequestCopyWith<ContainerReceivingRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContainerReceivingRequestCopyWith<$Res> {
  factory $ContainerReceivingRequestCopyWith(ContainerReceivingRequest value,
          $Res Function(ContainerReceivingRequest) then) =
      _$ContainerReceivingRequestCopyWithImpl<$Res, ContainerReceivingRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'source_warehouse_id') int sourceWarehouseId,
      @JsonKey(name: 'destination_warehouse_id') int destinationWarehouseId,
      @JsonKey(name: 'container_number') String containerNumber,
      @JsonKey(name: 'plate_number') String? plateNumber,
      @JsonKey(name: 'driver_name') String? driverName,
      List<ContainerGroupedManifest> manifest});
}

/// @nodoc
class _$ContainerReceivingRequestCopyWithImpl<$Res,
        $Val extends ContainerReceivingRequest>
    implements $ContainerReceivingRequestCopyWith<$Res> {
  _$ContainerReceivingRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sourceWarehouseId = null,
    Object? destinationWarehouseId = null,
    Object? containerNumber = null,
    Object? plateNumber = freezed,
    Object? driverName = freezed,
    Object? manifest = null,
  }) {
    return _then(_value.copyWith(
      sourceWarehouseId: null == sourceWarehouseId
          ? _value.sourceWarehouseId
          : sourceWarehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      destinationWarehouseId: null == destinationWarehouseId
          ? _value.destinationWarehouseId
          : destinationWarehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      containerNumber: null == containerNumber
          ? _value.containerNumber
          : containerNumber // ignore: cast_nullable_to_non_nullable
              as String,
      plateNumber: freezed == plateNumber
          ? _value.plateNumber
          : plateNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      driverName: freezed == driverName
          ? _value.driverName
          : driverName // ignore: cast_nullable_to_non_nullable
              as String?,
      manifest: null == manifest
          ? _value.manifest
          : manifest // ignore: cast_nullable_to_non_nullable
              as List<ContainerGroupedManifest>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContainerReceivingRequestImplCopyWith<$Res>
    implements $ContainerReceivingRequestCopyWith<$Res> {
  factory _$$ContainerReceivingRequestImplCopyWith(
          _$ContainerReceivingRequestImpl value,
          $Res Function(_$ContainerReceivingRequestImpl) then) =
      __$$ContainerReceivingRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'source_warehouse_id') int sourceWarehouseId,
      @JsonKey(name: 'destination_warehouse_id') int destinationWarehouseId,
      @JsonKey(name: 'container_number') String containerNumber,
      @JsonKey(name: 'plate_number') String? plateNumber,
      @JsonKey(name: 'driver_name') String? driverName,
      List<ContainerGroupedManifest> manifest});
}

/// @nodoc
class __$$ContainerReceivingRequestImplCopyWithImpl<$Res>
    extends _$ContainerReceivingRequestCopyWithImpl<$Res,
        _$ContainerReceivingRequestImpl>
    implements _$$ContainerReceivingRequestImplCopyWith<$Res> {
  __$$ContainerReceivingRequestImplCopyWithImpl(
      _$ContainerReceivingRequestImpl _value,
      $Res Function(_$ContainerReceivingRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sourceWarehouseId = null,
    Object? destinationWarehouseId = null,
    Object? containerNumber = null,
    Object? plateNumber = freezed,
    Object? driverName = freezed,
    Object? manifest = null,
  }) {
    return _then(_$ContainerReceivingRequestImpl(
      sourceWarehouseId: null == sourceWarehouseId
          ? _value.sourceWarehouseId
          : sourceWarehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      destinationWarehouseId: null == destinationWarehouseId
          ? _value.destinationWarehouseId
          : destinationWarehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      containerNumber: null == containerNumber
          ? _value.containerNumber
          : containerNumber // ignore: cast_nullable_to_non_nullable
              as String,
      plateNumber: freezed == plateNumber
          ? _value.plateNumber
          : plateNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      driverName: freezed == driverName
          ? _value.driverName
          : driverName // ignore: cast_nullable_to_non_nullable
              as String?,
      manifest: null == manifest
          ? _value._manifest
          : manifest // ignore: cast_nullable_to_non_nullable
              as List<ContainerGroupedManifest>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContainerReceivingRequestImpl implements _ContainerReceivingRequest {
  const _$ContainerReceivingRequestImpl(
      {@JsonKey(name: 'source_warehouse_id') required this.sourceWarehouseId,
      @JsonKey(name: 'destination_warehouse_id')
      required this.destinationWarehouseId,
      @JsonKey(name: 'container_number') required this.containerNumber,
      @JsonKey(name: 'plate_number') this.plateNumber,
      @JsonKey(name: 'driver_name') this.driverName,
      required final List<ContainerGroupedManifest> manifest})
      : _manifest = manifest;

  factory _$ContainerReceivingRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContainerReceivingRequestImplFromJson(json);

  @override
  @JsonKey(name: 'source_warehouse_id')
  final int sourceWarehouseId;
  @override
  @JsonKey(name: 'destination_warehouse_id')
  final int destinationWarehouseId;
  @override
  @JsonKey(name: 'container_number')
  final String containerNumber;
  @override
  @JsonKey(name: 'plate_number')
  final String? plateNumber;
  @override
  @JsonKey(name: 'driver_name')
  final String? driverName;
  final List<ContainerGroupedManifest> _manifest;
  @override
  List<ContainerGroupedManifest> get manifest {
    if (_manifest is EqualUnmodifiableListView) return _manifest;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_manifest);
  }

  @override
  String toString() {
    return 'ContainerReceivingRequest(sourceWarehouseId: $sourceWarehouseId, destinationWarehouseId: $destinationWarehouseId, containerNumber: $containerNumber, plateNumber: $plateNumber, driverName: $driverName, manifest: $manifest)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContainerReceivingRequestImpl &&
            (identical(other.sourceWarehouseId, sourceWarehouseId) ||
                other.sourceWarehouseId == sourceWarehouseId) &&
            (identical(other.destinationWarehouseId, destinationWarehouseId) ||
                other.destinationWarehouseId == destinationWarehouseId) &&
            (identical(other.containerNumber, containerNumber) ||
                other.containerNumber == containerNumber) &&
            (identical(other.plateNumber, plateNumber) ||
                other.plateNumber == plateNumber) &&
            (identical(other.driverName, driverName) ||
                other.driverName == driverName) &&
            const DeepCollectionEquality().equals(other._manifest, _manifest));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      sourceWarehouseId,
      destinationWarehouseId,
      containerNumber,
      plateNumber,
      driverName,
      const DeepCollectionEquality().hash(_manifest));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContainerReceivingRequestImplCopyWith<_$ContainerReceivingRequestImpl>
      get copyWith => __$$ContainerReceivingRequestImplCopyWithImpl<
          _$ContainerReceivingRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContainerReceivingRequestImplToJson(
      this,
    );
  }
}

abstract class _ContainerReceivingRequest implements ContainerReceivingRequest {
  const factory _ContainerReceivingRequest(
      {@JsonKey(name: 'source_warehouse_id')
      required final int sourceWarehouseId,
      @JsonKey(name: 'destination_warehouse_id')
      required final int destinationWarehouseId,
      @JsonKey(name: 'container_number') required final String containerNumber,
      @JsonKey(name: 'plate_number') final String? plateNumber,
      @JsonKey(name: 'driver_name') final String? driverName,
      required final List<ContainerGroupedManifest>
          manifest}) = _$ContainerReceivingRequestImpl;

  factory _ContainerReceivingRequest.fromJson(Map<String, dynamic> json) =
      _$ContainerReceivingRequestImpl.fromJson;

  @override
  @JsonKey(name: 'source_warehouse_id')
  int get sourceWarehouseId;
  @override
  @JsonKey(name: 'destination_warehouse_id')
  int get destinationWarehouseId;
  @override
  @JsonKey(name: 'container_number')
  String get containerNumber;
  @override
  @JsonKey(name: 'plate_number')
  String? get plateNumber;
  @override
  @JsonKey(name: 'driver_name')
  String? get driverName;
  @override
  List<ContainerGroupedManifest> get manifest;
  @override
  @JsonKey(ignore: true)
  _$$ContainerReceivingRequestImplCopyWith<_$ContainerReceivingRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ContainerGroupedManifest _$ContainerGroupedManifestFromJson(
    Map<String, dynamic> json) {
  return _ContainerGroupedManifest.fromJson(json);
}

/// @nodoc
mixin _$ContainerGroupedManifest {
  @JsonKey(name: 'po_header_id')
  int get poHeaderId => throw _privateConstructorUsedError;
  List<ContainerReceivingItemRequest> get items =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContainerGroupedManifestCopyWith<ContainerGroupedManifest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContainerGroupedManifestCopyWith<$Res> {
  factory $ContainerGroupedManifestCopyWith(ContainerGroupedManifest value,
          $Res Function(ContainerGroupedManifest) then) =
      _$ContainerGroupedManifestCopyWithImpl<$Res, ContainerGroupedManifest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'po_header_id') int poHeaderId,
      List<ContainerReceivingItemRequest> items});
}

/// @nodoc
class _$ContainerGroupedManifestCopyWithImpl<$Res,
        $Val extends ContainerGroupedManifest>
    implements $ContainerGroupedManifestCopyWith<$Res> {
  _$ContainerGroupedManifestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poHeaderId = null,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      poHeaderId: null == poHeaderId
          ? _value.poHeaderId
          : poHeaderId // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ContainerReceivingItemRequest>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContainerGroupedManifestImplCopyWith<$Res>
    implements $ContainerGroupedManifestCopyWith<$Res> {
  factory _$$ContainerGroupedManifestImplCopyWith(
          _$ContainerGroupedManifestImpl value,
          $Res Function(_$ContainerGroupedManifestImpl) then) =
      __$$ContainerGroupedManifestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'po_header_id') int poHeaderId,
      List<ContainerReceivingItemRequest> items});
}

/// @nodoc
class __$$ContainerGroupedManifestImplCopyWithImpl<$Res>
    extends _$ContainerGroupedManifestCopyWithImpl<$Res,
        _$ContainerGroupedManifestImpl>
    implements _$$ContainerGroupedManifestImplCopyWith<$Res> {
  __$$ContainerGroupedManifestImplCopyWithImpl(
      _$ContainerGroupedManifestImpl _value,
      $Res Function(_$ContainerGroupedManifestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poHeaderId = null,
    Object? items = null,
  }) {
    return _then(_$ContainerGroupedManifestImpl(
      poHeaderId: null == poHeaderId
          ? _value.poHeaderId
          : poHeaderId // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ContainerReceivingItemRequest>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContainerGroupedManifestImpl implements _ContainerGroupedManifest {
  const _$ContainerGroupedManifestImpl(
      {@JsonKey(name: 'po_header_id') required this.poHeaderId,
      required final List<ContainerReceivingItemRequest> items})
      : _items = items;

  factory _$ContainerGroupedManifestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContainerGroupedManifestImplFromJson(json);

  @override
  @JsonKey(name: 'po_header_id')
  final int poHeaderId;
  final List<ContainerReceivingItemRequest> _items;
  @override
  List<ContainerReceivingItemRequest> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'ContainerGroupedManifest(poHeaderId: $poHeaderId, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContainerGroupedManifestImpl &&
            (identical(other.poHeaderId, poHeaderId) ||
                other.poHeaderId == poHeaderId) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, poHeaderId, const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContainerGroupedManifestImplCopyWith<_$ContainerGroupedManifestImpl>
      get copyWith => __$$ContainerGroupedManifestImplCopyWithImpl<
          _$ContainerGroupedManifestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContainerGroupedManifestImplToJson(
      this,
    );
  }
}

abstract class _ContainerGroupedManifest implements ContainerGroupedManifest {
  const factory _ContainerGroupedManifest(
          {@JsonKey(name: 'po_header_id') required final int poHeaderId,
          required final List<ContainerReceivingItemRequest> items}) =
      _$ContainerGroupedManifestImpl;

  factory _ContainerGroupedManifest.fromJson(Map<String, dynamic> json) =
      _$ContainerGroupedManifestImpl.fromJson;

  @override
  @JsonKey(name: 'po_header_id')
  int get poHeaderId;
  @override
  List<ContainerReceivingItemRequest> get items;
  @override
  @JsonKey(ignore: true)
  _$$ContainerGroupedManifestImplCopyWith<_$ContainerGroupedManifestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ContainerReceivingItemRequest _$ContainerReceivingItemRequestFromJson(
    Map<String, dynamic> json) {
  return _ContainerReceivingItemRequest.fromJson(json);
}

/// @nodoc
mixin _$ContainerReceivingItemRequest {
  @JsonKey(name: 'po_detail_id')
  int get poDetailId => throw _privateConstructorUsedError;
  @JsonKey(name: 'received_qty')
  double get receivedQty => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  int get conversion => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContainerReceivingItemRequestCopyWith<ContainerReceivingItemRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContainerReceivingItemRequestCopyWith<$Res> {
  factory $ContainerReceivingItemRequestCopyWith(
          ContainerReceivingItemRequest value,
          $Res Function(ContainerReceivingItemRequest) then) =
      _$ContainerReceivingItemRequestCopyWithImpl<$Res,
          ContainerReceivingItemRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'po_detail_id') int poDetailId,
      @JsonKey(name: 'received_qty') double receivedQty,
      String unit,
      int conversion});
}

/// @nodoc
class _$ContainerReceivingItemRequestCopyWithImpl<$Res,
        $Val extends ContainerReceivingItemRequest>
    implements $ContainerReceivingItemRequestCopyWith<$Res> {
  _$ContainerReceivingItemRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poDetailId = null,
    Object? receivedQty = null,
    Object? unit = null,
    Object? conversion = null,
  }) {
    return _then(_value.copyWith(
      poDetailId: null == poDetailId
          ? _value.poDetailId
          : poDetailId // ignore: cast_nullable_to_non_nullable
              as int,
      receivedQty: null == receivedQty
          ? _value.receivedQty
          : receivedQty // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      conversion: null == conversion
          ? _value.conversion
          : conversion // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContainerReceivingItemRequestImplCopyWith<$Res>
    implements $ContainerReceivingItemRequestCopyWith<$Res> {
  factory _$$ContainerReceivingItemRequestImplCopyWith(
          _$ContainerReceivingItemRequestImpl value,
          $Res Function(_$ContainerReceivingItemRequestImpl) then) =
      __$$ContainerReceivingItemRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'po_detail_id') int poDetailId,
      @JsonKey(name: 'received_qty') double receivedQty,
      String unit,
      int conversion});
}

/// @nodoc
class __$$ContainerReceivingItemRequestImplCopyWithImpl<$Res>
    extends _$ContainerReceivingItemRequestCopyWithImpl<$Res,
        _$ContainerReceivingItemRequestImpl>
    implements _$$ContainerReceivingItemRequestImplCopyWith<$Res> {
  __$$ContainerReceivingItemRequestImplCopyWithImpl(
      _$ContainerReceivingItemRequestImpl _value,
      $Res Function(_$ContainerReceivingItemRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poDetailId = null,
    Object? receivedQty = null,
    Object? unit = null,
    Object? conversion = null,
  }) {
    return _then(_$ContainerReceivingItemRequestImpl(
      poDetailId: null == poDetailId
          ? _value.poDetailId
          : poDetailId // ignore: cast_nullable_to_non_nullable
              as int,
      receivedQty: null == receivedQty
          ? _value.receivedQty
          : receivedQty // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      conversion: null == conversion
          ? _value.conversion
          : conversion // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContainerReceivingItemRequestImpl
    implements _ContainerReceivingItemRequest {
  const _$ContainerReceivingItemRequestImpl(
      {@JsonKey(name: 'po_detail_id') required this.poDetailId,
      @JsonKey(name: 'received_qty') required this.receivedQty,
      required this.unit,
      this.conversion = 1});

  factory _$ContainerReceivingItemRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ContainerReceivingItemRequestImplFromJson(json);

  @override
  @JsonKey(name: 'po_detail_id')
  final int poDetailId;
  @override
  @JsonKey(name: 'received_qty')
  final double receivedQty;
  @override
  final String unit;
  @override
  @JsonKey()
  final int conversion;

  @override
  String toString() {
    return 'ContainerReceivingItemRequest(poDetailId: $poDetailId, receivedQty: $receivedQty, unit: $unit, conversion: $conversion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContainerReceivingItemRequestImpl &&
            (identical(other.poDetailId, poDetailId) ||
                other.poDetailId == poDetailId) &&
            (identical(other.receivedQty, receivedQty) ||
                other.receivedQty == receivedQty) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.conversion, conversion) ||
                other.conversion == conversion));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, poDetailId, receivedQty, unit, conversion);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContainerReceivingItemRequestImplCopyWith<
          _$ContainerReceivingItemRequestImpl>
      get copyWith => __$$ContainerReceivingItemRequestImplCopyWithImpl<
          _$ContainerReceivingItemRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContainerReceivingItemRequestImplToJson(
      this,
    );
  }
}

abstract class _ContainerReceivingItemRequest
    implements ContainerReceivingItemRequest {
  const factory _ContainerReceivingItemRequest(
      {@JsonKey(name: 'po_detail_id') required final int poDetailId,
      @JsonKey(name: 'received_qty') required final double receivedQty,
      required final String unit,
      final int conversion}) = _$ContainerReceivingItemRequestImpl;

  factory _ContainerReceivingItemRequest.fromJson(Map<String, dynamic> json) =
      _$ContainerReceivingItemRequestImpl.fromJson;

  @override
  @JsonKey(name: 'po_detail_id')
  int get poDetailId;
  @override
  @JsonKey(name: 'received_qty')
  double get receivedQty;
  @override
  String get unit;
  @override
  int get conversion;
  @override
  @JsonKey(ignore: true)
  _$$ContainerReceivingItemRequestImplCopyWith<
          _$ContainerReceivingItemRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
