// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Invoice _$InvoiceFromJson(Map<String, dynamic> json) {
  return _Invoice.fromJson(json);
}

/// @nodoc
mixin _$Invoice {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_number')
  String get invoiceNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'vendor_invoice_number')
  String? get vendorInvoiceNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_date')
  String get invoiceDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'due_date')
  String? get dueDate => throw _privateConstructorUsedError;
  @JsonKey(fromJson: doubleFromJson)
  double get subtotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_amount', fromJson: doubleFromJson)
  double get taxAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_amount', fromJson: doubleFromJson)
  double get discountAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
  double get totalAmount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  int get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_id')
  int? get supplierId => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_name')
  String? get supplierName => throw _privateConstructorUsedError;
  @JsonKey(name: 'receiving_number')
  String? get receivingNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_approve')
  bool get canApprove => throw _privateConstructorUsedError;
  @JsonKey(name: 'pdf_url')
  String? get pdfUrl => throw _privateConstructorUsedError;
  List<InvoiceItem> get items => throw _privateConstructorUsedError;
  List<MediaFile> get media => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InvoiceCopyWith<Invoice> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceCopyWith<$Res> {
  factory $InvoiceCopyWith(Invoice value, $Res Function(Invoice) then) =
      _$InvoiceCopyWithImpl<$Res, Invoice>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'invoice_number') String invoiceNumber,
      @JsonKey(name: 'vendor_invoice_number') String? vendorInvoiceNumber,
      @JsonKey(name: 'invoice_date') String invoiceDate,
      @JsonKey(name: 'due_date') String? dueDate,
      @JsonKey(fromJson: doubleFromJson) double subtotal,
      @JsonKey(name: 'tax_amount', fromJson: doubleFromJson) double taxAmount,
      @JsonKey(name: 'discount_amount', fromJson: doubleFromJson)
      double discountAmount,
      @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
      double totalAmount,
      String currency,
      String? description,
      String? notes,
      String status,
      @JsonKey(name: 'company_id') int companyId,
      @JsonKey(name: 'supplier_id') int? supplierId,
      @JsonKey(name: 'supplier_name') String? supplierName,
      @JsonKey(name: 'receiving_number') String? receivingNumber,
      @JsonKey(name: 'can_approve') bool canApprove,
      @JsonKey(name: 'pdf_url') String? pdfUrl,
      List<InvoiceItem> items,
      List<MediaFile> media});
}

/// @nodoc
class _$InvoiceCopyWithImpl<$Res, $Val extends Invoice>
    implements $InvoiceCopyWith<$Res> {
  _$InvoiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceNumber = null,
    Object? vendorInvoiceNumber = freezed,
    Object? invoiceDate = null,
    Object? dueDate = freezed,
    Object? subtotal = null,
    Object? taxAmount = null,
    Object? discountAmount = null,
    Object? totalAmount = null,
    Object? currency = null,
    Object? description = freezed,
    Object? notes = freezed,
    Object? status = null,
    Object? companyId = null,
    Object? supplierId = freezed,
    Object? supplierName = freezed,
    Object? receivingNumber = freezed,
    Object? canApprove = null,
    Object? pdfUrl = freezed,
    Object? items = null,
    Object? media = null,
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
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      receivingNumber: freezed == receivingNumber
          ? _value.receivingNumber
          : receivingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      canApprove: null == canApprove
          ? _value.canApprove
          : canApprove // ignore: cast_nullable_to_non_nullable
              as bool,
      pdfUrl: freezed == pdfUrl
          ? _value.pdfUrl
          : pdfUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<InvoiceItem>,
      media: null == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as List<MediaFile>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvoiceImplCopyWith<$Res> implements $InvoiceCopyWith<$Res> {
  factory _$$InvoiceImplCopyWith(
          _$InvoiceImpl value, $Res Function(_$InvoiceImpl) then) =
      __$$InvoiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'invoice_number') String invoiceNumber,
      @JsonKey(name: 'vendor_invoice_number') String? vendorInvoiceNumber,
      @JsonKey(name: 'invoice_date') String invoiceDate,
      @JsonKey(name: 'due_date') String? dueDate,
      @JsonKey(fromJson: doubleFromJson) double subtotal,
      @JsonKey(name: 'tax_amount', fromJson: doubleFromJson) double taxAmount,
      @JsonKey(name: 'discount_amount', fromJson: doubleFromJson)
      double discountAmount,
      @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
      double totalAmount,
      String currency,
      String? description,
      String? notes,
      String status,
      @JsonKey(name: 'company_id') int companyId,
      @JsonKey(name: 'supplier_id') int? supplierId,
      @JsonKey(name: 'supplier_name') String? supplierName,
      @JsonKey(name: 'receiving_number') String? receivingNumber,
      @JsonKey(name: 'can_approve') bool canApprove,
      @JsonKey(name: 'pdf_url') String? pdfUrl,
      List<InvoiceItem> items,
      List<MediaFile> media});
}

