import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/api/token_provider.dart';
import '../models/user.dart';
import 'auth_provider.dart';

part 'impersonation_provider.g.dart';

class ImpersonationState {
  final bool isImpersonating;
  final User? originalUser;

  const ImpersonationState({
    required this.isImpersonating,
    this.originalUser,
  });
}

@riverpod
class Impersonation extends _$Impersonation {
  final _secureStorage = const FlutterSecureStorage();

  @override
  Future<ImpersonationState> build() async {
    final isImpersonatingStr = await _secureStorage.read(key: 'is_impersonating');
    final isImpersonating = isImpersonatingStr == 'true';
    
    User? originalUser;
    if (isImpersonating) {
      final originalUserJson = await _secureStorage.read(key: 'original_user_data');
      if (originalUserJson != null) {
        try {
          originalUser = User.fromJson(jsonDecode(originalUserJson));
        } catch (_) {}
      }
    }

    return ImpersonationState(
      isImpersonating: isImpersonating,
      originalUser: originalUser,
    );
  }

  Future<bool> startImpersonating(int targetUserId) async {
    state = const AsyncValue.loading();
    try {
      final dio = ref.read(dioProvider);
      final tokenStorage = ref.read(tokenProvider);

      // Call API backend impersonate
      final response = await dio.post('auth/impersonate/$targetUserId');
      if (response.data['success'] == true) {
        final data = response.data['data'];
        final impersonatedToken = data['token'] as String;
        final impersonatedUserData = data['user'];
        final impersonatedUser = User.fromJson(impersonatedUserData);

        // Get current auth state
        final currentAuth = ref.read(authProvider).valueOrNull;
        User? originalUser;
        String? originalToken;

        currentAuth?.maybeWhen(
          authenticated: (user, token) {
            originalUser = user;
            originalToken = token;
          },
          orElse: () {},
        );

        if (originalToken != null && originalUser != null) {
          // Save original credentials to secure storage
          await _secureStorage.write(key: 'original_auth_token', value: originalToken);
          await _secureStorage.write(key: 'original_user_data', value: jsonEncode(originalUser!.toJson()));
          await _secureStorage.write(key: 'is_impersonating', value: 'true');

          // Save new credentials
          await tokenStorage.saveToken(impersonatedToken);
          if (impersonatedUser.companyId != null) {
            await tokenStorage.saveCompanyId(impersonatedUser.companyId!);
          }

          // Update local state
          state = AsyncValue.data(ImpersonationState(
            isImpersonating: true,
            originalUser: originalUser,
          ));

          // Reload Auth Provider to fetch impersonated user context
          ref.invalidate(authProvider);
          return true;
        }
      }
    } catch (_) {}
    
    // Reset to previous state if failed
    ref.invalidateSelf();
    return false;
  }

  Future<void> stopImpersonating() async {
    state = const AsyncValue.loading();
    try {
      final tokenStorage = ref.read(tokenProvider);
      final originalToken = await _secureStorage.read(key: 'original_auth_token');
      final originalUserJson = await _secureStorage.read(key: 'original_user_data');

      if (originalToken != null) {
        // Restore original credentials
        await tokenStorage.saveToken(originalToken);
        
        if (originalUserJson != null) {
          try {
            final originalUser = User.fromJson(jsonDecode(originalUserJson));
            if (originalUser.companyId != null) {
              await tokenStorage.saveCompanyId(originalUser.companyId!);
            }
          } catch (_) {}
        }

        // Clear impersonating flags from secure storage
        await _secureStorage.delete(key: 'original_auth_token');
        await _secureStorage.delete(key: 'original_user_data');
        await _secureStorage.delete(key: 'is_impersonating');

        // Update local state
        state = const AsyncValue.data(ImpersonationState(
          isImpersonating: false,
          originalUser: null,
        ));

        // Reload Auth Provider to fetch original user context
        ref.invalidate(authProvider);
      }
    } catch (_) {
      ref.invalidateSelf();
    }
  }

  Future<List<Map<String, dynamic>>> fetchImpersonationUsers({String? search}) async {
    try {
      final dio = ref.read(dioProvider);
      final queryParams = <String, dynamic>{};
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      
      final response = await dio.get('auth/users', queryParameters: queryParams);
      if (response.data['success'] == true) {
        final list = response.data['data'] as List;
        return list.map((item) => item as Map<String, dynamic>).toList();
      }
    } catch (_) {}
    return [];
  }
}
