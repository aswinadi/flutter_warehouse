// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_mutation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StockMutationSummary _$StockMutationSummaryFromJson(Map<String, dynamic> json) {
  return _StockMutationSummary.fromJson(json);
}

/// @nodoc
mixin _$StockMutationSummary {
  String get sku => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name')
  String get productName => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'initial_balance')
  int get initialBalance => throw _privateConstructorUsedError;
  @JsonKey(name: 'period_in')
  int get periodIn => throw _privateConstructorUsedError;
  @JsonKey(name: 'period_out')
  int get periodOut => throw _privateConstructorUsedError;
  @JsonKey(name: 'ending_balance')
  int get endingBalance => throw _privateConstructorUsedError;
  List<dynamic> get packagings => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StockMutationSummaryCopyWith<StockMutationSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockMutationSummaryCopyWith<$Res> {
  factory $StockMutationSummaryCopyWith(StockMutationSummary value,
          $Res Function(StockMutationSummary) then) =
      _$StockMutationSummaryCopyWithImpl<$Res, StockMutationSummary>;
  @useResult
  $Res call(
      {String sku,
      @JsonKey(name: 'product_name') String productName,
      String unit,
      @JsonKey(name: 'initial_balance') int initialBalance,
      @JsonKey(name: 'period_in') int periodIn,
      @JsonKey(name: 'period_out') int periodOut,
      @JsonKey(name: 'ending_balance') int endingBalance,
      List<dynamic> packagings});
}

/// @nodoc
class _$StockMutationSummaryCopyWithImpl<$Res,
        $Val extends StockMutationSummary>
    implements $StockMutationSummaryCopyWith<$Res> {
  _$StockMutationSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sku = null,
    Object? productName = null,
    Object? unit = null,
    Object? initialBalance = null,
    Object? periodIn = null,
    Object? periodOut = null,
    Object? endingBalance = null,
    Object? packagings = null,
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
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      initialBalance: null == initialBalance
          ? _value.initialBalance
          : initialBalance // ignore: cast_nullable_to_non_nullable
              as int,
      periodIn: null == periodIn
          ? _value.periodIn
          : periodIn // ignore: cast_nullable_to_non_nullable
              as int,
      periodOut: null == periodOut
          ? _value.periodOut
          : periodOut // ignore: cast_nullable_to_non_nullable
              as int,
      endingBalance: null == endingBalance
          ? _value.endingBalance
          : endingBalance // ignore: cast_nullable_to_non_nullable
              as int,
      packagings: null == packagings
          ? _value.packagings
          : packagings // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StockMutationSummaryImplCopyWith<$Res>
    implements $StockMutationSummaryCopyWith<$Res> {
  factory _$$StockMutationSummaryImplCopyWith(_$StockMutationSummaryImpl value,
          $Res Function(_$StockMutationSummaryImpl) then) =
      __$$StockMutationSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sku,
      @JsonKey(name: 'product_name') String productName,
      String unit,
      @JsonKey(name: 'initial_balance') int initialBalance,
      @JsonKey(name: 'period_in') int periodIn,
      @JsonKey(name: 'period_out') int periodOut,
      @JsonKey(name: 'ending_balance') int endingBalance,
      List<dynamic> packagings});
}

