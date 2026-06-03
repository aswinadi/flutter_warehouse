import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/notification_model.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/api/paginated_response.dart';

part 'notification_repository.g.dart';

class NotificationRepository {
  final Dio dio;

  NotificationRepository(this.dio);

  Future<PaginatedResponse<AppNotification>> getNotifications({
    int page = 1,
  }) async {
    final response = await dio.get('auth/notifications', queryParameters: {
      'page': page,
    });

    return PaginatedResponse.fromJson(
      response.data,
      (json) => AppNotification.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<int> getUnreadCount() async {
    final response = await dio.get('auth/notifications/unread-count');
    return response.data['data']['count'] as int;
  }

  Future<void> markAsRead(String id) async {
    await dio.post('auth/notifications/$id/read');
  }

  Future<void> markAllAsRead() async {
    await dio.post('auth/notifications/read-all');
  }
}

@riverpod
NotificationRepository notificationRepository(NotificationRepositoryRef ref) {
  return NotificationRepository(ref.watch(dioProvider));
}
