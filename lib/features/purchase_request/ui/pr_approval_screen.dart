import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors; // kept for legacy reference
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:printing/printing.dart';
import 'package:go_router/go_router.dart';
import '../models/purchase_request.dart';
import '../providers/purchase_request_detail_provider.dart';
import '../providers/purchase_request_provider.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../core/api/dio_client.dart';

class PRApprovalScreen extends ConsumerWidget {
  final int prId;
  const PRApprovalScreen({super.key, required this.prId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prAsync = ref.watch(purchaseRequestDetailProvider(prId));

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Detail PR'),
        trailing: prAsync.when(
          data: (pr) => CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.printer, size: 22),
            onPressed: () {
              context.push('/pdf-preview?title=Purchase Request ${pr.code}&url_path=pdf/purchase-request/${pr.id}');
            },
          ),
          loading: () => const SizedBox(),
          error: (_, __) => const SizedBox(),
        ),
      ),
      child: SafeArea(
        child: PRDetailsView(prId: prId),
      ),
    );
  }
}

class PRDetailsView extends ConsumerStatefulWidget {
  final int prId;
  const PRDetailsView({super.key, required this.prId});

  @override
  ConsumerState<PRDetailsView> createState() => _PRDetailsViewState();
}

class _PRDetailsViewState extends ConsumerState<PRDetailsView> {
  bool _isAutoAssigning = false;
  bool _isSubmittingToBod = false;
  final Set<int> _selectedComparisonIds = {};
  bool _isGeneratingPos = false;
  int _currentTab = 0; // 0 for requested items, 1 for comparisons

  Future<void> _handleAutoAssign(String strategy) async {
    setState(() => _isAutoAssigning = true);
    try {
      final repo = ref.read(purchaseRequestRepositoryProvider);
      await repo.autoAssignVendors(widget.prId, strategy: strategy);

      ref.invalidate(purchaseRequestDetailProvider(widget.prId));
      ref.invalidate(purchaseRequestsProvider);

      _showNotification('Penetapan otomatis berhasil.');
    } catch (e) {
      _showNotification('Gagal menetapkan otomatis: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isAutoAssigning = false);
      }
    }
  }

  Future<void> _handleSubmitToBod() async {
    setState(() => _isSubmittingToBod = true);
    try {
      final repo = ref.read(purchaseRequestRepositoryProvider);
      await repo.submitToBod(widget.prId);

      ref.invalidate(purchaseRequestDetailProvider(widget.prId));
      ref.invalidate(purchaseRequestsProvider);

      _showNotification('Kuantitas berhasil diajukan ke BOD untuk pemilihan vendor.');
    } catch (e) {
      _showNotification('Gagal mengajukan: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isSubmittingToBod = false);
      }
    }
  }

