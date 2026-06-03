import 'package:flutter/material.dart';
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

class ApprovalsScreen extends ConsumerWidget {
  const ApprovalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Workspace Persetujuan'),
          backgroundColor: const Color(0xFF0F172A),
          foregroundColor: Colors.white,
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Qty PR'),
              Tab(text: 'Vendor PR'),
              Tab(text: 'Invoice'),
              Tab(text: 'Payment Request'),
              Tab(text: 'PO'),
            ],
          ),
        ),
        body: Column(
          children: [
            const CompanySwitcher(),
            const Expanded(
              child: TabBarView(
                children: [
                  _PrQtyApprovalList(),
                  _PrVendorApprovalList(),
                  _InvoiceApprovalList(),
                  _PaymentRequestApprovalList(),
                  _POApprovalList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

    setState(() => _isSubmitting = true);

    try {
      // Group selected items by prId
      final selectedItems = allItems.where((item) => _selectedItemIds.contains(item.id)).toList();
      final groupedByPr = <int, List<PurchaseRequestItem>>{};
      for (var item in selectedItems) {
        if (item.prId != null) {
          groupedByPr.putIfAbsent(item.prId!, () => []).add(item);
        }
      }

      final repository = ref.read(purchaseRequestRepositoryProvider);

      for (var entry in groupedByPr.entries) {
        final prId = entry.key;
        final prSelectedItems = entry.value;

        // Find all items in this PR that the user can approve (authorized)
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Persetujuan item PR berhasil diajukan')),
        );
        // Clear selection & reset notes
        setState(() {
          _selectedItemIds.clear();
          _notesController.clear();
        });
        // Invalidate provider to reload data
        ref.invalidate(purchaseRequestsProvider(status: 'submitted'));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengajukan persetujuan: $e'), backgroundColor: Colors.red),
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
        // Flatten and extract all items that are pending approval for the current user
        final allItems = prs
            .expand((pr) => pr.details)
            .where((item) => item.canApprove)
            .toList();

        if (allItems.isEmpty) {
          return const Center(child: Text('Tidak ada item PR yang menunggu persetujuan Qty'));
        }

        _initializeQtyControllers(allItems);

        // Filter items based on active tab
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
            // Pill tabs selector
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
              ),
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
            // Items List
            Expanded(
              child: filteredItems.isEmpty
                  ? Center(
                      child: Text(
                        _activeTab == CategoryTab.budidaya
                            ? 'Tidak ada item Budidaya yang menunggu persetujuan'
                            : 'Tidak ada item Non-Budidaya yang menunggu persetujuan',
                      ),
                    )
                  : ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredItems.length + (showLoader ? 1 : 0),
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        if (index == filteredItems.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
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
            // Bottom Action Sheet if any items are selected
            if (_selectedItemIds.isNotEmpty) _buildBottomActionSheet(allItems),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0F172A) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
            width: 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF64748B),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionSheet(List<PurchaseRequestItem> allItems) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 1.0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _notesController,
            decoration: InputDecoration(
              labelText: 'Catatan Persetujuan (Opsional)',
              labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
              fillColor: const Color(0xFFF8FAFC),
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF6E56CF), width: 2.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : () => _submitBatchApproval(allItems),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6E56CF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text('SETUJUI SELEKSI (${_selectedItemIds.length} BARANG)'),
            ),
          ),
        ],
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
          return const Center(child: Text('Tidak ada PR yang menunggu persetujuan Vendor'));
        }
        final hasMore = ref.watch(purchaseRequestsProvider(status: 'waiting_bod_approval').notifier).hasMore;
        final showLoader = listAsync.isLoading && hasMore;

        return ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: items.length + (showLoader ? 1 : 0),
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == items.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final item = items[index];
            return PRCard(
              pr: item,
              onTap: () => context.push('/approvals/pr-vendor/${item.id}'),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
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

    return listAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return const Center(child: Text('Tidak ada Invoice yang menunggu persetujuan'));
        }
        final hasMore = ref.watch(invoicesProvider(status: 'draft').notifier).hasMore;
        final showLoader = listAsync.isLoading && hasMore;

        return ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: items.length + (showLoader ? 1 : 0),
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == items.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final item = items[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x140F0F0F),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.push('/approvals/invoice/${item.id}'),
                  borderRadius: BorderRadius.circular(12),
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF59E0B).withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.2)),
                              ),
                              child: const Text(
                                'DRAFT',
                                style: TextStyle(
                                  color: Color(0xFFF59E0B),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Vendor: ${item.supplierName ?? "-"}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF0F172A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total: ${formatWithCurrency(item.totalAmount, item.currency)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4F46E5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
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

    return listAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return const Center(child: Text('Tidak ada Payment Request yang menunggu persetujuan'));
        }
        final hasMore = ref.watch(paymentRequestsProvider(status: 'pending').notifier).hasMore;
        final showLoader = listAsync.isLoading && hasMore;

        return ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: items.length + (showLoader ? 1 : 0),
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == items.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final item = items[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x140F0F0F),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.push('/approvals/payment-request/${item.id}'),
                  borderRadius: BorderRadius.circular(12),
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF59E0B).withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.2)),
                              ),
                              child: const Text(
                                'PENDING',
                                style: TextStyle(
                                  color: Color(0xFFF59E0B),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Diajukan oleh: ${item.requestorName}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF0F172A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total: ${formatWithCurrency(item.totalAmount, item.currency)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4F46E5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0x140F0F0F),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Checkbox(
              value: isSelected, 
              onChanged: onChanged,
              activeColor: const Color(0xFF6E56CF), // Notion Purple
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
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A), fontSize: 14),
                        ),
                      ),
                      if (item.costCode != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.costCode!,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(item.itemCode, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.description_outlined, size: 12, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Text(
                        '${item.prCode ?? "PR"} • ${item.companyName ?? "Unknown"}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF4F46E5), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Jml Diminta: ${item.qtyRequested} ${item.uom}', style: const TextStyle(fontSize: 12, color: Color(0xFF0F172A))),
                  const SizedBox(height: 2),
                  Text(
                    'Stok Saat Ini: ${item.currentStock} ${item.uom}',
                    style: TextStyle(
                      fontSize: 12,
                      color: item.currentStock < item.qtyRequested ? const Color(0xFFF59E0B) : const Color(0xFF64748B),
                      fontWeight: item.currentStock < item.qtyRequested ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                  if (item.dtSpec != null && item.dtSpec!.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Spesifikasi: ${item.dtSpec}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
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
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 90,
              child: TextField(
                controller: qtyController,
                enabled: !isReadOnly && isSelected,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'Jml Setuju',
                  labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  fillColor: const Color(0xFFF8FAFC),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF6E56CF), width: 2.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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

    return listAsync.when(
      data: (items) {
        final approvableItems = items.where((po) => po.canApprove).toList();

        if (approvableItems.isEmpty) {
          return const Center(child: Text('Tidak ada PO yang menunggu persetujuan Anda'));
        }
        final hasMore = ref.read(purchaseOrdersProvider(status: 'submitted').notifier).hasMore;
        final showLoader = listAsync.isLoading && hasMore;

        return ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: approvableItems.length + (showLoader ? 1 : 0),
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == approvableItems.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x140F0F0F),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.push('/approvals/po/${item.id}'),
                  borderRadius: BorderRadius.circular(12),
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF59E0B).withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.2)),
                              ),
                              child: const Text(
                                'SUBMITTED',
                                style: TextStyle(
                                  color: Color(0xFFF59E0B),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Pemasok: ${item.supplierName}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF0F172A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total: ${formatWithCurrency(displayTotal, 'IDR')}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4F46E5),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tanggal: ${item.transactionDate}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

