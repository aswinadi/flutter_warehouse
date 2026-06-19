// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentRequest _$PaymentRequestFromJson(Map<String, dynamic> json) {
  return _PaymentRequest.fromJson(json);
}

/// @nodoc
mixin _$PaymentRequest {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'request_number')
  String get requestNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'request_date')
  String get requestDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'requestor_name')
  String get requestorName => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
  double get totalAmount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  int get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_approve')
  bool get canApprove => throw _privateConstructorUsedError;
  @JsonKey(name: 'pdf_url')
  String? get pdfUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_names')
  String? get supplierNames => throw _privateConstructorUsedError;
  @JsonKey(name: 'due_date')
  String? get dueDate => throw _privateConstructorUsedError;
  List<PaymentRequestInvoice> get invoices =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaymentRequestCopyWith<PaymentRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentRequestCopyWith<$Res> {
  factory $PaymentRequestCopyWith(
          PaymentRequest value, $Res Function(PaymentRequest) then) =
      _$PaymentRequestCopyWithImpl<$Res, PaymentRequest>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'request_number') String requestNumber,
      @JsonKey(name: 'request_date') String requestDate,
      @JsonKey(name: 'requestor_name') String requestorName,
      @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
      double totalAmount,
      String currency,
      String status,
      String? description,
      @JsonKey(name: 'company_id') int companyId,
      @JsonKey(name: 'can_approve') bool canApprove,
      @JsonKey(name: 'pdf_url') String? pdfUrl,
      @JsonKey(name: 'supplier_names') String? supplierNames,
      @JsonKey(name: 'due_date') String? dueDate,
      List<PaymentRequestInvoice> invoices});
}

/// @nodoc
class _$PaymentRequestCopyWithImpl<$Res, $Val extends PaymentRequest>
    implements $PaymentRequestCopyWith<$Res> {
  _$PaymentRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requestNumber = null,
    Object? requestDate = null,
    Object? requestorName = null,
    Object? totalAmount = null,
    Object? currency = null,
    Object? status = null,
    Object? description = freezed,
    Object? companyId = null,
    Object? canApprove = null,
    Object? pdfUrl = freezed,
    Object? supplierNames = freezed,
    Object? dueDate = freezed,
    Object? invoices = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      requestNumber: null == requestNumber
          ? _value.requestNumber
          : requestNumber // ignore: cast_nullable_to_non_nullable
              as String,
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      requestorName: null == requestorName
          ? _value.requestorName
          : requestorName // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int,
      canApprove: null == canApprove
          ? _value.canApprove
          : canApprove // ignore: cast_nullable_to_non_nullable
              as bool,
      pdfUrl: freezed == pdfUrl
          ? _value.pdfUrl
          : pdfUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierNames: freezed == supplierNames
          ? _value.supplierNames
          : supplierNames // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      invoices: null == invoices
          ? _value.invoices
          : invoices // ignore: cast_nullable_to_non_nullable
              as List<PaymentRequestInvoice>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentRequestImplCopyWith<$Res>
    implements $PaymentRequestCopyWith<$Res> {
  factory _$$PaymentRequestImplCopyWith(_$PaymentRequestImpl value,
          $Res Function(_$PaymentRequestImpl) then) =
      __$$PaymentRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'request_number') String requestNumber,
      @JsonKey(name: 'request_date') String requestDate,
      @JsonKey(name: 'requestor_name') String requestorName,
      @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
      double totalAmount,
      String currency,
      String status,
      String? description,
      @JsonKey(name: 'company_id') int companyId,
      @JsonKey(name: 'can_approve') bool canApprove,
      @JsonKey(name: 'pdf_url') String? pdfUrl,
      @JsonKey(name: 'supplier_names') String? supplierNames,
      @JsonKey(name: 'due_date') String? dueDate,
      List<PaymentRequestInvoice> invoices});
}

