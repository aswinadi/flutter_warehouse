// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'landed_cost.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LandedCost _$LandedCostFromJson(Map<String, dynamic> json) {
  return _LandedCost.fromJson(json);
}

/// @nodoc
mixin _$LandedCost {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  int get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_number')
  String get referenceNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'posting_date')
  String get postingDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
  double get totalAmount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_code')
  String get supplierCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_name')
  String get supplierName => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_at')
  String? get approvedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_by')
  int? get approvedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_by_user')
  UserDto? get approvedByUser => throw _privateConstructorUsedError;
  List<LandedCostComponent>? get components =>
      throw _privateConstructorUsedError;
  List<LandedCostShipment>? get shipments => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LandedCostCopyWith<LandedCost> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LandedCostCopyWith<$Res> {
  factory $LandedCostCopyWith(
          LandedCost value, $Res Function(LandedCost) then) =
      _$LandedCostCopyWithImpl<$Res, LandedCost>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'company_id') int companyId,
      @JsonKey(name: 'reference_number') String referenceNumber,
      @JsonKey(name: 'posting_date') String postingDate,
      @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
      double totalAmount,
      String currency,
      @JsonKey(name: 'supplier_code') String supplierCode,
      @JsonKey(name: 'supplier_name') String supplierName,
      String? description,
      String status,
      @JsonKey(name: 'approved_at') String? approvedAt,
      @JsonKey(name: 'approved_by') int? approvedBy,
      @JsonKey(name: 'approved_by_user') UserDto? approvedByUser,
      List<LandedCostComponent>? components,
      List<LandedCostShipment>? shipments});

  $UserDtoCopyWith<$Res>? get approvedByUser;
}

/// @nodoc
class _$LandedCostCopyWithImpl<$Res, $Val extends LandedCost>
    implements $LandedCostCopyWith<$Res> {
  _$LandedCostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? referenceNumber = null,
    Object? postingDate = null,
    Object? totalAmount = null,
    Object? currency = null,
    Object? supplierCode = null,
    Object? supplierName = null,
    Object? description = freezed,
    Object? status = null,
    Object? approvedAt = freezed,
    Object? approvedBy = freezed,
    Object? approvedByUser = freezed,
    Object? components = freezed,
    Object? shipments = freezed,
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
      referenceNumber: null == referenceNumber
          ? _value.referenceNumber
          : referenceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      postingDate: null == postingDate
          ? _value.postingDate
          : postingDate // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      supplierCode: null == supplierCode
          ? _value.supplierCode
          : supplierCode // ignore: cast_nullable_to_non_nullable
              as String,
      supplierName: null == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as int?,
      approvedByUser: freezed == approvedByUser
          ? _value.approvedByUser
          : approvedByUser // ignore: cast_nullable_to_non_nullable
              as UserDto?,
      components: freezed == components
          ? _value.components
          : components // ignore: cast_nullable_to_non_nullable
              as List<LandedCostComponent>?,
      shipments: freezed == shipments
          ? _value.shipments
          : shipments // ignore: cast_nullable_to_non_nullable
              as List<LandedCostShipment>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserDtoCopyWith<$Res>? get approvedByUser {
    if (_value.approvedByUser == null) {
      return null;
    }

    return $UserDtoCopyWith<$Res>(_value.approvedByUser!, (value) {
      return _then(_value.copyWith(approvedByUser: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LandedCostImplCopyWith<$Res>
    implements $LandedCostCopyWith<$Res> {
  factory _$$LandedCostImplCopyWith(
          _$LandedCostImpl value, $Res Function(_$LandedCostImpl) then) =
      __$$LandedCostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'company_id') int companyId,
      @JsonKey(name: 'reference_number') String referenceNumber,
      @JsonKey(name: 'posting_date') String postingDate,
      @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
      double totalAmount,
      String currency,
      @JsonKey(name: 'supplier_code') String supplierCode,
      @JsonKey(name: 'supplier_name') String supplierName,
      String? description,
      String status,
      @JsonKey(name: 'approved_at') String? approvedAt,
      @JsonKey(name: 'approved_by') int? approvedBy,
      @JsonKey(name: 'approved_by_user') UserDto? approvedByUser,
      List<LandedCostComponent>? components,
      List<LandedCostShipment>? shipments});

  @override
  $UserDtoCopyWith<$Res>? get approvedByUser;
}

/// @nodoc
class __$$LandedCostImplCopyWithImpl<$Res>
    extends _$LandedCostCopyWithImpl<$Res, _$LandedCostImpl>
    implements _$$LandedCostImplCopyWith<$Res> {
  __$$LandedCostImplCopyWithImpl(
      _$LandedCostImpl _value, $Res Function(_$LandedCostImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? referenceNumber = null,
    Object? postingDate = null,
    Object? totalAmount = null,
    Object? currency = null,
    Object? supplierCode = null,
    Object? supplierName = null,
    Object? description = freezed,
    Object? status = null,
    Object? approvedAt = freezed,
    Object? approvedBy = freezed,
    Object? approvedByUser = freezed,
    Object? components = freezed,
    Object? shipments = freezed,
  }) {
    return _then(_$LandedCostImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int,
      referenceNumber: null == referenceNumber
          ? _value.referenceNumber
          : referenceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      postingDate: null == postingDate
          ? _value.postingDate
          : postingDate // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      supplierCode: null == supplierCode
          ? _value.supplierCode
          : supplierCode // ignore: cast_nullable_to_non_nullable
              as String,
      supplierName: null == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as int?,
      approvedByUser: freezed == approvedByUser
          ? _value.approvedByUser
          : approvedByUser // ignore: cast_nullable_to_non_nullable
              as UserDto?,
      components: freezed == components
          ? _value._components
          : components // ignore: cast_nullable_to_non_nullable
              as List<LandedCostComponent>?,
      shipments: freezed == shipments
          ? _value._shipments
          : shipments // ignore: cast_nullable_to_non_nullable
              as List<LandedCostShipment>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LandedCostImpl implements _LandedCost {
  const _$LandedCostImpl(
      {required this.id,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'reference_number') required this.referenceNumber,
      @JsonKey(name: 'posting_date') required this.postingDate,
      @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
      required this.totalAmount,
      required this.currency,
      @JsonKey(name: 'supplier_code') required this.supplierCode,
      @JsonKey(name: 'supplier_name') required this.supplierName,
      this.description,
      required this.status,
      @JsonKey(name: 'approved_at') this.approvedAt,
      @JsonKey(name: 'approved_by') this.approvedBy,
      @JsonKey(name: 'approved_by_user') this.approvedByUser,
      final List<LandedCostComponent>? components,
      final List<LandedCostShipment>? shipments})
      : _components = components,
        _shipments = shipments;

  factory _$LandedCostImpl.fromJson(Map<String, dynamic> json) =>
      _$$LandedCostImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'company_id')
  final int companyId;
  @override
  @JsonKey(name: 'reference_number')
  final String referenceNumber;
  @override
  @JsonKey(name: 'posting_date')
  final String postingDate;
  @override
  @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
  final double totalAmount;
  @override
  final String currency;
  @override
  @JsonKey(name: 'supplier_code')
  final String supplierCode;
  @override
  @JsonKey(name: 'supplier_name')
  final String supplierName;
  @override
  final String? description;
  @override
  final String status;
  @override
  @JsonKey(name: 'approved_at')
  final String? approvedAt;
  @override
  @JsonKey(name: 'approved_by')
  final int? approvedBy;
  @override
  @JsonKey(name: 'approved_by_user')
  final UserDto? approvedByUser;
  final List<LandedCostComponent>? _components;
  @override
  List<LandedCostComponent>? get components {
    final value = _components;
    if (value == null) return null;
    if (_components is EqualUnmodifiableListView) return _components;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<LandedCostShipment>? _shipments;
  @override
  List<LandedCostShipment>? get shipments {
    final value = _shipments;
    if (value == null) return null;
    if (_shipments is EqualUnmodifiableListView) return _shipments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'LandedCost(id: $id, companyId: $companyId, referenceNumber: $referenceNumber, postingDate: $postingDate, totalAmount: $totalAmount, currency: $currency, supplierCode: $supplierCode, supplierName: $supplierName, description: $description, status: $status, approvedAt: $approvedAt, approvedBy: $approvedBy, approvedByUser: $approvedByUser, components: $components, shipments: $shipments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LandedCostImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.referenceNumber, referenceNumber) ||
                other.referenceNumber == referenceNumber) &&
            (identical(other.postingDate, postingDate) ||
                other.postingDate == postingDate) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.supplierCode, supplierCode) ||
                other.supplierCode == supplierCode) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
            (identical(other.approvedBy, approvedBy) ||
                other.approvedBy == approvedBy) &&
            (identical(other.approvedByUser, approvedByUser) ||
                other.approvedByUser == approvedByUser) &&
            const DeepCollectionEquality()
                .equals(other._components, _components) &&
            const DeepCollectionEquality()
                .equals(other._shipments, _shipments));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      companyId,
      referenceNumber,
      postingDate,
      totalAmount,
      currency,
      supplierCode,
      supplierName,
      description,
      status,
      approvedAt,
      approvedBy,
      approvedByUser,
      const DeepCollectionEquality().hash(_components),
      const DeepCollectionEquality().hash(_shipments));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LandedCostImplCopyWith<_$LandedCostImpl> get copyWith =>
      __$$LandedCostImplCopyWithImpl<_$LandedCostImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LandedCostImplToJson(
      this,
    );
  }
}