/// @nodoc
class __$$StockMutationSummaryImplCopyWithImpl<$Res>
    extends _$StockMutationSummaryCopyWithImpl<$Res, _$StockMutationSummaryImpl>
    implements _$$StockMutationSummaryImplCopyWith<$Res> {
  __$$StockMutationSummaryImplCopyWithImpl(_$StockMutationSummaryImpl _value,
      $Res Function(_$StockMutationSummaryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sku = null,
    Object? productName = null,
    Object? unit = null,
    Object? initialBalance = null,
    Object? periodIn = null,
    Object? periodOut = null,
    Object? endingBalance = null,
    Object? packagings = null,
  }) {
    return _then(_$StockMutationSummaryImpl(
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      initialBalance: null == initialBalance
          ? _value.initialBalance
          : initialBalance // ignore: cast_nullable_to_non_nullable
              as int,
      periodIn: null == periodIn
          ? _value.periodIn
          : periodIn // ignore: cast_nullable_to_non_nullable
              as int,
      periodOut: null == periodOut
          ? _value.periodOut
          : periodOut // ignore: cast_nullable_to_non_nullable
              as int,
      endingBalance: null == endingBalance
          ? _value.endingBalance
          : endingBalance // ignore: cast_nullable_to_non_nullable
              as int,
      packagings: null == packagings
          ? _value._packagings
          : packagings // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockMutationSummaryImpl implements _StockMutationSummary {
  const _$StockMutationSummaryImpl(
      {required this.sku,
      @JsonKey(name: 'product_name') required this.productName,
      required this.unit,
      @JsonKey(name: 'initial_balance') required this.initialBalance,
      @JsonKey(name: 'period_in') required this.periodIn,
      @JsonKey(name: 'period_out') required this.periodOut,
      @JsonKey(name: 'ending_balance') required this.endingBalance,
      final List<dynamic> packagings = const []})
      : _packagings = packagings;

  factory _$StockMutationSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockMutationSummaryImplFromJson(json);

  @override
  final String sku;
  @override
  @JsonKey(name: 'product_name')
  final String productName;
  @override
  final String unit;
  @override
  @JsonKey(name: 'initial_balance')
  final int initialBalance;
  @override
  @JsonKey(name: 'period_in')
  final int periodIn;
  @override
  @JsonKey(name: 'period_out')
  final int periodOut;
  @override
  @JsonKey(name: 'ending_balance')
  final int endingBalance;
  final List<dynamic> _packagings;
  @override
  @JsonKey()
  List<dynamic> get packagings {
    if (_packagings is EqualUnmodifiableListView) return _packagings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_packagings);
  }

  @override
  String toString() {
    return 'StockMutationSummary(sku: $sku, productName: $productName, unit: $unit, initialBalance: $initialBalance, periodIn: $periodIn, periodOut: $periodOut, endingBalance: $endingBalance, packagings: $packagings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockMutationSummaryImpl &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.initialBalance, initialBalance) ||
                other.initialBalance == initialBalance) &&
            (identical(other.periodIn, periodIn) ||
                other.periodIn == periodIn) &&
            (identical(other.periodOut, periodOut) ||
                other.periodOut == periodOut) &&
            (identical(other.endingBalance, endingBalance) ||
                other.endingBalance == endingBalance) &&
            const DeepCollectionEquality()
                .equals(other._packagings, _packagings));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      sku,
      productName,
      unit,
      initialBalance,
      periodIn,
      periodOut,
      endingBalance,
      const DeepCollectionEquality().hash(_packagings));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StockMutationSummaryImplCopyWith<_$StockMutationSummaryImpl>
      get copyWith =>
          __$$StockMutationSummaryImplCopyWithImpl<_$StockMutationSummaryImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockMutationSummaryImplToJson(
      this,
    );
  }
}

abstract class _StockMutationSummary implements StockMutationSummary {
  const factory _StockMutationSummary(
      {required final String sku,
      @JsonKey(name: 'product_name') required final String productName,
      required final String unit,
      @JsonKey(name: 'initial_balance') required final int initialBalance,
      @JsonKey(name: 'period_in') required final int periodIn,
      @JsonKey(name: 'period_out') required final int periodOut,
      @JsonKey(name: 'ending_balance') required final int endingBalance,
      final List<dynamic> packagings}) = _$StockMutationSummaryImpl;

  factory _StockMutationSummary.fromJson(Map<String, dynamic> json) =
      _$StockMutationSummaryImpl.fromJson;

  @override
  String get sku;
  @override
  @JsonKey(name: 'product_name')
  String get productName;
  @override
  String get unit;
  @override
  @JsonKey(name: 'initial_balance')
  int get initialBalance;
  @override
  @JsonKey(name: 'period_in')
  int get periodIn;
  @override
  @JsonKey(name: 'period_out')
  int get periodOut;
  @override
  @JsonKey(name: 'ending_balance')
  int get endingBalance;
  @override
  List<dynamic> get packagings;
  @override
  @JsonKey(ignore: true)
  _$$StockMutationSummaryImplCopyWith<_$StockMutationSummaryImpl>
      get copyWith => throw _privateConstructorUsedError;
}

StockMutationDetail _$StockMutationDetailFromJson(Map<String, dynamic> json) {
  return _StockMutationDetail.fromJson(json);
}

