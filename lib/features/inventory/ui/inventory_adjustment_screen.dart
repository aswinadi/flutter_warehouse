import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:dio/dio.dart';
import '../models/inventory.dart';
import '../providers/inventory_provider.dart';
import '../providers/inventory_adjustment_repository.dart';
import '../../../core/widgets/company_switcher.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';

class InventoryAdjustmentScreen extends ConsumerStatefulWidget {
  final Inventory? prefilledItem;

  const InventoryAdjustmentScreen({super.key, this.prefilledItem});

  @override
  ConsumerState<InventoryAdjustmentScreen> createState() => _InventoryAdjustmentScreenState();
}

class _InventoryAdjustmentScreenState extends ConsumerState<InventoryAdjustmentScreen> {
  final _qtyController = TextEditingController();
  final _notesController = TextEditingController();
  final _searchController = TextEditingController();

  Inventory? _selectedItem;
  String _reasonType = 'usage'; // default to Pemakaian
  XFile? _photoFile;
  bool _isLoadingItem = false;
  bool _isSubmitting = false;
  String? _itemErrorMessage;
  String? _qtyErrorMessage;

  final Map<String, String> _reasons = {
    'usage': 'Pemakaian Umum (General Usage)',
    'lost': 'Kehilangan (Lost)',
    'breakage': 'Kerusakan (Breakage)',
    'dispose': 'Pembuangan (Dispose)',
  };

  @override
  void initState() {
    super.initState();
    if (widget.prefilledItem != null) {
      _selectedItem = widget.prefilledItem;
    }
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _notesController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _lookupItem(String barcodeCode) async {
    if (barcodeCode.trim().isEmpty) return;
    setState(() {
      _isLoadingItem = true;
      _itemErrorMessage = null;
    });

    try {
      final repository = ref.read(inventoryRepositoryProvider);
      final item = await repository.getInventoryByBarcode(barcodeCode.trim());
      setState(() {
        _selectedItem = item;
        _qtyController.clear();
        _qtyErrorMessage = null;
      });
    } catch (e) {
      String message = e.toString();
      if (e is DioException) {
        final response = e.response;
        if (response != null && response.data is Map) {
          final errorData = response.data['error'];
          if (errorData != null && errorData['message'] != null) {
            message = errorData['message'].toString();
          }
        }
      }
      setState(() {
        _itemErrorMessage = 'Barang tidak ditemukan: $message';
      });
    } finally {
      setState(() {
        _isLoadingItem = false;
      });
    }
  }

  Future<void> _scanBarcode() async {
    final barcode = await showCupertinoModalPopup<String>(
      context: context,
      builder: (context) => const BarcodeScannerBottomSheet(),
    );

    if (barcode != null && barcode.isNotEmpty) {
      final cleanCode = _extractAssetCode(barcode);
      _lookupItem(cleanCode);
    }
  }

  String _extractAssetCode(String rawCode) {
    final trimmed = rawCode.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      try {
        final uri = Uri.parse(trimmed);
        if (uri.pathSegments.contains('verify')) {
          final verifyIndex = uri.pathSegments.indexOf('verify');
          if (verifyIndex != -1 && verifyIndex + 1 < uri.pathSegments.length) {
            return uri.pathSegments[verifyIndex + 1];
          }
        }
        if (uri.pathSegments.isNotEmpty) {
          return uri.pathSegments.lastWhere((seg) => seg.isNotEmpty, orElse: () => trimmed);
        }
      } catch (_) {}
    }
    return trimmed;
  }

