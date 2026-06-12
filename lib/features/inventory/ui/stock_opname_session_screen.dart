import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors, Divider, VerticalDivider, Scrollbar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../models/stock_opname.dart';
import '../providers/stock_opname_repository.dart';

class StockOpnameSessionScreen extends ConsumerStatefulWidget {
  final int sessionId;

  const StockOpnameSessionScreen({
    super.key,
    required this.sessionId,
  });

  @override
  ConsumerState<StockOpnameSessionScreen> createState() => _StockOpnameSessionScreenState();
}

class _StockOpnameSessionScreenState extends ConsumerState<StockOpnameSessionScreen> with SingleTickerProviderStateMixin {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  late AnimationController _scannerAnimationController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _manualBarcodeController = TextEditingController();

  String _filterQuery = '';
  bool _isCameraActive = true;
  bool _isSubmitting = false;
  bool _isLoadingProduct = false;

  double _keypadValue = 0.0;
  String _keypadValueStr = '';

  @override
  void initState() {
    super.initState();
    _scannerAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _scannerAnimationController.dispose();
    _searchController.dispose();
    _manualBarcodeController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (!_isCameraActive || _isLoadingProduct || _isSubmitting) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;
    if (code == null || code.trim().isEmpty) return;

    _processScannedBarcode(code.trim());
  }

