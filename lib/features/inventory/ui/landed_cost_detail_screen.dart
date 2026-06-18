import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider, Scrollbar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/landed_cost.dart';
import '../providers/landed_cost_repository.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';
import '../../../core/widgets/cupertino_glass_dialog.dart';
import '../../../core/utils/currency_utils.dart';

class LandedCostDetailScreen extends ConsumerStatefulWidget {
  final int landedCostId;
  const LandedCostDetailScreen({super.key, required this.landedCostId});

  @override
  ConsumerState<LandedCostDetailScreen> createState() => _LandedCostDetailScreenState();
}

class _LandedCostDetailScreenState extends ConsumerState<LandedCostDetailScreen> {
  bool _isSubmitting = false;

  Future<void> _approveLandedCost() async {
    final confirm = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoGlassDialog(
        title: const Text('Setujui & Terapkan HPP'),
        content: const Text(
            'Apakah Anda yakin ingin menyetujui landed cost ini dan menerapkan kenaikan HPP ke persediaan? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          CupertinoGlassDialogAction(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context, false),
          ),
          CupertinoGlassDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Setujui'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isSubmitting = true);
      try {
        await ref.read(landedCostRepositoryProvider).approveLandedCost(widget.landedCostId);
        ref.invalidate(landedCostListProvider);
        ref.invalidate(landedCostDetailProvider(widget.landedCostId));
        if (mounted) {
          CupertinoGlassToast.showSuccess(context, 'Landed Cost berhasil disetujui & HPP diterapkan.');
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted) context.pop();
          });
        }
      } catch (e) {
        if (mounted) {
          CupertinoGlassToast.showError(context, 'Gagal menyetujui: $e');
        }
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'approved':
        bgColor = CupertinoColors.systemGreen.withValues(alpha: 0.15);
        textColor = CupertinoColors.systemGreen;
        break;
      case 'pending':
        bgColor = CupertinoColors.systemOrange.withValues(alpha: 0.15);
        textColor = CupertinoColors.systemOrange;
        break;
      case 'cancelled':
        bgColor = CupertinoColors.systemRed.withValues(alpha: 0.15);
        textColor = CupertinoColors.systemRed;
        break;
      case 'draft':
      default:
        bgColor = CupertinoColors.systemGrey.withValues(alpha: 0.15);
        textColor = CupertinoColors.systemGrey;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.xs + 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.footnote.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: context.subhead.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getShipmentLabel(LandedCostShipment s) {
    if (s.receivingHeader == null) return s.receivingHeaderId.toString();
    final header = s.receivingHeader!;
    return header.deliveryOrderNumber != null && header.deliveryOrderNumber!.isNotEmpty
        ? '${header.deliveryOrderNumber} (${header.receivingNumber})'
        : header.receivingNumber;
  }

  Map<int, double> _calculateAllItemAllocations(double totalCostPool, List<LandedCostShipment> shipments) {
    final allocations = <int, double>{};
    final totalPool = totalCostPool.round();

    // Filter active shipments (those with at least one selected item)
    final activeShipments = shipments.where((s) {
      final items = s.items ?? <LandedCostItem>[];
      return items.any((it) => it.isSelected);
    }).toList();

    // 1. Calculate shipment pools
    double totalShipmentPct = 0.0;
    for (final s in activeShipments) {
      totalShipmentPct += s.shipmentPercentage;
    }
    if (totalShipmentPct == 0.0) totalShipmentPct = 100.0;

    final shipmentPools = <int, int>{};
    int totalAllocatedShipments = 0;

    for (int i = 0; i < activeShipments.length; i++) {
      final shipment = activeShipments[i];
      if (i == activeShipments.length - 1) {
        shipmentPools[shipment.id] = totalPool - totalAllocatedShipments;
      } else {
        final portion = ((shipment.shipmentPercentage / totalShipmentPct) * totalPool).round();
        shipmentPools[shipment.id] = portion;
        totalAllocatedShipments += portion;
      }
    }

    // 2. Calculate item portions in each shipment
    for (final shipment in shipments) {
      final shipmentPool = shipmentPools[shipment.id] ?? 0;
      final items = shipment.items ?? <LandedCostItem>[];

      final selectedItems = items.where((it) => it.isSelected).toList();
      double totalItemPct = 0.0;
      for (final it in selectedItems) {
        totalItemPct += it.itemPercentage;
      }
      if (totalItemPct == 0.0) totalItemPct = 100.0;

      int totalAllocatedItems = 0;
      for (int j = 0; j < selectedItems.length; j++) {
        final item = selectedItems[j];
        if (j == selectedItems.length - 1) {
          allocations[item.id] = (shipmentPool - totalAllocatedItems).toDouble();
        } else {
          final portion = ((item.itemPercentage / totalItemPct) * shipmentPool).round();
          allocations[item.id] = portion.toDouble();
          totalAllocatedItems += portion;
        }
      }
    }

    return allocations;
  }

  double _getDisplayNewHpp(LandedCostItem item, Map<int, double> allocations, String status) {
    if (status.toLowerCase() == 'approved') {
      if (!item.isSelected || item.receivedQty <= 0) {
        return item.originalPrice;
      }
      return item.originalPrice + (item.allocatedAmount / item.receivedQty);
    } else {
      if (!item.isSelected || item.receivedQty <= 0) {
        return item.originalPrice;
      }
      final itemCost = allocations[item.id] ?? 0.0;
      return item.originalPrice + (itemCost / item.receivedQty);
    }
  }

  double _getDisplayAllocatedAmount(LandedCostItem item, Map<int, double> allocations, String status) {
    if (status.toLowerCase() == 'approved') {
      return item.allocatedAmount;
    } else {
      if (!item.isSelected || item.receivedQty <= 0) {
        return 0.0;
      }
      return allocations[item.id] ?? 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(landedCostDetailProvider(widget.landedCostId));
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final borderCol = CupertinoColors.separator.resolveFrom(context);

    final content = detailAsync.when(
      data: (cost) {
        final totalCostPool = cost.totalAmount;
        final isPending = cost.status.toLowerCase() == 'pending';
        final components = cost.components ?? [];
        final shipments = cost.shipments ?? [];
        final allocations = _calculateAllItemAllocations(totalCostPool, shipments);

        return Column(
          children: [
            Expanded(
              child: Scrollbar(
                child: ListView(
                  padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                  children: [
                    // General Info Card
                    CupertinoGlassContainer(
                      borderRadius: CupertinoSpacing.cardRadius,
                      padding: const EdgeInsets.all(CupertinoSpacing.m),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  cost.referenceNumber,
                                  style: context.title3.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              _buildStatusBadge(cost.status),
                            ],
                          ),
                          const SizedBox(height: CupertinoSpacing.m),
                          _buildInfoRow('Pemasok / Transporter', cost.supplierName),
                          _buildInfoRow('Kode Pemasok', cost.supplierCode),
                          _buildInfoRow('Tanggal Posting', _formatDate(cost.postingDate)),
                          _buildInfoRow('Total Biaya', formatWithCurrency(totalCostPool, cost.currency), isBold: true),
                          if (cost.description != null && cost.description!.isNotEmpty) ...[
                            const Divider(color: CupertinoColors.separator, height: 16),
                            Text(
                              'Catatan:',
                              style: context.footnote.copyWith(fontWeight: FontWeight.bold, color: secondaryLabel),
                            ),
                            const SizedBox(height: CupertinoSpacing.xs),
                            Text(
                              cost.description!,
                              style: context.subhead.copyWith(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: CupertinoSpacing.screenMargin),

                    // Cost Components Section
                    Text(
                      'Komponen Biaya',
                      style: context.callout.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                    ),
                    const SizedBox(height: CupertinoSpacing.s),
                    if (components.isEmpty)
                      CupertinoGlassContainer(
                        borderRadius: CupertinoSpacing.cardRadius,
                        padding: const EdgeInsets.all(CupertinoSpacing.m),
                        child: Center(
                          child: Text(
                            'Tidak ada komponen biaya.',
                            style: context.subhead.copyWith(color: secondaryLabel),
                          ),
                        ),
                      )
                    else
                      ...components.map((comp) {
                        String refLabel = '-';
                        if (comp.refType == 'packing_list' && comp.container != null) {
                          refLabel = 'PL: ${comp.container!.containerNumber}';
                        } else if (comp.refType == 'invoice' && comp.invoice != null) {
                          refLabel = 'Inv: ${comp.invoice!.invoiceNumber}';
                        }

                        // Human readable category
                        String catLabel = comp.category;
                        switch (comp.category.toLowerCase()) {
                          case 'transport':
                            catLabel = 'Transportasi';
                            break;
                          case 'labor':
                            catLabel = 'Tenaga Kerja';
                            break;
                          case 'shipping':
                            catLabel = 'Pengiriman/Logistik';
                            break;
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: CupertinoSpacing.s),
                          child: CupertinoGlassContainer(
                            borderRadius: CupertinoSpacing.cardRadius,
                            padding: const EdgeInsets.all(CupertinoSpacing.m),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        catLabel,
                                        style: context.subhead.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Referensi: $refLabel',
                                        style: context.caption2.copyWith(color: secondaryLabel),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  formatWithCurrency(comp.amount, cost.currency),
                                  style: context.callout.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    const SizedBox(height: CupertinoSpacing.screenMargin),

                    // Allocations Section
                    Text(
                      'Detail Alokasi HPP',
                      style: context.callout.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                    ),
                    const SizedBox(height: CupertinoSpacing.s),
                    if (shipments.isEmpty)
                      CupertinoGlassContainer(
                        borderRadius: CupertinoSpacing.cardRadius,
                        padding: const EdgeInsets.all(CupertinoSpacing.m),
                        child: Center(
                          child: Text(
                            'Tidak ada pengiriman yang dialokasikan.',
                            style: context.subhead.copyWith(color: secondaryLabel),
                          ),
                        ),
                      )
                    else
                      ...shipments.map((shipment) {
                        final shipmentLabel = _getShipmentLabel(shipment);
                        final items = shipment.items ?? [];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: CupertinoSpacing.m),
                          child: CupertinoGlassContainer(
                            borderRadius: CupertinoSpacing.cardRadius,
                            padding: const EdgeInsets.all(CupertinoSpacing.m),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        shipmentLabel,
                                        style: context.callout.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: CupertinoColors.activeBlue.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '${shipment.shipmentPercentage.toStringAsFixed(1)}%',
                                        style: context.caption1.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: CupertinoColors.activeBlue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(color: CupertinoColors.separator, height: 16),
                                ...items.map((item) {
                                  final details = item.receivingDetail;
                                  final productName = details?.product?.name ?? 'Unknown Item';
                                  final sku = details?.product?.sku ?? '-';
                                  final qty = details?.receivedQty ?? 0.0;
                                  final unit = details?.unit ?? '';
                                  final originalPrice = item.originalPrice;
                                  final newHpp = _getDisplayNewHpp(item, allocations, cost.status);
                                  final allocatedAmt = _getDisplayAllocatedAmount(item, allocations, cost.status);

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.s),
                                    child: Opacity(
                                      opacity: item.isSelected ? 1.0 : 0.4,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            item.isSelected ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.circle,
                                            size: 16,
                                            color: item.isSelected ? CupertinoColors.systemGreen : CupertinoColors.inactiveGray,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  productName,
                                                  style: context.footnote.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: labelColor,
                                                  ),
                                                ),
                                                Text(
                                                  'SKU: $sku | Qty: ${qty.toStringAsFixed(0)} $unit',
                                                  style: context.caption2.copyWith(color: secondaryLabel),
                                                ),
                                                const SizedBox(height: 2),
                                                if (item.isSelected) ...[
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'HPP: ${formatWithCurrency(originalPrice, cost.currency)}',
                                                        style: context.caption2.copyWith(color: secondaryLabel),
                                                      ),
                                                      const Icon(CupertinoIcons.right_chevron, size: 10, color: CupertinoColors.inactiveGray),
                                                      Text(
                                                        formatWithCurrency(newHpp, cost.currency),
                                                        style: context.caption2.copyWith(
                                                          color: CupertinoColors.systemGreen,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    'Alokasi: ${formatWithCurrency(allocatedAmt, cost.currency)} (${item.itemPercentage.toStringAsFixed(1)}%)',
                                                    style: context.caption2.copyWith(
                                                      color: CupertinoColors.activeBlue,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ] else
                                                  Text(
                                                    'Tidak Dialokasikan',
                                                    style: context.caption2.copyWith(
                                                      color: secondaryLabel,
                                                      fontStyle: FontStyle.italic,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
            if (isPending)
              SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                  decoration: BoxDecoration(
                    color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                    border: const Border(top: BorderSide(color: CupertinoColors.separator, width: 0.5)),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      color: const Color(0xFF6E56CF),
                      borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                      onPressed: _isSubmitting ? null : _approveLandedCost,
                      child: _isSubmitting
                          ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                          : const Text(
                              'Setujui & Terapkan HPP',
                              style: TextStyle(
                                color: CupertinoColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (err, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.exclamationmark_triangle, size: 36, color: CupertinoColors.systemRed),
              const SizedBox(height: 12),
              Text(
                'Gagal memuat detail landed cost:\n$err',
                textAlign: TextAlign.center,
                style: context.subhead.copyWith(color: secondaryLabel),
              ),
            ],
          ),
        ),
      ),
    );

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        middle: Text(
          'Detail Landed Cost',
          style: context.headline.copyWith(color: labelColor),
        ),
        previousPageTitle: 'Kembali',
      ),
      child: SafeArea(child: content),
    );
  }
}
