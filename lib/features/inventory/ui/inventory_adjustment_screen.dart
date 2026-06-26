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
  final bool isUsageMode;

  const InventoryAdjustmentScreen({
    super.key,
    this.prefilledItem,
    required this.isUsageMode,
  });

  @override
  ConsumerState<InventoryAdjustmentScreen> createState() => _InventoryAdjustmentScreenState();
}

class _InventoryAdjustmentScreenState extends ConsumerState<InventoryAdjustmentScreen> {
  final _qtyController = TextEditingController();
  final _notesController = TextEditingController();
  final _searchController = TextEditingController();
  final _unitCostController = TextEditingController();

  Inventory? _selectedItem;
  String _reasonType = 'usage'; // default to Pemakaian
  String _adjustmentAction = 'out'; // 'out', 'in', 'value_only'
  String _adjustmentMode = 'qty_only'; // 'qty_only', 'qty_and_value'
  XFile? _photoFile;
  bool _isLoadingItem = false;
  bool _isSubmitting = false;
  String? _itemErrorMessage;
  String? _qtyErrorMessage;
  String? _unitCostErrorMessage;

  final Map<String, String> _reasons = {
    'usage': 'Pemakaian Umum (General Usage)',
    'lost': 'Kehilangan (Lost)',
    'breakage': 'Kerusakan (Breakage)',
    'dispose': 'Pembuangan (Dispose)',
    'correction': 'Koreksi Stok (Correction)',
  };

  @override
  void initState() {
    super.initState();
    if (widget.prefilledItem != null) {
      _selectedItem = widget.prefilledItem;
    }
    if (widget.isUsageMode) {
      _reasonType = 'usage';
      _adjustmentAction = 'out';
      _adjustmentMode = 'qty_only';
    } else {
      _reasonType = 'lost';
      _adjustmentAction = 'out';
      _adjustmentMode = 'qty_only';
    }
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _notesController.dispose();
    _searchController.dispose();
    _unitCostController.dispose();
    super.dispose();
  }

