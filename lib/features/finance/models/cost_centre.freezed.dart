// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cost_centre.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CostCentre _$CostCentreFromJson(Map<String, dynamic> json) {
  return _CostCentre.fromJson(json);
}

/// @nodoc
mixin _$CostCentre {
  int get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'parent_code')
  String? get parentCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'luas_m2', fromJson: doubleFromJson)
  double get luasM2 => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_parent')
  bool get isParent => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CostCentreCopyWith<CostCentre> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CostCentreCopyWith<$Res> {
  factory $CostCentreCopyWith(
          CostCentre value, $Res Function(CostCentre) then) =
      _$CostCentreCopyWithImpl<$Res, CostCentre>;
  @useResult
  $Res call(
      {int id,
      String code,
      String name,
      @JsonKey(name: 'parent_code') String? parentCode,
      @JsonKey(name: 'luas_m2', fromJson: doubleFromJson) double luasM2,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_parent') bool isParent});
}

/// @nodoc
class _$CostCentreCopyWithImpl<$Res, $Val extends CostCentre>
    implements $CostCentreCopyWith<$Res> {
  _$CostCentreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? parentCode = freezed,
    Object? luasM2 = null,
    Object? isActive = null,
    Object? isParent = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      parentCode: freezed == parentCode
          ? _value.parentCode
          : parentCode // ignore: cast_nullable_to_non_nullable
              as String?,
      luasM2: null == luasM2
          ? _value.luasM2
          : luasM2 // ignore: cast_nullable_to_non_nullable
              as double,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isParent: null == isParent
          ? _value.isParent
          : isParent // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CostCentreImplCopyWith<$Res>
    implements $CostCentreCopyWith<$Res> {
  factory _$$CostCentreImplCopyWith(
          _$CostCentreImpl value, $Res Function(_$CostCentreImpl) then) =
      __$$CostCentreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String code,
      String name,
      @JsonKey(name: 'parent_code') String? parentCode,
      @JsonKey(name: 'luas_m2', fromJson: doubleFromJson) double luasM2,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_parent') bool isParent});
}

/// @nodoc
class __$$CostCentreImplCopyWithImpl<$Res>
    extends _$CostCentreCopyWithImpl<$Res, _$CostCentreImpl>
    implements _$$CostCentreImplCopyWith<$Res> {
  __$$CostCentreImplCopyWithImpl(
      _$CostCentreImpl _value, $Res Function(_$CostCentreImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? parentCode = freezed,
    Object? luasM2 = null,
    Object? isActive = null,
    Object? isParent = null,
  }) {
    return _then(_$CostCentreImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      parentCode: freezed == parentCode
          ? _value.parentCode
          : parentCode // ignore: cast_nullable_to_non_nullable
              as String?,
      luasM2: null == luasM2
          ? _value.luasM2
          : luasM2 // ignore: cast_nullable_to_non_nullable
              as double,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isParent: null == isParent
          ? _value.isParent
          : isParent // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CostCentreImpl implements _CostCentre {
  const _$CostCentreImpl(
      {required this.id,
      required this.code,
      required this.name,
      @JsonKey(name: 'parent_code') this.parentCode,
      @JsonKey(name: 'luas_m2', fromJson: doubleFromJson) required this.luasM2,
      @JsonKey(name: 'is_active') required this.isActive,
      @JsonKey(name: 'is_parent') this.isParent = false});

  factory _$CostCentreImpl.fromJson(Map<String, dynamic> json) =>
      _$$CostCentreImplFromJson(json);

  @override
  final int id;
  @override
  final String code;
  @override
  final String name;
  @override
  @JsonKey(name: 'parent_code')
  final String? parentCode;
  @override
  @JsonKey(name: 'luas_m2', fromJson: doubleFromJson)
  final double luasM2;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'is_parent')
  final bool isParent;

  @override
  String toString() {
    return 'CostCentre(id: $id, code: $code, name: $name, parentCode: $parentCode, luasM2: $luasM2, isActive: $isActive, isParent: $isParent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CostCentreImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.parentCode, parentCode) ||
                other.parentCode == parentCode) &&
            (identical(other.luasM2, luasM2) || other.luasM2 == luasM2) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isParent, isParent) ||
                other.isParent == isParent));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, code, name, parentCode, luasM2, isActive, isParent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CostCentreImplCopyWith<_$CostCentreImpl> get copyWith =>
      __$$CostCentreImplCopyWithImpl<_$CostCentreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CostCentreImplToJson(
      this,
    );
  }
}

abstract class _CostCentre implements CostCentre {
  const factory _CostCentre(
      {required final int id,
      required final String code,
      required final String name,
      @JsonKey(name: 'parent_code') final String? parentCode,
      @JsonKey(name: 'luas_m2', fromJson: doubleFromJson)
      required final double luasM2,
      @JsonKey(name: 'is_active') required final bool isActive,
      @JsonKey(name: 'is_parent') final bool isParent}) = _$CostCentreImpl;

  factory _CostCentre.fromJson(Map<String, dynamic> json) =
      _$CostCentreImpl.fromJson;

  @override
  int get id;
  @override
  String get code;
  @override
  String get name;
  @override
  @JsonKey(name: 'parent_code')
  String? get parentCode;
  @override
  @JsonKey(name: 'luas_m2', fromJson: doubleFromJson)
  double get luasM2;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'is_parent')
  bool get isParent;
  @override
  @JsonKey(ignore: true)
  _$$CostCentreImplCopyWith<_$CostCentreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
