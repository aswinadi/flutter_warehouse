import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/running_stock.dart';
import '../providers/inventory_breakdown_provider.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';

class RunningStockDetailsSheet extends ConsumerWidget {
  final RunningStockItem item;

  const RunningStockDetailsSheet({
    super.key,
    required this.item,
  });

  String _formatNum(double value) {
    final formatter = NumberFormat('#,##0.##', 'id_ID');
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakdownAsync = ref.watch(inventoryBreakdownBySkuProvider(item.sku));
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryColor = CupertinoColors.secondaryLabel.resolveFrom(context);

    return CupertinoGlassContainer(
      borderRadius: CupertinoSpacing.dialogRadius,
      blurSigma: 30.0,
      padding: EdgeInsets.zero,
      child: SafeArea(
        top: false,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Indicator
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey3.resolveFrom(context),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: CupertinoColors.activeBlue.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.sku,
                            style: context.caption1.copyWith(
                              color: CupertinoColors.activeBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.name,
                          style: context.headline.copyWith(
                            fontWeight: FontWeight.bold,
                            color: labelColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    child: const Icon(CupertinoIcons.xmark_circle_fill, size: 26, color: CupertinoColors.systemGrey),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Breakdown Content
              Expanded(
                child: breakdownAsync.when(
                  data: (breakdown) {
                    final onHand = breakdown.onHand;
                    final inTransit = breakdown.inTransit;
                    final ordered = breakdown.ordered;

                    if (onHand.isEmpty && inTransit.isEmpty && ordered.isEmpty) {
                      return Center(
                        child: Text(
                          'Tidak ada detail breakdown untuk stok barang ini.',
                          style: context.subhead.copyWith(color: secondaryColor),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        // 1. On Hand Stock Breakdown
                        _buildSectionHeader(
                          context,
                          title: 'Stok On Hand (Tersedia)',
                          icon: CupertinoIcons.archivebox_fill,
                          color: CupertinoColors.activeBlue,
                          totalQty: item.onHandQty,
                          unit: item.unit,
                        ),
                        const SizedBox(height: 8),
                        if (onHand.isEmpty)
                          _buildEmptySectionText(context, 'Tidak ada stok fisik di gudang')
                        else
                          ...onHand.map((wh) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: CupertinoGlassContainer(
                                borderRadius: CupertinoSpacing.cardRadius,
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          wh.warehouseName,
                                          style: context.subhead.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: labelColor,
                                          ),
                                        ),
                                        Text(
                                          '${_formatNum(wh.quantity)} ${item.unit}',
                                          style: context.subhead.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: CupertinoColors.activeBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (wh.locations.isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      Container(height: 0.5, color: CupertinoColors.separator.resolveFrom(context)),
                                      const SizedBox(height: 6),
                                      ...wh.locations.map((loc) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '  Lokasi: ${loc.locationCode}',
                                                style: context.caption1.copyWith(color: secondaryColor),
                                              ),
                                              Text(
                                                '${_formatNum(loc.quantity)} ${item.unit}',
                                                style: context.caption1.copyWith(color: labelColor),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          }),

                        const SizedBox(height: 16),

                        // 2. In Transit Stock Breakdown
                        _buildSectionHeader(
                          context,
                          title: 'Stok In Transit (Pengiriman)',
                          icon: CupertinoIcons.paperplane_fill,
                          color: CupertinoColors.activeOrange,
                          totalQty: item.inTransitQty,
                          unit: item.unit,
                        ),
                        const SizedBox(height: 8),
                        if (inTransit.isEmpty)
                          _buildEmptySectionText(context, 'Tidak ada pengiriman berjalan')
                        else
                          ...inTransit.map((tr) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: CupertinoGlassContainer(
                                borderRadius: CupertinoSpacing.cardRadius,
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tr.transferNumber,
                                            style: context.caption1.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: labelColor,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${tr.sourceWarehouseName} ➔ ${tr.destinationWarehouseName}',
                                            style: context.caption2.copyWith(color: secondaryColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${_formatNum(tr.quantity)} ${item.unit}',
                                      style: context.subhead.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: CupertinoColors.activeOrange,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),

                        const SizedBox(height: 16),

                        // 3. Ordered Stock Breakdown
                        _buildSectionHeader(
                          context,
                          title: 'Stok Ordered (Pesanan PO)',
                          icon: CupertinoIcons.cart_fill,
                          color: CupertinoColors.activeGreen,
                          totalQty: item.orderedQty,
                          unit: item.unit,
                        ),
                        const SizedBox(height: 8),
                        if (ordered.isEmpty)
                          _buildEmptySectionText(context, 'Tidak ada pesanan PO aktif')
                        else
                          ...ordered.map((po) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: CupertinoGlassContainer(
                                borderRadius: CupertinoSpacing.cardRadius,
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            po.poNumber,
                                            style: context.caption1.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: labelColor,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Gudang Tujuan: ${po.warehouseName}',
                                            style: context.caption2.copyWith(color: secondaryColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${_formatNum(po.quantity)} ${item.unit}',
                                      style: context.subhead.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: CupertinoColors.activeGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                      ],
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CupertinoActivityIndicator(radius: 14),
                    ),
                  ),
                  error: (err, _) => Center(
                    child: Text(
                      'Gagal memuat detail breakdown: $err',
                      style: context.caption1.copyWith(color: CupertinoColors.systemRed),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required double totalQty,
    required String unit,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          title,
          style: context.subhead.copyWith(
            fontWeight: FontWeight.bold,
            color: CupertinoColors.label.resolveFrom(context),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${_formatNum(totalQty)} $unit',
            style: context.caption2.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptySectionText(BuildContext context, String message) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
      child: Text(
        '- $message',
        style: context.caption1.copyWith(
          color: CupertinoColors.secondaryLabel.resolveFrom(context),
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
