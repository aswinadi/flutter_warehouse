// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AquacultureCycle _$AquacultureCycleFromJson(Map<String, dynamic> json) {
  return _AquacultureCycle.fromJson(json);
}

/// @nodoc
mixin _$AquacultureCycle {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  int get companyId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'stocking_date')
  String? get stockingDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AquacultureCycleCopyWith<AquacultureCycle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AquacultureCycleCopyWith<$Res> {
  factory $AquacultureCycleCopyWith(
          AquacultureCycle value, $Res Function(AquacultureCycle) then) =
      _$AquacultureCycleCopyWithImpl<$Res, AquacultureCycle>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'company_id') int companyId,
      String name,
      @JsonKey(name: 'stocking_date') String? stockingDate,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class _$AquacultureCycleCopyWithImpl<$Res, $Val extends AquacultureCycle>
    implements $AquacultureCycleCopyWith<$Res> {
  _$AquacultureCycleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? name = null,
    Object? stockingDate = freezed,
    Object? isActive = null,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      stockingDate: freezed == stockingDate
          ? _value.stockingDate
          : stockingDate // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AquacultureCycleImplCopyWith<$Res>
    implements $AquacultureCycleCopyWith<$Res> {
  factory _$$AquacultureCycleImplCopyWith(_$AquacultureCycleImpl value,
          $Res Function(_$AquacultureCycleImpl) then) =
      __$$AquacultureCycleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'company_id') int companyId,
      String name,
      @JsonKey(name: 'stocking_date') String? stockingDate,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class __$$AquacultureCycleImplCopyWithImpl<$Res>
    extends _$AquacultureCycleCopyWithImpl<$Res, _$AquacultureCycleImpl>
    implements _$$AquacultureCycleImplCopyWith<$Res> {
  __$$AquacultureCycleImplCopyWithImpl(_$AquacultureCycleImpl _value,
      $Res Function(_$AquacultureCycleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? name = null,
    Object? stockingDate = freezed,
    Object? isActive = null,
  }) {
    return _then(_$AquacultureCycleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      stockingDate: freezed == stockingDate
          ? _value.stockingDate
          : stockingDate // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AquacultureCycleImpl implements _AquacultureCycle {
  const _$AquacultureCycleImpl(
      {required this.id,
      @JsonKey(name: 'company_id') required this.companyId,
      required this.name,
      @JsonKey(name: 'stocking_date') this.stockingDate,
      @JsonKey(name: 'is_active') required this.isActive});

  factory _$AquacultureCycleImpl.fromJson(Map<String, dynamic> json) =>
      _$$AquacultureCycleImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'company_id')
  final int companyId;
  @override
  final String name;
  @override
  @JsonKey(name: 'stocking_date')
  final String? stockingDate;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'AquacultureCycle(id: $id, companyId: $companyId, name: $name, stockingDate: $stockingDate, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AquacultureCycleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.stockingDate, stockingDate) ||
                other.stockingDate == stockingDate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, companyId, name, stockingDate, isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AquacultureCycleImplCopyWith<_$AquacultureCycleImpl> get copyWith =>
      __$$AquacultureCycleImplCopyWithImpl<_$AquacultureCycleImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AquacultureCycleImplToJson(
      this,
    );
  }
}

abstract class _AquacultureCycle implements AquacultureCycle {
  const factory _AquacultureCycle(
          {required final int id,
          @JsonKey(name: 'company_id') required final int companyId,
          required final String name,
          @JsonKey(name: 'stocking_date') final String? stockingDate,
          @JsonKey(name: 'is_active') required final bool isActive}) =
      _$AquacultureCycleImpl;

  factory _AquacultureCycle.fromJson(Map<String, dynamic> json) =
      _$AquacultureCycleImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'company_id')
  int get companyId;
  @override
  String get name;
  @override
  @JsonKey(name: 'stocking_date')
  String? get stockingDate;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$AquacultureCycleImplCopyWith<_$AquacultureCycleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AquaculturePond _$AquaculturePondFromJson(Map<String, dynamic> json) {
  return _AquaculturePond.fromJson(json);
}

/// @nodoc
mixin _$AquaculturePond {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get code => throw _privateConstructorUsedError;
  double? get length => throw _privateConstructorUsedError;
  double? get width => throw _privateConstructorUsedError;
  double? get depth => throw _privateConstructorUsedError;
  @JsonKey(name: 'modul_id')
  int? get modulId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AquaculturePondCopyWith<AquaculturePond> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AquaculturePondCopyWith<$Res> {
  factory $AquaculturePondCopyWith(
          AquaculturePond value, $Res Function(AquaculturePond) then) =
      _$AquaculturePondCopyWithImpl<$Res, AquaculturePond>;
  @useResult
  $Res call(
      {int id,
      String name,
      String? code,
      double? length,
      double? width,
      double? depth,
      @JsonKey(name: 'modul_id') int? modulId});
}

/// @nodoc
class _$AquaculturePondCopyWithImpl<$Res, $Val extends AquaculturePond>
    implements $AquaculturePondCopyWith<$Res> {
  _$AquaculturePondCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = freezed,
    Object? length = freezed,
    Object? width = freezed,
    Object? depth = freezed,
    Object? modulId = freezed,
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
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      length: freezed == length
          ? _value.length
          : length // ignore: cast_nullable_to_non_nullable
              as double?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double?,
      depth: freezed == depth
          ? _value.depth
          : depth // ignore: cast_nullable_to_non_nullable
              as double?,
      modulId: freezed == modulId
          ? _value.modulId
          : modulId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AquaculturePondImplCopyWith<$Res>
    implements $AquaculturePondCopyWith<$Res> {
  factory _$$AquaculturePondImplCopyWith(_$AquaculturePondImpl value,
          $Res Function(_$AquaculturePondImpl) then) =
      __$$AquaculturePondImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String? code,
      double? length,
      double? width,
      double? depth,
      @JsonKey(name: 'modul_id') int? modulId});
}

/// @nodoc
class __$$AquaculturePondImplCopyWithImpl<$Res>
    extends _$AquaculturePondCopyWithImpl<$Res, _$AquaculturePondImpl>
    implements _$$AquaculturePondImplCopyWith<$Res> {
  __$$AquaculturePondImplCopyWithImpl(
      _$AquaculturePondImpl _value, $Res Function(_$AquaculturePondImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = freezed,
    Object? length = freezed,
    Object? width = freezed,
    Object? depth = freezed,
    Object? modulId = freezed,
  }) {
    return _then(_$AquaculturePondImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      length: freezed == length
          ? _value.length
          : length // ignore: cast_nullable_to_non_nullable
              as double?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double?,
      depth: freezed == depth
          ? _value.depth
          : depth // ignore: cast_nullable_to_non_nullable
              as double?,
      modulId: freezed == modulId
          ? _value.modulId
          : modulId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AquaculturePondImpl implements _AquaculturePond {
  const _$AquaculturePondImpl(
      {required this.id,
      required this.name,
      this.code,
      this.length,
      this.width,
      this.depth,
      @JsonKey(name: 'modul_id') this.modulId});

  factory _$AquaculturePondImpl.fromJson(Map<String, dynamic> json) =>
      _$$AquaculturePondImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? code;
  @override
  final double? length;
  @override
  final double? width;
  @override
  final double? depth;
  @override
  @JsonKey(name: 'modul_id')
  final int? modulId;

  @override
  String toString() {
    return 'AquaculturePond(id: $id, name: $name, code: $code, length: $length, width: $width, depth: $depth, modulId: $modulId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AquaculturePondImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.length, length) || other.length == length) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.depth, depth) || other.depth == depth) &&
            (identical(other.modulId, modulId) || other.modulId == modulId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, code, length, width, depth, modulId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AquaculturePondImplCopyWith<_$AquaculturePondImpl> get copyWith =>
      __$$AquaculturePondImplCopyWithImpl<_$AquaculturePondImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AquaculturePondImplToJson(
      this,
    );
  }
}

abstract class _AquaculturePond implements AquaculturePond {
  const factory _AquaculturePond(
      {required final int id,
      required final String name,
      final String? code,
      final double? length,
      final double? width,
      final double? depth,
      @JsonKey(name: 'modul_id') final int? modulId}) = _$AquaculturePondImpl;

  factory _AquaculturePond.fromJson(Map<String, dynamic> json) =
      _$AquaculturePondImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get code;
  @override
  double? get length;
  @override
  double? get width;
  @override
  double? get depth;
  @override
  @JsonKey(name: 'modul_id')
  int? get modulId;
  @override
  @JsonKey(ignore: true)
  _$$AquaculturePondImplCopyWith<_$AquaculturePondImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FeedLog _$FeedLogFromJson(Map<String, dynamic> json) {
  return _FeedLog.fromJson(json);
}

/// @nodoc
mixin _$FeedLog {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'cycle_id')
  int get cycleId => throw _privateConstructorUsedError;
  @JsonKey(name: 'cycle_name')
  String? get cycleName => throw _privateConstructorUsedError;
  @JsonKey(name: 'pond_id')
  int get pondId => throw _privateConstructorUsedError;
  @JsonKey(name: 'pond_name')
  String? get pondName => throw _privateConstructorUsedError;
  @JsonKey(name: 'tambak_name')
  String? get tambakName => throw _privateConstructorUsedError;
  @JsonKey(name: 'blok_name')
  String? get blokName => throw _privateConstructorUsedError;
  @JsonKey(name: 'modul_name')
  String? get modulName => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'feed_code')
  String? get feedCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_kg')
  double get amountKg => throw _privateConstructorUsedError;
  int? get doc => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedLogCopyWith<FeedLog> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedLogCopyWith<$Res> {
  factory $FeedLogCopyWith(FeedLog value, $Res Function(FeedLog) then) =
      _$FeedLogCopyWithImpl<$Res, FeedLog>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'cycle_id') int cycleId,
      @JsonKey(name: 'cycle_name') String? cycleName,
      @JsonKey(name: 'pond_id') int pondId,
      @JsonKey(name: 'pond_name') String? pondName,
      @JsonKey(name: 'tambak_name') String? tambakName,
      @JsonKey(name: 'blok_name') String? blokName,
      @JsonKey(name: 'modul_name') String? modulName,
      String date,
      @JsonKey(name: 'feed_code') String? feedCode,
      @JsonKey(name: 'amount_kg') double amountKg,
      int? doc,
      String? notes,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt});
}

/// @nodoc
class _$FeedLogCopyWithImpl<$Res, $Val extends FeedLog>
    implements $FeedLogCopyWith<$Res> {
  _$FeedLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cycleId = null,
    Object? cycleName = freezed,
    Object? pondId = null,
    Object? pondName = freezed,
    Object? tambakName = freezed,
    Object? blokName = freezed,
    Object? modulName = freezed,
    Object? date = null,
    Object? feedCode = freezed,
    Object? amountKg = null,
    Object? doc = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      cycleId: null == cycleId
          ? _value.cycleId
          : cycleId // ignore: cast_nullable_to_non_nullable
              as int,
      cycleName: freezed == cycleName
          ? _value.cycleName
          : cycleName // ignore: cast_nullable_to_non_nullable
              as String?,
      pondId: null == pondId
          ? _value.pondId
          : pondId // ignore: cast_nullable_to_non_nullable
              as int,
      pondName: freezed == pondName
          ? _value.pondName
          : pondName // ignore: cast_nullable_to_non_nullable
              as String?,
      tambakName: freezed == tambakName
          ? _value.tambakName
          : tambakName // ignore: cast_nullable_to_non_nullable
              as String?,
      blokName: freezed == blokName
          ? _value.blokName
          : blokName // ignore: cast_nullable_to_non_nullable
              as String?,
      modulName: freezed == modulName
          ? _value.modulName
          : modulName // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      feedCode: freezed == feedCode
          ? _value.feedCode
          : feedCode // ignore: cast_nullable_to_non_nullable
              as String?,
      amountKg: null == amountKg
          ? _value.amountKg
          : amountKg // ignore: cast_nullable_to_non_nullable
              as double,
      doc: freezed == doc
          ? _value.doc
          : doc // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeedLogImplCopyWith<$Res> implements $FeedLogCopyWith<$Res> {
  factory _$$FeedLogImplCopyWith(
          _$FeedLogImpl value, $Res Function(_$FeedLogImpl) then) =
      __$$FeedLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'cycle_id') int cycleId,
      @JsonKey(name: 'cycle_name') String? cycleName,
      @JsonKey(name: 'pond_id') int pondId,
      @JsonKey(name: 'pond_name') String? pondName,
      @JsonKey(name: 'tambak_name') String? tambakName,
      @JsonKey(name: 'blok_name') String? blokName,
      @JsonKey(name: 'modul_name') String? modulName,
      String date,
      @JsonKey(name: 'feed_code') String? feedCode,
      @JsonKey(name: 'amount_kg') double amountKg,
      int? doc,
      String? notes,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt});
}

