import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/purchase_request_detail_provider.dart';
import '../providers/purchase_request_provider.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';

class PRVendorApprovalScreen extends ConsumerStatefulWidget {
  final int prId;
  final int? itemId;
  final bool isEmbedded;
  const PRVendorApprovalScreen({super.key, required this.prId, this.itemId, this.isEmbedded = false});

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
    final targetItems = widget.itemId != null
        ? itemsWaitingBod.where((d) => d.id == widget.itemId).toList()
        : itemsWaitingBod;

    final missingSelections = targetItems.any((d) => !_selections.containsKey(d.id));

    if (missingSelections) {
      _showNotification('Silakan pilih vendor untuk item barang yang diajukan', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final payload = targetItems.map((d) {
        return {
          'item_id': d.id,
          'comparison_id': _selections[d.id]!,
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
    if (isError) {
      CupertinoGlassToast.showError(context, message);
    } else {
      CupertinoGlassToast.showSuccess(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final prAsync = ref.watch(purchaseRequestDetailProvider(widget.prId));
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        automaticallyImplyLeading: !widget.isEmbedded,
        middle: Text(
          prAsync.valueOrNull != null &&
                      (widget.itemId != null
                          ? prAsync.valueOrNull!.details.any((d) => d.id == widget.itemId && d.status?.toLowerCase() == 'waiting_bod_approval')
                          : prAsync.valueOrNull!.details.any((d) => d.status?.toLowerCase() == 'waiting_bod_approval')) &&
                      prAsync.valueOrNull!.canApprove
              ? 'Pemilihan Vendor PR'
              : 'Detail PR',
          style: TextStyle(color: labelColor),
        ),
      ),
      child: SafeArea(
        child: prAsync.when(
          data: (pr) {
            _initializeSelections(pr.details, pr.comparisons);
            final hasItemsWaitingBod = widget.itemId != null
                ? pr.details.any((d) => d.id == widget.itemId && d.status?.toLowerCase() == 'waiting_bod_approval')
                : pr.details.any((d) => d.status?.toLowerCase() == 'waiting_bod_approval');
            final canApproveNow = hasItemsWaitingBod && pr.canApprove;

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                    children: [
                      CupertinoGlassContainer(
                        padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pr.code,
                              style: context.title3.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                            ),
                            const SizedBox(height: CupertinoSpacing.s),
                            Text('Perusahaan: ${pr.companyName ?? "-"}', style: context.subhead.copyWith(color: labelColor)),
                            const SizedBox(height: CupertinoSpacing.xs),
                            Text('Tanggal: ${pr.requestDate}', style: context.footnote.copyWith(color: secondaryLabel)),
                            const SizedBox(height: CupertinoSpacing.xs),
                            Text('Catatan: ${pr.notes ?? "-"}', style: context.footnote.copyWith(color: secondaryLabel, fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),
                      const SizedBox(height: CupertinoSpacing.xl),
                      Text(
                        'Item & Perbandingan Vendor',
                        style: context.headline.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                      ),
                      const SizedBox(height: CupertinoSpacing.s),
                      ...pr.details.where((detail) {
                        if (widget.itemId != null) {
                          return detail.id == widget.itemId;
                        }
                        return true;
                      }).map((detail) {
                        // Find comparisons that offer this item
                        final itemOptions = pr.comparisons.where((comp) {
                          return comp.details.any((cd) => cd.purchaseRequestDetailId == detail.id);
                        }).toList();

                        return CupertinoGlassContainer(
                          margin: const EdgeInsets.only(bottom: CupertinoSpacing.screenMargin),
                          padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detail.itemName,
                                style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                              ),
                              const SizedBox(height: CupertinoSpacing.xs),
                              Text(
                                'SKU: ${detail.itemCode} | Qty: ${detail.qtyRequested} ${detail.uom}',
                                style: context.footnote.copyWith(color: secondaryLabel),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.m),
                                child: Container(height: 0.5, color: separatorColor),
                              ),
                              if (itemOptions.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: CupertinoSpacing.s),
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
                                      padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.s),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 2.0, right: CupertinoSpacing.s),
                                            child: Icon(
                                              isSelected ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.circle,
                                              color: isSelected ? CupertinoColors.activeBlue : secondaryLabel,
                                              size: 20,
                                            ),
                                          ),
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
                                                  'Harga: ${formatWithCurrency(compDetail.offeredUnitPrice, 'IDR')} | Waktu Tunggu: ${comp.leadTimeDays} hari\nCatatan: ${comp.notes ?? "-"}',
                                                  style: context.footnote.copyWith(
                                                    color: secondaryLabel,
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
                        );
                      }),
                    ],
                  ),
                ),
                if (canApproveNow)
                  CupertinoGlassContainer(
                    borderRadius: 0,
                    padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                    child: Row(
                      children: [
                        Expanded(
                          child: CupertinoButton.filled(
                            borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
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