  Future<void> _processScannedBarcode(String barcode) async {
    setState(() {
      _isLoadingProduct = true;
      _isCameraActive = false;
    });

    try {
      final repo = ref.read(stockOpnameRepositoryProvider);
      final productData = await repo.lookupBarcode(barcode);
      
      final product = productData['product'] as Map<String, dynamic>;
      
      // Let's also see if this SKU already exists in our current opname list to pre-populate its counted qty
      final summaryAsync = ref.read(stockOpnameSummaryProvider(widget.sessionId));
      double initialQty = 0.0;
      
      if (summaryAsync.hasValue) {
        final items = summaryAsync.value?['items'] as List? ?? [];
        final existing = items.firstWhere(
          (item) => item['sku'] == product['sku'],
          orElse: () => null,
        );
        if (existing != null) {
          initialQty = double.tryParse(existing['counted_qty']?.toString() ?? '') ?? 0.0;
        }
      }

      _showCountKeypadDialog(
        barcode: barcode,
        sku: product['sku'] ?? 'N/A',
        productName: product['name'] ?? 'Unknown',
        productUnit: product['unit'] ?? 'pcs',
        initialQty: initialQty,
      );
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Barcode Tidak Dikenal'),
            content: Text('Gagal mengenali barcode "$barcode": $e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _isCameraActive = true;
                  });
                },
              )
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingProduct = false;
        });
      }
    }
  }

  void _showCountKeypadDialog({
    required String barcode,
    required String sku,
    required String productName,
    required String productUnit,
    required double initialQty,
  }) {
    setState(() {
      _keypadValue = initialQty;
      _keypadValueStr = initialQty % 1 == 0 ? initialQty.toInt().toString() : initialQty.toString();
      if (_keypadValueStr == '0') {
        _keypadValueStr = '';
      }
    });

    showCupertinoModalPopup(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => CupertinoActionSheet(
          title: Text(
            'Input Jumlah Hitung',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.label.resolveFrom(context),
            ),
          ),
          message: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                productName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.label.resolveFrom(context),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'SKU: $sku | Barcode: $barcode',
                style: const TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground.resolveFrom(context),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: CupertinoColors.separator.resolveFrom(context),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _keypadValueStr.isEmpty ? '0' : _keypadValueStr,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: _keypadValueStr.isEmpty
                            ? CupertinoColors.placeholderText.resolveFrom(context)
                            : CupertinoColors.activeBlue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      productUnit,
                      style: const TextStyle(fontSize: 16, color: CupertinoColors.secondaryLabel),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildKeypadGrid(
                onKeyPress: (key) {
                  setDialogState(() {
                    if (key == 'BACK') {
                      if (_keypadValueStr.isNotEmpty) {
                        _keypadValueStr = _keypadValueStr.substring(0, _keypadValueStr.length - 1);
                      }
                    } else if (key == 'CLEAR') {
                      _keypadValueStr = '';
                    } else if (key == '+1') {
                      final val = double.tryParse(_keypadValueStr) ?? 0.0;
                      _keypadValueStr = (val + 1).toInt().toString();
                    } else if (key == '-1') {
                      final val = double.tryParse(_keypadValueStr) ?? 0.0;
                      if (val > 0) {
                        _keypadValueStr = (val - 1).toInt().toString();
                      }
                    } else if (key == '.') {
                      if (!_keypadValueStr.contains('.')) {
                        _keypadValueStr += _keypadValueStr.isEmpty ? '0.' : '.';
                      }
                    } else {
                      _keypadValueStr += key;
                    }
                    _keypadValue = double.tryParse(_keypadValueStr) ?? 0.0;
                  });
                },
              ),
            ],
          ),
          actions: [
            CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: _isSubmitting
                  ? () {}
                  : () async {
                      setDialogState(() {
                        _isSubmitting = true;
                      });
                      final success = await _submitQty(barcode, _keypadValue);
                      if (mounted) {
                        setDialogState(() {
                          _isSubmitting = false;
                        });
                        if (success) {
                          Navigator.pop(context);
                          setState(() {
                            _isCameraActive = true;
                          });
                        }
                      }
                    },
              child: _isSubmitting
                  ? const CupertinoActivityIndicator()
                  : const Text('Simpan Hasil Hitung'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isCameraActive = true;
              });
            },
            child: const Text('Batal'),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypadGrid({required Function(String) onKeyPress}) {
    final buttons = [
      ['1', '2', '3', '+1'],
      ['4', '5', '6', '-1'],
      ['7', '8', '9', '.'],
      ['CLEAR', '0', 'BACK', '']
    ];

    return Column(
      children: buttons.map((row) {
        return Row(
          children: row.map((key) {
            if (key.isEmpty) {
              return const Expanded(child: SizedBox());
            }
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  color: (key == 'CLEAR' || key == 'BACK')
                      ? CupertinoColors.systemRed.withValues(alpha: 0.1)
                      : (key == '+1' || key == '-1')
                          ? CupertinoColors.activeOrange.withValues(alpha: 0.1)
                          : CupertinoColors.secondarySystemFill,
                  borderRadius: BorderRadius.circular(8),
                  minSize: 0,
                  onPressed: () => onKeyPress(key),
                  child: Text(
                    key == 'BACK' ? '⌫' : key,
                    style: TextStyle(
                      fontSize: (key == 'CLEAR' || key == 'BACK' || key == '+1' || key == '-1') ? 13 : 18,
                      fontWeight: FontWeight.bold,
                      color: (key == 'CLEAR' || key == 'BACK')
                          ? CupertinoColors.systemRed
                          : (key == '+1' || key == '-1')
                              ? CupertinoColors.activeOrange
                              : CupertinoColors.label,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  Future<bool> _submitQty(String barcode, double qty) async {
    try {
      final repo = ref.read(stockOpnameRepositoryProvider);
      await repo.submitScan(
        sessionId: widget.sessionId,
        barcode: barcode,
        qty: qty.toInt(),
      );

      // Invalidate the provider to refetch summary
      ref.invalidate(stockOpnameSummaryProvider(widget.sessionId));
      return true;
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Gagal Menyimpan'),
            content: Text('Terjadi kesalahan saat menyimpan data: $e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
      }
      return false;
    }
  }

  Future<void> _completeSession() async {
    final success = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Selesaikan Opname?'),
        content: const Text(
          'Tindakan ini akan mencocokkan stok fisik Anda dengan sistem dan membuat transaksi penyesuaian jika ada selisih. Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context, false),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Selesaikan & Reconcile'),
          ),
        ],
      ),
    );

    if (success == true) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        final repo = ref.read(stockOpnameRepositoryProvider);
        await repo.completeSession(widget.sessionId);
        
        ref.invalidate(activeStockOpnameSessionsProvider);

        if (mounted) {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Selesai'),
              content: const Text('Sesi opname berhasil diselesaikan dan stok disesuaikan.'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context); // Pop dialog
                    context.pop(); // Go back to list screen
                  },
                )
              ],
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Gagal Menyelesaikan'),
              content: Text('Terjadi kesalahan: $e'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  void _manualLookup() {
    final barcode = _manualBarcodeController.text.trim();
    if (barcode.isEmpty) return;
    _manualBarcodeController.clear();
    _processScannedBarcode(barcode);
  }

  @override
  Widget build(BuildContext context) {
    final summaryAsync = ref.watch(stockOpnameSummaryProvider(widget.sessionId));
    final isLargeScreen = MediaQuery.of(context).size.width >= 900;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        middle: summaryAsync.when(
          data: (data) => Text(
            'Hitung: ${data['opname_number']}',
            style: TextStyle(color: CupertinoColors.label.resolveFrom(context)),
          ),
          loading: () => const Text('Memuat Sesi...'),
          error: (_, __) => const Text('Error Sesi'),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _isSubmitting ? null : _completeSession,
          child: const Text(
            'Selesai',
            style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.activeBlue),
          ),
        ),
      ),
      child: SafeArea(
        child: summaryAsync.when(
          data: (data) {
            final itemsList = (data['items'] as List? ?? []).map((json) {
              return StockOpnameItem.fromJson(json as Map<String, dynamic>);
            }).toList();

            final filteredItems = itemsList.where((item) {
              if (_filterQuery.isEmpty) return true;
              final q = _filterQuery.toLowerCase();
              return item.sku.toLowerCase().contains(q) ||
                  item.productName.toLowerCase().contains(q);
            }).toList();

            if (isLargeScreen) {
              return Row(
                children: [
                  // Left Pane - Items List
                  Expanded(
                    flex: 5,
                    child: _buildItemsPane(filteredItems),
                  ),
                  const VerticalDivider(width: 1, color: CupertinoColors.separator),
                  // Right Pane - Scanner / Inputs
                  Expanded(
                    flex: 4,
                    child: _buildScannerPane(),
                  ),
                ],
              );
            } else {
              // Narrow Screen - Default view with a toggle or slide-up sheet for scanner
              return Stack(
                children: [
                  Column(
                    children: [
                      // List view
                      Expanded(
                        child: _buildItemsPane(filteredItems),
                      ),
                    ],
                  ),
                  // Floating Scanner Button
                  Positioned(
                    bottom: 24,
                    right: 24,
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(16),
                      color: CupertinoColors.activeBlue,
                      borderRadius: BorderRadius.circular(30),
                      onPressed: () {
                        // Show mobile full scanner modal
                        _showMobileScannerModal();
                      },
                      child: const Icon(CupertinoIcons.barcode_viewfinder, color: CupertinoColors.white, size: 28),
                    ),
                  ),
                ],
              );
            }
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (err, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.exclamationmark_triangle, size: 48, color: CupertinoColors.systemRed),
                  const SizedBox(height: 16),
                  Text('Gagal memuat data: $err', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  CupertinoButton.filled(
                    onPressed: () => ref.invalidate(stockOpnameSummaryProvider(widget.sessionId)),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showMobileScannerModal() {
    setState(() {
      _isCameraActive = true;
    });

    showCupertinoModalPopup(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          color: const Color(0xFF0F172A), // Slate 900
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pindai Barcode Barang',
                      style: TextStyle(color: CupertinoColors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Text('Tutup', style: TextStyle(color: CupertinoColors.link)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white24, height: 1),
              // Scanner view
              Expanded(
                child: Stack(
                  children: [
                    MobileScanner(
                      controller: _scannerController,
                      onDetect: (capture) {
                        _onDetect(capture);
                        Navigator.pop(context); // Close scanner modal immediately to show keypad on main screen
                      },
                    ),
                    _buildViewfinderOverlay(),
                  ],
                ),
              ),
              // Manual key input bottom section
              Container(
                color: const Color(0xFF1E293B),
                padding: const EdgeInsets.all(16),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: CupertinoTextField(
                          controller: _manualBarcodeController,
                          placeholder: 'Ketik Kode Barcode/SKU...',
                          placeholderStyle: const TextStyle(color: CupertinoColors.placeholderText),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white12),
                          ),
                          style: const TextStyle(color: CupertinoColors.white),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          onSubmitted: (val) {
                            Navigator.pop(context);
                            _manualLookup();
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        color: CupertinoColors.activeBlue,
                        borderRadius: BorderRadius.circular(8),
                        onPressed: () {
                          Navigator.pop(context);
                          _manualLookup();
                        },
                        child: const Text('Cari', style: TextStyle(fontSize: 14)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemsPane(List<StockOpnameItem> items) {
    return Column(
      children: [
        // Search & Filter header
        Padding(
          padding: const EdgeInsets.all(16),
          child: CupertinoSearchTextField(
            controller: _searchController,
            placeholder: 'Filter SKU atau nama produk...',
            onChanged: (val) {
              setState(() {
                _filterQuery = val.trim();
              });
            },
          ),
        ),
        // Table list of items
        Expanded(
          child: items.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada produk yang cocok.',
                    style: TextStyle(color: CupertinoColors.secondaryLabel),
                  ),
                )
              : Scrollbar(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: items.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final double diff = item.discrepancy;
                      final isDiff = diff != 0;

                      return GestureDetector(
                        onTap: () {
                          // Allow editing of this item by tapping it
                          // Let's trigger keypad dialog using its SKU as mock barcode (since SKU can lookup directly)
                          _showCountKeypadDialog(
                            barcode: item.sku, // SKU can act as lookup
                            sku: item.sku,
                            productName: item.productName,
                            productUnit: item.productUnit,
                            initialQty: item.countedQty,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDiff
                                  ? (diff < 0 ? CupertinoColors.systemRed : CupertinoColors.systemGreen).withValues(alpha: 0.3)
                                  : CupertinoColors.separator.resolveFrom(context),
                              width: isDiff ? 1.0 : 0.5,
                            ),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.productName,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (isDiff)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: (diff < 0 ? CupertinoColors.systemRed : CupertinoColors.systemGreen).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'Selisih: ${diff > 0 ? "+" : ""}${diff % 1 == 0 ? diff.toInt().toString() : diff.toString()}',
                                        style: TextStyle(
                                          color: diff < 0 ? CupertinoColors.systemRed : CupertinoColors.systemGreen,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'SKU: ${item.sku}',
                                style: const TextStyle(fontSize: 11, color: CupertinoColors.secondaryLabel),
                              ),
                              const Divider(color: CupertinoColors.separator, height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Sistem: ${item.systemQty % 1 == 0 ? item.systemQty.toInt().toString() : item.systemQty.toString()} ${item.productUnit}',
                                    style: const TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(CupertinoIcons.pencil_ellipsis_rectangle, size: 14, color: CupertinoColors.activeBlue),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Fisik: ${item.countedQty % 1 == 0 ? item.countedQty.toInt().toString() : item.countedQty.toString()} ${item.productUnit}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: CupertinoColors.label,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildScannerPane() {
    return Column(
      children: [
        // Camera Viewport
        Expanded(
          child: _isLoadingProduct
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoActivityIndicator(radius: 14),
                      SizedBox(height: 12),
                      Text('Mencari data produk...', style: TextStyle(color: CupertinoColors.secondaryLabel)),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    if (_isCameraActive)
                      MobileScanner(
                        controller: _scannerController,
                        onDetect: _onDetect,
                      )
                    else
                      Container(
                        color: CupertinoColors.black,
                        child: const Center(
                          child: Text(
                            'Kamera Jeda',
                            style: TextStyle(color: CupertinoColors.white),
                          ),
                        ),
                      ),
                    _buildViewfinderOverlay(),
                  ],
                ),
        ),
        // Manual lookup & controller bar
        Container(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Lookup Manual Barcode / SKU',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: CupertinoColors.secondaryLabel),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: CupertinoTextField(
                      controller: _manualBarcodeController,
                      placeholder: 'Masukkan Kode Barcode / SKU...',
                      placeholderStyle: const TextStyle(color: CupertinoColors.placeholderText),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: CupertinoColors.secondarySystemBackground.resolveFrom(context),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onSubmitted: (val) => _manualLookup(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    color: CupertinoColors.activeBlue,
                    borderRadius: BorderRadius.circular(8),
                    onPressed: _manualLookup,
                    child: const Text('Cari', style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildViewfinderOverlay() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;
        final double scanSize = width * 0.7 < 260 ? width * 0.7 : 260;

        return Stack(
          children: [
            // Darkened Outer Bounds
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.6),
                BlendMode.srcOut,
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      backgroundBlendMode: BlendMode.dstOut,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: scanSize,
                      height: scanSize,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Glowing Frame
            Align(
              alignment: Alignment.center,
              child: Container(
                width: scanSize,
                height: scanSize,
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.activeBlue, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            // Laser Line
            AnimatedBuilder(
              animation: _scannerAnimationController,
              builder: (context, child) {
                final double topPosition = (height / 2 - scanSize / 2) + (_scannerAnimationController.value * scanSize);
                return Positioned(
                  top: topPosition,
                  left: (width - scanSize) / 2 + 10,
                  right: (width - scanSize) / 2 + 10,
                  child: Container(
                    height: 2,
                    decoration: const BoxDecoration(
                      color: CupertinoColors.systemRed,
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.systemRed,
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