  void _showStrategyDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Tetapkan Vendor Otomatis'),
          content: const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text('Pilih strategi untuk menemukan dan menetapkan vendor terbaik secara otomatis berdasarkan riwayat pembelian:'),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                _handleAutoAssign('lowest_price');
              },
              child: const Text('Harga Terendah'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                _handleAutoAssign('last_supplier');
              },
              child: const Text('Pemasok Terakhir'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  void _showNotification(String message, {bool isError = false}) {
    if (!mounted) return;
    
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 24,
        left: 24,
        right: 24,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: DefaultTextStyle(
              style: const TextStyle(color: CupertinoColors.white, fontFamily: '.SF Pro Text'),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 250),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - value) * -20),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isError ? CupertinoColors.systemRed : CupertinoColors.activeGreen,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: CupertinoColors.black,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isError ? CupertinoIcons.exclamationmark_triangle : CupertinoIcons.check_mark_circled,
                        color: CupertinoColors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          message,
                          style: const TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          if (entry.mounted) entry.remove();
                        },
                        child: const Icon(CupertinoIcons.xmark, color: CupertinoColors.white, size: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (entry.mounted) entry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final prAsync = ref.watch(purchaseRequestDetailProvider(widget.prId));
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return prAsync.when(
      data: (pr) {
        if (pr.status.toLowerCase() == 'vendor_approved' ||
            pr.status.toLowerCase() == 'po_created' ||
            pr.purchaseOrders.isNotEmpty) {
          return _buildVendorApprovedView(pr);
        }

        final showPurchasingActions = pr.status.toLowerCase() == 'approved' || pr.status.toLowerCase() == 'waiting_comparison';

        if (!showPurchasingActions) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMetadataHeader(context, pr),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: pr.details.length,
                  itemBuilder: (context, index) {
                    final item = pr.details[index];
                    return _DetailItemRow(item: item);
                  },
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetadataHeader(context, pr),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoSlidingSegmentedControl<int>(
                  groupValue: _currentTab,
                  children: {
                    0: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Text('Barang Diminta', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    ),
                    1: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text('Perbandingan Vendor (${pr.comparisons.length})', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    ),
                  },
                  onValueChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _currentTab = val;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: IndexedStack(
                index: _currentTab,
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: pr.details.length,
                    itemBuilder: (context, index) {
                      final item = pr.details[index];
                      return _DetailItemRow(item: item);
                    },
                  ),
                  _buildComparisonsTab(pr, showPurchasingActions),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: CupertinoColors.destructiveRed))),
    );
  }

  Widget _buildComparisonsTab(PurchaseRequest pr, bool showPurchasingActions) {
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    if (pr.comparisons.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.sparkles, size: 64, color: secondaryLabel.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text(
            'Belum ada perbandingan vendor yang ditetapkan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Jalankan penetapan otomatis untuk menemukan saran vendor.',
            style: TextStyle(fontSize: 13, color: secondaryLabel),
          ),
          if (showPurchasingActions) ...[
            const SizedBox(height: 24),
            CupertinoButton.filled(
              onPressed: _isAutoAssigning ? null : _showStrategyDialog,
              child: _isAutoAssigning
                  ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                  : const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.sparkles, size: 18),
                        SizedBox(width: 8),
                        Text('Tetapkan Vendor Otomatis'),
                      ],
                    ),
            ),
          ],
        ],
      );
    }

    return Column(
      children: [
        if (showPurchasingActions)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CupertinoColors.activeGreen.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: CupertinoColors.activeGreen.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.info, color: CupertinoColors.activeGreen, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Vendor telah ditetapkan. Klik "Ajukan ke BOD" untuk meminta persetujuan.',
                    style: TextStyle(fontSize: 12, color: CupertinoColors.activeGreen.resolveFrom(context), fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: pr.comparisons.length,
            itemBuilder: (context, index) {
              final comp = pr.comparisons[index];
              return _ComparisonCard(comparison: comp, pr: pr);
            },
          ),
        ),
        if (showPurchasingActions)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              border: Border(top: BorderSide(color: separatorColor, width: 0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                    color: CupertinoColors.tertiarySystemFill,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    onPressed: _isAutoAssigning ? null : _showStrategyDialog,
                    child: _isAutoAssigning
                        ? const CupertinoActivityIndicator()
                        : const Text('Tetapkan Ulang', style: TextStyle(color: CupertinoColors.activeBlue)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CupertinoButton.filled(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    onPressed: _isSubmittingToBod ? null : _handleSubmitToBod,
                    child: _isSubmittingToBod
                        ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                        : const Text('Ajukan ke BOD', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMetadataHeader(BuildContext context, PurchaseRequest pr) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: separatorColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pr.code,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: labelColor),
              ),
              _buildStatusChip(pr.status),
            ],
          ),
          if (pr.companyName != null) ...[
            const SizedBox(height: 6),
            Text(
              pr.companyName!,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6E56CF)),
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Container(height: 0.5, color: separatorColor),
          ),
          _buildMetaRow(CupertinoIcons.calendar, 'Tanggal', pr.requestDate),
          const SizedBox(height: 6),
          _buildMetaRow(CupertinoIcons.person, 'Diminta oleh', pr.requestByName ?? '-'),
          if (pr.notes != null && pr.notes!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: separatorColor, width: 0.5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(CupertinoIcons.doc_plaintext, size: 16, color: secondaryLabel),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      pr.notes!,
                      style: TextStyle(fontSize: 13, color: secondaryLabel, fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetaRow(IconData icon, String label, String value) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    return Row(
      children: [
        Icon(icon, size: 15, color: secondaryLabel),
        const SizedBox(width: 8),
        Text('$label: ', style: TextStyle(color: secondaryLabel, fontSize: 13)),
        Text(value, style: TextStyle(color: labelColor, fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    CupertinoDynamicColor color;
    switch (status.toLowerCase()) {
      case 'approved':
      case 'vendor_approved':
      case 'po_created':
        color = CupertinoColors.activeGreen;
        break;
      case 'pending':
      case 'submitted':
        color = CupertinoColors.systemOrange;
        break;
      case 'rejected':
        color = CupertinoColors.destructiveRed;
        break;
      case 'waiting_bod_approval':
      case 'waiting_comparison':
        color = CupertinoColors.systemPurple;
        break;
      default:
        color = CupertinoColors.systemGrey;
    }

    final resolvedColor = color.resolveFrom(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: resolvedColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: resolvedColor, width: 0.5),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: resolvedColor, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildVendorApprovedView(PurchaseRequest pr) {
    final groupedItems = <PurchaseRequestComparison, List<PurchaseRequestItem>>{};
    final noVendorItems = <PurchaseRequestItem>[];

    for (final item in pr.details) {
      if (item.selectedComparisonId == null) {
        noVendorItems.add(item);
        continue;
      }
      final comp = pr.comparisons.firstWhere(
        (c) => c.id == item.selectedComparisonId,
        orElse: () => const PurchaseRequestComparison(
          id: -1,
          supplierId: -1,
          supplierName: 'Pemasok Tidak Diketahui',
          totalAmount: 0,
          leadTimeDays: 0,
        ),
      );
      if (comp.id == -1) {
        noVendorItems.add(item);
      } else {
        groupedItems.putIfAbsent(comp, () => []).add(item);
      }
    }

    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              _buildMetadataHeader(context, pr),
              
              // Grouped Suppliers
              ...groupedItems.entries.map((entry) {
                final comp = entry.key;
                final items = entry.value;
                final matchedPoNumbers = pr.purchaseOrders
                    .where((po) => po.supplierName == comp.supplierName)
                    .map((po) => po.poNumber)
                    .toList();
                final hasPo = matchedPoNumbers.isNotEmpty;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: separatorColor, width: 0.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            if (!hasPo && pr.status.toLowerCase() == 'vendor_approved')
                              CupertinoCheckbox(
                                value: _selectedComparisonIds.contains(comp.id),
                                activeColor: const Color(0xFF6E56CF),
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      _selectedComparisonIds.add(comp.id);
                                    } else {
                                      _selectedComparisonIds.remove(comp.id);
                                    }
                                  });
                                },
                              ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    comp.supplierName,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: labelColor,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Waktu tunggu: ${comp.leadTimeDays} hari',
                                    style: TextStyle(fontSize: 12, color: secondaryLabel),
                                  ),
                                ],
                              ),
                            ),
                            if (hasPo)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: CupertinoColors.activeGreen.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: CupertinoColors.activeGreen.withOpacity(0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(CupertinoIcons.check_mark_circled, size: 12, color: CupertinoColors.activeGreen),
                                    const SizedBox(width: 4),
                                    Text(
                                      matchedPoNumbers.length == 1
                                          ? 'PO: ${matchedPoNumbers.first}'
                                          : 'POs: ${matchedPoNumbers.join(', ')}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: CupertinoColors.activeGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      Container(height: 0.5, color: separatorColor),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => Container(height: 0.5, color: separatorColor),
                        itemBuilder: (ctx, idx) {
                          final item = items[idx];
                          final cd = comp.details.firstWhere(
                            (d) => d.purchaseRequestDetailId == item.id,
                            orElse: () => const ComparisonDetail(id: -1, purchaseRequestDetailId: -1, offeredUnitPrice: 0.0),
                          );
                          final subtotal = cd.offeredUnitPrice * (item.approvedQty ?? item.qtyRequested);

                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.itemName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: labelColor,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      formatWithCurrency(subtotal, 'IDR'),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: labelColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Jml: ${item.approvedQty ?? item.qtyRequested} ${item.uom} @ ${formatWithCurrency(cd.offeredUnitPrice, "IDR")}',
                                      style: TextStyle(fontSize: 12, color: secondaryLabel),
                                    ),
                                    if (item.warehouseName != null)
                                      Text(
                                        'Gudang: ${item.warehouseName}',
                                        style: TextStyle(fontSize: 12, color: secondaryLabel),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Container(height: 0.5, color: separatorColor),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Pemasok:',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: secondaryLabel),
                            ),
                            Text(
                              formatWithCurrency(comp.totalAmount, 'IDR'),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6E56CF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // Generated POs
              if (pr.purchaseOrders.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    'Pesanan Pembelian (PO) Dibuat',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: labelColor,
                    ),
                  ),
                ),
                ...pr.purchaseOrders.map((po) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: separatorColor, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.doc_text, color: Color(0xFF6E56CF), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              po.poNumber,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: labelColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              po.supplierName,
                              style: TextStyle(fontSize: 12, color: secondaryLabel),
                            ),
                          ],
                        ),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        color: CupertinoColors.tertiarySystemFill,
                        borderRadius: BorderRadius.circular(8),
                        onPressed: () => _downloadAndPrintPdf(
                          context,
                          po.pdfUrl ?? '',
                          po.poNumber,
                        ),
                        child: const Row(
                          children: [
                            Icon(CupertinoIcons.cloud_download, size: 14, color: CupertinoColors.activeBlue),
                            SizedBox(width: 4),
                            Text('PDF', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: CupertinoColors.activeBlue)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ],

              // Unassigned items
              if (noVendorItems.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    'Barang Menunggu Penetapan Vendor',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.destructiveRed,
                    ),
                  ),
                ),
                ...noVendorItems.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: _DetailItemRow(item: item),
                )),
              ],
            ],
          ),
        ),
        if (pr.status.toLowerCase() == 'vendor_approved' && _selectedComparisonIds.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              border: Border(top: BorderSide(color: separatorColor, width: 0.5)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: CupertinoButton.filled(
                onPressed: _isGeneratingPos ? null : () => _handleProceedToPO(pr),
                child: _isGeneratingPos
                    ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(CupertinoIcons.checkmark_seal, size: 18),
                          const SizedBox(width: 8),
                          Text('Proceed to PO for ${_selectedComparisonIds.length} Supplier(s)'),
                        ],
                      ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _handleProceedToPO(PurchaseRequest pr) async {
    setState(() => _isGeneratingPos = true);
    try {
      final repo = ref.read(purchaseRequestRepositoryProvider);
      final createdPosRaw = await repo.generatePOs(
        pr.id,
        comparisonIds: _selectedComparisonIds.toList(),
      );

      ref.invalidate(purchaseRequestDetailProvider(pr.id));
      ref.invalidate(purchaseRequestsProvider);

      setState(() {
        _selectedComparisonIds.clear();
      });

      if (mounted) {
        await showCupertinoDialog(
          context: context,
          builder: (dialogCtx) {
            return CupertinoAlertDialog(
              title: const Text('POs Generated'),
              content: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Successfully generated Purchase Orders from selected vendors. You can download the PDF documents below:',
                      style: TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    ...createdPosRaw.map((poRaw) {
                      final poNum = poRaw['po_number'] ?? 'PO';
                      final supplierName = poRaw['supplier_name'] ?? 'Supplier';
                      final pdfUrl = poRaw['pdf_url'];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.doc_text, size: 18, color: Color(0xFF6E56CF)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    poNum,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                  Text(
                                    supplierName,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            if (pdfUrl != null)
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: const Icon(CupertinoIcons.cloud_download, color: CupertinoColors.activeBlue, size: 20),
                                onPressed: () {
                                  _downloadAndPrintPdf(context, pdfUrl, poNum);
                                },
                              ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      _showNotification('Error generating POs: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isGeneratingPos = false);
      }
    }
  }

  Future<void> _downloadAndPrintPdf(BuildContext context, String url, String fileName) async {
    if (url.isEmpty) return;
    bool dialogOpen = false;
    BuildContext? dialogContext;
    try {
      await Future.delayed(Duration.zero);
      if (!context.mounted) return;

      showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (dCtx) {
          dialogContext = dCtx;
          return const Center(child: CupertinoActivityIndicator(radius: 14));
        },
      );
      dialogOpen = true;

      final dio = ref.read(dioProvider);
      final response = await dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (dialogOpen) {
        dialogOpen = false;
        if (dialogContext != null && dialogContext!.mounted) {
          Navigator.pop(dialogContext!);
        } else if (context.mounted) {
          Navigator.pop(context);
        }
      }

      if (response.data != null) {
        if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
          final dir = await getDownloadsDirectory();
          if (dir != null) {
            final filePath = p.join(dir.path, '$fileName.pdf');
            final file = File(filePath);
            await file.writeAsBytes(response.data!);

            try {
              if (Platform.isWindows) {
                await Process.run('explorer.exe', [filePath.replaceAll('/', '\\')]);
              } else if (Platform.isMacOS) {
                await Process.run('open', [filePath]);
              } else if (Platform.isLinux) {
                await Process.run('xdg-open', [filePath]);
              }
            } catch (e) {
              // Ignore explorer launch issues
            }

            _showNotification('Downloaded PDF to Downloads folder: $fileName.pdf');
          } else {
            throw Exception('Could not find Downloads folder');
          }
        } else {
          await Printing.layoutPdf(
            name: fileName,
            onLayout: (format) async => Uint8List.fromList(response.data!),
          );
        }
      } else {
        throw Exception('Empty PDF response');
      }
    } catch (e) {
      if (dialogOpen) {
        dialogOpen = false;
        if (dialogContext != null && dialogContext!.mounted) {
          Navigator.pop(dialogContext!);
        } else if (context.mounted) {
          Navigator.pop(context);
        }
      }
      _showNotification('Failed to download PDF: $e', isError: true);
    }
  }
}

class _DetailItemRow extends StatelessWidget {
  final PurchaseRequestItem item;
  const _DetailItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: separatorColor, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.itemName,
                    style: TextStyle(fontWeight: FontWeight.bold, color: labelColor, fontSize: 14),
                  ),
                ),
                if (item.costCode != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: separatorColor, width: 0.5),
                    ),
                    child: Text(
                      item.costCode!,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: secondaryLabel),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(item.itemCode, style: TextStyle(color: secondaryLabel, fontSize: 12)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Container(height: 0.5, color: separatorColor),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Req Qty', style: TextStyle(color: secondaryLabel, fontSize: 11)),
                    const SizedBox(height: 2),
                    Text(
                      '${item.qtyRequested} ${item.uom}',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: labelColor),
                    ),
                  ],
                ),
                if (item.approvedQty != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Approved Qty', style: TextStyle(color: CupertinoColors.activeGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(
                        '${item.approvedQty} ${item.uom}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: CupertinoColors.activeGreen),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(CupertinoIcons.cube, size: 14, color: secondaryLabel),
                const SizedBox(width: 4),
                Text(
                  'Current Stock: ${item.currentStock} ${item.uom}',
                  style: TextStyle(
                    fontSize: 12,
                    color: item.currentStock < item.qtyRequested ? CupertinoColors.systemOrange : secondaryLabel,
                    fontWeight: item.currentStock < item.qtyRequested ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ],
            ),
            if (item.dtSpec != null && item.dtSpec!.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Spesifikasi: ${item.dtSpec}',
                  style: TextStyle(fontSize: 12, color: labelColor, fontStyle: FontStyle.italic),
                ),
              ),
            ],
            if (item.dtNotes != null && item.dtNotes!.trim().isNotEmpty) ...[
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Keterangan: ${item.dtNotes}',
                  style: TextStyle(fontSize: 12, color: labelColor),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  final PurchaseRequestComparison comparison;
  final PurchaseRequest pr;

  const _ComparisonCard({required this.comparison, required this.pr});

  @override
  Widget build(BuildContext context) {
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: separatorColor, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    comparison.supplierName,
                    style: TextStyle(fontWeight: FontWeight.bold, color: labelColor, fontSize: 15),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${comparison.leadTimeDays} days lead time',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: secondaryLabel),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Total: ${formatWithCurrency(comparison.totalAmount, 'IDR')}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6E56CF),
              ),
            ),
            if (comparison.notes != null && comparison.notes!.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Notes: ${comparison.notes}',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: secondaryLabel),
              ),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Container(height: 0.5, color: separatorColor),
            ),
            Text(
              'Offered Items:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: labelColor),
            ),
            const SizedBox(height: 6),
            ...comparison.details.map((compDetail) {
              final prDetail = pr.details.firstWhere(
                (d) => d.id == compDetail.purchaseRequestDetailId,
                orElse: () => PurchaseRequestItem(id: 0, itemName: 'Unknown Item', itemCode: '', qtyRequested: 0, uom: ''),
              );

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        prDetail.itemName,
                        style: TextStyle(fontSize: 13, color: labelColor),
                      ),
                    ),
                    Text(
                      formatWithCurrency(compDetail.offeredUnitPrice, 'IDR'),
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: labelColor),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
