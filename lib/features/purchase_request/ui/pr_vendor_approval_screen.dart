import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors; // kept for compatibility if needed
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/purchase_request_detail_provider.dart';
import '../providers/purchase_request_provider.dart';
import '../../../core/utils/currency_utils.dart';

class PRVendorApprovalScreen extends ConsumerStatefulWidget {
  final int prId;
  final bool isEmbedded;
  const PRVendorApprovalScreen({super.key, required this.prId, this.isEmbedded = false});

  @override
  ConsumerState<PRVendorApprovalScreen> createState() => _PRVendorApprovalScreenState();
}

class _PRVendorApprovalScreenState extends ConsumerState<PRVendorApprovalScreen> {
  // Map to store selected comparison_id for each item_id (detail.id)
  final Map<int, int> _selections = {};
  bool _isSubmitting = false;

  void _initializeSelections(List<dynamic> details, List<dynamic> comparisons) {
    if (_selections.isEmpty) {
      for (var detail in details) {
        final options = comparisons.where((c) => c.details.any((d) => d.purchaseRequestDetailId == detail.id)).toList();
        if (options.isNotEmpty) {
          _selections[detail.id] = options.first.id;
        }
      }
    }
  }

  Future<void> _submit() async {
    final detailProvider = ref.read(purchaseRequestDetailProvider(widget.prId));
    final pr = detailProvider.valueOrNull;

    if (pr == null) return;

    final itemsWaitingBod = pr.details.where((d) => d.status?.toLowerCase() == 'waiting_bod_approval').toList();
    final missingSelections = itemsWaitingBod.any((d) => !_selections.containsKey(d.id));

    if (missingSelections) {
      _showNotification('Silakan pilih vendor untuk semua item barang yang diajukan', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final payload = _selections.entries.map((e) {
        return {
          'item_id': e.key,
          'comparison_id': e.value,
        };
      }).toList();

      await ref.read(purchaseRequestRepositoryProvider).approvePurchaseRequestComparisons(
            widget.prId,
            payload,
          );

      ref.invalidate(purchaseRequestsProvider);
      _showNotification('Pilihan vendor berhasil disetujui');
      if (!widget.isEmbedded && mounted) {
        context.pop();
      }
    } catch (e) {
      _showNotification('Error: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
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
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: !widget.isEmbedded,
        middle: Text(prAsync.valueOrNull != null &&
                    prAsync.valueOrNull!.details.any((d) => d.status?.toLowerCase() == 'waiting_bod_approval') &&
                    prAsync.valueOrNull!.canApprove
                    ? 'Pemilihan Vendor PR'
                    : 'Detail PR'),
      ),
      child: SafeArea(
        child: prAsync.when(
          data: (pr) {
            _initializeSelections(pr.details, pr.comparisons);
            final hasItemsWaitingBod = pr.details.any((d) => d.status?.toLowerCase() == 'waiting_bod_approval');
            final canApproveNow = hasItemsWaitingBod && pr.canApprove;

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Container(
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
                              Text(
                                pr.code,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: labelColor),
                              ),
                              const SizedBox(height: 8),
                              Text('Perusahaan: ${pr.companyName ?? "-"}', style: TextStyle(color: labelColor)),
                              const SizedBox(height: 4),
                              Text('Tanggal: ${pr.requestDate}', style: TextStyle(color: secondaryLabel)),
                              const SizedBox(height: 4),
                              Text('Catatan: ${pr.notes ?? "-"}', style: TextStyle(color: secondaryLabel, fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Item & Perbandingan Vendor',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: labelColor),
                      ),
                      const SizedBox(height: 10),
                      ...pr.details.map((detail) {
                        // Find comparisons that offer this item
                        final itemOptions = pr.comparisons.where((comp) {
                          return comp.details.any((cd) => cd.purchaseRequestDetailId == detail.id);
                        }).toList();

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
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
                                Text(
                                  detail.itemName,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: labelColor),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'SKU: ${detail.itemCode} | Qty: ${detail.qtyRequested} ${detail.uom}',
                                  style: TextStyle(color: secondaryLabel, fontSize: 13),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  child: Container(height: 0.5, color: separatorColor),
                                ),
                                if (itemOptions.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      'Tidak ada perbandingan vendor untuk item ini',
                                      style: TextStyle(color: CupertinoColors.destructiveRed, fontStyle: FontStyle.italic),
                                    ),
                                  )
                                else
                                  ...itemOptions.map((comp) {
                                    final compDetail = comp.details.firstWhere((cd) => cd.purchaseRequestDetailId == detail.id);
                                    final isSelected = _selections[detail.id] == comp.id;

                                    return GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: (canApproveNow && detail.status?.toLowerCase() == 'waiting_bod_approval')
                                          ? () {
                                              setState(() => _selections[detail.id] = comp.id);
                                            }
                                          : null,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2.0, right: 10.0),
                                              child: Icon(
                                                isSelected ? CupertinoIcons.check_mark_circled_solid : CupertinoIcons.circle,
                                                color: isSelected ? const Color(0xFF6E56CF) : secondaryLabel,
                                                size: 20,
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    comp.supplierName,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      color: labelColor,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Harga: ${formatWithCurrency(compDetail.offeredUnitPrice, 'IDR')} | Waktu Tunggu: ${comp.leadTimeDays} hari\nCatatan: ${comp.notes ?? "-"}',
                                                    style: TextStyle(
                                                      color: secondaryLabel,
                                                      fontSize: 13,
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
                if (canApproveNow)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      border: Border(top: BorderSide(color: separatorColor, width: 0.5)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: CupertinoButton.filled(
                            onPressed: _isSubmitting ? null : _submit,
                            child: _isSubmitting
                                ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                                : const Text('Kirim Pilihan Vendor', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(color: CupertinoColors.destructiveRed))),
        ),
      ),
    );
  }
}
