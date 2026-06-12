import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors; // kept for legacy Color references if needed
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../providers/asset_repository.dart';
import '../../../core/widgets/company_switcher.dart';
import '../../../core/providers/company_provider.dart';
import 'asset_detail_screen.dart';

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
  int? _selectedAssetId;

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
    showCupertinoModalPopup(
      context: context,
      builder: (context) => const AssetScanBottomSheet(),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return CupertinoColors.activeGreen;
      case 'assigned':
        return CupertinoColors.activeBlue;
      case 'maintenance':
        return CupertinoColors.systemOrange;
      case 'broken':
      case 'lost':
        return CupertinoColors.destructiveRed;
      case 'retired':
        return CupertinoColors.systemGrey;
      default:
        return CupertinoColors.systemGrey;
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

    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final isWide = MediaQuery.of(context).size.width > 900;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Hardware Assets'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.qrcode_viewfinder, size: 24),
              onPressed: _openScanner,
            ),
            const SizedBox(width: 12),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.add, size: 24),
              onPressed: () => context.push('/assets/add'),
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Company Switcher Header
            const CompanySwitcher(),
            
            // Search Bar Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: 'Cari nama, tag, S/N, atau brand aset...',
                onChanged: _onSearchChanged,
              ),
            ),

            // Horizontal Filters Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Selector
                  SizedBox(
                    height: 32,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final isSelected = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildCategoryChip(cat, isSelected),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Status Selector
                  SizedBox(
                    height: 32,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _statuses.length,
                      itemBuilder: (context, index) {
                        final status = _statuses[index];
                        final isSelected = _selectedStatus == status;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildStatusChip(status, isSelected),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Assets List or Dual Pane
            Expanded(
              child: assetsAsync.when(
                data: (assets) {
                  if (assets.isEmpty) {
                    final emptyView = CustomScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        CupertinoSliverRefreshControl(
                          onRefresh: () => ref.refresh(assetListProvider(
                            search: _searchQuery.isEmpty ? null : _searchQuery,
                            category: _selectedCategory == 'all' ? null : _selectedCategory,
                            status: _selectedStatus == 'all' ? null : _selectedStatus,
                          ).future),
                        ),
                        SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.device_laptop, size: 64, color: secondaryLabel.withOpacity(0.5)),
                                const SizedBox(height: 16),
                                Text(
                                  'Tidak ada aset hardware ditemukan',
                                  style: TextStyle(color: secondaryLabel, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                    
                    if (isWide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 380,
                            child: emptyView,
                          ),
                          Container(width: 0.5, color: separatorColor),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Tidak ada aset hardware ditemukan',
                                style: TextStyle(color: secondaryLabel),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return emptyView;
                  }

                  if (isWide) {
                    if (assets.isNotEmpty &&
                        (_selectedAssetId == null || !assets.any((x) => x.id == _selectedAssetId))) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _selectedAssetId = assets.first.id;
                          });
                        }
                      });
                    }
                  }

                  final hasMore = ref.watch(assetListProvider(
                    search: _searchQuery.isEmpty ? null : _searchQuery,
                    category: _selectedCategory == 'all' ? null : _selectedCategory,
                    status: _selectedStatus == 'all' ? null : _selectedStatus,
                  ).notifier).hasMore;

                  final mainList = CustomScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      CupertinoSliverRefreshControl(
                        onRefresh: () => ref.refresh(assetListProvider(
                          search: _searchQuery.isEmpty ? null : _searchQuery,
                          category: _selectedCategory == 'all' ? null : _selectedCategory,
                          status: _selectedStatus == 'all' ? null : _selectedStatus,
                        ).future),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index == assets.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(child: CupertinoActivityIndicator()),
                                );
                              }

                              final asset = assets[index];
                              final statusColor = _getStatusColor(asset.status);
                              final isSelected = _selectedAssetId == asset.id;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: cardBg,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected && isWide ? const Color(0xFF6E56CF) : separatorColor,
                                    width: isSelected && isWide ? 2.0 : 0.5,
                                  ),
                                ),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (isWide) {
                                      setState(() {
                                        _selectedAssetId = asset.id;
                                      });
                                    } else {
                                      context.push('/assets/${asset.id}');
                                    }
                                  },
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
                                                color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                                                borderRadius: BorderRadius.circular(6),
                                                border: Border.all(color: separatorColor, width: 0.5),
                                              ),
                                              child: Text(
                                                asset.assetTag,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  fontFamily: 'monospace',
                                                  color: labelColor,
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
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: labelColor,
                                          ),
                                        ),
                                        if (asset.brand != null || asset.model != null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            '${asset.brand ?? ''} ${asset.model ?? ''}'.trim(),
                                            style: TextStyle(
                                              color: secondaryLabel,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                                          child: Container(height: 0.5, color: separatorColor),
                                        ),
                                        // Footer row: Category, Assigned employee & office
                                        Row(
                                          children: [
                                            // Category badge
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                asset.category,
                                                style: TextStyle(
                                                  color: secondaryLabel,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            // Assigned Info
                                            if (asset.employeeName != null) ...[
                                              Icon(CupertinoIcons.person, size: 14, color: secondaryLabel),
                                              const SizedBox(width: 4),
                                              Text(
                                                asset.employeeName!,
                                                style: TextStyle(fontSize: 12, color: secondaryLabel, fontWeight: FontWeight.w500),
                                              ),
                                            ] else if (asset.officeName != null) ...[
                                              Icon(CupertinoIcons.location, size: 14, color: secondaryLabel),
                                              const SizedBox(width: 4),
                                              Text(
                                                asset.officeName!,
                                                style: TextStyle(fontSize: 12, color: secondaryLabel, fontWeight: FontWeight.w500),
                                              ),
                                            ] else ...[
                                              Icon(CupertinoIcons.info, size: 14, color: secondaryLabel.withOpacity(0.6)),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Unassigned',
                                                style: TextStyle(fontSize: 12, color: secondaryLabel.withOpacity(0.6), fontStyle: FontStyle.italic),
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
                            childCount: assets.length + (hasMore ? 1 : 0),
                          ),
                        ),
                      ),
                    ],
                  );

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 380,
                          child: mainList,
                        ),
                        Container(width: 0.5, color: separatorColor),
                        Expanded(
                          child: _selectedAssetId != null
                              ? AssetDetailContent(
                                  key: ValueKey(_selectedAssetId),
                                  assetId: _selectedAssetId!,
                                )
                              : Center(
                                  child: Text(
                                    'Pilih aset untuk melihat detail',
                                    style: TextStyle(color: secondaryLabel),
                                  ),
                                ),
                        ),
                      ],
                    );
                  }
                  return mainList;
                },
                loading: () => const Center(child: CupertinoActivityIndicator()),
                error: (err, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Gagal memuat daftar aset: $err', style: const TextStyle(color: CupertinoColors.destructiveRed)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String cat, bool isSelected) {
    final contextResolvedBg = isSelected
        ? const Color(0xFF6E56CF)
        : CupertinoColors.tertiarySystemFill.resolveFrom(context);
    final labelColor = isSelected
        ? CupertinoColors.white
        : CupertinoColors.label.resolveFrom(context);

    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = cat),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: contextResolvedBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          cat == 'all' ? 'Semua Kategori' : cat,
          style: TextStyle(
            color: labelColor,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, bool isSelected) {
    final statusColor = _getStatusColor(status);
    final contextResolvedBg = isSelected
        ? statusColor
        : CupertinoColors.tertiarySystemFill.resolveFrom(context);
    final labelColor = isSelected
        ? CupertinoColors.white
        : CupertinoColors.label.resolveFrom(context);

    return GestureDetector(
      onTap: () => setState(() => _selectedStatus = status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: contextResolvedBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          status == 'all' ? 'Semua Status' : _getStatusLabel(status),
          style: TextStyle(
            color: labelColor,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
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
        Navigator.pop(context);
        context.push('/assets/${asset.id}');
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
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Scan QR Code Aset'),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Text('Tutup'),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        child: SafeArea(
          child: _buildMainContent(),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(),
            SizedBox(height: 16),
            Text(
              'Mencari data aset...',
              style: TextStyle(fontSize: 14),
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
                CupertinoColors.black.withOpacity(0.6),
                BlendMode.srcOut,
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: CupertinoColors.black,
                      backgroundBlendMode: BlendMode.dstOut,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: scanSize,
                      height: scanSize,
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemRed,
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
                      color: CupertinoColors.systemRed,
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.systemRed,
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
                  color: CupertinoColors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Arahkan kamera ke QR Code label aset',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildView() {
    return Container();
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
              color: CupertinoColors.destructiveRed.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(CupertinoIcons.exclamationmark_triangle, color: CupertinoColors.destructiveRed, size: 48),
          ),
          const SizedBox(height: 16),
          const Text(
            'Verifikasi Gagal',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context), fontSize: 14),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: CupertinoButton(
                  color: CupertinoColors.quaternarySystemFill,
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup', style: TextStyle(color: CupertinoColors.label)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CupertinoButton.filled(
                  onPressed: _resetScanner,
                  child: const Text('Coba Lagi'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
