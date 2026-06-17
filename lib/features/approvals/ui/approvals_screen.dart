import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Scrollbar, Colors;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../purchase_request/providers/purchase_request_provider.dart';
import '../../invoice/providers/invoice_repository.dart';
import '../../payment_request/providers/payment_request_repository.dart';
import '../../../core/widgets/company_switcher.dart';
import '../../../core/utils/currency_utils.dart';
import '../../purchase_request/models/purchase_request.dart';
import '../../purchase_request/models/pr_approval.dart';
import '../../purchase_request/ui/pr_approval_screen.dart';
import '../../purchase_request/ui/pr_vendor_approval_screen.dart';
import '../../invoice/ui/invoice_approval_screen.dart';
import '../../payment_request/ui/payment_request_approval_screen.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_dialog.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';

class CupertinoCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CupertinoCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: value ? CupertinoColors.activeBlue : Colors.transparent,
          border: Border.all(
            color: value ? CupertinoColors.activeBlue : CupertinoColors.separator.resolveFrom(context),
            width: 1.5,
          ),
        ),
        child: value
            ? const Icon(
                CupertinoIcons.checkmark,
                size: 14,
                color: CupertinoColors.white,
              )
            : null,
      ),
    );
  }
}

class ApprovalsScreen extends ConsumerStatefulWidget {
  const ApprovalsScreen({super.key});

  @override
  ConsumerState<ApprovalsScreen> createState() => _ApprovalsScreenState();
}

class _ApprovalsScreenState extends ConsumerState<ApprovalsScreen> {
  int _selectedSegment = 0;

  // Selected IDs for wide layout
  int? _selectedPrQtyId;
  int? _selectedPrQtyItemId;
  int? _selectedPrVendorId;
  int? _selectedPrVendorItemId;
  int? _selectedInvoiceId;
  int? _selectedPaymentRequestId;

  @override
  Widget build(BuildContext context) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final bgColor = CupertinoColors.systemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final isWide = MediaQuery.of(context).size.width > 900;

