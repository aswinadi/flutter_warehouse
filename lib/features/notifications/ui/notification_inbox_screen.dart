import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider, Scrollbar, Colors;
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
        return CupertinoIcons.bag;
      case 'invoice':
        return CupertinoIcons.doc_text;
      case 'payment_request':
        return CupertinoIcons.creditcard;
      case 'purchase_request':
        return CupertinoIcons.doc_plaintext;
      default:
        return CupertinoIcons.bell;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'purchase_order':
        return CupertinoColors.systemTeal;
      case 'invoice':
        return CupertinoColors.systemBlue;
      case 'payment_request':
        return CupertinoColors.systemPurple;
      case 'purchase_request':
        return CupertinoColors.systemOrange;
      default:
        return CupertinoColors.systemGrey;
    }
  }

  void _handleNotificationTap(AppNotification notification) {
    if (!notification.isRead) {
      ref.read(notificationsListProvider.notifier).markAsRead(notification.id);
    }

    final data = notification.data;
    final type = data['type'] ?? notification.type;
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
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Notifikasi'),
            backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.checkmark_seal, size: 22),
              onPressed: () {
                ref.read(notificationsListProvider.notifier).markAllAsRead();
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('Sukses'),
                    content: const Text('Semua notifikasi ditandai sebagai dibaca.'),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text('OK'),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () => ref.refresh(notificationsListProvider.future),
          ),
          notificationsAsync.when(
            data: (notifications) {
              if (notifications.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              CupertinoIcons.bell_slash,
                              size: 48,
                              color: CupertinoColors.secondaryLabel,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tidak ada pemberitahuan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: labelColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Semua notifikasi baru akan muncul di sini.',
                            style: TextStyle(
                              fontSize: 14,
                              color: secondaryLabelColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              final hasMore = ref.watch(notificationsListProvider.notifier).hasMore;

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == notifications.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      );
                    }

                    final notification = notifications[index];
                    final iconColor = _getColorForType(notification.type);

                    return Container(
                      decoration: BoxDecoration(
                        color: notification.isRead 
                            ? CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context)
                            : CupertinoColors.systemBackground.resolveFrom(context),
                        border: Border(
                          bottom: BorderSide(color: separatorColor, width: 0.5),
                        ),
                      ),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _handleNotificationTap(notification),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Unread Dot Indicator
                              Padding(
                                padding: const EdgeInsets.only(top: 14.0, right: 10.0),
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: notification.isRead 
                                        ? Colors.transparent 
                                        : CupertinoColors.activeBlue,
                                  ),
                                ),
                              ),
                              // Notification Icon
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: iconColor.withValues(alpha: 0.1),
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
                                              fontWeight: notification.isRead 
                                                  ? FontWeight.w600 
                                                  : FontWeight.bold,
                                              fontSize: 14,
                                              color: labelColor,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          notification.timeAgo,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: secondaryLabelColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      notification.message,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: notification.isRead 
                                            ? secondaryLabelColor 
                                            : labelColor,
                                        fontWeight: notification.isRead 
                                            ? FontWeight.normal 
                                            : FontWeight.w500,
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
                  childCount: notifications.length + (hasMore ? 1 : 0),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            ),
            error: (err, _) => SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.exclamationmark_triangle,
                        color: CupertinoColors.systemRed,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Gagal memuat notifikasi',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: labelColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        err.toString(),
                        style: TextStyle(color: secondaryLabelColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      CupertinoButton.filled(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        onPressed: () => ref.refresh(notificationsListProvider),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
