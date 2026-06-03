import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        title: const Text('Detail PR'),
        actions: [
          prAsync.when(
            data: (pr) => IconButton(
              icon: const Icon(Icons.print),
              onPressed: () {
                context.push('/pdf-preview?title=Purchase Request ${pr.code}&url_path=pdf/purchase-request/${pr.id}');
              },
            ),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: PRDetailsView(prId: prId),
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

  Future<void> _handleAutoAssign(String strategy) async {
    setState(() => _isAutoAssigning = true);
    try {
      final repo = ref.read(purchaseRequestRepositoryProvider);
      await repo.autoAssignVendors(widget.prId, strategy: strategy);

      ref.invalidate(purchaseRequestDetailProvider(widget.prId));
      ref.invalidate(purchaseRequestsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Penetapan otomatis berhasil.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menetapkan otomatis: $e')),
        );
      }
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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kuantitas berhasil diajukan ke BOD untuk pemilihan vendor.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengajukan: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmittingToBod = false);
      }
    }
  }

  Future<void> _showStrategyDialog() async {
    String selectedStrategy = 'lowest_price';

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Tetapkan Vendor Otomatis'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih strategi untuk menemukan dan menetapkan vendor terbaik secara otomatis berdasarkan riwayat pembelian:',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 16),
                  RadioListTile<String>(
                    title: const Text('Harga Terendah'),
                    subtitle: const Text('Mencari vendor dengan harga historis terendah untuk barang-barang ini.'),
                    value: 'lowest_price',
                    groupValue: selectedStrategy,
                    activeColor: const Color(0xFF4F46E5),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedStrategy = val);
                      }
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Pemasok Terakhir'),
                    subtitle: const Text('Memilih pemasok dari pesanan pembelian terbaru.'),
                    value: 'last_supplier',
                    groupValue: selectedStrategy,
                    activeColor: const Color(0xFF4F46E5),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedStrategy = val);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal', style: TextStyle(color: Color(0xFF64748B))),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleAutoAssign(selectedStrategy);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Jalankan Penetapan'),
                ),
              ],
            );
          },
        );
      },
    );
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

        return DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMetadataHeader(context, pr),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A0F0F0F),
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    labelColor: const Color(0xFF0F172A),
                    unselectedLabelColor: const Color(0xFF64748B),
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    tabs: [
                      const Tab(text: 'Barang Diminta'),
                      Tab(text: 'Perbandingan Vendor (${pr.comparisons.length})'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: TabBarView(
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
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildComparisonsTab(PurchaseRequest pr, bool showPurchasingActions) {
    if (pr.comparisons.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.auto_awesome_outlined, size: 64, color: Color(0xFF94A3B8)),
          const SizedBox(height: 16),
          const Text(
            'Belum ada perbandingan vendor yang ditetapkan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Jalankan penetapan otomatis untuk menemukan saran vendor.',
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
          if (showPurchasingActions) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isAutoAssigning ? null : _showStrategyDialog,
              icon: _isAutoAssigning
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.auto_awesome, size: 18),
              label: const Text('Tetapkan Vendor Otomatis'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFA7F3D0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF059669), size: 20),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Vendor telah ditetapkan. Klik "Ajukan ke BOD" untuk meminta persetujuan.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF065F46), fontWeight: FontWeight.w500),
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
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isAutoAssigning ? null : _showStrategyDialog,
                    icon: _isAutoAssigning
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.auto_awesome, size: 16),
                    label: const Text('Tetapkan Ulang Vendor'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF4F46E5),
                      side: const BorderSide(color: Color(0xFF4F46E5)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isSubmittingToBod ? null : _handleSubmitToBod,
                    icon: _isSubmittingToBod
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.send_rounded, size: 16),
                    label: const Text('Ajukan ke BOD'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMetadataHeader(BuildContext context, PurchaseRequest pr) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F0F0F),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pr.code,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              _buildStatusChip(pr.status),
            ],
          ),
          if (pr.companyName != null) ...[
            const SizedBox(height: 6),
            Text(
              pr.companyName!,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF4F46E5)),
            ),
          ],
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 12),
          _buildMetaRow(Icons.calendar_today_outlined, 'Tanggal', pr.requestDate),
          const SizedBox(height: 6),
          _buildMetaRow(Icons.person_outline, 'Diminta oleh', pr.requestByName ?? '-'),
          if (pr.notes != null && pr.notes!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.sticky_note_2_outlined, size: 16, color: Color(0xFF64748B)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      pr.notes!,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF475569), fontStyle: FontStyle.italic),
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
    return Row(
      children: [
        Icon(icon, size: 15, color: const Color(0xFF64748B)),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
        Text(value, style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'approved':
      case 'vendor_approved':
      case 'po_created':
        color = const Color(0xFF10B981);
        break;
      case 'pending':
      case 'submitted':
        color = const Color(0xFFF59E0B);
        break;
      case 'rejected':
        color = const Color(0xFFEF4444);
        break;
      case 'waiting_bod_approval':
      case 'waiting_comparison':
        color = const Color(0xFF6366F1);
        break;
      default:
        color = const Color(0xFF64748B);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: const [
                      BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            if (!hasPo && pr.status.toLowerCase() == 'vendor_approved')
                              Checkbox(
                                value: _selectedComparisonIds.contains(comp.id),
                                activeColor: const Color(0xFF4F46E5),
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
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Waktu tunggu: ${comp.leadTimeDays} hari',
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                  ),
                                ],
                              ),
                            ),
                            if (hasPo)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFECFDF5),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: const Color(0xFFA7F3D0)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.check_circle_outline, size: 12, color: Color(0xFF059669)),
                                    const SizedBox(width: 4),
                                    Text(
                                      matchedPoNumbers.length == 1
                                          ? 'PO: ${matchedPoNumbers.first}'
                                          : 'POs: ${matchedPoNumbers.join(', ')}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF059669),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
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
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: Color(0xFF1E293B),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      formatWithCurrency(subtotal, 'IDR'),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Color(0xFF0F172A),
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
                                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                    ),
                                    if (item.warehouseName != null)
                                      Text(
                                        'Gudang: ${item.warehouseName}',
                                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Pemasok:',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF64748B)),
                            ),
                            Text(
                              formatWithCurrency(comp.totalAmount, 'IDR'),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4F46E5),
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
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    'Pesanan Pembelian (PO) Dibuat',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
                ...pr.purchaseOrders.map((po) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.receipt_long_outlined, color: Color(0xFF4F46E5), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              po.poNumber,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              po.supplierName,
                              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _downloadAndPrintPdf(
                          context,
                          po.pdfUrl ?? '',
                          po.poNumber,
                        ),
                        icon: const Icon(Icons.download_outlined, size: 14),
                        label: const Text('PDF'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF4F46E5),
                          side: const BorderSide(color: Color(0xFF4F46E5)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
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
                      color: Color(0xFFEF4444),
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
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isGeneratingPos ? null : () => _handleProceedToPO(pr),
                icon: _isGeneratingPos
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.playlist_add_check, size: 18),
                label: Text('Proceed to PO for ${_selectedComparisonIds.length} Supplier(s)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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

      // Invalidate details provider to reload status
      ref.invalidate(purchaseRequestDetailProvider(pr.id));
      ref.invalidate(purchaseRequestsProvider);

      setState(() {
        _selectedComparisonIds.clear();
      });

      if (mounted) {
        // Show success dialog with download buttons
        await showDialog(
          context: context,
          builder: (dialogCtx) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.check_circle_outline, color: Color(0xFF10B981)),
                  SizedBox(width: 8),
                  Text('POs Generated'),
                ],
              ),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Successfully generated Purchase Orders from selected vendors. You can download the PDF documents below:',
                      style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
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
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.receipt_long_outlined, size: 18, color: Color(0xFF4F46E5)),
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
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                  ),
                                ],
                              ),
                            ),
                            if (pdfUrl != null)
                              IconButton(
                                icon: const Icon(Icons.download_rounded, color: Color(0xFF4F46E5), size: 20),
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
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating POs: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
      // Delay showing dialog to allow pending transitions/pops to complete
      await Future.delayed(Duration.zero);
      if (!context.mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dCtx) {
          dialogContext = dCtx;
          return const Center(child: CircularProgressIndicator());
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
          // Direct file saving for desktop
          final dir = await getDownloadsDirectory();
          if (dir != null) {
            final filePath = p.join(dir.path, '$fileName.pdf');
            final file = File(filePath);
            await file.writeAsBytes(response.data!);

            // Open the saved file using default platform app
            try {
              if (Platform.isWindows) {
                await Process.run('explorer.exe', [filePath.replaceAll('/', '\\')]);
              } else if (Platform.isMacOS) {
                await Process.run('open', [filePath]);
              } else if (Platform.isLinux) {
                await Process.run('xdg-open', [filePath]);
              }
            } catch (e) {
              // Ignore failure to open file
            }

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Downloaded PDF to Downloads folder: $fileName.pdf'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          } else {
            throw Exception('Could not find Downloads folder');
          }
        } else {
          // Fallback for Web/Mobile (layoutPdf shows save/preview UI)
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
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _DetailItemRow extends StatelessWidget {
  final PurchaseRequestItem item;
  const _DetailItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F0F0F),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
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
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A), fontSize: 14),
                  ),
                ),
                if (item.costCode != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
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
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Req Qty', style: TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                    const SizedBox(height: 2),
                    Text(
                      '${item.qtyRequested} ${item.uom}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                  ],
                ),
                if (item.approvedQty != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Approved Qty', style: TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(
                        '${item.approvedQty} ${item.uom}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.inventory_2_outlined, size: 14, color: Color(0xFF64748B)),
                const SizedBox(width: 4),
                Text(
                  'Current Stock: ${item.currentStock} ${item.uom}',
                  style: TextStyle(
                    fontSize: 12,
                    color: item.currentStock < item.qtyRequested ? const Color(0xFFF59E0B) : const Color(0xFF64748B),
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
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Spesifikasi: ${item.dtSpec}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF475569), fontStyle: FontStyle.italic),
                ),
              ),
            ],
            if (item.dtNotes != null && item.dtNotes!.trim().isNotEmpty) ...[
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Keterangan: ${item.dtNotes}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F0F0F),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
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
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A), fontSize: 15),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2F6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${comparison.leadTimeDays} days lead time',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
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
                color: Color(0xFF4F46E5),
              ),
            ),
            if (comparison.notes != null && comparison.notes!.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Notes: ${comparison.notes}',
                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Color(0xFF64748B)),
              ),
            ],
            const Divider(height: 24, color: Color(0xFFF1F5F9)),
            const Text(
              'Offered Items:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
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
                        style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
                      ),
                    ),
                    Text(
                      formatWithCurrency(compDetail.offeredUnitPrice, 'IDR'),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
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