  void _showItemSelectionSheet(List<Inventory> items) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Pilih Barang yang Sesuai'),
        message: Text('Ditemukan ${items.length} barang cocok.'),
        actions: items.map((item) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _selectedItem = item;
                _qtyController.clear();
                _qtyErrorMessage = null;
                _unitCostController.clear();
                _unitCostErrorMessage = null;
              });
              Navigator.pop(context);
            },
            child: Column(
              children: [
                Text(
                  item.productName ?? 'Unknown Product',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 2),
                Text(
                  'SKU: ${item.sku} • Stok: ${item.quantity.toStringAsFixed(1)} ${item.unit ?? "PCS"}',
                  style: const TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel),
                ),
              ],
            ),
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

  Future<void> _lookupItem(String barcodeCode) async {
    final cleanQuery = barcodeCode.trim();
    if (cleanQuery.isEmpty) return;
    
    setState(() {
      _isLoadingItem = true;
      _itemErrorMessage = null;
    });

    try {
      final repository = ref.read(inventoryRepositoryProvider);
      
      // Search using getInventory (covers SKU, barcode, and Name)
      final paginated = await repository.getInventory(search: cleanQuery);
      final items = paginated.data;

      if (items.length == 1) {
        setState(() {
          _selectedItem = items.first;
          _qtyController.clear();
          _qtyErrorMessage = null;
          _unitCostController.clear();
          _unitCostErrorMessage = null;
        });
      } else if (items.length > 1) {
        _showItemSelectionSheet(items);
      } else {
        // Fallback to exact barcode lookup
        try {
          final item = await repository.getInventoryByBarcode(cleanQuery);
          setState(() {
            _selectedItem = item;
            _qtyController.clear();
            _qtyErrorMessage = null;
            _unitCostController.clear();
            _unitCostErrorMessage = null;
          });
        } catch (barcodeError) {
          setState(() {
            _itemErrorMessage = 'Barang tidak ditemukan untuk pencarian: "$cleanQuery"';
          });
        }
      }
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
        _itemErrorMessage = 'Gagal memproses pencarian: $message';
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
    final reasons = widget.isUsageMode
        ? {'usage': 'Pemakaian Umum (General Usage)'}
        : {
            'lost': 'Kehilangan (Lost)',
            'breakage': 'Kerusakan (Breakage)',
            'dispose': 'Pembuangan (Dispose)',
            'correction': 'Koreksi Stok (Correction)',
          };
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Pilih Tipe Penyesuaian'),
        actions: reasons.entries.map((entry) {
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

    double parsedQty = 0;
    double? parsedUnitCost;
    String finalAdjustmentMode = _adjustmentMode;

    if (_adjustmentAction != 'value_only') {
      final qtyText = _qtyController.text.trim();
      if (qtyText.isEmpty) {
        setState(() {
          _qtyErrorMessage = 'Jumlah wajib diisi';
        });
        return;
      }

      final parsed = double.tryParse(qtyText);
      if (parsed == null) {
        setState(() {
          _qtyErrorMessage = 'Masukkan angka desimal yang valid';
        });
        return;
      }

      if (parsed <= 0) {
        setState(() {
          _qtyErrorMessage = 'Jumlah harus lebih besar dari 0';
        });
        return;
      }

      if (_adjustmentAction == 'out') {
        if (parsed > _selectedItem!.quantity) {
          setState(() {
            _qtyErrorMessage = 'Jumlah melebihi stok yang tersedia (${_selectedItem!.quantity.toStringAsFixed(1)})';
          });
          return;
        }
        parsedQty = -parsed;
      } else {
        parsedQty = parsed;
      }
    } else {
      parsedQty = 0;
      finalAdjustmentMode = 'value_only';
    }

    final needsUnitCost = _adjustmentAction == 'value_only' || _adjustmentMode == 'qty_and_value';
    if (needsUnitCost) {
      final unitCostText = _unitCostController.text.trim();
      if (unitCostText.isEmpty) {
        setState(() {
          _unitCostErrorMessage = 'Harga perolehan / HPP wajib diisi';
        });
        return;
      }

      final parsedCost = double.tryParse(unitCostText);
      if (parsedCost == null || parsedCost < 0) {
        setState(() {
          _unitCostErrorMessage = 'Masukkan harga perolehan yang valid';
        });
        return;
      }
      parsedUnitCost = parsedCost;
    }

    setState(() {
      _qtyErrorMessage = null;
      _unitCostErrorMessage = null;
      _isSubmitting = true;
    });

    try {
      final repository = ref.read(inventoryAdjustmentRepositoryProvider);

      await repository.adjustStock(
        inventoryId: _selectedItem!.id,
        quantity: parsedQty,
        reasonType: _reasonType,
        adjustmentMode: finalAdjustmentMode,
        unitCost: parsedUnitCost,
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
            _unitCostController.clear();
            _photoFile = null;
            _qtyErrorMessage = null;
            _unitCostErrorMessage = null;
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
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.isUsageMode ? 'Pemakaian Barang' : 'Penyesuaian Barang'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
          child: const Icon(CupertinoIcons.back, color: CupertinoColors.activeBlue),
        ),
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
                            : Text(
                                widget.isUsageMode ? 'Kirim Pemakaian Barang' : 'Kirim Penyesuaian Stok',
                                style: const TextStyle(fontWeight: FontWeight.bold),
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
    const primaryAccent = CupertinoColors.activeBlue;

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
                placeholder: 'Cari nama barang, SKU, atau barcode...',
                onSubmitted: (val) => _lookupItem(val),
              ),
              const SizedBox(height: CupertinoSpacing.m),
              CupertinoButton.filled(
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
                       placeholder: 'Cari nama barang, SKU, atau barcode...',
                       onSubmitted: (val) => _lookupItem(val),
                     ),
                   ),
                  const SizedBox(width: CupertinoSpacing.m),
                  CupertinoButton.filled(
                    padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.xxl),
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

    final showHppInput = _adjustmentAction == 'value_only' || _adjustmentMode == 'qty_and_value';

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
          
          // 1. Selection for Action
          if (!widget.isUsageMode) ...[
            Text('Aksi Penyesuaian *', style: context.caption1.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: CupertinoSpacing.s),
            SizedBox(
              width: double.infinity,
              child: CupertinoSlidingSegmentedControl<String>(
                groupValue: _adjustmentAction,
                children: const {
                  'out': Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                    child: Text('Kurangi Stok', style: TextStyle(fontSize: 12)),
                  ),
                  'in': Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                    child: Text('Tambah Stok', style: TextStyle(fontSize: 12)),
                  ),
                  'value_only': Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                    child: Text('Koreksi HPP', style: TextStyle(fontSize: 12)),
                  ),
                },
                onValueChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _adjustmentAction = value;
                      if (value == 'value_only') {
                        _reasonType = 'correction';
                      } else if (_reasonType == 'correction') {
                        _reasonType = 'usage';
                      }
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: CupertinoSpacing.l),
          ],

          // 2. Selection for Mode (only if not value_only)
          if (!widget.isUsageMode && _adjustmentAction != 'value_only') ...[
            Text('Mode Penyesuaian *', style: context.caption1.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: CupertinoSpacing.s),
            SizedBox(
              width: double.infinity,
              child: CupertinoSlidingSegmentedControl<String>(
                groupValue: _adjustmentMode,
                children: const {
                  'qty_only': Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                    child: Text('Koreksi Qty Saja', style: TextStyle(fontSize: 12)),
                  ),
                  'qty_and_value': Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                    child: Text('Koreksi Qty & HPP', style: TextStyle(fontSize: 12)),
                  ),
                },
                onValueChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _adjustmentMode = value;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: CupertinoSpacing.l),
          ],

          // 3. Quantity Input (only if not value_only)
          if (_adjustmentAction != 'value_only') ...[
            Text(widget.isUsageMode ? 'Jumlah yang Dipakai *' : 'Jumlah yang Disesuaikan *', style: context.caption1.copyWith(fontWeight: FontWeight.w500)),
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
          ],

          // 4. HPP Input (if qty_and_value or value_only)
          if (showHppInput) ...[
            Text(
              _adjustmentAction == 'value_only' 
                  ? 'Harga Perolehan Baru (HPP Target) *' 
                  : 'Harga Perolehan / Unit Cost (Rp) *', 
              style: context.caption1.copyWith(fontWeight: FontWeight.w500)
            ),
            const SizedBox(height: CupertinoSpacing.s),
            CupertinoTextField(
              controller: _unitCostController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              placeholder: 'Contoh: 50000',
              prefix: const Padding(
                padding: EdgeInsets.only(left: CupertinoSpacing.m),
                child: Text('Rp', style: TextStyle(color: CupertinoColors.placeholderText)),
              ),
            ),
            if (_unitCostErrorMessage != null) ...[
              const SizedBox(height: CupertinoSpacing.xs),
              Text(
                _unitCostErrorMessage!,
                style: context.caption1.copyWith(color: CupertinoColors.destructiveRed),
              ),
            ],
            const SizedBox(height: CupertinoSpacing.l),
          ],

          // 5. Warning / Info Banner based on selection
          _buildInfoBanner(),
          const SizedBox(height: CupertinoSpacing.l),

          // 6. Reason Type Selector
          if (!widget.isUsageMode) ...[
            Text('Alasan Penyesuaian *', style: context.caption1.copyWith(fontWeight: FontWeight.w500)),
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
          ],

          // 7. Notes Input
          Text('Keterangan / Notes', style: context.caption1.copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(height: CupertinoSpacing.s),
          CupertinoTextField(
            controller: _notesController,
            maxLines: 3,
            placeholder: 'Tuliskan alasan penyesuaian...',
          ),
          const SizedBox(height: CupertinoSpacing.l),

          // 8. Photo Picker Section
          _buildPhotoPickerSection(),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    if (widget.isUsageMode) return const SizedBox.shrink();
    String text = '';
    Color color = CupertinoColors.activeBlue;

    if (_adjustmentAction == 'value_only') {
      text = 'Koreksi Nilai: Transaksi ini HANYA akan mengubah rata-rata HPP tanpa mempengaruhi jumlah kuantitas stok fisik.';
      color = CupertinoColors.activeOrange;
    } else if (_adjustmentAction == 'in') {
      if (_adjustmentMode == 'qty_and_value') {
        text = 'Tambah & Rekalkulasi: Menambah stok sekaligus menghitung ulang HPP rata-rata berjalan menggunakan harga perolehan baru yang Anda masukkan.';
        color = CupertinoColors.activeGreen;
      } else {
        text = 'Tambah Qty Saja: Menambah stok baru menggunakan harga HPP berjalan saat ini.';
      }
    } else if (_adjustmentAction == 'out') {
      if (_adjustmentMode == 'qty_and_value') {
        text = 'Kurang & Rekalkulasi: Mengurangi stok sekaligus mengkoreksi sisa nilai HPP barang yang tersisa di gudang.';
        color = CupertinoColors.destructiveRed;
      } else {
        text = 'Kurang Qty Saja: Pengurangan stok biasa dengan HPP berjalan. HPP per unit tidak akan berubah.';
      }
    }

    return Container(
      padding: const EdgeInsets.all(CupertinoSpacing.m),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(CupertinoIcons.info_circle_fill, color: color, size: 16),
          const SizedBox(width: CupertinoSpacing.s),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 11, color: color, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoPickerSection() {
    const primaryAccent = CupertinoColors.activeBlue;

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
                border: Border.all(color: CupertinoColors.activeBlue, width: 3),
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
