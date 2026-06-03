// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentTransaction _$PaymentTransactionFromJson(Map<String, dynamic> json) {
  return _PaymentTransaction.fromJson(json);
}

/// @nodoc
mixin _$PaymentTransaction {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  int get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name')
  String? get companyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_id')
  int get supplierId => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_name')
  String? get supplierName => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_bank_account_id')
  int? get companyBankAccountId => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_request_id')
  int? get paymentRequestId => throw _privateConstructorUsedError;
  @JsonKey(name: 'transaction_number')
  String get transactionNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'transaction_date')
  String get transactionDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
  double get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank_name')
  String? get bankName => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank_account')
  String? get bankAccount => throw _privateConstructorUsedError;
  @JsonKey(name: 'transfer_reference')
  String? get transferReference => throw _privateConstructorUsedError;
  @JsonKey(name: 'receipt_path')
  String? get receiptPath => throw _privateConstructorUsedError;
  @JsonKey(name: 'receipt_url')
  String? get receiptUrl => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'paid_by')
  int? get paidBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'paid_by_name')
  String? get paidByName => throw _privateConstructorUsedError;
  @JsonKey(name: 'formatted_invoices')
  List<PaymentTransactionInvoice> get invoices =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaymentTransactionCopyWith<PaymentTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentTransactionCopyWith<$Res> {
  factory $PaymentTransactionCopyWith(
          PaymentTransaction value, $Res Function(PaymentTransaction) then) =
      _$PaymentTransactionCopyWithImpl<$Res, PaymentTransaction>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'company_id') int companyId,
      @JsonKey(name: 'company_name') String? companyName,
      @JsonKey(name: 'supplier_id') int supplierId,
      @JsonKey(name: 'supplier_name') String? supplierName,
      @JsonKey(name: 'company_bank_account_id') int? companyBankAccountId,
      @JsonKey(name: 'payment_request_id') int? paymentRequestId,
      @JsonKey(name: 'transaction_number') String transactionNumber,
      @JsonKey(name: 'transaction_date') String transactionDate,
      @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
      double totalAmount,
      @JsonKey(name: 'bank_name') String? bankName,
      @JsonKey(name: 'bank_account') String? bankAccount,
      @JsonKey(name: 'transfer_reference') String? transferReference,
      @JsonKey(name: 'receipt_path') String? receiptPath,
      @JsonKey(name: 'receipt_url') String? receiptUrl,
      String? notes,
      @JsonKey(name: 'paid_by') int? paidBy,
      @JsonKey(name: 'paid_by_name') String? paidByName,
      @JsonKey(name: 'formatted_invoices')
      List<PaymentTransactionInvoice> invoices});
}

