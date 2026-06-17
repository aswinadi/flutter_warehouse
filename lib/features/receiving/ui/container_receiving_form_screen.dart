import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/receiving.dart';
import '../providers/receiving_provider.dart';
import '../providers/receiving_repository.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';

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
      CupertinoGlassToast.showError(context, 'Silakan masukkan jumlah diterima minimal untuk satu item.');
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
        CupertinoGlassToast.showSuccess(context, 'Penerimaan Barang Kontainer berhasil dikirim!');
        if (widget.embed) {
          widget.onSubmitSuccess?.call();
        } else {
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        CupertinoGlassToast.showError(context, 'Gagal mengirim Penerimaan Barang Kontainer: $e');
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
        final isReadOnly = ['closed', 'shipped', 'arrived'].contains(manifest.status.toLowerCase());

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                children: [
                  _buildContainerDetailsCard(manifest),
                  const SizedBox(height: CupertinoSpacing.l),
                  _buildReceiptFormFields(isWide, isReadOnly),
                  const SizedBox(height: CupertinoSpacing.xxl),
                  Text(
                    'Barang yang Diterima dari Kontainer',
                    style: context.headline.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                  ),
                  const SizedBox(height: CupertinoSpacing.s),
                  ...manifest.items.map((item) => _buildItemRow(item, isReadOnly)),
                ],
              ),
            ),
            if (!isReadOnly)
              Container(
                padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                decoration: BoxDecoration(
                  color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                  border: Border(top: BorderSide(color: CupertinoColors.separator.resolveFrom(context), width: 0.5)),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: CupertinoSpacing.primaryButtonHeight,
                  child: CupertinoButton.filled(
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                    onPressed: _isSubmitting ? null : () => _submit(manifest),
                    child: _isSubmitting
                        ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                        : const Text(
                            'KIRIM PENERIMAAN KONTAINER',
                            style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.white),
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
        backgroundColor: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context).withValues(alpha: 0.96),
      ),
      child: SafeArea(child: content),
    );
  }

  Widget _buildContainerDetailsCard(ReceivingContainerManifest manifest) {
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    const statusColor = CupertinoColors.activeBlue;

    return CupertinoGlassContainer(
      borderRadius: CupertinoSpacing.cardRadius,
      padding: const EdgeInsets.all(CupertinoSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                manifest.containerNumber,
                style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: CupertinoColors.activeBlue),
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
                  style: context.caption2.copyWith(fontWeight: FontWeight.bold, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: CupertinoSpacing.s),
          Container(height: 0.5, color: separatorColor),
          const SizedBox(height: CupertinoSpacing.s),
          _buildDetailRow('Pemasok', manifest.supplierName),
          const SizedBox(height: CupertinoSpacing.xs),
          _buildDetailRow('Tujuan', manifest.destinationWarehouseName ?? '-'),
          const SizedBox(height: CupertinoSpacing.xs),
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
            style: context.footnote.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context), fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: context.footnote.copyWith(color: labelColor, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptFormFields(bool isWide, bool isReadOnly) {
    final labelColor = CupertinoColors.label.resolveFrom(context);

    return CupertinoGlassContainer(
      borderRadius: CupertinoSpacing.cardRadius,
      padding: const EdgeInsets.all(CupertinoSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Referensi Penerimaan',
            style: context.footnote.copyWith(fontWeight: FontWeight.bold, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
          ),
          const SizedBox(height: CupertinoSpacing.m),
          if (isWide)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama Sopir', style: context.caption1.copyWith(color: labelColor)),
                      const SizedBox(height: CupertinoSpacing.xs),
                      CupertinoTextField(
                        controller: _driverController,
                        readOnly: isReadOnly,
                        placeholder: 'Nama Sopir Kontainer',
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: CupertinoSpacing.l),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nomor Plat Truk / Armada', style: context.caption1.copyWith(color: labelColor)),
                      const SizedBox(height: CupertinoSpacing.xs),
                      CupertinoTextField(
                        controller: _truckController,
                        readOnly: isReadOnly,
                        placeholder: 'L 1234 AB',
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ],
                  ),
                ),
              ],
            )
          else ...[
            Text('Nama Sopir', style: context.caption1.copyWith(color: labelColor)),
            const SizedBox(height: CupertinoSpacing.xs),
            CupertinoTextField(
              controller: _driverController,
              readOnly: isReadOnly,
              placeholder: 'Nama Sopir Kontainer',
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            const SizedBox(height: CupertinoSpacing.m),
            Text('Nomor Plat Truk / Armada', style: context.caption1.copyWith(color: labelColor)),
            const SizedBox(height: CupertinoSpacing.xs),
            CupertinoTextField(
              controller: _truckController,
              readOnly: isReadOnly,
              placeholder: 'L 1234 AB',
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ],
          const SizedBox(height: CupertinoSpacing.m),
          Text('Catatan Umum', style: context.caption1.copyWith(color: labelColor)),
          const SizedBox(height: CupertinoSpacing.xs),
          CupertinoTextField(
            controller: _notesController,
            readOnly: isReadOnly,
            maxLines: 2,
            placeholder: 'Tambahkan catatan jika ada...',
            padding: const EdgeInsets.all(12),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(ReceivingContainerManifestItem item, bool isReadOnly) {
    final remaining = item.plannedQty;
    final currentQty = _receivedQuantities[item.poDetailId] ?? 0.0;
    final labelColor = CupertinoColors.label.resolveFrom(context);

    return Container(
      margin: const EdgeInsets.only(bottom: CupertinoSpacing.s),
      child: CupertinoGlassContainer(
        borderRadius: CupertinoSpacing.cardRadius,
        padding: const EdgeInsets.all(CupertinoSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.productName,
              style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: labelColor),
            ),
            const SizedBox(height: 4),
            Text(
              'SKU: ${item.sku} • Unit: ${item.unit} • PO: ${item.poNumber}',
              style: context.caption1.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
            ),
            const SizedBox(height: CupertinoSpacing.s),
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
            if (!isReadOnly) ...[
              const SizedBox(height: CupertinoSpacing.m),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(36, 36),
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
                              style: context.headline.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                            ),
                          ),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(36, 36),
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
                  const SizedBox(width: CupertinoSpacing.l),
                  SizedBox(
                    height: 36,
                    child: CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      color: CupertinoColors.activeBlue.resolveFrom(context),
                      borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                      onPressed: () {
                        setState(() {
                          _receivedQuantities[item.poDetailId] = remaining;
                        });
                      },
                      child: Text('Terima Semua', style: context.caption1.copyWith(color: CupertinoColors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPill(String label, double val, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: context.caption2.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Text(
          val.toStringAsFixed(0),
          style: context.caption1.copyWith(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
