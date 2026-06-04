// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PurchaseOrder _$PurchaseOrderFromJson(Map<String, dynamic> json) {
  return _PurchaseOrder.fromJson(json);
}

/// @nodoc
mixin _$PurchaseOrder {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'po_number')
  String get poNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  int get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'warehouse_id')
  int get warehouseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'warehouse_name')
  String? get warehouseName => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_id')
  int? get supplierId => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_name')
  String get supplierName => throw _privateConstructorUsedError;
  @JsonKey(name: 'transaction_date')
  String get transactionDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'expected_date')
  String get expectedDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_term')
  String? get paymentTerm => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_items')
  int get totalItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'received_items')
  int get receivedItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_approve')
  bool get canApprove => throw _privateConstructorUsedError;
  @JsonKey(name: 'pdf_url')
  String? get pdfUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount', fromJson: doubleOrNullFromJson)
  double? get totalAmount => throw _privateConstructorUsedError;
  List<PurchaseOrderItem> get items => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PurchaseOrderCopyWith<PurchaseOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseOrderCopyWith<$Res> {
  factory $PurchaseOrderCopyWith(
          PurchaseOrder value, $Res Function(PurchaseOrder) then) =
      _$PurchaseOrderCopyWithImpl<$Res, PurchaseOrder>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'po_number') String poNumber,
      @JsonKey(name: 'company_id') int companyId,
      @JsonKey(name: 'warehouse_id') int warehouseId,
      @JsonKey(name: 'warehouse_name') String? warehouseName,
      @JsonKey(name: 'supplier_id') int? supplierId,
      @JsonKey(name: 'supplier_name') String supplierName,
      @JsonKey(name: 'transaction_date') String transactionDate,
      @JsonKey(name: 'expected_date') String expectedDate,
      @JsonKey(name: 'payment_term') String? paymentTerm,
      String status,
      @JsonKey(name: 'total_items') int totalItems,
      @JsonKey(name: 'received_items') int receivedItems,
      @JsonKey(name: 'can_approve') bool canApprove,
      @JsonKey(name: 'pdf_url') String? pdfUrl,
      @JsonKey(name: 'total_amount', fromJson: doubleOrNullFromJson)
      double? totalAmount,
      List<PurchaseOrderItem> items});
}

/// @nodoc
class _$PurchaseOrderCopyWithImpl<$Res, $Val extends PurchaseOrder>
    implements $PurchaseOrderCopyWith<$Res> {
  _$PurchaseOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? poNumber = null,
    Object? companyId = null,
    Object? warehouseId = null,
    Object? warehouseName = freezed,
    Object? supplierId = freezed,
    Object? supplierName = null,
    Object? transactionDate = null,
    Object? expectedDate = null,
    Object? paymentTerm = freezed,
    Object? status = null,
    Object? totalItems = null,
    Object? receivedItems = null,
    Object? canApprove = null,
    Object? pdfUrl = freezed,
    Object? totalAmount = freezed,
    Object? items = null,
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
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int,
      warehouseId: null == warehouseId
          ? _value.warehouseId
          : warehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      warehouseName: freezed == warehouseName
          ? _value.warehouseName
          : warehouseName // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int?,
      supplierName: null == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String,
      transactionDate: null == transactionDate
          ? _value.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as String,
      expectedDate: null == expectedDate
          ? _value.expectedDate
          : expectedDate // ignore: cast_nullable_to_non_nullable
              as String,
      paymentTerm: freezed == paymentTerm
          ? _value.paymentTerm
          : paymentTerm // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      receivedItems: null == receivedItems
          ? _value.receivedItems
          : receivedItems // ignore: cast_nullable_to_non_nullable
              as int,
      canApprove: null == canApprove
          ? _value.canApprove
          : canApprove // ignore: cast_nullable_to_non_nullable
              as bool,
      pdfUrl: freezed == pdfUrl
          ? _value.pdfUrl
          : pdfUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      totalAmount: freezed == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<PurchaseOrderItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PurchaseOrderImplCopyWith<$Res>
    implements $PurchaseOrderCopyWith<$Res> {
  factory _$$PurchaseOrderImplCopyWith(
          _$PurchaseOrderImpl value, $Res Function(_$PurchaseOrderImpl) then) =
      __$$PurchaseOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'po_number') String poNumber,
      @JsonKey(name: 'company_id') int companyId,
      @JsonKey(name: 'warehouse_id') int warehouseId,
      @JsonKey(name: 'warehouse_name') String? warehouseName,
      @JsonKey(name: 'supplier_id') int? supplierId,
      @JsonKey(name: 'supplier_name') String supplierName,
      @JsonKey(name: 'transaction_date') String transactionDate,
      @JsonKey(name: 'expected_date') String expectedDate,
      @JsonKey(name: 'payment_term') String? paymentTerm,
      String status,
      @JsonKey(name: 'total_items') int totalItems,
      @JsonKey(name: 'received_items') int receivedItems,
      @JsonKey(name: 'can_approve') bool canApprove,
      @JsonKey(name: 'pdf_url') String? pdfUrl,
      @JsonKey(name: 'total_amount', fromJson: doubleOrNullFromJson)
      double? totalAmount,
      List<PurchaseOrderItem> items});
}

