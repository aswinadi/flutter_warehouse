import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/payment_transaction.dart';
import '../providers/payment_transaction_provider.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';

class PaymentTransactionDetailScreen extends StatelessWidget {
  final int transactionId;

  const PaymentTransactionDetailScreen({
    super.key,
    required this.transactionId,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        middle: Text(
          'Detail Pembayaran',
          style: context.headline.copyWith(color: CupertinoColors.label.resolveFrom(context)),
        ),
      ),
      child: SafeArea(
        child: PaymentTransactionDetailWidget(
          transactionId: transactionId,
        ),
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
    final source = await showCupertinoModalPopup<ImageSource>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Pilih Sumber Foto'),
        actions: [
          CupertinoActionSheetAction(
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.camera, color: CupertinoColors.activeBlue),
                SizedBox(width: 8),
                Text('Kamera'),
              ],
            ),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          CupertinoActionSheetAction(
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.photo, color: CupertinoColors.activeBlue),
                SizedBox(width: 8),
                Text('Galeri'),
              ],
            ),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
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
        CupertinoGlassToast.showSuccess(context, 'Bukti transfer berhasil diunggah.');
        ref.invalidate(paymentTransactionDetailsProvider(transactionId));
        widget.onUploadSuccess?.call();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _uploadError = e.toString();
        });
        CupertinoGlassToast.showError(context, 'Gagal mengunggah: $e');
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
          padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMainDetailsCard(trx),
              const SizedBox(height: CupertinoSpacing.l),
              _buildProofUploadSection(trx),
              const SizedBox(height: CupertinoSpacing.l),
              _buildInvoicesSection(trx),
            ],
          ),
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(CupertinoSpacing.xxxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.exclamationmark_triangle, color: CupertinoColors.systemRed, size: 48),
              const SizedBox(height: CupertinoSpacing.m),
              Text(
                'Gagal memuat detail transaksi: $err',
                textAlign: TextAlign.center,
                style: context.subhead.copyWith(color: CupertinoColors.systemRed),
              ),
              const SizedBox(height: CupertinoSpacing.m),
              CupertinoButton.filled(
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
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);

    return CupertinoGlassContainer(
      borderRadius: CupertinoSpacing.cardRadius + 2,
      padding: const EdgeInsets.all(CupertinoSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(CupertinoSpacing.s),
                decoration: BoxDecoration(
                  color: CupertinoColors.activeBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  CupertinoIcons.creditcard_fill,
                  color: CupertinoColors.activeBlue,
                ),
              ),
              const SizedBox(width: CupertinoSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trx.transactionNumber,
                      style: context.title3.copyWith(
                        fontWeight: FontWeight.bold,
                        color: labelColor,
                      ),
                    ),
                    Text(
                      'Tanggal: ${trx.transactionDate}',
                      style: context.footnote.copyWith(color: secondaryLabelColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: CupertinoSpacing.xxxl),
          _buildDetailRow(CupertinoIcons.building_2_fill, 'Pemasok', trx.supplierName ?? '-'),
          const SizedBox(height: CupertinoSpacing.m),
          _buildDetailRow(
            CupertinoIcons.creditcard,
            'Rekening Bank Pemasok',
            trx.supplierBankAccount != null && trx.supplierBankAccount!.isNotEmpty
                ? '${trx.supplierBankName ?? ''} - ${trx.supplierBankAccount} (${trx.supplierBankAccountName ?? ''})'
                : '-',
          ),
          const SizedBox(height: CupertinoSpacing.m),
          _buildDetailRow(
            CupertinoIcons.house_fill,
            'Bank Sumber',
            trx.bankName != null
                ? '${trx.bankName} - ${trx.bankAccount}'
                : 'Tidak Ada Rekening Bank',
          ),
          if (trx.transferReference != null && trx.transferReference!.isNotEmpty) ...[
            const SizedBox(height: CupertinoSpacing.m),
            _buildDetailRow(
              CupertinoIcons.doc_text,
              'Referensi Transfer',
              trx.transferReference!,
            ),
          ],
          if (trx.notes != null && trx.notes!.isNotEmpty) ...[
            const SizedBox(height: CupertinoSpacing.m),
            _buildDetailRow(CupertinoIcons.doc, 'Catatan', trx.notes!),
          ],
          const Divider(height: CupertinoSpacing.xxxl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Bayar',
                style: context.subhead.copyWith(
                  color: secondaryLabelColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                _formatCurrency(trx.totalAmount),
                style: context.title3.copyWith(
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.activeBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: secondaryLabelColor),
        const SizedBox(width: CupertinoSpacing.m),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.caption1.copyWith(
                  color: secondaryLabelColor,
                ),
              ),
              const SizedBox(height: CupertinoSpacing.xs - 2),
              Text(
                value,
                style: context.subhead.copyWith(
                  fontWeight: FontWeight.w500,
                  color: labelColor,
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
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);

    return CupertinoGlassContainer(
      borderRadius: CupertinoSpacing.cardRadius + 2,
      padding: const EdgeInsets.all(CupertinoSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bukti Transfer',
            style: context.callout.copyWith(
              fontWeight: FontWeight.bold,
              color: labelColor,
            ),
          ),
          const SizedBox(height: CupertinoSpacing.l),
          if (_isUploading)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.screenMargin),
                child: Column(
                  children: [
                    const CupertinoActivityIndicator(radius: 14),
                    const SizedBox(height: CupertinoSpacing.m),
                    Text('Mengunggah bukti transfer...', style: TextStyle(color: secondaryLabelColor)),
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
                    border: Border.all(color: CupertinoColors.separator.resolveFrom(context)),
                    borderRadius: BorderRadius.circular(12),
                    color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: trx.receiptUrl!.toLowerCase().endsWith('.pdf')
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(CupertinoIcons.doc_text, size: 64, color: CupertinoColors.systemRed),
                              const SizedBox(height: CupertinoSpacing.s),
                              Text(
                                'Dokumen PDF Bukti Transfer',
                                style: context.footnote.copyWith(color: secondaryLabelColor),
                              ),
                            ],
                          ),
                        )
                      : Image.network(
                          trx.receiptUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.exclamationmark_triangle, size: 48, color: secondaryLabelColor),
                                const SizedBox(height: CupertinoSpacing.s),
                                Text(
                                  'Gagal menampilkan gambar bukti',
                                  style: context.footnote.copyWith(color: secondaryLabelColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: CupertinoSpacing.l),
                Row(
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        color: CupertinoColors.activeBlue,
                        onPressed: () => _pickAndUploadProof(trx.id),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.arrow_clockwise),
                            SizedBox(width: CupertinoSpacing.s),
                            Text('Unggah Ulang Bukti'),
                          ],
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
              padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.xxxl, horizontal: CupertinoSpacing.screenMargin),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                border: Border.all(
                  color: CupertinoColors.separator.resolveFrom(context),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    CupertinoIcons.cloud_upload,
                    size: 48,
                    color: secondaryLabelColor,
                  ),
                  const SizedBox(height: CupertinoSpacing.m),
                  Text(
                    'Belum Ada Bukti Transfer',
                    style: context.subhead.copyWith(
                      fontWeight: FontWeight.bold,
                      color: labelColor,
                    ),
                  ),
                  const SizedBox(height: CupertinoSpacing.xs),
                  Text(
                    'Harap unggah bukti transfer pembayaran ini',
                    style: context.caption1.copyWith(
                      color: secondaryLabelColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: CupertinoSpacing.l),
                  CupertinoButton.filled(
                    onPressed: () => _pickAndUploadProof(trx.id),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.cloud_upload),
                        SizedBox(width: CupertinoSpacing.s),
                        Text('Unggah Bukti'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (_uploadError != null) ...[
            const SizedBox(height: CupertinoSpacing.s),
            Text(
              _uploadError!,
              style: context.caption1.copyWith(color: CupertinoColors.destructiveRed),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInvoicesSection(PaymentTransaction trx) {
    if (trx.invoices.isEmpty) return const SizedBox.shrink();
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);

    return CupertinoGlassContainer(
      borderRadius: CupertinoSpacing.cardRadius + 2,
      padding: const EdgeInsets.all(CupertinoSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Invoice yang Dibayar',
            style: context.callout.copyWith(
              fontWeight: FontWeight.bold,
              color: labelColor,
            ),
          ),
          const SizedBox(height: CupertinoSpacing.m),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: trx.invoices.length,
            separatorBuilder: (context, index) =>
                Divider(color: CupertinoColors.separator.resolveFrom(context)),
            itemBuilder: (context, index) {
              final item = trx.invoices[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.xs),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.invoiceNumber,
                          style: context.subhead.copyWith(
                            fontWeight: FontWeight.bold,
                            color: labelColor,
                          ),
                        ),
                        if (item.invoiceDate != null)
                          Text(
                            'Tanggal: ${item.invoiceDate}',
                            style: context.caption1.copyWith(
                              color: secondaryLabelColor,
                            ),
                          ),
                      ],
                    ),
                    Text(
                      _formatCurrency(item.amountPaid),
                      style: context.subhead.copyWith(
                        fontWeight: FontWeight.w600,
                        color: labelColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