/// @nodoc
class __$$InvoiceImplCopyWithImpl<$Res>
    extends _$InvoiceCopyWithImpl<$Res, _$InvoiceImpl>
    implements _$$InvoiceImplCopyWith<$Res> {
  __$$InvoiceImplCopyWithImpl(
      _$InvoiceImpl _value, $Res Function(_$InvoiceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceNumber = null,
    Object? vendorInvoiceNumber = freezed,
    Object? invoiceDate = null,
    Object? dueDate = freezed,
    Object? subtotal = null,
    Object? taxAmount = null,
    Object? discountAmount = null,
    Object? totalAmount = null,
    Object? currency = null,
    Object? description = freezed,
    Object? notes = freezed,
    Object? status = null,
    Object? companyId = null,
    Object? supplierId = freezed,
    Object? supplierName = freezed,
    Object? receivingNumber = freezed,
    Object? canApprove = null,
    Object? pdfUrl = freezed,
    Object? items = null,
    Object? media = null,
  }) {
    return _then(_$InvoiceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
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
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      receivingNumber: freezed == receivingNumber
          ? _value.receivingNumber
          : receivingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      canApprove: null == canApprove
          ? _value.canApprove
          : canApprove // ignore: cast_nullable_to_non_nullable
              as bool,
      pdfUrl: freezed == pdfUrl
          ? _value.pdfUrl
          : pdfUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<InvoiceItem>,
      media: null == media
          ? _value._media
          : media // ignore: cast_nullable_to_non_nullable
              as List<MediaFile>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InvoiceImpl implements _Invoice {
  const _$InvoiceImpl(
      {required this.id,
      @JsonKey(name: 'invoice_number') required this.invoiceNumber,
      @JsonKey(name: 'vendor_invoice_number') this.vendorInvoiceNumber,
      @JsonKey(name: 'invoice_date') required this.invoiceDate,
      @JsonKey(name: 'due_date') this.dueDate,
      @JsonKey(fromJson: doubleFromJson) required this.subtotal,
      @JsonKey(name: 'tax_amount', fromJson: doubleFromJson)
      required this.taxAmount,
      @JsonKey(name: 'discount_amount', fromJson: doubleFromJson)
      required this.discountAmount,
      @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
      required this.totalAmount,
      required this.currency,
      this.description,
      this.notes,
      required this.status,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'supplier_id') this.supplierId,
      @JsonKey(name: 'supplier_name') this.supplierName,
      @JsonKey(name: 'receiving_number') this.receivingNumber,
      @JsonKey(name: 'can_approve') this.canApprove = false,
      @JsonKey(name: 'pdf_url') this.pdfUrl,
      final List<InvoiceItem> items = const [],
      final List<MediaFile> media = const []})
      : _items = items,
        _media = media;

  factory _$InvoiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvoiceImplFromJson(json);

  @override
  final int id;
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
  final double subtotal;
  @override
  @JsonKey(name: 'tax_amount', fromJson: doubleFromJson)
  final double taxAmount;
  @override
  @JsonKey(name: 'discount_amount', fromJson: doubleFromJson)
  final double discountAmount;
  @override
  @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
  final double totalAmount;
  @override
  final String currency;
  @override
  final String? description;
  @override
  final String? notes;
  @override
  final String status;
  @override
  @JsonKey(name: 'company_id')
  final int companyId;
  @override
  @JsonKey(name: 'supplier_id')
  final int? supplierId;
  @override
  @JsonKey(name: 'supplier_name')
  final String? supplierName;
  @override
  @JsonKey(name: 'receiving_number')
  final String? receivingNumber;
  @override
  @JsonKey(name: 'can_approve')
  final bool canApprove;
  @override
  @JsonKey(name: 'pdf_url')
  final String? pdfUrl;
  final List<InvoiceItem> _items;
  @override
  @JsonKey()
  List<InvoiceItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final List<MediaFile> _media;
  @override
  @JsonKey()
  List<MediaFile> get media {
    if (_media is EqualUnmodifiableListView) return _media;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_media);
  }

  @override
  String toString() {
    return 'Invoice(id: $id, invoiceNumber: $invoiceNumber, vendorInvoiceNumber: $vendorInvoiceNumber, invoiceDate: $invoiceDate, dueDate: $dueDate, subtotal: $subtotal, taxAmount: $taxAmount, discountAmount: $discountAmount, totalAmount: $totalAmount, currency: $currency, description: $description, notes: $notes, status: $status, companyId: $companyId, supplierId: $supplierId, supplierName: $supplierName, receivingNumber: $receivingNumber, canApprove: $canApprove, pdfUrl: $pdfUrl, items: $items, media: $media)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.invoiceNumber, invoiceNumber) ||
                other.invoiceNumber == invoiceNumber) &&
            (identical(other.vendorInvoiceNumber, vendorInvoiceNumber) ||
                other.vendorInvoiceNumber == vendorInvoiceNumber) &&
            (identical(other.invoiceDate, invoiceDate) ||
                other.invoiceDate == invoiceDate) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            (identical(other.receivingNumber, receivingNumber) ||
                other.receivingNumber == receivingNumber) &&
            (identical(other.canApprove, canApprove) ||
                other.canApprove == canApprove) &&
            (identical(other.pdfUrl, pdfUrl) || other.pdfUrl == pdfUrl) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(other._media, _media));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        invoiceNumber,
        vendorInvoiceNumber,
        invoiceDate,
        dueDate,
        subtotal,
        taxAmount,
        discountAmount,
        totalAmount,
        currency,
        description,
        notes,
        status,
        companyId,
        supplierId,
        supplierName,
        receivingNumber,
        canApprove,
        pdfUrl,
        const DeepCollectionEquality().hash(_items),
        const DeepCollectionEquality().hash(_media)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceImplCopyWith<_$InvoiceImpl> get copyWith =>
      __$$InvoiceImplCopyWithImpl<_$InvoiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InvoiceImplToJson(
      this,
    );
  }
}