abstract class _LandedCost implements LandedCost {
  const factory _LandedCost(
      {required final int id,
      @JsonKey(name: 'company_id') required final int companyId,
      @JsonKey(name: 'reference_number') required final String referenceNumber,
      @JsonKey(name: 'posting_date') required final String postingDate,
      @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
      required final double totalAmount,
      required final String currency,
      @JsonKey(name: 'supplier_code') required final String supplierCode,
      @JsonKey(name: 'supplier_name') required final String supplierName,
      final String? description,
      required final String status,
      @JsonKey(name: 'approved_at') final String? approvedAt,
      @JsonKey(name: 'approved_by') final int? approvedBy,
      @JsonKey(name: 'approved_by_user') final UserDto? approvedByUser,
      final List<LandedCostComponent>? components,
      final List<LandedCostShipment>? shipments}) = _$LandedCostImpl;

  factory _LandedCost.fromJson(Map<String, dynamic> json) =
      _$LandedCostImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'company_id')
  int get companyId;
  @override
  @JsonKey(name: 'reference_number')
  String get referenceNumber;
  @override
  @JsonKey(name: 'posting_date')
  String get postingDate;
  @override
  @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
  double get totalAmount;
  @override
  String get currency;
  @override
  @JsonKey(name: 'supplier_code')
  String get supplierCode;
  @override
  @JsonKey(name: 'supplier_name')
  String get supplierName;
  @override
  String? get description;
  @override
  String get status;
  @override
  @JsonKey(name: 'approved_at')
  String? get approvedAt;
  @override
  @JsonKey(name: 'approved_by')
  int? get approvedBy;
  @override
  @JsonKey(name: 'approved_by_user')
  UserDto? get approvedByUser;
  @override
  List<LandedCostComponent>? get components;
  @override
  List<LandedCostShipment>? get shipments;
  @override
  @JsonKey(ignore: true)
  _$$LandedCostImplCopyWith<_$LandedCostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LandedCostComponent _$LandedCostComponentFromJson(Map<String, dynamic> json) {
  return _LandedCostComponent.fromJson(json);
}

/// @nodoc
mixin _$LandedCostComponent {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'landed_cost_id')
  int get landedCostId => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_id')
  int? get invoiceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'receiving_header_id')
  int? get receivingHeaderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'container_id')
  int? get containerId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: doubleFromJson)
  double get amount => throw _privateConstructorUsedError;
  ContainerDto? get container => throw _privateConstructorUsedError;
  InvoiceDto? get invoice => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LandedCostComponentCopyWith<LandedCostComponent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LandedCostComponentCopyWith<$Res> {
  factory $LandedCostComponentCopyWith(
          LandedCostComponent value, $Res Function(LandedCostComponent) then) =
      _$LandedCostComponentCopyWithImpl<$Res, LandedCostComponent>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'landed_cost_id') int landedCostId,
      String category,
      @JsonKey(name: 'invoice_id') int? invoiceId,
      @JsonKey(name: 'receiving_header_id') int? receivingHeaderId,
      @JsonKey(name: 'container_id') int? containerId,
      @JsonKey(fromJson: doubleFromJson) double amount,
      ContainerDto? container,
      InvoiceDto? invoice});

  $ContainerDtoCopyWith<$Res>? get container;
  $InvoiceDtoCopyWith<$Res>? get invoice;
}