/// @nodoc
class __$$PaymentRequestImplCopyWithImpl<$Res>
    extends _$PaymentRequestCopyWithImpl<$Res, _$PaymentRequestImpl>
    implements _$$PaymentRequestImplCopyWith<$Res> {
  __$$PaymentRequestImplCopyWithImpl(
      _$PaymentRequestImpl _value, $Res Function(_$PaymentRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requestNumber = null,
    Object? requestDate = null,
    Object? requestorName = null,
    Object? totalAmount = null,
    Object? currency = null,
    Object? status = null,
    Object? description = freezed,
    Object? companyId = null,
    Object? canApprove = null,
    Object? pdfUrl = freezed,
    Object? supplierNames = freezed,
    Object? dueDate = freezed,
    Object? invoices = null,
  }) {
    return _then(_$PaymentRequestImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      requestNumber: null == requestNumber
          ? _value.requestNumber
          : requestNumber // ignore: cast_nullable_to_non_nullable
              as String,
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      requestorName: null == requestorName
          ? _value.requestorName
          : requestorName // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int,
      canApprove: null == canApprove
          ? _value.canApprove
          : canApprove // ignore: cast_nullable_to_non_nullable
              as bool,
      pdfUrl: freezed == pdfUrl
          ? _value.pdfUrl
          : pdfUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierNames: freezed == supplierNames
          ? _value.supplierNames
          : supplierNames // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      invoices: null == invoices
          ? _value._invoices
          : invoices // ignore: cast_nullable_to_non_nullable
              as List<PaymentRequestInvoice>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentRequestImpl implements _PaymentRequest {
  const _$PaymentRequestImpl(
      {required this.id,
      @JsonKey(name: 'request_number') required this.requestNumber,
      @JsonKey(name: 'request_date') required this.requestDate,
      @JsonKey(name: 'requestor_name') required this.requestorName,
      @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
      required this.totalAmount,
      required this.currency,
      required this.status,
      this.description,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'can_approve') this.canApprove = false,
      @JsonKey(name: 'pdf_url') this.pdfUrl,
      @JsonKey(name: 'supplier_names') this.supplierNames,
      @JsonKey(name: 'due_date') this.dueDate,
      final List<PaymentRequestInvoice> invoices = const []})
      : _invoices = invoices;

  factory _$PaymentRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentRequestImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'request_number')
  final String requestNumber;
  @override
  @JsonKey(name: 'request_date')
  final String requestDate;
  @override
  @JsonKey(name: 'requestor_name')
  final String requestorName;
  @override
  @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
  final double totalAmount;
  @override
  final String currency;
  @override
  final String status;
  @override
  final String? description;
  @override
  @JsonKey(name: 'company_id')
  final int companyId;
  @override
  @JsonKey(name: 'can_approve')
  final bool canApprove;
  @override
  @JsonKey(name: 'pdf_url')
  final String? pdfUrl;
  @override
  @JsonKey(name: 'supplier_names')
  final String? supplierNames;
  @override
  @JsonKey(name: 'due_date')
  final String? dueDate;
  final List<PaymentRequestInvoice> _invoices;
  @override
  @JsonKey()
  List<PaymentRequestInvoice> get invoices {
    if (_invoices is EqualUnmodifiableListView) return _invoices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_invoices);
  }

  @override
  String toString() {
    return 'PaymentRequest(id: $id, requestNumber: $requestNumber, requestDate: $requestDate, requestorName: $requestorName, totalAmount: $totalAmount, currency: $currency, status: $status, description: $description, companyId: $companyId, canApprove: $canApprove, pdfUrl: $pdfUrl, supplierNames: $supplierNames, dueDate: $dueDate, invoices: $invoices)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.requestNumber, requestNumber) ||
                other.requestNumber == requestNumber) &&
            (identical(other.requestDate, requestDate) ||
                other.requestDate == requestDate) &&
            (identical(other.requestorName, requestorName) ||
                other.requestorName == requestorName) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.canApprove, canApprove) ||
                other.canApprove == canApprove) &&
            (identical(other.pdfUrl, pdfUrl) || other.pdfUrl == pdfUrl) &&
            (identical(other.supplierNames, supplierNames) ||
                other.supplierNames == supplierNames) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            const DeepCollectionEquality().equals(other._invoices, _invoices));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      requestNumber,
      requestDate,
      requestorName,
      totalAmount,
      currency,
      status,
      description,
      companyId,
      canApprove,
      pdfUrl,
      supplierNames,
      dueDate,
      const DeepCollectionEquality().hash(_invoices));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentRequestImplCopyWith<_$PaymentRequestImpl> get copyWith =>
      __$$PaymentRequestImplCopyWithImpl<_$PaymentRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentRequestImplToJson(
      this,
    );
  }
}

