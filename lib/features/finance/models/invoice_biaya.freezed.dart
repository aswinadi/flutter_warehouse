// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_biaya.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InvoiceBiaya _$InvoiceBiayaFromJson(Map<String, dynamic> json) {
  return _InvoiceBiaya.fromJson(json);
}

/// @nodoc
mixin _$InvoiceBiaya {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  int get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_id')
  int? get supplierId => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_code')
  String? get supplierCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_name')
  String? get supplierName => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_number')
  String get invoiceNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor_invoice_number')
  String? get vendorInvoiceNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_date')
  String get invoiceDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'due_date')
  String? get dueDate => throw _privateConstructorUsedError;
  @JsonKey(fromJson: doubleFromJson)
  double get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_amount', fromJson: doubleFromJson)
  double get taxAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
  double get totalAmount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  int? get createdBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_invoice_number')
  String? get taxInvoiceNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_invoice_date')
  String? get taxInvoiceDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'cost_center_code')
  String? get costCenterCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'jv_type')
  String? get jvType => throw _privateConstructorUsedError;
  List<MediaFile> get media => throw _privateConstructorUsedError;
  List<InvoiceBiayaDetail> get details => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InvoiceBiayaCopyWith<InvoiceBiaya> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceBiayaCopyWith<$Res> {
  factory $InvoiceBiayaCopyWith(
          InvoiceBiaya value, $Res Function(InvoiceBiaya) then) =
      _$InvoiceBiayaCopyWithImpl<$Res, InvoiceBiaya>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'company_id') int companyId,
      @JsonKey(name: 'supplier_id') int? supplierId,
      @JsonKey(name: 'supplier_code') String? supplierCode,
      @JsonKey(name: 'supplier_name') String? supplierName,
      @JsonKey(name: 'invoice_number') String invoiceNumber,
      @JsonKey(name: 'vendor_invoice_number') String? vendorInvoiceNumber,
      @JsonKey(name: 'invoice_date') String invoiceDate,
      @JsonKey(name: 'due_date') String? dueDate,
      @JsonKey(fromJson: doubleFromJson) double amount,
      @JsonKey(name: 'tax_amount', fromJson: doubleFromJson) double taxAmount,
      @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
      double totalAmount,
      String currency,
      String? notes,
      String status,
      @JsonKey(name: 'created_by') int? createdBy,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'tax_invoice_number') String? taxInvoiceNumber,
      @JsonKey(name: 'tax_invoice_date') String? taxInvoiceDate,
      @JsonKey(name: 'cost_center_code') String? costCenterCode,
      @JsonKey(name: 'jv_type') String? jvType,
      List<MediaFile> media,
      List<InvoiceBiayaDetail> details});
}