/// @nodoc
class __$$PurchaseOrderImplCopyWithImpl<$Res>
    extends _$PurchaseOrderCopyWithImpl<$Res, _$PurchaseOrderImpl>
    implements _$$PurchaseOrderImplCopyWith<$Res> {
  __$$PurchaseOrderImplCopyWithImpl(
      _$PurchaseOrderImpl _value, $Res Function(_$PurchaseOrderImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? poNumber = null,
    Object? companyId = null,
    Object? warehouseId = null,
    Object? warehouseName = freezed,
    Object? supplierId = freezed,
    Object? supplierName = null,
    Object? transactionDate = null,
    Object? expectedDate = null,
    Object? paymentTerm = freezed,
    Object? status = null,
    Object? totalItems = null,
    Object? receivedItems = null,
    Object? canApprove = null,
    Object? pdfUrl = freezed,
    Object? totalAmount = freezed,
    Object? items = null,
  }) {
    return _then(_$PurchaseOrderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      poNumber: null == poNumber
          ? _value.poNumber
          : poNumber // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int,
      warehouseId: null == warehouseId
          ? _value.warehouseId
          : warehouseId // ignore: cast_nullable_to_non_nullable
              as int,
      warehouseName: freezed == warehouseName
          ? _value.warehouseName
          : warehouseName // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int?,
      supplierName: null == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String,
      transactionDate: null == transactionDate
          ? _value.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as String,
      expectedDate: null == expectedDate
          ? _value.expectedDate
          : expectedDate // ignore: cast_nullable_to_non_nullable
              as String,
      paymentTerm: freezed == paymentTerm
          ? _value.paymentTerm
          : paymentTerm // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      receivedItems: null == receivedItems
          ? _value.receivedItems
          : receivedItems // ignore: cast_nullable_to_non_nullable
              as int,
      canApprove: null == canApprove
          ? _value.canApprove
          : canApprove // ignore: cast_nullable_to_non_nullable
              as bool,
      pdfUrl: freezed == pdfUrl
          ? _value.pdfUrl
          : pdfUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      totalAmount: freezed == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<PurchaseOrderItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseOrderImpl implements _PurchaseOrder {
  const _$PurchaseOrderImpl(
      {required this.id,
      @JsonKey(name: 'po_number') required this.poNumber,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'warehouse_id') required this.warehouseId,
      @JsonKey(name: 'warehouse_name') this.warehouseName,
      @JsonKey(name: 'supplier_id') this.supplierId,
      @JsonKey(name: 'supplier_name') required this.supplierName,
      @JsonKey(name: 'transaction_date') required this.transactionDate,
      @JsonKey(name: 'expected_date') required this.expectedDate,
      @JsonKey(name: 'payment_term') this.paymentTerm,
      required this.status,
      @JsonKey(name: 'total_items') this.totalItems = 0,
      @JsonKey(name: 'received_items') this.receivedItems = 0,
      @JsonKey(name: 'can_approve') this.canApprove = false,
      @JsonKey(name: 'pdf_url') this.pdfUrl,
      @JsonKey(name: 'total_amount', fromJson: doubleOrNullFromJson)
      this.totalAmount,
      final List<PurchaseOrderItem> items = const []})
      : _items = items;

  factory _$PurchaseOrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseOrderImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'po_number')
  final String poNumber;
  @override
  @JsonKey(name: 'company_id')
  final int companyId;
  @override
  @JsonKey(name: 'warehouse_id')
  final int warehouseId;
  @override
  @JsonKey(name: 'warehouse_name')
  final String? warehouseName;
  @override
  @JsonKey(name: 'supplier_id')
  final int? supplierId;
  @override
  @JsonKey(name: 'supplier_name')
  final String supplierName;
  @override
  @JsonKey(name: 'transaction_date')
  final String transactionDate;
  @override
  @JsonKey(name: 'expected_date')
  final String expectedDate;
  @override
  @JsonKey(name: 'payment_term')
  final String? paymentTerm;
  @override
  final String status;
  @override
  @JsonKey(name: 'total_items')
  final int totalItems;
  @override
  @JsonKey(name: 'received_items')
  final int receivedItems;
  @override
  @JsonKey(name: 'can_approve')
  final bool canApprove;
  @override
  @JsonKey(name: 'pdf_url')
  final String? pdfUrl;
  @override
  @JsonKey(name: 'total_amount', fromJson: doubleOrNullFromJson)
  final double? totalAmount;
  final List<PurchaseOrderItem> _items;
  @override
  @JsonKey()
  List<PurchaseOrderItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'PurchaseOrder(id: $id, poNumber: $poNumber, companyId: $companyId, warehouseId: $warehouseId, warehouseName: $warehouseName, supplierId: $supplierId, supplierName: $supplierName, transactionDate: $transactionDate, expectedDate: $expectedDate, paymentTerm: $paymentTerm, status: $status, totalItems: $totalItems, receivedItems: $receivedItems, canApprove: $canApprove, pdfUrl: $pdfUrl, totalAmount: $totalAmount, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseOrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.poNumber, poNumber) ||
                other.poNumber == poNumber) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.warehouseId, warehouseId) ||
                other.warehouseId == warehouseId) &&
            (identical(other.warehouseName, warehouseName) ||
                other.warehouseName == warehouseName) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.expectedDate, expectedDate) ||
                other.expectedDate == expectedDate) &&
            (identical(other.paymentTerm, paymentTerm) ||
                other.paymentTerm == paymentTerm) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.receivedItems, receivedItems) ||
                other.receivedItems == receivedItems) &&
            (identical(other.canApprove, canApprove) ||
                other.canApprove == canApprove) &&
            (identical(other.pdfUrl, pdfUrl) || other.pdfUrl == pdfUrl) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      poNumber,
      companyId,
      warehouseId,
      warehouseName,
      supplierId,
      supplierName,
      transactionDate,
      expectedDate,
      paymentTerm,
      status,
      totalItems,
      receivedItems,
      canApprove,
      pdfUrl,
      totalAmount,
      const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseOrderImplCopyWith<_$PurchaseOrderImpl> get copyWith =>
      __$$PurchaseOrderImplCopyWithImpl<_$PurchaseOrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseOrderImplToJson(
      this,
    );
  }
}