/// @nodoc
class _$LandedCostComponentCopyWithImpl<$Res, $Val extends LandedCostComponent>
    implements $LandedCostComponentCopyWith<$Res> {
  _$LandedCostComponentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? landedCostId = null,
    Object? category = null,
    Object? invoiceId = freezed,
    Object? receivingHeaderId = freezed,
    Object? containerId = freezed,
    Object? amount = null,
    Object? container = freezed,
    Object? invoice = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      landedCostId: null == landedCostId
          ? _value.landedCostId
          : landedCostId // ignore: cast_nullable_to_non_nullable
              as int,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceId: freezed == invoiceId
          ? _value.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as int?,
      receivingHeaderId: freezed == receivingHeaderId
          ? _value.receivingHeaderId
          : receivingHeaderId // ignore: cast_nullable_to_non_nullable
              as int?,
      containerId: freezed == containerId
          ? _value.containerId
          : containerId // ignore: cast_nullable_to_non_nullable
              as int?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      container: freezed == container
          ? _value.container
          : container // ignore: cast_nullable_to_non_nullable
              as ContainerDto?,
      invoice: freezed == invoice
          ? _value.invoice
          : invoice // ignore: cast_nullable_to_non_nullable
              as InvoiceDto?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ContainerDtoCopyWith<$Res>? get container {
    if (_value.container == null) {
      return null;
    }

    return $ContainerDtoCopyWith<$Res>(_value.container!, (value) {
      return _then(_value.copyWith(container: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $InvoiceDtoCopyWith<$Res>? get invoice {
    if (_value.invoice == null) {
      return null;
    }

    return $InvoiceDtoCopyWith<$Res>(_value.invoice!, (value) {
      return _then(_value.copyWith(invoice: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LandedCostComponentImplCopyWith<$Res>
    implements $LandedCostComponentCopyWith<$Res> {
  factory _$$LandedCostComponentImplCopyWith(_$LandedCostComponentImpl value,
          $Res Function(_$LandedCostComponentImpl) then) =
      __$$LandedCostComponentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'landed_cost_id') int landedCostId,
      String category,
      @JsonKey(name: 'invoice_id') int? invoiceId,
      @JsonKey(name: 'receiving_header_id') int? receivingHeaderId,
      @JsonKey(name: 'container_id') int? containerId,
      @JsonKey(fromJson: doubleFromJson) double amount,
      ContainerDto? container,
      InvoiceDto? invoice});

  @override
  $ContainerDtoCopyWith<$Res>? get container;
  @override
  $InvoiceDtoCopyWith<$Res>? get invoice;
}

/// @nodoc
class __$$LandedCostComponentImplCopyWithImpl<$Res>
    extends _$LandedCostComponentCopyWithImpl<$Res, _$LandedCostComponentImpl>
    implements _$$LandedCostComponentImplCopyWith<$Res> {
  __$$LandedCostComponentImplCopyWithImpl(_$LandedCostComponentImpl _value,
      $Res Function(_$LandedCostComponentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? landedCostId = null,
    Object? category = null,
    Object? invoiceId = freezed,
    Object? receivingHeaderId = freezed,
    Object? containerId = freezed,
    Object? amount = null,
    Object? container = freezed,
    Object? invoice = freezed,
  }) {
    return _then(_$LandedCostComponentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      landedCostId: null == landedCostId
          ? _value.landedCostId
          : landedCostId // ignore: cast_nullable_to_non_nullable
              as int,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceId: freezed == invoiceId
          ? _value.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as int?,
      receivingHeaderId: freezed == receivingHeaderId
          ? _value.receivingHeaderId
          : receivingHeaderId // ignore: cast_nullable_to_non_nullable
              as int?,
      containerId: freezed == containerId
          ? _value.containerId
          : containerId // ignore: cast_nullable_to_non_nullable
              as int?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      container: freezed == container
          ? _value.container
          : container // ignore: cast_nullable_to_non_nullable
              as ContainerDto?,
      invoice: freezed == invoice
          ? _value.invoice
          : invoice // ignore: cast_nullable_to_non_nullable
              as InvoiceDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LandedCostComponentImpl implements _LandedCostComponent {
  const _$LandedCostComponentImpl(
      {required this.id,
      @JsonKey(name: 'landed_cost_id') required this.landedCostId,
      required this.category,
      @JsonKey(name: 'invoice_id') this.invoiceId,
      @JsonKey(name: 'receiving_header_id') this.receivingHeaderId,
      @JsonKey(name: 'container_id') this.containerId,
      @JsonKey(fromJson: doubleFromJson) required this.amount,
      this.container,
      this.invoice});

  factory _$LandedCostComponentImpl.fromJson(Map<String, dynamic> json) =>
      _$$LandedCostComponentImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'landed_cost_id')
  final int landedCostId;
  @override
  final String category;
  @override
  @JsonKey(name: 'invoice_id')
  final int? invoiceId;
  @override
  @JsonKey(name: 'receiving_header_id')
  final int? receivingHeaderId;
  @override
  @JsonKey(name: 'container_id')
  final int? containerId;
  @override
  @JsonKey(fromJson: doubleFromJson)
  final double amount;
  @override
  final ContainerDto? container;
  @override
  final InvoiceDto? invoice;

  @override
  String toString() {
    return 'LandedCostComponent(id: $id, landedCostId: $landedCostId, category: $category, invoiceId: $invoiceId, receivingHeaderId: $receivingHeaderId, containerId: $containerId, amount: $amount, container: $container, invoice: $invoice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LandedCostComponentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.landedCostId, landedCostId) ||
                other.landedCostId == landedCostId) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.invoiceId, invoiceId) ||
                other.invoiceId == invoiceId) &&
            (identical(other.receivingHeaderId, receivingHeaderId) ||
                other.receivingHeaderId == receivingHeaderId) &&
            (identical(other.containerId, containerId) ||
                other.containerId == containerId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.container, container) ||
                other.container == container) &&
            (identical(other.invoice, invoice) || other.invoice == invoice));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, landedCostId, category,
      invoiceId, receivingHeaderId, containerId, amount, container, invoice);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LandedCostComponentImplCopyWith<_$LandedCostComponentImpl> get copyWith =>
      __$$LandedCostComponentImplCopyWithImpl<_$LandedCostComponentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LandedCostComponentImplToJson(
      this,
    );
  }
}

abstract class _LandedCostComponent implements LandedCostComponent {
  const factory _LandedCostComponent(
      {required final int id,
      @JsonKey(name: 'landed_cost_id') required final int landedCostId,
      required final String category,
      @JsonKey(name: 'invoice_id') final int? invoiceId,
      @JsonKey(name: 'receiving_header_id') final int? receivingHeaderId,
      @JsonKey(name: 'container_id') final int? containerId,
      @JsonKey(fromJson: doubleFromJson) required final double amount,
      final ContainerDto? container,
      final InvoiceDto? invoice}) = _$LandedCostComponentImpl;

  factory _LandedCostComponent.fromJson(Map<String, dynamic> json) =
      _$LandedCostComponentImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'landed_cost_id')
  int get landedCostId;
  @override
  String get category;
  @override
  @JsonKey(name: 'invoice_id')
  int? get invoiceId;
  @override
  @JsonKey(name: 'receiving_header_id')
  int? get receivingHeaderId;
  @override
  @JsonKey(name: 'container_id')
  int? get containerId;
  @override
  @JsonKey(fromJson: doubleFromJson)
  double get amount;
  @override
  ContainerDto? get container;
  @override
  InvoiceDto? get invoice;
  @override
  @JsonKey(ignore: true)
  _$$LandedCostComponentImplCopyWith<_$LandedCostComponentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ContainerDto _$ContainerDtoFromJson(Map<String, dynamic> json) {
  return _ContainerDto.fromJson(json);
}

/// @nodoc
mixin _$ContainerDto {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'container_number')
  String get containerNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContainerDtoCopyWith<ContainerDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContainerDtoCopyWith<$Res> {
  factory $ContainerDtoCopyWith(
          ContainerDto value, $Res Function(ContainerDto) then) =
      _$ContainerDtoCopyWithImpl<$Res, ContainerDto>;
  @useResult
  $Res call(
      {int id, @JsonKey(name: 'container_number') String containerNumber});
}

/// @nodoc
class _$ContainerDtoCopyWithImpl<$Res, $Val extends ContainerDto>
    implements $ContainerDtoCopyWith<$Res> {
  _$ContainerDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? containerNumber = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContainerDtoImplCopyWith<$Res>
    implements $ContainerDtoCopyWith<$Res> {
  factory _$$ContainerDtoImplCopyWith(
          _$ContainerDtoImpl value, $Res Function(_$ContainerDtoImpl) then) =
      __$$ContainerDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id, @JsonKey(name: 'container_number') String containerNumber});
}

/// @nodoc
class __$$ContainerDtoImplCopyWithImpl<$Res>
    extends _$ContainerDtoCopyWithImpl<$Res, _$ContainerDtoImpl>
    implements _$$ContainerDtoImplCopyWith<$Res> {
  __$$ContainerDtoImplCopyWithImpl(
      _$ContainerDtoImpl _value, $Res Function(_$ContainerDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? containerNumber = null,
  }) {
    return _then(_$ContainerDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      containerNumber: null == containerNumber
          ? _value.containerNumber
          : containerNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContainerDtoImpl implements _ContainerDto {
  const _$ContainerDtoImpl(
      {required this.id,
      @JsonKey(name: 'container_number') required this.containerNumber});

  factory _$ContainerDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContainerDtoImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'container_number')
  final String containerNumber;

  @override
  String toString() {
    return 'ContainerDto(id: $id, containerNumber: $containerNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContainerDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.containerNumber, containerNumber) ||
                other.containerNumber == containerNumber));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, containerNumber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContainerDtoImplCopyWith<_$ContainerDtoImpl> get copyWith =>
      __$$ContainerDtoImplCopyWithImpl<_$ContainerDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContainerDtoImplToJson(
      this,
    );
  }
}

abstract class _ContainerDto implements ContainerDto {
  const factory _ContainerDto(
      {required final int id,
      @JsonKey(name: 'container_number')
      required final String containerNumber}) = _$ContainerDtoImpl;

  factory _ContainerDto.fromJson(Map<String, dynamic> json) =
      _$ContainerDtoImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'container_number')
  String get containerNumber;
  @override
  @JsonKey(ignore: true)
  _$$ContainerDtoImplCopyWith<_$ContainerDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InvoiceDto _$InvoiceDtoFromJson(Map<String, dynamic> json) {
  return _InvoiceDto.fromJson(json);
}

/// @nodoc
mixin _$InvoiceDto {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_number')
  String get invoiceNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InvoiceDtoCopyWith<InvoiceDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceDtoCopyWith<$Res> {
  factory $InvoiceDtoCopyWith(
          InvoiceDto value, $Res Function(InvoiceDto) then) =
      _$InvoiceDtoCopyWithImpl<$Res, InvoiceDto>;
  @useResult
  $Res call({int id, @JsonKey(name: 'invoice_number') String invoiceNumber});
}

/// @nodoc
class _$InvoiceDtoCopyWithImpl<$Res, $Val extends InvoiceDto>
    implements $InvoiceDtoCopyWith<$Res> {
  _$InvoiceDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceNumber = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      invoiceNumber: null == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvoiceDtoImplCopyWith<$Res>
    implements $InvoiceDtoCopyWith<$Res> {
  factory _$$InvoiceDtoImplCopyWith(
          _$InvoiceDtoImpl value, $Res Function(_$InvoiceDtoImpl) then) =
      __$$InvoiceDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, @JsonKey(name: 'invoice_number') String invoiceNumber});
}

/// @nodoc
class __$$InvoiceDtoImplCopyWithImpl<$Res>
    extends _$InvoiceDtoCopyWithImpl<$Res, _$InvoiceDtoImpl>
    implements _$$InvoiceDtoImplCopyWith<$Res> {
  __$$InvoiceDtoImplCopyWithImpl(
      _$InvoiceDtoImpl _value, $Res Function(_$InvoiceDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceNumber = null,
  }) {
    return _then(_$InvoiceDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      invoiceNumber: null == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InvoiceDtoImpl implements _InvoiceDto {
  const _$InvoiceDtoImpl(
      {required this.id,
      @JsonKey(name: 'invoice_number') required this.invoiceNumber});

  factory _$InvoiceDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvoiceDtoImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'invoice_number')
  final String invoiceNumber;

  @override
  String toString() {
    return 'InvoiceDto(id: $id, invoiceNumber: $invoiceNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.invoiceNumber, invoiceNumber) ||
                other.invoiceNumber == invoiceNumber));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, invoiceNumber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceDtoImplCopyWith<_$InvoiceDtoImpl> get copyWith =>
      __$$InvoiceDtoImplCopyWithImpl<_$InvoiceDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InvoiceDtoImplToJson(
      this,
    );
  }
}

abstract class _InvoiceDto implements InvoiceDto {
  const factory _InvoiceDto(
      {required final int id,
      @JsonKey(name: 'invoice_number')
      required final String invoiceNumber}) = _$InvoiceDtoImpl;

  factory _InvoiceDto.fromJson(Map<String, dynamic> json) =
      _$InvoiceDtoImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'invoice_number')
  String get invoiceNumber;
  @override
  @JsonKey(ignore: true)
  _$$InvoiceDtoImplCopyWith<_$InvoiceDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LandedCostShipment _$LandedCostShipmentFromJson(Map<String, dynamic> json) {
  return _LandedCostShipment.fromJson(json);
}

/// @nodoc
mixin _$LandedCostShipment {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'landed_cost_id')
  int get landedCostId => throw _privateConstructorUsedError;
  @JsonKey(name: 'receiving_header_id')
  int get receivingHeaderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipment_percentage', fromJson: doubleFromJson)
  double get shipmentPercentage => throw _privateConstructorUsedError;
  @JsonKey(name: 'receiving_header')
  ReceivingHeaderDto? get receivingHeader => throw _privateConstructorUsedError;
  List<LandedCostItem>? get items => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LandedCostShipmentCopyWith<LandedCostShipment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LandedCostShipmentCopyWith<$Res> {
  factory $LandedCostShipmentCopyWith(
          LandedCostShipment value, $Res Function(LandedCostShipment) then) =
      _$LandedCostShipmentCopyWithImpl<$Res, LandedCostShipment>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'landed_cost_id') int landedCostId,
      @JsonKey(name: 'receiving_header_id') int receivingHeaderId,
      @JsonKey(name: 'shipment_percentage', fromJson: doubleFromJson)
      double shipmentPercentage,
      @JsonKey(name: 'receiving_header') ReceivingHeaderDto? receivingHeader,
      List<LandedCostItem>? items});

  $ReceivingHeaderDtoCopyWith<$Res>? get receivingHeader;
}

