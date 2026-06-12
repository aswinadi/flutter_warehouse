import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors; // kept for legacy Color references if needed
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/inventory_provider.dart';
import '../../../core/widgets/company_switcher.dart';
import 'barcode_lookup_bottom_sheet.dart';
import '../providers/inventory_breakdown_provider.dart';
import '../models/inventory_breakdown.dart';
import '../models/inventory.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  String? _searchText;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String? _selectedSku;

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
      ref.read(inventoryListProvider(search: _searchText).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 900;
    final inventoryAsync = ref.watch(inventoryListProvider(search: _searchText));
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    const primaryAccent = Color(0xFF6E56CF);

    Widget buildLeftPane() {
      return Column(
        children: [
          const CompanySwitcher(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CupertinoSearchTextField(
              controller: _searchController,
              placeholder: 'Cari SKU atau Produk...',
              onChanged: (val) {
                if (val.trim().isEmpty) {
                  setState(() {
                    _searchText = null;
                  });
                }
              },
              onSubmitted: (val) {
                setState(() {
                  _searchText = val.trim().isEmpty ? null : val.trim();
                });
              },
            ),
          ),
          Expanded(
            child: inventoryAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return const Center(child: Text('Tidak ada barang ditemukan di dalam stok'));
                }

                // Automatically select first item on large screen if nothing is selected
                if (isLargeScreen && _selectedSku == null && items.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _selectedSku = items.first.sku;
                    });
                  });
                }

                final hasMore = ref.watch(inventoryListProvider(search: _searchText).notifier).hasMore;
                final showLoader = inventoryAsync.isLoading && hasMore;

                return ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length + (showLoader ? 1 : 0),
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == items.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CupertinoActivityIndicator()),
                      );
                    }
                    final item = items[index];
                    final isSelected = isLargeScreen && item.sku == _selectedSku;

                    final tileBg = isSelected
                        ? primaryAccent.withOpacity(0.08)
                        : cardBg;
                    final tileBorder = Border.all(
                      color: isSelected ? primaryAccent : separatorColor,
                      width: isSelected ? 1.5 : 0.5,
                    );

                    return GestureDetector(
                      onTap: () {
                        if (isLargeScreen) {
                          setState(() {
                            _selectedSku = item.sku;
                          });
                        } else {
                          _showStockDetailBottomSheet(context, item.sku);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: tileBg,
                          borderRadius: BorderRadius.circular(12),
                          border: tileBorder,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName ?? 'Produk Tidak Dikenal',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: labelColor,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'SKU: ${item.sku}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: secondaryLabel,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Lokasi: ${item.locationCode ?? "Belum Ditentukan"}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: secondaryLabel,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${item.quantity}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? primaryAccent : CupertinoColors.activeBlue,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.unit ?? 'pcs',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: secondaryLabel,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      );
    }

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Stok Barang'),
      ),
      child: SafeArea(
        child: isLargeScreen
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: buildLeftPane(),
                  ),
                  Container(
                    width: 0.5,
                    color: separatorColor,
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                      child: _selectedSku != null
                          ? StockDetailPane(sku: _selectedSku!)
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.square_stack_3d_up,
                                    size: 48,
                                    color: secondaryLabel.withOpacity(0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Pilih barang untuk melihat detail rincian stok',
                                    style: TextStyle(color: secondaryLabel, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ],
              )
            : buildLeftPane(),
      ),
    );
  }

  void _showStockDetailBottomSheet(BuildContext context, String sku) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        final double sheetHeight = MediaQuery.of(context).size.height * 0.85;
        return Container(
          height: sheetHeight,
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text('Detail Rincian Stok'),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text('Tutup'),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            child: SafeArea(
              child: Consumer(
                builder: (context, ref, child) {
                  final breakdownAsync = ref.watch(inventoryBreakdownBySkuProvider(sku));
                  return breakdownAsync.when(
                    data: (breakdown) {
                      final totalOnHand = breakdown.onHand.fold<double>(0, (sum, wh) => sum + wh.quantity);
                      final totalInTransit = breakdown.inTransit.fold<double>(0, (sum, transit) => sum + transit.quantity);
                      final totalOrdered = breakdown.ordered.fold<double>(0, (sum, order) => sum + order.quantity);
                      final labelColor = CupertinoColors.label.resolveFrom(context);
                      final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
                      final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
                      final separatorColor = CupertinoColors.separator.resolveFrom(context);

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name & SKU Card
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: separatorColor, width: 0.5),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    breakdown.productName,
                                    style: TextStyle(
                                      color: labelColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'SKU: ${breakdown.sku}',
                                    style: TextStyle(color: secondaryLabel, fontSize: 13),
                                  ),
                                  const SizedBox(height: 12),
                                  CupertinoButton.filled(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    onPressed: () {
                                      Navigator.pop(context); // Close bottom sheet
                                      final firstWh = breakdown.onHand.isNotEmpty ? breakdown.onHand.first : null;
                                      final firstLoc = (firstWh != null && firstWh.locations.isNotEmpty) ? firstWh.locations.first : null;
                                      final item = Inventory(
                                        id: firstLoc?.inventoryId ?? 0,
                                        sku: breakdown.sku,
                                        productName: breakdown.productName,
                                        quantity: totalOnHand,
                                        status: 'available',
                                        warehouseName: firstWh?.warehouseName,
                                        locationCode: firstLoc?.locationCode,
                                        unit: breakdown.unit,
                                      );
                                      context.push('/inventory-adjustments', extra: item);
                                    },
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(CupertinoIcons.arrow_2_circlepath, size: 16),
                                        SizedBox(width: 8),
                                        Text(
                                          'Sesuaikan / Pakai Stok',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
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
                                    context,
                                    'Tersedia',
                                    totalOnHand,
                                    CupertinoColors.activeBlue.resolveFrom(context),
                                    CupertinoIcons.cube_box,
                                    breakdown.unit,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildSummaryGridItem(
                                    context,
                                    'Transit',
                                    totalInTransit,
                                    CupertinoColors.systemOrange.resolveFrom(context),
                                    CupertinoIcons.paperplane,
                                    breakdown.unit,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildSummaryGridItem(
                                    context,
                                    'Dipesan',
                                    totalOrdered,
                                    CupertinoColors.systemPurple.resolveFrom(context),
                                    CupertinoIcons.doc_text,
                                    breakdown.unit,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // On Hand Breakdown
                            Text(
                              'Rincian Stok Tersedia (On Hand)',
                              style: TextStyle(
                                color: secondaryLabel,
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
                                  color: cardBg.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Tidak ada stok tersedia di gudang mana pun.',
                                  style: TextStyle(color: secondaryLabel, fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            else
                              ...breakdown.onHand.map((wh) => WarehouseStockTile(warehouse: wh, unit: breakdown.unit)),

                            const SizedBox(height: 20),

                            // In Transit Breakdown
                            Text(
                              'Rincian Dalam Perjalanan (In Transit)',
                              style: TextStyle(
                                color: secondaryLabel,
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
                                  color: cardBg.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Tidak ada transfer barang aktif saat ini.',
                                  style: TextStyle(color: secondaryLabel, fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            else
                              ...breakdown.inTransit.map((transit) => InTransitStockTile(transit: transit, unit: breakdown.unit)),

                            const SizedBox(height: 20),

                            // Ordered Breakdown
                            Text(
                              'Rincian Pesanan (On Order)',
                              style: TextStyle(
                                color: secondaryLabel,
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
                                  color: cardBg.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Tidak ada pesanan pembelian (PO) aktif untuk produk ini.',
                                  style: TextStyle(color: secondaryLabel, fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            else
                              ...breakdown.ordered.map((order) => OrderedStockTile(order: order, unit: breakdown.unit)),
                          ],
                        ),
                      );
                    },
                    loading: () => const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CupertinoActivityIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Memuat detail stok...',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    error: (err, stack) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          'Gagal mengambil rincian stok: $err',
                          style: const TextStyle(color: CupertinoColors.destructiveRed, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryGridItem(
    BuildContext context,
    String title,
    double qty,
    Color accentColor,
    IconData icon,
    String unit,
  ) {
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
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
                style: TextStyle(color: secondaryLabel, fontSize: 11, fontWeight: FontWeight.w500),
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
                  style: TextStyle(color: secondaryLabel.withOpacity(0.6), fontSize: 10),
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
}

class StockDetailPane extends ConsumerWidget {
  final String sku;
  const StockDetailPane({super.key, required this.sku});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakdownAsync = ref.watch(inventoryBreakdownBySkuProvider(sku));
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return breakdownAsync.when(
      data: (breakdown) {
        final totalOnHand = breakdown.onHand.fold<double>(0, (sum, wh) => sum + wh.quantity);
        final totalInTransit = breakdown.inTransit.fold<double>(0, (sum, transit) => sum + transit.quantity);
        final totalOrdered = breakdown.ordered.fold<double>(0, (sum, order) => sum + order.quantity);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Details Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: separatorColor, width: 0.5),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      breakdown.productName,
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'SKU: ${breakdown.sku}',
                      style: TextStyle(color: secondaryLabel, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    CupertinoButton.filled(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      onPressed: () {
                        final firstWh = breakdown.onHand.isNotEmpty ? breakdown.onHand.first : null;
                        final firstLoc = (firstWh != null && firstWh.locations.isNotEmpty) ? firstWh.locations.first : null;
                        final item = Inventory(
                          id: firstLoc?.inventoryId ?? 0,
                          sku: breakdown.sku,
                          productName: breakdown.productName,
                          quantity: totalOnHand,
                          status: 'available',
                          warehouseName: firstWh?.warehouseName,
                          locationCode: firstLoc?.locationCode,
                          unit: breakdown.unit,
                        );
                        context.push('/inventory-adjustments', extra: item);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.arrow_2_circlepath, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'Sesuaikan / Pakai Stok',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Summary Grid
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryGridItem(
                      context,
                      'Tersedia',
                      totalOnHand,
                      CupertinoColors.activeBlue.resolveFrom(context),
                      CupertinoIcons.cube_box,
                      breakdown.unit,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryGridItem(
                      context,
                      'Transit',
                      totalInTransit,
                      CupertinoColors.systemOrange.resolveFrom(context),
                      CupertinoIcons.paperplane,
                      breakdown.unit,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryGridItem(
                      context,
                      'Dipesan',
                      totalOrdered,
                      CupertinoColors.systemPurple.resolveFrom(context),
                      CupertinoIcons.doc_text,
                      breakdown.unit,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Rincian On Hand
              Text(
                'Rincian Stok Tersedia (On Hand)',
                style: TextStyle(color: labelColor, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (breakdown.onHand.isEmpty)
                _buildEmptyCard(context, 'Tidak ada stok tersedia di gudang mana pun.')
              else
                ...breakdown.onHand.map((wh) => WarehouseStockTile(warehouse: wh, unit: breakdown.unit)),

              const SizedBox(height: 24),

              // Rincian In Transit
              Text(
                'Rincian Dalam Perjalanan (In Transit)',
                style: TextStyle(color: labelColor, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (breakdown.inTransit.isEmpty)
                _buildEmptyCard(context, 'Tidak ada transfer barang aktif.')
              else
                ...breakdown.inTransit.map((transit) => InTransitStockTile(transit: transit, unit: breakdown.unit)),

              const SizedBox(height: 24),

              // Rincian Ordered
              Text(
                'Rincian Pesanan (On Order)',
                style: TextStyle(color: labelColor, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (breakdown.ordered.isEmpty)
                _buildEmptyCard(context, 'Tidak ada pesanan pembelian aktif.')
              else
                ...breakdown.ordered.map((order) => OrderedStockTile(order: order, unit: breakdown.unit)),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 100.0),
          child: CupertinoActivityIndicator(),
        ),
      ),
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            'Gagal memuat detail stok: $err',
            style: const TextStyle(color: CupertinoColors.destructiveRed),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryGridItem(
    BuildContext context,
    String title,
    double qty,
    Color accentColor,
    IconData icon,
    String unit,
  ) {
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 18, color: accentColor),
              Text(
                title,
                style: TextStyle(color: secondaryLabel, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text(
                qty % 1 == 0 ? qty.toInt().toString() : qty.toString(),
                style: TextStyle(
                  color: accentColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  unit,
                  style: TextStyle(color: secondaryLabel.withOpacity(0.6), fontSize: 12),
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

  Widget _buildEmptyCard(BuildContext context, String text) {
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: secondaryLabel, fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }
}
