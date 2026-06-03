import 'dart:io';
import 'package:flutter/material.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice Disetujui')));
        if (!widget.isEmbedded) {
          context.pop();
        }
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
        title: const Text('Tolak Invoice'),
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
        await ref.read(invoiceRepositoryProvider).rejectInvoice(widget.invoiceId, reasonController.text);
        ref.invalidate(invoiceDetailProvider(widget.invoiceId));
        ref.invalidate(invoicesProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice Ditolak')));
          if (!widget.isEmbedded) {
            context.pop();
          }
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
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
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal mengambil gambar: $e')));
    }
  }

  Future<void> _saveVerification() async {
    if (_vendorInvoiceNoController.text.isEmpty && _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan masukkan nomor invoice vendor atau pilih file bukti.')),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verifikasi Invoice Berhasil Disimpan')),
        );
        setState(() {
          _imageFile = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan verifikasi: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final invoiceAsync = ref.watch(invoiceDetailProvider(widget.invoiceId));

    invoiceAsync.whenData((invoice) {
      if (_vendorInvoiceNoController.text.isEmpty && invoice.vendorInvoiceNumber != null) {
        _vendorInvoiceNoController.text = invoice.vendorInvoiceNumber!;
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: !widget.isEmbedded,
        title: Text(invoiceAsync.valueOrNull?.canApprove == true ? 'Persetujuan Invoice' : 'Detail Invoice'),
      ),
      body: invoiceAsync.when(
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
                            if (!widget.isEmbedded) ...[
                              _buildInfoRow('Nomor Invoice', invoice.invoiceNumber, isBold: true),
                              _buildInfoRow('Invoice Vendor', invoice.vendorInvoiceNumber ?? '-'),
                              _buildInfoRow('Pemasok', invoice.supplierName ?? '-'),
                              _buildInfoRow('Tanggal', _formatDate(invoice.invoiceDate)),
                              _buildInfoRow('Jatuh Tempo', _formatDate(invoice.dueDate)),
                              _buildInfoRow('Nomor Penerimaan', invoice.receivingNumber ?? '-'),
                              _buildInfoRow('Status', invoice.status.toUpperCase()),
                              const Divider(color: Color(0xFFE2E8F0), height: 24),
                            ],
                            _buildInfoRow('Subtotal', formatWithCurrency(invoice.subtotal, invoice.currency)),
                            _buildInfoRow('Pajak', formatWithCurrency(invoice.taxAmount, invoice.currency)),
                            _buildInfoRow('Diskon', formatWithCurrency(invoice.discountAmount, invoice.currency)),
                            _buildInfoRow('Jumlah Total', formatWithCurrency(invoice.totalAmount, invoice.currency), isBold: true),
                            if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text('Catatan: ${invoice.notes}', style: const TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF64748B))),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (isDraftOrPending) ...[
                      const Text('Verifikasi & Bukti Pendukung', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x0A0F0F0F),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextField(
                                controller: _vendorInvoiceNoController,
                                decoration: const InputDecoration(
                                  labelText: 'Nomor Invoice Vendor',
                                  hintText: 'Masukkan nomor invoice dari pihak supplier',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text('Foto / Bukti Dukung Vendor Invoice', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => _pickImage(ImageSource.camera),
                                      icon: const Icon(Icons.camera_alt),
                                      label: const Text('Kamera'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => _pickImage(ImageSource.gallery),
                                      icon: const Icon(Icons.photo_library),
                                      label: const Text('Galeri'),
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
                              ElevatedButton(
                                onPressed: _isSubmitting ? null : _saveVerification,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6E56CF), // Notion Purple
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: _isSubmitting
                                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                    : const Text('SIMPAN VERIFIKASI'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (invoice.media.isNotEmpty) ...[
                      const Text('Dokumen Pendukung Terupload', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...invoice.media.map((med) {
                        final isImage = med.mimeType.startsWith('image/');
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: ListTile(
                            leading: Icon(isImage ? Icons.image : Icons.picture_as_pdf, color: const Color(0xFF6E56CF)),
                            title: Text(med.fileName),
                            subtitle: Text(med.mimeType.toUpperCase()),
                            trailing: IconButton(
                              icon: const Icon(Icons.open_in_new),
                              onPressed: () {
                                final mediaUrl = _getMediaUrl(med.originalUrl);
                                if (med.mimeType == 'application/pdf') {
                                  context.push('/pdf-preview?title=${Uri.encodeComponent(med.fileName)}&pdf_url=${Uri.encodeComponent(mediaUrl)}');
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AppBar(
                                            title: Text(med.fileName),
                                            leading: IconButton(
                                              icon: const Icon(Icons.close),
                                              onPressed: () => Navigator.pop(context),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InteractiveViewer(
                                              child: Image.network(mediaUrl),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                    ],
                    const Text('Item Invoice', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...invoice.items.map((item) => Container(
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
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'SKU: ${item.productCode}',
                                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${item.quantity.toStringAsFixed(item.quantity.truncateToDouble() == item.quantity ? 0 : 2)} ${item.unit} × ${formatWithCurrency(item.unitPrice, invoice.currency)}',
                                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
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
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                    ),
                                    if (item.discount > 0)
                                      Text(
                                        'Diskon: ${formatWithCurrency(item.discount, invoice.currency)}',
                                        style: const TextStyle(color: Color(0xFFEF4444), fontSize: 11),
                                      ),
                                    if (item.taxAmount > 0)
                                      Text(
                                        'Pajak: ${formatWithCurrency(item.taxAmount, invoice.currency)}',
                                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
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
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
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
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
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
