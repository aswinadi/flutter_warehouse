import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../providers/return_to_vendor_provider.dart';

class ReturnToVendorDetailScreen extends ConsumerStatefulWidget {
  final int rtvId;
  final bool isEmbedded;

  const ReturnToVendorDetailScreen({
    super.key,
    required this.rtvId,
    this.isEmbedded = false,
  });

  @override
  ConsumerState<ReturnToVendorDetailScreen> createState() =>
      _ReturnToVendorDetailScreenState();
}

class _ReturnToVendorDetailScreenState
    extends ConsumerState<ReturnToVendorDetailScreen> {
  bool _isSubmitting = false;

  Future<void> _approveRtv() async {
    setState(() => _isSubmitting = true);
    try {
      await ref.read(returnToVendorRepositoryProvider).approveRtv(widget.rtvId);
      ref.invalidate(returnToVendorDetailProvider(widget.rtvId));
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
            title: const Text('Berhasil'),
            content: const Text('Dokumen Retur RTV telah disetujui.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
            title: const Text('Error'),
            content: Text('Gagal menyetujui RTV: $e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _shipRtv() async {
    final confirm = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Proses Kirim Retur'),
        content: const Text(
          'Tindakan ini akan mengosongkan/mengurangi stok barang di gudang dan mencatat Piutang Vendor (AR Debit Note). Lanjutkan?',
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Kirim & Potong Stok'),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isSubmitting = true);
    try {
      await ref.read(returnToVendorRepositoryProvider).shipRtv(widget.rtvId);
      ref.invalidate(returnToVendorDetailProvider(widget.rtvId));
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
            title: const Text('Sukses Diproses'),
            content: const Text(
              'Retur barang berhasil dikirim! Stok telah dikurangi dan Piutang Vendor (AR Debit Note) telah dicatat.',
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
            title: const Text('Error'),
            content: Text('Gagal memproses RTV: $e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(ctx),
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
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    final rtvAsync = ref.watch(returnToVendorDetailProvider(widget.rtvId));

    return CupertinoPageScaffold(
      navigationBar: widget.isEmbedded
          ? null
          : const CupertinoNavigationBar(
              middle: Text('Detail Retur Supplier (RTV)'),
            ),
      child: SafeArea(
        child: rtvAsync.when(
          data: (rtv) {
            final canApprove = rtv.status.toLowerCase() == 'draft';
            final canShip = rtv.status.toLowerCase() == 'draft' || rtv.status.toLowerCase() == 'approved';

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(CupertinoSpacing.m),
                    children: [
                      // Header Card
                      CupertinoGlassContainer(
                        borderRadius: 16.0,
                        padding: const EdgeInsets.all(CupertinoSpacing.m),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  rtv.rtvNumber,
                                  style: context.title2.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: labelColor,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.activeBlue.resolveFrom(context).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    rtv.status.toUpperCase(),
                                    style: context.caption1.copyWith(
                                      color: CupertinoColors.activeBlue.resolveFrom(context),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildInfoRow('Supplier', rtv.supplierName ?? '-'),
                            _buildInfoRow('Gudang Asal', rtv.warehouseName ?? '-'),
                            _buildInfoRow('Tanggal Retur', rtv.returnDate),
                            if (rtv.reason != null) _buildInfoRow('Alasan', rtv.reason!),
                            if (rtv.notes != null) _buildInfoRow('Catatan', rtv.notes!),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total Retur', style: context.headline.copyWith(color: secondaryLabel)),
                                Text(
                                  formatWithCurrency(rtv.totalAmount, 'IDR'),
                                  style: context.title1.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: labelColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: CupertinoSpacing.l),

                      Text('Daftar Barang Retur', style: context.title2.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: CupertinoSpacing.s),

                      // Details List
                      ...rtv.details.map(
                        (detail) => Padding(
                          padding: const EdgeInsets.only(bottom: CupertinoSpacing.s),
                          child: CupertinoGlassContainer(
                            borderRadius: 12.0,
                            padding: const EdgeInsets.all(CupertinoSpacing.m),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  detail.itemName ?? 'Item #${detail.itemId}',
                                  style: context.headline.copyWith(fontWeight: FontWeight.bold),
                                ),
                                if (detail.itemCode != null)
                                  Text('SKU: ${detail.itemCode}', style: context.footnote.copyWith(color: secondaryLabel)),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Qty: ${detail.quantity}', style: context.subhead),
                                    Text(
                                      'Subtotal: ${formatWithCurrency(detail.subtotal, 'IDR')}',
                                      style: context.subhead.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                if (detail.reason != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Kondisi: ${detail.condition} (${detail.reason})',
                                    style: context.caption1.copyWith(color: CupertinoColors.systemRed),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Footer Action Buttons
                if (canShip || canApprove)
                  Padding(
                    padding: const EdgeInsets.all(CupertinoSpacing.m),
                    child: Column(
                      children: [
                        if (canApprove)
                          SizedBox(
                            width: double.infinity,
                            child: CupertinoButton(
                              color: CupertinoColors.activeBlue,
                              onPressed: _isSubmitting ? null : _approveRtv,
                              child: _isSubmitting
                                  ? const CupertinoActivityIndicator()
                                  : const Text('Approve RTV Document'),
                            ),
                          ),
                        if (canApprove && canShip) const SizedBox(height: CupertinoSpacing.s),
                        if (canShip)
                          SizedBox(
                            width: double.infinity,
                            child: CupertinoButton(
                              color: CupertinoColors.systemGreen,
                              onPressed: _isSubmitting ? null : _shipRtv,
                              child: _isSubmitting
                                  ? const CupertinoActivityIndicator()
                                  : const Text('Kirim Retur & Potong Stok'),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (err, stack) => Center(
            child: Text('Error: $err', style: TextStyle(color: CupertinoColors.destructiveRed.resolveFrom(context))),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: CupertinoColors.secondaryLabel)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
