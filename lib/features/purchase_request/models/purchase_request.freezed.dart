// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PurchaseRequest _$PurchaseRequestFromJson(Map<String, dynamic> json) {
  return _PurchaseRequest.fromJson(json);
}

/// @nodoc
mixin _$PurchaseRequest {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  int? get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name')
  String? get companyName => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  @JsonKey(name: 'request_date')
  String get requestDate => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'request_by_name')
  String? get requestByName => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_approve')
  bool get canApprove => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_by')
  String? get approvedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_at')
  String? get approvedAt => throw _privateConstructorUsedError;
  List<PurchaseRequestItem> get details => throw _privateConstructorUsedError;
  List<PurchaseRequestComparison> get comparisons =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'purchase_orders')
  List<PRAssociatedPO> get purchaseOrders => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PurchaseRequestCopyWith<PurchaseRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseRequestCopyWith<$Res> {
  factory $PurchaseRequestCopyWith(
          PurchaseRequest value, $Res Function(PurchaseRequest) then) =
      _$PurchaseRequestCopyWithImpl<$Res, PurchaseRequest>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'company_id') int? companyId,
      @JsonKey(name: 'company_name') String? companyName,
      String code,
      @JsonKey(name: 'request_date') String requestDate,
      String? notes,
      @JsonKey(name: 'request_by_name') String? requestByName,
      String status,
      @JsonKey(name: 'can_approve') bool canApprove,
      @JsonKey(name: 'approved_by') String? approvedBy,
      @JsonKey(name: 'approved_at') String? approvedAt,
      List<PurchaseRequestItem> details,
      List<PurchaseRequestComparison> comparisons,
      @JsonKey(name: 'purchase_orders') List<PRAssociatedPO> purchaseOrders});
}

/// @nodoc
class _$PurchaseRequestCopyWithImpl<$Res, $Val extends PurchaseRequest>
    implements $PurchaseRequestCopyWith<$Res> {
  _$PurchaseRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = freezed,
    Object? companyName = freezed,
    Object? code = null,
    Object? requestDate = null,
    Object? notes = freezed,
    Object? requestByName = freezed,
    Object? status = null,
    Object? canApprove = null,
    Object? approvedBy = freezed,
    Object? approvedAt = freezed,
    Object? details = null,
    Object? comparisons = null,
    Object? purchaseOrders = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int?,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      requestByName: freezed == requestByName
          ? _value.requestByName
          : requestByName // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      canApprove: null == canApprove
          ? _value.canApprove
          : canApprove // ignore: cast_nullable_to_non_nullable
              as bool,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as List<PurchaseRequestItem>,
      comparisons: null == comparisons
          ? _value.comparisons
          : comparisons // ignore: cast_nullable_to_non_nullable
              as List<PurchaseRequestComparison>,
      purchaseOrders: null == purchaseOrders
          ? _value.purchaseOrders
          : purchaseOrders // ignore: cast_nullable_to_non_nullable
              as List<PRAssociatedPO>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PurchaseRequestImplCopyWith<$Res>
    implements $PurchaseRequestCopyWith<$Res> {
  factory _$$PurchaseRequestImplCopyWith(_$PurchaseRequestImpl value,
          $Res Function(_$PurchaseRequestImpl) then) =
      __$$PurchaseRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'company_id') int? companyId,
      @JsonKey(name: 'company_name') String? companyName,
      String code,
      @JsonKey(name: 'request_date') String requestDate,
      String? notes,
      @JsonKey(name: 'request_by_name') String? requestByName,
      String status,
      @JsonKey(name: 'can_approve') bool canApprove,
      @JsonKey(name: 'approved_by') String? approvedBy,
      @JsonKey(name: 'approved_at') String? approvedAt,
      List<PurchaseRequestItem> details,
      List<PurchaseRequestComparison> comparisons,
      @JsonKey(name: 'purchase_orders') List<PRAssociatedPO> purchaseOrders});
}

