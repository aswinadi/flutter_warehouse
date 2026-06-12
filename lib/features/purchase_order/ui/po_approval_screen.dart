import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors; // kept for legacy Color references if needed
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/purchase_order_provider.dart';
import '../providers/purchase_order_repository.dart';
import '../../../core/utils/currency_utils.dart';

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
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Tolak Pesanan Pembelian'),
        content: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Silakan berikan alasan penolakan (minimal 5 karakter):'),
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: reasonController,
                placeholder: 'Alasan Penolakan',
                maxLines: 3,
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
            onPressed: () {
              if (reasonController.text.trim().length >= 5) {
                Navigator.pop(context, true);
              } else {
                // Keep dialog open, or we can close and notify
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
    
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 24,
        left: 24,
        right: 24,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: DefaultTextStyle(
              style: const TextStyle(color: CupertinoColors.white, fontFamily: '.SF Pro Text'),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 250),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - value) * -20),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isError ? CupertinoColors.systemRed : CupertinoColors.activeGreen,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: CupertinoColors.black,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isError ? CupertinoIcons.exclamationmark_triangle : CupertinoIcons.check_mark_circled,
                        color: CupertinoColors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          message,
                          style: const TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          if (entry.mounted) entry.remove();
                        },
                        child: const Icon(CupertinoIcons.xmark, color: CupertinoColors.white, size: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (entry.mounted) entry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final poAsync = ref.watch(purchaseOrderDetailProvider(widget.poId));
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: !widget.isEmbedded,
        middle: poAsync.when(
          data: (po) => Text(po.canApprove ? 'Persetujuan PO' : 'Detail PO'),
          loading: () => const Text('Memuat PO...'),
          error: (_, __) => const Text('Error'),
        ),
        trailing: poAsync.when(
          data: (po) => CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.printer, size: 22),
            onPressed: () {
              context.push('/pdf-preview?title=Pesanan Pembelian ${po.poNumber}&url_path=pdf/purchase-order/${po.id}');
            },
          ),
          loading: () => const SizedBox(),
          error: (_, __) => const SizedBox(),
        ),
      ),
      child: SafeArea(
        child: poAsync.when(
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
                    padding: const EdgeInsets.all(16),
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: separatorColor, width: 0.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
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
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Container(height: 0.5, color: separatorColor),
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
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Daftar Barang PO',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: labelColor),
                      ),
                      const SizedBox(height: 10),
                      ...po.items.map((item) {
                        final itemTotal = item.orderedQty * (item.unitPrice ?? 0.0);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: separatorColor, width: 0.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.productName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: labelColor,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'SKU: ${item.sku}',
                                      style: TextStyle(color: secondaryLabel, fontSize: 12),
                                    ),
                                    Text(
                                      'Qty: ${item.orderedQty} ${item.unit}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: labelColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Container(height: 0.5, color: separatorColor),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Harga Satuan: ${formatWithCurrency(item.unitPrice ?? 0.0, 'IDR')}',
                                      style: TextStyle(color: secondaryLabel, fontSize: 12),
                                    ),
                                    Text(
                                      'Subtotal: ${formatWithCurrency(itemTotal, 'IDR')}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: labelColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                if (item.detailNotes != null && item.detailNotes!.trim().isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    'Catatan: ${item.detailNotes}',
                                    style: TextStyle(fontSize: 12, color: secondaryLabel),
                                  ),
                                ],
                                if (item.detailSpec != null && item.detailSpec!.trim().isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Spesifikasi: ${item.detailSpec}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: secondaryLabel,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                if (canApproveNow)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      border: Border(top: BorderSide(color: separatorColor, width: 0.5)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: CupertinoButton(
                            color: CupertinoColors.destructiveRed,
                            onPressed: _isSubmitting ? null : _reject,
                            child: const Text('Tolak', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: CupertinoButton.filled(
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
        ),
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: secondaryLabel, fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
              color: textColor ?? labelColor,
            ),
          ),
        ],
      ),
    );
  }
}