/// @nodoc
mixin _$StockMutationDetail {
  int get id => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get sku => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name')
  String get productName => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  @JsonKey(fromJson: stringOrNullFromJson)
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'ref_number', fromJson: stringOrNullFromJson)
  String? get refNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'in_qty', fromJson: doubleFromJson)
  double get inQty => throw _privateConstructorUsedError;
  @JsonKey(name: 'out_qty', fromJson: doubleFromJson)
  double get outQty => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StockMutationDetailCopyWith<StockMutationDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockMutationDetailCopyWith<$Res> {
  factory $StockMutationDetailCopyWith(
          StockMutationDetail value, $Res Function(StockMutationDetail) then) =
      _$StockMutationDetailCopyWithImpl<$Res, StockMutationDetail>;
  @useResult
  $Res call(
      {int id,
      String date,
      String type,
      String sku,
      @JsonKey(name: 'product_name') String productName,
      String unit,
      @JsonKey(fromJson: stringOrNullFromJson) String? description,
      @JsonKey(name: 'ref_number', fromJson: stringOrNullFromJson)
      String? refNumber,
      @JsonKey(name: 'in_qty', fromJson: doubleFromJson) double inQty,
      @JsonKey(name: 'out_qty', fromJson: doubleFromJson) double outQty});
}

/// @nodoc
class _$StockMutationDetailCopyWithImpl<$Res, $Val extends StockMutationDetail>
    implements $StockMutationDetailCopyWith<$Res> {
  _$StockMutationDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? type = null,
    Object? sku = null,
    Object? productName = null,
    Object? unit = null,
    Object? description = freezed,
    Object? refNumber = freezed,
    Object? inQty = null,
    Object? outQty = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      refNumber: freezed == refNumber
          ? _value.refNumber
          : refNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      inQty: null == inQty
          ? _value.inQty
          : inQty // ignore: cast_nullable_to_non_nullable
              as double,
      outQty: null == outQty
          ? _value.outQty
          : outQty // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StockMutationDetailImplCopyWith<$Res>
    implements $StockMutationDetailCopyWith<$Res> {
  factory _$$StockMutationDetailImplCopyWith(_$StockMutationDetailImpl value,
          $Res Function(_$StockMutationDetailImpl) then) =
      __$$StockMutationDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String date,
      String type,
      String sku,
      @JsonKey(name: 'product_name') String productName,
      String unit,
      @JsonKey(fromJson: stringOrNullFromJson) String? description,
      @JsonKey(name: 'ref_number', fromJson: stringOrNullFromJson)
      String? refNumber,
      @JsonKey(name: 'in_qty', fromJson: doubleFromJson) double inQty,
      @JsonKey(name: 'out_qty', fromJson: doubleFromJson) double outQty});
}

/// @nodoc
class __$$StockMutationDetailImplCopyWithImpl<$Res>
    extends _$StockMutationDetailCopyWithImpl<$Res, _$StockMutationDetailImpl>
    implements _$$StockMutationDetailImplCopyWith<$Res> {
  __$$StockMutationDetailImplCopyWithImpl(_$StockMutationDetailImpl _value,
      $Res Function(_$StockMutationDetailImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? type = null,
    Object? sku = null,
    Object? productName = null,
    Object? unit = null,
    Object? description = freezed,
    Object? refNumber = freezed,
    Object? inQty = null,
    Object? outQty = null,
  }) {
    return _then(_$StockMutationDetailImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      sku: null == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      refNumber: freezed == refNumber
          ? _value.refNumber
          : refNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      inQty: null == inQty
          ? _value.inQty
          : inQty // ignore: cast_nullable_to_non_nullable
              as double,
      outQty: null == outQty
          ? _value.outQty
          : outQty // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockMutationDetailImpl implements _StockMutationDetail {
  const _$StockMutationDetailImpl(
      {required this.id,
      required this.date,
      required this.type,
      required this.sku,
      @JsonKey(name: 'product_name') required this.productName,
      required this.unit,
      @JsonKey(fromJson: stringOrNullFromJson) this.description,
      @JsonKey(name: 'ref_number', fromJson: stringOrNullFromJson)
      this.refNumber,
      @JsonKey(name: 'in_qty', fromJson: doubleFromJson) required this.inQty,
      @JsonKey(name: 'out_qty', fromJson: doubleFromJson)
      required this.outQty});

  factory _$StockMutationDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockMutationDetailImplFromJson(json);

  @override
  final int id;
  @override
  final String date;
  @override
  final String type;
  @override
  final String sku;
  @override
  @JsonKey(name: 'product_name')
  final String productName;
  @override
  final String unit;
  @override
  @JsonKey(fromJson: stringOrNullFromJson)
  final String? description;
  @override
  @JsonKey(name: 'ref_number', fromJson: stringOrNullFromJson)
  final String? refNumber;
  @override
  @JsonKey(name: 'in_qty', fromJson: doubleFromJson)
  final double inQty;
  @override
  @JsonKey(name: 'out_qty', fromJson: doubleFromJson)
  final double outQty;

  @override
  String toString() {
    return 'StockMutationDetail(id: $id, date: $date, type: $type, sku: $sku, productName: $productName, unit: $unit, description: $description, refNumber: $refNumber, inQty: $inQty, outQty: $outQty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockMutationDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.refNumber, refNumber) ||
                other.refNumber == refNumber) &&
            (identical(other.inQty, inQty) || other.inQty == inQty) &&
            (identical(other.outQty, outQty) || other.outQty == outQty));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, date, type, sku, productName,
      unit, description, refNumber, inQty, outQty);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StockMutationDetailImplCopyWith<_$StockMutationDetailImpl> get copyWith =>
      __$$StockMutationDetailImplCopyWithImpl<_$StockMutationDetailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockMutationDetailImplToJson(
      this,
    );
  }
}

