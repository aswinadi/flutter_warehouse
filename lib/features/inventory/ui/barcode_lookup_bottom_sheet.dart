import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../providers/inventory_provider.dart';
import '../models/inventory.dart';
import '../models/inventory_breakdown.dart';
import '../models/asset.dart';
import '../providers/asset_repository.dart';

class BarcodeLookupBottomSheet extends ConsumerStatefulWidget {
  const BarcodeLookupBottomSheet({super.key});

  @override
  ConsumerState<BarcodeLookupBottomSheet> createState() => _BarcodeLookupBottomSheetState();
}

class _BarcodeLookupBottomSheetState extends ConsumerState<BarcodeLookupBottomSheet> with SingleTickerProviderStateMixin {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  late AnimationController _animationController;
  bool _isLoading = false;
  InventoryBreakdown? _scannedBreakdown;
  Asset? _scannedAsset;
  String? _errorMessage;
  bool _isCameraActive = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _animationController.dispose();
    super.dispose();
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

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (!_isCameraActive || _isLoading) return;
    
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;
    if (code == null || code.trim().isEmpty) return;

    final cleanCode = _extractAssetCode(code);

    setState(() {
      _isLoading = true;
      _isCameraActive = false;
      _errorMessage = null;
      _scannedBreakdown = null;
      _scannedAsset = null;
    });