abstract class _PurchaseOrder implements PurchaseOrder {
  const factory _PurchaseOrder(
      {required final int id,
      @JsonKey(name: 'po_number') required final String poNumber,
      @JsonKey(name: 'company_id') required final int companyId,
      @JsonKey(name: 'warehouse_id') required final int warehouseId,
      @JsonKey(name: 'warehouse_name') final String? warehouseName,
      @JsonKey(name: 'supplier_id') final int? supplierId,
      @JsonKey(name: 'supplier_name') required final String supplierName,
      @JsonKey(name: 'transaction_date') required final String transactionDate,
      @JsonKey(name: 'expected_date') required final String expectedDate,
      @JsonKey(name: 'payment_term') final String? paymentTerm,
      required final String status,
      @JsonKey(name: 'total_items') final int totalItems,
      @JsonKey(name: 'received_items') final int receivedItems,
      @JsonKey(name: 'can_approve') final bool canApprove,
      @JsonKey(name: 'pdf_url') final String? pdfUrl,
      @JsonKey(name: 'total_amount', fromJson: doubleOrNullFromJson)
      final double? totalAmount,
      final List<PurchaseOrderItem> items}) = _$PurchaseOrderImpl;

  factory _PurchaseOrder.fromJson(Map<String, dynamic> json) =
      _$PurchaseOrderImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'po_number')
  String get poNumber;
  @override
  @JsonKey(name: 'company_id')
  int get companyId;
  @override
  @JsonKey(name: 'warehouse_id')
  int get warehouseId;
  @override
  @JsonKey(name: 'warehouse_name')
  String? get warehouseName;
  @override
  @JsonKey(name: 'supplier_id')
  int? get supplierId;
  @override
  @JsonKey(name: 'supplier_name')
  String get supplierName;
  @override
  @JsonKey(name: 'transaction_date')
  String get transactionDate;
  @override
  @JsonKey(name: 'expected_date')
  String get expectedDate;
  @override
  @JsonKey(name: 'payment_term')
  String? get paymentTerm;
  @override
  String get status;
  @override
  @JsonKey(name: 'total_items')
  int get totalItems;
  @override
  @JsonKey(name: 'received_items')
  int get receivedItems;
  @override
  @JsonKey(name: 'can_approve')
  bool get canApprove;
  @override
  @JsonKey(name: 'pdf_url')
  String? get pdfUrl;
  @override
  @JsonKey(name: 'total_amount', fromJson: doubleOrNullFromJson)
  double? get totalAmount;
  @override
  List<PurchaseOrderItem> get items;
  @override
  @JsonKey(ignore: true)
  _$$PurchaseOrderImplCopyWith<_$PurchaseOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PurchaseOrderItem _$PurchaseOrderItemFromJson(Map<String, dynamic> json) {
  return _PurchaseOrderItem.fromJson(json);
}