/// @nodoc
class _$InvoiceBiayaCopyWithImpl<$Res, $Val extends InvoiceBiaya>
    implements $InvoiceBiayaCopyWith<$Res> {
  _$InvoiceBiayaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? supplierId = freezed,
    Object? supplierCode = freezed,
    Object? supplierName = freezed,
    Object? invoiceNumber = null,
    Object? vendorInvoiceNumber = freezed,
    Object? invoiceDate = null,
    Object? dueDate = freezed,
    Object? amount = null,
    Object? taxAmount = null,
    Object? totalAmount = null,
    Object? currency = null,
    Object? notes = freezed,
    Object? status = null,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? taxInvoiceNumber = freezed,
    Object? taxInvoiceDate = freezed,
    Object? costCenterCode = freezed,
    Object? jvType = freezed,
    Object? media = null,
    Object? details = null,
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
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int?,
      supplierCode: freezed == supplierCode
          ? _value.supplierCode
          : supplierCode // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceNumber: null == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      vendorInvoiceNumber: freezed == vendorInvoiceNumber
          ? _value.vendorInvoiceNumber
          : vendorInvoiceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceDate: null == invoiceDate
          ? _value.invoiceDate
          : invoiceDate // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      taxInvoiceNumber: freezed == taxInvoiceNumber
          ? _value.taxInvoiceNumber
          : taxInvoiceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      taxInvoiceDate: freezed == taxInvoiceDate
          ? _value.taxInvoiceDate
          : taxInvoiceDate // ignore: cast_nullable_to_non_nullable
              as String?,
      costCenterCode: freezed == costCenterCode
          ? _value.costCenterCode
          : costCenterCode // ignore: cast_nullable_to_non_nullable
              as String?,
      jvType: freezed == jvType
          ? _value.jvType
          : jvType // ignore: cast_nullable_to_non_nullable
              as String?,
      media: null == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as List<MediaFile>,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as List<InvoiceBiayaDetail>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvoiceBiayaImplCopyWith<$Res>
    implements $InvoiceBiayaCopyWith<$Res> {
  factory _$$InvoiceBiayaImplCopyWith(
          _$InvoiceBiayaImpl value, $Res Function(_$InvoiceBiayaImpl) then) =
      __$$InvoiceBiayaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'company_id') int companyId,
      @JsonKey(name: 'supplier_id') int? supplierId,
      @JsonKey(name: 'supplier_code') String? supplierCode,
      @JsonKey(name: 'supplier_name') String? supplierName,
      @JsonKey(name: 'invoice_number') String invoiceNumber,
      @JsonKey(name: 'vendor_invoice_number') String? vendorInvoiceNumber,
      @JsonKey(name: 'invoice_date') String invoiceDate,
      @JsonKey(name: 'due_date') String? dueDate,
      @JsonKey(fromJson: doubleFromJson) double amount,
      @JsonKey(name: 'tax_amount', fromJson: doubleFromJson) double taxAmount,
      @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
      double totalAmount,
      String currency,
      String? notes,
      String status,
      @JsonKey(name: 'created_by') int? createdBy,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'tax_invoice_number') String? taxInvoiceNumber,
      @JsonKey(name: 'tax_invoice_date') String? taxInvoiceDate,
      @JsonKey(name: 'cost_center_code') String? costCenterCode,
      @JsonKey(name: 'jv_type') String? jvType,
      List<MediaFile> media,
      List<InvoiceBiayaDetail> details});
}

