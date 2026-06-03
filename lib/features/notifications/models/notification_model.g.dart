// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppNotificationImpl _$$AppNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$AppNotificationImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>,
      isRead: json['is_read'] as bool,
      createdAt: json['created_at'] as String,
      timeAgo: json['time_ago'] as String,
    );

Map<String, dynamic> _$$AppNotificationImplToJson(
        _$AppNotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'message': instance.message,
      'data': instance.data,
      'is_read': instance.isRead,
      'created_at': instance.createdAt,
      'time_ago': instance.timeAgo,
    };
