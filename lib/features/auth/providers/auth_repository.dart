import 'package:dio/dio.dart';
import '../models/user.dart';

abstract class AuthRepository {
  Future<AuthState> login(String username, String password);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<void> registerDeviceToken(String token);
  Future<void> unregisterDeviceToken(String token);
}

class AuthRepositoryImpl implements AuthRepository {
  final Dio dio;

  AuthRepositoryImpl(this.dio);

  @override
  Future<AuthState> login(String username, String password) async {
    try {
      final response = await dio.post('auth/login', data: {
        'employee_id': username,
        'password': password,
      });

      if (response.data['success'] == true) {
        final userData = response.data['data']['user'];
        final token = response.data['data']['token'];
        return AuthState.authenticated(
          user: User.fromJson(userData),
          token: token,
        );
      } else {
        return AuthState.unauthenticated(
          message: response.data['error']['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      return AuthState.unauthenticated(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post('auth/logout');
    } catch (_) {}
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final response = await dio.get('auth/me');
      if (response.data['success'] == true) {
        return User.fromJson(response.data['data']);
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<void> registerDeviceToken(String token) async {
    try {
      await dio.post('auth/device-token', data: {'token': token});
    } catch (_) {}
  }

  @override
  Future<void> unregisterDeviceToken(String token) async {
    try {
      await dio.delete('auth/device-token', data: {'token': token});
    } catch (_) {}
  }
}