/// @nodoc
class __$$PurchaseRequestImplCopyWithImpl<$Res>
    extends _$PurchaseRequestCopyWithImpl<$Res, _$PurchaseRequestImpl>
    implements _$$PurchaseRequestImplCopyWith<$Res> {
  __$$PurchaseRequestImplCopyWithImpl(
      _$PurchaseRequestImpl _value, $Res Function(_$PurchaseRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = freezed,
    Object? companyName = freezed,
    Object? code = null,
    Object? requestDate = null,
    Object? notes = freezed,
    Object? requestByName = freezed,
    Object? status = null,
    Object? canApprove = null,
    Object? approvedBy = freezed,
    Object? approvedAt = freezed,
    Object? details = null,
    Object? comparisons = null,
    Object? purchaseOrders = null,
  }) {
    return _then(_$PurchaseRequestImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int?,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      requestByName: freezed == requestByName
          ? _value.requestByName
          : requestByName // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      canApprove: null == canApprove
          ? _value.canApprove
          : canApprove // ignore: cast_nullable_to_non_nullable
              as bool,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      details: null == details
          ? _value._details
          : details // ignore: cast_nullable_to_non_nullable
              as List<PurchaseRequestItem>,
      comparisons: null == comparisons
          ? _value._comparisons
          : comparisons // ignore: cast_nullable_to_non_nullable
              as List<PurchaseRequestComparison>,
      purchaseOrders: null == purchaseOrders
          ? _value._purchaseOrders
          : purchaseOrders // ignore: cast_nullable_to_non_nullable
              as List<PRAssociatedPO>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseRequestImpl implements _PurchaseRequest {
  const _$PurchaseRequestImpl(
      {required this.id,
      @JsonKey(name: 'company_id') this.companyId,
      @JsonKey(name: 'company_name') this.companyName,
      required this.code,
      @JsonKey(name: 'request_date') required this.requestDate,
      this.notes,
      @JsonKey(name: 'request_by_name') this.requestByName,
      required this.status,
      @JsonKey(name: 'can_approve') this.canApprove = false,
      @JsonKey(name: 'approved_by') this.approvedBy,
      @JsonKey(name: 'approved_at') this.approvedAt,
      final List<PurchaseRequestItem> details = const [],
      final List<PurchaseRequestComparison> comparisons = const [],
      @JsonKey(name: 'purchase_orders')
      final List<PRAssociatedPO> purchaseOrders = const []})
      : _details = details,
        _comparisons = comparisons,
        _purchaseOrders = purchaseOrders;

  factory _$PurchaseRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseRequestImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'company_id')
  final int? companyId;
  @override
  @JsonKey(name: 'company_name')
  final String? companyName;
  @override
  final String code;
  @override
  @JsonKey(name: 'request_date')
  final String requestDate;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'request_by_name')
  final String? requestByName;
  @override
  final String status;
  @override
  @JsonKey(name: 'can_approve')
  final bool canApprove;
  @override
  @JsonKey(name: 'approved_by')
  final String? approvedBy;
  @override
  @JsonKey(name: 'approved_at')
  final String? approvedAt;
  final List<PurchaseRequestItem> _details;
  @override
  @JsonKey()
  List<PurchaseRequestItem> get details {
    if (_details is EqualUnmodifiableListView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_details);
  }

  final List<PurchaseRequestComparison> _comparisons;
  @override
  @JsonKey()
  List<PurchaseRequestComparison> get comparisons {
    if (_comparisons is EqualUnmodifiableListView) return _comparisons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comparisons);
  }

  final List<PRAssociatedPO> _purchaseOrders;
  @override
  @JsonKey(name: 'purchase_orders')
  List<PRAssociatedPO> get purchaseOrders {
    if (_purchaseOrders is EqualUnmodifiableListView) return _purchaseOrders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_purchaseOrders);
  }

  @override
  String toString() {
    return 'PurchaseRequest(id: $id, companyId: $companyId, companyName: $companyName, code: $code, requestDate: $requestDate, notes: $notes, requestByName: $requestByName, status: $status, canApprove: $canApprove, approvedBy: $approvedBy, approvedAt: $approvedAt, details: $details, comparisons: $comparisons, purchaseOrders: $purchaseOrders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.requestDate, requestDate) ||
                other.requestDate == requestDate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.requestByName, requestByName) ||
                other.requestByName == requestByName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.canApprove, canApprove) ||
                other.canApprove == canApprove) &&
            (identical(other.approvedBy, approvedBy) ||
                other.approvedBy == approvedBy) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
            const DeepCollectionEquality().equals(other._details, _details) &&
            const DeepCollectionEquality()
                .equals(other._comparisons, _comparisons) &&
            const DeepCollectionEquality()
                .equals(other._purchaseOrders, _purchaseOrders));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      companyId,
      companyName,
      code,
      requestDate,
      notes,
      requestByName,
      status,
      canApprove,
      approvedBy,
      approvedAt,
      const DeepCollectionEquality().hash(_details),
      const DeepCollectionEquality().hash(_comparisons),
      const DeepCollectionEquality().hash(_purchaseOrders));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseRequestImplCopyWith<_$PurchaseRequestImpl> get copyWith =>
      __$$PurchaseRequestImplCopyWithImpl<_$PurchaseRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseRequestImplToJson(
      this,
    );
  }
}

abstract class _PurchaseRequest implements PurchaseRequest {
  const factory _PurchaseRequest(
      {required final int id,
      @JsonKey(name: 'company_id') final int? companyId,
      @JsonKey(name: 'company_name') final String? companyName,
      required final String code,
      @JsonKey(name: 'request_date') required final String requestDate,
      final String? notes,
      @JsonKey(name: 'request_by_name') final String? requestByName,
      required final String status,
      @JsonKey(name: 'can_approve') final bool canApprove,
      @JsonKey(name: 'approved_by') final String? approvedBy,
      @JsonKey(name: 'approved_at') final String? approvedAt,
      final List<PurchaseRequestItem> details,
      final List<PurchaseRequestComparison> comparisons,
      @JsonKey(name: 'purchase_orders')
      final List<PRAssociatedPO> purchaseOrders}) = _$PurchaseRequestImpl;

  factory _PurchaseRequest.fromJson(Map<String, dynamic> json) =
      _$PurchaseRequestImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'company_id')
  int? get companyId;
  @override
  @JsonKey(name: 'company_name')
  String? get companyName;
  @override
  String get code;
  @override
  @JsonKey(name: 'request_date')
  String get requestDate;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'request_by_name')
  String? get requestByName;
  @override
  String get status;
  @override
  @JsonKey(name: 'can_approve')
  bool get canApprove;
  @override
  @JsonKey(name: 'approved_by')
  String? get approvedBy;
  @override
  @JsonKey(name: 'approved_at')
  String? get approvedAt;
  @override
  List<PurchaseRequestItem> get details;
  @override
  List<PurchaseRequestComparison> get comparisons;
  @override
  @JsonKey(name: 'purchase_orders')
  List<PRAssociatedPO> get purchaseOrders;
  @override
  @JsonKey(ignore: true)
  _$$PurchaseRequestImplCopyWith<_$PurchaseRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PurchaseRequestComparison _$PurchaseRequestComparisonFromJson(
    Map<String, dynamic> json) {
  return _PurchaseRequestComparison.fromJson(json);
}

/// @nodoc
mixin _$PurchaseRequestComparison {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_id')
  int get supplierId => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_name')
  String get supplierName => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
  double get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'lead_time_days')
  int get leadTimeDays => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<ComparisonDetail> get details => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PurchaseRequestComparisonCopyWith<PurchaseRequestComparison> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseRequestComparisonCopyWith<$Res> {
  factory $PurchaseRequestComparisonCopyWith(PurchaseRequestComparison value,
          $Res Function(PurchaseRequestComparison) then) =
      _$PurchaseRequestComparisonCopyWithImpl<$Res, PurchaseRequestComparison>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'supplier_id') int supplierId,
      @JsonKey(name: 'supplier_name') String supplierName,
      @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
      double totalAmount,
      @JsonKey(name: 'lead_time_days') int leadTimeDays,
      String? status,
      String? notes,
      List<ComparisonDetail> details});
}