abstract class _PaymentRequest implements PaymentRequest {
  const factory _PaymentRequest(
      {required final int id,
      @JsonKey(name: 'request_number') required final String requestNumber,
      @JsonKey(name: 'request_date') required final String requestDate,
      @JsonKey(name: 'requestor_name') required final String requestorName,
      @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
      required final double totalAmount,
      required final String currency,
      required final String status,
      final String? description,
      @JsonKey(name: 'company_id') required final int companyId,
      @JsonKey(name: 'can_approve') final bool canApprove,
      @JsonKey(name: 'pdf_url') final String? pdfUrl,
      @JsonKey(name: 'supplier_names') final String? supplierNames,
      @JsonKey(name: 'due_date') final String? dueDate,
      final List<PaymentRequestInvoice> invoices}) = _$PaymentRequestImpl;

  factory _PaymentRequest.fromJson(Map<String, dynamic> json) =
      _$PaymentRequestImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'request_number')
  String get requestNumber;
  @override
  @JsonKey(name: 'request_date')
  String get requestDate;
  @override
  @JsonKey(name: 'requestor_name')
  String get requestorName;
  @override
  @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
  double get totalAmount;
  @override
  String get currency;
  @override
  String get status;
  @override
  String? get description;
  @override
  @JsonKey(name: 'company_id')
  int get companyId;
  @override
  @JsonKey(name: 'can_approve')
  bool get canApprove;
  @override
  @JsonKey(name: 'pdf_url')
  String? get pdfUrl;
  @override
  @JsonKey(name: 'supplier_names')
  String? get supplierNames;
  @override
  @JsonKey(name: 'due_date')
  String? get dueDate;
  @override
  List<PaymentRequestInvoice> get invoices;
  @override
  @JsonKey(ignore: true)
  _$$PaymentRequestImplCopyWith<_$PaymentRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentRequestInvoice _$PaymentRequestInvoiceFromJson(
    Map<String, dynamic> json) {
  return _PaymentRequestInvoice.fromJson(json);
}

/// @nodoc
mixin _$PaymentRequestInvoice {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_request_id')
  int get paymentRequestId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_number')
  String get invoiceNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_date')
  String get invoiceDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'due_date')
  String? get dueDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_name')
  String? get supplierName => throw _privateConstructorUsedError;
  @JsonKey(fromJson: doubleFromJson)
  double get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_amount', fromJson: doubleFromJson)
  double get taxAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'paid_amount', fromJson: doubleFromJson)
  double get paidAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status')
  String get paymentStatus => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Map<String, dynamic>? get supplier => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaymentRequestInvoiceCopyWith<PaymentRequestInvoice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentRequestInvoiceCopyWith<$Res> {
  factory $PaymentRequestInvoiceCopyWith(PaymentRequestInvoice value,
          $Res Function(PaymentRequestInvoice) then) =
      _$PaymentRequestInvoiceCopyWithImpl<$Res, PaymentRequestInvoice>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'payment_request_id') int paymentRequestId,
      String type,
      @JsonKey(name: 'invoice_number') String invoiceNumber,
      @JsonKey(name: 'invoice_date') String invoiceDate,
      @JsonKey(name: 'due_date') String? dueDate,
      @JsonKey(name: 'supplier_name') String? supplierName,
      @JsonKey(fromJson: doubleFromJson) double amount,
      @JsonKey(name: 'tax_amount', fromJson: doubleFromJson) double taxAmount,
      @JsonKey(name: 'paid_amount', fromJson: doubleFromJson) double paidAmount,
      @JsonKey(name: 'payment_status') String paymentStatus,
      String? description,
      Map<String, dynamic>? supplier});
}

