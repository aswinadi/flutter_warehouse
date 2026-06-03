import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/notification_provider.dart';
import '../models/notification_model.dart';

class NotificationInboxScreen extends ConsumerStatefulWidget {
  const NotificationInboxScreen({super.key});

  @override
  ConsumerState<NotificationInboxScreen> createState() => _NotificationInboxScreenState();
}

class _NotificationInboxScreenState extends ConsumerState<NotificationInboxScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(notificationsListProvider.notifier).loadMore();
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'purchase_order':
        return Icons.shopping_bag_outlined;
      case 'invoice':
        return Icons.receipt_long_outlined;
      case 'payment_request':
        return Icons.payment_outlined;
      case 'purchase_request':
        return Icons.assignment_outlined;
      default:
        return Icons.notifications_none_outlined;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'purchase_order':
        return Colors.teal;
      case 'invoice':
        return Colors.blue;
      case 'payment_request':
        return Colors.purple;
      case 'purchase_request':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _handleNotificationTap(AppNotification notification) {
    // Mark as read
    if (!notification.isRead) {
      ref.read(notificationsListProvider.notifier).markAsRead(notification.id);
    }

    // Direct routing logic matching notification_service.dart
    final data = notification.data;
    final type = data['type'] ?? notification.type; // Fallback to type if data type is null
    final id = data['id'] ?? data['pr_id'] ?? data['po_id'] ?? data['invoice_id'] ?? data['payment_request_id'];

    if (type == null || id == null) {
      context.push('/approvals');
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

    context.push(path);
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Ultra light background matching Notion style
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A), // Notion Navy
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Kotak Masuk Notifikasi',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            tooltip: 'Tandai semua dibaca',
            icon: const Icon(Icons.done_all),
            onPressed: () {
              ref.read(notificationsListProvider.notifier).markAllAsRead();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Semua notifikasi ditandai sebagai dibaca')),
              );
            },
          ),
        ],
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE2E8F0),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_off_outlined,
                      size: 48,
                      color: Colors.blueGrey[400],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada pemberitahuan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Semua notifikasi baru akan muncul di sini.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey[400],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(notificationsListProvider.future),
            child: ListView.separated(
              controller: _scrollController,
              itemCount: notifications.length + (ref.watch(notificationsListProvider.notifier).hasMore ? 1 : 0),
              separatorBuilder: (context, index) => const Divider(
                color: Color(0xFFE2E8F0),
                height: 1,
              ),
              itemBuilder: (context, index) {
                if (index == notifications.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final notification = notifications[index];
                final iconColor = _getColorForType(notification.type);

                return Material(
                  color: notification.isRead ? Colors.transparent : const Color(0xFFEEF2F6),
                  child: InkWell(
                    onTap: () => _handleNotificationTap(notification),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Badge / Status Dot for Unread items
                          Padding(
                            padding: const EdgeInsets.only(top: 14.0, right: 12.0),
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: notification.isRead ? Colors.transparent : const Color(0xFF4F46E5), // Indigo unread dot
                              ),
                            ),
                          ),
                          // Notification Icon
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: iconColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              _getIconForType(notification.type),
                              color: iconColor,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          // Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notification.title,
                                        style: TextStyle(
                                          fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.bold,
                                          fontSize: 14,
                                          color: notification.isRead ? const Color(0xFF334155) : const Color(0xFF0F172A),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      notification.timeAgo,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF94A3B8),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notification.message,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: notification.isRead ? const Color(0xFF64748B) : const Color(0xFF334155),
                                    fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w500,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 12),
                Text(
                  'Gagal memuat notifikasi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
                ),
                const SizedBox(height: 8),
                Text(err.toString(), style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(notificationsListProvider),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
