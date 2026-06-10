import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/notification_model.dart';
import 'notification_repository.dart';

part 'notification_provider.g.dart';

@riverpod
class NotificationsList extends _$NotificationsList {
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;

  @override
  Future<List<AppNotification>> build() async {
    ref.watch(notificationRepositoryProvider);
    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    return _fetchPage(1);
  }

  Future<List<AppNotification>> _fetchPage(int page) async {
    final repository = ref.read(notificationRepositoryProvider);
    final response = await repository.getNotifications(page: page);

    if (response.meta != null) {
      _hasMore = response.meta!.currentPage < response.meta!.lastPage;
    } else {
      _hasMore = response.data.isNotEmpty;
    }

    return response.data;
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;

    final currentList = state.value ?? [];
    state = const AsyncLoading<List<AppNotification>>().copyWithPrevious(state);

    try {
      final nextPage = _currentPage + 1;
      final response = await _fetchPage(nextPage);

      _currentPage = nextPage;
      state = AsyncValue.data([...currentList, ...response]);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> markAsRead(String id) async {
    final repository = ref.read(notificationRepositoryProvider);
    try {
      await repository.markAsRead(id);
      
      if (state.hasValue) {
        final updatedList = state.value!.map((n) {
          if (n.id == id) {
            return n.copyWith(isRead: true);
          }
          return n;
        }).toList();
        state = AsyncValue.data(updatedList);
      }
      
      // Auto refresh unread badge count
      ref.read(unreadNotificationCountProvider.notifier).refreshCount();
    } catch (e) {
      // ignore
    }
  }

  Future<void> markAllAsRead() async {
    final repository = ref.read(notificationRepositoryProvider);
    try {
      await repository.markAllAsRead();
      
      if (state.hasValue) {
        final updatedList = state.value!.map((n) => n.copyWith(isRead: true)).toList();
        state = AsyncValue.data(updatedList);
      }
      
      // Auto refresh unread badge count
      ref.read(unreadNotificationCountProvider.notifier).refreshCount();
    } catch (e) {
      // ignore
    }
  }
}

@riverpod
class UnreadNotificationCount extends _$UnreadNotificationCount {
  @override
  Future<int> build() async {
    ref.watch(notificationRepositoryProvider);
    final repository = ref.read(notificationRepositoryProvider);
    try {
      return await repository.getUnreadCount();
    } on DioException catch (e) {
      // Silently return 0 if unauthorized (e.g. token not yet ready)
      if (e.response?.statusCode == 401) return 0;
      rethrow;
    } catch (_) {
      return 0;
    }
  }

  Future<void> refreshCount() async {
    state = const AsyncLoading<int>().copyWithPrevious(state);
    try {
      final repository = ref.read(notificationRepositoryProvider);
      final count = await repository.getUnreadCount();
      state = AsyncValue.data(count);
    } on DioException catch (e) {
      // Silently reset to 0 on auth errors
      if (e.response?.statusCode == 401) {
        state = const AsyncValue.data(0);
      } else {
        state = AsyncValue.error(e, StackTrace.current);
      }
    } catch (_) {
      state = const AsyncValue.data(0);
    }
  }
}