/// @nodoc
mixin _$PurchaseOrderItem {
  int get id => throw _privateConstructorUsedError;
  String get sku => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name')
  String get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'ordered_qty', fromJson: doubleFromJson)
  double get orderedQty => throw _privateConstructorUsedError;
  @JsonKey(name: 'received_qty', fromJson: doubleFromJson)
  double get receivedQty => throw _privateConstructorUsedError;
  @JsonKey(name: 'remaining_qty', fromJson: doubleFromJson)
  double get remainingQty => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price', fromJson: doubleOrNullFromJson)
  double? get unitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'detail_notes')
  String? get detailNotes => throw _privateConstructorUsedError;
  @JsonKey(name: 'detail_spec')
  String? get detailSpec => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PurchaseOrderItemCopyWith<PurchaseOrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseOrderItemCopyWith<$Res> {
  factory $PurchaseOrderItemCopyWith(
          PurchaseOrderItem value, $Res Function(PurchaseOrderItem) then) =
      _$PurchaseOrderItemCopyWithImpl<$Res, PurchaseOrderItem>;
  @useResult
  $Res call(
      {int id,
      String sku,
      @JsonKey(name: 'product_name') String productName,
      @JsonKey(name: 'ordered_qty', fromJson: doubleFromJson) double orderedQty,
      @JsonKey(name: 'received_qty', fromJson: doubleFromJson)
      double receivedQty,
      @JsonKey(name: 'remaining_qty', fromJson: doubleFromJson)
      double remainingQty,
      String unit,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'unit_price', fromJson: doubleOrNullFromJson)
      double? unitPrice,
      @JsonKey(name: 'detail_notes') String? detailNotes,
      @JsonKey(name: 'detail_spec') String? detailSpec,
      int version});
}