/// @nodoc
class _$LandedCostShipmentCopyWithImpl<$Res, $Val extends LandedCostShipment>
    implements $LandedCostShipmentCopyWith<$Res> {
  _$LandedCostShipmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? landedCostId = null,
    Object? receivingHeaderId = null,
    Object? shipmentPercentage = null,
    Object? receivingHeader = freezed,
    Object? items = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      landedCostId: null == landedCostId
          ? _value.landedCostId
          : landedCostId // ignore: cast_nullable_to_non_nullable
              as int,
      receivingHeaderId: null == receivingHeaderId
          ? _value.receivingHeaderId
          : receivingHeaderId // ignore: cast_nullable_to_non_nullable
              as int,
      shipmentPercentage: null == shipmentPercentage
          ? _value.shipmentPercentage
          : shipmentPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      receivingHeader: freezed == receivingHeader
          ? _value.receivingHeader
          : receivingHeader // ignore: cast_nullable_to_non_nullable
              as ReceivingHeaderDto?,
      items: freezed == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<LandedCostItem>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ReceivingHeaderDtoCopyWith<$Res>? get receivingHeader {
    if (_value.receivingHeader == null) {
      return null;
    }

    return $ReceivingHeaderDtoCopyWith<$Res>(_value.receivingHeader!, (value) {
      return _then(_value.copyWith(receivingHeader: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LandedCostShipmentImplCopyWith<$Res>
    implements $LandedCostShipmentCopyWith<$Res> {
  factory _$$LandedCostShipmentImplCopyWith(_$LandedCostShipmentImpl value,
          $Res Function(_$LandedCostShipmentImpl) then) =
      __$$LandedCostShipmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'landed_cost_id') int landedCostId,
      @JsonKey(name: 'receiving_header_id') int receivingHeaderId,
      @JsonKey(name: 'shipment_percentage', fromJson: doubleFromJson)
      double shipmentPercentage,
      @JsonKey(name: 'receiving_header') ReceivingHeaderDto? receivingHeader,
      List<LandedCostItem>? items});

  @override
  $ReceivingHeaderDtoCopyWith<$Res>? get receivingHeader;
}

/// @nodoc
class __$$LandedCostShipmentImplCopyWithImpl<$Res>
    extends _$LandedCostShipmentCopyWithImpl<$Res, _$LandedCostShipmentImpl>
    implements _$$LandedCostShipmentImplCopyWith<$Res> {
  __$$LandedCostShipmentImplCopyWithImpl(_$LandedCostShipmentImpl _value,
      $Res Function(_$LandedCostShipmentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? landedCostId = null,
    Object? receivingHeaderId = null,
    Object? shipmentPercentage = null,
    Object? receivingHeader = freezed,
    Object? items = freezed,
  }) {
    return _then(_$LandedCostShipmentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      landedCostId: null == landedCostId
          ? _value.landedCostId
          : landedCostId // ignore: cast_nullable_to_non_nullable
              as int,
      receivingHeaderId: null == receivingHeaderId
          ? _value.receivingHeaderId
          : receivingHeaderId // ignore: cast_nullable_to_non_nullable
              as int,
      shipmentPercentage: null == shipmentPercentage
          ? _value.shipmentPercentage
          : shipmentPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      receivingHeader: freezed == receivingHeader
          ? _value.receivingHeader
          : receivingHeader // ignore: cast_nullable_to_non_nullable
              as ReceivingHeaderDto?,
      items: freezed == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<LandedCostItem>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LandedCostShipmentImpl implements _LandedCostShipment {
  const _$LandedCostShipmentImpl(
      {required this.id,
      @JsonKey(name: 'landed_cost_id') required this.landedCostId,
      @JsonKey(name: 'receiving_header_id') required this.receivingHeaderId,
      @JsonKey(name: 'shipment_percentage', fromJson: doubleFromJson)
      required this.shipmentPercentage,
      @JsonKey(name: 'receiving_header') this.receivingHeader,
      final List<LandedCostItem>? items})
      : _items = items;

  factory _$LandedCostShipmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$LandedCostShipmentImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'landed_cost_id')
  final int landedCostId;
  @override
  @JsonKey(name: 'receiving_header_id')
  final int receivingHeaderId;
  @override
  @JsonKey(name: 'shipment_percentage', fromJson: doubleFromJson)
  final double shipmentPercentage;
  @override
  @JsonKey(name: 'receiving_header')
  final ReceivingHeaderDto? receivingHeader;
  final List<LandedCostItem>? _items;
  @override
  List<LandedCostItem>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'LandedCostShipment(id: $id, landedCostId: $landedCostId, receivingHeaderId: $receivingHeaderId, shipmentPercentage: $shipmentPercentage, receivingHeader: $receivingHeader, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LandedCostShipmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.landedCostId, landedCostId) ||
                other.landedCostId == landedCostId) &&
            (identical(other.receivingHeaderId, receivingHeaderId) ||
                other.receivingHeaderId == receivingHeaderId) &&
            (identical(other.shipmentPercentage, shipmentPercentage) ||
                other.shipmentPercentage == shipmentPercentage) &&
            (identical(other.receivingHeader, receivingHeader) ||
                other.receivingHeader == receivingHeader) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      landedCostId,
      receivingHeaderId,
      shipmentPercentage,
      receivingHeader,
      const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LandedCostShipmentImplCopyWith<_$LandedCostShipmentImpl> get copyWith =>
      __$$LandedCostShipmentImplCopyWithImpl<_$LandedCostShipmentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LandedCostShipmentImplToJson(
      this,
    );
  }
}

abstract class _LandedCostShipment implements LandedCostShipment {
  const factory _LandedCostShipment(
      {required final int id,
      @JsonKey(name: 'landed_cost_id') required final int landedCostId,
      @JsonKey(name: 'receiving_header_id')
      required final int receivingHeaderId,
      @JsonKey(name: 'shipment_percentage', fromJson: doubleFromJson)
      required final double shipmentPercentage,
      @JsonKey(name: 'receiving_header')
      final ReceivingHeaderDto? receivingHeader,
      final List<LandedCostItem>? items}) = _$LandedCostShipmentImpl;

  factory _LandedCostShipment.fromJson(Map<String, dynamic> json) =
      _$LandedCostShipmentImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'landed_cost_id')
  int get landedCostId;
  @override
  @JsonKey(name: 'receiving_header_id')
  int get receivingHeaderId;
  @override
  @JsonKey(name: 'shipment_percentage', fromJson: doubleFromJson)
  double get shipmentPercentage;
  @override
  @JsonKey(name: 'receiving_header')
  ReceivingHeaderDto? get receivingHeader;
  @override
  List<LandedCostItem>? get items;
  @override
  @JsonKey(ignore: true)
  _$$LandedCostShipmentImplCopyWith<_$LandedCostShipmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReceivingHeaderDto _$ReceivingHeaderDtoFromJson(Map<String, dynamic> json) {
  return _ReceivingHeaderDto.fromJson(json);
}

/// @nodoc
mixin _$ReceivingHeaderDto {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'receiving_number')
  String get receivingNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_order_number')
  String? get deliveryOrderNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'purchase_order')
  PurchaseOrderDto? get purchaseOrder => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReceivingHeaderDtoCopyWith<ReceivingHeaderDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceivingHeaderDtoCopyWith<$Res> {
  factory $ReceivingHeaderDtoCopyWith(
          ReceivingHeaderDto value, $Res Function(ReceivingHeaderDto) then) =
      _$ReceivingHeaderDtoCopyWithImpl<$Res, ReceivingHeaderDto>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'receiving_number') String receivingNumber,
      @JsonKey(name: 'delivery_order_number') String? deliveryOrderNumber,
      @JsonKey(name: 'purchase_order') PurchaseOrderDto? purchaseOrder});

  $PurchaseOrderDtoCopyWith<$Res>? get purchaseOrder;
}

