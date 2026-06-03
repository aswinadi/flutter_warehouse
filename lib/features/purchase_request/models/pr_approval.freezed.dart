// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pr_approval.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApproveRequest _$ApproveRequestFromJson(Map<String, dynamic> json) {
  return _ApproveRequest.fromJson(json);
}

/// @nodoc
mixin _$ApproveRequest {
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'selected_item_ids')
  List<int>? get selectedItemIds => throw _privateConstructorUsedError;
  List<ApproveRequestDetail>? get details => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApproveRequestCopyWith<ApproveRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApproveRequestCopyWith<$Res> {
  factory $ApproveRequestCopyWith(
          ApproveRequest value, $Res Function(ApproveRequest) then) =
      _$ApproveRequestCopyWithImpl<$Res, ApproveRequest>;
  @useResult
  $Res call(
      {String? notes,
      @JsonKey(name: 'selected_item_ids') List<int>? selectedItemIds,
      List<ApproveRequestDetail>? details});
}

/// @nodoc
class _$ApproveRequestCopyWithImpl<$Res, $Val extends ApproveRequest>
    implements $ApproveRequestCopyWith<$Res> {
  _$ApproveRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notes = freezed,
    Object? selectedItemIds = freezed,
    Object? details = freezed,
  }) {
    return _then(_value.copyWith(
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedItemIds: freezed == selectedItemIds
          ? _value.selectedItemIds
          : selectedItemIds // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as List<ApproveRequestDetail>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApproveRequestImplCopyWith<$Res>
    implements $ApproveRequestCopyWith<$Res> {
  factory _$$ApproveRequestImplCopyWith(_$ApproveRequestImpl value,
          $Res Function(_$ApproveRequestImpl) then) =
      __$$ApproveRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? notes,
      @JsonKey(name: 'selected_item_ids') List<int>? selectedItemIds,
      List<ApproveRequestDetail>? details});
}

/// @nodoc
class __$$ApproveRequestImplCopyWithImpl<$Res>
    extends _$ApproveRequestCopyWithImpl<$Res, _$ApproveRequestImpl>
    implements _$$ApproveRequestImplCopyWith<$Res> {
  __$$ApproveRequestImplCopyWithImpl(
      _$ApproveRequestImpl _value, $Res Function(_$ApproveRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notes = freezed,
    Object? selectedItemIds = freezed,
    Object? details = freezed,
  }) {
    return _then(_$ApproveRequestImpl(
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedItemIds: freezed == selectedItemIds
          ? _value._selectedItemIds
          : selectedItemIds // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      details: freezed == details
          ? _value._details
          : details // ignore: cast_nullable_to_non_nullable
              as List<ApproveRequestDetail>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApproveRequestImpl implements _ApproveRequest {
  const _$ApproveRequestImpl(
      {this.notes,
      @JsonKey(name: 'selected_item_ids') final List<int>? selectedItemIds,
      final List<ApproveRequestDetail>? details})
      : _selectedItemIds = selectedItemIds,
        _details = details;

  factory _$ApproveRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApproveRequestImplFromJson(json);

  @override
  final String? notes;
  final List<int>? _selectedItemIds;
  @override
  @JsonKey(name: 'selected_item_ids')
  List<int>? get selectedItemIds {
    final value = _selectedItemIds;
    if (value == null) return null;
    if (_selectedItemIds is EqualUnmodifiableListView) return _selectedItemIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<ApproveRequestDetail>? _details;
  @override
  List<ApproveRequestDetail>? get details {
    final value = _details;
    if (value == null) return null;
    if (_details is EqualUnmodifiableListView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ApproveRequest(notes: $notes, selectedItemIds: $selectedItemIds, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApproveRequestImpl &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality()
                .equals(other._selectedItemIds, _selectedItemIds) &&
            const DeepCollectionEquality().equals(other._details, _details));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      notes,
      const DeepCollectionEquality().hash(_selectedItemIds),
      const DeepCollectionEquality().hash(_details));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApproveRequestImplCopyWith<_$ApproveRequestImpl> get copyWith =>
      __$$ApproveRequestImplCopyWithImpl<_$ApproveRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApproveRequestImplToJson(
      this,
    );
  }
}

abstract class _ApproveRequest implements ApproveRequest {
  const factory _ApproveRequest(
      {final String? notes,
      @JsonKey(name: 'selected_item_ids') final List<int>? selectedItemIds,
      final List<ApproveRequestDetail>? details}) = _$ApproveRequestImpl;

  factory _ApproveRequest.fromJson(Map<String, dynamic> json) =
      _$ApproveRequestImpl.fromJson;

  @override
  String? get notes;
  @override
  @JsonKey(name: 'selected_item_ids')
  List<int>? get selectedItemIds;
  @override
  List<ApproveRequestDetail>? get details;
  @override
  @JsonKey(ignore: true)
  _$$ApproveRequestImplCopyWith<_$ApproveRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApproveRequestDetail _$ApproveRequestDetailFromJson(Map<String, dynamic> json) {
  return _ApproveRequestDetail.fromJson(json);
}

/// @nodoc
mixin _$ApproveRequestDetail {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_qty')
  double get approvedQty => throw _privateConstructorUsedError;
  @JsonKey(name: 'approval_notes')
  String? get approvalNotes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApproveRequestDetailCopyWith<ApproveRequestDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApproveRequestDetailCopyWith<$Res> {
  factory $ApproveRequestDetailCopyWith(ApproveRequestDetail value,
          $Res Function(ApproveRequestDetail) then) =
      _$ApproveRequestDetailCopyWithImpl<$Res, ApproveRequestDetail>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'approved_qty') double approvedQty,
      @JsonKey(name: 'approval_notes') String? approvalNotes});
}

/// @nodoc
class _$ApproveRequestDetailCopyWithImpl<$Res,
        $Val extends ApproveRequestDetail>
    implements $ApproveRequestDetailCopyWith<$Res> {
  _$ApproveRequestDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? approvedQty = null,
    Object? approvalNotes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      approvedQty: null == approvedQty
          ? _value.approvedQty
          : approvedQty // ignore: cast_nullable_to_non_nullable
              as double,
      approvalNotes: freezed == approvalNotes
          ? _value.approvalNotes
          : approvalNotes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApproveRequestDetailImplCopyWith<$Res>
    implements $ApproveRequestDetailCopyWith<$Res> {
  factory _$$ApproveRequestDetailImplCopyWith(_$ApproveRequestDetailImpl value,
          $Res Function(_$ApproveRequestDetailImpl) then) =
      __$$ApproveRequestDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'approved_qty') double approvedQty,
      @JsonKey(name: 'approval_notes') String? approvalNotes});
}

/// @nodoc
class __$$ApproveRequestDetailImplCopyWithImpl<$Res>
    extends _$ApproveRequestDetailCopyWithImpl<$Res, _$ApproveRequestDetailImpl>
    implements _$$ApproveRequestDetailImplCopyWith<$Res> {
  __$$ApproveRequestDetailImplCopyWithImpl(_$ApproveRequestDetailImpl _value,
      $Res Function(_$ApproveRequestDetailImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? approvedQty = null,
    Object? approvalNotes = freezed,
  }) {
    return _then(_$ApproveRequestDetailImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      approvedQty: null == approvedQty
          ? _value.approvedQty
          : approvedQty // ignore: cast_nullable_to_non_nullable
              as double,
      approvalNotes: freezed == approvalNotes
          ? _value.approvalNotes
          : approvalNotes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApproveRequestDetailImpl implements _ApproveRequestDetail {
  const _$ApproveRequestDetailImpl(
      {required this.id,
      @JsonKey(name: 'approved_qty') required this.approvedQty,
      @JsonKey(name: 'approval_notes') this.approvalNotes});

  factory _$ApproveRequestDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApproveRequestDetailImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'approved_qty')
  final double approvedQty;
  @override
  @JsonKey(name: 'approval_notes')
  final String? approvalNotes;

  @override
  String toString() {
    return 'ApproveRequestDetail(id: $id, approvedQty: $approvedQty, approvalNotes: $approvalNotes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApproveRequestDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.approvedQty, approvedQty) ||
                other.approvedQty == approvedQty) &&
            (identical(other.approvalNotes, approvalNotes) ||
                other.approvalNotes == approvalNotes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, approvedQty, approvalNotes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApproveRequestDetailImplCopyWith<_$ApproveRequestDetailImpl>
      get copyWith =>
          __$$ApproveRequestDetailImplCopyWithImpl<_$ApproveRequestDetailImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApproveRequestDetailImplToJson(
      this,
    );
  }
}

abstract class _ApproveRequestDetail implements ApproveRequestDetail {
  const factory _ApproveRequestDetail(
          {required final int id,
          @JsonKey(name: 'approved_qty') required final double approvedQty,
          @JsonKey(name: 'approval_notes') final String? approvalNotes}) =
      _$ApproveRequestDetailImpl;

  factory _ApproveRequestDetail.fromJson(Map<String, dynamic> json) =
      _$ApproveRequestDetailImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'approved_qty')
  double get approvedQty;
  @override
  @JsonKey(name: 'approval_notes')
  String? get approvalNotes;
  @override
  @JsonKey(ignore: true)
  _$$ApproveRequestDetailImplCopyWith<_$ApproveRequestDetailImpl>
      get copyWith => throw _privateConstructorUsedError;
}
