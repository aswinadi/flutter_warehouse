import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/notification_provider.dart';
import '../models/notification_model.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';

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

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Notifikasi'),
            backgroundColor: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context).withValues(alpha: 0.96),
            border: Border(
              bottom: BorderSide(
                color: CupertinoColors.separator.resolveFrom(context),
                width: 0.5,
              ),
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.checkmark_seal, size: 22),
              onPressed: () {
                ref.read(notificationsListProvider.notifier).markAllAsRead();
                CupertinoGlassToast.showSuccess(context, 'Semua notifikasi ditandai sebagai dibaca.');
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
                          const SizedBox(height: CupertinoSpacing.l),
                          Text(
                            'Tidak ada pemberitahuan',
                            style: context.headline.copyWith(
                              fontWeight: FontWeight.bold,
                              color: labelColor,
                            ),
                          ),
                          const SizedBox(height: CupertinoSpacing.s),
                          Text(
                            'Semua notifikasi baru akan muncul di sini.',
                            style: context.subhead.copyWith(
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

              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CupertinoSpacing.screenMargin,
                  vertical: CupertinoSpacing.s,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == notifications.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: CupertinoSpacing.xxl),
                          child: Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        );
                      }

                      final notification = notifications[index];
                      final iconColor = _getColorForType(notification.type);

                      return Container(
                        margin: const EdgeInsets.only(bottom: CupertinoSpacing.s),
                        child: CupertinoGlassContainer(
                          borderRadius: CupertinoSpacing.cardRadius,
                          backgroundColor: notification.isRead 
                              ? null 
                              : CupertinoColors.activeBlue.resolveFrom(context).withValues(alpha: 0.05),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => _handleNotificationTap(notification),
                            child: Padding(
                              padding: const EdgeInsets.all(CupertinoSpacing.l),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Unread Dot Indicator
                                  if (!notification.isRead)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6.0, right: 8.0),
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: CupertinoColors.activeBlue,
                                        ),
                                      ),
                                    ),
                                  // Notification Icon
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: iconColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      _getIconForType(notification.type),
                                      color: iconColor,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: CupertinoSpacing.m),
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
                                                style: context.subhead.copyWith(
                                                  fontWeight: notification.isRead 
                                                      ? FontWeight.w600 
                                                      : FontWeight.bold,
                                                  color: labelColor,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              notification.timeAgo,
                                              style: context.caption2.copyWith(
                                                color: secondaryLabelColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          notification.message,
                                          style: context.footnote.copyWith(
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
                        ),
                      );
                    },
                    childCount: notifications.length + (hasMore ? 1 : 0),
                  ),
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
                        style: context.headline.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        err.toString(),
                        style: context.footnote.copyWith(color: secondaryLabelColor),
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
