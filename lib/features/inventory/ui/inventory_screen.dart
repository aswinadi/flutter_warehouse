import 'package:flutter/material.dart';
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

    Widget buildLeftPane() {
      return Column(
        children: [
          const CompanySwitcher(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari SKU atau Produk...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchText = null;
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
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
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final item = items[index];
                    final isSelected = isLargeScreen && item.sku == _selectedSku;

                    return Card(
                      margin: EdgeInsets.zero,
                      shape: isSelected
                          ? RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Color(0xFF6E56CF), width: 2),
                            )
                          : RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                      color: isSelected ? const Color(0xFF1E293B) : null,
                      child: ListTile(
                        onTap: () {
                          if (isLargeScreen) {
                            setState(() {
                              _selectedSku = item.sku;
                            });
                          } else {
                            _showStockDetailBottomSheet(context, item.sku);
                          }
                        },
                        title: Text(
                          item.productName ?? 'Produk Tidak Dikenal',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : null,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SKU: ${item.sku}',
                              style: TextStyle(color: isSelected ? Colors.white70 : null),
                            ),
                            Text(
                              'Lokasi: ${item.locationCode ?? "Belum Ditentukan"}',
                              style: TextStyle(color: isSelected ? Colors.white54 : null),
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${item.quantity}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? const Color(0xFF38BDF8) : Colors.blue,
                              ),
                            ),
                            Text(
                              item.unit ?? 'pcs',
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected ? Colors.white30 : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stok Barang'),
      ),
      body: isLargeScreen
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: buildLeftPane(),
                ),
                const VerticalDivider(
                  width: 1,
                  color: Colors.white10,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: const Color(0xFF0F172A),
                    child: _selectedSku != null
                        ? StockDetailPane(sku: _selectedSku!)
                        : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.inventory_2_outlined, size: 48, color: Colors.white24),
                                SizedBox(height: 16),
                                Text(
                                  'Pilih barang untuk melihat detail rincian stok',
                                  style: TextStyle(color: Colors.white38, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            )
          : buildLeftPane(),
    );
  }

  void _showStockDetailBottomSheet(BuildContext context, String sku) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final double sheetHeight = MediaQuery.of(context).size.height * 0.85;
        return Container(
          height: sheetHeight,
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              // Handle Bar
              Center(
                child: Container(
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
                      'Detail Rincian Stok',
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
                child: Consumer(
                  builder: (context, ref, child) {
                    final breakdownAsync = ref.watch(inventoryBreakdownBySkuProvider(sku));
                    return breakdownAsync.when(
                      data: (breakdown) {
                        final totalOnHand = breakdown.onHand.fold<double>(0, (sum, wh) => sum + wh.quantity);
                        final totalInTransit = breakdown.inTransit.fold<double>(0, (sum, transit) => sum + transit.quantity);
                        final totalOrdered = breakdown.ordered.fold<double>(0, (sum, order) => sum + order.quantity);

                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Name & SKU Card
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E293B),
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
                                    const SizedBox(height: 12),
                                    ElevatedButton.icon(
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
                                      icon: const Icon(Icons.settings_backup_restore, size: 16),
                                      label: const Text('Sesuaikan / Pakai Stok'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF6E56CF),
                                        foregroundColor: Colors.white,
                                        minimumSize: const Size.fromHeight(40),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

                              // On Hand Breakdown
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
                            ],
                          ),
                        );
                      },
                      loading: () => const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Color(0xFF6E56CF)),
                            SizedBox(height: 16),
                            Text(
                              'Memuat detail stok...',
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      error: (err, stack) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            'Gagal mengambil rincian stok: $err',
                            style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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
}

class StockDetailPane extends ConsumerWidget {
  final String sku;
  const StockDetailPane({super.key, required this.sku});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakdownAsync = ref.watch(inventoryBreakdownBySkuProvider(sku));
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
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      breakdown.productName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'SKU: ${breakdown.sku}',
                      style: const TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
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
                      icon: const Icon(Icons.settings_backup_restore, size: 16),
                      label: const Text('Sesuaikan / Pakai Stok'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6E56CF),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                      'Tersedia',
                      totalOnHand,
                      const Color(0xFF38BDF8),
                      Icons.inventory_2_outlined,
                      breakdown.unit,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSummaryGridItem(
                      'Transit',
                      totalInTransit,
                      Colors.amber,
                      Icons.local_shipping_outlined,
                      breakdown.unit,
                    ),
                  ),
                  const SizedBox(width: 12),
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
              const SizedBox(height: 28),

              // Rincian On Hand
              const Text(
                'Rincian Stok Tersedia (On Hand)',
                style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (breakdown.onHand.isEmpty)
                _buildEmptyCard('Tidak ada stok tersedia di gudang mana pun.')
              else
                ...breakdown.onHand.map((wh) => WarehouseStockTile(warehouse: wh, unit: breakdown.unit)),

              const SizedBox(height: 24),

              // Rincian In Transit
              const Text(
                'Rincian Dalam Perjalanan (In Transit)',
                style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (breakdown.inTransit.isEmpty)
                _buildEmptyCard('Tidak ada transfer barang aktif.')
              else
                ...breakdown.inTransit.map((transit) => InTransitStockTile(transit: transit, unit: breakdown.unit)),

              const SizedBox(height: 24),

              // Rincian Ordered
              const Text(
                'Rincian Pesanan (On Order)',
                style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (breakdown.ordered.isEmpty)
                _buildEmptyCard('Tidak ada pesanan pembelian aktif.')
              else
                ...breakdown.ordered.map((order) => OrderedStockTile(order: order, unit: breakdown.unit)),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 100.0),
          child: CircularProgressIndicator(color: Color(0xFF6E56CF)),
        ),
      ),
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            'Gagal memuat detail stok: $err',
            style: const TextStyle(color: Colors.redAccent),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryGridItem(String title, double qty, Color accentColor, IconData icon, String unit) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              Icon(icon, size: 18, color: accentColor),
              Text(
                title,
                style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w500),
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
                  style: const TextStyle(color: Colors.white30, fontSize: 12),
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

  Widget _buildEmptyCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white38, fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }
}