/// @nodoc
class _$PaymentTransactionCopyWithImpl<$Res, $Val extends PaymentTransaction>
    implements $PaymentTransactionCopyWith<$Res> {
  _$PaymentTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? companyName = freezed,
    Object? supplierId = null,
    Object? supplierName = freezed,
    Object? companyBankAccountId = freezed,
    Object? paymentRequestId = freezed,
    Object? transactionNumber = null,
    Object? transactionDate = null,
    Object? totalAmount = null,
    Object? bankName = freezed,
    Object? bankAccount = freezed,
    Object? transferReference = freezed,
    Object? receiptPath = freezed,
    Object? receiptUrl = freezed,
    Object? notes = freezed,
    Object? paidBy = freezed,
    Object? paidByName = freezed,
    Object? invoices = null,
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
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierId: null == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      companyBankAccountId: freezed == companyBankAccountId
          ? _value.companyBankAccountId
          : companyBankAccountId // ignore: cast_nullable_to_non_nullable
              as int?,
      paymentRequestId: freezed == paymentRequestId
          ? _value.paymentRequestId
          : paymentRequestId // ignore: cast_nullable_to_non_nullable
              as int?,
      transactionNumber: null == transactionNumber
          ? _value.transactionNumber
          : transactionNumber // ignore: cast_nullable_to_non_nullable
              as String,
      transactionDate: null == transactionDate
          ? _value.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAccount: freezed == bankAccount
          ? _value.bankAccount
          : bankAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      transferReference: freezed == transferReference
          ? _value.transferReference
          : transferReference // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptPath: freezed == receiptPath
          ? _value.receiptPath
          : receiptPath // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptUrl: freezed == receiptUrl
          ? _value.receiptUrl
          : receiptUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      paidBy: freezed == paidBy
          ? _value.paidBy
          : paidBy // ignore: cast_nullable_to_non_nullable
              as int?,
      paidByName: freezed == paidByName
          ? _value.paidByName
          : paidByName // ignore: cast_nullable_to_non_nullable
              as String?,
      invoices: null == invoices
          ? _value.invoices
          : invoices // ignore: cast_nullable_to_non_nullable
              as List<PaymentTransactionInvoice>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentTransactionImplCopyWith<$Res>
    implements $PaymentTransactionCopyWith<$Res> {
  factory _$$PaymentTransactionImplCopyWith(_$PaymentTransactionImpl value,
          $Res Function(_$PaymentTransactionImpl) then) =
      __$$PaymentTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'company_id') int companyId,
      @JsonKey(name: 'company_name') String? companyName,
      @JsonKey(name: 'supplier_id') int supplierId,
      @JsonKey(name: 'supplier_name') String? supplierName,
      @JsonKey(name: 'company_bank_account_id') int? companyBankAccountId,
      @JsonKey(name: 'payment_request_id') int? paymentRequestId,
      @JsonKey(name: 'transaction_number') String transactionNumber,
      @JsonKey(name: 'transaction_date') String transactionDate,
      @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
      double totalAmount,
      @JsonKey(name: 'bank_name') String? bankName,
      @JsonKey(name: 'bank_account') String? bankAccount,
      @JsonKey(name: 'transfer_reference') String? transferReference,
      @JsonKey(name: 'receipt_path') String? receiptPath,
      @JsonKey(name: 'receipt_url') String? receiptUrl,
      String? notes,
      @JsonKey(name: 'paid_by') int? paidBy,
      @JsonKey(name: 'paid_by_name') String? paidByName,
      @JsonKey(name: 'formatted_invoices')
      List<PaymentTransactionInvoice> invoices});
}

