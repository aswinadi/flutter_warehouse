import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/purchase_request_detail_provider.dart';
import '../providers/purchase_request_provider.dart';
import '../../../core/utils/currency_utils.dart';

class PRVendorApprovalScreen extends ConsumerStatefulWidget {
  final int prId;
  const PRVendorApprovalScreen({super.key, required this.prId});

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
    // Verify that a selection is made for all items
    final detailProvider = ref.read(purchaseRequestDetailProvider(widget.prId));
    final pr = detailProvider.valueOrNull;

    if (pr == null) return;

    if (_selections.length < pr.details.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih vendor untuk semua item barang')),
      );
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilihan vendor berhasil disetujui')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final prAsync = ref.watch(purchaseRequestDetailProvider(widget.prId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        title: Text(prAsync.valueOrNull?.status.toLowerCase() == 'waiting_bod_approval' && (prAsync.valueOrNull?.canApprove ?? false) ? 'Pemilihan Vendor PR' : 'Detail PR'),
      ),
      body: prAsync.when(
        data: (pr) {
          _initializeSelections(pr.details, pr.comparisons);
          final canApproveNow = pr.status.toLowerCase() == 'waiting_bod_approval' && pr.canApprove;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
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
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pr.code,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                            const SizedBox(height: 8),
                            Text('Perusahaan: ${pr.companyName ?? "-"}', style: const TextStyle(color: Color(0xFF1E293B))),
                            Text('Tanggal: ${pr.requestDate}', style: const TextStyle(color: Color(0xFF64748B))),
                            Text('Catatan: ${pr.notes ?? "-"}', style: const TextStyle(color: Color(0xFF64748B), fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Item & Perbandingan Vendor', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...pr.details.map((detail) {
                      // Find comparisons that offer this item
                      final itemOptions = pr.comparisons.where((comp) {
                        return comp.details.any((cd) => cd.purchaseRequestDetailId == detail.id);
                      }).toList();

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detail.itemName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
                              ),
                              const SizedBox(height: 2),
                              Text('SKU: ${detail.itemCode} | Qty: ${detail.qtyRequested} ${detail.uom}',
                                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                              const Divider(color: Color(0xFFE2E8F0), height: 24),
                              if (itemOptions.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Text('Tidak ada perbandingan vendor untuk item ini',
                                      style: TextStyle(color: Color(0xFFEF4444), fontStyle: FontStyle.italic)),
                                )
                              else
                                ...itemOptions.map((comp) {
                                  final compDetail = comp.details.firstWhere((cd) => cd.purchaseRequestDetailId == detail.id);

                                  return RadioListTile<int>(
                                    value: comp.id,
                                    groupValue: _selections[detail.id],
                                    activeColor: const Color(0xFF6E56CF), // Notion Purple
                                    onChanged: canApproveNow
                                        ? (val) {
                                            if (val != null) {
                                              setState(() => _selections[detail.id] = val);
                                            }
                                          }
                                        : null,
                                    title: Text(comp.supplierName, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
                                    subtitle: Text(
                                        'Harga: ${formatWithCurrency(compDetail.offeredUnitPrice, 'IDR')} | Waktu Tunggu: ${comp.leadTimeDays} hari\nCatatan: ${comp.notes ?? "-"}',
                                        style: const TextStyle(color: Color(0xFF64748B))),
                                    isThreeLine: true,
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
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6E56CF), // Notion Purple
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text('KIRIM PILIHAN VENDOR'),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
