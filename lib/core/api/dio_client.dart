import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import 'token_provider.dart';
import '../../features/auth/providers/auth_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-Client-Platform': 'flutter_mobile',
        'ngrok-skip-browser-warning': 'true',
      },
    ),
  );

  final storage = ref.watch(tokenProvider);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final currentBase = AppConfig.baseUrl;
        options.baseUrl = currentBase;
        if (!options.path.startsWith('http://') && !options.path.startsWith('https://')) {
          options.path = Uri.parse(currentBase).resolve(options.path).toString();
        }
        final token = await storage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (e, handler) {
        if (e.response?.statusCode == 401) {
          // Handle unauthorized - logout user and redirect to login
          storage.clearAll();
          ref.read(authProvider.notifier).forceLogout();
        }
        return handler.next(e);
      },
    ),
  );

  // Add logging in debug mode
  dio.interceptors.add(LogInterceptor(
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
  ));

  return dio;
});