/// @nodoc
class __$$InvoiceBiayaImplCopyWithImpl<$Res>
    extends _$InvoiceBiayaCopyWithImpl<$Res, _$InvoiceBiayaImpl>
    implements _$$InvoiceBiayaImplCopyWith<$Res> {
  __$$InvoiceBiayaImplCopyWithImpl(
      _$InvoiceBiayaImpl _value, $Res Function(_$InvoiceBiayaImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? supplierId = freezed,
    Object? supplierCode = freezed,
    Object? supplierName = freezed,
    Object? invoiceNumber = null,
    Object? vendorInvoiceNumber = freezed,
    Object? invoiceDate = null,
    Object? dueDate = freezed,
    Object? amount = null,
    Object? taxAmount = null,
    Object? totalAmount = null,
    Object? currency = null,
    Object? notes = freezed,
    Object? status = null,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? taxInvoiceNumber = freezed,
    Object? taxInvoiceDate = freezed,
    Object? costCenterCode = freezed,
    Object? jvType = freezed,
    Object? media = null,
    Object? details = null,
  }) {
    return _then(_$InvoiceBiayaImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int?,
      supplierCode: freezed == supplierCode
          ? _value.supplierCode
          : supplierCode // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceNumber: null == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      vendorInvoiceNumber: freezed == vendorInvoiceNumber
          ? _value.vendorInvoiceNumber
          : vendorInvoiceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      invoiceDate: null == invoiceDate
          ? _value.invoiceDate
          : invoiceDate // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      taxInvoiceNumber: freezed == taxInvoiceNumber
          ? _value.taxInvoiceNumber
          : taxInvoiceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      taxInvoiceDate: freezed == taxInvoiceDate
          ? _value.taxInvoiceDate
          : taxInvoiceDate // ignore: cast_nullable_to_non_nullable
              as String?,
      costCenterCode: freezed == costCenterCode
          ? _value.costCenterCode
          : costCenterCode // ignore: cast_nullable_to_non_nullable
              as String?,
      jvType: freezed == jvType
          ? _value.jvType
          : jvType // ignore: cast_nullable_to_non_nullable
              as String?,
      media: null == media
          ? _value._media
          : media // ignore: cast_nullable_to_non_nullable
              as List<MediaFile>,
      details: null == details
          ? _value._details
          : details // ignore: cast_nullable_to_non_nullable
              as List<InvoiceBiayaDetail>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InvoiceBiayaImpl implements _InvoiceBiaya {
  const _$InvoiceBiayaImpl(
      {required this.id,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'supplier_id') this.supplierId,
      @JsonKey(name: 'supplier_code') this.supplierCode,
      @JsonKey(name: 'supplier_name') this.supplierName,
      @JsonKey(name: 'invoice_number') required this.invoiceNumber,
      @JsonKey(name: 'vendor_invoice_number') this.vendorInvoiceNumber,
      @JsonKey(name: 'invoice_date') required this.invoiceDate,
      @JsonKey(name: 'due_date') this.dueDate,
      @JsonKey(fromJson: doubleFromJson) required this.amount,
      @JsonKey(name: 'tax_amount', fromJson: doubleFromJson)
      required this.taxAmount,
      @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
      required this.totalAmount,
      required this.currency,
      this.notes,
      required this.status,
      @JsonKey(name: 'created_by') this.createdBy,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'tax_invoice_number') this.taxInvoiceNumber,
      @JsonKey(name: 'tax_invoice_date') this.taxInvoiceDate,
      @JsonKey(name: 'cost_center_code') this.costCenterCode,
      @JsonKey(name: 'jv_type') this.jvType,
      final List<MediaFile> media = const [],
      final List<InvoiceBiayaDetail> details = const []})
      : _media = media,
        _details = details;

  factory _$InvoiceBiayaImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvoiceBiayaImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'company_id')
  final int companyId;
  @override
  @JsonKey(name: 'supplier_id')
  final int? supplierId;
  @override
  @JsonKey(name: 'supplier_code')
  final String? supplierCode;
  @override
  @JsonKey(name: 'supplier_name')
  final String? supplierName;
  @override
  @JsonKey(name: 'invoice_number')
  final String invoiceNumber;
  @override
  @JsonKey(name: 'vendor_invoice_number')
  final String? vendorInvoiceNumber;
  @override
  @JsonKey(name: 'invoice_date')
  final String invoiceDate;
  @override
  @JsonKey(name: 'due_date')
  final String? dueDate;
  @override
  @JsonKey(fromJson: doubleFromJson)
  final double amount;
  @override
  @JsonKey(name: 'tax_amount', fromJson: doubleFromJson)
  final double taxAmount;
  @override
  @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
  final double totalAmount;
  @override
  final String currency;
  @override
  final String? notes;
  @override
  final String status;
  @override
  @JsonKey(name: 'created_by')
  final int? createdBy;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'tax_invoice_number')
  final String? taxInvoiceNumber;
  @override
  @JsonKey(name: 'tax_invoice_date')
  final String? taxInvoiceDate;
  @override
  @JsonKey(name: 'cost_center_code')
  final String? costCenterCode;
  @override
  @JsonKey(name: 'jv_type')
  final String? jvType;
  final List<MediaFile> _media;
  @override
  @JsonKey()
  List<MediaFile> get media {
    if (_media is EqualUnmodifiableListView) return _media;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_media);
  }

  final List<InvoiceBiayaDetail> _details;
  @override
  @JsonKey()
  List<InvoiceBiayaDetail> get details {
    if (_details is EqualUnmodifiableListView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_details);
  }

  @override
  String toString() {
    return 'InvoiceBiaya(id: $id, companyId: $companyId, supplierId: $supplierId, supplierCode: $supplierCode, supplierName: $supplierName, invoiceNumber: $invoiceNumber, vendorInvoiceNumber: $vendorInvoiceNumber, invoiceDate: $invoiceDate, dueDate: $dueDate, amount: $amount, taxAmount: $taxAmount, totalAmount: $totalAmount, currency: $currency, notes: $notes, status: $status, createdBy: $createdBy, createdAt: $createdAt, taxInvoiceNumber: $taxInvoiceNumber, taxInvoiceDate: $taxInvoiceDate, costCenterCode: $costCenterCode, jvType: $jvType, media: $media, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceBiayaImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.supplierCode, supplierCode) ||
                other.supplierCode == supplierCode) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            (identical(other.invoiceNumber, invoiceNumber) ||
                other.invoiceNumber == invoiceNumber) &&
            (identical(other.vendorInvoiceNumber, vendorInvoiceNumber) ||
                other.vendorInvoiceNumber == vendorInvoiceNumber) &&
            (identical(other.invoiceDate, invoiceDate) ||
                other.invoiceDate == invoiceDate) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.taxInvoiceNumber, taxInvoiceNumber) ||
                other.taxInvoiceNumber == taxInvoiceNumber) &&
            (identical(other.taxInvoiceDate, taxInvoiceDate) ||
                other.taxInvoiceDate == taxInvoiceDate) &&
            (identical(other.costCenterCode, costCenterCode) ||
                other.costCenterCode == costCenterCode) &&
            (identical(other.jvType, jvType) || other.jvType == jvType) &&
            const DeepCollectionEquality().equals(other._media, _media) &&
            const DeepCollectionEquality().equals(other._details, _details));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        companyId,
        supplierId,
        supplierCode,
        supplierName,
        invoiceNumber,
        vendorInvoiceNumber,
        invoiceDate,
        dueDate,
        amount,
        taxAmount,
        totalAmount,
        currency,
        notes,
        status,
        createdBy,
        createdAt,
        taxInvoiceNumber,
        taxInvoiceDate,
        costCenterCode,
        jvType,
        const DeepCollectionEquality().hash(_media),
        const DeepCollectionEquality().hash(_details)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceBiayaImplCopyWith<_$InvoiceBiayaImpl> get copyWith =>
      __$$InvoiceBiayaImplCopyWithImpl<_$InvoiceBiayaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InvoiceBiayaImplToJson(
      this,
    );
  }
}