/// @nodoc
class _$ReceivingHeaderDtoCopyWithImpl<$Res, $Val extends ReceivingHeaderDto>
    implements $ReceivingHeaderDtoCopyWith<$Res> {
  _$ReceivingHeaderDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? receivingNumber = null,
    Object? deliveryOrderNumber = freezed,
    Object? purchaseOrder = freezed,
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
      deliveryOrderNumber: freezed == deliveryOrderNumber
          ? _value.deliveryOrderNumber
          : deliveryOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      purchaseOrder: freezed == purchaseOrder
          ? _value.purchaseOrder
          : purchaseOrder // ignore: cast_nullable_to_non_nullable
              as PurchaseOrderDto?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PurchaseOrderDtoCopyWith<$Res>? get purchaseOrder {
    if (_value.purchaseOrder == null) {
      return null;
    }

    return $PurchaseOrderDtoCopyWith<$Res>(_value.purchaseOrder!, (value) {
      return _then(_value.copyWith(purchaseOrder: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReceivingHeaderDtoImplCopyWith<$Res>
    implements $ReceivingHeaderDtoCopyWith<$Res> {
  factory _$$ReceivingHeaderDtoImplCopyWith(_$ReceivingHeaderDtoImpl value,
          $Res Function(_$ReceivingHeaderDtoImpl) then) =
      __$$ReceivingHeaderDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'receiving_number') String receivingNumber,
      @JsonKey(name: 'delivery_order_number') String? deliveryOrderNumber,
      @JsonKey(name: 'purchase_order') PurchaseOrderDto? purchaseOrder});

  @override
  $PurchaseOrderDtoCopyWith<$Res>? get purchaseOrder;
}

/// @nodoc
class __$$ReceivingHeaderDtoImplCopyWithImpl<$Res>
    extends _$ReceivingHeaderDtoCopyWithImpl<$Res, _$ReceivingHeaderDtoImpl>
    implements _$$ReceivingHeaderDtoImplCopyWith<$Res> {
  __$$ReceivingHeaderDtoImplCopyWithImpl(_$ReceivingHeaderDtoImpl _value,
      $Res Function(_$ReceivingHeaderDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? receivingNumber = null,
    Object? deliveryOrderNumber = freezed,
    Object? purchaseOrder = freezed,
  }) {
    return _then(_$ReceivingHeaderDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      receivingNumber: null == receivingNumber
          ? _value.receivingNumber
          : receivingNumber // ignore: cast_nullable_to_non_nullable
              as String,
      deliveryOrderNumber: freezed == deliveryOrderNumber
          ? _value.deliveryOrderNumber
          : deliveryOrderNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      purchaseOrder: freezed == purchaseOrder
          ? _value.purchaseOrder
          : purchaseOrder // ignore: cast_nullable_to_non_nullable
              as PurchaseOrderDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReceivingHeaderDtoImpl implements _ReceivingHeaderDto {
  const _$ReceivingHeaderDtoImpl(
      {required this.id,
      @JsonKey(name: 'receiving_number') required this.receivingNumber,
      @JsonKey(name: 'delivery_order_number') this.deliveryOrderNumber,
      @JsonKey(name: 'purchase_order') this.purchaseOrder});

  factory _$ReceivingHeaderDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReceivingHeaderDtoImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'receiving_number')
  final String receivingNumber;
  @override
  @JsonKey(name: 'delivery_order_number')
  final String? deliveryOrderNumber;
  @override
  @JsonKey(name: 'purchase_order')
  final PurchaseOrderDto? purchaseOrder;

  @override
  String toString() {
    return 'ReceivingHeaderDto(id: $id, receivingNumber: $receivingNumber, deliveryOrderNumber: $deliveryOrderNumber, purchaseOrder: $purchaseOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceivingHeaderDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.receivingNumber, receivingNumber) ||
                other.receivingNumber == receivingNumber) &&
            (identical(other.deliveryOrderNumber, deliveryOrderNumber) ||
                other.deliveryOrderNumber == deliveryOrderNumber) &&
            (identical(other.purchaseOrder, purchaseOrder) ||
                other.purchaseOrder == purchaseOrder));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, receivingNumber, deliveryOrderNumber, purchaseOrder);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceivingHeaderDtoImplCopyWith<_$ReceivingHeaderDtoImpl> get copyWith =>
      __$$ReceivingHeaderDtoImplCopyWithImpl<_$ReceivingHeaderDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReceivingHeaderDtoImplToJson(
      this,
    );
  }
}

abstract class _ReceivingHeaderDto implements ReceivingHeaderDto {
  const factory _ReceivingHeaderDto(
      {required final int id,
      @JsonKey(name: 'receiving_number') required final String receivingNumber,
      @JsonKey(name: 'delivery_order_number') final String? deliveryOrderNumber,
      @JsonKey(name: 'purchase_order')
      final PurchaseOrderDto? purchaseOrder}) = _$ReceivingHeaderDtoImpl;

  factory _ReceivingHeaderDto.fromJson(Map<String, dynamic> json) =
      _$ReceivingHeaderDtoImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'receiving_number')
  String get receivingNumber;
  @override
  @JsonKey(name: 'delivery_order_number')
  String? get deliveryOrderNumber;
  @override
  @JsonKey(name: 'purchase_order')
  PurchaseOrderDto? get purchaseOrder;
  @override
  @JsonKey(ignore: true)
  _$$ReceivingHeaderDtoImplCopyWith<_$ReceivingHeaderDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PurchaseOrderDto _$PurchaseOrderDtoFromJson(Map<String, dynamic> json) {
  return _PurchaseOrderDto.fromJson(json);
}

/// @nodoc
mixin _$PurchaseOrderDto {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_name')
  String get supplierName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PurchaseOrderDtoCopyWith<PurchaseOrderDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseOrderDtoCopyWith<$Res> {
  factory $PurchaseOrderDtoCopyWith(
          PurchaseOrderDto value, $Res Function(PurchaseOrderDto) then) =
      _$PurchaseOrderDtoCopyWithImpl<$Res, PurchaseOrderDto>;
  @useResult
  $Res call({int id, @JsonKey(name: 'supplier_name') String supplierName});
}

/// @nodoc
class _$PurchaseOrderDtoCopyWithImpl<$Res, $Val extends PurchaseOrderDto>
    implements $PurchaseOrderDtoCopyWith<$Res> {
  _$PurchaseOrderDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? supplierName = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      supplierName: null == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PurchaseOrderDtoImplCopyWith<$Res>
    implements $PurchaseOrderDtoCopyWith<$Res> {
  factory _$$PurchaseOrderDtoImplCopyWith(_$PurchaseOrderDtoImpl value,
          $Res Function(_$PurchaseOrderDtoImpl) then) =
      __$$PurchaseOrderDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, @JsonKey(name: 'supplier_name') String supplierName});
}

/// @nodoc
class __$$PurchaseOrderDtoImplCopyWithImpl<$Res>
    extends _$PurchaseOrderDtoCopyWithImpl<$Res, _$PurchaseOrderDtoImpl>
    implements _$$PurchaseOrderDtoImplCopyWith<$Res> {
  __$$PurchaseOrderDtoImplCopyWithImpl(_$PurchaseOrderDtoImpl _value,
      $Res Function(_$PurchaseOrderDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? supplierName = null,
  }) {
    return _then(_$PurchaseOrderDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      supplierName: null == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseOrderDtoImpl implements _PurchaseOrderDto {
  const _$PurchaseOrderDtoImpl(
      {required this.id,
      @JsonKey(name: 'supplier_name') required this.supplierName});

  factory _$PurchaseOrderDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseOrderDtoImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'supplier_name')
  final String supplierName;

  @override
  String toString() {
    return 'PurchaseOrderDto(id: $id, supplierName: $supplierName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseOrderDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, supplierName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseOrderDtoImplCopyWith<_$PurchaseOrderDtoImpl> get copyWith =>
      __$$PurchaseOrderDtoImplCopyWithImpl<_$PurchaseOrderDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseOrderDtoImplToJson(
      this,
    );
  }
}

abstract class _PurchaseOrderDto implements PurchaseOrderDto {
  const factory _PurchaseOrderDto(
          {required final int id,
          @JsonKey(name: 'supplier_name') required final String supplierName}) =
      _$PurchaseOrderDtoImpl;

  factory _PurchaseOrderDto.fromJson(Map<String, dynamic> json) =
      _$PurchaseOrderDtoImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'supplier_name')
  String get supplierName;
  @override
  @JsonKey(ignore: true)
  _$$PurchaseOrderDtoImplCopyWith<_$PurchaseOrderDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LandedCostItem _$LandedCostItemFromJson(Map<String, dynamic> json) {
  return _LandedCostItem.fromJson(json);
}

/// @nodoc
mixin _$LandedCostItem {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'landed_cost_shipment_id')
  int get landedCostShipmentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'receiving_detail_id')
  int get receivingDetailId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_selected')
  bool get isSelected => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_percentage', fromJson: doubleFromJson)
  double get itemPercentage => throw _privateConstructorUsedError;
  @JsonKey(name: 'allocated_amount', fromJson: doubleFromJson)
  double get allocatedAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'receiving_detail')
  ReceivingDetailDto? get receivingDetail => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LandedCostItemCopyWith<LandedCostItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LandedCostItemCopyWith<$Res> {
  factory $LandedCostItemCopyWith(
          LandedCostItem value, $Res Function(LandedCostItem) then) =
      _$LandedCostItemCopyWithImpl<$Res, LandedCostItem>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'landed_cost_shipment_id') int landedCostShipmentId,
      @JsonKey(name: 'receiving_detail_id') int receivingDetailId,
      @JsonKey(name: 'is_selected') bool isSelected,
      @JsonKey(name: 'item_percentage', fromJson: doubleFromJson)
      double itemPercentage,
      @JsonKey(name: 'allocated_amount', fromJson: doubleFromJson)
      double allocatedAmount,
      @JsonKey(name: 'receiving_detail') ReceivingDetailDto? receivingDetail});

  $ReceivingDetailDtoCopyWith<$Res>? get receivingDetail;
}

