import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required int id,
    required String name,
    required String email,
    String? photoUrl,
    @JsonKey(name: 'company_id') int? companyId,
    @Default([]) @JsonKey(name: 'approval_types') List<String> approvalTypes,
    @Default([]) List<String> roles,
    @Default([
      'view_dashboard',
      'view_pr',
      'view_po',
      'view_receiving',
      'view_inventory',
      'view_usage'
    ])
    List<String> permissions,
  }) = _User;

  const User._();

  List<String> get effectivePermissions {
    final list = List<String>.from(permissions);
    if (approvalTypes.isNotEmpty) {
      list.add('approve_pr');
    }
    return list;
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated({
    required User user,
    required String token,
  }) = _Authenticated;
  const factory AuthState.unauthenticated({String? message}) = _Unauthenticated;
}