    try {
      if (cleanCode.startsWith('AST-')) {
        final repository = ref.read(assetRepositoryProvider);
        final asset = await repository.getAssetByTag(cleanCode);
        setState(() {
          _scannedAsset = asset;
          _isLoading = false;
        });
      } else {
        final repository = ref.read(inventoryRepositoryProvider);
        final breakdown = await repository.getInventoryBreakdown(cleanCode);
        setState(() {
          _scannedBreakdown = breakdown;
          _isLoading = false;
        });
      }
    } catch (e) {
      String msg = e.toString();
      if (msg.contains('404') || msg.contains('not found')) {
        msg = cleanCode.startsWith('AST-')
            ? 'Tag aset tidak ditemukan di sistem.'
            : 'Barcode tidak ditemukan di sistem atau belum memiliki catatan stok aktif.';
      } else {
        msg = 'Gagal mengambil data: ${e.toString()}';
      }
      setState(() {
        _errorMessage = msg;
        _isLoading = false;
      });
    }
  }

  void _resetScanner() {
    setState(() {
      _scannedBreakdown = null;
      _scannedAsset = null;
      _errorMessage = null;
      _isLoading = false;
      _isCameraActive = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double sheetHeight = MediaQuery.of(context).size.height * 0.85;

    return Container(
      height: sheetHeight,
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A), // Slate 900
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle Bar
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quick Barcode Lookup',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10),
          // Content
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: const Color(0xFF007AFF)),
            SizedBox(height: 16),
            Text(
              'Mencari data barang...',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_scannedBreakdown != null) {
      return _buildResultCard(_scannedBreakdown!);
    }

    if (_scannedAsset != null) {
      return _buildAssetResultCard(_scannedAsset!);
    }

    if (_errorMessage != null) {
      return _buildErrorState(_errorMessage!);
    }

    // Camera Scan View
    return Stack(
      children: [
        MobileScanner(
          controller: _scannerController,
          onDetect: _onDetect,
        ),
        // Viewfinder and Laser Line Overlay
        _buildViewfinderOverlay(),
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
            // Glowing Frame and Corners
            Align(
              alignment: Alignment.center,
              child: Container(
                width: scanSize,
                height: scanSize,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF007AFF), width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            // Laser Line Animation
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final double topPosition = (height / 2 - scanSize / 2) + (_animationController.value * scanSize);
                return Positioned(
                  top: topPosition,
                  left: (width - scanSize) / 2 + 10,
                  right: (width - scanSize) / 2 + 10,
                  child: Container(
                    height: 2,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red,
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Label instruction
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Arahkan kamera ke barcode/QR barang',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildResultCard(InventoryBreakdown breakdown) {
    final totalOnHand = breakdown.onHand.fold<double>(0, (sum, wh) => sum + wh.quantity);
    final totalInTransit = breakdown.inTransit.fold<double>(0, (sum, transit) => sum + transit.quantity);
    final totalOrdered = breakdown.ordered.fold<double>(0, (sum, order) => sum + order.quantity);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and Title
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle_outline, color: Colors.green, size: 48),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Barang Ditemukan',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Product Name and SKU Card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B), // Slate 800
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  breakdown.productName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'SKU: ${breakdown.sku}',
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Summary Grid
          Row(
            children: [
              Expanded(
                child: _buildSummaryGridItem(
                  'Tersedia',
                  totalOnHand,
                  const Color(0xFF38BDF8),
                  Icons.inventory_2_outlined,
                  breakdown.unit,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSummaryGridItem(
                  'Transit',
                  totalInTransit,
                  Colors.amber,
                  Icons.local_shipping_outlined,
                  breakdown.unit,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSummaryGridItem(
                  'Dipesan',
                  totalOrdered,
                  const Color(0xFFa78bfa),
                  Icons.assignment_outlined,
                  breakdown.unit,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // On Hand (Tersedia) Breakdown
          const Text(
            'Rincian Stok Tersedia (On Hand)',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (breakdown.onHand.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Tidak ada stok tersedia di gudang mana pun.',
                style: TextStyle(color: Colors.white38, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            )
          else
            ...breakdown.onHand.map((wh) => WarehouseStockTile(warehouse: wh, unit: breakdown.unit)),

          const SizedBox(height: 20),

          // In Transit Breakdown
          const Text(
            'Rincian Dalam Perjalanan (In Transit)',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (breakdown.inTransit.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Tidak ada transfer barang aktif saat ini.',
                style: TextStyle(color: Colors.white38, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            )
          else
            ...breakdown.inTransit.map((transit) => InTransitStockTile(transit: transit, unit: breakdown.unit)),

          const SizedBox(height: 20),

          // Ordered Breakdown
          const Text(
            'Rincian Pesanan (On Order)',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (breakdown.ordered.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Tidak ada pesanan pembelian (PO) aktif untuk produk ini.',
                style: TextStyle(color: Colors.white38, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            )
          else
            ...breakdown.ordered.map((order) => OrderedStockTile(order: order, unit: breakdown.unit)),

          const SizedBox(height: 24),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('TUTUP'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _resetScanner,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AFF), // Notion Purple
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('SCAN LAGI'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryGridItem(
    String title,
    double qty,
    Color accentColor,
    IconData icon,
    String unit,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 16, color: accentColor),
              Text(
                title,
                style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text(
                qty % 1 == 0 ? qty.toInt().toString() : qty.toString(),
                style: TextStyle(
                  color: accentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  unit,
                  style: const TextStyle(color: Colors.white30, fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.error_outline, color: Colors.red, size: 48),
          ),
          const SizedBox(height: 16),
          const Text(
            'Lookup Gagal',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('TUTUP'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _resetScanner,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AFF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('COBA LAGI'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isHighlight = false, Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              color: textColor ?? (isHighlight ? const Color(0xFF38BDF8) : Colors.white), // Sky Blue highlight or white
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'reserved':
        return Colors.orange;
      case 'shipped':
        return Colors.blue;
      case 'damaged':
        return Colors.red;
      case 'consumed':
        return Colors.grey;
      default:
        return Colors.white;
    }
  }

  Widget _buildAssetResultCard(Asset asset) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_outline, color: Colors.green, size: 48),
          ),
          const SizedBox(height: 16),
          const Text(
            'Aset Hardware Ditemukan',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${asset.brand ?? ''} ${asset.model ?? ''}'.trim(),
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
                const Divider(color: Colors.white10, height: 24),
                _buildInfoRow('Asset Tag', asset.assetTag),
                _buildInfoRow('Kategori', asset.category),
                _buildInfoRow('Serial Number', asset.serialNumber ?? '—'),
                _buildInfoRow('Lokasi', asset.officeName ?? '—'),
                _buildInfoRow('Ditugaskan Ke', asset.employeeName ?? 'Belum Ditugaskan', textColor: asset.employeeName == null ? Colors.amber : null),
                _buildInfoRow('Status', asset.status.toUpperCase(), textColor: _getAssetStatusColor(asset.status)),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('TUTUP'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push('/assets/${asset.id}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AFF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('LIHAT DETAIL ASET'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getAssetStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'assigned':
        return Colors.blue;
      case 'maintenance':
        return Colors.orange;
      case 'retired':
        return Colors.grey;
      default:
        return Colors.red;
    }
  }
}

class WarehouseStockTile extends StatefulWidget {
  final WarehouseOnHand warehouse;
  final String unit;

  const WarehouseStockTile({
    super.key,
    required this.warehouse,
    required this.unit,
  });

  @override
  State<WarehouseStockTile> createState() => _WarehouseStockTileState();
}

class _WarehouseStockTileState extends State<WarehouseStockTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final wh = widget.warehouse;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Icon(
              Icons.warehouse_outlined,
              color: wh.quantity > 0 ? const Color(0xFF38BDF8) : Colors.white30,
            ),
            title: Text(
              wh.warehouseName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  wh.quantity % 1 == 0 ? wh.quantity.toInt().toString() : wh.quantity.toString(),
                  style: const TextStyle(
                    color: Color(0xFF38BDF8),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  widget.unit,
                  style: const TextStyle(color: Colors.white30, fontSize: 11),
                ),
                if (wh.locations.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.white54,
                    size: 20,
                  ),
                ],
              ],
            ),
            onTap: wh.locations.isNotEmpty
                ? () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  }
                : null,
          ),
          if (_isExpanded && wh.locations.isNotEmpty) ...[
            const Divider(color: Colors.white10, height: 1),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withOpacity(0.5),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Column(
                children: wh.locations.map((loc) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.grid_on_outlined, size: 14, color: Colors.white30),
                            const SizedBox(width: 8),
                            Text(
                              loc.locationCode,
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                        Text(
                          '${loc.quantity % 1 == 0 ? loc.quantity.toInt() : loc.quantity} ${widget.unit}',
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ]
        ],
      ),
    );
  }
}

class InTransitStockTile extends StatelessWidget {
  final InTransitStock transit;
  final String unit;

  const InTransitStockTile({
    super.key,
    required this.transit,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.local_shipping_outlined, color: Colors.amber, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    transit.transferNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Text(
                '${transit.quantity % 1 == 0 ? transit.quantity.toInt() : transit.quantity} $unit',
                style: const TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  transit.sourceWarehouseName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.arrow_forward, color: Colors.white30, size: 14),
              ),
              Expanded(
                child: Text(
                  transit.destinationWarehouseName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderedStockTile extends StatelessWidget {
  final OrderedStock order;
  final String unit;

  const OrderedStockTile({
    super.key,
    required this.order,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.assignment_outlined, color: Color(0xFFa78bfa), size: 16),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.poNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                ),
              ),
                  const SizedBox(height: 2),
                  Text(
                    'Gudang: ${order.warehouseName}',
                    style: const TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          Text(
            '${order.quantity % 1 == 0 ? order.quantity.toInt() : order.quantity} $unit',
            style: const TextStyle(
              color: Color(0xFFa78bfa),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
