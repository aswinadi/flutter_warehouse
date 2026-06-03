import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/providers/auth_repository.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../api/dio_client.dart';
import '../api/router.dart';
import '../../features/notifications/providers/notification_provider.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref);
});

class NotificationService {
  final Ref _ref;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'maxmar_warehouse_notifications', // id
    'Notifikasi Penting Maxmar', // title
    description: 'Channel ini digunakan untuk notifikasi persetujuan penting.',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  NotificationService(this._ref);

  Future<void> initialize() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      debugPrint('FCM is not supported on this platform, skipping initialization.');
      return;
    }

    // 1. Request Permission
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2. Local Notifications Initialization (For Foreground Banners)
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification click when app is running/foreground
        debugPrint('Notification clicked in foreground: ${response.payload}');
        if (response.payload != null) {
          try {
            final data = jsonDecode(response.payload!) as Map<String, dynamic>;
            _handleNotificationClick(data);
          } catch (e) {
            debugPrint('Error parsing notification payload: $e');
          }
        }
      },
    );

    // Create Notification Channel for Android
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // 3. Listen to Foreground Messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final android = message.notification?.android;

      if (notification != null) {
        _localNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channel.id,
              _channel.name,
              channelDescription: _channel.description,
              icon: android?.smallIcon ?? '@mipmap/ic_launcher',
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }
      try {
        _ref.read(unreadNotificationCountProvider.notifier).refreshCount();
      } catch (e) {
        debugPrint('Error refreshing unread count: $e');
      }
    });

    // 4. Handle Notification Click when app opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      _handleNotificationClick(message.data);
    });

    // 5. Handle initial message when app is opened from terminated state
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('App opened from terminated state by notification click!');
      Future.delayed(const Duration(milliseconds: 800), () {
        _handleNotificationClick(initialMessage.data);
      });
    }

    // 6. Handle Token Refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      debugPrint('FCM Token Refreshed: $token');
      // If user is authenticated, register the new token
      final authState = _ref.read(authProvider);
      final isAuthenticated = authState.valueOrNull?.maybeWhen(
            authenticated: (_, __) => true,
            orElse: () => false,
          ) ??
          false;

      if (isAuthenticated) {
        final repository = AuthRepositoryImpl(_ref.read(dioProvider));
        await repository.registerDeviceToken(token);
      }
    });
  }

  void _handleNotificationClick(Map<String, dynamic> data) {
    debugPrint('Handling notification click with data: $data');
    final type = data['type'];
    final id = data['id'] ?? data['pr_id'] ?? data['po_id'] ?? data['invoice_id'] ?? data['payment_request_id'];

    if (type == null || id == null) {
      debugPrint('Redirecting to default approvals page (missing type/id)');
      try {
        _ref.read(routerProvider).push('/approvals');
      } catch (e) {
        debugPrint('Router error: $e');
      }
      return;
    }

    final idString = id.toString();
    String path = '/approvals';

    switch (type) {
      case 'purchase_order':
        path = '/approvals/po/$idString';
        break;
      case 'invoice':
        path = '/approvals/invoice/$idString';
        break;
      case 'payment_request':
        path = '/approvals/payment-request/$idString';
        break;
      case 'purchase_request':
        final action = data['action'];
        if (action == 'bod_selection_ready' || action == 'bod_comparison') {
          path = '/approvals/pr-vendor/$idString';
        } else {
          path = '/approvals/pr-qty/$idString';
        }
        break;
      default:
        path = '/approvals';
    }

    debugPrint('Navigating to deep-link path: $path');
    try {
      _ref.read(routerProvider).push(path);
    } catch (e) {
      debugPrint('Navigation failed: $e');
    }
  }

  Future<String?> getDeviceToken() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      return null;
    }

    try {
      final token = await FirebaseMessaging.instance.getToken();
      debugPrint('FCM Device Token: $token');
      return token;
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }
}
