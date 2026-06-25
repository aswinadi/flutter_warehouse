import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider, Navigator;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/payment_request_repository.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_dialog.dart';

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
          builder: (context) => CupertinoGlassDialog(
            title: const Text('Sukses'),
            content: const Text('Payment Request berhasil disetujui.'),
            actions: [
              CupertinoGlassDialogAction(
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
          builder: (context) => CupertinoGlassDialog(
            title: const Text('Gagal'),
            content: Text('Gagal menyetujui: $e'),
            actions: [
              CupertinoGlassDialogAction(
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
      builder: (context) => CupertinoGlassDialog(
        title: const Text('Tolak Payment Request'),
        content: Container(
          padding: const EdgeInsets.only(top: CupertinoSpacing.s),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Silakan berikan alasan penolakan:'),
              const SizedBox(height: CupertinoSpacing.m),
              CupertinoTextField(
                controller: reasonController,
                placeholder: 'Alasan Penolakan',
                placeholderStyle: context.subhead.copyWith(color: CupertinoColors.placeholderText),
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.separator),
                  borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                ),
                maxLines: 2,
                padding: const EdgeInsets.all(CupertinoSpacing.s),
              ),
            ],
          ),
        ),
        actions: [
          CupertinoGlassDialogAction(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          CupertinoGlassDialogAction(
            isDestructive: true,
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
            builder: (context) => CupertinoGlassDialog(
              title: const Text('Sukses'),
              content: const Text('Payment Request berhasil ditolak.'),
              actions: [
                CupertinoGlassDialogAction(
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
            builder: (context) => CupertinoGlassDialog(
              title: const Text('Gagal'),
              content: Text('Gagal menolak: $e'),
              actions: [
                CupertinoGlassDialogAction(
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
        final labelColor = CupertinoColors.label.resolveFrom(context);
        final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              pr.requestNumber,
                              style: context.callout.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              onPressed: () {
                                context.push('/pdf-preview?title=Payment Request ${pr.requestNumber}&url_path=pdf/payment-request/${pr.id}');
                              },
                              child: const Icon(CupertinoIcons.printer, color: CupertinoColors.activeBlue, size: 20),
                            ),
                          ],
                        ),
                        Divider(color: CupertinoColors.separator.resolveFrom(context), height: CupertinoSpacing.xl, thickness: 0.5),
                        _buildInfoRow('Pengaju', pr.requestorName),
                        _buildInfoRow('Tanggal Pengajuan', pr.requestDate),
                        _buildInfoRow('Status', pr.status.toUpperCase()),
                        _buildInfoRow('Pemasok', pr.supplierNames ?? '-'),
                        _buildInfoRow('Jatuh Tempo Terdekat', pr.dueDate ?? '-'),
                        Divider(color: CupertinoColors.separator.resolveFrom(context), height: CupertinoSpacing.xl, thickness: 0.5),
                        _buildInfoRow('Total Pengajuan', formatWithCurrency(pr.totalAmount, pr.currency), isBold: true),
                        if (pr.description != null && pr.description!.isNotEmpty) ...[
                          const SizedBox(height: CupertinoSpacing.m),
                          Text('Deskripsi:', style: context.footnote.copyWith(fontWeight: FontWeight.bold, color: secondaryLabelColor)),
                          const SizedBox(height: CupertinoSpacing.xs),
                          Text(pr.description!, style: context.body.copyWith(fontStyle: FontStyle.italic)),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: CupertinoSpacing.screenMargin),
                  Text('Invoice Terkait', style: context.headline.copyWith(fontWeight: FontWeight.bold, color: labelColor)),
                  const SizedBox(height: CupertinoSpacing.s),
                  ...pr.invoices.map((inv) => CupertinoGlassContainer(
                        margin: const EdgeInsets.only(bottom: CupertinoSpacing.s),
                        padding: const EdgeInsets.all(CupertinoSpacing.m),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(inv.invoiceNumber, style: context.body.copyWith(fontWeight: FontWeight.bold)),
                                Text(
                                  inv.paymentStatus.toUpperCase(),
                                  style: context.caption2.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: inv.paymentStatus == 'paid' ? CupertinoColors.systemGreen : CupertinoColors.activeOrange,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: CupertinoSpacing.s),
                            _buildInfoRow('Pemasok', inv.supplierName ?? '-'),
                            _buildInfoRow('Tanggal Invoice', inv.invoiceDate),
                            _buildInfoRow('Tipe Invoice', inv.type == 'biaya_invoice' ? 'Invoice Biaya' : 'Faktur Pembelian'),
                            Divider(color: CupertinoColors.separator.resolveFrom(context), height: CupertinoSpacing.l, thickness: 0.5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Pajak: ${formatWithCurrency(inv.taxAmount, pr.currency)}', style: context.caption1.copyWith(color: secondaryLabelColor)),
                                Text(
                                  'Jumlah: ${formatWithCurrency(inv.amount, pr.currency)}',
                                  style: context.body.copyWith(fontWeight: FontWeight.bold),
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
                child: CupertinoGlassContainer(
                  borderRadius: 0,
                  padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoTextField(
                        controller: _notesController,
                        placeholder: 'Catatan Persetujuan/Penolakan (Opsional)',
                        placeholderStyle: context.subhead.copyWith(color: CupertinoColors.placeholderText),
                        decoration: BoxDecoration(
                          border: Border.all(color: CupertinoColors.separator),
                          borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                        ),
                        maxLines: 2,
                        padding: const EdgeInsets.all(CupertinoSpacing.s),
                      ),
                      const SizedBox(height: CupertinoSpacing.m),
                      Row(
                        children: [
                          Expanded(
                            child: CupertinoButton(
                              padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.m),
                              color: CupertinoColors.systemRed,
                              borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                              minimumSize: Size.zero,
                              onPressed: _isSubmitting ? null : _reject,
                              child: const Text('TOLAK', style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: CupertinoSpacing.m),
                          Expanded(
                            flex: 2,
                            child: CupertinoButton(
                              padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.m),
                              color: CupertinoColors.activeBlue,
                              borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                              minimumSize: Size.zero,
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
      padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.footnote.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context))),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.footnote.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
