import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/receiving.dart';
import '../providers/receiving_provider.dart';
import '../providers/receiving_repository.dart';
import 'package:go_router/go_router.dart';

class ContainerReceivingFormScreen extends ConsumerStatefulWidget {
  final String containerNumber;
  final bool embed;
  final VoidCallback? onSubmitSuccess;

  const ContainerReceivingFormScreen({
    super.key,
    required this.containerNumber,
    this.embed = false,
    this.onSubmitSuccess,
  });

  @override
  ConsumerState<ContainerReceivingFormScreen> createState() => _ContainerReceivingFormScreenState();
}

class _ContainerReceivingFormScreenState extends ConsumerState<ContainerReceivingFormScreen> {
  final _driverController = TextEditingController();
  final _truckController = TextEditingController();
  final _notesController = TextEditingController();

  final Map<int, double> _receivedQuantities = {};
  bool _isSubmitting = false;
  bool _initialized = false;

  @override
  void dispose() {
    _driverController.dispose();
    _truckController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _initializeValues(ReceivingContainerManifest manifest) {
    if (_initialized) return;
    _truckController.text = manifest.plateNumber ?? '';
    for (final item in manifest.items) {
      _receivedQuantities[item.poDetailId] = item.plannedQty;
    }
    _initialized = true;
  }

  Future<void> _submit(ReceivingContainerManifest manifest) async {
    // Check if at least one item has received qty > 0
    final hasQty = _receivedQuantities.values.any((qty) => qty > 0);
    if (!hasQty) {
      _showTopNotification(context, 'Silakan masukkan jumlah diterima minimal untuk satu item.', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Group items by po_header_id
      final groupedManifestMap = <int, List<ContainerReceivingItemRequest>>{};
      for (final item in manifest.items) {
        final qty = _receivedQuantities[item.poDetailId] ?? 0.0;
        if (qty > 0) {
          final requestItem = ContainerReceivingItemRequest(
            poDetailId: item.poDetailId,
            receivedQty: qty,
            unit: item.unit,
            conversion: 1,
          );
          if (!groupedManifestMap.containsKey(item.poHeaderId)) {
            groupedManifestMap[item.poHeaderId] = [];
          }
          groupedManifestMap[item.poHeaderId]!.add(requestItem);
        }
      }

      final manifestGroups = groupedManifestMap.entries.map((entry) {
        return ContainerGroupedManifest(
          poHeaderId: entry.key,
          items: entry.value,
        );
      }).toList();

      final request = ContainerReceivingRequest(
        sourceWarehouseId: manifest.sourceWarehouseId,
        destinationWarehouseId: manifest.destinationWarehouseId,
        containerNumber: manifest.containerNumber,
        plateNumber: _truckController.text.trim().isNotEmpty ? _truckController.text.trim() : null,
        driverName: _driverController.text.trim().isNotEmpty ? _driverController.text.trim() : null,
        manifest: manifestGroups,
      );

      final repo = ref.read(receivingRepositoryProvider);
      await repo.submitContainerReceiving(request);

      ref.invalidate(receivingsHistoryProvider);
      ref.invalidate(receivingContainersProvider);
      ref.invalidate(containerManifestProvider(widget.containerNumber));

      if (mounted) {
        _showTopNotification(context, 'Penerimaan Barang Kontainer berhasil dikirim!');
        if (widget.embed) {
          widget.onSubmitSuccess?.call();
        } else {
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        _showTopNotification(context, 'Gagal mengirim Penerimaan Barang Kontainer: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final manifestAsync = ref.watch(containerManifestProvider(widget.containerNumber));
    final isWide = MediaQuery.of(context).size.width > 900;
    final bgColor = CupertinoColors.systemGroupedBackground.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);

    final content = manifestAsync.when(
      data: (manifest) {
        _initializeValues(manifest);

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildContainerDetailsCard(manifest),
                  const SizedBox(height: 16),
                  _buildReceiptFormFields(isWide),
                  const SizedBox(height: 24),
                  Text(
                    'Barang yang Diterima dari Kontainer',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: labelColor),
                  ),
                  const SizedBox(height: 8),
                  ...manifest.items.map((item) => _buildItemRow(item)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                border: Border(top: BorderSide(color: CupertinoColors.separator.resolveFrom(context), width: 0.5)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  borderRadius: BorderRadius.circular(10),
                  onPressed: _isSubmitting ? null : () => _submit(manifest),
                  child: _isSubmitting
                      ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                      : const Text(
                          'KIRIM PENERIMAAN KONTAINER',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: CupertinoColors.white),
                        ),
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (err, _) => Center(child: Text('Gagal memuat manifest kontainer: $err')),
    );

    if (widget.embed) {
      return content;
    }

    return CupertinoPageScaffold(
      backgroundColor: bgColor,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Penerimaan Barang Kontainer'),
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
      ),
      child: SafeArea(child: content),
    );
  }

  Widget _buildContainerDetailsCard(ReceivingContainerManifest manifest) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    const statusColor = CupertinoColors.activeBlue;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: separatorColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                manifest.containerNumber,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: CupertinoColors.activeBlue),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor, width: 0.5),
                ),
                child: Text(
                  manifest.status.toUpperCase(),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(height: 0.5, color: separatorColor),
          const SizedBox(height: 8),
          _buildDetailRow('Pemasok', manifest.supplierName),
          const SizedBox(height: 4),
          _buildDetailRow('Tujuan', manifest.destinationWarehouseName ?? '-'),
          const SizedBox(height: 4),
          _buildDetailRow('Plat Pelayaran / Armada', manifest.plateNumber ?? '-'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: TextStyle(fontSize: 13, color: CupertinoColors.secondaryLabel.resolveFrom(context), fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 13, color: labelColor, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptFormFields(bool isWide) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: separatorColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Referensi Penerimaan',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
          ),
          const SizedBox(height: 12),
          if (isWide)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama Sopir', style: TextStyle(fontSize: 12, color: labelColor)),
                      const SizedBox(height: 6),
                      CupertinoTextField(
                        controller: _driverController,
                        placeholder: 'Nama Sopir Kontainer',
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nomor Plat Truk / Armada', style: TextStyle(fontSize: 12, color: labelColor)),
                      const SizedBox(height: 6),
                      CupertinoTextField(
                        controller: _truckController,
                        placeholder: 'L 1234 AB',
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ],
                  ),
                ),
              ],
            )
          else ...[
            Text('Nama Sopir', style: TextStyle(fontSize: 12, color: labelColor)),
            const SizedBox(height: 6),
            CupertinoTextField(
              controller: _driverController,
              placeholder: 'Nama Sopir Kontainer',
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            const SizedBox(height: 12),
            Text('Nomor Plat Truk / Armada', style: TextStyle(fontSize: 12, color: labelColor)),
            const SizedBox(height: 6),
            CupertinoTextField(
              controller: _truckController,
              placeholder: 'L 1234 AB',
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ],
          const SizedBox(height: 12),
          Text('Catatan Umum', style: TextStyle(fontSize: 12, color: labelColor)),
          const SizedBox(height: 6),
          CupertinoTextField(
            controller: _notesController,
            maxLines: 2,
            placeholder: 'Tambahkan catatan jika ada...',
            padding: const EdgeInsets.all(12),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(ReceivingContainerManifestItem item) {
    final remaining = item.plannedQty;
    final currentQty = _receivedQuantities[item.poDetailId] ?? 0.0;
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: separatorColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.productName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: labelColor),
          ),
          const SizedBox(height: 4),
          Text(
            'SKU: ${item.sku} • Unit: ${item.unit} • PO: ${item.poNumber}',
            style: TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoPill('Jml Rencana', remaining, CupertinoColors.secondaryLabel.resolveFrom(context)),
                _buildInfoPill('Penerimaan Saat Ini', currentQty, CupertinoColors.activeBlue),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: 36,
                      color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                      borderRadius: BorderRadius.circular(18),
                      onPressed: currentQty > 0
                          ? () {
                              setState(() {
                                _receivedQuantities[item.poDetailId] = (currentQty - 1).clamp(0.0, remaining);
                              });
                            }
                          : null,
                      child: const Icon(CupertinoIcons.minus, size: 16),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          currentQty.toStringAsFixed(0),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: labelColor),
                        ),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: 36,
                      color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                      borderRadius: BorderRadius.circular(18),
                      onPressed: currentQty < remaining
                          ? () {
                              setState(() {
                                _receivedQuantities[item.poDetailId] = (currentQty + 1).clamp(0.0, remaining);
                              });
                            }
                          : null,
                      child: const Icon(CupertinoIcons.plus, size: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minSize: 0,
                color: CupertinoColors.activeBlue.resolveFrom(context),
                borderRadius: BorderRadius.circular(8),
                onPressed: () {
                  setState(() {
                    _receivedQuantities[item.poDetailId] = remaining;
                  });
                },
                child: const Text('Terima Semua', style: TextStyle(fontSize: 12, color: CupertinoColors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPill(String label, double val, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: CupertinoColors.secondaryLabel.resolveFrom(context), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Text(
          val.toStringAsFixed(0),
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}

void _showTopNotification(BuildContext context, String message, {bool isError = false}) {
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isError ? CupertinoColors.destructiveRed : CupertinoColors.activeGreen,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x42000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isError ? CupertinoIcons.exclamationmark_circle : CupertinoIcons.check_mark_circled,
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
                    if (entry.mounted) {
                      entry.remove();
                    }
                  },
                  child: const Icon(CupertinoIcons.xmark, color: CupertinoColors.white, size: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);

  Future.delayed(const Duration(milliseconds: 2500), () {
    if (entry.mounted) {
      entry.remove();
    }
  });
}