/// @nodoc
class __$$PaymentTransactionImplCopyWithImpl<$Res>
    extends _$PaymentTransactionCopyWithImpl<$Res, _$PaymentTransactionImpl>
    implements _$$PaymentTransactionImplCopyWith<$Res> {
  __$$PaymentTransactionImplCopyWithImpl(_$PaymentTransactionImpl _value,
      $Res Function(_$PaymentTransactionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? companyName = freezed,
    Object? supplierId = null,
    Object? supplierName = freezed,
    Object? companyBankAccountId = freezed,
    Object? paymentRequestId = freezed,
    Object? transactionNumber = null,
    Object? transactionDate = null,
    Object? totalAmount = null,
    Object? bankName = freezed,
    Object? bankAccount = freezed,
    Object? transferReference = freezed,
    Object? receiptPath = freezed,
    Object? receiptUrl = freezed,
    Object? notes = freezed,
    Object? paidBy = freezed,
    Object? paidByName = freezed,
    Object? invoices = null,
  }) {
    return _then(_$PaymentTransactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierId: null == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      companyBankAccountId: freezed == companyBankAccountId
          ? _value.companyBankAccountId
          : companyBankAccountId // ignore: cast_nullable_to_non_nullable
              as int?,
      paymentRequestId: freezed == paymentRequestId
          ? _value.paymentRequestId
          : paymentRequestId // ignore: cast_nullable_to_non_nullable
              as int?,
      transactionNumber: null == transactionNumber
          ? _value.transactionNumber
          : transactionNumber // ignore: cast_nullable_to_non_nullable
              as String,
      transactionDate: null == transactionDate
          ? _value.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAccount: freezed == bankAccount
          ? _value.bankAccount
          : bankAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      transferReference: freezed == transferReference
          ? _value.transferReference
          : transferReference // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptPath: freezed == receiptPath
          ? _value.receiptPath
          : receiptPath // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptUrl: freezed == receiptUrl
          ? _value.receiptUrl
          : receiptUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      paidBy: freezed == paidBy
          ? _value.paidBy
          : paidBy // ignore: cast_nullable_to_non_nullable
              as int?,
      paidByName: freezed == paidByName
          ? _value.paidByName
          : paidByName // ignore: cast_nullable_to_non_nullable
              as String?,
      invoices: null == invoices
          ? _value._invoices
          : invoices // ignore: cast_nullable_to_non_nullable
              as List<PaymentTransactionInvoice>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentTransactionImpl implements _PaymentTransaction {
  const _$PaymentTransactionImpl(
      {required this.id,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'company_name') this.companyName,
      @JsonKey(name: 'supplier_id') required this.supplierId,
      @JsonKey(name: 'supplier_name') this.supplierName,
      @JsonKey(name: 'company_bank_account_id') this.companyBankAccountId,
      @JsonKey(name: 'payment_request_id') this.paymentRequestId,
      @JsonKey(name: 'transaction_number') required this.transactionNumber,
      @JsonKey(name: 'transaction_date') required this.transactionDate,
      @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
      required this.totalAmount,
      @JsonKey(name: 'bank_name') this.bankName,
      @JsonKey(name: 'bank_account') this.bankAccount,
      @JsonKey(name: 'transfer_reference') this.transferReference,
      @JsonKey(name: 'receipt_path') this.receiptPath,
      @JsonKey(name: 'receipt_url') this.receiptUrl,
      this.notes,
      @JsonKey(name: 'paid_by') this.paidBy,
      @JsonKey(name: 'paid_by_name') this.paidByName,
      @JsonKey(name: 'formatted_invoices')
      final List<PaymentTransactionInvoice> invoices = const []})
      : _invoices = invoices;

  factory _$PaymentTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentTransactionImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'company_id')
  final int companyId;
  @override
  @JsonKey(name: 'company_name')
  final String? companyName;
  @override
  @JsonKey(name: 'supplier_id')
  final int supplierId;
  @override
  @JsonKey(name: 'supplier_name')
  final String? supplierName;
  @override
  @JsonKey(name: 'company_bank_account_id')
  final int? companyBankAccountId;
  @override
  @JsonKey(name: 'payment_request_id')
  final int? paymentRequestId;
  @override
  @JsonKey(name: 'transaction_number')
  final String transactionNumber;
  @override
  @JsonKey(name: 'transaction_date')
  final String transactionDate;
  @override
  @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
  final double totalAmount;
  @override
  @JsonKey(name: 'bank_name')
  final String? bankName;
  @override
  @JsonKey(name: 'bank_account')
  final String? bankAccount;
  @override
  @JsonKey(name: 'transfer_reference')
  final String? transferReference;
  @override
  @JsonKey(name: 'receipt_path')
  final String? receiptPath;
  @override
  @JsonKey(name: 'receipt_url')
  final String? receiptUrl;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'paid_by')
  final int? paidBy;
  @override
  @JsonKey(name: 'paid_by_name')
  final String? paidByName;
  final List<PaymentTransactionInvoice> _invoices;
  @override
  @JsonKey(name: 'formatted_invoices')
  List<PaymentTransactionInvoice> get invoices {
    if (_invoices is EqualUnmodifiableListView) return _invoices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_invoices);
  }

  @override
  String toString() {
    return 'PaymentTransaction(id: $id, companyId: $companyId, companyName: $companyName, supplierId: $supplierId, supplierName: $supplierName, companyBankAccountId: $companyBankAccountId, paymentRequestId: $paymentRequestId, transactionNumber: $transactionNumber, transactionDate: $transactionDate, totalAmount: $totalAmount, bankName: $bankName, bankAccount: $bankAccount, transferReference: $transferReference, receiptPath: $receiptPath, receiptUrl: $receiptUrl, notes: $notes, paidBy: $paidBy, paidByName: $paidByName, invoices: $invoices)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            (identical(other.companyBankAccountId, companyBankAccountId) ||
                other.companyBankAccountId == companyBankAccountId) &&
            (identical(other.paymentRequestId, paymentRequestId) ||
                other.paymentRequestId == paymentRequestId) &&
            (identical(other.transactionNumber, transactionNumber) ||
                other.transactionNumber == transactionNumber) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.bankAccount, bankAccount) ||
                other.bankAccount == bankAccount) &&
            (identical(other.transferReference, transferReference) ||
                other.transferReference == transferReference) &&
            (identical(other.receiptPath, receiptPath) ||
                other.receiptPath == receiptPath) &&
            (identical(other.receiptUrl, receiptUrl) ||
                other.receiptUrl == receiptUrl) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.paidBy, paidBy) || other.paidBy == paidBy) &&
            (identical(other.paidByName, paidByName) ||
                other.paidByName == paidByName) &&
            const DeepCollectionEquality().equals(other._invoices, _invoices));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        companyId,
        companyName,
        supplierId,
        supplierName,
        companyBankAccountId,
        paymentRequestId,
        transactionNumber,
        transactionDate,
        totalAmount,
        bankName,
        bankAccount,
        transferReference,
        receiptPath,
        receiptUrl,
        notes,
        paidBy,
        paidByName,
        const DeepCollectionEquality().hash(_invoices)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentTransactionImplCopyWith<_$PaymentTransactionImpl> get copyWith =>
      __$$PaymentTransactionImplCopyWithImpl<_$PaymentTransactionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentTransactionImplToJson(
      this,
    );
  }
}