/// @nodoc
class _$PurchaseRequestComparisonCopyWithImpl<$Res,
        $Val extends PurchaseRequestComparison>
    implements $PurchaseRequestComparisonCopyWith<$Res> {
  _$PurchaseRequestComparisonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? supplierId = null,
    Object? supplierName = null,
    Object? totalAmount = null,
    Object? leadTimeDays = null,
    Object? status = freezed,
    Object? notes = freezed,
    Object? details = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      supplierId: null == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int,
      supplierName: null == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      leadTimeDays: null == leadTimeDays
          ? _value.leadTimeDays
          : leadTimeDays // ignore: cast_nullable_to_non_nullable
              as int,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as List<ComparisonDetail>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PurchaseRequestComparisonImplCopyWith<$Res>
    implements $PurchaseRequestComparisonCopyWith<$Res> {
  factory _$$PurchaseRequestComparisonImplCopyWith(
          _$PurchaseRequestComparisonImpl value,
          $Res Function(_$PurchaseRequestComparisonImpl) then) =
      __$$PurchaseRequestComparisonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'supplier_id') int supplierId,
      @JsonKey(name: 'supplier_name') String supplierName,
      @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
      double totalAmount,
      @JsonKey(name: 'lead_time_days') int leadTimeDays,
      String? status,
      String? notes,
      List<ComparisonDetail> details});
}

/// @nodoc
class __$$PurchaseRequestComparisonImplCopyWithImpl<$Res>
    extends _$PurchaseRequestComparisonCopyWithImpl<$Res,
        _$PurchaseRequestComparisonImpl>
    implements _$$PurchaseRequestComparisonImplCopyWith<$Res> {
  __$$PurchaseRequestComparisonImplCopyWithImpl(
      _$PurchaseRequestComparisonImpl _value,
      $Res Function(_$PurchaseRequestComparisonImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? supplierId = null,
    Object? supplierName = null,
    Object? totalAmount = null,
    Object? leadTimeDays = null,
    Object? status = freezed,
    Object? notes = freezed,
    Object? details = null,
  }) {
    return _then(_$PurchaseRequestComparisonImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      supplierId: null == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int,
      supplierName: null == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      leadTimeDays: null == leadTimeDays
          ? _value.leadTimeDays
          : leadTimeDays // ignore: cast_nullable_to_non_nullable
              as int,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      details: null == details
          ? _value._details
          : details // ignore: cast_nullable_to_non_nullable
              as List<ComparisonDetail>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseRequestComparisonImpl implements _PurchaseRequestComparison {
  const _$PurchaseRequestComparisonImpl(
      {required this.id,
      @JsonKey(name: 'supplier_id') required this.supplierId,
      @JsonKey(name: 'supplier_name') required this.supplierName,
      @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
      required this.totalAmount,
      @JsonKey(name: 'lead_time_days') required this.leadTimeDays,
      this.status,
      this.notes,
      final List<ComparisonDetail> details = const []})
      : _details = details;

  factory _$PurchaseRequestComparisonImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseRequestComparisonImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'supplier_id')
  final int supplierId;
  @override
  @JsonKey(name: 'supplier_name')
  final String supplierName;
  @override
  @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
  final double totalAmount;
  @override
  @JsonKey(name: 'lead_time_days')
  final int leadTimeDays;
  @override
  final String? status;
  @override
  final String? notes;
  final List<ComparisonDetail> _details;
  @override
  @JsonKey()
  List<ComparisonDetail> get details {
    if (_details is EqualUnmodifiableListView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_details);
  }

  @override
  String toString() {
    return 'PurchaseRequestComparison(id: $id, supplierId: $supplierId, supplierName: $supplierName, totalAmount: $totalAmount, leadTimeDays: $leadTimeDays, status: $status, notes: $notes, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseRequestComparisonImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.leadTimeDays, leadTimeDays) ||
                other.leadTimeDays == leadTimeDays) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._details, _details));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      supplierId,
      supplierName,
      totalAmount,
      leadTimeDays,
      status,
      notes,
      const DeepCollectionEquality().hash(_details));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseRequestComparisonImplCopyWith<_$PurchaseRequestComparisonImpl>
      get copyWith => __$$PurchaseRequestComparisonImplCopyWithImpl<
          _$PurchaseRequestComparisonImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseRequestComparisonImplToJson(
      this,
    );
  }
}

abstract class _PurchaseRequestComparison implements PurchaseRequestComparison {
  const factory _PurchaseRequestComparison(
      {required final int id,
      @JsonKey(name: 'supplier_id') required final int supplierId,
      @JsonKey(name: 'supplier_name') required final String supplierName,
      @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
      required final double totalAmount,
      @JsonKey(name: 'lead_time_days') required final int leadTimeDays,
      final String? status,
      final String? notes,
      final List<ComparisonDetail> details}) = _$PurchaseRequestComparisonImpl;

  factory _PurchaseRequestComparison.fromJson(Map<String, dynamic> json) =
      _$PurchaseRequestComparisonImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'supplier_id')
  int get supplierId;
  @override
  @JsonKey(name: 'supplier_name')
  String get supplierName;
  @override
  @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
  double get totalAmount;
  @override
  @JsonKey(name: 'lead_time_days')
  int get leadTimeDays;
  @override
  String? get status;
  @override
  String? get notes;
  @override
  List<ComparisonDetail> get details;
  @override
  @JsonKey(ignore: true)
  _$$PurchaseRequestComparisonImplCopyWith<_$PurchaseRequestComparisonImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ComparisonDetail _$ComparisonDetailFromJson(Map<String, dynamic> json) {
  return _ComparisonDetail.fromJson(json);
}

