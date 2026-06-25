import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/inventory_provider.dart';
import '../../../core/widgets/company_switcher.dart';
import 'barcode_lookup_bottom_sheet.dart';
import '../providers/inventory_breakdown_provider.dart';
import '../models/inventory.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_search_field.dart';

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
    const primaryAccent = CupertinoColors.activeBlue;

    Widget buildLeftPane() {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.halfScreenMargin),
            child: CupertinoGlassSearchField(
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
                  padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                  itemCount: items.length + (showLoader ? 1 : 0),
                  separatorBuilder: (context, index) => const SizedBox(height: CupertinoSpacing.m),
                  itemBuilder: (context, index) {
                    if (index == items.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: CupertinoSpacing.screenMargin),
                        child: Center(child: CupertinoActivityIndicator()),
                      );
                    }
                    final item = items[index];
                    final isSelected = isLargeScreen && item.sku == _selectedSku;

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
                      child: CupertinoGlassContainer(
                        padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                        borderColor: isSelected ? primaryAccent : null,
                        backgroundColor: isSelected ? primaryAccent.withValues(alpha: 0.08) : null,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName ?? 'Produk Tidak Dikenal',
                                    style: context.subhead.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: labelColor,
                                    ),
                                  ),
                                  const SizedBox(height: CupertinoSpacing.s),
                                  Text(
                                    'SKU: ${item.sku}',
                                    style: context.footnote.copyWith(
                                      color: secondaryLabel,
                                    ),
                                  ),
                                  const SizedBox(height: CupertinoSpacing.xs),
                                  Text(
                                    'Lokasi: ${item.locationCode ?? "Belum Ditentukan"}',
                                    style: context.caption1.copyWith(
                                      color: secondaryLabel,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: CupertinoSpacing.m),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${item.quantity}',
                                  style: context.title3.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? primaryAccent : CupertinoColors.activeBlue,
                                  ),
                                ),
                                const SizedBox(height: CupertinoSpacing.xs),
                                Text(
                                  item.unit ?? 'pcs',
                                  style: context.caption1.copyWith(
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
      backgroundColor: CupertinoColors.transparent,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Stok Barang'),
        trailing: CompanySwitcher(),
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
                                    color: secondaryLabel.withValues(alpha: 0.5),
                                  ),
                                  const SizedBox(height: CupertinoSpacing.screenMargin),
                                  Text(
                                    'Pilih barang untuk melihat detail rincian stok',
                                    style: context.subhead.copyWith(color: secondaryLabel),
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

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(CupertinoSpacing.xl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name & SKU Card
                            CupertinoGlassContainer(
                              padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    breakdown.productName,
                                    style: context.headline.copyWith(
                                      color: labelColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: CupertinoSpacing.s),
                                  Text(
                                    'SKU: ${breakdown.sku}',
                                    style: context.footnote.copyWith(color: secondaryLabel),
                                  ),
                                  const SizedBox(height: CupertinoSpacing.m),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: CupertinoButton.filled(
                                            padding: EdgeInsets.zero,
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
                                                Icon(CupertinoIcons.arrow_2_circlepath, size: 14),
                                                SizedBox(width: 4),
                                                Text('Sesuaikan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: CupertinoSpacing.s),
                                        Expanded(
                                          child: CupertinoButton.filled(
                                            padding: EdgeInsets.zero,
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
                                              context.push('/inventory-usages', extra: item);
                                            },
                                            child: const Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(CupertinoIcons.minus_circle, size: 14),
                                                SizedBox(width: 4),
                                                Text('Pakai Stok', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: CupertinoSpacing.l),

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
                                const SizedBox(width: CupertinoSpacing.s),
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
                                const SizedBox(width: CupertinoSpacing.s),
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
                            const SizedBox(height: CupertinoSpacing.xxl),

                            // On Hand Breakdown
                            Text(
                              'Rincian Stok Tersedia (On Hand)',
                              style: context.footnote.copyWith(
                                color: secondaryLabel,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: CupertinoSpacing.s),
                            if (breakdown.onHand.isEmpty)
                              _buildEmptyCard(context, 'Tidak ada stok tersedia di gudang mana pun.')
                            else
                              ...breakdown.onHand.map((wh) => WarehouseStockTile(warehouse: wh, unit: breakdown.unit)),

                            const SizedBox(height: CupertinoSpacing.xl),

                            // In Transit Breakdown
                            Text(
                              'Rincian Dalam Perjalanan (In Transit)',
                              style: context.footnote.copyWith(
                                color: secondaryLabel,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: CupertinoSpacing.s),
                            if (breakdown.inTransit.isEmpty)
                              _buildEmptyCard(context, 'Tidak ada transfer barang aktif saat ini.')
                            else
                              ...breakdown.inTransit.map((transit) => InTransitStockTile(transit: transit, unit: breakdown.unit)),

                            const SizedBox(height: CupertinoSpacing.xl),

                            // Ordered Breakdown
                            Text(
                              'Rincian Pesanan (On Order)',
                              style: context.footnote.copyWith(
                                color: secondaryLabel,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: CupertinoSpacing.s),
                            if (breakdown.ordered.isEmpty)
                              _buildEmptyCard(context, 'Tidak ada pesanan pembelian (PO) aktif untuk produk ini.')
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
                          SizedBox(height: CupertinoSpacing.screenMargin),
                          Text(
                            'Memuat detail stok...',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    error: (err, stack) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(CupertinoSpacing.xxl),
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
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    return CupertinoGlassContainer(
      padding: const EdgeInsets.all(CupertinoSpacing.m),
      borderColor: accentColor.withValues(alpha: 0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 16, color: accentColor),
              Text(
                title,
                style: context.caption2.copyWith(color: secondaryLabel, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: CupertinoSpacing.s),
          Row(
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text(
                qty % 1 == 0 ? qty.toInt().toString() : qty.toString(),
                style: context.title3.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  unit,
                  style: context.caption2.copyWith(color: secondaryLabel.withValues(alpha: 0.6), fontSize: 10),
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
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    return CupertinoGlassContainer(
      padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
      backgroundColor: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context).withValues(alpha: 0.5),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          text,
          style: context.footnote.copyWith(color: secondaryLabel),
          textAlign: TextAlign.center,
        ),
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

    return breakdownAsync.when(
      data: (breakdown) {
        final totalOnHand = breakdown.onHand.fold<double>(0, (sum, wh) => sum + wh.quantity);
        final totalInTransit = breakdown.inTransit.fold<double>(0, (sum, transit) => sum + transit.quantity);
        final totalOrdered = breakdown.ordered.fold<double>(0, (sum, order) => sum + order.quantity);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(CupertinoSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Details Card
              CupertinoGlassContainer(
                padding: const EdgeInsets.all(CupertinoSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      breakdown.productName,
                      style: context.title3.copyWith(
                        color: labelColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: CupertinoSpacing.s),
                    Text(
                      'SKU: ${breakdown.sku}',
                      style: context.subhead.copyWith(color: secondaryLabel),
                    ),
                    const SizedBox(height: CupertinoSpacing.m),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: CupertinoButton.filled(
                              padding: EdgeInsets.zero,
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
                                  Icon(CupertinoIcons.arrow_2_circlepath, size: 14),
                                  SizedBox(width: 4),
                                  Text('Sesuaikan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: CupertinoSpacing.s),
                          Expanded(
                            child: CupertinoButton.filled(
                              padding: EdgeInsets.zero,
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
                                context.push('/inventory-usages', extra: item);
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.minus_circle, size: 14),
                                  SizedBox(width: 4),
                                  Text('Pakai Stok', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: CupertinoSpacing.xl),

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
                  const SizedBox(width: CupertinoSpacing.m),
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
                  const SizedBox(width: CupertinoSpacing.m),
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
              const SizedBox(height: CupertinoSpacing.xxl),

              // Rincian On Hand
              Text(
                'Rincian Stok Tersedia (On Hand)',
                style: context.subhead.copyWith(color: labelColor, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: CupertinoSpacing.s),
              if (breakdown.onHand.isEmpty)
                _buildEmptyCard(context, 'Tidak ada stok tersedia di gudang mana pun.')
              else
                ...breakdown.onHand.map((wh) => WarehouseStockTile(warehouse: wh, unit: breakdown.unit)),

              const SizedBox(height: CupertinoSpacing.xxl),

              // Rincian In Transit
              Text(
                'Rincian Dalam Perjalanan (In Transit)',
                style: context.subhead.copyWith(color: labelColor, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: CupertinoSpacing.s),
              if (breakdown.inTransit.isEmpty)
                _buildEmptyCard(context, 'Tidak ada transfer barang aktif.')
              else
                ...breakdown.inTransit.map((transit) => InTransitStockTile(transit: transit, unit: breakdown.unit)),

              const SizedBox(height: CupertinoSpacing.xxl),

              // Rincian Ordered
              Text(
                'Rincian Pesanan (On Order)',
                style: context.subhead.copyWith(color: labelColor, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: CupertinoSpacing.s),
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
          padding: const EdgeInsets.all(CupertinoSpacing.xxl),
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
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    return CupertinoGlassContainer(
      padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
      borderColor: accentColor.withValues(alpha: 0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 18, color: accentColor),
              Text(
                title,
                style: context.caption1.copyWith(color: secondaryLabel, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: CupertinoSpacing.s),
          Row(
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text(
                qty % 1 == 0 ? qty.toInt().toString() : qty.toString(),
                style: context.title2.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  unit,
                  style: context.caption1.copyWith(color: secondaryLabel.withValues(alpha: 0.6)),
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
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    return CupertinoGlassContainer(
      padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
      backgroundColor: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context).withValues(alpha: 0.5),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          text,
          style: context.footnote.copyWith(color: secondaryLabel),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