abstract class _PaymentTransaction implements PaymentTransaction {
  const factory _PaymentTransaction(
      {required final int id,
      @JsonKey(name: 'company_id') required final int companyId,
      @JsonKey(name: 'company_name') final String? companyName,
      @JsonKey(name: 'supplier_id') required final int supplierId,
      @JsonKey(name: 'supplier_name') final String? supplierName,
      @JsonKey(name: 'company_bank_account_id') final int? companyBankAccountId,
      @JsonKey(name: 'payment_request_id') final int? paymentRequestId,
      @JsonKey(name: 'transaction_number')
      required final String transactionNumber,
      @JsonKey(name: 'transaction_date') required final String transactionDate,
      @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
      required final double totalAmount,
      @JsonKey(name: 'bank_name') final String? bankName,
      @JsonKey(name: 'bank_account') final String? bankAccount,
      @JsonKey(name: 'transfer_reference') final String? transferReference,
      @JsonKey(name: 'receipt_path') final String? receiptPath,
      @JsonKey(name: 'receipt_url') final String? receiptUrl,
      final String? notes,
      @JsonKey(name: 'paid_by') final int? paidBy,
      @JsonKey(name: 'paid_by_name') final String? paidByName,
      @JsonKey(name: 'formatted_invoices')
      final List<PaymentTransactionInvoice>
          invoices}) = _$PaymentTransactionImpl;

  factory _PaymentTransaction.fromJson(Map<String, dynamic> json) =
      _$PaymentTransactionImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'company_id')
  int get companyId;
  @override
  @JsonKey(name: 'company_name')
  String? get companyName;
  @override
  @JsonKey(name: 'supplier_id')
  int get supplierId;
  @override
  @JsonKey(name: 'supplier_name')
  String? get supplierName;
  @override
  @JsonKey(name: 'company_bank_account_id')
  int? get companyBankAccountId;
  @override
  @JsonKey(name: 'payment_request_id')
  int? get paymentRequestId;
  @override
  @JsonKey(name: 'transaction_number')
  String get transactionNumber;
  @override
  @JsonKey(name: 'transaction_date')
  String get transactionDate;
  @override
  @JsonKey(name: 'total_amount', fromJson: doubleFromJson)
  double get totalAmount;
  @override
  @JsonKey(name: 'bank_name')
  String? get bankName;
  @override
  @JsonKey(name: 'bank_account')
  String? get bankAccount;
  @override
  @JsonKey(name: 'transfer_reference')
  String? get transferReference;
  @override
  @JsonKey(name: 'receipt_path')
  String? get receiptPath;
  @override
  @JsonKey(name: 'receipt_url')
  String? get receiptUrl;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'paid_by')
  int? get paidBy;
  @override
  @JsonKey(name: 'paid_by_name')
  String? get paidByName;
  @override
  @JsonKey(name: 'formatted_invoices')
  List<PaymentTransactionInvoice> get invoices;
  @override
  @JsonKey(ignore: true)
  _$$PaymentTransactionImplCopyWith<_$PaymentTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentTransactionInvoice _$PaymentTransactionInvoiceFromJson(
    Map<String, dynamic> json) {
  return _PaymentTransactionInvoice.fromJson(json);
}