/// @nodoc
mixin _$ComparisonDetail {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'purchase_request_detail_id')
  int get purchaseRequestDetailId => throw _privateConstructorUsedError;
  @JsonKey(name: 'offered_unit_price', fromJson: doubleFromJson)
  double get offeredUnitPrice => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ComparisonDetailCopyWith<ComparisonDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ComparisonDetailCopyWith<$Res> {
  factory $ComparisonDetailCopyWith(
          ComparisonDetail value, $Res Function(ComparisonDetail) then) =
      _$ComparisonDetailCopyWithImpl<$Res, ComparisonDetail>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'purchase_request_detail_id') int purchaseRequestDetailId,
      @JsonKey(name: 'offered_unit_price', fromJson: doubleFromJson)
      double offeredUnitPrice});
}

/// @nodoc
class _$ComparisonDetailCopyWithImpl<$Res, $Val extends ComparisonDetail>
    implements $ComparisonDetailCopyWith<$Res> {
  _$ComparisonDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? purchaseRequestDetailId = null,
    Object? offeredUnitPrice = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      purchaseRequestDetailId: null == purchaseRequestDetailId
          ? _value.purchaseRequestDetailId
          : purchaseRequestDetailId // ignore: cast_nullable_to_non_nullable
              as int,
      offeredUnitPrice: null == offeredUnitPrice
          ? _value.offeredUnitPrice
          : offeredUnitPrice // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ComparisonDetailImplCopyWith<$Res>
    implements $ComparisonDetailCopyWith<$Res> {
  factory _$$ComparisonDetailImplCopyWith(_$ComparisonDetailImpl value,
          $Res Function(_$ComparisonDetailImpl) then) =
      __$$ComparisonDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'purchase_request_detail_id') int purchaseRequestDetailId,
      @JsonKey(name: 'offered_unit_price', fromJson: doubleFromJson)
      double offeredUnitPrice});
}

/// @nodoc
class __$$ComparisonDetailImplCopyWithImpl<$Res>
    extends _$ComparisonDetailCopyWithImpl<$Res, _$ComparisonDetailImpl>
    implements _$$ComparisonDetailImplCopyWith<$Res> {
  __$$ComparisonDetailImplCopyWithImpl(_$ComparisonDetailImpl _value,
      $Res Function(_$ComparisonDetailImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? purchaseRequestDetailId = null,
    Object? offeredUnitPrice = null,
  }) {
    return _then(_$ComparisonDetailImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      purchaseRequestDetailId: null == purchaseRequestDetailId
          ? _value.purchaseRequestDetailId
          : purchaseRequestDetailId // ignore: cast_nullable_to_non_nullable
              as int,
      offeredUnitPrice: null == offeredUnitPrice
          ? _value.offeredUnitPrice
          : offeredUnitPrice // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ComparisonDetailImpl implements _ComparisonDetail {
  const _$ComparisonDetailImpl(
      {required this.id,
      @JsonKey(name: 'purchase_request_detail_id')
      required this.purchaseRequestDetailId,
      @JsonKey(name: 'offered_unit_price', fromJson: doubleFromJson)
      required this.offeredUnitPrice});

  factory _$ComparisonDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$ComparisonDetailImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'purchase_request_detail_id')
  final int purchaseRequestDetailId;
  @override
  @JsonKey(name: 'offered_unit_price', fromJson: doubleFromJson)
  final double offeredUnitPrice;

  @override
  String toString() {
    return 'ComparisonDetail(id: $id, purchaseRequestDetailId: $purchaseRequestDetailId, offeredUnitPrice: $offeredUnitPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ComparisonDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(
                    other.purchaseRequestDetailId, purchaseRequestDetailId) ||
                other.purchaseRequestDetailId == purchaseRequestDetailId) &&
            (identical(other.offeredUnitPrice, offeredUnitPrice) ||
                other.offeredUnitPrice == offeredUnitPrice));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, purchaseRequestDetailId, offeredUnitPrice);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ComparisonDetailImplCopyWith<_$ComparisonDetailImpl> get copyWith =>
      __$$ComparisonDetailImplCopyWithImpl<_$ComparisonDetailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ComparisonDetailImplToJson(
      this,
    );
  }
}

abstract class _ComparisonDetail implements ComparisonDetail {
  const factory _ComparisonDetail(
      {required final int id,
      @JsonKey(name: 'purchase_request_detail_id')
      required final int purchaseRequestDetailId,
      @JsonKey(name: 'offered_unit_price', fromJson: doubleFromJson)
      required final double offeredUnitPrice}) = _$ComparisonDetailImpl;

  factory _ComparisonDetail.fromJson(Map<String, dynamic> json) =
      _$ComparisonDetailImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'purchase_request_detail_id')
  int get purchaseRequestDetailId;
  @override
  @JsonKey(name: 'offered_unit_price', fromJson: doubleFromJson)
  double get offeredUnitPrice;
  @override
  @JsonKey(ignore: true)
  _$$ComparisonDetailImplCopyWith<_$ComparisonDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PurchaseRequestItem _$PurchaseRequestItemFromJson(Map<String, dynamic> json) {
  return _PurchaseRequestItem.fromJson(json);
}

