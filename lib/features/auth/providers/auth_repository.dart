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
      if (e is DioException) {
        final response = e.response;
        if (response != null && response.data is Map) {
          final errorData = response.data['error'];
          if (errorData != null && errorData['message'] != null) {
            final msg = errorData['message'].toString();
            if (msg == 'Email atau password salah') {
              return const AuthState.unauthenticated(message: 'Username atau password salah');
            }
            return AuthState.unauthenticated(message: msg);
          }
        }
        if (e.response?.statusCode == 401) {
          return const AuthState.unauthenticated(message: 'Username atau password salah');
        }
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.connectionError) {
          return const AuthState.unauthenticated(
            message: 'Koneksi internet bermasalah. Silakan periksa koneksi Anda.',
          );
        }
      }
      return AuthState.unauthenticated(message: 'Gagal masuk: ${e.toString()}');
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
