// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_biaya_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InvoiceBiayaDetail _$InvoiceBiayaDetailFromJson(Map<String, dynamic> json) {
  return _InvoiceBiayaDetail.fromJson(json);
}

/// @nodoc
mixin _$InvoiceBiayaDetail {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'invoice_biaya_id')
  int? get invoiceBiayaId => throw _privateConstructorUsedError;
  @JsonKey(name: 'coa_code')
  String get coaCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'coa_name')
  String? get coaName => throw _privateConstructorUsedError;
  @JsonKey(name: 'project_code')
  String? get projectCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'cost_code')
  String? get costCode => throw _privateConstructorUsedError;
  @JsonKey(fromJson: doubleFromJson)
  double get debit => throw _privateConstructorUsedError;
  @JsonKey(fromJson: doubleFromJson)
  double get credit => throw _privateConstructorUsedError;
  @JsonKey(name: 'staff_name')
  String? get staffName => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InvoiceBiayaDetailCopyWith<InvoiceBiayaDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceBiayaDetailCopyWith<$Res> {
  factory $InvoiceBiayaDetailCopyWith(
          InvoiceBiayaDetail value, $Res Function(InvoiceBiayaDetail) then) =
      _$InvoiceBiayaDetailCopyWithImpl<$Res, InvoiceBiayaDetail>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'invoice_biaya_id') int? invoiceBiayaId,
      @JsonKey(name: 'coa_code') String coaCode,
      @JsonKey(name: 'coa_name') String? coaName,
      @JsonKey(name: 'project_code') String? projectCode,
      @JsonKey(name: 'cost_code') String? costCode,
      @JsonKey(fromJson: doubleFromJson) double debit,
      @JsonKey(fromJson: doubleFromJson) double credit,
      @JsonKey(name: 'staff_name') String? staffName,
      String? notes});
}

/// @nodoc
class _$InvoiceBiayaDetailCopyWithImpl<$Res, $Val extends InvoiceBiayaDetail>
    implements $InvoiceBiayaDetailCopyWith<$Res> {
  _$InvoiceBiayaDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? invoiceBiayaId = freezed,
    Object? coaCode = null,
    Object? coaName = freezed,
    Object? projectCode = freezed,
    Object? costCode = freezed,
    Object? debit = null,
    Object? credit = null,
    Object? staffName = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      invoiceBiayaId: freezed == invoiceBiayaId
          ? _value.invoiceBiayaId
          : invoiceBiayaId // ignore: cast_nullable_to_non_nullable
              as int?,
      coaCode: null == coaCode
          ? _value.coaCode
          : coaCode // ignore: cast_nullable_to_non_nullable
              as String,
      coaName: freezed == coaName
          ? _value.coaName
          : coaName // ignore: cast_nullable_to_non_nullable
              as String?,
      projectCode: freezed == projectCode
          ? _value.projectCode
          : projectCode // ignore: cast_nullable_to_non_nullable
              as String?,
      costCode: freezed == costCode
          ? _value.costCode
          : costCode // ignore: cast_nullable_to_non_nullable
              as String?,
      debit: null == debit
          ? _value.debit
          : debit // ignore: cast_nullable_to_non_nullable
              as double,
      credit: null == credit
          ? _value.credit
          : credit // ignore: cast_nullable_to_non_nullable
              as double,
      staffName: freezed == staffName
          ? _value.staffName
          : staffName // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvoiceBiayaDetailImplCopyWith<$Res>
    implements $InvoiceBiayaDetailCopyWith<$Res> {
  factory _$$InvoiceBiayaDetailImplCopyWith(_$InvoiceBiayaDetailImpl value,
          $Res Function(_$InvoiceBiayaDetailImpl) then) =
      __$$InvoiceBiayaDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'invoice_biaya_id') int? invoiceBiayaId,
      @JsonKey(name: 'coa_code') String coaCode,
      @JsonKey(name: 'coa_name') String? coaName,
      @JsonKey(name: 'project_code') String? projectCode,
      @JsonKey(name: 'cost_code') String? costCode,
      @JsonKey(fromJson: doubleFromJson) double debit,
      @JsonKey(fromJson: doubleFromJson) double credit,
      @JsonKey(name: 'staff_name') String? staffName,
      String? notes});
}

