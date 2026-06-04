import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../models/inventory.dart';
import '../providers/inventory_provider.dart';
import '../providers/inventory_adjustment_repository.dart';
import '../../../core/widgets/company_switcher.dart';

class InventoryAdjustmentScreen extends ConsumerStatefulWidget {
  final Inventory? prefilledItem;

  const InventoryAdjustmentScreen({super.key, this.prefilledItem});

  @override
  ConsumerState<InventoryAdjustmentScreen> createState() => _InventoryAdjustmentScreenState();
}

class _InventoryAdjustmentScreenState extends ConsumerState<InventoryAdjustmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _qtyController = TextEditingController();
  final _notesController = TextEditingController();
  final _searchController = TextEditingController();

  Inventory? _selectedItem;
  String _reasonType = 'usage'; // default to Pemakaian
  XFile? _photoFile;
  bool _isLoadingItem = false;
  bool _isSubmitting = false;
  String? _itemErrorMessage;

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
      });
    } catch (e) {
      setState(() {
        _itemErrorMessage = 'Barang tidak ditemukan: $e';
      });
    } finally {
      setState(() {
        _isLoadingItem = false;
      });
    }
  }

  Future<void> _scanBarcode() async {
    final barcode = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const BarcodeScannerBottomSheet(),
    );

    if (barcode != null && barcode.isNotEmpty) {
      // Clean up URL prefix if present in the scanned code
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
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil Foto dari Kamera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih Foto dari Galeri'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
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

  Future<void> _submit() async {
    if (_selectedItem == null) {
      _showNotification('Silakan pilih atau pindai barang terlebih dahulu.', isError: true);
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final repository = ref.read(inventoryAdjustmentRepositoryProvider);
      final qty = double.parse(_qtyController.text);

      await repository.adjustStock(
        inventoryId: _selectedItem!.id,
        quantity: qty,
        reasonType: _reasonType,
        notes: _notesController.text.trim(),
        photoFile: _photoFile,
      );

      _showNotification('Penyesuaian stok berhasil dikirim!');
      
      // Refresh inventory lists
      ref.invalidate(inventoryRepositoryProvider);
      
      if (mounted) {
        if (widget.prefilledItem != null) {
          // If came from detail list, pop back
          context.pop();
        } else {
          // Reset form for next entry
          setState(() {
            _selectedItem = null;
            _qtyController.clear();
            _notesController.clear();
            _photoFile = null;
          });
        }
      }
    } catch (e) {
      _showNotification('Gagal mengirim penyesuaian: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
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
                          if (entry.mounted) entry.remove();
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
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (entry.mounted) entry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Penyesuaian & Pemakaian'),
      ),
      body: Column(
        children: [
          const CompanySwitcher(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isWide ? 650 : double.infinity),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildItemSelectionCard(),
                      const SizedBox(height: 16),
                      if (_selectedItem != null) _buildAdjustmentFormCard(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _selectedItem == null
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isWide ? 650 : double.infinity),
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6E56CF),
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
                        : const Text(
                            'KIRIM PENYESUAIAN STOK',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildItemSelectionCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Informasi Barang',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 16),
            if (_selectedItem == null) ...[
              OutlinedButton.icon(
                onPressed: _scanBarcode,
                icon: const Icon(Icons.qr_code_scanner, color: Color(0xFF6E56CF)),
                label: const Text('PINDAI BARCODE BARANG'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF6E56CF),
                  side: const BorderSide(color: Color(0xFF6E56CF)),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('ATAU CARI MANUAL', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan Barcode atau SKU...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onSubmitted: (val) => _lookupItem(val),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isLoadingItem ? null : () => _lookupItem(_searchController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    child: _isLoadingItem
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Cari'),
                  ),
                ],
              ),
              if (_itemErrorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _itemErrorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ],
            ] else ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
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
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
                          ),
                        ),
                        if (widget.prefilledItem == null)
                          TextButton(
                            onPressed: () => setState(() => _selectedItem = null),
                            child: const Text('Ganti', style: TextStyle(color: Color(0xFF6E56CF))),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'SKU: ${_selectedItem!.sku}',
                      style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Gudang: ${_selectedItem!.warehouseName ?? "-"} • Lokasi: ${_selectedItem!.locationCode ?? "-"}',
                      style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Stok Tersedia Saat Ini:',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF475569)),
                        ),
                        Text(
                          '${_selectedItem!.quantity.toStringAsFixed(1)} ${_selectedItem!.unit ?? "PCS"}',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF6E56CF)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAdjustmentFormCard() {
    final currentItem = _selectedItem!;
    final unit = currentItem.unit ?? 'PCS';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Detail Transaksi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 16),
              
              // Reason Type Dropdown
              DropdownButtonFormField<String>(
                value: _reasonType,
                decoration: const InputDecoration(
                  labelText: 'Tipe Penyesuaian / Pemakaian *',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
                items: const [
                  DropdownMenuItem(value: 'usage', child: Text('Pemakaian Umum (General Usage)')),
                  DropdownMenuItem(value: 'lost', child: Text('Kehilangan (Lost)')),
                  DropdownMenuItem(value: 'breakage', child: Text('Kerusakan (Breakage)')),
                  DropdownMenuItem(value: 'dispose', child: Text('Pembuangan (Dispose)')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _reasonType = val);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Quantity Input
              TextFormField(
                controller: _qtyController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Jumlah yang Disesuaikan *',
                  border: const OutlineInputBorder(),
                  suffixText: unit,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Jumlah wajib diisi';
                  }
                  final parsed = double.tryParse(value);
                  if (parsed == null) {
                    return 'Masukkan angka desimal yang valid';
                  }
                  if (parsed <= 0) {
                    return 'Jumlah harus lebih besar dari 0';
                  }
                  if (parsed > currentItem.quantity) {
                    return 'Jumlah melebihi stok yang tersedia (${currentItem.quantity.toStringAsFixed(1)})';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Notes Input
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Keterangan / Notes',
                  border: OutlineInputBorder(),
                  hintText: 'Tuliskan alasan penyesuaian...',
                ),
              ),
              const SizedBox(height: 16),

              // Photo Picker Widget
              _buildPhotoPickerSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPickerSection() {
    if (_photoFile != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
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
            const SizedBox(width: 12),
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
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  _photoFile = null;
                });
              },
            ),
          ],
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: _pickImage,
      icon: const Icon(Icons.camera_alt, color: Color(0xFF6E56CF)),
      label: const Text('LAMPIRKAN FOTO BUKTI (OPSIONAL)'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF6E56CF),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
        padding: const EdgeInsets.symmetric(vertical: 16),
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
        color: Colors.black,
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
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
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
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Posisikan Barcode / QR Code di dalam kotak',
                style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