/// @nodoc
class _$LandedCostItemCopyWithImpl<$Res, $Val extends LandedCostItem>
    implements $LandedCostItemCopyWith<$Res> {
  _$LandedCostItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? landedCostShipmentId = null,
    Object? receivingDetailId = null,
    Object? isSelected = null,
    Object? itemPercentage = null,
    Object? allocatedAmount = null,
    Object? receivingDetail = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      landedCostShipmentId: null == landedCostShipmentId
          ? _value.landedCostShipmentId
          : landedCostShipmentId // ignore: cast_nullable_to_non_nullable
              as int,
      receivingDetailId: null == receivingDetailId
          ? _value.receivingDetailId
          : receivingDetailId // ignore: cast_nullable_to_non_nullable
              as int,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      itemPercentage: null == itemPercentage
          ? _value.itemPercentage
          : itemPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      allocatedAmount: null == allocatedAmount
          ? _value.allocatedAmount
          : allocatedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      receivingDetail: freezed == receivingDetail
          ? _value.receivingDetail
          : receivingDetail // ignore: cast_nullable_to_non_nullable
              as ReceivingDetailDto?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ReceivingDetailDtoCopyWith<$Res>? get receivingDetail {
    if (_value.receivingDetail == null) {
      return null;
    }

    return $ReceivingDetailDtoCopyWith<$Res>(_value.receivingDetail!, (value) {
      return _then(_value.copyWith(receivingDetail: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LandedCostItemImplCopyWith<$Res>
    implements $LandedCostItemCopyWith<$Res> {
  factory _$$LandedCostItemImplCopyWith(_$LandedCostItemImpl value,
          $Res Function(_$LandedCostItemImpl) then) =
      __$$LandedCostItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'landed_cost_shipment_id') int landedCostShipmentId,
      @JsonKey(name: 'receiving_detail_id') int receivingDetailId,
      @JsonKey(name: 'is_selected') bool isSelected,
      @JsonKey(name: 'item_percentage', fromJson: doubleFromJson)
      double itemPercentage,
      @JsonKey(name: 'allocated_amount', fromJson: doubleFromJson)
      double allocatedAmount,
      @JsonKey(name: 'receiving_detail') ReceivingDetailDto? receivingDetail});

  @override
  $ReceivingDetailDtoCopyWith<$Res>? get receivingDetail;
}

/// @nodoc
class __$$LandedCostItemImplCopyWithImpl<$Res>
    extends _$LandedCostItemCopyWithImpl<$Res, _$LandedCostItemImpl>
    implements _$$LandedCostItemImplCopyWith<$Res> {
  __$$LandedCostItemImplCopyWithImpl(
      _$LandedCostItemImpl _value, $Res Function(_$LandedCostItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? landedCostShipmentId = null,
    Object? receivingDetailId = null,
    Object? isSelected = null,
    Object? itemPercentage = null,
    Object? allocatedAmount = null,
    Object? receivingDetail = freezed,
  }) {
    return _then(_$LandedCostItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      landedCostShipmentId: null == landedCostShipmentId
          ? _value.landedCostShipmentId
          : landedCostShipmentId // ignore: cast_nullable_to_non_nullable
              as int,
      receivingDetailId: null == receivingDetailId
          ? _value.receivingDetailId
          : receivingDetailId // ignore: cast_nullable_to_non_nullable
              as int,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      itemPercentage: null == itemPercentage
          ? _value.itemPercentage
          : itemPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      allocatedAmount: null == allocatedAmount
          ? _value.allocatedAmount
          : allocatedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      receivingDetail: freezed == receivingDetail
          ? _value.receivingDetail
          : receivingDetail // ignore: cast_nullable_to_non_nullable
              as ReceivingDetailDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LandedCostItemImpl implements _LandedCostItem {
  const _$LandedCostItemImpl(
      {required this.id,
      @JsonKey(name: 'landed_cost_shipment_id')
      required this.landedCostShipmentId,
      @JsonKey(name: 'receiving_detail_id') required this.receivingDetailId,
      @JsonKey(name: 'is_selected') required this.isSelected,
      @JsonKey(name: 'item_percentage', fromJson: doubleFromJson)
      required this.itemPercentage,
      @JsonKey(name: 'allocated_amount', fromJson: doubleFromJson)
      required this.allocatedAmount,
      @JsonKey(name: 'receiving_detail') this.receivingDetail});

  factory _$LandedCostItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$LandedCostItemImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'landed_cost_shipment_id')
  final int landedCostShipmentId;
  @override
  @JsonKey(name: 'receiving_detail_id')
  final int receivingDetailId;
  @override
  @JsonKey(name: 'is_selected')
  final bool isSelected;
  @override
  @JsonKey(name: 'item_percentage', fromJson: doubleFromJson)
  final double itemPercentage;
  @override
  @JsonKey(name: 'allocated_amount', fromJson: doubleFromJson)
  final double allocatedAmount;
  @override
  @JsonKey(name: 'receiving_detail')
  final ReceivingDetailDto? receivingDetail;

  @override
  String toString() {
    return 'LandedCostItem(id: $id, landedCostShipmentId: $landedCostShipmentId, receivingDetailId: $receivingDetailId, isSelected: $isSelected, itemPercentage: $itemPercentage, allocatedAmount: $allocatedAmount, receivingDetail: $receivingDetail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LandedCostItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.landedCostShipmentId, landedCostShipmentId) ||
                other.landedCostShipmentId == landedCostShipmentId) &&
            (identical(other.receivingDetailId, receivingDetailId) ||
                other.receivingDetailId == receivingDetailId) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected) &&
            (identical(other.itemPercentage, itemPercentage) ||
                other.itemPercentage == itemPercentage) &&
            (identical(other.allocatedAmount, allocatedAmount) ||
                other.allocatedAmount == allocatedAmount) &&
            (identical(other.receivingDetail, receivingDetail) ||
                other.receivingDetail == receivingDetail));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      landedCostShipmentId,
      receivingDetailId,
      isSelected,
      itemPercentage,
      allocatedAmount,
      receivingDetail);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LandedCostItemImplCopyWith<_$LandedCostItemImpl> get copyWith =>
      __$$LandedCostItemImplCopyWithImpl<_$LandedCostItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LandedCostItemImplToJson(
      this,
    );
  }
}

abstract class _LandedCostItem implements LandedCostItem {
  const factory _LandedCostItem(
      {required final int id,
      @JsonKey(name: 'landed_cost_shipment_id')
      required final int landedCostShipmentId,
      @JsonKey(name: 'receiving_detail_id')
      required final int receivingDetailId,
      @JsonKey(name: 'is_selected') required final bool isSelected,
      @JsonKey(name: 'item_percentage', fromJson: doubleFromJson)
      required final double itemPercentage,
      @JsonKey(name: 'allocated_amount', fromJson: doubleFromJson)
      required final double allocatedAmount,
      @JsonKey(name: 'receiving_detail')
      final ReceivingDetailDto? receivingDetail}) = _$LandedCostItemImpl;

  factory _LandedCostItem.fromJson(Map<String, dynamic> json) =
      _$LandedCostItemImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'landed_cost_shipment_id')
  int get landedCostShipmentId;
  @override
  @JsonKey(name: 'receiving_detail_id')
  int get receivingDetailId;
  @override
  @JsonKey(name: 'is_selected')
  bool get isSelected;
  @override
  @JsonKey(name: 'item_percentage', fromJson: doubleFromJson)
  double get itemPercentage;
  @override
  @JsonKey(name: 'allocated_amount', fromJson: doubleFromJson)
  double get allocatedAmount;
  @override
  @JsonKey(name: 'receiving_detail')
  ReceivingDetailDto? get receivingDetail;
  @override
  @JsonKey(ignore: true)
  _$$LandedCostItemImplCopyWith<_$LandedCostItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReceivingDetailDto _$ReceivingDetailDtoFromJson(Map<String, dynamic> json) {
  return _ReceivingDetailDto.fromJson(json);
}

/// @nodoc
mixin _$ReceivingDetailDto {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'received_qty', fromJson: doubleFromJson)
  double get receivedQty => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  ProductDto? get product => throw _privateConstructorUsedError;
  @JsonKey(name: 'po_detail')
  PoDetailDto? get poDetail => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReceivingDetailDtoCopyWith<ReceivingDetailDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceivingDetailDtoCopyWith<$Res> {
  factory $ReceivingDetailDtoCopyWith(
          ReceivingDetailDto value, $Res Function(ReceivingDetailDto) then) =
      _$ReceivingDetailDtoCopyWithImpl<$Res, ReceivingDetailDto>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'received_qty', fromJson: doubleFromJson)
      double receivedQty,
      String unit,
      ProductDto? product,
      @JsonKey(name: 'po_detail') PoDetailDto? poDetail});

  $ProductDtoCopyWith<$Res>? get product;
  $PoDetailDtoCopyWith<$Res>? get poDetail;
}