/// @nodoc
class _$PaymentRequestInvoiceCopyWithImpl<$Res,
        $Val extends PaymentRequestInvoice>
    implements $PaymentRequestInvoiceCopyWith<$Res> {
  _$PaymentRequestInvoiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? paymentRequestId = null,
    Object? type = null,
    Object? invoiceNumber = null,
    Object? invoiceDate = null,
    Object? dueDate = freezed,
    Object? supplierName = freezed,
    Object? amount = null,
    Object? taxAmount = null,
    Object? paidAmount = null,
    Object? paymentStatus = null,
    Object? description = freezed,
    Object? supplier = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      paymentRequestId: null == paymentRequestId
          ? _value.paymentRequestId
          : paymentRequestId // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceNumber: null == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceDate: null == invoiceDate
          ? _value.invoiceDate
          : invoiceDate // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paidAmount: null == paidAmount
          ? _value.paidAmount
          : paidAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      supplier: freezed == supplier
          ? _value.supplier
          : supplier // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentRequestInvoiceImplCopyWith<$Res>
    implements $PaymentRequestInvoiceCopyWith<$Res> {
  factory _$$PaymentRequestInvoiceImplCopyWith(
          _$PaymentRequestInvoiceImpl value,
          $Res Function(_$PaymentRequestInvoiceImpl) then) =
      __$$PaymentRequestInvoiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'payment_request_id') int paymentRequestId,
      String type,
      @JsonKey(name: 'invoice_number') String invoiceNumber,
      @JsonKey(name: 'invoice_date') String invoiceDate,
      @JsonKey(name: 'due_date') String? dueDate,
      @JsonKey(name: 'supplier_name') String? supplierName,
      @JsonKey(fromJson: doubleFromJson) double amount,
      @JsonKey(name: 'tax_amount', fromJson: doubleFromJson) double taxAmount,
      @JsonKey(name: 'paid_amount', fromJson: doubleFromJson) double paidAmount,
      @JsonKey(name: 'payment_status') String paymentStatus,
      String? description,
      Map<String, dynamic>? supplier});
}

