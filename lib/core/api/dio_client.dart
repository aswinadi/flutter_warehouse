import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import 'token_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
    ),
  );

  final storage = ref.watch(tokenProvider);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await storage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        

        
        return handler.next(options);
      },
      onError: (e, handler) {
        if (e.response?.statusCode == 401) {
          // Handle unauthorized - logout user
          storage.clearAll();
          // We can't navigate here easily, but we can update a provider
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
