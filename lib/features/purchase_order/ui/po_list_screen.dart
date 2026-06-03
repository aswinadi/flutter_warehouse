import 'package:flutter/material.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.purchaseOrders),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(purchaseOrdersProvider),
          ),
        ],
      ),
      body: Column(
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
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final po = orders[index];
                    return _POCard(po: po);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}

class _POCard extends StatelessWidget {
  final PurchaseOrder po;
  const _POCard({required this.po});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigate to detail
        },
        borderRadius: BorderRadius.circular(12),
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
                      color: Colors.blue[900],
                    ),
                  ),
                  _StatusChip(status: po.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                po.supplierName,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'Estimasi: ${po.expectedDate}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: po.totalItems > 0 ? po.receivedItems / po.totalItems : 0,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation(Colors.blue.shade700),
              ),
              const SizedBox(height: 4),
              Text(
                'Diterima: ${po.receivedItems} / ${po.totalItems} barang',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
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
    Color color;
    switch (status.toLowerCase()) {
      case 'completed':
        color = Colors.green;
        break;
      case 'partial':
        color = Colors.blue;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