abstract class _Invoice implements Invoice {
  const factory _Invoice(
      {required final int id,
      @JsonKey(name: 'invoice_number') required final String invoiceNumber,
      @JsonKey(name: 'vendor_invoice_number') final String? vendorInvoiceNumber,
      @JsonKey(name: 'invoice_date') required final String invoiceDate,
      @JsonKey(name: 'due_date') final String? dueDate,
      @JsonKey(fromJson: doubleFromJson) required final double subtotal,
      @JsonKey(name: 'tax_amount', fromJson: doubleFromJson)
      required final double taxAmount,
      @JsonKey(name: 'discount_amount', fromJson: doubleFromJson)
      required final double discountAmount,
      @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
      required final double totalAmount,
      required final String currency,
      final String? description,
      final String? notes,
      required final String status,
      @JsonKey(name: 'company_id') required final int companyId,
      @JsonKey(name: 'supplier_id') final int? supplierId,
      @JsonKey(name: 'supplier_name') final String? supplierName,
      @JsonKey(name: 'receiving_number') final String? receivingNumber,
      @JsonKey(name: 'can_approve') final bool canApprove,
      @JsonKey(name: 'pdf_url') final String? pdfUrl,
      final List<InvoiceItem> items,
      final List<MediaFile> media}) = _$InvoiceImpl;

  factory _Invoice.fromJson(Map<String, dynamic> json) = _$InvoiceImpl.fromJson;