  Future<void> _pickImage() async {
    final source = await showCupertinoModalPopup<ImageSource>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Pilih Sumber Foto'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text('Ambil Foto dari Kamera'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text('Pilih Foto dari Galeri'),
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
    final image = await picker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _photoFile = image;
      });
    }
  }

  void _showReasonPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Pilih Tipe Penyesuaian'),
        actions: _reasons.entries.map((entry) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _reasonType = entry.key;
              });
              Navigator.pop(context);
            },
            child: Text(entry.value),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_selectedItem == null) {
      CupertinoGlassToast.showError(context, 'Silakan pilih atau pindai barang terlebih dahulu.');
      return;
    }

    final qtyText = _qtyController.text.trim();
    if (qtyText.isEmpty) {
      setState(() {
        _qtyErrorMessage = 'Jumlah wajib diisi';
      });
      return;
    }

    final parsedQty = double.tryParse(qtyText);
    if (parsedQty == null) {
      setState(() {
        _qtyErrorMessage = 'Masukkan angka desimal yang valid';
      });
      return;
    }

    if (parsedQty <= 0) {
      setState(() {
        _qtyErrorMessage = 'Jumlah harus lebih besar dari 0';
      });
      return;
    }

    if (parsedQty > _selectedItem!.quantity) {
      setState(() {
        _qtyErrorMessage = 'Jumlah melebihi stok yang tersedia (${_selectedItem!.quantity.toStringAsFixed(1)})';
      });
      return;
    }

    setState(() {
      _qtyErrorMessage = null;
      _isSubmitting = true;
    });

    try {
      final repository = ref.read(inventoryAdjustmentRepositoryProvider);

      await repository.adjustStock(
        inventoryId: _selectedItem!.id,
        quantity: parsedQty,
        reasonType: _reasonType,
        notes: _notesController.text.trim(),
        photoFile: _photoFile,
      );

      CupertinoGlassToast.showSuccess(context, 'Penyesuaian stok berhasil dikirim!');
      ref.invalidate(inventoryRepositoryProvider);
      
      if (mounted) {
        if (widget.prefilledItem != null) {
          context.pop();
        } else {
          setState(() {
            _selectedItem = null;
            _qtyController.clear();
            _notesController.clear();
            _photoFile = null;
            _qtyErrorMessage = null;
          });
        }
      }
    } catch (e) {
      CupertinoGlassToast.showError(context, 'Gagal mengirim penyesuaian: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double maxLayoutWidth;
    if (screenWidth > 1200) {
      maxLayoutWidth = 650;
    } else if (screenWidth > 800) {
      maxLayoutWidth = 600;
    } else if (screenWidth > 600) {
      maxLayoutWidth = 500;
    } else {
      maxLayoutWidth = double.infinity;
    }

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Penyesuaian & Pemakaian'),
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxLayoutWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const CompanySwitcher(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildItemSelectionCard(),
                        const SizedBox(height: CupertinoSpacing.l),
                        if (_selectedItem != null) _buildAdjustmentFormCard(),
                      ],
                    ),
                  ),
                ),
                if (_selectedItem != null)
                  CupertinoGlassContainer(
                    borderRadius: 0,
                    padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                    child: SizedBox(
                      width: double.infinity,
                      child: CupertinoButton.filled(
                        onPressed: _isSubmitting ? null : _submit,
                        child: _isSubmitting
                            ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                            : const Text(
                                'Kirim Penyesuaian Stok',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemSelectionCard() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobileNarrow = screenWidth < 400;
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    const primaryAccent = Color(0xFF6E56CF);

    return CupertinoGlassContainer(
      padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Informasi Barang',
            style: context.headline.copyWith(fontWeight: FontWeight.bold, color: labelColor),
          ),
          const SizedBox(height: CupertinoSpacing.l),
          if (_selectedItem == null) ...[
            CupertinoButton(
              color: primaryAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              onPressed: _scanBarcode,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.qrcode_viewfinder, color: primaryAccent, size: 20),
                  SizedBox(width: CupertinoSpacing.s),
                  Text('PINDAI BARCODE BARANG', style: TextStyle(color: primaryAccent, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: CupertinoSpacing.l),
            Row(
              children: [
                Expanded(child: Container(height: 0.5, color: separatorColor)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.m),
                  child: Text('ATAU CARI MANUAL', style: context.caption2.copyWith(color: secondaryLabel)),
                ),
                Expanded(child: Container(height: 0.5, color: separatorColor)),
              ],
            ),
            const SizedBox(height: CupertinoSpacing.l),
            if (isMobileNarrow) ...[
              CupertinoTextField(
                controller: _searchController,
                placeholder: 'Masukkan Barcode atau SKU...',
                onSubmitted: (val) => _lookupItem(val),
              ),
              const SizedBox(height: CupertinoSpacing.m),
              CupertinoButton(
                color: CupertinoColors.activeBlue,
                onPressed: _isLoadingItem ? null : () => _lookupItem(_searchController.text),
                child: _isLoadingItem
                    ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                    : const Text('Cari'),
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: CupertinoTextField(
                      controller: _searchController,
                      placeholder: 'Masukkan Barcode atau SKU...',
                      onSubmitted: (val) => _lookupItem(val),
                    ),
                  ),
                  const SizedBox(width: CupertinoSpacing.m),
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.xxl),
                    color: CupertinoColors.activeBlue,
                    onPressed: _isLoadingItem ? null : () => _lookupItem(_searchController.text),
                    child: _isLoadingItem
                        ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                        : const Text('Cari'),
                  ),
                ],
              ),
            ],
            if (_itemErrorMessage != null) ...[
              const SizedBox(height: CupertinoSpacing.m),
              Text(
                _itemErrorMessage!,
                style: context.footnote.copyWith(color: CupertinoColors.destructiveRed),
              ),
            ],
          ] else ...[
            CupertinoGlassContainer(
              borderRadius: 8,
              padding: const EdgeInsets.all(CupertinoSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          _selectedItem!.productName ?? 'Unknown Product',
                          style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                        ),
                      ),
                      if (widget.prefilledItem == null)
                        GestureDetector(
                          onTap: () => setState(() => _selectedItem = null),
                          child: Text('Ganti', style: context.subhead.copyWith(color: primaryAccent, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                  const SizedBox(height: CupertinoSpacing.xs),
                  Text(
                    'SKU: ${_selectedItem!.sku}',
                    style: context.footnote.copyWith(color: secondaryLabel),
                  ),
                  const SizedBox(height: CupertinoSpacing.xs),
                  Text(
                    'Gudang: ${_selectedItem!.warehouseName ?? "-"} • Lokasi: ${_selectedItem!.locationCode ?? "-"}',
                    style: context.footnote.copyWith(color: secondaryLabel),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.m),
                    child: Container(height: 0.5, color: separatorColor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Stok Tersedia Saat Ini:',
                        style: context.footnote.copyWith(fontWeight: FontWeight.w500, color: secondaryLabel),
                      ),
                      Text(
                        '${_selectedItem!.quantity.toStringAsFixed(1)} ${_selectedItem!.unit ?? "PCS"}',
                        style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: primaryAccent),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAdjustmentFormCard() {
    final currentItem = _selectedItem!;
    final unit = currentItem.unit ?? 'PCS';
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return CupertinoGlassContainer(
      padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Detail Transaksi',
            style: context.headline.copyWith(fontWeight: FontWeight.bold, color: labelColor),
          ),
          const SizedBox(height: CupertinoSpacing.l),
          
          // Reason Type Selector
          Text('Tipe Penyesuaian / Pemakaian *', style: context.caption1.copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(height: CupertinoSpacing.s),
          GestureDetector(
            onTap: _showReasonPicker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.m, vertical: CupertinoSpacing.m),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground.resolveFrom(context),
                border: Border.all(color: separatorColor, width: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_reasons[_reasonType] ?? '', style: context.subhead.copyWith(color: labelColor)),
                  Icon(CupertinoIcons.chevron_down, size: 14, color: secondaryLabel),
                ],
              ),
            ),
          ),
          const SizedBox(height: CupertinoSpacing.l),

          // Quantity Input
          Text('Jumlah yang Disesuaikan *', style: context.caption1.copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(height: CupertinoSpacing.s),
          CupertinoTextField(
            controller: _qtyController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            placeholder: 'Contoh: 10',
            suffix: Padding(
              padding: const EdgeInsets.only(right: CupertinoSpacing.m),
              child: Text(unit, style: TextStyle(color: secondaryLabel)),
            ),
          ),
          if (_qtyErrorMessage != null) ...[
            const SizedBox(height: CupertinoSpacing.xs),
            Text(
              _qtyErrorMessage!,
              style: context.caption1.copyWith(color: CupertinoColors.destructiveRed),
            ),
          ],
          const SizedBox(height: CupertinoSpacing.l),

          // Notes Input
          Text('Keterangan / Notes', style: context.caption1.copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(height: CupertinoSpacing.s),
          CupertinoTextField(
            controller: _notesController,
            maxLines: 3,
            placeholder: 'Tuliskan alasan penyesuaian...',
          ),
          const SizedBox(height: CupertinoSpacing.l),

          // Photo Picker Section
          _buildPhotoPickerSection(),
        ],
      ),
    );
  }

  Widget _buildPhotoPickerSection() {
    const primaryAccent = Color(0xFF6E56CF);

    if (_photoFile != null) {
      return CupertinoGlassContainer(
        borderRadius: 8,
        padding: const EdgeInsets.all(CupertinoSpacing.m),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.file(
                File(_photoFile!.path),
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: CupertinoSpacing.m),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Foto Terlampir',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Siap diunggah',
                    style: TextStyle(color: CupertinoColors.activeGreen, fontSize: 12),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _photoFile = null;
                });
              },
              child: const Icon(CupertinoIcons.trash, color: CupertinoColors.destructiveRed, size: 20),
            ),
          ],
        ),
      );
    }

    return CupertinoButton(
      color: primaryAccent.withValues(alpha: 0.1),
      onPressed: _pickImage,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.camera, color: primaryAccent, size: 18),
          SizedBox(width: CupertinoSpacing.s),
          Text('LAMPIRKAN FOTO BUKTI (OPSIONAL)', style: TextStyle(color: primaryAccent, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}

class BarcodeScannerBottomSheet extends StatefulWidget {
  const BarcodeScannerBottomSheet({super.key});

  @override
  State<BarcodeScannerBottomSheet> createState() => _BarcodeScannerBottomSheetState();
}

class _BarcodeScannerBottomSheetState extends State<BarcodeScannerBottomSheet> {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );
  bool _isCameraActive = true;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480,
      decoration: const BoxDecoration(
        color: CupertinoColors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: MobileScanner(
              controller: _scannerController,
              onDetect: (capture) {
                if (!_isCameraActive) return;
                final barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  final code = barcodes.first.rawValue;
                  if (code != null && code.isNotEmpty) {
                    setState(() => _isCameraActive = false);
                    Navigator.pop(context, code);
                  }
                }
              },
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: CupertinoColors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(CupertinoIcons.xmark, color: CupertinoColors.white, size: 20),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF6E56CF), width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const Positioned(
            bottom: CupertinoSpacing.xxxl,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Posisikan Barcode / QR Code di dalam kotak',
                style: TextStyle(color: CupertinoColors.systemGrey3, fontSize: 13, fontWeight: FontWeight.bold, decoration: TextDecoration.none),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
