// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cost_code.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CostCode _$CostCodeFromJson(Map<String, dynamic> json) {
  return _CostCode.fromJson(json);
}

/// @nodoc
mixin _$CostCode {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  int get companyId => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'tipe_cost_name')
  String? get tipeCostName => throw _privateConstructorUsedError;
  @JsonKey(name: 'group_name')
  String? get groupName => throw _privateConstructorUsedError;
  @JsonKey(name: 'group_tipe')
  String? get groupTipe => throw _privateConstructorUsedError;
  String? get codecoa => throw _privateConstructorUsedError;
  String? get namecoa => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CostCodeCopyWith<CostCode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CostCodeCopyWith<$Res> {
  factory $CostCodeCopyWith(CostCode value, $Res Function(CostCode) then) =
      _$CostCodeCopyWithImpl<$Res, CostCode>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'company_id') int companyId,
      String code,
      String name,
      @JsonKey(name: 'tipe_cost_name') String? tipeCostName,
      @JsonKey(name: 'group_name') String? groupName,
      @JsonKey(name: 'group_tipe') String? groupTipe,
      String? codecoa,
      String? namecoa,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class _$CostCodeCopyWithImpl<$Res, $Val extends CostCode>
    implements $CostCodeCopyWith<$Res> {
  _$CostCodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? code = null,
    Object? name = null,
    Object? tipeCostName = freezed,
    Object? groupName = freezed,
    Object? groupTipe = freezed,
    Object? codecoa = freezed,
    Object? namecoa = freezed,
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
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      tipeCostName: freezed == tipeCostName
          ? _value.tipeCostName
          : tipeCostName // ignore: cast_nullable_to_non_nullable
              as String?,
      groupName: freezed == groupName
          ? _value.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String?,
      groupTipe: freezed == groupTipe
          ? _value.groupTipe
          : groupTipe // ignore: cast_nullable_to_non_nullable
              as String?,
      codecoa: freezed == codecoa
          ? _value.codecoa
          : codecoa // ignore: cast_nullable_to_non_nullable
              as String?,
      namecoa: freezed == namecoa
          ? _value.namecoa
          : namecoa // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CostCodeImplCopyWith<$Res>
    implements $CostCodeCopyWith<$Res> {
  factory _$$CostCodeImplCopyWith(
          _$CostCodeImpl value, $Res Function(_$CostCodeImpl) then) =
      __$$CostCodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'company_id') int companyId,
      String code,
      String name,
      @JsonKey(name: 'tipe_cost_name') String? tipeCostName,
      @JsonKey(name: 'group_name') String? groupName,
      @JsonKey(name: 'group_tipe') String? groupTipe,
      String? codecoa,
      String? namecoa,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class __$$CostCodeImplCopyWithImpl<$Res>
    extends _$CostCodeCopyWithImpl<$Res, _$CostCodeImpl>
    implements _$$CostCodeImplCopyWith<$Res> {
  __$$CostCodeImplCopyWithImpl(
      _$CostCodeImpl _value, $Res Function(_$CostCodeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? code = null,
    Object? name = null,
    Object? tipeCostName = freezed,
    Object? groupName = freezed,
    Object? groupTipe = freezed,
    Object? codecoa = freezed,
    Object? namecoa = freezed,
    Object? isActive = null,
  }) {
    return _then(_$CostCodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      tipeCostName: freezed == tipeCostName
          ? _value.tipeCostName
          : tipeCostName // ignore: cast_nullable_to_non_nullable
              as String?,
      groupName: freezed == groupName
          ? _value.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String?,
      groupTipe: freezed == groupTipe
          ? _value.groupTipe
          : groupTipe // ignore: cast_nullable_to_non_nullable
              as String?,
      codecoa: freezed == codecoa
          ? _value.codecoa
          : codecoa // ignore: cast_nullable_to_non_nullable
              as String?,
      namecoa: freezed == namecoa
          ? _value.namecoa
          : namecoa // ignore: cast_nullable_to_non_nullable
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
class _$CostCodeImpl implements _CostCode {
  const _$CostCodeImpl(
      {required this.id,
      @JsonKey(name: 'company_id') required this.companyId,
      required this.code,
      required this.name,
      @JsonKey(name: 'tipe_cost_name') this.tipeCostName,
      @JsonKey(name: 'group_name') this.groupName,
      @JsonKey(name: 'group_tipe') this.groupTipe,
      this.codecoa,
      this.namecoa,
      @JsonKey(name: 'is_active') required this.isActive});

  factory _$CostCodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$CostCodeImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'company_id')
  final int companyId;
  @override
  final String code;
  @override
  final String name;
  @override
  @JsonKey(name: 'tipe_cost_name')
  final String? tipeCostName;
  @override
  @JsonKey(name: 'group_name')
  final String? groupName;
  @override
  @JsonKey(name: 'group_tipe')
  final String? groupTipe;
  @override
  final String? codecoa;
  @override
  final String? namecoa;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'CostCode(id: $id, companyId: $companyId, code: $code, name: $name, tipeCostName: $tipeCostName, groupName: $groupName, groupTipe: $groupTipe, codecoa: $codecoa, namecoa: $namecoa, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CostCodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.tipeCostName, tipeCostName) ||
                other.tipeCostName == tipeCostName) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.groupTipe, groupTipe) ||
                other.groupTipe == groupTipe) &&
            (identical(other.codecoa, codecoa) || other.codecoa == codecoa) &&
            (identical(other.namecoa, namecoa) || other.namecoa == namecoa) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, companyId, code, name,
      tipeCostName, groupName, groupTipe, codecoa, namecoa, isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CostCodeImplCopyWith<_$CostCodeImpl> get copyWith =>
      __$$CostCodeImplCopyWithImpl<_$CostCodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CostCodeImplToJson(
      this,
    );
  }
}

abstract class _CostCode implements CostCode {
  const factory _CostCode(
          {required final int id,
          @JsonKey(name: 'company_id') required final int companyId,
          required final String code,
          required final String name,
          @JsonKey(name: 'tipe_cost_name') final String? tipeCostName,
          @JsonKey(name: 'group_name') final String? groupName,
          @JsonKey(name: 'group_tipe') final String? groupTipe,
          final String? codecoa,
          final String? namecoa,
          @JsonKey(name: 'is_active') required final bool isActive}) =
      _$CostCodeImpl;

  factory _CostCode.fromJson(Map<String, dynamic> json) =
      _$CostCodeImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'company_id')
  int get companyId;
  @override
  String get code;
  @override
  String get name;
  @override
  @JsonKey(name: 'tipe_cost_name')
  String? get tipeCostName;
  @override
  @JsonKey(name: 'group_name')
  String? get groupName;
  @override
  @JsonKey(name: 'group_tipe')
  String? get groupTipe;
  @override
  String? get codecoa;
  @override
  String? get namecoa;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$CostCodeImplCopyWith<_$CostCodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