/// @nodoc
mixin _$PurchaseRequestItem {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_name')
  String get itemName => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_code')
  String get itemCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'qty_requested', fromJson: doubleFromJson)
  double get qtyRequested => throw _privateConstructorUsedError;
  @JsonKey(name: 'uom_order')
  String get uom => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_stock', fromJson: doubleFromJson)
  double get currentStock => throw _privateConstructorUsedError;
  @JsonKey(name: 'dt_notes')
  String? get dtNotes => throw _privateConstructorUsedError;
  @JsonKey(name: 'dt_spec')
  String? get dtSpec => throw _privateConstructorUsedError;
  @JsonKey(name: 'cost_code')
  String? get costCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_approve')
  bool get canApprove => throw _privateConstructorUsedError;
  @JsonKey(name: 'pr_code')
  String? get prCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name')
  String? get companyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'pr_id')
  int? get prId => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_qty', fromJson: doubleFromJson)
  double? get approvedQty => throw _privateConstructorUsedError;
  @JsonKey(name: 'selected_comparison_id')
  int? get selectedComparisonId => throw _privateConstructorUsedError;
  @JsonKey(name: 'warehouse_code')
  String? get warehouseCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'warehouse_name')
  String? get warehouseName => throw _privateConstructorUsedError;
  @JsonKey(name: 'po_number')
  String? get poNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PurchaseRequestItemCopyWith<PurchaseRequestItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseRequestItemCopyWith<$Res> {
  factory $PurchaseRequestItemCopyWith(
          PurchaseRequestItem value, $Res Function(PurchaseRequestItem) then) =
      _$PurchaseRequestItemCopyWithImpl<$Res, PurchaseRequestItem>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'item_name') String itemName,
      @JsonKey(name: 'item_code') String itemCode,
      @JsonKey(name: 'qty_requested', fromJson: doubleFromJson)
      double qtyRequested,
      @JsonKey(name: 'uom_order') String uom,
      String? status,
      @JsonKey(name: 'current_stock', fromJson: doubleFromJson)
      double currentStock,
      @JsonKey(name: 'dt_notes') String? dtNotes,
      @JsonKey(name: 'dt_spec') String? dtSpec,
      @JsonKey(name: 'cost_code') String? costCode,
      @JsonKey(name: 'can_approve') bool canApprove,
      @JsonKey(name: 'pr_code') String? prCode,
      @JsonKey(name: 'company_name') String? companyName,
      @JsonKey(name: 'pr_id') int? prId,
      @JsonKey(name: 'approved_qty', fromJson: doubleFromJson)
      double? approvedQty,
      @JsonKey(name: 'selected_comparison_id') int? selectedComparisonId,
      @JsonKey(name: 'warehouse_code') String? warehouseCode,
      @JsonKey(name: 'warehouse_name') String? warehouseName,
      @JsonKey(name: 'po_number') String? poNumber});
}

/// @nodoc
class _$PurchaseRequestItemCopyWithImpl<$Res, $Val extends PurchaseRequestItem>
    implements $PurchaseRequestItemCopyWith<$Res> {
  _$PurchaseRequestItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemName = null,
    Object? itemCode = null,
    Object? qtyRequested = null,
    Object? uom = null,
    Object? status = freezed,
    Object? currentStock = null,
    Object? dtNotes = freezed,
    Object? dtSpec = freezed,
    Object? costCode = freezed,
    Object? canApprove = null,
    Object? prCode = freezed,
    Object? companyName = freezed,
    Object? prId = freezed,
    Object? approvedQty = freezed,
    Object? selectedComparisonId = freezed,
    Object? warehouseCode = freezed,
    Object? warehouseName = freezed,
    Object? poNumber = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      itemCode: null == itemCode
          ? _value.itemCode
          : itemCode // ignore: cast_nullable_to_non_nullable
              as String,
      qtyRequested: null == qtyRequested
          ? _value.qtyRequested
          : qtyRequested // ignore: cast_nullable_to_non_nullable
              as double,
      uom: null == uom
          ? _value.uom
          : uom // ignore: cast_nullable_to_non_nullable
              as String,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      currentStock: null == currentStock
          ? _value.currentStock
          : currentStock // ignore: cast_nullable_to_non_nullable
              as double,
      dtNotes: freezed == dtNotes
          ? _value.dtNotes
          : dtNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      dtSpec: freezed == dtSpec
          ? _value.dtSpec
          : dtSpec // ignore: cast_nullable_to_non_nullable
              as String?,
      costCode: freezed == costCode
          ? _value.costCode
          : costCode // ignore: cast_nullable_to_non_nullable
              as String?,
      canApprove: null == canApprove
          ? _value.canApprove
          : canApprove // ignore: cast_nullable_to_non_nullable
              as bool,
      prCode: freezed == prCode
          ? _value.prCode
          : prCode // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      prId: freezed == prId
          ? _value.prId
          : prId // ignore: cast_nullable_to_non_nullable
              as int?,
      approvedQty: freezed == approvedQty
          ? _value.approvedQty
          : approvedQty // ignore: cast_nullable_to_non_nullable
              as double?,
      selectedComparisonId: freezed == selectedComparisonId
          ? _value.selectedComparisonId
          : selectedComparisonId // ignore: cast_nullable_to_non_nullable
              as int?,
      warehouseCode: freezed == warehouseCode
          ? _value.warehouseCode
          : warehouseCode // ignore: cast_nullable_to_non_nullable
              as String?,
      warehouseName: freezed == warehouseName
          ? _value.warehouseName
          : warehouseName // ignore: cast_nullable_to_non_nullable
              as String?,
      poNumber: freezed == poNumber
          ? _value.poNumber
          : poNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PurchaseRequestItemImplCopyWith<$Res>
    implements $PurchaseRequestItemCopyWith<$Res> {
  factory _$$PurchaseRequestItemImplCopyWith(_$PurchaseRequestItemImpl value,
          $Res Function(_$PurchaseRequestItemImpl) then) =
      __$$PurchaseRequestItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'item_name') String itemName,
      @JsonKey(name: 'item_code') String itemCode,
      @JsonKey(name: 'qty_requested', fromJson: doubleFromJson)
      double qtyRequested,
      @JsonKey(name: 'uom_order') String uom,
      String? status,
      @JsonKey(name: 'current_stock', fromJson: doubleFromJson)
      double currentStock,
      @JsonKey(name: 'dt_notes') String? dtNotes,
      @JsonKey(name: 'dt_spec') String? dtSpec,
      @JsonKey(name: 'cost_code') String? costCode,
      @JsonKey(name: 'can_approve') bool canApprove,
      @JsonKey(name: 'pr_code') String? prCode,
      @JsonKey(name: 'company_name') String? companyName,
      @JsonKey(name: 'pr_id') int? prId,
      @JsonKey(name: 'approved_qty', fromJson: doubleFromJson)
      double? approvedQty,
      @JsonKey(name: 'selected_comparison_id') int? selectedComparisonId,
      @JsonKey(name: 'warehouse_code') String? warehouseCode,
      @JsonKey(name: 'warehouse_name') String? warehouseName,
      @JsonKey(name: 'po_number') String? poNumber});
}

