import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/usage.dart';
import '../../../core/api/dio_client.dart';

class UsageRepository {
  final Dio dio;

  UsageRepository(this.dio);

  Future<List<Pond>> getPonds() async {
    final response = await dio.get('wh/ponds');
    return (response.data['data'] as List)
        .map((e) => Pond.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> submitUsage(UsageRequest request) async {
    await dio.post('wh/usage', data: request.toJson());
  }
}

final usageRepositoryProvider = Provider<UsageRepository>((ref) {
  return UsageRepository(ref.watch(dioProvider));
});

final pondsProvider = FutureProvider<List<Pond>>((ref) async {
  return ref.watch(usageRepositoryProvider).getPonds();
});