/// @nodoc
class _$ReceivingDetailDtoCopyWithImpl<$Res, $Val extends ReceivingDetailDto>
    implements $ReceivingDetailDtoCopyWith<$Res> {
  _$ReceivingDetailDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? receivedQty = null,
    Object? unit = null,
    Object? product = freezed,
    Object? poDetail = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      receivedQty: null == receivedQty
          ? _value.receivedQty
          : receivedQty // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      product: freezed == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as ProductDto?,
      poDetail: freezed == poDetail
          ? _value.poDetail
          : poDetail // ignore: cast_nullable_to_non_nullable
              as PoDetailDto?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ProductDtoCopyWith<$Res>? get product {
    if (_value.product == null) {
      return null;
    }

    return $ProductDtoCopyWith<$Res>(_value.product!, (value) {
      return _then(_value.copyWith(product: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PoDetailDtoCopyWith<$Res>? get poDetail {
    if (_value.poDetail == null) {
      return null;
    }

    return $PoDetailDtoCopyWith<$Res>(_value.poDetail!, (value) {
      return _then(_value.copyWith(poDetail: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReceivingDetailDtoImplCopyWith<$Res>
    implements $ReceivingDetailDtoCopyWith<$Res> {
  factory _$$ReceivingDetailDtoImplCopyWith(_$ReceivingDetailDtoImpl value,
          $Res Function(_$ReceivingDetailDtoImpl) then) =
      __$$ReceivingDetailDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'received_qty', fromJson: doubleFromJson)
      double receivedQty,
      String unit,
      ProductDto? product,
      @JsonKey(name: 'po_detail') PoDetailDto? poDetail});

  @override
  $ProductDtoCopyWith<$Res>? get product;
  @override
  $PoDetailDtoCopyWith<$Res>? get poDetail;
}

/// @nodoc
class __$$ReceivingDetailDtoImplCopyWithImpl<$Res>
    extends _$ReceivingDetailDtoCopyWithImpl<$Res, _$ReceivingDetailDtoImpl>
    implements _$$ReceivingDetailDtoImplCopyWith<$Res> {
  __$$ReceivingDetailDtoImplCopyWithImpl(_$ReceivingDetailDtoImpl _value,
      $Res Function(_$ReceivingDetailDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? receivedQty = null,
    Object? unit = null,
    Object? product = freezed,
    Object? poDetail = freezed,
  }) {
    return _then(_$ReceivingDetailDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      receivedQty: null == receivedQty
          ? _value.receivedQty
          : receivedQty // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      product: freezed == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as ProductDto?,
      poDetail: freezed == poDetail
          ? _value.poDetail
          : poDetail // ignore: cast_nullable_to_non_nullable
              as PoDetailDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReceivingDetailDtoImpl implements _ReceivingDetailDto {
  const _$ReceivingDetailDtoImpl(
      {required this.id,
      @JsonKey(name: 'received_qty', fromJson: doubleFromJson)
      required this.receivedQty,
      required this.unit,
      this.product,
      @JsonKey(name: 'po_detail') this.poDetail});

  factory _$ReceivingDetailDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReceivingDetailDtoImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'received_qty', fromJson: doubleFromJson)
  final double receivedQty;
  @override
  final String unit;
  @override
  final ProductDto? product;
  @override
  @JsonKey(name: 'po_detail')
  final PoDetailDto? poDetail;

  @override
  String toString() {
    return 'ReceivingDetailDto(id: $id, receivedQty: $receivedQty, unit: $unit, product: $product, poDetail: $poDetail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceivingDetailDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.receivedQty, receivedQty) ||
                other.receivedQty == receivedQty) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.poDetail, poDetail) ||
                other.poDetail == poDetail));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, receivedQty, unit, product, poDetail);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceivingDetailDtoImplCopyWith<_$ReceivingDetailDtoImpl> get copyWith =>
      __$$ReceivingDetailDtoImplCopyWithImpl<_$ReceivingDetailDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReceivingDetailDtoImplToJson(
      this,
    );
  }
}

abstract class _ReceivingDetailDto implements ReceivingDetailDto {
  const factory _ReceivingDetailDto(
          {required final int id,
          @JsonKey(name: 'received_qty', fromJson: doubleFromJson)
          required final double receivedQty,
          required final String unit,
          final ProductDto? product,
          @JsonKey(name: 'po_detail') final PoDetailDto? poDetail}) =
      _$ReceivingDetailDtoImpl;

  factory _ReceivingDetailDto.fromJson(Map<String, dynamic> json) =
      _$ReceivingDetailDtoImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'received_qty', fromJson: doubleFromJson)
  double get receivedQty;
  @override
  String get unit;
  @override
  ProductDto? get product;
  @override
  @JsonKey(name: 'po_detail')
  PoDetailDto? get poDetail;
  @override
  @JsonKey(ignore: true)
  _$$ReceivingDetailDtoImplCopyWith<_$ReceivingDetailDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductDto _$ProductDtoFromJson(Map<String, dynamic> json) {
  return _ProductDto.fromJson(json);
}

/// @nodoc
mixin _$ProductDto {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get sku => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductDtoCopyWith<ProductDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductDtoCopyWith<$Res> {
  factory $ProductDtoCopyWith(
          ProductDto value, $Res Function(ProductDto) then) =
      _$ProductDtoCopyWithImpl<$Res, ProductDto>;
  @useResult
  $Res call({int id, String name, String sku});
}

/// @nodoc
class _$ProductDtoCopyWithImpl<$Res, $Val extends ProductDto>
    implements $ProductDtoCopyWith<$Res> {
  _$ProductDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? sku = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductDtoImplCopyWith<$Res>
    implements $ProductDtoCopyWith<$Res> {
  factory _$$ProductDtoImplCopyWith(
          _$ProductDtoImpl value, $Res Function(_$ProductDtoImpl) then) =
      __$$ProductDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String sku});
}

/// @nodoc
class __$$ProductDtoImplCopyWithImpl<$Res>
    extends _$ProductDtoCopyWithImpl<$Res, _$ProductDtoImpl>
    implements _$$ProductDtoImplCopyWith<$Res> {
  __$$ProductDtoImplCopyWithImpl(
      _$ProductDtoImpl _value, $Res Function(_$ProductDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? sku = null,
  }) {
    return _then(_$ProductDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductDtoImpl implements _ProductDto {
  const _$ProductDtoImpl(
      {required this.id, required this.name, required this.sku});

  factory _$ProductDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String sku;

  @override
  String toString() {
    return 'ProductDto(id: $id, name: $name, sku: $sku)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sku, sku) || other.sku == sku));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, sku);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductDtoImplCopyWith<_$ProductDtoImpl> get copyWith =>
      __$$ProductDtoImplCopyWithImpl<_$ProductDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductDtoImplToJson(
      this,
    );
  }
}

abstract class _ProductDto implements ProductDto {
  const factory _ProductDto(
      {required final int id,
      required final String name,
      required final String sku}) = _$ProductDtoImpl;

  factory _ProductDto.fromJson(Map<String, dynamic> json) =
      _$ProductDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get sku;
  @override
  @JsonKey(ignore: true)
  _$$ProductDtoImplCopyWith<_$ProductDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PoDetailDto _$PoDetailDtoFromJson(Map<String, dynamic> json) {
  return _PoDetailDto.fromJson(json);
}

/// @nodoc
mixin _$PoDetailDto {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price', fromJson: doubleFromJson)
  double get unitPrice => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PoDetailDtoCopyWith<PoDetailDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoDetailDtoCopyWith<$Res> {
  factory $PoDetailDtoCopyWith(
          PoDetailDto value, $Res Function(PoDetailDto) then) =
      _$PoDetailDtoCopyWithImpl<$Res, PoDetailDto>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'unit_price', fromJson: doubleFromJson) double unitPrice});
}

/// @nodoc
class _$PoDetailDtoCopyWithImpl<$Res, $Val extends PoDetailDto>
    implements $PoDetailDtoCopyWith<$Res> {
  _$PoDetailDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? unitPrice = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PoDetailDtoImplCopyWith<$Res>
    implements $PoDetailDtoCopyWith<$Res> {
  factory _$$PoDetailDtoImplCopyWith(
          _$PoDetailDtoImpl value, $Res Function(_$PoDetailDtoImpl) then) =
      __$$PoDetailDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'unit_price', fromJson: doubleFromJson) double unitPrice});
}

/// @nodoc
class __$$PoDetailDtoImplCopyWithImpl<$Res>
    extends _$PoDetailDtoCopyWithImpl<$Res, _$PoDetailDtoImpl>
    implements _$$PoDetailDtoImplCopyWith<$Res> {
  __$$PoDetailDtoImplCopyWithImpl(
      _$PoDetailDtoImpl _value, $Res Function(_$PoDetailDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? unitPrice = null,
  }) {
    return _then(_$PoDetailDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PoDetailDtoImpl implements _PoDetailDto {
  const _$PoDetailDtoImpl(
      {required this.id,
      @JsonKey(name: 'unit_price', fromJson: doubleFromJson)
      required this.unitPrice});

  factory _$PoDetailDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PoDetailDtoImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'unit_price', fromJson: doubleFromJson)
  final double unitPrice;

  @override
  String toString() {
    return 'PoDetailDto(id: $id, unitPrice: $unitPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoDetailDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, unitPrice);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PoDetailDtoImplCopyWith<_$PoDetailDtoImpl> get copyWith =>
      __$$PoDetailDtoImplCopyWithImpl<_$PoDetailDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PoDetailDtoImplToJson(
      this,
    );
  }
}

abstract class _PoDetailDto implements PoDetailDto {
  const factory _PoDetailDto(
      {required final int id,
      @JsonKey(name: 'unit_price', fromJson: doubleFromJson)
      required final double unitPrice}) = _$PoDetailDtoImpl;

  factory _PoDetailDto.fromJson(Map<String, dynamic> json) =
      _$PoDetailDtoImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'unit_price', fromJson: doubleFromJson)
  double get unitPrice;
  @override
  @JsonKey(ignore: true)
  _$$PoDetailDtoImplCopyWith<_$PoDetailDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserDto _$UserDtoFromJson(Map<String, dynamic> json) {
  return _UserDto.fromJson(json);
}

/// @nodoc
mixin _$UserDto {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserDtoCopyWith<UserDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDtoCopyWith<$Res> {
  factory $UserDtoCopyWith(UserDto value, $Res Function(UserDto) then) =
      _$UserDtoCopyWithImpl<$Res, UserDto>;
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class _$UserDtoCopyWithImpl<$Res, $Val extends UserDto>
    implements $UserDtoCopyWith<$Res> {
  _$UserDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserDtoImplCopyWith<$Res> implements $UserDtoCopyWith<$Res> {
  factory _$$UserDtoImplCopyWith(
          _$UserDtoImpl value, $Res Function(_$UserDtoImpl) then) =
      __$$UserDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class __$$UserDtoImplCopyWithImpl<$Res>
    extends _$UserDtoCopyWithImpl<$Res, _$UserDtoImpl>
    implements _$$UserDtoImplCopyWith<$Res> {
  __$$UserDtoImplCopyWithImpl(
      _$UserDtoImpl _value, $Res Function(_$UserDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$UserDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserDtoImpl implements _UserDto {
  const _$UserDtoImpl({required this.id, required this.name});

  factory _$UserDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;

  @override
  String toString() {
    return 'UserDto(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserDtoImplCopyWith<_$UserDtoImpl> get copyWith =>
      __$$UserDtoImplCopyWithImpl<_$UserDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserDtoImplToJson(
      this,
    );
  }
}

abstract class _UserDto implements UserDto {
  const factory _UserDto({required final int id, required final String name}) =
      _$UserDtoImpl;

  factory _UserDto.fromJson(Map<String, dynamic> json) = _$UserDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$UserDtoImplCopyWith<_$UserDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