/// @nodoc
class __$$PurchaseRequestItemImplCopyWithImpl<$Res>
    extends _$PurchaseRequestItemCopyWithImpl<$Res, _$PurchaseRequestItemImpl>
    implements _$$PurchaseRequestItemImplCopyWith<$Res> {
  __$$PurchaseRequestItemImplCopyWithImpl(_$PurchaseRequestItemImpl _value,
      $Res Function(_$PurchaseRequestItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemName = null,
    Object? itemCode = null,
    Object? qtyRequested = null,
    Object? uom = null,
    Object? status = freezed,
    Object? currentStock = null,
    Object? dtNotes = freezed,
    Object? dtSpec = freezed,
    Object? costCode = freezed,
    Object? canApprove = null,
    Object? prCode = freezed,
    Object? companyName = freezed,
    Object? prId = freezed,
    Object? approvedQty = freezed,
    Object? selectedComparisonId = freezed,
    Object? warehouseCode = freezed,
    Object? warehouseName = freezed,
    Object? poNumber = freezed,
  }) {
    return _then(_$PurchaseRequestItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      itemName: null == itemName
          ? _value.itemName
          : itemName // ignore: cast_nullable_to_non_nullable
              as String,
      itemCode: null == itemCode
          ? _value.itemCode
          : itemCode // ignore: cast_nullable_to_non_nullable
              as String,
      qtyRequested: null == qtyRequested
          ? _value.qtyRequested
          : qtyRequested // ignore: cast_nullable_to_non_nullable
              as double,
      uom: null == uom
          ? _value.uom
          : uom // ignore: cast_nullable_to_non_nullable
              as String,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      currentStock: null == currentStock
          ? _value.currentStock
          : currentStock // ignore: cast_nullable_to_non_nullable
              as double,
      dtNotes: freezed == dtNotes
          ? _value.dtNotes
          : dtNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      dtSpec: freezed == dtSpec
          ? _value.dtSpec
          : dtSpec // ignore: cast_nullable_to_non_nullable
              as String?,
      costCode: freezed == costCode
          ? _value.costCode
          : costCode // ignore: cast_nullable_to_non_nullable
              as String?,
      canApprove: null == canApprove
          ? _value.canApprove
          : canApprove // ignore: cast_nullable_to_non_nullable
              as bool,
      prCode: freezed == prCode
          ? _value.prCode
          : prCode // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      prId: freezed == prId
          ? _value.prId
          : prId // ignore: cast_nullable_to_non_nullable
              as int?,
      approvedQty: freezed == approvedQty
          ? _value.approvedQty
          : approvedQty // ignore: cast_nullable_to_non_nullable
              as double?,
      selectedComparisonId: freezed == selectedComparisonId
          ? _value.selectedComparisonId
          : selectedComparisonId // ignore: cast_nullable_to_non_nullable
              as int?,
      warehouseCode: freezed == warehouseCode
          ? _value.warehouseCode
          : warehouseCode // ignore: cast_nullable_to_non_nullable
              as String?,
      warehouseName: freezed == warehouseName
          ? _value.warehouseName
          : warehouseName // ignore: cast_nullable_to_non_nullable
              as String?,
      poNumber: freezed == poNumber
          ? _value.poNumber
          : poNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseRequestItemImpl implements _PurchaseRequestItem {
  const _$PurchaseRequestItemImpl(
      {required this.id,
      @JsonKey(name: 'item_name') required this.itemName,
      @JsonKey(name: 'item_code') required this.itemCode,
      @JsonKey(name: 'qty_requested', fromJson: doubleFromJson)
      required this.qtyRequested,
      @JsonKey(name: 'uom_order') required this.uom,
      this.status,
      @JsonKey(name: 'current_stock', fromJson: doubleFromJson)
      this.currentStock = 0.0,
      @JsonKey(name: 'dt_notes') this.dtNotes,
      @JsonKey(name: 'dt_spec') this.dtSpec,
      @JsonKey(name: 'cost_code') this.costCode,
      @JsonKey(name: 'can_approve') this.canApprove = false,
      @JsonKey(name: 'pr_code') this.prCode,
      @JsonKey(name: 'company_name') this.companyName,
      @JsonKey(name: 'pr_id') this.prId,
      @JsonKey(name: 'approved_qty', fromJson: doubleFromJson) this.approvedQty,
      @JsonKey(name: 'selected_comparison_id') this.selectedComparisonId,
      @JsonKey(name: 'warehouse_code') this.warehouseCode,
      @JsonKey(name: 'warehouse_name') this.warehouseName,
      @JsonKey(name: 'po_number') this.poNumber});

  factory _$PurchaseRequestItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseRequestItemImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'item_name')
  final String itemName;
  @override
  @JsonKey(name: 'item_code')
  final String itemCode;
  @override
  @JsonKey(name: 'qty_requested', fromJson: doubleFromJson)
  final double qtyRequested;
  @override
  @JsonKey(name: 'uom_order')
  final String uom;
  @override
  final String? status;
  @override
  @JsonKey(name: 'current_stock', fromJson: doubleFromJson)
  final double currentStock;
  @override
  @JsonKey(name: 'dt_notes')
  final String? dtNotes;
  @override
  @JsonKey(name: 'dt_spec')
  final String? dtSpec;
  @override
  @JsonKey(name: 'cost_code')
  final String? costCode;
  @override
  @JsonKey(name: 'can_approve')
  final bool canApprove;
  @override
  @JsonKey(name: 'pr_code')
  final String? prCode;
  @override
  @JsonKey(name: 'company_name')
  final String? companyName;
  @override
  @JsonKey(name: 'pr_id')
  final int? prId;
  @override
  @JsonKey(name: 'approved_qty', fromJson: doubleFromJson)
  final double? approvedQty;
  @override
  @JsonKey(name: 'selected_comparison_id')
  final int? selectedComparisonId;
  @override
  @JsonKey(name: 'warehouse_code')
  final String? warehouseCode;
  @override
  @JsonKey(name: 'warehouse_name')
  final String? warehouseName;
  @override
  @JsonKey(name: 'po_number')
  final String? poNumber;

  @override
  String toString() {
    return 'PurchaseRequestItem(id: $id, itemName: $itemName, itemCode: $itemCode, qtyRequested: $qtyRequested, uom: $uom, status: $status, currentStock: $currentStock, dtNotes: $dtNotes, dtSpec: $dtSpec, costCode: $costCode, canApprove: $canApprove, prCode: $prCode, companyName: $companyName, prId: $prId, approvedQty: $approvedQty, selectedComparisonId: $selectedComparisonId, warehouseCode: $warehouseCode, warehouseName: $warehouseName, poNumber: $poNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseRequestItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.itemCode, itemCode) ||
                other.itemCode == itemCode) &&
            (identical(other.qtyRequested, qtyRequested) ||
                other.qtyRequested == qtyRequested) &&
            (identical(other.uom, uom) || other.uom == uom) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.currentStock, currentStock) ||
                other.currentStock == currentStock) &&
            (identical(other.dtNotes, dtNotes) || other.dtNotes == dtNotes) &&
            (identical(other.dtSpec, dtSpec) || other.dtSpec == dtSpec) &&
            (identical(other.costCode, costCode) ||
                other.costCode == costCode) &&
            (identical(other.canApprove, canApprove) ||
                other.canApprove == canApprove) &&
            (identical(other.prCode, prCode) || other.prCode == prCode) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.prId, prId) || other.prId == prId) &&
            (identical(other.approvedQty, approvedQty) ||
                other.approvedQty == approvedQty) &&
            (identical(other.selectedComparisonId, selectedComparisonId) ||
                other.selectedComparisonId == selectedComparisonId) &&
            (identical(other.warehouseCode, warehouseCode) ||
                other.warehouseCode == warehouseCode) &&
            (identical(other.warehouseName, warehouseName) ||
                other.warehouseName == warehouseName) &&
            (identical(other.poNumber, poNumber) ||
                other.poNumber == poNumber));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        itemName,
        itemCode,
        qtyRequested,
        uom,
        status,
        currentStock,
        dtNotes,
        dtSpec,
        costCode,
        canApprove,
        prCode,
        companyName,
        prId,
        approvedQty,
        selectedComparisonId,
        warehouseCode,
        warehouseName,
        poNumber
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseRequestItemImplCopyWith<_$PurchaseRequestItemImpl> get copyWith =>
      __$$PurchaseRequestItemImplCopyWithImpl<_$PurchaseRequestItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseRequestItemImplToJson(
      this,
    );
  }
}

