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
    @Default([]) List<String> permissions,
  }) = _User;

  const User._();

  List<String> get effectivePermissions {
    final list = <String>['view_dashboard']; // Everyone sees dashboard

    for (final perm in permissions) {
      if (perm == 'view_purchase_request') {
        list.add('view_pr');
      } else if (perm == 'view_purchase_order') {
        list.add('view_po');
      } else if (perm == 'view_receiving') {
        list.add('view_receiving');
      } else if (perm == 'view_inventory') {
        list.add('view_inventory');
      } else if (perm == 'view_warehouse' || perm == 'view_containers') {
        list.addAll(['view_containers', 'view_warehouse']);
      } else if (perm == 'view_usage') {
        list.add('view_usage');
      } else if (perm == 'view_payment_request' || perm == 'view_payments') {
        list.add('view_payments');
      } else {
        list.add(perm); // Fallback pass-through
      }
    }

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