  @override
  int get id;
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
  double get subtotal;
  @override
  @JsonKey(name: 'tax_amount', fromJson: doubleFromJson)
  double get taxAmount;
  @override
  @JsonKey(name: 'discount_amount', fromJson: doubleFromJson)
  double get discountAmount;
  @override
  @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
  double get totalAmount;
  @override
  String get currency;
  @override
  String? get description;
  @override
  String? get notes;
  @override
  String get status;
  @override
  @JsonKey(name: 'company_id')
  int get companyId;
  @override
  @JsonKey(name: 'supplier_id')
  int? get supplierId;
  @override
  @JsonKey(name: 'supplier_name')
  String? get supplierName;
  @override
  @JsonKey(name: 'receiving_number')
  String? get receivingNumber;
  @override
  @JsonKey(name: 'can_approve')
  bool get canApprove;
  @override
  @JsonKey(name: 'pdf_url')
  String? get pdfUrl;
  @override
  List<InvoiceItem> get items;
  @override
  List<MediaFile> get media;
  @override
  @JsonKey(ignore: true)
  _$$InvoiceImplCopyWith<_$InvoiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InvoiceItem _$InvoiceItemFromJson(Map<String, dynamic> json) {
  return _InvoiceItem.fromJson(json);
}

/// @nodoc
mixin _$InvoiceItem {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_id')
  int get invoiceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  int? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_code')
  String get productCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name')
  String get productName => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(fromJson: doubleFromJson)
  double get quantity => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price', fromJson: doubleFromJson)
  double get unitPrice => throw _privateConstructorUsedError;
  @JsonKey(fromJson: doubleFromJson)
  double get discount => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_rate', fromJson: doubleFromJson)
  double get taxRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_amount', fromJson: doubleFromJson)
  double get taxAmount => throw _privateConstructorUsedError;
  @JsonKey(fromJson: doubleFromJson)
  double get subtotal => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InvoiceItemCopyWith<InvoiceItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceItemCopyWith<$Res> {
  factory $InvoiceItemCopyWith(
          InvoiceItem value, $Res Function(InvoiceItem) then) =
      _$InvoiceItemCopyWithImpl<$Res, InvoiceItem>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'invoice_id') int invoiceId,
      @JsonKey(name: 'product_id') int? productId,
      @JsonKey(name: 'product_code') String productCode,
      @JsonKey(name: 'product_name') String productName,
      String? description,
      @JsonKey(fromJson: doubleFromJson) double quantity,
      String unit,
      @JsonKey(name: 'unit_price', fromJson: doubleFromJson) double unitPrice,
      @JsonKey(fromJson: doubleFromJson) double discount,
      @JsonKey(name: 'tax_rate', fromJson: doubleFromJson) double taxRate,
      @JsonKey(name: 'tax_amount', fromJson: doubleFromJson) double taxAmount,
      @JsonKey(fromJson: doubleFromJson) double subtotal});
}

/// @nodoc
class _$InvoiceItemCopyWithImpl<$Res, $Val extends InvoiceItem>
    implements $InvoiceItemCopyWith<$Res> {
  _$InvoiceItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceId = null,
    Object? productId = freezed,
    Object? productCode = null,
    Object? productName = null,
    Object? description = freezed,
    Object? quantity = null,
    Object? unit = null,
    Object? unitPrice = null,
    Object? discount = null,
    Object? taxRate = null,
    Object? taxAmount = null,
    Object? subtotal = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      invoiceId: null == invoiceId
          ? _value.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as int,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
      productCode: null == productCode
          ? _value.productCode
          : productCode // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      taxRate: null == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as double,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvoiceItemImplCopyWith<$Res>
    implements $InvoiceItemCopyWith<$Res> {
  factory _$$InvoiceItemImplCopyWith(
          _$InvoiceItemImpl value, $Res Function(_$InvoiceItemImpl) then) =
      __$$InvoiceItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'invoice_id') int invoiceId,
      @JsonKey(name: 'product_id') int? productId,
      @JsonKey(name: 'product_code') String productCode,
      @JsonKey(name: 'product_name') String productName,
      String? description,
      @JsonKey(fromJson: doubleFromJson) double quantity,
      String unit,
      @JsonKey(name: 'unit_price', fromJson: doubleFromJson) double unitPrice,
      @JsonKey(fromJson: doubleFromJson) double discount,
      @JsonKey(name: 'tax_rate', fromJson: doubleFromJson) double taxRate,
      @JsonKey(name: 'tax_amount', fromJson: doubleFromJson) double taxAmount,
      @JsonKey(fromJson: doubleFromJson) double subtotal});
}

