import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors, Divider, Icons, Navigator, showDialog;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/payment_request_repository.dart';
import '../models/payment_request.dart';
import '../../../core/utils/currency_utils.dart';

class PaymentRequestDetailScreen extends ConsumerStatefulWidget {
  final int prId;
  final bool isEmbedded;

  const PaymentRequestDetailScreen({
    super.key,
    required this.prId,
    this.isEmbedded = false,
  });

  @override
  ConsumerState<PaymentRequestDetailScreen> createState() => _PaymentRequestDetailScreenState();
}

class _PaymentRequestDetailScreenState extends ConsumerState<PaymentRequestDetailScreen> {
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
      ref.invalidate(paymentRequestDetailProvider(widget.prId));
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Sukses'),
            content: const Text('Payment Request berhasil disetujui.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  if (!widget.isEmbedded) {
                    context.pop();
                  }
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
            content: Text('Gagal menyetujui: $e'),
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

  Future<void> _reject() async {
    final reasonController = TextEditingController();
    final result = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Tolak Payment Request'),
        content: Container(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Silakan berikan alasan penolakan:'),
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: reasonController,
                placeholder: 'Alasan Penolakan',
                placeholderStyle: const TextStyle(color: CupertinoColors.placeholderText, fontSize: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.separator),
                  borderRadius: BorderRadius.circular(6),
                ),
                maxLines: 2,
                padding: const EdgeInsets.all(8),
              ),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context, false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Tolak'),
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
        ref.invalidate(paymentRequestDetailProvider(widget.prId));
        if (mounted) {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Sukses'),
              content: const Text('Payment Request berhasil ditolak.'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                    if (!widget.isEmbedded) {
                      context.pop();
                    }
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
              content: Text('Gagal menolak: $e'),
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
  }

  @override
  Widget build(BuildContext context) {
    final prAsync = ref.watch(paymentRequestDetailProvider(widget.prId));

    final content = prAsync.when(
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
                      color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              pr.requestNumber,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              minSize: 0,
                              onPressed: () {
                                context.push('/pdf-preview?title=Payment Request ${pr.requestNumber}&url_path=pdf/payment-request/${pr.id}');
                              },
                              child: const Icon(CupertinoIcons.printer, color: Color(0xFF6E56CF), size: 20),
                            ),
                          ],
                        ),
                        const Divider(color: CupertinoColors.separator, height: 20, thickness: 0.5),
                        _buildInfoRow('Pengaju', pr.requestorName),
                        _buildInfoRow('Tanggal Pengajuan', pr.requestDate),
                        _buildInfoRow('Status', pr.status.toUpperCase()),
                        _buildInfoRow('Pemasok', pr.supplierNames ?? '-'),
                        _buildInfoRow('Jatuh Tempo Terdekat', pr.dueDate ?? '-'),
                        const Divider(color: CupertinoColors.separator, height: 20, thickness: 0.5),
                        _buildInfoRow('Total Pengajuan', formatWithCurrency(pr.totalAmount, pr.currency), isBold: true),
                        if (pr.description != null && pr.description!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          const Text('Deskripsi:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: CupertinoColors.secondaryLabel)),
                          const SizedBox(height: 4),
                          Text(pr.description!, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Invoice Terkait', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...pr.invoices.map((inv) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(inv.invoiceNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                Text(
                                  inv.paymentStatus.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: inv.paymentStatus == 'paid' ? CupertinoColors.systemGreen : CupertinoColors.activeOrange,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            _buildInfoRow('Pemasok', inv.supplierName ?? '-'),
                            _buildInfoRow('Tanggal Invoice', inv.invoiceDate),
                            _buildInfoRow('Tipe Invoice', inv.type == 'biaya_invoice' ? 'Invoice Biaya' : 'Faktur Pembelian'),
                            const Divider(color: CupertinoColors.separator, height: 16, thickness: 0.5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Pajak: ${formatWithCurrency(inv.taxAmount, pr.currency)}', style: const TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel)),
                                Text(
                                  'Jumlah: ${formatWithCurrency(inv.amount, pr.currency)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            if (canApproveNow)
              SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                    border: const Border(top: BorderSide(color: CupertinoColors.separator, width: 0.5)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoTextField(
                        controller: _notesController,
                        placeholder: 'Catatan Persetujuan/Penolakan (Opsional)',
                        placeholderStyle: const TextStyle(color: CupertinoColors.placeholderText, fontSize: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: CupertinoColors.separator),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        maxLines: 2,
                        padding: const EdgeInsets.all(8),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: CupertinoButton(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              color: CupertinoColors.systemRed,
                              borderRadius: BorderRadius.circular(8),
                              minSize: 0,
                              onPressed: _isSubmitting ? null : _reject,
                              child: const Text('TOLAK', style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: CupertinoButton(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              color: const Color(0xFF6E56CF),
                              borderRadius: BorderRadius.circular(8),
                              minSize: 0,
                              onPressed: _isSubmitting ? null : _approve,
                              child: _isSubmitting
                                  ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                                  : const Text('SETUJUI', style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (err, _) => Center(child: Text('Gagal: $err')),
    );

    if (widget.isEmbedded) {
      return content;
    }

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        middle: Text(
          'Detail Permintaan Pembayaran',
          style: TextStyle(color: CupertinoColors.label.resolveFrom(context)),
        ),
        previousPageTitle: 'Kembali',
      ),
      child: SafeArea(child: content),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: CupertinoColors.secondaryLabel, fontSize: 13)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
