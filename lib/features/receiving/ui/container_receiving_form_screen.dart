import 'package:flutter/material.dart';
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
  final _formKey = GlobalKey<FormState>();
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
    if (!_formKey.currentState!.validate()) return;

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

    final content = manifestAsync.when(
      data: (manifest) {
        _initializeValues(manifest);

        return Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildContainerDetailsCard(manifest),
                    const SizedBox(height: 16),
                    _buildReceiptFormFields(isWide),
                    const SizedBox(height: 24),
                    const Text(
                      'Barang yang Diterima dari Kontainer',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 8),
                    ...manifest.items.map((item) => _buildItemRow(item)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                ),
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : () => _submit(manifest),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('KIRIM PENERIMAAN KONTAINER', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Gagal memuat manifest kontainer: $err')),
    );

    if (widget.embed) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Penerimaan Barang Kontainer'),
      ),
      body: content,
    );
  }

  Widget _buildContainerDetailsCard(ReceivingContainerManifest manifest) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                manifest.containerNumber,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF4F46E5)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF3B82F6), width: 0.8),
                ),
                child: Text(
                  manifest.status.toUpperCase(),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF3B82F6)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B), fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptFormFields(bool isWide) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Referensi Penerimaan',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
          ),
          const SizedBox(height: 12),
          if (isWide)
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _driverController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Sopir',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _truckController,
                    decoration: const InputDecoration(
                      labelText: 'Nomor Plat Truk / Armada',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ],
            )
          else ...[
            TextFormField(
              controller: _driverController,
              decoration: const InputDecoration(
                labelText: 'Nama Sopir',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _truckController,
              decoration: const InputDecoration(
                labelText: 'Nomor Plat Truk / Armada',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
          const SizedBox(height: 12),
          TextFormField(
            controller: _notesController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Catatan Umum',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(ReceivingContainerManifestItem item) {
    final remaining = item.plannedQty;
    final currentQty = _receivedQuantities[item.poDetailId] ?? 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.productName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 4),
          Text(
            'SKU: ${item.sku} • Unit: ${item.unit} • PO: ${item.poNumber}',
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoPill('Jml Rencana', remaining, const Color(0xFF64748B)),
                _buildInfoPill('Penerimaan Saat Ini', currentQty, const Color(0xFF4F46E5)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: currentQty > 0
                          ? () {
                              setState(() {
                                _receivedQuantities[item.poDetailId] = (currentQty - 1).clamp(0, remaining);
                              });
                            }
                          : null,
                      icon: const Icon(Icons.remove, size: 16),
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(36, 36),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          currentQty.toStringAsFixed(0),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: currentQty < remaining
                          ? () {
                              setState(() {
                                _receivedQuantities[item.poDetailId] = (currentQty + 1).clamp(0, remaining);
                              });
                            }
                          : null,
                      icon: const Icon(Icons.add, size: 16),
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(36, 36),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _receivedQuantities[item.poDetailId] = remaining;
                  });
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF4F46E5),
                  side: const BorderSide(color: Color(0xFF4F46E5)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                child: const Text('Terima Semua'),
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
          style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
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
          child: Material(
            color: Colors.transparent,
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
                  color: isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isError ? Icons.error_outline : Icons.check_circle_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        if (entry.mounted) {
                          entry.remove();
                        }
                      },
                      child: const Icon(Icons.close, color: Colors.white, size: 18),
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

  Future.delayed(const Duration(milliseconds: 2500), () {
    if (entry.mounted) {
      entry.remove();
    }
  });
}
