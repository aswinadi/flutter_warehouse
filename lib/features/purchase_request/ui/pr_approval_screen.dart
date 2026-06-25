import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';
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
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_dialog.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';

class PRApprovalScreen extends ConsumerWidget {
  final int prId;
  final int? itemId;
  final bool isEmbedded;
  const PRApprovalScreen({super.key, required this.prId, this.itemId, this.isEmbedded = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prAsync = ref.watch(purchaseRequestDetailProvider(prId));
    final labelColor = CupertinoColors.label.resolveFrom(context);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        automaticallyImplyLeading: !isEmbedded,
        middle: Text('Detail PR', style: TextStyle(color: labelColor)),
        trailing: prAsync.when(
          data: (pr) => CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: const Size(22, 22),
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
        child: PRDetailsView(prId: prId, itemId: itemId, isEmbedded: isEmbedded),
      ),
    );
  }
}

class PRDetailsView extends ConsumerStatefulWidget {
  final int prId;
  final int? itemId;
  final bool isEmbedded;
  const PRDetailsView({super.key, required this.prId, this.itemId, this.isEmbedded = false});

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
        return CupertinoGlassDialog(
          title: const Text('Tetapkan Vendor Otomatis'),
          content: const Padding(
            padding: EdgeInsets.only(top: CupertinoSpacing.s),
            child: Text('Pilih strategi untuk menemukan dan menetapkan vendor terbaik secara otomatis berdasarkan riwayat pembelian:'),
          ),
          actions: [
            CupertinoGlassDialogAction(
              onPressed: () {
                Navigator.pop(context);
                _handleAutoAssign('lowest_price');
              },
              child: const Text('Harga Terendah'),
            ),
            CupertinoGlassDialogAction(
              onPressed: () {
                Navigator.pop(context);
                _handleAutoAssign('last_supplier');
              },
              child: const Text('Pemasok Terakhir'),
            ),
            CupertinoGlassDialogAction(
              isDestructive: true,
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
    if (isError) {
      CupertinoGlassToast.showError(context, message);
    } else {
      CupertinoGlassToast.showSuccess(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final prAsync = ref.watch(purchaseRequestDetailProvider(widget.prId));

    return prAsync.when(
      data: (pr) {
        if (pr.status.toLowerCase() == 'vendor_approved' ||
            pr.status.toLowerCase() == 'po_created' ||
            pr.purchaseOrders.isNotEmpty) {
          return _buildVendorApprovedView(pr);
        }

        final showPurchasingActions = pr.status.toLowerCase() == 'approved' || pr.status.toLowerCase() == 'waiting_comparison';

        final filteredDetails = widget.itemId != null
            ? pr.details.where((d) => d.id == widget.itemId).toList()
            : pr.details;

        if (!showPurchasingActions) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMetadataHeader(context, pr),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.s),
                  itemCount: filteredDetails.length,
                  itemBuilder: (context, index) {
                    final item = filteredDetails[index];
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
              padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoSlidingSegmentedControl<int>(
                  groupValue: _currentTab,
                  children: {
                    0: Padding(
                      padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.s),
                      child: Text('Barang Diminta', style: context.footnote.copyWith(fontWeight: FontWeight.w500)),
                    ),
                    1: Padding(
                      padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.s),
                      child: Text('Perbandingan Vendor (${pr.comparisons.length})', style: context.footnote.copyWith(fontWeight: FontWeight.w500)),
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
            const SizedBox(height: CupertinoSpacing.s),
            Expanded(
              child: IndexedStack(
                index: _currentTab,
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.s),
                    itemCount: filteredDetails.length,
                    itemBuilder: (context, index) {
                      final item = filteredDetails[index];
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
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    final filteredComparisons = widget.itemId != null
        ? pr.comparisons.where((comp) => comp.details.any((cd) => cd.purchaseRequestDetailId == widget.itemId)).toList()
        : pr.comparisons;

    if (filteredComparisons.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.sparkles, size: 64, color: secondaryLabel.withOpacity(0.5)),
          const SizedBox(height: CupertinoSpacing.screenMargin),
          Text(
            'Belum ada perbandingan vendor yang ditetapkan',
            style: context.headline.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: CupertinoSpacing.s),
          Text(
            'Jalankan penetapan otomatis untuk menemukan saran vendor.',
            style: context.footnote.copyWith(color: secondaryLabel),
          ),
          if (showPurchasingActions) ...[
            const SizedBox(height: CupertinoSpacing.xxl),
            CupertinoButton.filled(
              borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
              onPressed: _isAutoAssigning ? null : _showStrategyDialog,
              child: _isAutoAssigning
                  ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(CupertinoIcons.sparkles, size: 18),
                        const SizedBox(width: CupertinoSpacing.s),
                        Text('Tetapkan Vendor Otomatis', style: context.body.copyWith(color: CupertinoColors.white, fontWeight: FontWeight.bold)),
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
            margin: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.s),
            padding: const EdgeInsets.all(CupertinoSpacing.m),
            decoration: BoxDecoration(
              color: CupertinoColors.activeGreen.withOpacity(0.12),
              borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
              border: Border.all(color: CupertinoColors.activeGreen.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.info, color: CupertinoColors.activeGreen, size: 20),
                const SizedBox(width: CupertinoSpacing.s),
                Expanded(
                  child: Text(
                    'Vendor telah ditetapkan. Klik "Ajukan ke BOD" untuk meminta persetujuan.',
                    style: context.footnote.copyWith(color: CupertinoColors.activeGreen.resolveFrom(context), fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.s),
            itemCount: filteredComparisons.length,
            itemBuilder: (context, index) {
              final comp = filteredComparisons[index];
              return _ComparisonCard(comparison: comp, pr: pr, itemId: widget.itemId);
            },
          ),
        ),
        if (showPurchasingActions)
          CupertinoGlassContainer(
            borderRadius: 0,
            padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
            child: Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                    color: CupertinoColors.tertiarySystemFill,
                    padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.m),
                    borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                    onPressed: _isAutoAssigning ? null : _showStrategyDialog,
                    child: _isAutoAssigning
                        ? const CupertinoActivityIndicator()
                        : Text('Tetapkan Ulang', style: context.body.copyWith(color: CupertinoColors.activeBlue, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: CupertinoSpacing.m),
                Expanded(
                  child: CupertinoButton.filled(
                    padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.m),
                    borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                    onPressed: _isSubmittingToBod ? null : _handleSubmitToBod,
                    child: _isSubmittingToBod
                        ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                        : Text('Ajukan ke BOD', style: context.body.copyWith(color: CupertinoColors.white, fontWeight: FontWeight.bold)),
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
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return CupertinoGlassContainer(
      margin: const EdgeInsets.all(CupertinoSpacing.screenMargin),
      padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pr.code,
                style: context.title3.copyWith(fontWeight: FontWeight.bold, color: labelColor),
              ),
              _buildStatusChip(pr.status),
            ],
          ),
          if (pr.companyName != null) ...[
            const SizedBox(height: CupertinoSpacing.xs),
            Text(
              pr.companyName!,
              style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: CupertinoColors.activeBlue),
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.m),
            child: Container(height: 0.5, color: separatorColor),
          ),
          _buildMetaRow(CupertinoIcons.calendar, 'Tanggal', pr.requestDate),
          const SizedBox(height: CupertinoSpacing.xs),
          _buildMetaRow(CupertinoIcons.person, 'Diminta oleh', pr.requestByName ?? '-'),
          if (pr.notes != null && pr.notes!.isNotEmpty) ...[
            const SizedBox(height: CupertinoSpacing.s),
            Container(
              padding: const EdgeInsets.all(CupertinoSpacing.s),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                border: Border.all(color: separatorColor, width: 0.5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(CupertinoIcons.doc_plaintext, size: 16, color: secondaryLabel),
                  const SizedBox(width: CupertinoSpacing.s),
                  Expanded(
                    child: Text(
                      pr.notes!,
                      style: context.footnote.copyWith(color: secondaryLabel, fontStyle: FontStyle.italic),
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
        const SizedBox(width: CupertinoSpacing.s),
        Text('$label: ', style: context.footnote.copyWith(color: secondaryLabel)),
        Text(value, style: context.footnote.copyWith(color: labelColor, fontWeight: FontWeight.w500)),
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
      padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.s, vertical: CupertinoSpacing.xs),
      decoration: BoxDecoration(
        color: resolvedColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: resolvedColor, width: 0.5),
      ),
      child: Text(
        status.toUpperCase(),
        style: context.caption2.copyWith(color: resolvedColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildVendorApprovedView(PurchaseRequest pr) {
    final groupedItems = <PurchaseRequestComparison, List<PurchaseRequestItem>>{};
    final noVendorItems = <PurchaseRequestItem>[];

    final filteredDetails = widget.itemId != null
        ? pr.details.where((d) => d.id == widget.itemId).toList()
        : pr.details;

    for (final item in filteredDetails) {
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

    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.s),
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

                return CupertinoGlassContainer(
                  margin: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.s),
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                        child: Row(
                          children: [
                            if (!hasPo && pr.status.toLowerCase() == 'vendor_approved')
                              CupertinoCheckbox(
                                value: _selectedComparisonIds.contains(comp.id),
                                activeColor: CupertinoColors.activeBlue,
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
                            const SizedBox(width: CupertinoSpacing.s),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    comp.supplierName,
                                    style: context.subhead.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: labelColor,
                                    ),
                                  ),
                                  const SizedBox(height: CupertinoSpacing.xs),
                                  Text(
                                    'Waktu tunggu: ${comp.leadTimeDays} hari',
                                    style: context.caption1.copyWith(color: secondaryLabel),
                                  ),
                                ],
                              ),
                            ),
                            if (hasPo)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.s, vertical: CupertinoSpacing.xs),
                                decoration: BoxDecoration(
                                  color: CupertinoColors.activeGreen.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: CupertinoColors.activeGreen.withOpacity(0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(CupertinoIcons.check_mark_circled, size: 12, color: CupertinoColors.activeGreen),
                                    const SizedBox(width: CupertinoSpacing.xs),
                                    Text(
                                      matchedPoNumbers.length == 1
                                          ? 'PO: ${matchedPoNumbers.first}'
                                          : 'POs: ${matchedPoNumbers.join(', ')}',
                                      style: context.caption2.copyWith(
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
                            padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.itemName,
                                        style: context.footnote.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: labelColor,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      formatWithCurrency(subtotal, 'IDR'),
                                      style: context.footnote.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: labelColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: CupertinoSpacing.xs),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Jml: ${item.approvedQty ?? item.qtyRequested} ${item.uom} @ ${formatWithCurrency(cd.offeredUnitPrice, "IDR")}',
                                      style: context.caption1.copyWith(color: secondaryLabel),
                                    ),
                                    if (item.warehouseName != null)
                                      Text(
                                        'Gudang: ${item.warehouseName}',
                                        style: context.caption1.copyWith(color: secondaryLabel),
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
                        padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Pemasok:',
                              style: context.footnote.copyWith(fontWeight: FontWeight.w600, color: secondaryLabel),
                            ),
                            Text(
                              formatWithCurrency(comp.totalAmount, 'IDR'),
                              style: context.subhead.copyWith(
                                fontWeight: FontWeight.bold,
                                color: CupertinoColors.activeBlue,
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
                  padding: const EdgeInsets.fromLTRB(CupertinoSpacing.screenMargin, CupertinoSpacing.xxl, CupertinoSpacing.screenMargin, CupertinoSpacing.s),
                  child: Text(
                    'Pesanan Pembelian (PO) Dibuat',
                    style: context.subhead.copyWith(
                      fontWeight: FontWeight.bold,
                      color: labelColor,
                    ),
                  ),
                ),
                ...pr.purchaseOrders.map((po) => CupertinoGlassContainer(
                  margin: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.xs),
                  padding: const EdgeInsets.all(CupertinoSpacing.m),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.doc_text, color: CupertinoColors.activeBlue, size: 20),
                      const SizedBox(width: CupertinoSpacing.m),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              po.poNumber,
                              style: context.footnote.copyWith(
                                fontWeight: FontWeight.bold,
                                color: labelColor,
                              ),
                            ),
                            const SizedBox(height: CupertinoSpacing.xs),
                            Text(
                              po.supplierName,
                              style: context.caption1.copyWith(color: secondaryLabel),
                            ),
                          ],
                        ),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.m, vertical: CupertinoSpacing.s),
                        color: CupertinoColors.tertiarySystemFill,
                        borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                        minimumSize: const Size.square(32),
                        onPressed: () => _downloadAndPrintPdf(
                          context,
                          po.pdfUrl ?? '',
                          po.poNumber,
                        ),
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.cloud_download, size: 14, color: CupertinoColors.activeBlue),
                            const SizedBox(width: CupertinoSpacing.xs),
                            Text('PDF', style: context.caption2.copyWith(fontWeight: FontWeight.bold, color: CupertinoColors.activeBlue)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ],

              // Unassigned items
              if (noVendorItems.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(CupertinoSpacing.screenMargin, CupertinoSpacing.xxl, CupertinoSpacing.screenMargin, CupertinoSpacing.s),
                  child: Text(
                    'Barang Menunggu Penetapan Vendor',
                    style: context.subhead.copyWith(
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.destructiveRed,
                    ),
                  ),
                ),
                ...noVendorItems.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.xs),
                  child: _DetailItemRow(item: item),
                )),
              ],
            ],
          ),
        ),
        if (pr.status.toLowerCase() == 'vendor_approved' && _selectedComparisonIds.isNotEmpty)
          CupertinoGlassContainer(
            borderRadius: 0,
            padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
            child: SizedBox(
              width: double.infinity,
              child: CupertinoButton.filled(
                borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                onPressed: _isGeneratingPos ? null : () => _handleProceedToPO(pr),
                child: _isGeneratingPos
                    ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(CupertinoIcons.checkmark_seal, size: 18),
                          const SizedBox(width: CupertinoSpacing.s),
                          Text('Proceed to PO for ${_selectedComparisonIds.length} Supplier(s)', style: context.body.copyWith(color: CupertinoColors.white, fontWeight: FontWeight.bold)),
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
            return CupertinoGlassDialog(
              title: const Text('POs Generated'),
              content: Padding(
                padding: const EdgeInsets.only(top: CupertinoSpacing.s),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Successfully generated Purchase Orders from selected vendors. You can download the PDF documents below:',
                      style: TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: CupertinoSpacing.screenMargin),
                    ...createdPosRaw.map((poRaw) {
                      final poNum = poRaw['po_number'] ?? 'PO';
                      final supplierName = poRaw['supplier_name'] ?? 'Supplier';
                      final pdfUrl = poRaw['pdf_url'];

                      return CupertinoGlassContainer(
                        margin: const EdgeInsets.only(bottom: CupertinoSpacing.s),
                        padding: const EdgeInsets.all(CupertinoSpacing.s),
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.doc_text, size: 18, color: CupertinoColors.activeBlue),
                            const SizedBox(width: CupertinoSpacing.s),
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
                                minimumSize: const Size.square(32),
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
                CupertinoGlassDialogAction(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      _showNotification('Error generating POs: ${_getErrorMessage(e)}', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isGeneratingPos = false);
      }
    }
  }

  String _getErrorMessage(dynamic e) {
    if (e is DioException) {
      final responseData = e.response?.data;
      if (responseData is Map) {
        if (responseData['errors'] != null && responseData['errors'] is Map) {
          final errors = responseData['errors'] as Map;
          if (errors.isNotEmpty) {
            final firstErrorVal = errors.values.first;
            if (firstErrorVal is List && firstErrorVal.isNotEmpty) {
              return firstErrorVal.first.toString();
            }
            return firstErrorVal.toString();
          }
        }
        if (responseData['message'] != null) {
          return responseData['message'].toString();
        }
        if (responseData['error'] != null) {
          return responseData['error'].toString();
        }
      }
      return e.message ?? e.toString();
    }
    return e.toString();
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
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return CupertinoGlassContainer(
      margin: const EdgeInsets.only(bottom: CupertinoSpacing.m),
      padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.itemName,
                  style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                ),
              ),
              if (item.costCode != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.s, vertical: CupertinoSpacing.xs),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: separatorColor, width: 0.5),
                  ),
                  child: Text(
                    item.costCode!,
                    style: context.caption2.copyWith(fontWeight: FontWeight.bold, color: secondaryLabel),
                  ),
                ),
            ],
          ),
          const SizedBox(height: CupertinoSpacing.xs),
          Text(item.itemCode, style: context.caption1.copyWith(color: secondaryLabel)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.m),
            child: Container(height: 0.5, color: separatorColor),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Req Qty', style: context.caption2.copyWith(color: secondaryLabel)),
                  const SizedBox(height: CupertinoSpacing.xs),
                  Text(
                    '${item.qtyRequested} ${item.uom}',
                    style: context.footnote.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                  ),
                ],
              ),
              if (item.approvedQty != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Approved Qty', style: context.caption2.copyWith(color: CupertinoColors.activeGreen, fontWeight: FontWeight.bold)),
                    const SizedBox(height: CupertinoSpacing.xs),
                    Text(
                      '${item.approvedQty} ${item.uom}',
                      style: context.footnote.copyWith(fontWeight: FontWeight.bold, color: CupertinoColors.activeGreen),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: CupertinoSpacing.s),
          Row(
            children: [
              Icon(CupertinoIcons.cube, size: 14, color: secondaryLabel),
              const SizedBox(width: CupertinoSpacing.xs),
              Text(
                'Current Stock: ${item.currentStock} ${item.uom}',
                style: context.caption1.copyWith(
                  color: item.currentStock < item.qtyRequested ? CupertinoColors.systemOrange : secondaryLabel,
                  fontWeight: item.currentStock < item.qtyRequested ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ],
          ),
          if (item.dtSpec != null && item.dtSpec!.trim().isNotEmpty) ...[
            const SizedBox(height: CupertinoSpacing.s),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(CupertinoSpacing.s),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Spesifikasi: ${item.dtSpec}',
                style: context.caption1.copyWith(color: labelColor, fontStyle: FontStyle.italic),
              ),
            ),
          ],
          if (item.dtNotes != null && item.dtNotes!.trim().isNotEmpty) ...[
            const SizedBox(height: CupertinoSpacing.s),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(CupertinoSpacing.s),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Keterangan: ${item.dtNotes}',
                style: context.caption1.copyWith(color: labelColor),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  final PurchaseRequestComparison comparison;
  final PurchaseRequest pr;
  final int? itemId;

  const _ComparisonCard({required this.comparison, required this.pr, this.itemId});

  @override
  Widget build(BuildContext context) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return CupertinoGlassContainer(
      margin: const EdgeInsets.only(bottom: CupertinoSpacing.m),
      padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  comparison.supplierName,
                  style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.s, vertical: CupertinoSpacing.xs),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${comparison.leadTimeDays} days lead time',
                  style: context.caption2.copyWith(fontWeight: FontWeight.bold, color: secondaryLabel),
                ),
              ),
            ],
          ),
          const SizedBox(height: CupertinoSpacing.xs),
          Text(
            'Total: ${formatWithCurrency(comparison.totalAmount, 'IDR')}',
            style: context.footnote.copyWith(
              fontWeight: FontWeight.bold,
              color: CupertinoColors.activeBlue,
            ),
          ),
          if (comparison.notes != null && comparison.notes!.trim().isNotEmpty) ...[
            const SizedBox(height: CupertinoSpacing.s),
            Text(
              'Notes: ${comparison.notes}',
              style: context.caption1.copyWith(fontStyle: FontStyle.italic, color: secondaryLabel),
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.m),
            child: Container(height: 0.5, color: separatorColor),
          ),
          Text(
            'Offered Items:',
            style: context.caption1.copyWith(fontWeight: FontWeight.bold, color: labelColor),
          ),
          const SizedBox(height: CupertinoSpacing.s),
          ...comparison.details.where((d) {
            if (itemId != null) {
              return d.purchaseRequestDetailId == itemId;
            }
            return true;
          }).map((compDetail) {
            final prDetail = pr.details.firstWhere(
              (d) => d.id == compDetail.purchaseRequestDetailId,
              orElse: () => PurchaseRequestItem(id: 0, itemName: 'Unknown Item', itemCode: '', qtyRequested: 0, uom: ''),
            );

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.xs),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      prDetail.itemName,
                      style: context.caption1.copyWith(color: labelColor),
                    ),
                  ),
                  Text(
                    formatWithCurrency(compDetail.offeredUnitPrice, 'IDR'),
                    style: context.caption1.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
