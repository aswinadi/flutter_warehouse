import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors, Divider, Icons, Navigator, showDatePicker, showDialog, Theme;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/invoice_biaya.dart';
import '../providers/invoice_biaya_repository.dart';
import '../../../core/utils/currency_utils.dart';
import '../../payment_request/providers/payment_request_repository.dart';

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
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Sukses'),
            content: const Text('Status Invoice Biaya berhasil diubah menjadi PENDING.'),
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
            content: Text('Gagal mengubah status: $e'),
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

  Future<void> _deleteInvoice() async {
    final confirm = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Hapus Invoice Biaya'),
        content: const Text('Apakah Anda yakin ingin menghapus invoice biaya ini? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context, false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
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
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Sukses'),
              content: const Text('Invoice Biaya berhasil dihapus.'),
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
              content: Text('Gagal menghapus invoice: $e'),
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

  Future<void> _submitPaymentRequest() async {
    DateTime requestDate = DateTime.now();
    final descriptionController = TextEditingController();

    final success = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Submit Payment Request'),
        content: Container(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Membuat permintaan pembayaran untuk Invoice Biaya ini.'),
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: descriptionController,
                placeholder: 'Keterangan/Alasan Pembayaran',
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
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Sukses'),
              content: const Text('Permintaan Pembayaran berhasil dibuat.'),
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
              content: Text('Gagal membuat permintaan: $e'),
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
                              invoice.invoiceNumber,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: statusColor, width: 0.5),
                              ),
                              child: Text(
                                invoice.status.toUpperCase(),
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow('Pemasok', invoice.supplierName ?? '-'),
                        _buildInfoRow('Kode Pemasok', invoice.supplierCode ?? '-'),
                        _buildInfoRow('No. Invoice Vendor', invoice.vendorInvoiceNumber ?? '-'),
                        _buildInfoRow('Tanggal Invoice', _formatDate(invoice.invoiceDate)),
                        _buildInfoRow('Tanggal Jatuh Tempo', _formatDate(invoice.dueDate)),
                        const Divider(color: CupertinoColors.separator, height: 24, thickness: 0.5),
                        _buildInfoRow('Subtotal', formatWithCurrency(invoice.amount, invoice.currency)),
                        _buildInfoRow('Pajak', formatWithCurrency(invoice.taxAmount, invoice.currency)),
                        _buildInfoRow('Total Tagihan', formatWithCurrency(invoice.totalAmount, invoice.currency), isBold: true),
                        if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          const Text('Catatan:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: CupertinoColors.secondaryLabel)),
                          const SizedBox(height: 4),
                          Text(invoice.notes!, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Lampiran Dokumen',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (invoice.media.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Tidak ada lampiran dokumen.',
                          style: TextStyle(color: CupertinoColors.secondaryLabel, fontSize: 14),
                        ),
                      ),
                    )
                  else
                    ...invoice.media.map((file) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
                          ),
                          child: CupertinoButton(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            onPressed: () async {
                              final url = Uri.parse(file.originalUrl);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url, mode: LaunchMode.externalApplication);
                              }
                            },
                            child: Row(
                              children: [
                                const Icon(CupertinoIcons.doc_text, color: Color(0xFF6E56CF), size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    file.fileName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: CupertinoColors.label.resolveFrom(context),
                                      fontSize: 14,
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
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                    border: const Border(top: BorderSide(color: CupertinoColors.separator, width: 0.5)),
                  ),
                  child: Row(
                    children: [
                      if (isDraft) ...[
                        Expanded(
                          child: CupertinoButton(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            color: CupertinoColors.systemRed,
                            borderRadius: BorderRadius.circular(8),
                            minSize: 0,
                            onPressed: _isSubmitting ? null : _deleteInvoice,
                            child: const Text('Hapus', style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CupertinoButton(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            color: CupertinoColors.systemGrey,
                            borderRadius: BorderRadius.circular(8),
                            minSize: 0,
                            onPressed: _isSubmitting
                                ? null
                                : () {
                                    context.push('/invoice-biaya/${invoice.id}/edit');
                                  },
                            child: const Text('Edit', style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold)),
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
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            color: const Color(0xFF6E56CF),
                            borderRadius: BorderRadius.circular(8),
                            minSize: 0,
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
          style: TextStyle(color: CupertinoColors.label.resolveFrom(context)),
        ),
        previousPageTitle: 'Kembali',
      ),
      child: SafeArea(child: content),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: CupertinoColors.secondaryLabel, fontSize: 13),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
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
