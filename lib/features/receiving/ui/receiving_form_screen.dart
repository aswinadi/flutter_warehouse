import 'dart:io';
import 'package:flutter/cupertino.dart';
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
    // DO Number Validation
    if (_doController.text.trim().isEmpty) {
      _showTopNotification(context, 'Nomor Surat Jalan wajib diisi', isError: true);
      return;
    }

    // Check if at least one item has received qty > 0
    final hasQty = _receivedQuantities.values.any((qty) => qty > 0);
    if (!hasQty) {
      _showTopNotification(context, 'Silakan masukkan jumlah diterima minimal untuk satu item.', isError: true);
      return;
    }

    // Validate discrepancies
    final poDetailAsync = ref.read(receivingPODetailProvider(widget.poId));
    final po = poDetailAsync.value;
    if (po == null) {
      _showTopNotification(context, 'Detail Purchase Order belum dimuat', isError: true);
      return;
    }

    for (final poItem in po.items) {
      final qty = _receivedQuantities[poItem.id] ?? 0.0;
      if (qty > 0) {
        final discrepancyType = _discrepancyTypes[poItem.id] ?? 'none';
        final isDiscrepant = discrepancyType == 'damaged' || discrepancyType == 'wrong_item';
        final dQty = isDiscrepant ? (_discrepancyQuantities[poItem.id] ?? 0.0) : 0.0;

        if (isDiscrepant) {
          if (dQty <= 0) {
            _showTopNotification(context, 'Jumlah ketidaksesuaian untuk ${poItem.productName} harus lebih besar dari 0.', isError: true);
            return;
          }
          if (dQty > qty) {
            _showTopNotification(context, 'Jumlah ketidaksesuaian untuk ${poItem.productName} tidak boleh melebihi jumlah diterima.', isError: true);
            return;
          }
        }
      }
    }

    setState(() => _isSubmitting = true);

    try {
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
    final source = await showCupertinoModalPopup<ImageSource>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Pilih Foto'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text('Ambil Foto'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text('Pilih dari Galeri'),
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
        _showTopNotification(context, 'Gagal mengunggah foto: $e', isError: true);
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
            CupertinoActivityIndicator(),
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
          const Icon(CupertinoIcons.checkmark_circle_fill, color: CupertinoColors.activeGreen, size: 16),
          const SizedBox(width: 4),
          const Expanded(
            child: Text(
              'Terunggah',
              style: TextStyle(fontSize: 12, color: CupertinoColors.activeGreen, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            minSize: 0,
            onPressed: () {
              setState(() {
                _photoPaths[itemId] = null;
                _photoLocalPaths[itemId] = null;
              });
            },
            child: const Icon(CupertinoIcons.trash, color: CupertinoColors.destructiveRed, size: 18),
          ),
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: CupertinoColors.activeBlue.resolveFrom(context), width: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minSize: 0,
        onPressed: () => _pickAndUploadImage(itemId),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.camera, size: 14),
            SizedBox(width: 6),
            Text('Unggah Foto', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final poAsync = ref.watch(receivingPODetailProvider(widget.poId));
    final isWide = MediaQuery.of(context).size.width > 900;
    final bgColor = CupertinoColors.systemGroupedBackground.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);

    final content = poAsync.when(
      data: (po) {
        _initializeValues(po);

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildPODetailsCard(po),
                  const SizedBox(height: 16),
                  _buildReceiptFormFields(isWide),
                  const SizedBox(height: 24),
                  Text(
                    'Barang yang Diterima',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: labelColor),
                  ),
                  const SizedBox(height: 8),
                  ...po.items.map((item) => _buildItemRow(item)),
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
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                      : const Text(
                          'KIRIM PENERIMAAN BARANG',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: CupertinoColors.white),
                        ),
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (err, _) => Center(child: Text('Gagal memuat detail PO: $err')),
    );

    if (widget.embed) {
      return content;
    }

    return CupertinoPageScaffold(
      backgroundColor: bgColor,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Penerimaan Barang Baru'),
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
      ),
      child: SafeArea(child: content),
    );
  }

  Widget _buildPODetailsCard(PurchaseOrder po) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                po.poNumber,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: CupertinoColors.activeBlue),
              ),
              Text(
                po.transactionDate,
                style: TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(height: 0.5, color: separatorColor),
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
                      Text('Nomor Surat Jalan (DO) *', style: TextStyle(fontSize: 12, color: labelColor)),
                      const SizedBox(height: 6),
                      CupertinoTextField(
                        controller: _doController,
                        placeholder: 'DO/xxx/xxxx',
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
                        placeholder: 'B 1234 XX',
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ],
                  ),
                ),
              ],
            )
          else ...[
            Text('Nomor Surat Jalan (DO) *', style: TextStyle(fontSize: 12, color: labelColor)),
            const SizedBox(height: 6),
            CupertinoTextField(
              controller: _doController,
              placeholder: 'DO/xxx/xxxx',
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            const SizedBox(height: 12),
            Text('Nomor Plat Truk / Armada', style: TextStyle(fontSize: 12, color: labelColor)),
            const SizedBox(height: 6),
            CupertinoTextField(
              controller: _truckController,
              placeholder: 'B 1234 XX',
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

  Widget _buildItemRow(PurchaseOrderItem item) {
    final remaining = item.remainingQty;
    final currentQty = _receivedQuantities[item.id] ?? 0.0;
    final discrepancyType = _discrepancyTypes[item.id] ?? 'none';
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
            'SKU: ${item.sku} • Unit: ${item.unit}',
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
                _buildInfoPill('Dipesan', item.orderedQty, CupertinoColors.secondaryLabel.resolveFrom(context)),
                _buildInfoPill('Diterima', item.receivedQty, CupertinoColors.activeGreen),
                _buildInfoPill('Sisa', remaining, CupertinoColors.systemOrange),
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
                                _receivedQuantities[item.id] = (currentQty - 1).clamp(0.0, remaining);
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
                                _receivedQuantities[item.id] = (currentQty + 1).clamp(0.0, remaining);
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
                    _receivedQuantities[item.id] = remaining;
                  });
                },
                child: const Text('Terima Semua', style: TextStyle(fontSize: 12, color: CupertinoColors.white)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(height: 0.5, color: separatorColor),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Ketidaksesuaian',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showCupertinoModalPopup<String>(
                      context: context,
                      builder: (BuildContext context) => CupertinoActionSheet(
                        title: const Text('Pilih Ketidaksesuaian'),
                        actions: <CupertinoActionSheetAction>[
                          CupertinoActionSheetAction(
                            onPressed: () => Navigator.pop(context, 'none'),
                            child: const Text('Tidak Ada'),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () => Navigator.pop(context, 'damaged'),
                            child: const Text('Barang Rusak'),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () => Navigator.pop(context, 'missing'),
                            child: const Text('Barang Kurang'),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () => Navigator.pop(context, 'wrong_item'),
                            child: const Text('Barang Salah'),
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          isDefaultAction: true,
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Batal'),
                        ),
                      ),
                    ).then((val) {
                      if (val != null) {
                        setState(() {
                          _discrepancyTypes[item.id] = val;
                        });
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: separatorColor, width: 0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _getDiscrepancyName(discrepancyType),
                          style: TextStyle(fontSize: 13, color: labelColor),
                        ),
                        const Icon(CupertinoIcons.chevron_down, size: 14, color: CupertinoColors.inactiveGray),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (discrepancyType != 'none') ...[
            const SizedBox(height: 12),
            if (discrepancyType == 'damaged' || discrepancyType == 'wrong_item') ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Jml Ketidaksesuaian *', style: TextStyle(fontSize: 11, color: labelColor)),
                        const SizedBox(height: 4),
                        CupertinoTextField(
                          placeholder: 'Qty',
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (val) {
                            setState(() {
                              _discrepancyQuantities[item.id] = double.tryParse(val) ?? 0.0;
                            });
                          },
                        ),
                      ],
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
            Text('Penjelasan Ketidaksesuaian', style: TextStyle(fontSize: 11, color: labelColor)),
            const SizedBox(height: 4),
            CupertinoTextField(
              placeholder: 'Masukkan penjelasan ketidaksesuaian...',
              onChanged: (val) {
                _discrepancyNotes[item.id] = val.trim();
              },
            ),
          ],
        ],
      ),
    );
  }

  String _getDiscrepancyName(String type) {
    switch (type) {
      case 'damaged':
        return 'Barang Rusak';
      case 'missing':
        return 'Barang Kurang';
      case 'wrong_item':
        return 'Barang Salah';
      default:
        return 'Tidak Ada';
    }
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
