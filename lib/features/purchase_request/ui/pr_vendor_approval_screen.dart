import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/purchase_request_detail_provider.dart';
import '../providers/purchase_request_provider.dart';
import '../../../core/providers/warehouse_provider.dart';
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
  // Map to store selected warehouse_area_id for each item_id (detail.id)
  final Map<int, int?> _areaSelections = {};
  bool _isSelectionsInitialized = false;
  bool _isSubmitting = false;

  void _initializeSelections(List<dynamic> details, List<dynamic> comparisons) {
    if (!_isSelectionsInitialized) {
      for (var detail in details) {
        if (detail.selectedComparisonId != null) {
          _selections[detail.id] = detail.selectedComparisonId!;
        } else {
          final options = comparisons.where((c) => c.details.any((d) => d.purchaseRequestDetailId == detail.id)).toList();
          if (options.isNotEmpty) {
            _selections[detail.id] = options.first.id;
          }
        }
        _areaSelections[detail.id] = detail.warehouseAreaId;
      }
      _isSelectionsInitialized = true;
    }
  }

  Future<void> _submit() async {
    final detailProvider = ref.read(purchaseRequestDetailProvider(widget.prId));
    final pr = detailProvider.valueOrNull;

    if (pr == null) return;

    final itemsWaitingSelection = pr.details.where((d) => 
        d.status?.toLowerCase() == 'waiting_acknowledge' || 
        d.status?.toLowerCase() == 'waiting_bod_approval').toList();
        
    final targetItems = widget.itemId != null
        ? itemsWaitingSelection.where((d) => d.id == widget.itemId).toList()
        : itemsWaitingSelection;

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
          if (_areaSelections[d.id] != null) 'warehouse_area_id': _areaSelections[d.id]!,
        };
      }).toList();

      await ref.read(purchaseRequestRepositoryProvider).approvePurchaseRequestComparisons(
            widget.prId,
            payload,
          );

      ref.invalidate(purchaseRequestsProvider);
      final String msg = pr.status.toLowerCase() == 'waiting_acknowledge' 
          ? 'Pilihan vendor berhasil di-acknowledge' 
          : 'Pilihan vendor berhasil disetujui';
      _showNotification(msg);
      if (!widget.isEmbedded && mounted) {
        context.pop();
      }
    } catch (e) {
      _showNotification('Error: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _reject() async {
    String? reason;
    await showCupertinoDialog<void>(
      context: context,
      builder: (ctx) {
        final textController = TextEditingController();
        return CupertinoAlertDialog(
          title: const Text('Tolak Pilihan Vendor'),
          content: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CupertinoTextField(
              controller: textController,
              placeholder: 'Alasan penolakan',
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Batal'),
              onPressed: () => Navigator.pop(ctx),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                reason = textController.text.trim();
                Navigator.pop(ctx);
              },
              child: const Text('Tolak'),
            ),
          ],
        );
      },
    );

    if (reason == null) return;

    setState(() => _isSubmitting = true);
    try {
      await ref.read(purchaseRequestRepositoryProvider).rejectPurchaseRequestComparisons(
            widget.prId,
            reason!,
          );

      ref.invalidate(purchaseRequestsProvider);
      _showNotification('Pilihan vendor berhasil ditolak');
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
                          ? prAsync.valueOrNull!.details.any((d) => d.id == widget.itemId && (d.status?.toLowerCase() == 'waiting_acknowledge' || d.status?.toLowerCase() == 'waiting_bod_approval'))
                          : prAsync.valueOrNull!.details.any((d) => d.status?.toLowerCase() == 'waiting_acknowledge' || d.status?.toLowerCase() == 'waiting_bod_approval')) &&
                      prAsync.valueOrNull!.canApprove
              ? (prAsync.valueOrNull!.status.toLowerCase() == 'waiting_acknowledge' ? 'Acknowledge Vendor PR' : 'Pemilihan Vendor PR')
              : 'Detail PR',
          style: TextStyle(color: labelColor),
        ),
      ),
      child: SafeArea(
        child: prAsync.when(
          data: (pr) {
            _initializeSelections(pr.details, pr.comparisons);
            final hasItemsWaitingBod = widget.itemId != null
                ? pr.details.any((d) => d.id == widget.itemId && (d.status?.toLowerCase() == 'waiting_acknowledge' || d.status?.toLowerCase() == 'waiting_bod_approval'))
                : pr.details.any((d) => d.status?.toLowerCase() == 'waiting_acknowledge' || d.status?.toLowerCase() == 'waiting_bod_approval');
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
                            if (pr.vendorSubmittedAt != null) ...[
                              Row(
                                children: [
                                  Icon(CupertinoIcons.clock, size: 12, color: secondaryLabel),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Diajukan Purchasing: ${pr.vendorSubmittedAt}',
                                    style: context.footnote.copyWith(
                                      color: CupertinoColors.activeBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: CupertinoSpacing.xs),
                            ],
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
                              const SizedBox(height: CupertinoSpacing.xs),
                              Text(
                                'Gudang: ${detail.warehouseName != null && detail.warehouseName!.isNotEmpty ? (detail.warehouseCode != null ? "${detail.warehouseName} (${detail.warehouseCode})" : detail.warehouseName!) : (detail.warehouseCode ?? "-")}${detail.warehouseAreaName != null ? " - Area: ${detail.warehouseAreaName}" : ""}',
                                style: context.footnote.copyWith(color: secondaryLabel),
                              ),
                              Builder(
                                builder: (ctx) {
                                  final warehouses = ref.watch(warehousesProvider).valueOrNull ?? [];
                                  final itemWarehouse = warehouses.where((w) => w.code == detail.warehouseCode).firstOrNull;
                                  final areas = itemWarehouse?.areas.where((a) => a.isActive).toList() ?? [];
                                  
                                  if (areas.isEmpty) {
                                    return const SizedBox.shrink();
                                  }

                                  final selectedAreaId = _areaSelections[detail.id];
                                  final selectedArea = areas.where((a) => a.id == selectedAreaId).firstOrNull;

                                  return Padding(
                                    padding: const EdgeInsets.only(top: CupertinoSpacing.s),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Area Tujuan: ',
                                          style: context.footnote.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                                        ),
                                        const SizedBox(width: CupertinoSpacing.xs),
                                        GestureDetector(
                                          onTap: canApproveNow ? () async {
                                            await showCupertinoModalPopup<void>(
                                              context: ctx,
                                              builder: (BuildContext sheetCtx) {
                                                return CupertinoActionSheet(
                                                  title: const Text('Pilih Area Tujuan'),
                                                  message: Text('Gudang: ${detail.warehouseName ?? detail.warehouseCode}'),
                                                  actions: [
                                                    CupertinoActionSheetAction(
                                                      onPressed: () {
                                                        setState(() {
                                                          _areaSelections[detail.id] = null;
                                                        });
                                                        Navigator.pop(sheetCtx);
                                                      },
                                                      child: const Text('Tanpa Area / Default'),
                                                    ),
                                                    ...areas.map((area) {
                                                      return CupertinoActionSheetAction(
                                                        onPressed: () {
                                                          setState(() {
                                                            _areaSelections[detail.id] = area.id;
                                                          });
                                                          Navigator.pop(sheetCtx);
                                                        },
                                                        child: Text(area.name),
                                                      );
                                                    }),
                                                  ],
                                                  cancelButton: CupertinoActionSheetAction(
                                                    isDefaultAction: true,
                                                    onPressed: () => Navigator.pop(sheetCtx),
                                                    child: const Text('Batal'),
                                                  ),
                                                );
                                              },
                                            );
                                          } : null,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.s, vertical: CupertinoSpacing.xs),
                                            decoration: BoxDecoration(
                                              color: CupertinoColors.tertiarySystemFill.resolveFrom(ctx),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  selectedArea?.name ?? 'Pilih Area...',
                                                  style: context.footnote.copyWith(
                                                    color: selectedArea != null ? CupertinoColors.activeBlue : secondaryLabel,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                if (canApproveNow) ...[
                                                  const SizedBox(width: 4),
                                                  Icon(CupertinoIcons.chevron_down, size: 10, color: secondaryLabel),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
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
                                    onTap: (canApproveNow && (detail.status?.toLowerCase() == 'waiting_acknowledge' || detail.status?.toLowerCase() == 'waiting_bod_approval'))
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
                                                const SizedBox(height: 4),
                                                if (comp.isAdvancePayment) ...[
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: CupertinoColors.systemOrange.resolveFrom(context).withValues(alpha: 0.12),
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: Text(
                                                      'Membutuhkan DP ${comp.dpPercentage?.toStringAsFixed(0) ?? 0}% (${formatWithCurrency(comp.dpAmount ?? 0, 'IDR')})',
                                                      style: context.caption2.copyWith(
                                                        color: CupertinoColors.systemOrange.resolveFrom(context),
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ] else ...[
                                                  Text(
                                                    'Tanpa DP (TOP / Cash)',
                                                    style: context.caption2.copyWith(
                                                      color: CupertinoColors.systemGreen.resolveFrom(context),
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
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
                          child: CupertinoButton(
                            color: CupertinoColors.systemRed.resolveFrom(context),
                            borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                            onPressed: _isSubmitting ? null : _reject,
                            child: const Text('Tolak Pilihan', style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.white)),
                          ),
                        ),
                        const SizedBox(width: CupertinoSpacing.m),
                        Expanded(
                          child: CupertinoButton.filled(
                            borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                            onPressed: _isSubmitting ? null : _submit,
                            child: _isSubmitting
                                ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                                : Text(
                                    pr.status.toLowerCase() == 'waiting_acknowledge'
                                        ? 'Acknowledge'
                                        : 'Setujui Pilihan',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
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
