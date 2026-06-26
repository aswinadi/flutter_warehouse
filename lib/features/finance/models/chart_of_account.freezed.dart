// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chart_of_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChartOfAccount _$ChartOfAccountFromJson(Map<String, dynamic> json) {
  return _ChartOfAccount.fromJson(json);
}

/// @nodoc
mixin _$ChartOfAccount {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  int get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'coa_code')
  String get coaCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'coa_name')
  String get coaName => throw _privateConstructorUsedError;
  @JsonKey(name: 'parent_code')
  String? get parentCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChartOfAccountCopyWith<ChartOfAccount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChartOfAccountCopyWith<$Res> {
  factory $ChartOfAccountCopyWith(
          ChartOfAccount value, $Res Function(ChartOfAccount) then) =
      _$ChartOfAccountCopyWithImpl<$Res, ChartOfAccount>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'company_id') int companyId,
      @JsonKey(name: 'coa_code') String coaCode,
      @JsonKey(name: 'coa_name') String coaName,
      @JsonKey(name: 'parent_code') String? parentCode,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class _$ChartOfAccountCopyWithImpl<$Res, $Val extends ChartOfAccount>
    implements $ChartOfAccountCopyWith<$Res> {
  _$ChartOfAccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? coaCode = null,
    Object? coaName = null,
    Object? parentCode = freezed,
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
      coaCode: null == coaCode
          ? _value.coaCode
          : coaCode // ignore: cast_nullable_to_non_nullable
              as String,
      coaName: null == coaName
          ? _value.coaName
          : coaName // ignore: cast_nullable_to_non_nullable
              as String,
      parentCode: freezed == parentCode
          ? _value.parentCode
          : parentCode // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChartOfAccountImplCopyWith<$Res>
    implements $ChartOfAccountCopyWith<$Res> {
  factory _$$ChartOfAccountImplCopyWith(_$ChartOfAccountImpl value,
          $Res Function(_$ChartOfAccountImpl) then) =
      __$$ChartOfAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'company_id') int companyId,
      @JsonKey(name: 'coa_code') String coaCode,
      @JsonKey(name: 'coa_name') String coaName,
      @JsonKey(name: 'parent_code') String? parentCode,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class __$$ChartOfAccountImplCopyWithImpl<$Res>
    extends _$ChartOfAccountCopyWithImpl<$Res, _$ChartOfAccountImpl>
    implements _$$ChartOfAccountImplCopyWith<$Res> {
  __$$ChartOfAccountImplCopyWithImpl(
      _$ChartOfAccountImpl _value, $Res Function(_$ChartOfAccountImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? companyId = null,
    Object? coaCode = null,
    Object? coaName = null,
    Object? parentCode = freezed,
    Object? isActive = null,
  }) {
    return _then(_$ChartOfAccountImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int,
      coaCode: null == coaCode
          ? _value.coaCode
          : coaCode // ignore: cast_nullable_to_non_nullable
              as String,
      coaName: null == coaName
          ? _value.coaName
          : coaName // ignore: cast_nullable_to_non_nullable
              as String,
      parentCode: freezed == parentCode
          ? _value.parentCode
          : parentCode // ignore: cast_nullable_to_non_nullable
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
class _$ChartOfAccountImpl implements _ChartOfAccount {
  const _$ChartOfAccountImpl(
      {required this.id,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'coa_code') required this.coaCode,
      @JsonKey(name: 'coa_name') required this.coaName,
      @JsonKey(name: 'parent_code') this.parentCode,
      @JsonKey(name: 'is_active') required this.isActive});

  factory _$ChartOfAccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChartOfAccountImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'company_id')
  final int companyId;
  @override
  @JsonKey(name: 'coa_code')
  final String coaCode;
  @override
  @JsonKey(name: 'coa_name')
  final String coaName;
  @override
  @JsonKey(name: 'parent_code')
  final String? parentCode;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'ChartOfAccount(id: $id, companyId: $companyId, coaCode: $coaCode, coaName: $coaName, parentCode: $parentCode, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChartOfAccountImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.coaCode, coaCode) || other.coaCode == coaCode) &&
            (identical(other.coaName, coaName) || other.coaName == coaName) &&
            (identical(other.parentCode, parentCode) ||
                other.parentCode == parentCode) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, companyId, coaCode, coaName, parentCode, isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChartOfAccountImplCopyWith<_$ChartOfAccountImpl> get copyWith =>
      __$$ChartOfAccountImplCopyWithImpl<_$ChartOfAccountImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChartOfAccountImplToJson(
      this,
    );
  }
}

abstract class _ChartOfAccount implements ChartOfAccount {
  const factory _ChartOfAccount(
          {required final int id,
          @JsonKey(name: 'company_id') required final int companyId,
          @JsonKey(name: 'coa_code') required final String coaCode,
          @JsonKey(name: 'coa_name') required final String coaName,
          @JsonKey(name: 'parent_code') final String? parentCode,
          @JsonKey(name: 'is_active') required final bool isActive}) =
      _$ChartOfAccountImpl;

  factory _ChartOfAccount.fromJson(Map<String, dynamic> json) =
      _$ChartOfAccountImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'company_id')
  int get companyId;
  @override
  @JsonKey(name: 'coa_code')
  String get coaCode;
  @override
  @JsonKey(name: 'coa_name')
  String get coaName;
  @override
  @JsonKey(name: 'parent_code')
  String? get parentCode;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$ChartOfAccountImplCopyWith<_$ChartOfAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