/// @nodoc
class __$$InvoiceBiayaDetailImplCopyWithImpl<$Res>
    extends _$InvoiceBiayaDetailCopyWithImpl<$Res, _$InvoiceBiayaDetailImpl>
    implements _$$InvoiceBiayaDetailImplCopyWith<$Res> {
  __$$InvoiceBiayaDetailImplCopyWithImpl(_$InvoiceBiayaDetailImpl _value,
      $Res Function(_$InvoiceBiayaDetailImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? invoiceBiayaId = freezed,
    Object? coaCode = null,
    Object? coaName = freezed,
    Object? projectCode = freezed,
    Object? costCode = freezed,
    Object? debit = null,
    Object? credit = null,
    Object? staffName = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$InvoiceBiayaDetailImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      invoiceBiayaId: freezed == invoiceBiayaId
          ? _value.invoiceBiayaId
          : invoiceBiayaId // ignore: cast_nullable_to_non_nullable
              as int?,
      coaCode: null == coaCode
          ? _value.coaCode
          : coaCode // ignore: cast_nullable_to_non_nullable
              as String,
      coaName: freezed == coaName
          ? _value.coaName
          : coaName // ignore: cast_nullable_to_non_nullable
              as String?,
      projectCode: freezed == projectCode
          ? _value.projectCode
          : projectCode // ignore: cast_nullable_to_non_nullable
              as String?,
      costCode: freezed == costCode
          ? _value.costCode
          : costCode // ignore: cast_nullable_to_non_nullable
              as String?,
      debit: null == debit
          ? _value.debit
          : debit // ignore: cast_nullable_to_non_nullable
              as double,
      credit: null == credit
          ? _value.credit
          : credit // ignore: cast_nullable_to_non_nullable
              as double,
      staffName: freezed == staffName
          ? _value.staffName
          : staffName // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InvoiceBiayaDetailImpl implements _InvoiceBiayaDetail {
  const _$InvoiceBiayaDetailImpl(
      {this.id,
      @JsonKey(name: 'invoice_biaya_id') this.invoiceBiayaId,
      @JsonKey(name: 'coa_code') required this.coaCode,
      @JsonKey(name: 'coa_name') this.coaName,
      @JsonKey(name: 'project_code') this.projectCode,
      @JsonKey(name: 'cost_code') this.costCode,
      @JsonKey(fromJson: doubleFromJson) this.debit = 0.0,
      @JsonKey(fromJson: doubleFromJson) this.credit = 0.0,
      @JsonKey(name: 'staff_name') this.staffName,
      this.notes});

  factory _$InvoiceBiayaDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvoiceBiayaDetailImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'invoice_biaya_id')
  final int? invoiceBiayaId;
  @override
  @JsonKey(name: 'coa_code')
  final String coaCode;
  @override
  @JsonKey(name: 'coa_name')
  final String? coaName;
  @override
  @JsonKey(name: 'project_code')
  final String? projectCode;
  @override
  @JsonKey(name: 'cost_code')
  final String? costCode;
  @override
  @JsonKey(fromJson: doubleFromJson)
  final double debit;
  @override
  @JsonKey(fromJson: doubleFromJson)
  final double credit;
  @override
  @JsonKey(name: 'staff_name')
  final String? staffName;
  @override
  final String? notes;

  @override
  String toString() {
    return 'InvoiceBiayaDetail(id: $id, invoiceBiayaId: $invoiceBiayaId, coaCode: $coaCode, coaName: $coaName, projectCode: $projectCode, costCode: $costCode, debit: $debit, credit: $credit, staffName: $staffName, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceBiayaDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.invoiceBiayaId, invoiceBiayaId) ||
                other.invoiceBiayaId == invoiceBiayaId) &&
            (identical(other.coaCode, coaCode) || other.coaCode == coaCode) &&
            (identical(other.coaName, coaName) || other.coaName == coaName) &&
            (identical(other.projectCode, projectCode) ||
                other.projectCode == projectCode) &&
            (identical(other.costCode, costCode) ||
                other.costCode == costCode) &&
            (identical(other.debit, debit) || other.debit == debit) &&
            (identical(other.credit, credit) || other.credit == credit) &&
            (identical(other.staffName, staffName) ||
                other.staffName == staffName) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, invoiceBiayaId, coaCode,
      coaName, projectCode, costCode, debit, credit, staffName, notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceBiayaDetailImplCopyWith<_$InvoiceBiayaDetailImpl> get copyWith =>
      __$$InvoiceBiayaDetailImplCopyWithImpl<_$InvoiceBiayaDetailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InvoiceBiayaDetailImplToJson(
      this,
    );
  }
}

abstract class _InvoiceBiayaDetail implements InvoiceBiayaDetail {
  const factory _InvoiceBiayaDetail(
      {final int? id,
      @JsonKey(name: 'invoice_biaya_id') final int? invoiceBiayaId,
      @JsonKey(name: 'coa_code') required final String coaCode,
      @JsonKey(name: 'coa_name') final String? coaName,
      @JsonKey(name: 'project_code') final String? projectCode,
      @JsonKey(name: 'cost_code') final String? costCode,
      @JsonKey(fromJson: doubleFromJson) final double debit,
      @JsonKey(fromJson: doubleFromJson) final double credit,
      @JsonKey(name: 'staff_name') final String? staffName,
      final String? notes}) = _$InvoiceBiayaDetailImpl;

  factory _InvoiceBiayaDetail.fromJson(Map<String, dynamic> json) =
      _$InvoiceBiayaDetailImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'invoice_biaya_id')
  int? get invoiceBiayaId;
  @override
  @JsonKey(name: 'coa_code')
  String get coaCode;
  @override
  @JsonKey(name: 'coa_name')
  String? get coaName;
  @override
  @JsonKey(name: 'project_code')
  String? get projectCode;
  @override
  @JsonKey(name: 'cost_code')
  String? get costCode;
  @override
  @JsonKey(fromJson: doubleFromJson)
  double get debit;
  @override
  @JsonKey(fromJson: doubleFromJson)
  double get credit;
  @override
  @JsonKey(name: 'staff_name')
  String? get staffName;
  @override
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$InvoiceBiayaDetailImplCopyWith<_$InvoiceBiayaDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
