import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/payment_transaction.dart';
import '../providers/payment_transaction_provider.dart';

class PaymentTransactionDetailScreen extends StatelessWidget {
  final int transactionId;

  const PaymentTransactionDetailScreen({
    super.key,
    required this.transactionId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pembayaran'),
      ),
      body: PaymentTransactionDetailWidget(
        transactionId: transactionId,
      ),
    );
  }
}

class PaymentTransactionDetailWidget extends ConsumerStatefulWidget {
  final int transactionId;
  final VoidCallback? onUploadSuccess;

  const PaymentTransactionDetailWidget({
    super.key,
    required this.transactionId,
    this.onUploadSuccess,
  });

  @override
  ConsumerState<PaymentTransactionDetailWidget> createState() =>
      _PaymentTransactionDetailWidgetState();
}

class _PaymentTransactionDetailWidgetState
    extends ConsumerState<PaymentTransactionDetailWidget> {
  bool _isUploading = false;
  String? _uploadError;

  String _formatCurrency(double amount) {
    final str = amount.toStringAsFixed(0);
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return 'Rp ${str.replaceAllMapped(reg, (Match m) => '${m[1]}.')}';
  }

  Future<void> _pickAndUploadProof(int transactionId) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 80,
    );

    if (pickedFile == null) return;

    setState(() {
      _isUploading = true;
      _uploadError = null;
    });

    try {
      final repository = ref.read(paymentTransactionRepositoryProvider);
      await repository.uploadProof(transactionId, pickedFile.path);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bukti transfer berhasil diunggah.'),
            backgroundColor: Colors.green,
          ),
        );
        ref.invalidate(paymentTransactionDetailsProvider(transactionId));
        widget.onUploadSuccess?.call();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _uploadError = e.toString();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengunggah: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(paymentTransactionDetailsProvider(widget.transactionId));

    return detailAsync.when(
      data: (trx) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMainDetailsCard(trx),
              const SizedBox(height: 16),
              _buildProofUploadSection(trx),
              const SizedBox(height: 16),
              _buildInvoicesSection(trx),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 12),
              Text(
                'Gagal memuat detail transaksi: $err',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(paymentTransactionDetailsProvider(widget.transactionId));
                },
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainDetailsCard(PaymentTransaction trx) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trx.transactionNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Tanggal: ${trx.transactionDate}',
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            _buildDetailRow(Icons.business, 'Pemasok', trx.supplierName ?? '-'),
            const SizedBox(height: 12),
            _buildDetailRow(
              Icons.account_balance,
              'Bank Sumber',
              trx.bankName != null
                  ? '${trx.bankName} - ${trx.bankAccount}'
                  : 'Tidak Ada Rekening Bank',
            ),
            if (trx.transferReference != null && trx.transferReference!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildDetailRow(
                Icons.receipt,
                'Referensi Transfer',
                trx.transferReference!,
              ),
            ],
            if (trx.notes != null && trx.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildDetailRow(Icons.note, 'Catatan', trx.notes!),
            ],
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Bayar',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatCurrency(trx.totalAmount),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProofUploadSection(PaymentTransaction trx) {
    final hasProof = trx.receiptUrl != null && trx.receiptUrl!.isNotEmpty;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bukti Transfer',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            if (_isUploading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text('Mengunggah bukti transfer...'),
                    ],
                  ),
                ),
              )
            else if (hasProof)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade50,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: trx.receiptUrl!.toLowerCase().endsWith('.pdf')
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.picture_as_pdf,
                                    size: 64, color: Colors.red),
                                SizedBox(height: 8),
                                Text(
                                  'Dokumen PDF Bukti Transfer',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                ),
                              ],
                            ),
                          )
                        : Image.network(
                            trx.receiptUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.broken_image,
                                      size: 48, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text(
                                    'Gagal menampilkan gambar bukti',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickAndUploadProof(trx.id),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Unggah Ulang Bukti'),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border.all(
                    color: Colors.grey.shade300,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Belum Ada Bukti Transfer',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Harap unggah bukti transfer pembayaran ini',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _pickAndUploadProof(trx.id),
                      icon: const Icon(Icons.upload),
                      label: const Text('Unggah Bukti'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            if (_uploadError != null) ...[
              const SizedBox(height: 8),
              Text(
                _uploadError!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInvoicesSection(PaymentTransaction trx) {
    if (trx.invoices.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Invoice yang Dibayar',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: trx.invoices.length,
              separatorBuilder: (context, index) =>
                  Divider(color: Colors.grey.shade200),
              itemBuilder: (context, index) {
                final item = trx.invoices[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.invoiceNumber,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          if (item.invoiceDate != null)
                            Text(
                              'Tanggal: ${item.invoiceDate}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                      Text(
                        _formatCurrency(item.amountPaid),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
