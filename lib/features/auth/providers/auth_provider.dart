import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/user.dart';
import 'auth_repository.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/api/token_provider.dart';
import '../../../core/services/notification_service.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  Future<AuthState> build() async {
    final storage = ref.watch(tokenProvider);
    final token = await storage.getToken();
    
    if (token != null) {
      try {
        final repository = AuthRepositoryImpl(ref.read(dioProvider));
        final user = await repository.getCurrentUser();
        if (user != null) {
          Future.microtask(() async {
            try {
              final notificationService = ref.read(notificationServiceProvider);
              await notificationService.initialize();
              final deviceToken = await notificationService.getDeviceToken();
              if (deviceToken != null) {
                await repository.registerDeviceToken(deviceToken);
              }
            } catch (_) {}
          });
          return AuthState.authenticated(user: user, token: token);
        }
      } catch (_) {
        // Stale or expired token — clear it and force re-login
        await storage.clearAll();
      }
    }
    
    return const AuthState.unauthenticated();
  }

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();
    
    final repository = AuthRepositoryImpl(ref.read(dioProvider));
    final result = await repository.login(username, password);
    
    state = await result.when(
      authenticated: (user, token) async {
        final storage = ref.read(tokenProvider);
        await storage.saveToken(token);
        if (user.companyId != null) {
          await storage.saveCompanyId(user.companyId!);
        }
        try {
          final notificationService = ref.read(notificationServiceProvider);
          await notificationService.initialize();
          final deviceToken = await notificationService.getDeviceToken();
          if (deviceToken != null) {
            await repository.registerDeviceToken(deviceToken);
          }
        } catch (_) {}
        return AsyncValue.data(result);
      },
      unauthenticated: (message) => AsyncValue.data(result),
      initial: () => const AsyncValue.data(AuthState.unauthenticated()),
      loading: () => const AsyncValue.loading(),
    );
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    final repository = AuthRepositoryImpl(ref.read(dioProvider));
    
    try {
      final notificationService = ref.read(notificationServiceProvider);
      final deviceToken = await notificationService.getDeviceToken();
      if (deviceToken != null) {
        await repository.unregisterDeviceToken(deviceToken);
      }
    } catch (_) {}

    await repository.logout();
    
    final storage = ref.read(tokenProvider);
    await storage.clearAll();
    
    state = const AsyncValue.data(AuthState.unauthenticated());
  }
}
