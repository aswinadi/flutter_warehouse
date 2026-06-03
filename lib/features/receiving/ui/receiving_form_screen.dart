import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/receiving.dart';
import '../providers/receiving_provider.dart';
import '../providers/receiving_repository.dart';
import '../../purchase_order/models/purchase_order.dart';
import '../../purchase_order/providers/purchase_order_provider.dart';
import 'package:go_router/go_router.dart';

class ReceivingFormScreen extends ConsumerStatefulWidget {
  final int poId;
  final bool embed;
  final VoidCallback? onSubmitSuccess;

  const ReceivingFormScreen({
    super.key, 
    required this.poId, 
    this.embed = false,
    this.onSubmitSuccess,
  });

  @override
  ConsumerState<ReceivingFormScreen> createState() => _ReceivingFormScreenState();
}

class _ReceivingFormScreenState extends ConsumerState<ReceivingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _doController = TextEditingController();
  final _truckController = TextEditingController();
  final _notesController = TextEditingController();

  final Map<int, double> _receivedQuantities = {};
  final Map<int, String> _discrepancyTypes = {};
  final Map<int, String> _discrepancyNotes = {};
  final Map<int, double> _discrepancyQuantities = {};
  final Map<int, String?> _photoPaths = {};
  final Map<int, String?> _photoLocalPaths = {};
  final Map<int, bool> _isUploadingPhoto = {};

  bool _isSubmitting = false;
  bool _initialized = false;

  @override
  void dispose() {
    _doController.dispose();
    _truckController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _initializeValues(PurchaseOrder po) {
    if (_initialized) return;
    for (final item in po.items) {
      _receivedQuantities[item.id] = item.remainingQty;
      _discrepancyTypes[item.id] = 'none';
      _discrepancyNotes[item.id] = '';
      _discrepancyQuantities[item.id] = 0.0;
      _photoPaths[item.id] = null;
      _photoLocalPaths[item.id] = null;
      _isUploadingPhoto[item.id] = false;
    }
    _initialized = true;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Check if at least one item has received qty > 0
    final hasQty = _receivedQuantities.values.any((qty) => qty > 0);
    if (!hasQty) {
      _showTopNotification(context, 'Silakan masukkan jumlah diterima minimal untuk satu item.', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final poDetailAsync = ref.read(receivingPODetailProvider(widget.poId));
      final po = poDetailAsync.value;
      if (po == null) throw Exception('Purchase Order details not loaded');

      final items = <ReceivingItemRequest>[];
      for (final poItem in po.items) {
        final qty = _receivedQuantities[poItem.id] ?? 0.0;
        if (qty > 0) {
          final discrepancyType = _discrepancyTypes[poItem.id] ?? 'none';
          final isDiscrepant = discrepancyType == 'damaged' || discrepancyType == 'wrong_item';
          final dQty = isDiscrepant ? (_discrepancyQuantities[poItem.id] ?? 0.0) : 0.0;
          final photoPath = isDiscrepant ? _photoPaths[poItem.id] : null;

          items.add(ReceivingItemRequest(
            poDetailId: poItem.id,
            receivedQty: qty,
            version: poItem.version,
            discrepancyType: discrepancyType,
            discrepancyNote: _discrepancyNotes[poItem.id]?.isNotEmpty == true 
                ? _discrepancyNotes[poItem.id] 
                : null,
            discrepancyQty: dQty > 0 ? dQty : null,
            photoPath: photoPath,
          ));
        }
      }

      final request = CreateReceivingRequest(
        poHeaderId: widget.poId,
        deliveryOrderNumber: _doController.text.trim().isNotEmpty ? _doController.text.trim() : null,
        truckNumber: _truckController.text.trim().isNotEmpty ? _truckController.text.trim() : null,
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
        items: items,
      );

      final repo = ref.read(receivingRepositoryProvider);
      await repo.createReceiving(request);

      ref.invalidate(receivingsHistoryProvider);
      ref.invalidate(purchaseOrdersProvider);
      ref.invalidate(receivingPODetailProvider(widget.poId));

      if (mounted) {
        _showTopNotification(context, 'Penerimaan Barang berhasil dikirim!');
        if (widget.embed) {
          widget.onSubmitSuccess?.call();
        } else {
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        _showTopNotification(context, 'Gagal mengirim Penerimaan Barang: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _pickAndUploadImage(int itemId) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil Foto'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
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
      imageQuality: 85,
    );

    if (pickedFile == null) return;

    setState(() {
      _isUploadingPhoto[itemId] = true;
    });

    try {
      final repository = ref.read(receivingRepositoryProvider);
      final uploadedPath = await repository.uploadPhoto(pickedFile.path);

      setState(() {
        _photoPaths[itemId] = uploadedPath;
        _photoLocalPaths[itemId] = pickedFile.path;
      });
    } catch (e) {
      if (mounted) {
        _showTopNotification(context, 'Gagal mengunduh foto: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingPhoto[itemId] = false;
        });
      }
    }
  }

  Widget _buildPhotoUploadWidget(int itemId) {
    final isUploading = _isUploadingPhoto[itemId] ?? false;
    final photoPath = _photoPaths[itemId];
    final localPath = _photoLocalPaths[itemId];

    if (isUploading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 8),
            Text('Mengunggah...', style: TextStyle(fontSize: 12)),
          ],
        ),
      );
    }

    if (photoPath != null && localPath != null) {
      return Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.file(
              File(localPath),
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 4),
          const Expanded(
            child: Text(
              'Terunggah',
              style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 18),
            onPressed: () {
              setState(() {
                _photoPaths[itemId] = null;
                _photoLocalPaths[itemId] = null;
              });
            },
          ),
        ],
      );
    }

    return OutlinedButton.icon(
      onPressed: () => _pickAndUploadImage(itemId),
      icon: const Icon(Icons.camera_alt, size: 16),
      label: const Text('Unggah Foto', style: TextStyle(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final poAsync = ref.watch(receivingPODetailProvider(widget.poId));
    final isWide = MediaQuery.of(context).size.width > 900;

    final content = poAsync.when(
      data: (po) {
        _initializeValues(po);

        return Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildPODetailsCard(po),
                    const SizedBox(height: 16),
                    _buildReceiptFormFields(isWide),
                    const SizedBox(height: 24),
                    const Text(
                      'Barang yang Diterima',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 8),
                    ...po.items.map((item) => _buildItemRow(item)),
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
                  onPressed: _isSubmitting ? null : _submit,
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
                      : const Text('KIRIM PENERIMAAN BARANG', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Gagal memuat detail PO: $err')),
    );

    if (widget.embed) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Penerimaan Barang Baru'),
      ),
      body: content,
    );
  }

  Widget _buildPODetailsCard(PurchaseOrder po) {
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
                po.poNumber,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF4F46E5)),
              ),
              Text(
                po.transactionDate,
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 8),
          _buildDetailRow('Pemasok', po.supplierName),
          const SizedBox(height: 4),
          _buildDetailRow('Gudang', po.warehouseName ?? '-'),
          const SizedBox(height: 4),
          _buildDetailRow('Estimasi Tiba', po.expectedDate),
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
                    controller: _doController,
                    decoration: const InputDecoration(
                      labelText: 'Nomor Surat Jalan (DO) *',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nomor Surat Jalan wajib diisi';
                      }
                      return null;
                    },
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
              controller: _doController,
              decoration: const InputDecoration(
                labelText: 'Nomor Surat Jalan (DO) *',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nomor Surat Jalan wajib diisi';
                }
                return null;
              },
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

  Widget _buildItemRow(PurchaseOrderItem item) {
    final remaining = item.remainingQty;
    final currentQty = _receivedQuantities[item.id] ?? 0.0;
    final discrepancyType = _discrepancyTypes[item.id] ?? 'none';

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
            'SKU: ${item.sku} • Unit: ${item.unit}',
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
                _buildInfoPill('Dipesan', item.orderedQty, const Color(0xFF64748B)),
                _buildInfoPill('Diterima', item.receivedQty, const Color(0xFF10B981)),
                _buildInfoPill('Sisa', remaining, const Color(0xFFF59E0B)),
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
                                _receivedQuantities[item.id] = (currentQty - 1).clamp(0, remaining);
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
                                _receivedQuantities[item.id] = (currentQty + 1).clamp(0, remaining);
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
                    _receivedQuantities[item.id] = remaining;
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
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Ketidaksesuaian',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: discrepancyType,
                      isExpanded: true,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
                      items: const [
                        DropdownMenuItem(value: 'none', child: Text('Tidak Ada')),
                        DropdownMenuItem(value: 'damaged', child: Text('Barang Rusak')),
                        DropdownMenuItem(value: 'missing', child: Text('Barang Kurang')),
                        DropdownMenuItem(value: 'wrong_item', child: Text('Barang Salah')),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _discrepancyTypes[item.id] = val ?? 'none';
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (discrepancyType != 'none') ...[
            const SizedBox(height: 8),
            if (discrepancyType == 'damaged' || discrepancyType == 'wrong_item') ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: (_discrepancyQuantities[item.id] ?? 0.0) > 0 
                          ? _discrepancyQuantities[item.id]!.toStringAsFixed(0) 
                          : '',
                      decoration: const InputDecoration(
                        labelText: 'Jml Ketidaksesuaian *',
                        hintText: 'Qty',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(fontSize: 13),
                      validator: (val) {
                        final dQty = double.tryParse(val ?? '') ?? 0.0;
                        if (dQty <= 0) {
                           return 'Harus > 0';
                        }
                        if (dQty > currentQty) {
                           return 'Melebihi jml diterima';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          _discrepancyQuantities[item.id] = double.tryParse(val) ?? 0.0;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Center(
                      child: _buildPhotoUploadWidget(item.id),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            TextFormField(
              initialValue: _discrepancyNotes[item.id] ?? '',
              decoration: const InputDecoration(
                hintText: 'Masukkan penjelasan ketidaksesuaian...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              style: const TextStyle(fontSize: 13),
              onChanged: (val) {
                _discrepancyNotes[item.id] = val.trim();
              },
            ),
          ],
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
