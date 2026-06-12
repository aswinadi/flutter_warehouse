import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors; // kept for legacy colors
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import '../providers/purchase_order_provider.dart';
import '../models/purchase_order.dart';
import '../../../core/widgets/company_switcher.dart';

class POListScreen extends ConsumerStatefulWidget {
  const POListScreen({super.key});

  @override
  ConsumerState<POListScreen> createState() => _POListScreenState();
}

class _POListScreenState extends ConsumerState<POListScreen> {
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
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll * 0.9) {
      ref.read(purchaseOrdersProvider().notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final poAsync = ref.watch(purchaseOrdersProvider());

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        middle: Text(AppLocalizations.of(context)!.purchaseOrders),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.refresh, size: 22),
          onPressed: () => ref.invalidate(purchaseOrdersProvider),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const CompanySwitcher(),
            Expanded(
              child: poAsync.when(
                data: (orders) {
                  if (orders.isEmpty) {
                    return const Center(child: Text('Tidak ada Pesanan Pembelian (PO) yang ditemukan'));
                  }
                  final hasMore = ref.watch(purchaseOrdersProvider().notifier).hasMore;
                  final showLoader = poAsync.isLoading && hasMore;

                  return ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length + (showLoader ? 1 : 0),
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index == orders.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CupertinoActivityIndicator()),
                        );
                      }
                      final po = orders[index];
                      return _POCard(po: po);
                    },
                  );
                },
                loading: () => const Center(child: CupertinoActivityIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _POCard extends StatelessWidget {
  final PurchaseOrder po;
  const _POCard({required this.po});

  @override
  Widget build(BuildContext context) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    final progress = po.totalItems > 0 ? po.receivedItems / po.totalItems : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: separatorColor, width: 0.5),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // Navigate to detail
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    po.poNumber,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: CupertinoColors.activeBlue.resolveFrom(context),
                    ),
                  ),
                  _StatusChip(status: po.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                po.supplierName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: labelColor),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(CupertinoIcons.calendar, size: 14, color: secondaryLabel),
                  const SizedBox(width: 4),
                  Text(
                    'Estimasi: ${po.expectedDate}',
                    style: TextStyle(color: secondaryLabel, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Custom iOS Progress Bar
              Container(
                height: 6,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemFill.resolveFrom(context),
                  borderRadius: BorderRadius.circular(3),
                ),
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: CupertinoColors.activeBlue.resolveFrom(context),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Diterima: ${po.receivedItems} / ${po.totalItems} barang',
                style: TextStyle(fontSize: 12, color: secondaryLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    CupertinoDynamicColor color;
    switch (status.toLowerCase()) {
      case 'completed':
        color = CupertinoColors.activeGreen;
        break;
      case 'partial':
        color = CupertinoColors.activeBlue;
        break;
      case 'pending':
        color = CupertinoColors.systemOrange;
        break;
      default:
        color = CupertinoColors.systemGrey;
    }

    final resolvedColor = color.resolveFrom(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: resolvedColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: resolvedColor, width: 0.5),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: resolvedColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