/// @nodoc
class _$PurchaseOrderItemCopyWithImpl<$Res, $Val extends PurchaseOrderItem>
    implements $PurchaseOrderItemCopyWith<$Res> {
  _$PurchaseOrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sku = null,
    Object? productName = null,
    Object? orderedQty = null,
    Object? receivedQty = null,
    Object? remainingQty = null,
    Object? unit = null,
    Object? imageUrl = freezed,
    Object? unitPrice = freezed,
    Object? detailNotes = freezed,
    Object? detailSpec = freezed,
    Object? version = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      orderedQty: null == orderedQty
          ? _value.orderedQty
          : orderedQty // ignore: cast_nullable_to_non_nullable
              as double,
      receivedQty: null == receivedQty
          ? _value.receivedQty
          : receivedQty // ignore: cast_nullable_to_non_nullable
              as double,
      remainingQty: null == remainingQty
          ? _value.remainingQty
          : remainingQty // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      unitPrice: freezed == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      detailNotes: freezed == detailNotes
          ? _value.detailNotes
          : detailNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      detailSpec: freezed == detailSpec
          ? _value.detailSpec
          : detailSpec // ignore: cast_nullable_to_non_nullable
              as String?,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PurchaseOrderItemImplCopyWith<$Res>
    implements $PurchaseOrderItemCopyWith<$Res> {
  factory _$$PurchaseOrderItemImplCopyWith(_$PurchaseOrderItemImpl value,
          $Res Function(_$PurchaseOrderItemImpl) then) =
      __$$PurchaseOrderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String sku,
      @JsonKey(name: 'product_name') String productName,
      @JsonKey(name: 'ordered_qty', fromJson: doubleFromJson) double orderedQty,
      @JsonKey(name: 'received_qty', fromJson: doubleFromJson)
      double receivedQty,
      @JsonKey(name: 'remaining_qty', fromJson: doubleFromJson)
      double remainingQty,
      String unit,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'unit_price', fromJson: doubleOrNullFromJson)
      double? unitPrice,
      @JsonKey(name: 'detail_notes') String? detailNotes,
      @JsonKey(name: 'detail_spec') String? detailSpec,
      int version});
}

/// @nodoc
class __$$PurchaseOrderItemImplCopyWithImpl<$Res>
    extends _$PurchaseOrderItemCopyWithImpl<$Res, _$PurchaseOrderItemImpl>
    implements _$$PurchaseOrderItemImplCopyWith<$Res> {
  __$$PurchaseOrderItemImplCopyWithImpl(_$PurchaseOrderItemImpl _value,
      $Res Function(_$PurchaseOrderItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sku = null,
    Object? productName = null,
    Object? orderedQty = null,
    Object? receivedQty = null,
    Object? remainingQty = null,
    Object? unit = null,
    Object? imageUrl = freezed,
    Object? unitPrice = freezed,
    Object? detailNotes = freezed,
    Object? detailSpec = freezed,
    Object? version = null,
  }) {
    return _then(_$PurchaseOrderItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      orderedQty: null == orderedQty
          ? _value.orderedQty
          : orderedQty // ignore: cast_nullable_to_non_nullable
              as double,
      receivedQty: null == receivedQty
          ? _value.receivedQty
          : receivedQty // ignore: cast_nullable_to_non_nullable
              as double,
      remainingQty: null == remainingQty
          ? _value.remainingQty
          : remainingQty // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      unitPrice: freezed == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      detailNotes: freezed == detailNotes
          ? _value.detailNotes
          : detailNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      detailSpec: freezed == detailSpec
          ? _value.detailSpec
          : detailSpec // ignore: cast_nullable_to_non_nullable
              as String?,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseOrderItemImpl implements _PurchaseOrderItem {
  const _$PurchaseOrderItemImpl(
      {required this.id,
      required this.sku,
      @JsonKey(name: 'product_name') required this.productName,
      @JsonKey(name: 'ordered_qty', fromJson: doubleFromJson)
      required this.orderedQty,
      @JsonKey(name: 'received_qty', fromJson: doubleFromJson)
      required this.receivedQty,
      @JsonKey(name: 'remaining_qty', fromJson: doubleFromJson)
      required this.remainingQty,
      required this.unit,
      @JsonKey(name: 'image_url') this.imageUrl,
      @JsonKey(name: 'unit_price', fromJson: doubleOrNullFromJson)
      this.unitPrice,
      @JsonKey(name: 'detail_notes') this.detailNotes,
      @JsonKey(name: 'detail_spec') this.detailSpec,
      this.version = 0});

  factory _$PurchaseOrderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseOrderItemImplFromJson(json);

  @override
  final int id;
  @override
  final String sku;
  @override
  @JsonKey(name: 'product_name')
  final String productName;
  @override
  @JsonKey(name: 'ordered_qty', fromJson: doubleFromJson)
  final double orderedQty;
  @override
  @JsonKey(name: 'received_qty', fromJson: doubleFromJson)
  final double receivedQty;
  @override
  @JsonKey(name: 'remaining_qty', fromJson: doubleFromJson)
  final double remainingQty;
  @override
  final String unit;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @JsonKey(name: 'unit_price', fromJson: doubleOrNullFromJson)
  final double? unitPrice;
  @override
  @JsonKey(name: 'detail_notes')
  final String? detailNotes;
  @override
  @JsonKey(name: 'detail_spec')
  final String? detailSpec;
  @override
  @JsonKey()
  final int version;

  @override
  String toString() {
    return 'PurchaseOrderItem(id: $id, sku: $sku, productName: $productName, orderedQty: $orderedQty, receivedQty: $receivedQty, remainingQty: $remainingQty, unit: $unit, imageUrl: $imageUrl, unitPrice: $unitPrice, detailNotes: $detailNotes, detailSpec: $detailSpec, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseOrderItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.orderedQty, orderedQty) ||
                other.orderedQty == orderedQty) &&
            (identical(other.receivedQty, receivedQty) ||
                other.receivedQty == receivedQty) &&
            (identical(other.remainingQty, remainingQty) ||
                other.remainingQty == remainingQty) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.detailNotes, detailNotes) ||
                other.detailNotes == detailNotes) &&
            (identical(other.detailSpec, detailSpec) ||
                other.detailSpec == detailSpec) &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sku,
      productName,
      orderedQty,
      receivedQty,
      remainingQty,
      unit,
      imageUrl,
      unitPrice,
      detailNotes,
      detailSpec,
      version);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseOrderItemImplCopyWith<_$PurchaseOrderItemImpl> get copyWith =>
      __$$PurchaseOrderItemImplCopyWithImpl<_$PurchaseOrderItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseOrderItemImplToJson(
      this,
    );
  }
}

