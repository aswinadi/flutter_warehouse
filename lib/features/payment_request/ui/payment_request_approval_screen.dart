import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider, Colors;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/payment_request_repository.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_dialog.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';

class PaymentRequestApprovalScreen extends ConsumerStatefulWidget {
  final int prId;
  final bool isEmbedded;
  const PaymentRequestApprovalScreen({super.key, required this.prId, this.isEmbedded = false});

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
          builder: (context) => CupertinoGlassDialog(
            title: const Text('Sukses'),
            content: const Text('Payment Request Disetujui'),
            actions: [
              CupertinoGlassDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context); // dismiss dialog
                  if (!widget.isEmbedded && mounted) context.pop(); // pop screen
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
        content: Padding(
          padding: const EdgeInsets.only(top: CupertinoSpacing.m),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Silakan berikan alasan penolakan:'),
              const SizedBox(height: CupertinoSpacing.m),
              CupertinoTextField(
                controller: reasonController,
                placeholder: 'Alasan Penolakan',
                maxLines: 3,
                placeholderStyle: context.footnote.copyWith(
                  color: CupertinoColors.placeholderText.resolveFrom(context),
                ),
                style: context.footnote.copyWith(
                  color: CupertinoColors.label.resolveFrom(context),
                ),
                decoration: BoxDecoration(
                  color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                  border: Border.all(
                    color: CupertinoColors.separator.resolveFrom(context),
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                ),
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
        if (mounted) {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoGlassDialog(
              title: const Text('Sukses'),
              content: const Text('Payment Request Ditolak'),
              actions: [
                CupertinoGlassDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context); // dismiss dialog
                    if (!widget.isEmbedded && mounted) context.pop(); // pop screen
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
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);
    final bgColor = CupertinoColors.systemGroupedBackground.resolveFrom(context);

    return CupertinoPageScaffold(
      backgroundColor: bgColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        automaticallyImplyLeading: !widget.isEmbedded,
        middle: Text(
          'Persetujuan Payment Request',
          style: TextStyle(color: labelColor),
        ),
        trailing: prAsync.when(
          data: (pr) => CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: const Size.square(32),
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
                    padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                    children: [
                      CupertinoGlassContainer(
                        padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pr.requestNumber,
                              style: context.title3.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                            ),
                            const SizedBox(height: CupertinoSpacing.s),
                            _buildInfoRow('Pengaju', pr.requestorName),
                            _buildInfoRow('Tanggal Pengajuan', pr.requestDate),
                            _buildInfoRow('Status', pr.status.toUpperCase()),
                            _buildInfoRow('Pemasok', pr.supplierNames ?? '-'),
                            _buildInfoRow('Jatuh Tempo Terdekat', pr.dueDate ?? '-'),
                            const Divider(height: CupertinoSpacing.xxl),
                            _buildInfoRow('Total Pengajuan', formatWithCurrency(pr.totalAmount, pr.currency), isBold: true),
                            if (pr.description != null && pr.description!.isNotEmpty) ...[
                              const SizedBox(height: CupertinoSpacing.m),
                              Text(
                                'Deskripsi: ${pr.description}',
                                style: context.subhead.copyWith(fontStyle: FontStyle.italic, color: secondaryLabelColor),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: CupertinoSpacing.screenMargin),
                      Text(
                        'Invoice Terkait',
                        style: context.headline.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                      ),
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
                                    Text(
                                      inv.invoiceNumber,
                                      style: context.body.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                                    ),
                                    Text(
                                      inv.paymentStatus.toUpperCase(),
                                      style: context.caption1.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: inv.paymentStatus == 'paid'
                                            ? CupertinoColors.systemGreen.resolveFrom(context)
                                            : CupertinoColors.systemOrange.resolveFrom(context),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: CupertinoSpacing.xs),
                                Text(
                                  'Pemasok: ${inv.supplierName ?? "-"}',
                                  style: context.footnote.copyWith(color: labelColor),
                                ),
                                Text(
                                  'Tanggal: ${inv.invoiceDate} | Jatuh Tempo: ${inv.dueDate ?? "-"}',
                                  style: context.footnote.copyWith(color: secondaryLabelColor),
                                ),
                                const Divider(height: CupertinoSpacing.screenMargin),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Pajak: ${formatWithCurrency(inv.taxAmount, pr.currency)}',
                                      style: context.footnote.copyWith(color: secondaryLabelColor),
                                    ),
                                    Text(
                                      'Jumlah: ${formatWithCurrency(inv.amount, pr.currency)}',
                                      style: context.body.copyWith(fontWeight: FontWeight.bold, color: labelColor),
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
                  CupertinoGlassContainer(
                    borderRadius: 0, // bottom bar flush
                    padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CupertinoTextField(
                          controller: _notesController,
                          placeholder: 'Catatan Persetujuan/Penolakan (Opsional)',
                          placeholderStyle: context.subhead.copyWith(
                            color: CupertinoColors.placeholderText.resolveFrom(context),
                          ),
                          style: context.subhead.copyWith(
                            color: labelColor,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: CupertinoSpacing.m,
                            vertical: CupertinoSpacing.m,
                          ),
                          decoration: BoxDecoration(
                            color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                            border: Border.all(
                              color: CupertinoColors.separator.resolveFrom(context),
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(CupertinoSpacing.cardRadius),
                          ),
                        ),
                        const SizedBox(height: CupertinoSpacing.screenMargin),
                        Row(
                          children: [
                            Expanded(
                              child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: _isSubmitting ? null : _reject,
                                child: Container(
                                  height: CupertinoSpacing.primaryButtonHeight,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: CupertinoColors.destructiveRed),
                                    borderRadius: BorderRadius.circular(CupertinoSpacing.cardRadius),
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
                            const SizedBox(width: CupertinoSpacing.screenMargin),
                            Expanded(
                              flex: 2,
                              child: CupertinoButton(
                                color: const Color(0xFF6E56CF),
                                padding: EdgeInsets.zero,
                                onPressed: _isSubmitting ? null : _approve,
                                child: Container(
                                  height: CupertinoSpacing.primaryButtonHeight,
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
      padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.subhead.copyWith(color: secondaryLabelColor)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.subhead.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: labelColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
