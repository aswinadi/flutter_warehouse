import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/purchase_order_provider.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_dialog.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';

class POApprovalScreen extends ConsumerStatefulWidget {
  final int poId;
  final bool isEmbedded;
  const POApprovalScreen({super.key, required this.poId, this.isEmbedded = false});

  @override
  ConsumerState<POApprovalScreen> createState() => _POApprovalScreenState();
}

class _POApprovalScreenState extends ConsumerState<POApprovalScreen> {
  bool _isSubmitting = false;

  Future<void> _approve() async {
    setState(() => _isSubmitting = true);
    try {
      await ref.read(purchaseOrderRepositoryProvider).approvePurchaseOrder(widget.poId);
      ref.invalidate(purchaseOrdersProvider(status: 'submitted'));
      ref.invalidate(purchaseOrderDetailProvider(widget.poId));
      _showNotification('Pesanan Pembelian (PO) Berhasil Disetujui');
      if (!widget.isEmbedded && mounted) {
        context.pop();
      }
    } catch (e) {
      _showNotification('Gagal menyetujui: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _reject() async {
    final reasonController = TextEditingController();

    final result = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoGlassDialog(
        title: const Text('Tolak Pesanan Pembelian'),
        content: Padding(
          padding: const EdgeInsets.only(top: CupertinoSpacing.m),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Silakan berikan alasan penolakan (minimal 5 karakter):'),
              const SizedBox(height: CupertinoSpacing.m),
              CupertinoTextField(
                controller: reasonController,
                placeholder: 'Alasan Penolakan',
                maxLines: 3,
                placeholderStyle: context.subhead.copyWith(color: CupertinoColors.placeholderText),
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.separator),
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
            onPressed: () {
              if (reasonController.text.trim().length >= 5) {
                Navigator.pop(context, true);
              }
            },
            child: const Text('Tolak'),
          ),
        ],
      ),
    );

    if (result == true && reasonController.text.trim().length >= 5) {
      setState(() => _isSubmitting = true);
      try {
        await ref.read(purchaseOrderRepositoryProvider).rejectPurchaseOrder(
              widget.poId,
              reasonController.text.trim(),
            );
        ref.invalidate(purchaseOrdersProvider(status: 'submitted'));
        ref.invalidate(purchaseOrderDetailProvider(widget.poId));
        _showNotification('Pesanan Pembelian (PO) Telah Ditolak');
        if (!widget.isEmbedded && mounted) {
          context.pop();
        }
      } catch (e) {
        _showNotification('Gagal menolak: $e', isError: true);
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }

  void _showNotification(String message, {bool isError = false}) {
    if (!mounted) return;
    if (isError) {
      CupertinoGlassToast.showError(context, message);
    } else {
      CupertinoGlassToast.showSuccess(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final poAsync = ref.watch(purchaseOrderDetailProvider(widget.poId));
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    final detailContent = poAsync.when(
      data: (po) {
        final canApproveNow = po.status.toLowerCase() == 'submitted' && po.canApprove;
        final double calculatedTotal = po.items.fold(
          0.0,
          (sum, item) => sum + (item.orderedQty * (item.unitPrice ?? 0.0)),
        );
        final displayTotal = po.totalAmount ?? calculatedTotal;

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
                        _buildInfoRow(context, 'Nomor PO', po.poNumber, isBold: true),
                        _buildInfoRow(context, 'Pemasok', po.supplierName),
                        _buildInfoRow(context, 'Tanggal Transaksi', po.transactionDate),
                        _buildInfoRow(context, 'Tanggal Perkiraan', po.expectedDate),
                        if (po.paymentTerm != null && po.paymentTerm!.isNotEmpty)
                          _buildInfoRow(context, 'Syarat Pembayaran', po.paymentTerm!),
                        _buildInfoRow(context, 'Status', po.status.toUpperCase()),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.m),
                          child: Container(height: 0.5, color: CupertinoColors.separator.resolveFrom(context)),
                        ),
                        _buildInfoRow(
                          context,
                          'Jumlah Total',
                          formatWithCurrency(displayTotal, 'IDR'),
                          isBold: true,
                          textColor: const Color(0xFF6E56CF),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: CupertinoSpacing.xxl),
                  Text(
                    'Daftar Barang PO',
                    style: context.headline.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                  ),
                  const SizedBox(height: CupertinoSpacing.s),
                  ...po.items.map((item) {
                    final itemTotal = item.orderedQty * (item.unitPrice ?? 0.0);
                    return CupertinoGlassContainer(
                      margin: const EdgeInsets.only(bottom: CupertinoSpacing.m),
                      padding: const EdgeInsets.all(CupertinoSpacing.m),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: context.subhead.copyWith(
                              fontWeight: FontWeight.bold,
                              color: labelColor,
                            ),
                          ),
                          const SizedBox(height: CupertinoSpacing.xs),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'SKU: ${item.sku}',
                                style: context.caption1.copyWith(color: secondaryLabel),
                              ),
                              Text(
                                'Qty: ${item.orderedQty} ${item.unit}',
                                style: context.footnote.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: labelColor,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.s),
                            child: Container(height: 0.5, color: CupertinoColors.separator.resolveFrom(context)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Harga Satuan: ${formatWithCurrency(item.unitPrice ?? 0.0, 'IDR')}',
                                style: context.caption1.copyWith(color: secondaryLabel),
                              ),
                              Text(
                                'Subtotal: ${formatWithCurrency(itemTotal, 'IDR')}',
                                style: context.footnote.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: labelColor,
                                ),
                              ),
                            ],
                          ),
                          if (item.detailNotes != null && item.detailNotes!.trim().isNotEmpty) ...[
                            const SizedBox(height: CupertinoSpacing.s),
                            Text(
                              'Catatan: ${item.detailNotes}',
                              style: context.caption1.copyWith(color: secondaryLabel),
                            ),
                          ],
                          if (item.detailSpec != null && item.detailSpec!.trim().isNotEmpty) ...[
                            const SizedBox(height: CupertinoSpacing.xs),
                            Text(
                              'Spesifikasi: ${item.detailSpec}',
                              style: context.caption1.copyWith(
                                color: secondaryLabel,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            if (canApproveNow)
              CupertinoGlassContainer(
                borderRadius: 0,
                padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        color: CupertinoColors.destructiveRed,
                        borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                        onPressed: _isSubmitting ? null : _reject,
                        child: const Text('Tolak', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: CupertinoSpacing.screenMargin),
                    Expanded(
                      flex: 2,
                      child: CupertinoButton.filled(
                        borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                        onPressed: _isSubmitting ? null : _approve,
                        child: _isSubmitting
                            ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                            : const Text('Setujui', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (err, _) => Center(child: Text('Gagal memuat detail PO: $err', style: const TextStyle(color: CupertinoColors.destructiveRed))),
    );

    if (widget.isEmbedded) {
      return Container(
        color: CupertinoColors.transparent,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: CupertinoSpacing.screenMargin,
                vertical: CupertinoSpacing.s,
              ),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground.resolveFrom(context),
                border: Border(
                  bottom: BorderSide(
                    color: CupertinoColors.separator.resolveFrom(context),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  poAsync.when(
                    data: (po) => Text(
                      po.canApprove ? 'Persetujuan PO' : 'Detail PO',
                      style: context.headline.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                    ),
                    loading: () => const Text('Memuat PO...'),
                    error: (err, _) => const Text('Error'),
                  ),
                  poAsync.when(
                    data: (po) => CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size.square(32),
                      child: const Icon(CupertinoIcons.printer, size: 22),
                      onPressed: () {
                        context.push('/pdf-preview?title=Pesanan Pembelian ${po.poNumber}&url_path=pdf/purchase-order/${po.id}');
                      },
                    ),
                    loading: () => const SizedBox(),
                    error: (err, _) => const SizedBox(),
                  ),
                ],
              ),
            ),
            Expanded(child: detailContent),
          ],
        ),
      );
    }

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        automaticallyImplyLeading: !widget.isEmbedded,
        middle: poAsync.when(
          data: (po) => Text(
            po.canApprove ? 'Persetujuan PO' : 'Detail PO',
            style: TextStyle(color: labelColor),
          ),
          loading: () => const Text('Memuat PO...'),
          error: (err, _) => const Text('Error'),
        ),
        trailing: poAsync.when(
          data: (po) => CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: const Size.square(32),
            child: const Icon(CupertinoIcons.printer, size: 22),
            onPressed: () {
              context.push('/pdf-preview?title=Pesanan Pembelian ${po.poNumber}&url_path=pdf/purchase-order/${po.id}');
            },
          ),
          loading: () => const SizedBox(),
          error: (err, _) => const SizedBox(),
        ),
      ),
      child: SafeArea(
        child: detailContent,
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
    Color? textColor,
  }) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.subhead.copyWith(color: secondaryLabel)),
          Text(
            value,
            style: context.subhead.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: textColor ?? labelColor,
            ),
          ),
        ],
      ),
    );
  }
}