abstract class _InvoiceBiaya implements InvoiceBiaya {
  const factory _InvoiceBiaya(
      {required final int id,
      @JsonKey(name: 'company_id') required final int companyId,
      @JsonKey(name: 'supplier_id') final int? supplierId,
      @JsonKey(name: 'supplier_code') final String? supplierCode,
      @JsonKey(name: 'supplier_name') final String? supplierName,
      @JsonKey(name: 'invoice_number') required final String invoiceNumber,
      @JsonKey(name: 'vendor_invoice_number') final String? vendorInvoiceNumber,
      @JsonKey(name: 'invoice_date') required final String invoiceDate,
      @JsonKey(name: 'due_date') final String? dueDate,
      @JsonKey(fromJson: doubleFromJson) required final double amount,
      @JsonKey(name: 'tax_amount', fromJson: doubleFromJson)
      required final double taxAmount,
      @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
      required final double totalAmount,
      required final String currency,
      final String? notes,
      required final String status,
      @JsonKey(name: 'created_by') final int? createdBy,
      @JsonKey(name: 'created_at') final String? createdAt,
      @JsonKey(name: 'tax_invoice_number') final String? taxInvoiceNumber,
      @JsonKey(name: 'tax_invoice_date') final String? taxInvoiceDate,
      @JsonKey(name: 'cost_center_code') final String? costCenterCode,
      @JsonKey(name: 'jv_type') final String? jvType,
      final List<MediaFile> media,
      final List<InvoiceBiayaDetail> details}) = _$InvoiceBiayaImpl;

  factory _InvoiceBiaya.fromJson(Map<String, dynamic> json) =
      _$InvoiceBiayaImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'company_id')
  int get companyId;
  @override
  @JsonKey(name: 'supplier_id')
  int? get supplierId;
  @override
  @JsonKey(name: 'supplier_code')
  String? get supplierCode;
  @override
  @JsonKey(name: 'supplier_name')
  String? get supplierName;
  @override
  @JsonKey(name: 'invoice_number')
  String get invoiceNumber;
  @override
  @JsonKey(name: 'vendor_invoice_number')
  String? get vendorInvoiceNumber;
  @override
  @JsonKey(name: 'invoice_date')
  String get invoiceDate;
  @override
  @JsonKey(name: 'due_date')
  String? get dueDate;
  @override
  @JsonKey(fromJson: doubleFromJson)
  double get amount;
  @override
  @JsonKey(name: 'tax_amount', fromJson: doubleFromJson)
  double get taxAmount;
  @override
  @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
  double get totalAmount;
  @override
  String get currency;
  @override
  String? get notes;
  @override
  String get status;
  @override
  @JsonKey(name: 'created_by')
  int? get createdBy;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'tax_invoice_number')
  String? get taxInvoiceNumber;
  @override
  @JsonKey(name: 'tax_invoice_date')
  String? get taxInvoiceDate;
  @override
  @JsonKey(name: 'cost_center_code')
  String? get costCenterCode;
  @override
  @JsonKey(name: 'jv_type')
  String? get jvType;
  @override
  List<MediaFile> get media;
  @override
  List<InvoiceBiayaDetail> get details;
  @override
  @JsonKey(ignore: true)
  _$$InvoiceBiayaImplCopyWith<_$InvoiceBiayaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
