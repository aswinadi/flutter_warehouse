import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider, Scrollbar, Colors;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../purchase_request/providers/purchase_request_provider.dart';
import '../../purchase_request/widgets/pr_card.dart';
import '../../invoice/providers/invoice_repository.dart';
import '../../payment_request/providers/payment_request_repository.dart';
import '../../../core/widgets/company_switcher.dart';
import '../../../core/utils/currency_utils.dart';
import '../../purchase_request/models/purchase_request.dart';
import '../../purchase_request/models/pr_approval.dart';
import '../../purchase_order/providers/purchase_order_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final bgColor = CupertinoColors.systemGroupedBackground.resolveFrom(context);

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
        child: Column(
          children: [
            const CompanySwitcher(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: CupertinoSlidingSegmentedControl<int>(
                groupValue: _selectedSegment,
                children: const {
                  0: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text('Qty PR', style: TextStyle(fontSize: 13)),
                  ),
                  1: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text('Vendor PR', style: TextStyle(fontSize: 13)),
                  ),
                  2: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text('Invoice', style: TextStyle(fontSize: 13)),
                  ),
                  3: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text('Pay Req', style: TextStyle(fontSize: 13)),
                  ),
                  4: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text('PO', style: TextStyle(fontSize: 13)),
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
              child: _buildActiveList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveList() {
    switch (_selectedSegment) {
      case 0:
        return const _PrQtyApprovalList();
      case 1:
        return const _PrVendorApprovalList();
      case 2:
        return const _InvoiceApprovalList();
      case 3:
        return const _PaymentRequestApprovalList();
      case 4:
        return const _POApprovalList();
      default:
        return const SizedBox();
    }
  }
}

