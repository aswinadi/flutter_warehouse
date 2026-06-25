import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/invoice_biaya_repository.dart';
import '../../../core/utils/currency_utils.dart';
import '../../payment_request/providers/payment_request_repository.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';
import '../../../core/widgets/cupertino_glass_dialog.dart';

class InvoiceBiayaDetailScreen extends ConsumerStatefulWidget {
  final int invoiceId;
  final bool isEmbedded;

  const InvoiceBiayaDetailScreen({
    super.key,
    required this.invoiceId,
    this.isEmbedded = false,
  });

  @override
  ConsumerState<InvoiceBiayaDetailScreen> createState() => _InvoiceBiayaDetailScreenState();
}

class _InvoiceBiayaDetailScreenState extends ConsumerState<InvoiceBiayaDetailScreen> {
  bool _isSubmitting = false;

  Future<void> _markPending() async {
    setState(() => _isSubmitting = true);
    try {
      await ref.read(invoiceBiayaRepositoryProvider).markPending(widget.invoiceId);
      ref.invalidate(invoiceBiayasProvider);
      ref.invalidate(invoiceBiayaDetailProvider(widget.invoiceId));
      if (mounted) {
        CupertinoGlassToast.showSuccess(context, 'Status Invoice Biaya berhasil diubah menjadi PENDING.');
        if (!widget.isEmbedded) {
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted) context.pop();
          });
        }
      }
    } catch (e) {
      if (mounted) {
        CupertinoGlassToast.showError(context, 'Gagal mengubah status: $e');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _deleteInvoice() async {
    final confirm = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoGlassDialog(
        title: const Text('Hapus Invoice Biaya'),
        content: const Text('Apakah Anda yakin ingin menghapus invoice biaya ini? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          CupertinoGlassDialogAction(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context, false),
          ),
          CupertinoGlassDialogAction(
            isDestructive: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isSubmitting = true);
      try {
        await ref.read(invoiceBiayaRepositoryProvider).deleteInvoiceBiaya(widget.invoiceId);
        ref.invalidate(invoiceBiayasProvider);
        if (mounted) {
          CupertinoGlassToast.showSuccess(context, 'Invoice Biaya berhasil dihapus.');
          if (!widget.isEmbedded) {
            Future.delayed(const Duration(milliseconds: 1500), () {
              if (mounted) context.pop();
            });
          }
        }
      } catch (e) {
        if (mounted) {
          CupertinoGlassToast.showError(context, 'Gagal menghapus invoice: $e');
        }
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _submitPaymentRequest() async {
    DateTime requestDate = DateTime.now();
    final descriptionController = TextEditingController();

    final success = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoGlassDialog(
        title: const Text('Submit Payment Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Membuat permintaan pembayaran untuk Invoice Biaya ini.'),
            const SizedBox(height: CupertinoSpacing.m),
            CupertinoTextField(
              controller: descriptionController,
              placeholder: 'Keterangan/Alasan Pembayaran',
              placeholderStyle: context.subhead.copyWith(color: CupertinoColors.placeholderText.resolveFrom(context)),
              decoration: BoxDecoration(
                border: Border.all(color: CupertinoColors.separator.resolveFrom(context)),
                borderRadius: BorderRadius.circular(6),
              ),
              maxLines: 2,
              padding: const EdgeInsets.all(CupertinoSpacing.s),
            ),
          ],
        ),
        actions: [
          CupertinoGlassDialogAction(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context, false),
          ),
          CupertinoGlassDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Submit'),
          ),
        ],
      ),
    );

    if (success == true) {
      setState(() => _isSubmitting = true);
      try {
        final prRepository = ref.read(paymentRequestRepositoryProvider);
        await prRepository.dio.post('wh/payment-requests', data: {
          'invoice_type': 'biaya',
          'invoice_ids': [widget.invoiceId],
          'request_date': requestDate.toIso8601String().substring(0, 10),
          'description': descriptionController.text.isNotEmpty ? descriptionController.text : 'Payment Request Invoice Biaya',
        });

        ref.invalidate(invoiceBiayasProvider);
        ref.invalidate(invoiceBiayaDetailProvider(widget.invoiceId));

        if (mounted) {
          CupertinoGlassToast.showSuccess(context, 'Permintaan Pembayaran berhasil dibuat.');
          if (!widget.isEmbedded) {
            Future.delayed(const Duration(milliseconds: 1500), () {
              if (mounted) context.pop();
            });
          }
        }
      } catch (e) {
        if (mounted) {
          CupertinoGlassToast.showError(context, 'Gagal membuat permintaan: $e');
        }
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(invoiceBiayaDetailProvider(widget.invoiceId));

    final content = detailAsync.when(
      data: (invoice) {
        Color statusColor;
        switch (invoice.status.toLowerCase()) {
          case 'draft':
            statusColor = CupertinoColors.systemGrey;
            break;
          case 'pending':
            statusColor = CupertinoColors.activeOrange;
            break;
          case 'submitted':
            statusColor = CupertinoColors.activeBlue;
            break;
          case 'paid':
            statusColor = CupertinoColors.systemGreen;
            break;
          case 'cancelled':
            statusColor = CupertinoColors.systemRed;
            break;
          default:
            statusColor = CupertinoColors.systemGrey;
        }

        final isDraft = invoice.status == 'draft';
        final isPending = invoice.status == 'pending';

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                children: [
                  CupertinoGlassContainer(
                    borderRadius: CupertinoSpacing.cardRadius + 2,
                    padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              invoice.invoiceNumber,
                              style: context.title3.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.halfScreenMargin, vertical: CupertinoSpacing.xs),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: statusColor, width: 0.5),
                              ),
                              child: Text(
                                invoice.status.toUpperCase(),
                                style: context.caption2.copyWith(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: CupertinoSpacing.m),
                        _buildInfoRow('Pemasok', invoice.supplierName ?? '-'),
                        _buildInfoRow('Kode Pemasok', invoice.supplierCode ?? '-'),
                        _buildInfoRow('No. Invoice Vendor', invoice.vendorInvoiceNumber ?? '-'),
                        _buildInfoRow('Tanggal Invoice', _formatDate(invoice.invoiceDate)),
                        _buildInfoRow('Tanggal Jatuh Tempo', _formatDate(invoice.dueDate)),
                        const Divider(color: CupertinoColors.separator, height: CupertinoSpacing.xxl, thickness: 0.5),
                        _buildInfoRow('Subtotal', formatWithCurrency(invoice.amount, invoice.currency)),
                        _buildInfoRow('Pajak', formatWithCurrency(invoice.taxAmount, invoice.currency)),
                        _buildInfoRow('Total Tagihan', formatWithCurrency(invoice.totalAmount, invoice.currency), isBold: true),
                        if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
                          const SizedBox(height: CupertinoSpacing.m),
                          Text('Catatan:', style: context.footnote.copyWith(fontWeight: FontWeight.bold, color: CupertinoColors.secondaryLabel.resolveFrom(context))),
                          const SizedBox(height: CupertinoSpacing.xs),
                          Text(invoice.notes!, style: context.subhead.copyWith(fontStyle: FontStyle.italic)),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: CupertinoSpacing.screenMargin),
                  Text(
                    'Lampiran Dokumen',
                    style: context.callout.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: CupertinoSpacing.s),
                  if (invoice.media.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.screenMargin),
                        child: Text(
                          'Tidak ada lampiran dokumen.',
                          style: context.subhead.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                        ),
                      ),
                    )
                  else
                    ...invoice.media.map((file) => CupertinoGlassContainer(
                          borderRadius: CupertinoSpacing.buttonRadius,
                          margin: const EdgeInsets.only(bottom: CupertinoSpacing.s),
                          padding: EdgeInsets.zero,
                          child: CupertinoButton(
                            padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.m, vertical: CupertinoSpacing.s + 2),
                            onPressed: () async {
                              final url = Uri.parse(file.originalUrl);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url, mode: LaunchMode.externalApplication);
                              }
                            },
                            child: Row(
                              children: [
                                const Icon(CupertinoIcons.doc_text, color: CupertinoColors.activeBlue, size: 20),
                                const SizedBox(width: CupertinoSpacing.m),
                                Expanded(
                                  child: Text(
                                    file.fileName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.subhead.copyWith(
                                      color: CupertinoColors.label.resolveFrom(context),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const Icon(CupertinoIcons.arrow_down_to_line, color: CupertinoColors.secondaryLabel, size: 16),
                              ],
                            ),
                          ),
                        )),
                ],
              ),
            ),
            if (isDraft || isPending)
              SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                  decoration: BoxDecoration(
                    color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                    border: const Border(top: BorderSide(color: CupertinoColors.separator, width: 0.5)),
                  ),
                  child: Row(
                    children: [
                      if (isDraft) ...[
                        Expanded(
                          child: CupertinoButton(
                            padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.m),
                            color: CupertinoColors.systemRed,
                            borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                            minimumSize: Size.zero,
                            onPressed: _isSubmitting ? null : _deleteInvoice,
                            child: const Text('Hapus', style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: CupertinoSpacing.m),
                        Expanded(
                          child: CupertinoButton(
                            padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.m),
                            color: CupertinoColors.systemGrey,
                            borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                            minimumSize: Size.zero,
                            onPressed: _isSubmitting
                                ? null
                                : () {
                                    context.push('/invoice-biaya/${invoice.id}/edit');
                                  },
                            child: const Text('Edit', style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold)),
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
                            onPressed: _isSubmitting ? null : _markPending,
                            child: _isSubmitting
                                ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                                : const Text('Mark Pending', style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                      if (isPending) ...[
                        Expanded(
                          child: CupertinoButton(
                            padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.m),
                            color: CupertinoColors.activeBlue,
                            borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                            minimumSize: Size.zero,
                            onPressed: _isSubmitting ? null : _submitPaymentRequest,
                            child: _isSubmitting
                                ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                                : const Text('Submit Payment Request', style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (err, _) => Center(child: Text('Gagal memuat detail: $err')),
    );

    if (widget.isEmbedded) {
      return content;
    }

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        middle: Text(
          'Detail Invoice Biaya',
          style: context.headline.copyWith(color: CupertinoColors.label.resolveFrom(context)),
        ),
        previousPageTitle: 'Kembali',
      ),
      child: SafeArea(child: content),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.xs + 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.footnote.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: context.subhead.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final parsed = DateTime.parse(dateStr);
      return '${parsed.day.toString().padLeft(2, '0')}-${parsed.month.toString().padLeft(2, '0')}-${parsed.year}';
    } catch (e) {
      if (dateStr.length > 10) {
        return dateStr.substring(0, 10);
      }
      return dateStr;
    }
  }
}