/// @nodoc
mixin _$PaymentTransactionInvoice {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_id')
  int get invoiceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_number')
  String get invoiceNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_date')
  String? get invoiceDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'due_date')
  String? get dueDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_name')
  String? get supplierName => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_paid', fromJson: doubleFromJson)
  double get amountPaid => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaymentTransactionInvoiceCopyWith<PaymentTransactionInvoice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentTransactionInvoiceCopyWith<$Res> {
  factory $PaymentTransactionInvoiceCopyWith(PaymentTransactionInvoice value,
          $Res Function(PaymentTransactionInvoice) then) =
      _$PaymentTransactionInvoiceCopyWithImpl<$Res, PaymentTransactionInvoice>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'invoice_id') int invoiceId,
      @JsonKey(name: 'invoice_number') String invoiceNumber,
      @JsonKey(name: 'invoice_date') String? invoiceDate,
      @JsonKey(name: 'due_date') String? dueDate,
      @JsonKey(name: 'supplier_name') String? supplierName,
      @JsonKey(name: 'amount_paid', fromJson: doubleFromJson)
      double amountPaid});
}

/// @nodoc
class _$PaymentTransactionInvoiceCopyWithImpl<$Res,
        $Val extends PaymentTransactionInvoice>
    implements $PaymentTransactionInvoiceCopyWith<$Res> {
  _$PaymentTransactionInvoiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceId = null,
    Object? invoiceNumber = null,
    Object? invoiceDate = freezed,
    Object? dueDate = freezed,
    Object? supplierName = freezed,
    Object? amountPaid = null,
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
      invoiceNumber: null == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceDate: freezed == invoiceDate
          ? _value.invoiceDate
          : invoiceDate // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      amountPaid: null == amountPaid
          ? _value.amountPaid
          : amountPaid // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentTransactionInvoiceImplCopyWith<$Res>
    implements $PaymentTransactionInvoiceCopyWith<$Res> {
  factory _$$PaymentTransactionInvoiceImplCopyWith(
          _$PaymentTransactionInvoiceImpl value,
          $Res Function(_$PaymentTransactionInvoiceImpl) then) =
      __$$PaymentTransactionInvoiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'invoice_id') int invoiceId,
      @JsonKey(name: 'invoice_number') String invoiceNumber,
      @JsonKey(name: 'invoice_date') String? invoiceDate,
      @JsonKey(name: 'due_date') String? dueDate,
      @JsonKey(name: 'supplier_name') String? supplierName,
      @JsonKey(name: 'amount_paid', fromJson: doubleFromJson)
      double amountPaid});
}

