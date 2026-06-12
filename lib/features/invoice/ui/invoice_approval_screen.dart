import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider, Colors, InteractiveViewer;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/invoice_repository.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../core/config/app_config.dart';

class InvoiceApprovalScreen extends ConsumerStatefulWidget {
  final int invoiceId;
  final bool isEmbedded;
  const InvoiceApprovalScreen({super.key, required this.invoiceId, this.isEmbedded = false});

  @override
  ConsumerState<InvoiceApprovalScreen> createState() => _InvoiceApprovalScreenState();
}

class _InvoiceApprovalScreenState extends ConsumerState<InvoiceApprovalScreen> {
  bool _isSubmitting = false;
  late TextEditingController _vendorInvoiceNoController;
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _vendorInvoiceNoController = TextEditingController();
  }

  @override
  void dispose() {
    _vendorInvoiceNoController.dispose();
    super.dispose();
  }

  String _getMediaUrl(String originalUrl) {
    if (originalUrl.startsWith('http')) {
      final uri = Uri.parse(originalUrl);
      final baseUri = Uri.parse(AppConfig.baseUrl);
      final newUri = uri.replace(
        scheme: baseUri.scheme,
        host: baseUri.host,
        port: baseUri.port,
      );
      return newUri.toString();
    }
    final base = AppConfig.baseUrl.replaceAll('/api/v1/', '');
    return '$base$originalUrl';
  }

  Future<void> _approve() async {
    setState(() => _isSubmitting = true);
    try {
      await ref.read(invoiceRepositoryProvider).approveInvoice(widget.invoiceId);
      ref.invalidate(invoiceDetailProvider(widget.invoiceId));
      ref.invalidate(invoicesProvider);
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Sukses'),
            content: const Text('Invoice Disetujui'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  if (!widget.isEmbedded && mounted) {
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
        title: const Text('Tolak Invoice'),
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
        await ref.read(invoiceRepositoryProvider).rejectInvoice(widget.invoiceId, reasonController.text);
        ref.invalidate(invoiceDetailProvider(widget.invoiceId));
        ref.invalidate(invoicesProvider);
        if (mounted) {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Sukses'),
              content: const Text('Invoice Ditolak'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                    if (!widget.isEmbedded && mounted) {
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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Gagal'),
            content: Text('Gagal mengambil gambar: $e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _saveVerification() async {
    if (_vendorInvoiceNoController.text.isEmpty && _imageFile == null) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Peringatan'),
          content: const Text('Silakan masukkan nomor invoice vendor atau pilih file bukti.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await ref.read(invoiceRepositoryProvider).verifyInvoice(
        widget.invoiceId,
        vendorInvoiceNumber: _vendorInvoiceNoController.text.isNotEmpty ? _vendorInvoiceNoController.text : null,
        imageFile: _imageFile,
      );

      ref.invalidate(invoiceDetailProvider(widget.invoiceId));
      ref.invalidate(invoicesProvider);

      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Sukses'),
            content: const Text('Verifikasi Invoice Berhasil Disimpan'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
        setState(() {
          _imageFile = null;
        });
      }
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Gagal'),
            content: Text('Gagal menyimpan verifikasi: $e'),
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

  @override
  Widget build(BuildContext context) {
    final invoiceAsync = ref.watch(invoiceDetailProvider(widget.invoiceId));
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);
    final bgColor = CupertinoColors.systemGroupedBackground.resolveFrom(context);
    final secondaryBgColor = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);

    invoiceAsync.whenData((invoice) {
      if (_vendorInvoiceNoController.text.isEmpty && invoice.vendorInvoiceNumber != null) {
        _vendorInvoiceNoController.text = invoice.vendorInvoiceNumber!;
      }
    });

    return CupertinoPageScaffold(
      backgroundColor: bgColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        automaticallyImplyLeading: !widget.isEmbedded,
        middle: Text(
          invoiceAsync.valueOrNull?.canApprove == true ? 'Persetujuan Invoice' : 'Detail Invoice',
          style: TextStyle(color: labelColor),
        ),
      ),
      child: SafeArea(
        child: invoiceAsync.when(
          data: (invoice) {
            final isDraftOrPending = invoice.status.toLowerCase() == 'draft' || invoice.status.toLowerCase() == 'pending';
            final canApproveNow = invoice.status.toLowerCase() == 'draft' && invoice.canApprove;

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
                              if (!widget.isEmbedded) ...[
                                _buildInfoRow('Nomor Invoice', invoice.invoiceNumber, isBold: true),
                                _buildInfoRow('Invoice Vendor', invoice.vendorInvoiceNumber ?? '-'),
                                _buildInfoRow('Pemasok', invoice.supplierName ?? '-'),
                                _buildInfoRow('Tanggal', _formatDate(invoice.invoiceDate)),
                                _buildInfoRow('Jatuh Tempo', _formatDate(invoice.dueDate)),
                                _buildInfoRow('Nomor Penerimaan', invoice.receivingNumber ?? '-'),
                                _buildInfoRow('Status', invoice.status.toUpperCase()),
                                const Divider(height: 24),
                              ],
                              _buildInfoRow('Subtotal', formatWithCurrency(invoice.subtotal, invoice.currency)),
                              _buildInfoRow('Pajak', formatWithCurrency(invoice.taxAmount, invoice.currency)),
                              _buildInfoRow('Diskon', formatWithCurrency(invoice.discountAmount, invoice.currency)),
                              _buildInfoRow('Jumlah Total', formatWithCurrency(invoice.totalAmount, invoice.currency), isBold: true),
                              if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Text(
                                  'Catatan: ${invoice.notes}',
                                  style: TextStyle(fontStyle: FontStyle.italic, color: secondaryLabelColor),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (isDraftOrPending) ...[
                        Text(
                          'Verifikasi & Bukti Pendukung',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: labelColor),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: secondaryBgColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                CupertinoTextField(
                                  controller: _vendorInvoiceNoController,
                                  placeholder: 'Nomor Invoice Vendor',
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
                                Text(
                                  'Foto / Bukti Dukung Vendor Invoice',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: labelColor),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        color: CupertinoColors.activeBlue,
                                        onPressed: () => _pickImage(ImageSource.camera),
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(CupertinoIcons.camera),
                                            SizedBox(width: 8),
                                            Text('Kamera'),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        color: CupertinoColors.activeBlue,
                                        onPressed: () => _pickImage(ImageSource.gallery),
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(CupertinoIcons.photo),
                                            SizedBox(width: 8),
                                            Text('Galeri'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (_imageFile != null) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: FileImage(File(_imageFile!.path)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 16),
                                CupertinoButton(
                                  color: const Color(0xFF6E56CF),
                                  padding: EdgeInsets.zero,
                                  onPressed: _isSubmitting ? null : _saveVerification,
                                  child: Container(
                                    height: 48,
                                    alignment: Alignment.center,
                                    child: _isSubmitting
                                        ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                                        : const Text(
                                            'SIMPAN VERIFIKASI',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: CupertinoColors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (invoice.media.isNotEmpty) ...[
                        Text(
                          'Dokumen Pendukung Terupload',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: labelColor),
                        ),
                        const SizedBox(height: 8),
                        ...invoice.media.map((med) {
                          final isImage = med.mimeType.startsWith('image/');
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: secondaryBgColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  Icon(isImage ? CupertinoIcons.photo : CupertinoIcons.doc_text, color: const Color(0xFF6E56CF), size: 24),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          med.fileName,
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: labelColor),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          med.mimeType.toUpperCase(),
                                          style: TextStyle(fontSize: 12, color: secondaryLabelColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    minSize: 32,
                                    child: const Icon(CupertinoIcons.chevron_right_circle, size: 22),
                                    onPressed: () {
                                      final mediaUrl = _getMediaUrl(med.originalUrl);
                                      if (med.mimeType == 'application/pdf') {
                                        context.push('/pdf-preview?title=${Uri.encodeComponent(med.fileName)}&pdf_url=${Uri.encodeComponent(mediaUrl)}');
                                      } else {
                                        showCupertinoDialog(
                                          context: context,
                                          builder: (context) => CupertinoPageScaffold(
                                            navigationBar: CupertinoNavigationBar(
                                              middle: Text(
                                                med.fileName,
                                                style: TextStyle(color: labelColor),
                                              ),
                                              leading: CupertinoButton(
                                                padding: EdgeInsets.zero,
                                                child: const Icon(CupertinoIcons.xmark, size: 22),
                                                onPressed: () => Navigator.pop(context),
                                              ),
                                            ),
                                            child: SafeArea(
                                              child: Container(
                                                color: CupertinoColors.black,
                                                child: Center(
                                                  child: InteractiveViewer(
                                                    child: Image.network(mediaUrl),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 16),
                      ],
                      Text(
                        'Item Invoice',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: labelColor),
                      ),
                      const SizedBox(height: 8),
                      ...invoice.items.map((item) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: secondaryBgColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.productName,
                                          style: TextStyle(fontWeight: FontWeight.bold, color: labelColor),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'SKU: ${item.productCode}',
                                          style: TextStyle(color: secondaryLabelColor, fontSize: 12),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${item.quantity.toStringAsFixed(item.quantity.truncateToDouble() == item.quantity ? 0 : 2)} ${item.unit} × ${formatWithCurrency(item.unitPrice, invoice.currency)}',
                                          style: TextStyle(color: secondaryLabelColor, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        formatWithCurrency(item.subtotal, invoice.currency),
                                        style: TextStyle(fontWeight: FontWeight.bold, color: labelColor),
                                      ),
                                      if (item.discount > 0)
                                        Text(
                                          'Diskon: ${formatWithCurrency(item.discount, invoice.currency)}',
                                          style: const TextStyle(color: CupertinoColors.destructiveRed, fontSize: 11),
                                        ),
                                      if (item.taxAmount > 0)
                                        Text(
                                          'Pajak: ${formatWithCurrency(item.taxAmount, invoice.currency)}',
                                          style: TextStyle(color: secondaryLabelColor, fontSize: 11),
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
                    child: Row(
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
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
              color: labelColor,
            ),
          ),
        ],
      ),
    );
  }
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