abstract class _PurchaseRequestItem implements PurchaseRequestItem {
  const factory _PurchaseRequestItem(
      {required final int id,
      @JsonKey(name: 'item_name') required final String itemName,
      @JsonKey(name: 'item_code') required final String itemCode,
      @JsonKey(name: 'qty_requested', fromJson: doubleFromJson)
      required final double qtyRequested,
      @JsonKey(name: 'uom_order') required final String uom,
      final String? status,
      @JsonKey(name: 'current_stock', fromJson: doubleFromJson)
      final double currentStock,
      @JsonKey(name: 'dt_notes') final String? dtNotes,
      @JsonKey(name: 'dt_spec') final String? dtSpec,
      @JsonKey(name: 'cost_code') final String? costCode,
      @JsonKey(name: 'can_approve') final bool canApprove,
      @JsonKey(name: 'pr_code') final String? prCode,
      @JsonKey(name: 'company_name') final String? companyName,
      @JsonKey(name: 'pr_id') final int? prId,
      @JsonKey(name: 'approved_qty', fromJson: doubleFromJson)
      final double? approvedQty,
      @JsonKey(name: 'selected_comparison_id') final int? selectedComparisonId,
      @JsonKey(name: 'warehouse_code') final String? warehouseCode,
      @JsonKey(name: 'warehouse_name') final String? warehouseName,
      @JsonKey(name: 'po_number')
      final String? poNumber}) = _$PurchaseRequestItemImpl;

  factory _PurchaseRequestItem.fromJson(Map<String, dynamic> json) =
      _$PurchaseRequestItemImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'item_name')
  String get itemName;
  @override
  @JsonKey(name: 'item_code')
  String get itemCode;
  @override
  @JsonKey(name: 'qty_requested', fromJson: doubleFromJson)
  double get qtyRequested;
  @override
  @JsonKey(name: 'uom_order')
  String get uom;
  @override
  String? get status;
  @override
  @JsonKey(name: 'current_stock', fromJson: doubleFromJson)
  double get currentStock;
  @override
  @JsonKey(name: 'dt_notes')
  String? get dtNotes;
  @override
  @JsonKey(name: 'dt_spec')
  String? get dtSpec;
  @override
  @JsonKey(name: 'cost_code')
  String? get costCode;
  @override
  @JsonKey(name: 'can_approve')
  bool get canApprove;
  @override
  @JsonKey(name: 'pr_code')
  String? get prCode;
  @override
  @JsonKey(name: 'company_name')
  String? get companyName;
  @override
  @JsonKey(name: 'pr_id')
  int? get prId;
  @override
  @JsonKey(name: 'approved_qty', fromJson: doubleFromJson)
  double? get approvedQty;
  @override
  @JsonKey(name: 'selected_comparison_id')
  int? get selectedComparisonId;
  @override
  @JsonKey(name: 'warehouse_code')
  String? get warehouseCode;
  @override
  @JsonKey(name: 'warehouse_name')
  String? get warehouseName;
  @override
  @JsonKey(name: 'po_number')
  String? get poNumber;
  @override
  @JsonKey(ignore: true)
  _$$PurchaseRequestItemImplCopyWith<_$PurchaseRequestItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PRAssociatedPO _$PRAssociatedPOFromJson(Map<String, dynamic> json) {
  return _PRAssociatedPO.fromJson(json);
}

