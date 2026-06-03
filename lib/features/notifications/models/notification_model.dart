import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required String type,
    required String title,
    required String message,
    required Map<String, dynamic> data,
    @JsonKey(name: 'is_read') required bool isRead,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'time_ago') required String timeAgo,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}
