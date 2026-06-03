// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usage.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Pond _$PondFromJson(Map<String, dynamic> json) {
  return _Pond.fromJson(json);
}

/// @nodoc
mixin _$Pond {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get code => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PondCopyWith<Pond> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PondCopyWith<$Res> {
  factory $PondCopyWith(Pond value, $Res Function(Pond) then) =
      _$PondCopyWithImpl<$Res, Pond>;
  @useResult
  $Res call({int id, String name, String? code});
}

/// @nodoc
class _$PondCopyWithImpl<$Res, $Val extends Pond>
    implements $PondCopyWith<$Res> {
  _$PondCopyWithImpl(this._value, this._then);

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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PondImplCopyWith<$Res> implements $PondCopyWith<$Res> {
  factory _$$PondImplCopyWith(
          _$PondImpl value, $Res Function(_$PondImpl) then) =
      __$$PondImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String? code});
}

/// @nodoc
class __$$PondImplCopyWithImpl<$Res>
    extends _$PondCopyWithImpl<$Res, _$PondImpl>
    implements _$$PondImplCopyWith<$Res> {
  __$$PondImplCopyWithImpl(_$PondImpl _value, $Res Function(_$PondImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = freezed,
  }) {
    return _then(_$PondImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PondImpl implements _Pond {
  const _$PondImpl({required this.id, required this.name, this.code});

  factory _$PondImpl.fromJson(Map<String, dynamic> json) =>
      _$$PondImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? code;

  @override
  String toString() {
    return 'Pond(id: $id, name: $name, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PondImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, code);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PondImplCopyWith<_$PondImpl> get copyWith =>
      __$$PondImplCopyWithImpl<_$PondImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PondImplToJson(
      this,
    );
  }
}

abstract class _Pond implements Pond {
  const factory _Pond(
      {required final int id,
      required final String name,
      final String? code}) = _$PondImpl;

  factory _Pond.fromJson(Map<String, dynamic> json) = _$PondImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get code;
  @override
  @JsonKey(ignore: true)
  _$$PondImplCopyWith<_$PondImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UsageRequest _$UsageRequestFromJson(Map<String, dynamic> json) {
  return _UsageRequest.fromJson(json);
}

/// @nodoc
mixin _$UsageRequest {
  @JsonKey(name: 'pond_id')
  int get pondId => throw _privateConstructorUsedError;
  @JsonKey(name: 'inventory_id')
  int get inventoryId => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UsageRequestCopyWith<UsageRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsageRequestCopyWith<$Res> {
  factory $UsageRequestCopyWith(
          UsageRequest value, $Res Function(UsageRequest) then) =
      _$UsageRequestCopyWithImpl<$Res, UsageRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'pond_id') int pondId,
      @JsonKey(name: 'inventory_id') int inventoryId,
      double quantity,
      String? notes});
}

/// @nodoc
class _$UsageRequestCopyWithImpl<$Res, $Val extends UsageRequest>
    implements $UsageRequestCopyWith<$Res> {
  _$UsageRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pondId = null,
    Object? inventoryId = null,
    Object? quantity = null,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      pondId: null == pondId
          ? _value.pondId
          : pondId // ignore: cast_nullable_to_non_nullable
              as int,
      inventoryId: null == inventoryId
          ? _value.inventoryId
          : inventoryId // ignore: cast_nullable_to_non_nullable
              as int,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UsageRequestImplCopyWith<$Res>
    implements $UsageRequestCopyWith<$Res> {
  factory _$$UsageRequestImplCopyWith(
          _$UsageRequestImpl value, $Res Function(_$UsageRequestImpl) then) =
      __$$UsageRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'pond_id') int pondId,
      @JsonKey(name: 'inventory_id') int inventoryId,
      double quantity,
      String? notes});
}

/// @nodoc
class __$$UsageRequestImplCopyWithImpl<$Res>
    extends _$UsageRequestCopyWithImpl<$Res, _$UsageRequestImpl>
    implements _$$UsageRequestImplCopyWith<$Res> {
  __$$UsageRequestImplCopyWithImpl(
      _$UsageRequestImpl _value, $Res Function(_$UsageRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pondId = null,
    Object? inventoryId = null,
    Object? quantity = null,
    Object? notes = freezed,
  }) {
    return _then(_$UsageRequestImpl(
      pondId: null == pondId
          ? _value.pondId
          : pondId // ignore: cast_nullable_to_non_nullable
              as int,
      inventoryId: null == inventoryId
          ? _value.inventoryId
          : inventoryId // ignore: cast_nullable_to_non_nullable
              as int,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UsageRequestImpl implements _UsageRequest {
  const _$UsageRequestImpl(
      {@JsonKey(name: 'pond_id') required this.pondId,
      @JsonKey(name: 'inventory_id') required this.inventoryId,
      required this.quantity,
      this.notes});

  factory _$UsageRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UsageRequestImplFromJson(json);

  @override
  @JsonKey(name: 'pond_id')
  final int pondId;
  @override
  @JsonKey(name: 'inventory_id')
  final int inventoryId;
  @override
  final double quantity;
  @override
  final String? notes;

  @override
  String toString() {
    return 'UsageRequest(pondId: $pondId, inventoryId: $inventoryId, quantity: $quantity, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsageRequestImpl &&
            (identical(other.pondId, pondId) || other.pondId == pondId) &&
            (identical(other.inventoryId, inventoryId) ||
                other.inventoryId == inventoryId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, pondId, inventoryId, quantity, notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UsageRequestImplCopyWith<_$UsageRequestImpl> get copyWith =>
      __$$UsageRequestImplCopyWithImpl<_$UsageRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UsageRequestImplToJson(
      this,
    );
  }
}

abstract class _UsageRequest implements UsageRequest {
  const factory _UsageRequest(
      {@JsonKey(name: 'pond_id') required final int pondId,
      @JsonKey(name: 'inventory_id') required final int inventoryId,
      required final double quantity,
      final String? notes}) = _$UsageRequestImpl;

  factory _UsageRequest.fromJson(Map<String, dynamic> json) =
      _$UsageRequestImpl.fromJson;

  @override
  @JsonKey(name: 'pond_id')
  int get pondId;
  @override
  @JsonKey(name: 'inventory_id')
  int get inventoryId;
  @override
  double get quantity;
  @override
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$UsageRequestImplCopyWith<_$UsageRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