/// @nodoc
class __$$PaymentTransactionInvoiceImplCopyWithImpl<$Res>
    extends _$PaymentTransactionInvoiceCopyWithImpl<$Res,
        _$PaymentTransactionInvoiceImpl>
    implements _$$PaymentTransactionInvoiceImplCopyWith<$Res> {
  __$$PaymentTransactionInvoiceImplCopyWithImpl(
      _$PaymentTransactionInvoiceImpl _value,
      $Res Function(_$PaymentTransactionInvoiceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceId = null,
    Object? invoiceNumber = null,
    Object? invoiceDate = freezed,
    Object? dueDate = freezed,
    Object? supplierName = freezed,
    Object? amountPaid = null,
  }) {
    return _then(_$PaymentTransactionInvoiceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      invoiceId: null == invoiceId
          ? _value.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as int,
      invoiceNumber: null == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      invoiceDate: freezed == invoiceDate
          ? _value.invoiceDate
          : invoiceDate // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      amountPaid: null == amountPaid
          ? _value.amountPaid
          : amountPaid // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentTransactionInvoiceImpl implements _PaymentTransactionInvoice {
  const _$PaymentTransactionInvoiceImpl(
      {required this.id,
      @JsonKey(name: 'invoice_id') required this.invoiceId,
      @JsonKey(name: 'invoice_number') required this.invoiceNumber,
      @JsonKey(name: 'invoice_date') this.invoiceDate,
      @JsonKey(name: 'due_date') this.dueDate,
      @JsonKey(name: 'supplier_name') this.supplierName,
      @JsonKey(name: 'amount_paid', fromJson: doubleFromJson)
      required this.amountPaid});

  factory _$PaymentTransactionInvoiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentTransactionInvoiceImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'invoice_id')
  final int invoiceId;
  @override
  @JsonKey(name: 'invoice_number')
  final String invoiceNumber;
  @override
  @JsonKey(name: 'invoice_date')
  final String? invoiceDate;
  @override
  @JsonKey(name: 'due_date')
  final String? dueDate;
  @override
  @JsonKey(name: 'supplier_name')
  final String? supplierName;
  @override
  @JsonKey(name: 'amount_paid', fromJson: doubleFromJson)
  final double amountPaid;

  @override
  String toString() {
    return 'PaymentTransactionInvoice(id: $id, invoiceId: $invoiceId, invoiceNumber: $invoiceNumber, invoiceDate: $invoiceDate, dueDate: $dueDate, supplierName: $supplierName, amountPaid: $amountPaid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentTransactionInvoiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.invoiceId, invoiceId) ||
                other.invoiceId == invoiceId) &&
            (identical(other.invoiceNumber, invoiceNumber) ||
                other.invoiceNumber == invoiceNumber) &&
            (identical(other.invoiceDate, invoiceDate) ||
                other.invoiceDate == invoiceDate) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            (identical(other.amountPaid, amountPaid) ||
                other.amountPaid == amountPaid));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, invoiceId, invoiceNumber,
      invoiceDate, dueDate, supplierName, amountPaid);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentTransactionInvoiceImplCopyWith<_$PaymentTransactionInvoiceImpl>
      get copyWith => __$$PaymentTransactionInvoiceImplCopyWithImpl<
          _$PaymentTransactionInvoiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentTransactionInvoiceImplToJson(
      this,
    );
  }
}

abstract class _PaymentTransactionInvoice implements PaymentTransactionInvoice {
  const factory _PaymentTransactionInvoice(
      {required final int id,
      @JsonKey(name: 'invoice_id') required final int invoiceId,
      @JsonKey(name: 'invoice_number') required final String invoiceNumber,
      @JsonKey(name: 'invoice_date') final String? invoiceDate,
      @JsonKey(name: 'due_date') final String? dueDate,
      @JsonKey(name: 'supplier_name') final String? supplierName,
      @JsonKey(name: 'amount_paid', fromJson: doubleFromJson)
      required final double amountPaid}) = _$PaymentTransactionInvoiceImpl;

  factory _PaymentTransactionInvoice.fromJson(Map<String, dynamic> json) =
      _$PaymentTransactionInvoiceImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'invoice_id')
  int get invoiceId;
  @override
  @JsonKey(name: 'invoice_number')
  String get invoiceNumber;
  @override
  @JsonKey(name: 'invoice_date')
  String? get invoiceDate;
  @override
  @JsonKey(name: 'due_date')
  String? get dueDate;
  @override
  @JsonKey(name: 'supplier_name')
  String? get supplierName;
  @override
  @JsonKey(name: 'amount_paid', fromJson: doubleFromJson)
  double get amountPaid;
  @override
  @JsonKey(ignore: true)
  _$$PaymentTransactionInvoiceImplCopyWith<_$PaymentTransactionInvoiceImpl>
      get copyWith => throw _privateConstructorUsedError;
}