abstract class _StockMutationDetail implements StockMutationDetail {
  const factory _StockMutationDetail(
      {required final int id,
      required final String date,
      required final String type,
      required final String sku,
      @JsonKey(name: 'product_name') required final String productName,
      required final String unit,
      @JsonKey(fromJson: stringOrNullFromJson) final String? description,
      @JsonKey(name: 'ref_number', fromJson: stringOrNullFromJson)
      final String? refNumber,
      @JsonKey(name: 'in_qty', fromJson: doubleFromJson)
      required final double inQty,
      @JsonKey(name: 'out_qty', fromJson: doubleFromJson)
      required final double outQty}) = _$StockMutationDetailImpl;

  factory _StockMutationDetail.fromJson(Map<String, dynamic> json) =
      _$StockMutationDetailImpl.fromJson;

  @override
  int get id;
  @override
  String get date;
  @override
  String get type;
  @override
  String get sku;
  @override
  @JsonKey(name: 'product_name')
  String get productName;
  @override
  String get unit;
  @override
  @JsonKey(fromJson: stringOrNullFromJson)
  String? get description;
  @override
  @JsonKey(name: 'ref_number', fromJson: stringOrNullFromJson)
  String? get refNumber;
  @override
  @JsonKey(name: 'in_qty', fromJson: doubleFromJson)
  double get inQty;
  @override
  @JsonKey(name: 'out_qty', fromJson: doubleFromJson)
  double get outQty;
  @override
  @JsonKey(ignore: true)
  _$$StockMutationDetailImplCopyWith<_$StockMutationDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StockMutationHeader _$StockMutationHeaderFromJson(Map<String, dynamic> json) {
  return _StockMutationHeader.fromJson(json);
}

/// @nodoc
mixin _$StockMutationHeader {
  @JsonKey(name: 'initial_balance')
  int get initialBalance => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_in')
  int get totalIn => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_out')
  int get totalOut => throw _privateConstructorUsedError;
  @JsonKey(name: 'ending_balance')
  int get endingBalance => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StockMutationHeaderCopyWith<StockMutationHeader> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StockMutationHeaderCopyWith<$Res> {
  factory $StockMutationHeaderCopyWith(
          StockMutationHeader value, $Res Function(StockMutationHeader) then) =
      _$StockMutationHeaderCopyWithImpl<$Res, StockMutationHeader>;
  @useResult
  $Res call(
      {@JsonKey(name: 'initial_balance') int initialBalance,
      @JsonKey(name: 'total_in') int totalIn,
      @JsonKey(name: 'total_out') int totalOut,
      @JsonKey(name: 'ending_balance') int endingBalance});
}

/// @nodoc
class _$StockMutationHeaderCopyWithImpl<$Res, $Val extends StockMutationHeader>
    implements $StockMutationHeaderCopyWith<$Res> {
  _$StockMutationHeaderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? initialBalance = null,
    Object? totalIn = null,
    Object? totalOut = null,
    Object? endingBalance = null,
  }) {
    return _then(_value.copyWith(
      initialBalance: null == initialBalance
          ? _value.initialBalance
          : initialBalance // ignore: cast_nullable_to_non_nullable
              as int,
      totalIn: null == totalIn
          ? _value.totalIn
          : totalIn // ignore: cast_nullable_to_non_nullable
              as int,
      totalOut: null == totalOut
          ? _value.totalOut
          : totalOut // ignore: cast_nullable_to_non_nullable
              as int,
      endingBalance: null == endingBalance
          ? _value.endingBalance
          : endingBalance // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StockMutationHeaderImplCopyWith<$Res>
    implements $StockMutationHeaderCopyWith<$Res> {
  factory _$$StockMutationHeaderImplCopyWith(_$StockMutationHeaderImpl value,
          $Res Function(_$StockMutationHeaderImpl) then) =
      __$$StockMutationHeaderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'initial_balance') int initialBalance,
      @JsonKey(name: 'total_in') int totalIn,
      @JsonKey(name: 'total_out') int totalOut,
      @JsonKey(name: 'ending_balance') int endingBalance});
}

/// @nodoc
class __$$StockMutationHeaderImplCopyWithImpl<$Res>
    extends _$StockMutationHeaderCopyWithImpl<$Res, _$StockMutationHeaderImpl>
    implements _$$StockMutationHeaderImplCopyWith<$Res> {
  __$$StockMutationHeaderImplCopyWithImpl(_$StockMutationHeaderImpl _value,
      $Res Function(_$StockMutationHeaderImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? initialBalance = null,
    Object? totalIn = null,
    Object? totalOut = null,
    Object? endingBalance = null,
  }) {
    return _then(_$StockMutationHeaderImpl(
      initialBalance: null == initialBalance
          ? _value.initialBalance
          : initialBalance // ignore: cast_nullable_to_non_nullable
              as int,
      totalIn: null == totalIn
          ? _value.totalIn
          : totalIn // ignore: cast_nullable_to_non_nullable
              as int,
      totalOut: null == totalOut
          ? _value.totalOut
          : totalOut // ignore: cast_nullable_to_non_nullable
              as int,
      endingBalance: null == endingBalance
          ? _value.endingBalance
          : endingBalance // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StockMutationHeaderImpl implements _StockMutationHeader {
  const _$StockMutationHeaderImpl(
      {@JsonKey(name: 'initial_balance') required this.initialBalance,
      @JsonKey(name: 'total_in') required this.totalIn,
      @JsonKey(name: 'total_out') required this.totalOut,
      @JsonKey(name: 'ending_balance') required this.endingBalance});

  factory _$StockMutationHeaderImpl.fromJson(Map<String, dynamic> json) =>
      _$$StockMutationHeaderImplFromJson(json);

  @override
  @JsonKey(name: 'initial_balance')
  final int initialBalance;
  @override
  @JsonKey(name: 'total_in')
  final int totalIn;
  @override
  @JsonKey(name: 'total_out')
  final int totalOut;
  @override
  @JsonKey(name: 'ending_balance')
  final int endingBalance;

  @override
  String toString() {
    return 'StockMutationHeader(initialBalance: $initialBalance, totalIn: $totalIn, totalOut: $totalOut, endingBalance: $endingBalance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StockMutationHeaderImpl &&
            (identical(other.initialBalance, initialBalance) ||
                other.initialBalance == initialBalance) &&
            (identical(other.totalIn, totalIn) || other.totalIn == totalIn) &&
            (identical(other.totalOut, totalOut) ||
                other.totalOut == totalOut) &&
            (identical(other.endingBalance, endingBalance) ||
                other.endingBalance == endingBalance));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, initialBalance, totalIn, totalOut, endingBalance);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StockMutationHeaderImplCopyWith<_$StockMutationHeaderImpl> get copyWith =>
      __$$StockMutationHeaderImplCopyWithImpl<_$StockMutationHeaderImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StockMutationHeaderImplToJson(
      this,
    );
  }
}

abstract class _StockMutationHeader implements StockMutationHeader {
  const factory _StockMutationHeader(
          {@JsonKey(name: 'initial_balance') required final int initialBalance,
          @JsonKey(name: 'total_in') required final int totalIn,
          @JsonKey(name: 'total_out') required final int totalOut,
          @JsonKey(name: 'ending_balance') required final int endingBalance}) =
      _$StockMutationHeaderImpl;

  factory _StockMutationHeader.fromJson(Map<String, dynamic> json) =
      _$StockMutationHeaderImpl.fromJson;

  @override
  @JsonKey(name: 'initial_balance')
  int get initialBalance;
  @override
  @JsonKey(name: 'total_in')
  int get totalIn;
  @override
  @JsonKey(name: 'total_out')
  int get totalOut;
  @override
  @JsonKey(name: 'ending_balance')
  int get endingBalance;
  @override
  @JsonKey(ignore: true)
  _$$StockMutationHeaderImplCopyWith<_$StockMutationHeaderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
