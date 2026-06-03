import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/payment_request_repository.dart';
import '../../../core/utils/currency_utils.dart';

class PaymentRequestApprovalScreen extends ConsumerStatefulWidget {
  final int prId;
  const PaymentRequestApprovalScreen({super.key, required this.prId});

  @override
  ConsumerState<PaymentRequestApprovalScreen> createState() => _PaymentRequestApprovalScreenState();
}

class _PaymentRequestApprovalScreenState extends ConsumerState<PaymentRequestApprovalScreen> {
  final _notesController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _approve() async {
    setState(() => _isSubmitting = true);
    try {
      await ref.read(paymentRequestRepositoryProvider).approvePaymentRequest(
            widget.prId,
            notes: _notesController.text.isNotEmpty ? _notesController.text : null,
          );
      ref.invalidate(paymentRequestsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment Request Disetujui')));
        context.pop();
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _reject() async {
    final reasonController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tolak Payment Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Silakan berikan alasan penolakan:'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Alasan Penolakan',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('BATAL')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('TOLAK'),
          ),
        ],
      ),
    );

    if (result == true && reasonController.text.isNotEmpty) {
      setState(() => _isSubmitting = true);
      try {
        await ref.read(paymentRequestRepositoryProvider).rejectPaymentRequest(
              widget.prId,
              reasonController.text,
              notes: _notesController.text.isNotEmpty ? _notesController.text : null,
            );
        ref.invalidate(paymentRequestsProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment Request Ditolak')));
          context.pop();
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final prAsync = ref.watch(paymentRequestDetailProvider(widget.prId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        title: const Text('Persetujuan Payment Request'),
        actions: [
          prAsync.when(
            data: (pr) => IconButton(
              icon: const Icon(Icons.print),
              onPressed: () {
                context.push('/pdf-preview?title=Payment Request ${pr.requestNumber}&url_path=pdf/payment-request/${pr.id}');
              },
            ),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
      body: prAsync.when(
        data: (pr) {
          final canApproveNow = pr.status.toLowerCase() == 'pending' && pr.canApprove;

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
                              pr.requestNumber,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow('Pengaju', pr.requestorName),
                            _buildInfoRow('Tanggal Pengajuan', pr.requestDate),
                            _buildInfoRow('Status', pr.status.toUpperCase()),
                            _buildInfoRow('Pemasok', pr.supplierNames ?? '-'),
                            _buildInfoRow('Jatuh Tempo Terdekat', pr.dueDate ?? '-'),
                            const Divider(color: Color(0xFFE2E8F0), height: 24),
                            _buildInfoRow('Total Pengajuan', formatWithCurrency(pr.totalAmount, pr.currency), isBold: true),
                            if (pr.description != null && pr.description!.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text('Deskripsi: ${pr.description}', style: const TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF64748B))),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Invoice Terkait', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...pr.invoices.map((inv) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x140F0F0F),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(inv.invoiceNumber, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                    Text(
                                      inv.paymentStatus.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: inv.paymentStatus == 'paid' ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                                      ),
                                    ),
                                  ],
                                ),
                                 const SizedBox(height: 4),
                                 Text('Pemasok: ${inv.supplierName ?? "-"}', style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B))),
                                 Text('Tanggal: ${inv.invoiceDate} | Jatuh Tempo: ${inv.dueDate ?? "-"}', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                                 const Divider(color: Color(0xFFE2E8F0), height: 16),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text('Pajak: ${formatWithCurrency(inv.taxAmount, pr.currency)}', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                                     Text(
                                       'Jumlah: ${formatWithCurrency(inv.amount, pr.currency)}',
                                       style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                     ),
                                   ],
                                 ),
                              ],
                            ),
                          ),
                        )),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          labelText: 'Catatan Persetujuan/Penolakan (Opsional)',
                          labelStyle: const TextStyle(color: Color(0xFF64748B)),
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
                      const SizedBox(height: 16),
                      Row(
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
                                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text('SETUJUI'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Gagal: $err')),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 14)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
