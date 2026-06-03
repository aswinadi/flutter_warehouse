// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pr_rejection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RejectRequest _$RejectRequestFromJson(Map<String, dynamic> json) {
  return _RejectRequest.fromJson(json);
}

/// @nodoc
mixin _$RejectRequest {
  String get reason => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RejectRequestCopyWith<RejectRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RejectRequestCopyWith<$Res> {
  factory $RejectRequestCopyWith(
          RejectRequest value, $Res Function(RejectRequest) then) =
      _$RejectRequestCopyWithImpl<$Res, RejectRequest>;
  @useResult
  $Res call({String reason, String? notes});
}

/// @nodoc
class _$RejectRequestCopyWithImpl<$Res, $Val extends RejectRequest>
    implements $RejectRequestCopyWith<$Res> {
  _$RejectRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reason = null,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RejectRequestImplCopyWith<$Res>
    implements $RejectRequestCopyWith<$Res> {
  factory _$$RejectRequestImplCopyWith(
          _$RejectRequestImpl value, $Res Function(_$RejectRequestImpl) then) =
      __$$RejectRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String reason, String? notes});
}

/// @nodoc
class __$$RejectRequestImplCopyWithImpl<$Res>
    extends _$RejectRequestCopyWithImpl<$Res, _$RejectRequestImpl>
    implements _$$RejectRequestImplCopyWith<$Res> {
  __$$RejectRequestImplCopyWithImpl(
      _$RejectRequestImpl _value, $Res Function(_$RejectRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reason = null,
    Object? notes = freezed,
  }) {
    return _then(_$RejectRequestImpl(
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RejectRequestImpl implements _RejectRequest {
  const _$RejectRequestImpl({required this.reason, this.notes});

  factory _$RejectRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RejectRequestImplFromJson(json);

  @override
  final String reason;
  @override
  final String? notes;

  @override
  String toString() {
    return 'RejectRequest(reason: $reason, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RejectRequestImpl &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, reason, notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RejectRequestImplCopyWith<_$RejectRequestImpl> get copyWith =>
      __$$RejectRequestImplCopyWithImpl<_$RejectRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RejectRequestImplToJson(
      this,
    );
  }
}

abstract class _RejectRequest implements RejectRequest {
  const factory _RejectRequest(
      {required final String reason,
      final String? notes}) = _$RejectRequestImpl;

  factory _RejectRequest.fromJson(Map<String, dynamic> json) =
      _$RejectRequestImpl.fromJson;

  @override
  String get reason;
  @override
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$RejectRequestImplCopyWith<_$RejectRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