/// @nodoc
class __$$FeedLogImplCopyWithImpl<$Res>
    extends _$FeedLogCopyWithImpl<$Res, _$FeedLogImpl>
    implements _$$FeedLogImplCopyWith<$Res> {
  __$$FeedLogImplCopyWithImpl(
      _$FeedLogImpl _value, $Res Function(_$FeedLogImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cycleId = null,
    Object? cycleName = freezed,
    Object? pondId = null,
    Object? pondName = freezed,
    Object? tambakName = freezed,
    Object? blokName = freezed,
    Object? modulName = freezed,
    Object? date = null,
    Object? feedCode = freezed,
    Object? amountKg = null,
    Object? doc = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$FeedLogImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      cycleId: null == cycleId
          ? _value.cycleId
          : cycleId // ignore: cast_nullable_to_non_nullable
              as int,
      cycleName: freezed == cycleName
          ? _value.cycleName
          : cycleName // ignore: cast_nullable_to_non_nullable
              as String?,
      pondId: null == pondId
          ? _value.pondId
          : pondId // ignore: cast_nullable_to_non_nullable
              as int,
      pondName: freezed == pondName
          ? _value.pondName
          : pondName // ignore: cast_nullable_to_non_nullable
              as String?,
      tambakName: freezed == tambakName
          ? _value.tambakName
          : tambakName // ignore: cast_nullable_to_non_nullable
              as String?,
      blokName: freezed == blokName
          ? _value.blokName
          : blokName // ignore: cast_nullable_to_non_nullable
              as String?,
      modulName: freezed == modulName
          ? _value.modulName
          : modulName // ignore: cast_nullable_to_non_nullable
              as String?,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      feedCode: freezed == feedCode
          ? _value.feedCode
          : feedCode // ignore: cast_nullable_to_non_nullable
              as String?,
      amountKg: null == amountKg
          ? _value.amountKg
          : amountKg // ignore: cast_nullable_to_non_nullable
              as double,
      doc: freezed == doc
          ? _value.doc
          : doc // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedLogImpl implements _FeedLog {
  const _$FeedLogImpl(
      {required this.id,
      @JsonKey(name: 'cycle_id') required this.cycleId,
      @JsonKey(name: 'cycle_name') this.cycleName,
      @JsonKey(name: 'pond_id') required this.pondId,
      @JsonKey(name: 'pond_name') this.pondName,
      @JsonKey(name: 'tambak_name') this.tambakName,
      @JsonKey(name: 'blok_name') this.blokName,
      @JsonKey(name: 'modul_name') this.modulName,
      required this.date,
      @JsonKey(name: 'feed_code') this.feedCode,
      @JsonKey(name: 'amount_kg') required this.amountKg,
      this.doc,
      this.notes,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$FeedLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedLogImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'cycle_id')
  final int cycleId;
  @override
  @JsonKey(name: 'cycle_name')
  final String? cycleName;
  @override
  @JsonKey(name: 'pond_id')
  final int pondId;
  @override
  @JsonKey(name: 'pond_name')
  final String? pondName;
  @override
  @JsonKey(name: 'tambak_name')
  final String? tambakName;
  @override
  @JsonKey(name: 'blok_name')
  final String? blokName;
  @override
  @JsonKey(name: 'modul_name')
  final String? modulName;
  @override
  final String date;
  @override
  @JsonKey(name: 'feed_code')
  final String? feedCode;
  @override
  @JsonKey(name: 'amount_kg')
  final double amountKg;
  @override
  final int? doc;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @override
  String toString() {
    return 'FeedLog(id: $id, cycleId: $cycleId, cycleName: $cycleName, pondId: $pondId, pondName: $pondName, tambakName: $tambakName, blokName: $blokName, modulName: $modulName, date: $date, feedCode: $feedCode, amountKg: $amountKg, doc: $doc, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.cycleId, cycleId) || other.cycleId == cycleId) &&
            (identical(other.cycleName, cycleName) ||
                other.cycleName == cycleName) &&
            (identical(other.pondId, pondId) || other.pondId == pondId) &&
            (identical(other.pondName, pondName) ||
                other.pondName == pondName) &&
            (identical(other.tambakName, tambakName) ||
                other.tambakName == tambakName) &&
            (identical(other.blokName, blokName) ||
                other.blokName == blokName) &&
            (identical(other.modulName, modulName) ||
                other.modulName == modulName) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.feedCode, feedCode) ||
                other.feedCode == feedCode) &&
            (identical(other.amountKg, amountKg) ||
                other.amountKg == amountKg) &&
            (identical(other.doc, doc) || other.doc == doc) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      cycleId,
      cycleName,
      pondId,
      pondName,
      tambakName,
      blokName,
      modulName,
      date,
      feedCode,
      amountKg,
      doc,
      notes,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedLogImplCopyWith<_$FeedLogImpl> get copyWith =>
      __$$FeedLogImplCopyWithImpl<_$FeedLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedLogImplToJson(
      this,
    );
  }
}

abstract class _FeedLog implements FeedLog {
  const factory _FeedLog(
      {required final int id,
      @JsonKey(name: 'cycle_id') required final int cycleId,
      @JsonKey(name: 'cycle_name') final String? cycleName,
      @JsonKey(name: 'pond_id') required final int pondId,
      @JsonKey(name: 'pond_name') final String? pondName,
      @JsonKey(name: 'tambak_name') final String? tambakName,
      @JsonKey(name: 'blok_name') final String? blokName,
      @JsonKey(name: 'modul_name') final String? modulName,
      required final String date,
      @JsonKey(name: 'feed_code') final String? feedCode,
      @JsonKey(name: 'amount_kg') required final double amountKg,
      final int? doc,
      final String? notes,
      @JsonKey(name: 'created_at') final String? createdAt,
      @JsonKey(name: 'updated_at') final String? updatedAt}) = _$FeedLogImpl;

  factory _FeedLog.fromJson(Map<String, dynamic> json) = _$FeedLogImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'cycle_id')
  int get cycleId;
  @override
  @JsonKey(name: 'cycle_name')
  String? get cycleName;
  @override
  @JsonKey(name: 'pond_id')
  int get pondId;
  @override
  @JsonKey(name: 'pond_name')
  String? get pondName;
  @override
  @JsonKey(name: 'tambak_name')
  String? get tambakName;
  @override
  @JsonKey(name: 'blok_name')
  String? get blokName;
  @override
  @JsonKey(name: 'modul_name')
  String? get modulName;
  @override
  String get date;
  @override
  @JsonKey(name: 'feed_code')
  String? get feedCode;
  @override
  @JsonKey(name: 'amount_kg')
  double get amountKg;
  @override
  int? get doc;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$FeedLogImplCopyWith<_$FeedLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
