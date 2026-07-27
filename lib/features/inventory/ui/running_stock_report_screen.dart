import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/running_stock.dart';
import '../providers/running_stock_provider.dart';
import '../providers/inventory_provider.dart';
import 'running_stock_details_sheet.dart';
import '../../../core/providers/company_provider.dart';
import '../../../core/widgets/company_switcher.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';
import '../../../core/services/reporting_service.dart';

class RunningStockReportScreen extends ConsumerStatefulWidget {
  const RunningStockReportScreen({super.key});

  @override
  ConsumerState<RunningStockReportScreen> createState() => _RunningStockReportScreenState();
}

class _RunningStockReportScreenState extends ConsumerState<RunningStockReportScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isExporting = false;

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
      ref.read(runningStockListProvider.notifier).loadMore();
    }
  }

  String _formatNum(double value) {
    final formatter = NumberFormat('#,##0.##', 'id_ID');
    return formatter.format(value);
  }

  void _openDetailsSheet(BuildContext context, RunningStockItem item) {
    showCupertinoModalPopup(
      context: context,
      barrierColor: CupertinoColors.black.withValues(alpha: 0.4),
      builder: (context) => RunningStockDetailsSheet(item: item),
    );
  }

  Future<void> _exportReport(String type) async {
    if (_isExporting) return;
    setState(() => _isExporting = true);

    try {
      final repo = ref.read(inventoryRepositoryProvider);
      final company = ref.read(selectedCompanyProvider);
      final filter = ref.read(runningStockFilterProvider);
      final search = ref.read(runningStockSearchProvider);

      // Fetch full report data for export
      final response = await repo.getRunningStockReport(
        companyId: company?.id,
        search: search,
        filterOnHand: filter.filterOnHand,
        filterInTransit: filter.filterInTransit,
        filterOrdered: filter.filterOrdered,
        showEmpty: filter.showEmpty,
        page: 1,
        perPage: 1000,
      );

      final items = response.data;
      if (!mounted) return;

      if (items.isEmpty) {
        CupertinoGlassToast.showError(context, 'Tidak ada data untuk di-export.');
        return;
      }

      final companyName = company?.companyName ?? 'Semua_Perusahaan';
      final timeStr = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
      final fileName = 'Laporan_Stok_Berjalan_${companyName}_$timeStr';

      final headers = ['NO', 'SKU', 'NAMA BARANG', 'SATUAN', 'ON HAND', 'IN TRANSIT', 'ORDERED PO', 'TOTAL STOK'];

      if (type == 'excel') {
        final List<List<dynamic>> rows = [];
        for (int i = 0; i < items.length; i++) {
          final item = items[i];
          rows.add([
            i + 1,
            item.sku,
            item.name,
            item.unit,
            item.onHandQty,
            item.inTransitQty,
            item.orderedQty,
            item.totalQty,
          ]);
        }

        final reportingService = ReportingService();
        if (!mounted) return;
        await reportingService.exportToExcel(
          fileName: fileName,
          headers: headers,
          rows: rows,
          context: context,
        );
      } else if (type == 'pdf') {
        final List<List<String>> stringRows = [];
        for (int i = 0; i < items.length; i++) {
          final item = items[i];
          stringRows.add([
            (i + 1).toString(),
            item.sku,
            item.name,
            item.unit,
            _formatNum(item.onHandQty),
            _formatNum(item.inTransitQty),
            _formatNum(item.orderedQty),
            _formatNum(item.totalQty),
          ]);
        }

        final reportingService = ReportingService();
        await reportingService.generateAndPrintPdf(
          'Laporan Stok Berjalan ($companyName)',
          headers,
          stringRows,
        );
      }
    } catch (e) {
      if (mounted) {
        CupertinoGlassToast.showError(context, 'Gagal mengunduh $type: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final runningStockState = ref.watch(runningStockListProvider);
    final filterState = ref.watch(runningStockFilterProvider);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);

    final items = runningStockState.valueOrNull ?? [];

    double totalOnHand = 0;
    double totalInTransit = 0;
    double totalOrdered = 0;

    for (var item in items) {
      totalOnHand += item.onHandQty;
      totalInTransit += item.inTransitQty;
      totalOrdered += item.orderedQty;
    }

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Navigation Bar
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Laporan Stok Berjalan'),
            backgroundColor: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context).withValues(alpha: 0.96),
            border: Border(
              bottom: BorderSide(
                color: CupertinoColors.separator.resolveFrom(context),
                width: 0.5,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isExporting)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: CupertinoActivityIndicator(radius: 8),
                  )
                else ...[
                  // PDF Download
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _exportReport('pdf'),
                    child: const Icon(CupertinoIcons.printer_fill, size: 20, color: CupertinoColors.systemRed),
                  ),
                  const SizedBox(width: 4),
                  // Excel Download
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _exportReport('excel'),
                    child: const Icon(CupertinoIcons.doc_text_fill, size: 20, color: CupertinoColors.activeGreen),
                  ),
                ],
              ],
            ),
          ),

          // Pull to Refresh
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await ref.read(runningStockListProvider.notifier).fetchInitial();
            },
          ),

          // Filter & Search Controls
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company Switcher
                  const CompanySwitcher(),
                  const SizedBox(height: 12),

                  // Search Field
                  CupertinoSearchTextField(
                    controller: _searchController,
                    placeholder: 'Cari SKU atau Nama Produk...',
                    onChanged: (val) {
                      ref.read(runningStockSearchProvider.notifier).state = val.isEmpty ? null : val;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Checklist Filter Panel
                  CupertinoGlassContainer(
                    borderRadius: CupertinoSpacing.cardRadius,
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Filter Kategori Stok:',
                              style: context.caption1.copyWith(
                                fontWeight: FontWeight.bold,
                                color: labelColor,
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    ref.read(runningStockFilterProvider.notifier).state = const RunningStockFilterState(
                                      filterOnHand: true,
                                      filterInTransit: true,
                                      filterOrdered: true,
                                      showEmpty: true,
                                    );
                                  },
                                  child: Text(
                                    'Pilih Semua',
                                    style: context.caption2.copyWith(
                                      color: CupertinoColors.activeBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () {
                                    ref.read(runningStockFilterProvider.notifier).state = const RunningStockFilterState(
                                      filterOnHand: true,
                                      filterInTransit: true,
                                      filterOrdered: true,
                                      showEmpty: false,
                                    );
                                  },
                                  child: Text(
                                    'Reset',
                                    style: context.caption2.copyWith(
                                      color: CupertinoColors.secondaryLabel,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(height: 0.5, color: CupertinoColors.separator.resolveFrom(context)),
                        const SizedBox(height: 8),

                        // Checklist Options Grid/Wrap
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            _buildFilterCheckChip(
                              context: context,
                              label: 'On Hand',
                              color: CupertinoColors.activeBlue,
                              isChecked: filterState.filterOnHand,
                              onChanged: (val) {
                                ref.read(runningStockFilterProvider.notifier).state = filterState.copyWith(filterOnHand: val);
                              },
                            ),
                            _buildFilterCheckChip(
                              context: context,
                              label: 'In Transit',
                              color: CupertinoColors.activeOrange,
                              isChecked: filterState.filterInTransit,
                              onChanged: (val) {
                                ref.read(runningStockFilterProvider.notifier).state = filterState.copyWith(filterInTransit: val);
                              },
                            ),
                            _buildFilterCheckChip(
                              context: context,
                              label: 'Ordered PO',
                              color: CupertinoColors.activeGreen,
                              isChecked: filterState.filterOrdered,
                              onChanged: (val) {
                                ref.read(runningStockFilterProvider.notifier).state = filterState.copyWith(filterOrdered: val);
                              },
                            ),
                            _buildFilterCheckChip(
                              context: context,
                              label: 'Stok Kosong / Tampilkan Semua',
                              color: CupertinoColors.systemPurple,
                              isChecked: filterState.showEmpty,
                              onChanged: (val) {
                                ref.read(runningStockFilterProvider.notifier).state = filterState.copyWith(showEmpty: val);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Summary Statistics Widgets
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          context,
                          title: 'On Hand',
                          value: _formatNum(totalOnHand),
                          color: CupertinoColors.activeBlue,
                          icon: CupertinoIcons.archivebox,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildSummaryCard(
                          context,
                          title: 'In Transit',
                          value: _formatNum(totalInTransit),
                          color: CupertinoColors.activeOrange,
                          icon: CupertinoIcons.paperplane,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildSummaryCard(
                          context,
                          title: 'Ordered',
                          value: _formatNum(totalOrdered),
                          color: CupertinoColors.activeGreen,
                          icon: CupertinoIcons.cart,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Product List Section
          runningStockState.when(
            data: (runningStockItems) {
              if (runningStockItems.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            CupertinoIcons.tray,
                            size: 48,
                            color: CupertinoColors.secondaryLabel,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tidak ada data stok barang',
                            style: context.headline.copyWith(color: labelColor),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Coba ubah kata kunci pencarian atau aktifkan checklist filter.',
                            style: context.subhead.copyWith(color: secondaryLabelColor),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == runningStockItems.length) {
                        if (ref.read(runningStockListProvider.notifier).hasMore) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CupertinoActivityIndicator()),
                          );
                        } else {
                          return const SizedBox(height: 32);
                        }
                      }

                      final item = runningStockItems[index];
                      return _buildProductStockCard(context, item);
                    },
                    childCount: runningStockItems.length + 1,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CupertinoActivityIndicator(radius: 14),
              ),
            ),
            error: (err, stack) => SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(CupertinoIcons.exclamationmark_triangle_fill, size: 44, color: CupertinoColors.systemRed),
                      const SizedBox(height: 12),
                      Text('Gagal Memuat Laporan Stok', style: context.headline),
                      const SizedBox(height: 6),
                      Text('$err', style: context.caption1.copyWith(color: secondaryLabelColor), textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      CupertinoButton.filled(
                        onPressed: () => ref.read(runningStockListProvider.notifier).fetchInitial(),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCheckChip({
    required BuildContext context,
    required String label,
    required Color color,
    required bool isChecked,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!isChecked),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isChecked ? color.withValues(alpha: 0.15) : CupertinoColors.systemFill.resolveFrom(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isChecked ? color : CupertinoColors.separator.resolveFrom(context),
            width: isChecked ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isChecked ? CupertinoIcons.checkmark_square_fill : CupertinoIcons.square,
              size: 16,
              color: isChecked ? color : CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: context.caption1.copyWith(
                fontWeight: isChecked ? FontWeight.bold : FontWeight.w500,
                color: isChecked ? color : CupertinoColors.label.resolveFrom(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return CupertinoGlassContainer(
      borderRadius: CupertinoSpacing.cardRadius,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                title,
                style: context.caption2.copyWith(
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: context.title3.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductStockCard(BuildContext context, RunningStockItem item) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryColor = CupertinoColors.secondaryLabel.resolveFrom(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: CupertinoGlassContainer(
        borderRadius: CupertinoSpacing.cardRadius,
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SKU and Product Name
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: CupertinoColors.activeBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.sku,
                          style: context.caption2.copyWith(
                            color: CupertinoColors.activeBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.name,
                        style: context.subhead.copyWith(
                          fontWeight: FontWeight.bold,
                          color: labelColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey5.resolveFrom(context),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.unit,
                    style: context.caption2.copyWith(
                      fontWeight: FontWeight.w600,
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(height: 0.5, color: CupertinoColors.separator.resolveFrom(context)),
            const SizedBox(height: 12),

            // Metrics Badges Row
            Row(
              children: [
                Expanded(
                  child: _buildMetricBadge(
                    context,
                    label: 'On Hand',
                    value: _formatNum(item.onHandQty),
                    color: CupertinoColors.activeBlue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricBadge(
                    context,
                    label: 'In Transit',
                    value: _formatNum(item.inTransitQty),
                    color: CupertinoColors.activeOrange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricBadge(
                    context,
                    label: 'Ordered',
                    value: _formatNum(item.orderedQty),
                    color: CupertinoColors.activeGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Action: View Detail Breakdown
            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: CupertinoColors.activeBlue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                onPressed: () => _openDetailsSheet(context, item),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Lihat Detail Breakdown',
                      style: context.caption1.copyWith(
                        color: CupertinoColors.activeBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      CupertinoIcons.chevron_right,
                      size: 14,
                      color: CupertinoColors.activeBlue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricBadge(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: context.caption2.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: context.caption1.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