class _PrQtyApprovalList extends ConsumerStatefulWidget {
  const _PrQtyApprovalList();

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
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Peringatan'),
            content: const Text('Tidak ada item valid yang dipilih untuk disetujui.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
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
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Sukses'),
            content: const Text('Persetujuan item PR berhasil diajukan.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedItemIds.clear();
                    _notesController.clear();
                  });
                  ref.invalidate(purchaseRequestsProvider(status: 'submitted'));
                },
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Gagal'),
            content: Text('Gagal mengajukan persetujuan: $e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
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
          return const Center(
            child: Text(
              'Tidak ada item PR yang menunggu persetujuan Qty',
              style: TextStyle(color: CupertinoColors.secondaryLabel),
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
                      child: Text(
                        _activeTab == CategoryTab.budidaya
                            ? 'Tidak ada item Budidaya yang menunggu'
                            : 'Tidak ada item Non-Budidaya yang menunggu',
                        style: const TextStyle(color: CupertinoColors.secondaryLabel),
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

                          return _ApprovalItemRow(
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
          style: TextStyle(
            color: isActive ? CupertinoColors.white : CupertinoColors.label.resolveFrom(context),
            fontSize: 12,
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
              placeholderStyle: const TextStyle(color: CupertinoColors.placeholderText),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground.resolveFrom(context),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
              ),
              style: TextStyle(color: labelColor),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton.filled(
                padding: const EdgeInsets.symmetric(vertical: 12),
                onPressed: _isSubmitting ? null : () => _submitBatchApproval(allItems),
                child: _isSubmitting
                    ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                    : Text(
                        'Setujui Seleksi (${_selectedItemIds.length} Barang)',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
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
                          style: TextStyle(fontWeight: FontWeight.bold, color: labelColor, fontSize: 14),
                        ),
                      ),
                      if (item.costCode != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.costCode!,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(item.itemCode, style: const TextStyle(color: CupertinoColors.secondaryLabel, fontSize: 12)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(CupertinoIcons.doc_text, size: 12, color: CupertinoColors.secondaryLabel),
                      const SizedBox(width: 4),
                      Text(
                        '${item.prCode ?? "PR"} • ${item.companyName ?? "Unknown"}',
                        style: const TextStyle(fontSize: 12, color: CupertinoColors.activeBlue, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Jml Diminta: ${item.qtyRequested} ${item.uom}', style: TextStyle(fontSize: 12, color: labelColor)),
                  const SizedBox(height: 2),
                  Text(
                    'Stok Saat Ini: ${item.currentStock} ${item.uom}',
                    style: TextStyle(
                      fontSize: 12,
                      color: item.currentStock < item.qtyRequested ? CupertinoColors.activeOrange : CupertinoColors.secondaryLabel,
                      fontWeight: item.currentStock < item.qtyRequested ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                  if (item.dtSpec != null && item.dtSpec!.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Spesifikasi: ${item.dtSpec}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.secondaryLabel,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  if (item.dtNotes != null && item.dtNotes!.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Keterangan: ${item.dtNotes}',
                      style: const TextStyle(
                        fontSize: 12,
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
                style: TextStyle(fontSize: 13, color: labelColor),
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
      ),
    );
  }
}

class _PrVendorApprovalList extends ConsumerStatefulWidget {
  const _PrVendorApprovalList();

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
        if (items.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada PR yang menunggu persetujuan Vendor',
              style: TextStyle(color: CupertinoColors.secondaryLabel),
            ),
          );
        }
        final hasMore = ref.watch(purchaseRequestsProvider(status: 'waiting_bod_approval').notifier).hasMore;
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
              return PRCard(
                pr: item,
                onTap: () => context.push('/approvals/pr-vendor/${item.id}'),
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
  const _InvoiceApprovalList();

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
          return const Center(
            child: Text(
              'Tidak ada Invoice yang menunggu persetujuan',
              style: TextStyle(color: CupertinoColors.secondaryLabel),
            ),
          );
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
              return Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
                ),
                child: GestureDetector(
                  onTap: () => context.push('/approvals/invoice/${item.id}'),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.invoiceNumber,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
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
                              child: const Text(
                                'DRAFT',
                                style: TextStyle(
                                  color: CupertinoColors.activeOrange,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Vendor: ${item.supplierName ?? "-"}',
                          style: TextStyle(
                            fontSize: 13,
                            color: labelColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total: ${formatWithCurrency(item.totalAmount, item.currency)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.activeBlue,
                          ),
                        ),
                      ],
                    ),
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
  const _PaymentRequestApprovalList();

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
          return const Center(
            child: Text(
              'Tidak ada Payment Request yang menunggu persetujuan',
              style: TextStyle(color: CupertinoColors.secondaryLabel),
            ),
          );
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
              return Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
                ),
                child: GestureDetector(
                  onTap: () => context.push('/approvals/payment-request/${item.id}'),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.requestNumber,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
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
                              child: const Text(
                                'PENDING',
                                style: TextStyle(
                                  color: CupertinoColors.activeOrange,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Diajukan oleh: ${item.requestorName}',
                          style: TextStyle(
                            fontSize: 13,
                            color: labelColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total: ${formatWithCurrency(item.totalAmount, item.currency)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.activeBlue,
                          ),
                        ),
                      ],
                    ),
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

class _POApprovalList extends ConsumerStatefulWidget {
  const _POApprovalList();

  @override
  ConsumerState<_POApprovalList> createState() => _POApprovalListState();
}

class _POApprovalListState extends ConsumerState<_POApprovalList> {
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
      ref.read(purchaseOrdersProvider(status: 'submitted').notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(purchaseOrdersProvider(status: 'submitted'));
    final labelColor = CupertinoColors.label.resolveFrom(context);

    return listAsync.when(
      data: (items) {
        final approvableItems = items.where((po) => po.canApprove).toList();

        if (approvableItems.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada PO yang menunggu persetujuan Anda',
              style: TextStyle(color: CupertinoColors.secondaryLabel),
            ),
          );
        }
        final hasMore = ref.read(purchaseOrdersProvider(status: 'submitted').notifier).hasMore;
        final showLoader = listAsync.isLoading && hasMore;

        return Scrollbar(
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: approvableItems.length + (showLoader ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index == approvableItems.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CupertinoActivityIndicator()),
                );
              }
              final item = approvableItems[index];
              final double calculatedTotal = item.items.fold(
                0.0,
                (sum, item) => sum + (item.orderedQty * (item.unitPrice ?? 0.0)),
              );
              final displayTotal = item.totalAmount ?? calculatedTotal;

              return Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
                ),
                child: GestureDetector(
                  onTap: () => context.push('/approvals/po/${item.id}'),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.poNumber,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
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
                              child: const Text(
                                'SUBMITTED',
                                style: TextStyle(
                                  color: CupertinoColors.activeOrange,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Pemasok: ${item.supplierName}',
                          style: TextStyle(
                            fontSize: 13,
                            color: labelColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total: ${formatWithCurrency(displayTotal, 'IDR')}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.activeBlue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tanggal: ${item.transactionDate}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: CupertinoColors.secondaryLabel,
                          ),
                        ),
                      ],
                    ),
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