/// @nodoc
class __$$PaymentRequestInvoiceImplCopyWithImpl<$Res>
    extends _$PaymentRequestInvoiceCopyWithImpl<$Res,
        _$PaymentRequestInvoiceImpl>
    implements _$$PaymentRequestInvoiceImplCopyWith<$Res> {
  __$$PaymentRequestInvoiceImplCopyWithImpl(_$PaymentRequestInvoiceImpl _value,
      $Res Function(_$PaymentRequestInvoiceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? paymentRequestId = null,
    Object? type = null,
    Object? invoiceNumber = null,
    Object? invoiceDate = null,
    Object? dueDate = freezed,
    Object? supplierName = freezed,
    Object? amount = null,
    Object? taxAmount = null,
    Object? paidAmount = null,
    Object? paymentStatus = null,
    Object? description = freezed,
    Object? supplier = freezed,
  }) {
    return _then(_$PaymentRequestInvoiceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      paymentRequestId: null == paymentRequestId
          ? _value.paymentRequestId
          : paymentRequestId // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceNumber: null == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceDate: null == invoiceDate
          ? _value.invoiceDate
          : invoiceDate // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paidAmount: null == paidAmount
          ? _value.paidAmount
          : paidAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      supplier: freezed == supplier
          ? _value._supplier
          : supplier // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentRequestInvoiceImpl implements _PaymentRequestInvoice {
  const _$PaymentRequestInvoiceImpl(
      {required this.id,
      @JsonKey(name: 'payment_request_id') required this.paymentRequestId,
      required this.type,
      @JsonKey(name: 'invoice_number') required this.invoiceNumber,
      @JsonKey(name: 'invoice_date') required this.invoiceDate,
      @JsonKey(name: 'due_date') this.dueDate,
      @JsonKey(name: 'supplier_name') this.supplierName,
      @JsonKey(fromJson: doubleFromJson) required this.amount,
      @JsonKey(name: 'tax_amount', fromJson: doubleFromJson)
      required this.taxAmount,
      @JsonKey(name: 'paid_amount', fromJson: doubleFromJson)
      required this.paidAmount,
      @JsonKey(name: 'payment_status') required this.paymentStatus,
      this.description,
      final Map<String, dynamic>? supplier})
      : _supplier = supplier;

  factory _$PaymentRequestInvoiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentRequestInvoiceImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'payment_request_id')
  final int paymentRequestId;
  @override
  final String type;
  @override
  @JsonKey(name: 'invoice_number')
  final String invoiceNumber;
  @override
  @JsonKey(name: 'invoice_date')
  final String invoiceDate;
  @override
  @JsonKey(name: 'due_date')
  final String? dueDate;
  @override
  @JsonKey(name: 'supplier_name')
  final String? supplierName;
  @override
  @JsonKey(fromJson: doubleFromJson)
  final double amount;
  @override
  @JsonKey(name: 'tax_amount', fromJson: doubleFromJson)
  final double taxAmount;
  @override
  @JsonKey(name: 'paid_amount', fromJson: doubleFromJson)
  final double paidAmount;
  @override
  @JsonKey(name: 'payment_status')
  final String paymentStatus;
  @override
  final String? description;
  final Map<String, dynamic>? _supplier;
  @override
  Map<String, dynamic>? get supplier {
    final value = _supplier;
    if (value == null) return null;
    if (_supplier is EqualUnmodifiableMapView) return _supplier;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'PaymentRequestInvoice(id: $id, paymentRequestId: $paymentRequestId, type: $type, invoiceNumber: $invoiceNumber, invoiceDate: $invoiceDate, dueDate: $dueDate, supplierName: $supplierName, amount: $amount, taxAmount: $taxAmount, paidAmount: $paidAmount, paymentStatus: $paymentStatus, description: $description, supplier: $supplier)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentRequestInvoiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.paymentRequestId, paymentRequestId) ||
                other.paymentRequestId == paymentRequestId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.invoiceNumber, invoiceNumber) ||
                other.invoiceNumber == invoiceNumber) &&
            (identical(other.invoiceDate, invoiceDate) ||
                other.invoiceDate == invoiceDate) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.paidAmount, paidAmount) ||
                other.paidAmount == paidAmount) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._supplier, _supplier));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      paymentRequestId,
      type,
      invoiceNumber,
      invoiceDate,
      dueDate,
      supplierName,
      amount,
      taxAmount,
      paidAmount,
      paymentStatus,
      description,
      const DeepCollectionEquality().hash(_supplier));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentRequestInvoiceImplCopyWith<_$PaymentRequestInvoiceImpl>
      get copyWith => __$$PaymentRequestInvoiceImplCopyWithImpl<
          _$PaymentRequestInvoiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentRequestInvoiceImplToJson(
      this,
    );
  }
}

abstract class _PaymentRequestInvoice implements PaymentRequestInvoice {
  const factory _PaymentRequestInvoice(
      {required final int id,
      @JsonKey(name: 'payment_request_id') required final int paymentRequestId,
      required final String type,
      @JsonKey(name: 'invoice_number') required final String invoiceNumber,
      @JsonKey(name: 'invoice_date') required final String invoiceDate,
      @JsonKey(name: 'due_date') final String? dueDate,
      @JsonKey(name: 'supplier_name') final String? supplierName,
      @JsonKey(fromJson: doubleFromJson) required final double amount,
      @JsonKey(name: 'tax_amount', fromJson: doubleFromJson)
      required final double taxAmount,
      @JsonKey(name: 'paid_amount', fromJson: doubleFromJson)
      required final double paidAmount,
      @JsonKey(name: 'payment_status') required final String paymentStatus,
      final String? description,
      final Map<String, dynamic>? supplier}) = _$PaymentRequestInvoiceImpl;

