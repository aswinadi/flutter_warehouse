import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider, Colors;
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
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Sukses'),
            content: const Text('Payment Request Disetujui'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context); // dismiss dialog
                  if (mounted) context.pop(); // pop screen
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
        content: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Silakan berikan alasan penolakan:'),
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: reasonController,
                placeholder: 'Alasan Penolakan',
                maxLines: 3,
                placeholderStyle: TextStyle(
                  color: CupertinoColors.placeholderText.resolveFrom(context),
                  fontSize: 13,
                ),
                style: TextStyle(
                  color: CupertinoColors.label.resolveFrom(context),
                  fontSize: 13,
                ),
                decoration: BoxDecoration(
                  color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                  border: Border.all(
                    color: CupertinoColors.separator.resolveFrom(context),
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
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
        if (mounted) {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Sukses'),
              content: const Text('Payment Request Ditolak'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context); // dismiss dialog
                    if (mounted) context.pop(); // pop screen
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
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);
    final bgColor = CupertinoColors.systemGroupedBackground.resolveFrom(context);
    final secondaryBgColor = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);

    return CupertinoPageScaffold(
      backgroundColor: bgColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        middle: Text(
          'Persetujuan Payment Request',
          style: TextStyle(color: labelColor),
        ),
        trailing: prAsync.when(
          data: (pr) => CupertinoButton(
            padding: EdgeInsets.zero,
            minSize: 32,
            child: const Icon(CupertinoIcons.printer, size: 22),
            onPressed: () {
              context.push('/pdf-preview?title=Payment Request ${pr.requestNumber}&url_path=pdf/payment-request/${pr.id}');
            },
          ),
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ),
      child: SafeArea(
        child: prAsync.when(
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
                          color: secondaryBgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pr.requestNumber,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: labelColor),
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow('Pengaju', pr.requestorName),
                              _buildInfoRow('Tanggal Pengajuan', pr.requestDate),
                              _buildInfoRow('Status', pr.status.toUpperCase()),
                              _buildInfoRow('Pemasok', pr.supplierNames ?? '-'),
                              _buildInfoRow('Jatuh Tempo Terdekat', pr.dueDate ?? '-'),
                              const Divider(height: 24),
                              _buildInfoRow('Total Pengajuan', formatWithCurrency(pr.totalAmount, pr.currency), isBold: true),
                              if (pr.description != null && pr.description!.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Text(
                                  'Deskripsi: ${pr.description}',
                                  style: TextStyle(fontStyle: FontStyle.italic, color: secondaryLabelColor),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Invoice Terkait',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: labelColor),
                      ),
                      const SizedBox(height: 8),
                      ...pr.invoices.map((inv) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: secondaryBgColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        inv.invoiceNumber,
                                        style: TextStyle(fontWeight: FontWeight.bold, color: labelColor),
                                      ),
                                      Text(
                                        inv.paymentStatus.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: inv.paymentStatus == 'paid'
                                              ? CupertinoColors.systemGreen.resolveFrom(context)
                                              : CupertinoColors.systemOrange.resolveFrom(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Pemasok: ${inv.supplierName ?? "-"}',
                                    style: TextStyle(fontSize: 13, color: labelColor),
                                  ),
                                  Text(
                                    'Tanggal: ${inv.invoiceDate} | Jatuh Tempo: ${inv.dueDate ?? "-"}',
                                    style: TextStyle(fontSize: 13, color: secondaryLabelColor),
                                  ),
                                  const Divider(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Pajak: ${formatWithCurrency(inv.taxAmount, pr.currency)}',
                                        style: TextStyle(fontSize: 13, color: secondaryLabelColor),
                                      ),
                                      Text(
                                        'Jumlah: ${formatWithCurrency(inv.amount, pr.currency)}',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: labelColor),
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
                      color: CupertinoColors.systemBackground.resolveFrom(context),
                      border: Border(
                        top: BorderSide(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CupertinoTextField(
                          controller: _notesController,
                          placeholder: 'Catatan Persetujuan/Penolakan (Opsional)',
                          placeholderStyle: TextStyle(
                            color: CupertinoColors.placeholderText.resolveFrom(context),
                            fontSize: 14,
                          ),
                          style: TextStyle(
                            color: labelColor,
                            fontSize: 14,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                            border: Border.all(
                              color: CupertinoColors.separator.resolveFrom(context),
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: _isSubmitting ? null : _reject,
                                child: Container(
                                  height: 48,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: CupertinoColors.destructiveRed),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'TOLAK',
                                    style: TextStyle(
                                      color: CupertinoColors.destructiveRed,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: CupertinoButton(
                                color: const Color(0xFF6E56CF),
                                padding: EdgeInsets.zero,
                                onPressed: _isSubmitting ? null : _approve,
                                child: Container(
                                  height: 48,
                                  alignment: Alignment.center,
                                  child: _isSubmitting
                                      ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                                      : const Text(
                                          'SETUJUI',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: CupertinoColors.white,
                                          ),
                                        ),
                                ),
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
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (err, _) => Center(
            child: Text(
              'Gagal: $err',
              style: TextStyle(color: secondaryLabelColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: secondaryLabelColor, fontSize: 14)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
                color: labelColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