/// @nodoc
class __$$InvoiceItemImplCopyWithImpl<$Res>
    extends _$InvoiceItemCopyWithImpl<$Res, _$InvoiceItemImpl>
    implements _$$InvoiceItemImplCopyWith<$Res> {
  __$$InvoiceItemImplCopyWithImpl(
      _$InvoiceItemImpl _value, $Res Function(_$InvoiceItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceId = null,
    Object? productId = freezed,
    Object? productCode = null,
    Object? productName = null,
    Object? description = freezed,
    Object? quantity = null,
    Object? unit = null,
    Object? unitPrice = null,
    Object? discount = null,
    Object? taxRate = null,
    Object? taxAmount = null,
    Object? subtotal = null,
  }) {
    return _then(_$InvoiceItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      invoiceId: null == invoiceId
          ? _value.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as int,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
      productCode: null == productCode
          ? _value.productCode
          : productCode // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      taxRate: null == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as double,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InvoiceItemImpl implements _InvoiceItem {
  const _$InvoiceItemImpl(
      {required this.id,
      @JsonKey(name: 'invoice_id') required this.invoiceId,
      @JsonKey(name: 'product_id') this.productId,
      @JsonKey(name: 'product_code') required this.productCode,
      @JsonKey(name: 'product_name') required this.productName,
      this.description,
      @JsonKey(fromJson: doubleFromJson) required this.quantity,
      required this.unit,
      @JsonKey(name: 'unit_price', fromJson: doubleFromJson)
      required this.unitPrice,
      @JsonKey(fromJson: doubleFromJson) required this.discount,
      @JsonKey(name: 'tax_rate', fromJson: doubleFromJson)
      required this.taxRate,
      @JsonKey(name: 'tax_amount', fromJson: doubleFromJson)
      required this.taxAmount,
      @JsonKey(fromJson: doubleFromJson) required this.subtotal});

  factory _$InvoiceItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvoiceItemImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'invoice_id')
  final int invoiceId;
  @override
  @JsonKey(name: 'product_id')
  final int? productId;
  @override
  @JsonKey(name: 'product_code')
  final String productCode;
  @override
  @JsonKey(name: 'product_name')
  final String productName;
  @override
  final String? description;
  @override
  @JsonKey(fromJson: doubleFromJson)
  final double quantity;
  @override
  final String unit;
  @override
  @JsonKey(name: 'unit_price', fromJson: doubleFromJson)
  final double unitPrice;
  @override
  @JsonKey(fromJson: doubleFromJson)
  final double discount;
  @override
  @JsonKey(name: 'tax_rate', fromJson: doubleFromJson)
  final double taxRate;
  @override
  @JsonKey(name: 'tax_amount', fromJson: doubleFromJson)
  final double taxAmount;
  @override
  @JsonKey(fromJson: doubleFromJson)
  final double subtotal;

  @override
  String toString() {
    return 'InvoiceItem(id: $id, invoiceId: $invoiceId, productId: $productId, productCode: $productCode, productName: $productName, description: $description, quantity: $quantity, unit: $unit, unitPrice: $unitPrice, discount: $discount, taxRate: $taxRate, taxAmount: $taxAmount, subtotal: $subtotal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.invoiceId, invoiceId) ||
                other.invoiceId == invoiceId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productCode, productCode) ||
                other.productCode == productCode) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      invoiceId,
      productId,
      productCode,
      productName,
      description,
      quantity,
      unit,
      unitPrice,
      discount,
      taxRate,
      taxAmount,
      subtotal);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceItemImplCopyWith<_$InvoiceItemImpl> get copyWith =>
      __$$InvoiceItemImplCopyWithImpl<_$InvoiceItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InvoiceItemImplToJson(
      this,
    );
  }
}

abstract class _InvoiceItem implements InvoiceItem {
  const factory _InvoiceItem(
          {required final int id,
          @JsonKey(name: 'invoice_id') required final int invoiceId,
          @JsonKey(name: 'product_id') final int? productId,
          @JsonKey(name: 'product_code') required final String productCode,
          @JsonKey(name: 'product_name') required final String productName,
          final String? description,
          @JsonKey(fromJson: doubleFromJson) required final double quantity,
          required final String unit,
          @JsonKey(name: 'unit_price', fromJson: doubleFromJson)
          required final double unitPrice,
          @JsonKey(fromJson: doubleFromJson) required final double discount,
          @JsonKey(name: 'tax_rate', fromJson: doubleFromJson)
          required final double taxRate,
          @JsonKey(name: 'tax_amount', fromJson: doubleFromJson)
          required final double taxAmount,
          @JsonKey(fromJson: doubleFromJson) required final double subtotal}) =
      _$InvoiceItemImpl;

  factory _InvoiceItem.fromJson(Map<String, dynamic> json) =
      _$InvoiceItemImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'invoice_id')
  int get invoiceId;
  @override
  @JsonKey(name: 'product_id')
  int? get productId;
  @override
  @JsonKey(name: 'product_code')
  String get productCode;
  @override
  @JsonKey(name: 'product_name')
  String get productName;
  @override
  String? get description;
  @override
  @JsonKey(fromJson: doubleFromJson)
  double get quantity;
  @override
  String get unit;
  @override
  @JsonKey(name: 'unit_price', fromJson: doubleFromJson)
  double get unitPrice;
  @override
  @JsonKey(fromJson: doubleFromJson)
  double get discount;
  @override
  @JsonKey(name: 'tax_rate', fromJson: doubleFromJson)
  double get taxRate;
  @override
  @JsonKey(name: 'tax_amount', fromJson: doubleFromJson)
  double get taxAmount;
  @override
  @JsonKey(fromJson: doubleFromJson)
  double get subtotal;
  @override
  @JsonKey(ignore: true)
  _$$InvoiceItemImplCopyWith<_$InvoiceItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MediaFile _$MediaFileFromJson(Map<String, dynamic> json) {
  return _MediaFile.fromJson(json);
}