  factory _PaymentRequestInvoice.fromJson(Map<String, dynamic> json) =
      _$PaymentRequestInvoiceImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'payment_request_id')
  int get paymentRequestId;
  @override
  String get type;
  @override
  @JsonKey(name: 'invoice_number')
  String get invoiceNumber;
  @override
  @JsonKey(name: 'invoice_date')
  String get invoiceDate;
  @override
  @JsonKey(name: 'due_date')
  String? get dueDate;
  @override
  @JsonKey(name: 'supplier_name')
  String? get supplierName;
  @override
  @JsonKey(fromJson: doubleFromJson)
  double get amount;
  @override
  @JsonKey(name: 'tax_amount', fromJson: doubleFromJson)
  double get taxAmount;
  @override
  @JsonKey(name: 'paid_amount', fromJson: doubleFromJson)
  double get paidAmount;
  @override
  @JsonKey(name: 'payment_status')
  String get paymentStatus;
  @override
  String? get description;
  @override
  Map<String, dynamic>? get supplier;
  @override
  @JsonKey(ignore: true)
  _$$PaymentRequestInvoiceImplCopyWith<_$PaymentRequestInvoiceImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AvailableInvoice _$AvailableInvoiceFromJson(Map<String, dynamic> json) {
  return _AvailableInvoice.fromJson(json);
}

/// @nodoc
mixin _$AvailableInvoice {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_number')
  String get invoiceNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_date')
  String get invoiceDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'due_date')
  String? get dueDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_id')
  int? get supplierId => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_name')
  String get supplierName => throw _privateConstructorUsedError;
  @JsonKey(fromJson: doubleFromJson)
  double get amount => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AvailableInvoiceCopyWith<AvailableInvoice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvailableInvoiceCopyWith<$Res> {
  factory $AvailableInvoiceCopyWith(
          AvailableInvoice value, $Res Function(AvailableInvoice) then) =
      _$AvailableInvoiceCopyWithImpl<$Res, AvailableInvoice>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'invoice_number') String invoiceNumber,
      @JsonKey(name: 'invoice_date') String invoiceDate,
      @JsonKey(name: 'due_date') String? dueDate,
      @JsonKey(name: 'supplier_id') int? supplierId,
      @JsonKey(name: 'supplier_name') String supplierName,
      @JsonKey(fromJson: doubleFromJson) double amount,
      String type});
}

/// @nodoc
class _$AvailableInvoiceCopyWithImpl<$Res, $Val extends AvailableInvoice>
    implements $AvailableInvoiceCopyWith<$Res> {
  _$AvailableInvoiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceNumber = null,
    Object? invoiceDate = null,
    Object? dueDate = freezed,
    Object? supplierId = freezed,
    Object? supplierName = null,
    Object? amount = null,
    Object? type = null,
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
      invoiceDate: null == invoiceDate
          ? _value.invoiceDate
          : invoiceDate // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int?,
      supplierName: null == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AvailableInvoiceImplCopyWith<$Res>
    implements $AvailableInvoiceCopyWith<$Res> {
  factory _$$AvailableInvoiceImplCopyWith(_$AvailableInvoiceImpl value,
          $Res Function(_$AvailableInvoiceImpl) then) =
      __$$AvailableInvoiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'invoice_number') String invoiceNumber,
      @JsonKey(name: 'invoice_date') String invoiceDate,
      @JsonKey(name: 'due_date') String? dueDate,
      @JsonKey(name: 'supplier_id') int? supplierId,
      @JsonKey(name: 'supplier_name') String supplierName,
      @JsonKey(fromJson: doubleFromJson) double amount,
      String type});
}