abstract class _PurchaseOrderItem implements PurchaseOrderItem {
  const factory _PurchaseOrderItem(
      {required final int id,
      required final String sku,
      @JsonKey(name: 'product_name') required final String productName,
      @JsonKey(name: 'ordered_qty', fromJson: doubleFromJson)
      required final double orderedQty,
      @JsonKey(name: 'received_qty', fromJson: doubleFromJson)
      required final double receivedQty,
      @JsonKey(name: 'remaining_qty', fromJson: doubleFromJson)
      required final double remainingQty,
      required final String unit,
      @JsonKey(name: 'image_url') final String? imageUrl,
      @JsonKey(name: 'unit_price', fromJson: doubleOrNullFromJson)
      final double? unitPrice,
      @JsonKey(name: 'detail_notes') final String? detailNotes,
      @JsonKey(name: 'detail_spec') final String? detailSpec,
      final int version}) = _$PurchaseOrderItemImpl;

  factory _PurchaseOrderItem.fromJson(Map<String, dynamic> json) =
      _$PurchaseOrderItemImpl.fromJson;

  @override
  int get id;
  @override
  String get sku;
  @override
  @JsonKey(name: 'product_name')
  String get productName;
  @override
  @JsonKey(name: 'ordered_qty', fromJson: doubleFromJson)
  double get orderedQty;
  @override
  @JsonKey(name: 'received_qty', fromJson: doubleFromJson)
  double get receivedQty;
  @override
  @JsonKey(name: 'remaining_qty', fromJson: doubleFromJson)
  double get remainingQty;
  @override
  String get unit;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'unit_price', fromJson: doubleOrNullFromJson)
  double? get unitPrice;
  @override
  @JsonKey(name: 'detail_notes')
  String? get detailNotes;
  @override
  @JsonKey(name: 'detail_spec')
  String? get detailSpec;
  @override
  int get version;
  @override
  @JsonKey(ignore: true)
  _$$PurchaseOrderItemImplCopyWith<_$PurchaseOrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
