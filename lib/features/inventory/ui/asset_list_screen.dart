import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../providers/asset_repository.dart';
import '../../../core/widgets/company_switcher.dart';
import '../../../core/providers/company_provider.dart';

class AssetListScreen extends ConsumerStatefulWidget {
  const AssetListScreen({super.key});

  @override
  ConsumerState<AssetListScreen> createState() => _AssetListScreenState();
}

class _AssetListScreenState extends ConsumerState<AssetListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'all';
  String _selectedStatus = 'all';
  String _searchQuery = '';

  final List<String> _categories = [
    'all',
    'Laptop',
    'Desktop',
    'Monitor',
    'Camera',
    'Printer',
    'Networking',
    'Mobile',
    'Audio/Video',
    'Peripheral',
    'Other'
  ];

  final List<String> _statuses = [
    'all',
    'available',
    'assigned',
    'maintenance',
    'retired',
    'broken',
    'lost'
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll * 0.9) {
      ref.read(assetListProvider(
        search: _searchQuery.isEmpty ? null : _searchQuery,
        category: _selectedCategory == 'all' ? null : _selectedCategory,
        status: _selectedStatus == 'all' ? null : _selectedStatus,
      ).notifier).loadMore();
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _openScanner() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AssetScanBottomSheet(),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'assigned':
        return Colors.blue;
      case 'maintenance':
        return Colors.orange;
      case 'broken':
      case 'lost':
        return Colors.red;
      case 'retired':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return 'Available';
      case 'assigned':
        return 'Assigned';
      case 'maintenance':
        return 'In Maintenance';
      case 'broken':
        return 'Broken';
      case 'lost':
        return 'Lost';
      case 'retired':
        return 'Retired';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(selectedCompanyProvider);
    final assetsAsync = ref.watch(assetListProvider(
      search: _searchQuery.isEmpty ? null : _searchQuery,
      category: _selectedCategory == 'all' ? null : _selectedCategory,
      status: _selectedStatus == 'all' ? null : _selectedStatus,
    ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        title: const Text('Hardware Assets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Scan QR Aset',
            onPressed: _openScanner,
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/assets/add'),
        backgroundColor: const Color(0xFF6E56CF),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Header Company Switcher & Date Range
          Container(
            color: const Color(0xFF0F172A),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                const CompanySwitcher(),
                const SizedBox(height: 12),
                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Cari nama, tag, S/N, atau brand aset...',
                    hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.white54),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filters Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Selector
                SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(cat == 'all' ? 'Semua Kategori' : cat),
                          selected: isSelected,
                          selectedColor: const Color(0xFF6E56CF).withOpacity(0.15),
                          checkmarkColor: const Color(0xFF6E56CF),
                          labelStyle: TextStyle(
                            color: isSelected ? const Color(0xFF6E56CF) : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = cat;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                // Status Selector
                SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _statuses.length,
                    itemBuilder: (context, index) {
                      final status = _statuses[index];
                      final isSelected = _selectedStatus == status;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(status == 'all' ? 'Semua Status' : _getStatusLabel(status)),
                          selected: isSelected,
                          selectedColor: _getStatusColor(status).withOpacity(0.15),
                          checkmarkColor: _getStatusColor(status),
                          labelStyle: TextStyle(
                            color: isSelected ? _getStatusColor(status) : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (selected) {
                            setState(() {
                              _selectedStatus = status;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Assets List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.refresh(assetListProvider(
                search: _searchQuery.isEmpty ? null : _searchQuery,
                category: _selectedCategory == 'all' ? null : _selectedCategory,
                status: _selectedStatus == 'all' ? null : _selectedStatus,
              ).future),
              child: assetsAsync.when(
                data: (assets) {
                  if (assets.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.computer, size: 64, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text(
                            'Tidak ada aset hardware ditemukan',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: assets.length + (ref.watch(assetListProvider(
                      search: _searchQuery.isEmpty ? null : _searchQuery,
                      category: _selectedCategory == 'all' ? null : _selectedCategory,
                      status: _selectedStatus == 'all' ? null : _selectedStatus,
                    ).notifier).hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == assets.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final asset = assets[index];
                      final statusColor = _getStatusColor(asset.status);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => context.push('/assets/${asset.id}'),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top row: Tag and Status badge
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.grey.shade300),
                                      ),
                                      child: Text(
                                        asset.assetTag,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          fontFamily: 'monospace',
                                          color: Color(0xFF1E293B),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        _getStatusLabel(asset.status),
                                        style: TextStyle(
                                          color: statusColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Asset Name
                                Text(
                                  asset.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                if (asset.brand != null || asset.model != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    '${asset.brand ?? ''} ${asset.model ?? ''}'.trim(),
                                    style: const TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                                const Divider(height: 24, color: Color(0xFFF1F5F9)),
                                // Footer row: Category, Assigned employee & office
                                Row(
                                  children: [
                                    // Category badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        asset.category,
                                        style: const TextStyle(
                                          color: Color(0xFF475569),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    // Assigned Info
                                    if (asset.employeeName != null) ...[
                                      const Icon(Icons.person_outline, size: 14, color: Color(0xFF64748B)),
                                      const SizedBox(width: 4),
                                      Text(
                                        asset.employeeName!,
                                        style: const TextStyle(fontSize: 12, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                                      ),
                                    ] else if (asset.officeName != null) ...[
                                      const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF64748B)),
                                      const SizedBox(width: 4),
                                      Text(
                                        asset.officeName!,
                                        style: const TextStyle(fontSize: 12, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                                      ),
                                    ] else ...[
                                      const Icon(Icons.info_outline, size: 14, color: Color(0xFF94A3B8)),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'Unassigned',
                                        style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontStyle: FontStyle.italic),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                  child: Text('Gagal memuat daftar aset: $err', style: const TextStyle(color: Colors.red)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AssetScanBottomSheet extends ConsumerStatefulWidget {
  const AssetScanBottomSheet({super.key});

  @override
  ConsumerState<AssetScanBottomSheet> createState() => _AssetScanBottomSheetState();
}

class _AssetScanBottomSheetState extends ConsumerState<AssetScanBottomSheet> with SingleTickerProviderStateMixin {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  late AnimationController _animationController;
  bool _isLoading = false;
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
    });

    try {
      final repository = ref.read(assetRepositoryProvider);
      final asset = await repository.getAssetByTag(cleanCode);

      if (mounted) {
        Navigator.pop(context); // Close bottom sheet
        context.push('/assets/${asset.id}'); // Navigate directly to details
      }
    } catch (e) {
      String msg = e.toString();
      if (msg.contains('404') || msg.contains('not found')) {
        msg = 'Tag aset "$cleanCode" tidak terdaftar di sistem.';
      } else {
        msg = 'Gagal melakukan verifikasi aset: ${e.toString()}';
      }
      setState(() {
        _errorMessage = msg;
        _isLoading = false;
      });
    }
  }

  void _resetScanner() {
    setState(() {
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
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Scan QR Code Aset',
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
            CircularProgressIndicator(color: Color(0xFF6E56CF)),
            SizedBox(height: 16),
            Text(
              'Mencari data aset...',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorState(_errorMessage!);
    }

    return Stack(
      children: [
        MobileScanner(
          controller: _scannerController,
          onDetect: _onDetect,
        ),
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
            Align(
              alignment: Alignment.center,
              child: Container(
                width: scanSize,
                height: scanSize,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF6E56CF), width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
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
                  'Arahkan kamera ke QR Code label aset',
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
            'Verifikasi Gagal',
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
                    backgroundColor: const Color(0xFF6E56CF),
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
}