/// @nodoc
class __$$AvailableInvoiceImplCopyWithImpl<$Res>
    extends _$AvailableInvoiceCopyWithImpl<$Res, _$AvailableInvoiceImpl>
    implements _$$AvailableInvoiceImplCopyWith<$Res> {
  __$$AvailableInvoiceImplCopyWithImpl(_$AvailableInvoiceImpl _value,
      $Res Function(_$AvailableInvoiceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceNumber = null,
    Object? invoiceDate = null,
    Object? dueDate = freezed,
    Object? supplierId = freezed,
    Object? supplierName = null,
    Object? amount = null,
    Object? type = null,
  }) {
    return _then(_$AvailableInvoiceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      invoiceNumber: null == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceDate: null == invoiceDate
          ? _value.invoiceDate
          : invoiceDate // ignore: cast_nullable_to_non_nullable
              as String,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int?,
      supplierName: null == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AvailableInvoiceImpl implements _AvailableInvoice {
  const _$AvailableInvoiceImpl(
      {required this.id,
      @JsonKey(name: 'invoice_number') required this.invoiceNumber,
      @JsonKey(name: 'invoice_date') required this.invoiceDate,
      @JsonKey(name: 'due_date') this.dueDate,
      @JsonKey(name: 'supplier_id') this.supplierId,
      @JsonKey(name: 'supplier_name') required this.supplierName,
      @JsonKey(fromJson: doubleFromJson) required this.amount,
      required this.type});

  factory _$AvailableInvoiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvailableInvoiceImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'invoice_number')
  final String invoiceNumber;
  @override
  @JsonKey(name: 'invoice_date')
  final String invoiceDate;
  @override
  @JsonKey(name: 'due_date')
  final String? dueDate;
  @override
  @JsonKey(name: 'supplier_id')
  final int? supplierId;
  @override
  @JsonKey(name: 'supplier_name')
  final String supplierName;
  @override
  @JsonKey(fromJson: doubleFromJson)
  final double amount;
  @override
  final String type;

  @override
  String toString() {
    return 'AvailableInvoice(id: $id, invoiceNumber: $invoiceNumber, invoiceDate: $invoiceDate, dueDate: $dueDate, supplierId: $supplierId, supplierName: $supplierName, amount: $amount, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailableInvoiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.invoiceNumber, invoiceNumber) ||
                other.invoiceNumber == invoiceNumber) &&
            (identical(other.invoiceDate, invoiceDate) ||
                other.invoiceDate == invoiceDate) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, invoiceNumber, invoiceDate,
      dueDate, supplierId, supplierName, amount, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AvailableInvoiceImplCopyWith<_$AvailableInvoiceImpl> get copyWith =>
      __$$AvailableInvoiceImplCopyWithImpl<_$AvailableInvoiceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AvailableInvoiceImplToJson(
      this,
    );
  }
}

abstract class _AvailableInvoice implements AvailableInvoice {
  const factory _AvailableInvoice(
      {required final int id,
      @JsonKey(name: 'invoice_number') required final String invoiceNumber,
      @JsonKey(name: 'invoice_date') required final String invoiceDate,
      @JsonKey(name: 'due_date') final String? dueDate,
      @JsonKey(name: 'supplier_id') final int? supplierId,
      @JsonKey(name: 'supplier_name') required final String supplierName,
      @JsonKey(fromJson: doubleFromJson) required final double amount,
      required final String type}) = _$AvailableInvoiceImpl;

  factory _AvailableInvoice.fromJson(Map<String, dynamic> json) =
      _$AvailableInvoiceImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'invoice_number')
  String get invoiceNumber;
  @override
  @JsonKey(name: 'invoice_date')
  String get invoiceDate;
  @override
  @JsonKey(name: 'due_date')
  String? get dueDate;
  @override
  @JsonKey(name: 'supplier_id')
  int? get supplierId;
  @override
  @JsonKey(name: 'supplier_name')
  String get supplierName;
  @override
  @JsonKey(fromJson: doubleFromJson)
  double get amount;
  @override
  String get type;
  @override
  @JsonKey(ignore: true)
  _$$AvailableInvoiceImplCopyWith<_$AvailableInvoiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
