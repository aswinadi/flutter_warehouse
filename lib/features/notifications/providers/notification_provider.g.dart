// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationsListHash() => r'f73633589c81c35dd9ae5de83036dbd5b8c4e110';

/// See also [NotificationsList].
@ProviderFor(NotificationsList)
final notificationsListProvider = AutoDisposeAsyncNotifierProvider<
    NotificationsList, List<AppNotification>>.internal(
  NotificationsList.new,
  name: r'notificationsListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationsList = AutoDisposeAsyncNotifier<List<AppNotification>>;
String _$unreadNotificationCountHash() =>
    r'7943cc1f9d3c581587a54e14a4757f66c5faf174';

/// See also [UnreadNotificationCount].
@ProviderFor(UnreadNotificationCount)
final unreadNotificationCountProvider =
    AutoDisposeAsyncNotifierProvider<UnreadNotificationCount, int>.internal(
  UnreadNotificationCount.new,
  name: r'unreadNotificationCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unreadNotificationCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UnreadNotificationCount = AutoDisposeAsyncNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
