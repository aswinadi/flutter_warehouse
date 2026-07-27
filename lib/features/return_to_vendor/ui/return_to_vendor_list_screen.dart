import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../core/widgets/company_switcher.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../providers/return_to_vendor_provider.dart';
import 'return_to_vendor_detail_screen.dart';
import 'return_to_vendor_form_screen.dart';

class ReturnToVendorListScreen extends ConsumerStatefulWidget {
  const ReturnToVendorListScreen({super.key});

  @override
  ConsumerState<ReturnToVendorListScreen> createState() =>
      _ReturnToVendorListScreenState();
}

class _ReturnToVendorListScreenState
    extends ConsumerState<ReturnToVendorListScreen> {
  String _selectedStatus = 'all';

  @override
  Widget build(BuildContext context) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    final rtvAsync = ref.watch(returnToVendorListProvider({
      'status': _selectedStatus,
    }));

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Retur Supplier (RTV)'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.add),
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (_) => const ReturnToVendorFormScreen(),
                  ),
                ).then((_) => ref.invalidate(returnToVendorListProvider));
              },
            ),
            const CompanySwitcher(),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: CupertinoSpacing.m),

            // Status Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.m),
              child: Row(
                children: [
                  _buildFilterChip('all', 'Semua Status'),
                  const SizedBox(width: 8),
                  _buildFilterChip('draft', 'Draft'),
                  const SizedBox(width: 8),
                  _buildFilterChip('approved', 'Approved'),
                  const SizedBox(width: 8),
                  _buildFilterChip('shipped', 'Shipped / Selesai'),
                ],
              ),
            ),

            const SizedBox(height: CupertinoSpacing.m),

            // RTV List
            Expanded(
              child: rtvAsync.when(
                data: (response) {
                  final items = response.data;
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'Belum ada dokumen Retur Supplier (RTV)',
                        style: context.subhead.copyWith(color: secondaryLabel),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(CupertinoSpacing.m),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: CupertinoSpacing.s),
                    itemBuilder: (ctx, idx) {
                      final item = items[idx];
                      final statusColor = _getStatusColor(item.status, ctx);

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (_) => ReturnToVendorDetailScreen(rtvId: item.id),
                            ),
                          ).then((_) => ref.invalidate(returnToVendorListProvider));
                        },
                        child: CupertinoGlassContainer(
                          borderRadius: 16.0,
                          padding: const EdgeInsets.all(CupertinoSpacing.m),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.rtvNumber,
                                    style: context.headline.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: labelColor,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: statusColor.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      item.status.toUpperCase(),
                                      style: context.caption1.copyWith(
                                        color: statusColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Supplier: ${item.supplierName ?? "-"} | Gudang: ${item.warehouseName ?? "-"}',
                                style: context.subhead.copyWith(
                                  color: secondaryLabel,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Tgl: ${item.returnDate}',
                                    style: context.footnote.copyWith(color: secondaryLabel),
                                  ),
                                  Text(
                                    formatWithCurrency(item.totalAmount, 'IDR'),
                                    style: context.title2.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: labelColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CupertinoActivityIndicator()),
                error: (err, stack) => Center(
                  child: Text('Error: $err', style: TextStyle(color: CupertinoColors.destructiveRed.resolveFrom(context))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedStatus == value;
    final activeColor = CupertinoColors.activeBlue.resolveFrom(context);

    return GestureDetector(
      onTap: () => setState(() => _selectedStatus = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : CupertinoColors.tertiarySystemFill.resolveFrom(context),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? CupertinoColors.white : CupertinoColors.label.resolveFrom(context),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status, BuildContext ctx) {
    switch (status.toLowerCase()) {
      case 'draft':
        return CupertinoColors.systemGrey.resolveFrom(ctx);
      case 'approved':
        return CupertinoColors.activeBlue.resolveFrom(ctx);
      case 'shipped':
      case 'completed':
        return CupertinoColors.systemGreen.resolveFrom(ctx);
      case 'cancelled':
        return CupertinoColors.systemRed.resolveFrom(ctx);
      default:
        return CupertinoColors.systemGrey.resolveFrom(ctx);
    }
  }
}