    final mainContent = Column(
      children: [
        const CompanySwitcher(),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: CupertinoSlidingSegmentedControl<int>(
            groupValue: _selectedSegment,
            children: {
              0: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text('Qty PR', style: context.footnote),
              ),
              1: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text('Vendor PR', style: context.footnote),
              ),
              2: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text('Invoice', style: context.footnote),
              ),
              3: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text('Pay Req', style: context.footnote),
              ),
            },
            onValueChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedSegment = value;
                });
              }
            },
          ),
        ),
        Expanded(
          child: _buildActiveList(isWide),
        ),
      ],
    );

    return CupertinoPageScaffold(
      backgroundColor: bgColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        middle: Text(
          'Workspace Persetujuan',
          style: TextStyle(color: labelColor),
        ),
      ),
      child: SafeArea(
        child: isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 380,
                    child: mainContent,
                  ),
                  Container(width: 0.5, color: separatorColor),
                  Expanded(
                    child: Container(
                      color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                      child: _buildDetailPane(),
                    ),
                  ),
                ],
              )
            : mainContent,
      ),
    );
  }

  Widget _buildActiveList(bool isWide) {
    switch (_selectedSegment) {
      case 0:
        return _PrQtyApprovalList(
          isWide: isWide,
          selectedPrId: _selectedPrQtyId,
          selectedItemId: _selectedPrQtyItemId,
          onSelected: (prId, itemId) => setState(() {
            _selectedPrQtyId = prId;
            _selectedPrQtyItemId = itemId;
          }),
        );
      case 1:
        return _PrVendorApprovalList(
          isWide: isWide,
          selectedPrId: _selectedPrVendorId,
          selectedItemId: _selectedPrVendorItemId,
          onSelected: (prId, itemId) => setState(() {
            _selectedPrVendorId = prId;
            _selectedPrVendorItemId = itemId;
          }),
        );
      case 2:
        return _InvoiceApprovalList(
          isWide: isWide,
          selectedId: _selectedInvoiceId,
          onSelected: (id) => setState(() => _selectedInvoiceId = id),
        );
      case 3:
        return _PaymentRequestApprovalList(
          isWide: isWide,
          selectedId: _selectedPaymentRequestId,
          onSelected: (id) => setState(() => _selectedPaymentRequestId = id),
        );
      default:
        return const SizedBox();
    }
  }

  Widget? _buildDetailPane() {
    switch (_selectedSegment) {
      case 0:
        if (_selectedPrQtyId == null) return const Center(child: Text('Pilih PR untuk melihat detail'));
        return KeyedSubtree(
          key: ValueKey('qty_$_selectedPrQtyId-$_selectedPrQtyItemId'),
          child: PRApprovalScreen(
            prId: _selectedPrQtyId!,
            itemId: _selectedPrQtyItemId,
            isEmbedded: true,
          ),
        );
      case 1:
        if (_selectedPrVendorId == null) return const Center(child: Text('Pilih PR untuk melihat detail'));
        return KeyedSubtree(
          key: ValueKey('vendor_$_selectedPrVendorId-$_selectedPrVendorItemId'),
          child: PRVendorApprovalScreen(
            prId: _selectedPrVendorId!,
            itemId: _selectedPrVendorItemId,
            isEmbedded: true,
          ),
        );
      case 2:
        if (_selectedInvoiceId == null) return const Center(child: Text('Pilih Invoice untuk melihat detail'));
        return KeyedSubtree(
          key: ValueKey('invoice_$_selectedInvoiceId'),
          child: InvoiceApprovalScreen(invoiceId: _selectedInvoiceId!, isEmbedded: true),
        );
      case 3:
        if (_selectedPaymentRequestId == null) return const Center(child: Text('Pilih Payment Request untuk melihat detail'));
        return KeyedSubtree(
          key: ValueKey('payreq_$_selectedPaymentRequestId'),
          child: PaymentRequestApprovalScreen(prId: _selectedPaymentRequestId!, isEmbedded: true),
        );
      default:
        return null;
    }
  }
}

class _PrQtyApprovalList extends ConsumerStatefulWidget {
  final bool isWide;
  final int? selectedPrId;
  final int? selectedItemId;
  final void Function(int? prId, int? itemId) onSelected;

  const _PrQtyApprovalList({
    required this.isWide,
    required this.selectedPrId,
    required this.selectedItemId,
    required this.onSelected,
  });

  @override
  ConsumerState<_PrQtyApprovalList> createState() => _PrQtyApprovalListState();
}

enum CategoryTab { budidaya, nonBudidaya }