/// @nodoc
mixin _$PRAssociatedPO {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'po_number')
  String get poNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_name')
  String get supplierName => throw _privateConstructorUsedError;
  @JsonKey(name: 'pdf_url')
  String? get pdfUrl => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PRAssociatedPOCopyWith<PRAssociatedPO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PRAssociatedPOCopyWith<$Res> {
  factory $PRAssociatedPOCopyWith(
          PRAssociatedPO value, $Res Function(PRAssociatedPO) then) =
      _$PRAssociatedPOCopyWithImpl<$Res, PRAssociatedPO>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'po_number') String poNumber,
      @JsonKey(name: 'supplier_name') String supplierName,
      @JsonKey(name: 'pdf_url') String? pdfUrl,
      String status});
}

/// @nodoc
class _$PRAssociatedPOCopyWithImpl<$Res, $Val extends PRAssociatedPO>
    implements $PRAssociatedPOCopyWith<$Res> {
  _$PRAssociatedPOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? poNumber = null,
    Object? supplierName = null,
    Object? pdfUrl = freezed,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      poNumber: null == poNumber
          ? _value.poNumber
          : poNumber // ignore: cast_nullable_to_non_nullable
              as String,
      supplierName: null == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String,
      pdfUrl: freezed == pdfUrl
          ? _value.pdfUrl
          : pdfUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PRAssociatedPOImplCopyWith<$Res>
    implements $PRAssociatedPOCopyWith<$Res> {
  factory _$$PRAssociatedPOImplCopyWith(_$PRAssociatedPOImpl value,
          $Res Function(_$PRAssociatedPOImpl) then) =
      __$$PRAssociatedPOImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'po_number') String poNumber,
      @JsonKey(name: 'supplier_name') String supplierName,
      @JsonKey(name: 'pdf_url') String? pdfUrl,
      String status});
}

/// @nodoc
class __$$PRAssociatedPOImplCopyWithImpl<$Res>
    extends _$PRAssociatedPOCopyWithImpl<$Res, _$PRAssociatedPOImpl>
    implements _$$PRAssociatedPOImplCopyWith<$Res> {
  __$$PRAssociatedPOImplCopyWithImpl(
      _$PRAssociatedPOImpl _value, $Res Function(_$PRAssociatedPOImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? poNumber = null,
    Object? supplierName = null,
    Object? pdfUrl = freezed,
    Object? status = null,
  }) {
    return _then(_$PRAssociatedPOImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      poNumber: null == poNumber
          ? _value.poNumber
          : poNumber // ignore: cast_nullable_to_non_nullable
              as String,
      supplierName: null == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String,
      pdfUrl: freezed == pdfUrl
          ? _value.pdfUrl
          : pdfUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PRAssociatedPOImpl implements _PRAssociatedPO {
  const _$PRAssociatedPOImpl(
      {required this.id,
      @JsonKey(name: 'po_number') required this.poNumber,
      @JsonKey(name: 'supplier_name') required this.supplierName,
      @JsonKey(name: 'pdf_url') this.pdfUrl,
      required this.status});

  factory _$PRAssociatedPOImpl.fromJson(Map<String, dynamic> json) =>
      _$$PRAssociatedPOImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'po_number')
  final String poNumber;
  @override
  @JsonKey(name: 'supplier_name')
  final String supplierName;
  @override
  @JsonKey(name: 'pdf_url')
  final String? pdfUrl;
  @override
  final String status;

  @override
  String toString() {
    return 'PRAssociatedPO(id: $id, poNumber: $poNumber, supplierName: $supplierName, pdfUrl: $pdfUrl, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PRAssociatedPOImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.poNumber, poNumber) ||
                other.poNumber == poNumber) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            (identical(other.pdfUrl, pdfUrl) || other.pdfUrl == pdfUrl) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, poNumber, supplierName, pdfUrl, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PRAssociatedPOImplCopyWith<_$PRAssociatedPOImpl> get copyWith =>
      __$$PRAssociatedPOImplCopyWithImpl<_$PRAssociatedPOImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PRAssociatedPOImplToJson(
      this,
    );
  }
}

abstract class _PRAssociatedPO implements PRAssociatedPO {
  const factory _PRAssociatedPO(
      {required final int id,
      @JsonKey(name: 'po_number') required final String poNumber,
      @JsonKey(name: 'supplier_name') required final String supplierName,
      @JsonKey(name: 'pdf_url') final String? pdfUrl,
      required final String status}) = _$PRAssociatedPOImpl;

  factory _PRAssociatedPO.fromJson(Map<String, dynamic> json) =
      _$PRAssociatedPOImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'po_number')
  String get poNumber;
  @override
  @JsonKey(name: 'supplier_name')
  String get supplierName;
  @override
  @JsonKey(name: 'pdf_url')
  String? get pdfUrl;
  @override
  String get status;
  @override
  @JsonKey(ignore: true)
  _$$PRAssociatedPOImplCopyWith<_$PRAssociatedPOImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