/// @nodoc
mixin _$MediaFile {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'file_name')
  String get fileName => throw _privateConstructorUsedError;
  @JsonKey(name: 'mime_type')
  String get mimeType => throw _privateConstructorUsedError;
  @JsonKey(name: 'original_url')
  String get originalUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MediaFileCopyWith<MediaFile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaFileCopyWith<$Res> {
  factory $MediaFileCopyWith(MediaFile value, $Res Function(MediaFile) then) =
      _$MediaFileCopyWithImpl<$Res, MediaFile>;
  @useResult
  $Res call(
      {int id,
      String name,
      @JsonKey(name: 'file_name') String fileName,
      @JsonKey(name: 'mime_type') String mimeType,
      @JsonKey(name: 'original_url') String originalUrl});
}

/// @nodoc
class _$MediaFileCopyWithImpl<$Res, $Val extends MediaFile>
    implements $MediaFileCopyWith<$Res> {
  _$MediaFileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? fileName = null,
    Object? mimeType = null,
    Object? originalUrl = null,
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
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      originalUrl: null == originalUrl
          ? _value.originalUrl
          : originalUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MediaFileImplCopyWith<$Res>
    implements $MediaFileCopyWith<$Res> {
  factory _$$MediaFileImplCopyWith(
          _$MediaFileImpl value, $Res Function(_$MediaFileImpl) then) =
      __$$MediaFileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      @JsonKey(name: 'file_name') String fileName,
      @JsonKey(name: 'mime_type') String mimeType,
      @JsonKey(name: 'original_url') String originalUrl});
}

/// @nodoc
class __$$MediaFileImplCopyWithImpl<$Res>
    extends _$MediaFileCopyWithImpl<$Res, _$MediaFileImpl>
    implements _$$MediaFileImplCopyWith<$Res> {
  __$$MediaFileImplCopyWithImpl(
      _$MediaFileImpl _value, $Res Function(_$MediaFileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? fileName = null,
    Object? mimeType = null,
    Object? originalUrl = null,
  }) {
    return _then(_$MediaFileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      originalUrl: null == originalUrl
          ? _value.originalUrl
          : originalUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MediaFileImpl implements _MediaFile {
  const _$MediaFileImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'file_name') required this.fileName,
      @JsonKey(name: 'mime_type') required this.mimeType,
      @JsonKey(name: 'original_url') required this.originalUrl});

  factory _$MediaFileImpl.fromJson(Map<String, dynamic> json) =>
      _$$MediaFileImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  @JsonKey(name: 'file_name')
  final String fileName;
  @override
  @JsonKey(name: 'mime_type')
  final String mimeType;
  @override
  @JsonKey(name: 'original_url')
  final String originalUrl;

  @override
  String toString() {
    return 'MediaFile(id: $id, name: $name, fileName: $fileName, mimeType: $mimeType, originalUrl: $originalUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaFileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.originalUrl, originalUrl) ||
                other.originalUrl == originalUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, fileName, mimeType, originalUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaFileImplCopyWith<_$MediaFileImpl> get copyWith =>
      __$$MediaFileImplCopyWithImpl<_$MediaFileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MediaFileImplToJson(
      this,
    );
  }
}

abstract class _MediaFile implements MediaFile {
  const factory _MediaFile(
          {required final int id,
          required final String name,
          @JsonKey(name: 'file_name') required final String fileName,
          @JsonKey(name: 'mime_type') required final String mimeType,
          @JsonKey(name: 'original_url') required final String originalUrl}) =
      _$MediaFileImpl;

  factory _MediaFile.fromJson(Map<String, dynamic> json) =
      _$MediaFileImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'file_name')
  String get fileName;
  @override
  @JsonKey(name: 'mime_type')
  String get mimeType;
  @override
  @JsonKey(name: 'original_url')
  String get originalUrl;
  @override
  @JsonKey(ignore: true)
  _$$MediaFileImplCopyWith<_$MediaFileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