class _PrQtyApprovalListState extends ConsumerState<_PrQtyApprovalList> {
  final ScrollController _scrollController = ScrollController();
  CategoryTab _activeTab = CategoryTab.budidaya;
  final Set<int> _selectedItemIds = {};
  final Map<int, TextEditingController> _qtyControllers = {};
  final _notesController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (var controller in _qtyControllers.values) {
      controller.dispose();
    }
    _notesController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll * 0.9) {
      ref.read(purchaseRequestsProvider(status: 'submitted').notifier).loadMore();
    }
  }

  void _initializeQtyControllers(List<PurchaseRequestItem> items) {
    for (var item in items) {
      if (!_qtyControllers.containsKey(item.id)) {
        _qtyControllers[item.id] = TextEditingController(text: item.qtyRequested.toString());
      }
    }
  }

  Future<void> _submitBatchApproval(List<PurchaseRequestItem> allItems) async {
    if (_selectedItemIds.isEmpty) return;

    final selectedItems = allItems.where((item) => _selectedItemIds.contains(item.id)).toList();
    final groupedByPr = <int, List<PurchaseRequestItem>>{};
    for (var item in selectedItems) {
      if (item.prId != null) {
        groupedByPr.putIfAbsent(item.prId!, () => []).add(item);
      }
    }

    if (groupedByPr.isEmpty) {
      if (mounted) {
        CupertinoGlassToast.showError(context, 'Tidak ada item valid yang dipilih untuk disetujui.');
      }
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final repository = ref.read(purchaseRequestRepositoryProvider);

      for (var entry in groupedByPr.entries) {
        final prId = entry.key;
        final prSelectedItems = entry.value;

        final prAllAuthorizedItems = allItems.where((item) => item.prId == prId && item.canApprove).toList();

        final detailsList = prAllAuthorizedItems.map((item) {
          final isSelected = _selectedItemIds.contains(item.id);
          final qty = isSelected 
              ? (double.tryParse(_qtyControllers[item.id]?.text ?? '0') ?? 0) 
              : 0.0;
          return ApproveRequestDetail(id: item.id, approvedQty: qty);
        }).toList();

        final request = ApproveRequest(
          notes: _notesController.text.isNotEmpty ? _notesController.text : null,
          selectedItemIds: prSelectedItems.map((e) => e.id).toList(),
          details: detailsList,
        );

        await repository.approvePurchaseRequest(prId, request);
      }

      if (mounted) {
        CupertinoGlassToast.showSuccess(context, 'Persetujuan item PR berhasil diajukan.');
        setState(() {
          _selectedItemIds.clear();
          _notesController.clear();
        });
        ref.invalidate(purchaseRequestsProvider(status: 'submitted'));
      }
    } catch (e) {
      if (mounted) {
        CupertinoGlassToast.showError(context, 'Gagal mengajukan persetujuan: $e');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(purchaseRequestsProvider(status: 'submitted'));

    return listAsync.when(
      data: (prs) {
        final allItems = prs
            .expand((pr) => pr.details.map((item) => item.copyWith(prId: item.prId ?? pr.id)))
            .where((item) => item.canApprove)
            .toList();

        if (allItems.isEmpty) {
          if (widget.isWide && (widget.selectedPrId != null || widget.selectedItemId != null)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) widget.onSelected(null, null);
            });
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Tidak ada item PR yang menunggu persetujuan Qty',
                textAlign: TextAlign.center,
                style: context.subhead.copyWith(color: CupertinoColors.secondaryLabel),
              ),
            ),
          );
        }

        _initializeQtyControllers(allItems);

        final filteredItems = allItems.where((item) {
          final isBudidaya = item.costCode != null && item.costCode!.startsWith('9.');
          if (_activeTab == CategoryTab.budidaya) {
            return isBudidaya;
          } else {
            return !isBudidaya;
          }
        }).toList();

        if (widget.isWide) {
          if (filteredItems.isNotEmpty) {
            if (widget.selectedItemId == null || !filteredItems.any((x) => x.id == widget.selectedItemId)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  final firstItem = filteredItems.first;
                  widget.onSelected(firstItem.prId, firstItem.id);
                }
              });
            }
          } else {
            if (widget.selectedPrId != null || widget.selectedItemId != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) widget.onSelected(null, null);
              });
            }
          }
        }

        final hasMore = ref.watch(purchaseRequestsProvider(status: 'submitted').notifier).hasMore;
        final showLoader = listAsync.isLoading && hasMore;

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: Row(
                children: [
                  _buildPillTab(
                    label: 'Budidaya (9.x)',
                    isActive: _activeTab == CategoryTab.budidaya,
                    onTap: () => setState(() {
                      _activeTab = CategoryTab.budidaya;
                      _selectedItemIds.clear();
                    }),
                  ),
                  const SizedBox(width: 8),
                  _buildPillTab(
                    label: 'Non-Budidaya (10.x)',
                    isActive: _activeTab == CategoryTab.nonBudidaya,
                    onTap: () => setState(() {
                      _activeTab = CategoryTab.nonBudidaya;
                      _selectedItemIds.clear();
                    }),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filteredItems.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          _activeTab == CategoryTab.budidaya
                              ? 'Tidak ada item Budidaya yang menunggu'
                              : 'Tidak ada item Non-Budidaya yang menunggu',
                          textAlign: TextAlign.center,
                          style: context.subhead.copyWith(color: CupertinoColors.secondaryLabel),
                        ),
                      ),
                    )
                  : Scrollbar(
                      child: ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredItems.length + (showLoader ? 1 : 0),
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          if (index == filteredItems.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CupertinoActivityIndicator()),
                            );
                          }
                          final item = filteredItems[index];
                          final isSelected = _selectedItemIds.contains(item.id);
                          final isRowSelected = widget.isWide && item.id == widget.selectedItemId;

                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (widget.isWide) {
                                if (item.prId != null) {
                                  widget.onSelected(item.prId, item.id);
                                }
                              } else {
                                context.push('/approvals/pr-qty/${item.prId}?item_id=${item.id}');
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isRowSelected
                                      ? const Color(0xFF6E56CF)
                                      : Colors.transparent,
                                  width: isRowSelected ? 1.5 : 0.0,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: _ApprovalItemRow(
                                item: item,
                                isSelected: isSelected,
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      _selectedItemIds.add(item.id);
                                    } else {
                                      _selectedItemIds.remove(item.id);
                                    }
                                  });
                                },
                                qtyController: _qtyControllers[item.id]!,
                                isReadOnly: false,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
            if (_selectedItemIds.isNotEmpty) _buildBottomActionSheet(allItems),
          ],
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildPillTab({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive 
              ? CupertinoColors.activeBlue 
              : CupertinoColors.tertiarySystemFill.resolveFrom(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: context.caption1.copyWith(
            color: isActive ? CupertinoColors.white : CupertinoColors.label.resolveFrom(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionSheet(List<PurchaseRequestItem> allItems) {
    final labelColor = CupertinoColors.label.resolveFrom(context);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
          border: Border(
            top: BorderSide(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoTextField(
              controller: _notesController,
              placeholder: 'Catatan Persetujuan (Opsional)',
              placeholderStyle: context.subhead.copyWith(color: CupertinoColors.placeholderText.resolveFrom(context)),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground.resolveFrom(context),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
              ),
              style: context.subhead.copyWith(color: labelColor),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: CupertinoSpacing.primaryButtonHeight,
              child: CupertinoButton.filled(
                padding: EdgeInsets.zero,
                onPressed: _isSubmitting ? null : () => _submitBatchApproval(allItems),
                child: _isSubmitting
                    ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                    : Text(
                        'Setujui Seleksi (${_selectedItemIds.length} Barang)',
                        style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: CupertinoColors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApprovalItemRow extends StatelessWidget {
  final PurchaseRequestItem item;
  final bool isSelected;
  final ValueChanged<bool?>? onChanged;
  final TextEditingController qtyController;
  final bool isReadOnly;

  const _ApprovalItemRow({
    required this.item,
    required this.isSelected,
    required this.onChanged,
    required this.qtyController,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = CupertinoColors.label.resolveFrom(context);

    final cardColor = isSelected
        ? CupertinoColors.activeBlue.resolveFrom(context).withValues(alpha: 0.08)
        : CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);

    return CupertinoGlassContainer(
      backgroundColor: cardColor,
      borderColor: isSelected 
          ? CupertinoColors.activeBlue.resolveFrom(context) 
          : CupertinoColors.separator.resolveFrom(context),
      borderRadius: CupertinoSpacing.cardRadius,
      padding: const EdgeInsets.all(CupertinoSpacing.m),
      child: Row(
        children: [
          CupertinoCheckbox(
            value: isSelected, 
            onChanged: (val) => onChanged?.call(val),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.itemName, 
                        style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                      ),
                    ),
                    if (item.costCode != null) ...[
                      const SizedBox(width: CupertinoSpacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.costCode!,
                          style: context.caption2.copyWith(fontWeight: FontWeight.bold, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(item.itemCode, style: context.caption1.copyWith(color: CupertinoColors.secondaryLabel)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(CupertinoIcons.doc_text, size: 12, color: CupertinoColors.secondaryLabel),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${item.prCode ?? "PR"} • ${item.companyName ?? "Unknown"}',
                        style: context.caption1.copyWith(color: CupertinoColors.activeBlue, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Jml Diminta: ${item.qtyRequested} ${item.uom}', style: context.caption1.copyWith(color: labelColor)),
                const SizedBox(height: 2),
                Text(
                  'Stok Saat Ini: ${item.currentStock} ${item.uom}',
                  style: context.caption1.copyWith(
                    color: item.currentStock < item.qtyRequested ? CupertinoColors.activeOrange : CupertinoColors.secondaryLabel,
                    fontWeight: item.currentStock < item.qtyRequested ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
                if (item.dtSpec != null && item.dtSpec!.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Spesifikasi: ${item.dtSpec}',
                    style: context.caption1.copyWith(
                      color: CupertinoColors.secondaryLabel,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                if (item.dtNotes != null && item.dtNotes!.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Keterangan: ${item.dtNotes}',
                    style: context.caption1.copyWith(
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: CupertinoTextField(
              controller: qtyController,
              enabled: !isReadOnly && isSelected,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              style: context.footnote.copyWith(color: labelColor),
              placeholder: 'Jml',
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected 
                    ? CupertinoColors.systemBackground.resolveFrom(context)
                    : CupertinoColors.tertiarySystemFill.resolveFrom(context),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrVendorItemCard extends StatelessWidget {
  final PurchaseRequestItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _PrVendorItemCard({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);

    final cardColor = isSelected
        ? CupertinoColors.activeBlue.resolveFrom(context).withValues(alpha: 0.08)
        : CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);

    return CupertinoGlassContainer(
      backgroundColor: cardColor,
      borderColor: isSelected 
          ? CupertinoColors.activeBlue.resolveFrom(context) 
          : CupertinoColors.separator.resolveFrom(context),
      borderRadius: CupertinoSpacing.cardRadius,
      padding: const EdgeInsets.all(CupertinoSpacing.l),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.itemName,
              style: context.subhead.copyWith(
                fontWeight: FontWeight.bold,
                color: labelColor,
              ),
            ),
            const SizedBox(height: CupertinoSpacing.xs),
            Text(
              'SKU: ${item.itemCode} | Qty: ${item.qtyRequested} ${item.uom}',
              style: context.footnote.copyWith(
                color: secondaryLabelColor,
              ),
            ),
            const SizedBox(height: CupertinoSpacing.s),
            Row(
              children: [
                Icon(CupertinoIcons.doc_text, size: 12, color: secondaryLabelColor),
                const SizedBox(width: CupertinoSpacing.xs),
                Expanded(
                  child: Text(
                    '${item.prCode ?? "PR"} • ${item.companyName ?? "-"}',
                    style: context.caption1.copyWith(
                      color: CupertinoColors.activeBlue,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PrVendorApprovalList extends ConsumerStatefulWidget {
  final bool isWide;
  final int? selectedPrId;
  final int? selectedItemId;
  final void Function(int? prId, int? itemId) onSelected;

  const _PrVendorApprovalList({
    required this.isWide,
    required this.selectedPrId,
    required this.selectedItemId,
    required this.onSelected,
  });

  @override
  ConsumerState<_PrVendorApprovalList> createState() => _PrVendorApprovalListState();
}

class _PrVendorApprovalListState extends ConsumerState<_PrVendorApprovalList> {
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
      ref.read(purchaseRequestsProvider(status: 'waiting_bod_approval').notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(purchaseRequestsProvider(status: 'waiting_bod_approval'));

    return listAsync.when(
      data: (items) {
        final allItems = items
            .expand((pr) => pr.details.map((item) => item.copyWith(
                  prId: item.prId ?? pr.id,
                  prCode: item.prCode ?? pr.code,
                  companyName: item.companyName ?? pr.companyName,
                )))
            .where((item) => item.status?.toLowerCase() == 'waiting_bod_approval')
            .toList();

        if (allItems.isEmpty) {
          if (widget.isWide && (widget.selectedPrId != null || widget.selectedItemId != null)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) widget.onSelected(null, null);
            });
          }
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Tidak ada item PR yang menunggu persetujuan Vendor',
                textAlign: TextAlign.center,
                style: TextStyle(color: CupertinoColors.secondaryLabel),
              ),
            ),
          );
        }

        if (widget.isWide && allItems.isNotEmpty) {
          if (widget.selectedItemId == null || !allItems.any((x) => x.id == widget.selectedItemId)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                final firstItem = allItems.first;
                widget.onSelected(firstItem.prId, firstItem.id);
              }
            });
          }
        }

        final hasMore = ref.watch(purchaseRequestsProvider(status: 'waiting_bod_approval').notifier).hasMore;
        final showLoader = listAsync.isLoading && hasMore;

        return Scrollbar(
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: allItems.length + (showLoader ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index == allItems.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CupertinoActivityIndicator()),
                );
              }
              final item = allItems[index];
              final isSelected = widget.isWide && item.id == widget.selectedItemId;

              return _PrVendorItemCard(
                item: item,
                isSelected: isSelected,
                onTap: () {
                  if (widget.isWide) {
                    widget.onSelected(item.prId, item.id);
                  } else {
                    context.push('/approvals/pr-vendor/${item.prId}?item_id=${item.id}');
                  }
                },
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _InvoiceApprovalList extends ConsumerStatefulWidget {
  final bool isWide;
  final int? selectedId;
  final ValueChanged<int?> onSelected;

  const _InvoiceApprovalList({
    required this.isWide,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  ConsumerState<_InvoiceApprovalList> createState() => _InvoiceApprovalListState();
}

class _InvoiceApprovalListState extends ConsumerState<_InvoiceApprovalList> {
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
      ref.read(invoicesProvider(status: 'draft').notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(invoicesProvider(status: 'draft'));
    final labelColor = CupertinoColors.label.resolveFrom(context);

    return listAsync.when(
      data: (items) {
        if (items.isEmpty) {
          if (widget.isWide && widget.selectedId != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) widget.onSelected(null);
            });
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Tidak ada Invoice yang menunggu persetujuan',
                textAlign: TextAlign.center,
                style: context.subhead.copyWith(color: CupertinoColors.secondaryLabel),
              ),
            ),
          );
        }

        if (widget.isWide && items.isNotEmpty) {
          if (widget.selectedId == null || !items.any((x) => x.id == widget.selectedId)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                widget.onSelected(items.first.id);
              }
            });
          }
        }

        final hasMore = ref.watch(invoicesProvider(status: 'draft').notifier).hasMore;
        final showLoader = listAsync.isLoading && hasMore;

        return Scrollbar(
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: items.length + (showLoader ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index == items.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CupertinoActivityIndicator()),
                );
              }
              final item = items[index];
              final isSelected = item.id == widget.selectedId;

              final cardColor = isSelected
                  ? CupertinoColors.activeBlue.resolveFrom(context).withValues(alpha: 0.08)
                  : CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);

              return CupertinoGlassContainer(
                backgroundColor: cardColor,
                borderColor: isSelected 
                    ? CupertinoColors.activeBlue.resolveFrom(context) 
                    : CupertinoColors.separator.resolveFrom(context),
                borderRadius: CupertinoSpacing.cardRadius,
                padding: const EdgeInsets.all(CupertinoSpacing.l),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (widget.isWide) {
                      widget.onSelected(item.id);
                    } else {
                      context.push('/approvals/invoice/${item.id}');
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.invoiceNumber,
                            style: context.subhead.copyWith(
                              fontWeight: FontWeight.bold,
                              color: labelColor,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: CupertinoColors.activeOrange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: CupertinoColors.activeOrange, width: 0.5),
                            ),
                            child: Text(
                              'DRAFT',
                              style: context.caption2.copyWith(
                                color: CupertinoColors.activeOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: CupertinoSpacing.s),
                      Text(
                        'Vendor: ${item.supplierName ?? "-"}',
                        style: context.footnote.copyWith(
                          color: labelColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: CupertinoSpacing.xs),
                      Text(
                        'Total: ${formatWithCurrency(item.totalAmount, item.currency)}',
                        style: context.footnote.copyWith(
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _PaymentRequestApprovalList extends ConsumerStatefulWidget {
  final bool isWide;
  final int? selectedId;
  final ValueChanged<int?> onSelected;

  const _PaymentRequestApprovalList({
    required this.isWide,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  ConsumerState<_PaymentRequestApprovalList> createState() => _PaymentRequestApprovalListState();
}

class _PaymentRequestApprovalListState extends ConsumerState<_PaymentRequestApprovalList> {
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
      ref.read(paymentRequestsProvider(status: 'pending').notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(paymentRequestsProvider(status: 'pending'));
    final labelColor = CupertinoColors.label.resolveFrom(context);

    return listAsync.when(
      data: (items) {
        if (items.isEmpty) {
          if (widget.isWide && widget.selectedId != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) widget.onSelected(null);
            });
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Tidak ada Payment Request yang menunggu persetujuan',
                textAlign: TextAlign.center,
                style: context.subhead.copyWith(color: CupertinoColors.secondaryLabel),
              ),
            ),
          );
        }

        if (widget.isWide && items.isNotEmpty) {
          if (widget.selectedId == null || !items.any((x) => x.id == widget.selectedId)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                widget.onSelected(items.first.id);
              }
            });
          }
        }

        final hasMore = ref.watch(paymentRequestsProvider(status: 'pending').notifier).hasMore;
        final showLoader = listAsync.isLoading && hasMore;

        return Scrollbar(
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: items.length + (showLoader ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index == items.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CupertinoActivityIndicator()),
                );
              }
              final item = items[index];
              final isSelected = item.id == widget.selectedId;

              final cardColor = isSelected
                  ? CupertinoColors.activeBlue.resolveFrom(context).withValues(alpha: 0.08)
                  : CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);

              return CupertinoGlassContainer(
                backgroundColor: cardColor,
                borderColor: isSelected 
                    ? CupertinoColors.activeBlue.resolveFrom(context) 
                    : CupertinoColors.separator.resolveFrom(context),
                borderRadius: CupertinoSpacing.cardRadius,
                padding: const EdgeInsets.all(CupertinoSpacing.l),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (widget.isWide) {
                      widget.onSelected(item.id);
                    } else {
                      context.push('/approvals/payment-request/${item.id}');
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.requestNumber,
                            style: context.subhead.copyWith(
                              fontWeight: FontWeight.bold,
                              color: labelColor,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: CupertinoColors.activeOrange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: CupertinoColors.activeOrange, width: 0.5),
                            ),
                            child: Text(
                              'PENDING',
                              style: context.caption2.copyWith(
                                color: CupertinoColors.activeOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: CupertinoSpacing.s),
                      Text(
                        'Diajukan oleh: ${item.requestorName}',
                        style: context.footnote.copyWith(
                          color: labelColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: CupertinoSpacing.xs),
                      Text(
                        'Total: ${formatWithCurrency(item.totalAmount, item.currency)}',
                        style: context.footnote.copyWith(
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

// PO Approval List removed as PO approval is no longer required on screen
