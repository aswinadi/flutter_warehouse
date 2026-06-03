import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/purchase_order_provider.dart';
import '../providers/purchase_order_repository.dart';
import '../../../core/utils/currency_utils.dart';

class POApprovalScreen extends ConsumerStatefulWidget {
  final int poId;
  const POApprovalScreen({super.key, required this.poId});

  @override
  ConsumerState<POApprovalScreen> createState() => _POApprovalScreenState();
}

class _POApprovalScreenState extends ConsumerState<POApprovalScreen> {
  bool _isSubmitting = false;

  Future<void> _approve() async {
    setState(() => _isSubmitting = true);
    try {
      await ref.read(purchaseOrderRepositoryProvider).approvePurchaseOrder(widget.poId);
      ref.invalidate(purchaseOrdersProvider(status: 'submitted'));
      ref.invalidate(purchaseOrderDetailProvider(widget.poId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pesanan Pembelian (PO) Berhasil Disetujui')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyetujui: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _reject() async {
    final reasonController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tolak Pesanan Pembelian'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Silakan berikan alasan penolakan (minimal 5 karakter):'),
              const SizedBox(height: 16),
              TextFormField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: 'Alasan Penolakan',
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan alasan...',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().length < 5) {
                    return 'Alasan harus minimal 5 karakter';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('BATAL'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() == true) {
                Navigator.pop(context, true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('TOLAK'),
          ),
        ],
      ),
    );

    if (result == true && reasonController.text.trim().length >= 5) {
      setState(() => _isSubmitting = true);
      try {
        await ref.read(purchaseOrderRepositoryProvider).rejectPurchaseOrder(
              widget.poId,
              reasonController.text.trim(),
            );
        ref.invalidate(purchaseOrdersProvider(status: 'submitted'));
        ref.invalidate(purchaseOrderDetailProvider(widget.poId));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pesanan Pembelian (PO) Telah Ditolak')),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menolak: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final poAsync = ref.watch(purchaseOrderDetailProvider(widget.poId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        title: poAsync.when(
          data: (po) => Text(po.canApprove ? 'Persetujuan PO' : 'Detail PO'),
          loading: () => const Text('Memuat PO...'),
          error: (_, __) => const Text('Error'),
        ),
        actions: [
          poAsync.when(
            data: (po) => IconButton(
              icon: const Icon(Icons.print),
              onPressed: () {
                context.push('/pdf-preview?title=Pesanan Pembelian ${po.poNumber}&url_path=pdf/purchase-order/${po.id}');
              },
            ),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
      body: poAsync.when(
        data: (po) {
          final canApproveNow = po.status.toLowerCase() == 'submitted' && po.canApprove;
          // Dynamically calculate total amount if not returned by server directly
          final double calculatedTotal = po.items.fold(
            0.0,
            (sum, item) => sum + (item.orderedQty * (item.unitPrice ?? 0.0)),
          );
          final displayTotal = po.totalAmount ?? calculatedTotal;

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
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x140F0F0F),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow('Nomor PO', po.poNumber, isBold: true),
                            _buildInfoRow('Pemasok', po.supplierName),
                            _buildInfoRow('Tanggal Transaksi', po.transactionDate),
                            _buildInfoRow('Tanggal Perkiraan', po.expectedDate),
                            if (po.paymentTerm != null && po.paymentTerm!.isNotEmpty)
                              _buildInfoRow('Syarat Pembayaran', po.paymentTerm!),
                            _buildInfoRow('Status', po.status.toUpperCase()),
                            const Divider(color: Color(0xFFE2E8F0), height: 24),
                            _buildInfoRow(
                              'Jumlah Total',
                              formatWithCurrency(displayTotal, 'IDR'),
                              isBold: true,
                              textColor: const Color(0xFF4F46E5),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Daftar Barang PO',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 8),
                    ...po.items.map((item) {
                      final itemTotal = item.orderedQty * (item.unitPrice ?? 0.0);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0A0F0F0F),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'SKU: ${item.sku}',
                                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                                  ),
                                  Text(
                                    'Qty: ${item.orderedQty} ${item.unit}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0F172A),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(color: Color(0xFFF1F5F9), height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Harga Satuan: ${formatWithCurrency(item.unitPrice ?? 0.0, 'IDR')}',
                                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                                  ),
                                  Text(
                                    'Subtotal: ${formatWithCurrency(itemTotal, 'IDR')}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F172A),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              if (item.detailNotes != null && item.detailNotes!.trim().isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Catatan: ${item.detailNotes}',
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                ),
                              ],
                              if (item.detailSpec != null && item.detailSpec!.trim().isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Spesifikasi: ${item.detailSpec}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF64748B),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
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
                        child: OutlinedButton(
                          onPressed: _isSubmitting ? null : _reject,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFEF4444),
                            side: const BorderSide(color: Color(0xFFEF4444)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('TOLAK'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _approve,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6E56CF), // Notion Purple
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
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
                              : const Text('SETUJUI'),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Gagal memuat detail PO: $err')),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool isBold = false,
    Color? textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
              color: textColor ?? const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
