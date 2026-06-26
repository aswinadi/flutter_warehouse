import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show showDateRangePicker, DateTimeRange, Theme, ColorScheme, Colors;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/company_provider.dart';
import '../../../core/providers/warehouse_provider.dart';
import '../../../core/widgets/company_switcher.dart';
import '../../../core/models/company.dart';
import '../../../core/models/warehouse.dart';
import '../models/stock_mutation.dart';
import '../providers/stock_mutation_provider.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';

class StockMutationScreen extends ConsumerStatefulWidget {
  const StockMutationScreen({super.key});

  @override
  ConsumerState<StockMutationScreen> createState() => _StockMutationScreenState();
}

class _StockMutationScreenState extends ConsumerState<StockMutationScreen> {
  final ScrollController _summaryScrollController = ScrollController();
  final ScrollController _detailScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  int _selectedSegment = 0; // 0 for Summary, 1 for Detail (used in mobile view)
  String? _selectedSku;
  String? _selectedProductName;
  String? _selectedProductUnit;

  @override
  void initState() {
    super.initState();
    _summaryScrollController.addListener(_onSummaryScroll);
    _detailScrollController.addListener(_onDetailScroll);
  }

  @override
  void dispose() {
    _summaryScrollController.dispose();
    _detailScrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSummaryScroll() {
    if (!_summaryScrollController.hasClients) return;
    final maxScroll = _summaryScrollController.position.maxScrollExtent;
    final currentScroll = _summaryScrollController.position.pixels;
    if (currentScroll >= maxScroll * 0.9) {
      ref.read(stockMutationSummaryListProvider.notifier).loadMore();
    }
  }

  void _onDetailScroll() {
    if (!_detailScrollController.hasClients || _selectedSku == null) return;
    final maxScroll = _detailScrollController.position.maxScrollExtent;
    final currentScroll = _detailScrollController.position.pixels;
    if (currentScroll >= maxScroll * 0.9) {
      ref.read(stockCardDetailListProvider(_selectedSku!).notifier).loadMore();
    }
  }

  Future<void> _selectDateRange() async {
    final currentRange = ref.read(stockMutationDateRangeProvider);
    final pickedRange = await showDateRangePicker(
      context: context,
      initialDateRange: currentRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: CupertinoColors.activeBlue,
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedRange != null) {
      ref.read(stockMutationDateRangeProvider.notifier).selectRange(pickedRange);
    }
  }

  void _selectPresetRange(String preset) {
    final now = DateTime.now();
    DateTime start;
    switch (preset) {
      case 'today':
        start = DateTime(now.year, now.month, now.day);
        break;
      case '30days':
        start = now.subtract(const Duration(days: 30));
        break;
      case 'month':
      default:
        start = DateTime(now.year, now.month, 1);
        break;
    }
    ref.read(stockMutationDateRangeProvider.notifier).selectRange(
          DateTimeRange(start: start, end: now),
        );
  }

  String _formatDate(DateTime dt) {
    return DateFormat('dd/MM/yyyy').format(dt);
  }

  void _showWarehousePicker(BuildContext context, List<dynamic> warehouses) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Pilih Gudang'),
        actions: warehouses.map((w) {
          return CupertinoActionSheetAction(
            onPressed: () {
              ref.read(selectedWarehouseProvider.notifier).selectWarehouse(w);
              Navigator.pop(context);
            },
            child: Text(w.name),
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

  @override
  Widget build(BuildContext context) {
    ref.listen<Company?>(selectedCompanyProvider, (prev, next) {
      if (prev != next) {
        setState(() {
          _selectedSku = null;
          _selectedProductName = null;
          _selectedProductUnit = null;
        });
      }
    });

    ref.listen<Warehouse?>(selectedWarehouseProvider, (prev, next) {
      if (prev != next) {
        setState(() {
          _selectedSku = null;
          _selectedProductName = null;
          _selectedProductUnit = null;
        });
      }
    });

    final isWide = MediaQuery.of(context).size.width > 900;
    final company = ref.watch(selectedCompanyProvider);
    final warehouse = ref.watch(selectedWarehouseProvider);
    final dateRange = ref.watch(stockMutationDateRangeProvider);
    final warehousesAsync = ref.watch(warehousesProvider);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    // Get warehouses list filtered by active company
    final filteredWarehouses = warehousesAsync.maybeWhen(
      data: (list) => company != null
          ? list.where((w) => w.companyId == company.id).toList()
          : [],
      orElse: () => [],
    );

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Mutasi & Kartu Stok'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const CompanySwitcher(),
            _buildFilterPanel(filteredWarehouses, warehouse, dateRange),
            if (!isWide)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.halfScreenMargin),
                child: SizedBox(
                  width: double.infinity,
                  child: CupertinoSlidingSegmentedControl<int>(
                    groupValue: _selectedSegment,
                    children: const {
                      0: Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Text('Ringkasan Mutasi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      ),
                      1: Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Text('Detail Kartu Stok', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      ),
                    },
                    onValueChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedSegment = val;
                        });
                      }
                    },
                  ),
                ),
              ),
            Expanded(
              child: isWide
                  ? Row(
                      children: [
                        SizedBox(
                          width: 480,
                          child: _buildSummaryTabContent(isWide: true),
                        ),
                        Container(
                          width: 0.5,
                          color: separatorColor,
                        ),
                        Expanded(
                          child: _selectedSku != null
                              ? _buildDetailCardView(isWide: true)
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.square_stack_3d_down_right,
                                        size: 48,
                                        color: CupertinoColors.secondaryLabel.resolveFrom(context).withValues(alpha: 0.5),
                                      ),
                                      const SizedBox(height: CupertinoSpacing.screenMargin),
                                      Text(
                                        'Pilih produk dari ringkasan mutasi di panel kiri untuk melihat Kartu Stok',
                                        style: context.subhead.copyWith(
                                          color: CupertinoColors.secondaryLabel.resolveFrom(context),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    )
                  : IndexedStack(
                      index: _selectedSegment,
                      children: [
                        _buildSummaryTabContent(isWide: false),
                        _selectedSku != null
                            ? _buildDetailCardView(isWide: false)
                            : Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(CupertinoSpacing.xxl),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.list_bullet,
                                        size: 48,
                                        color: CupertinoColors.secondaryLabel.resolveFrom(context).withValues(alpha: 0.5),
                                      ),
                                      const SizedBox(height: CupertinoSpacing.screenMargin),
                                      Text(
                                        'Harap pilih produk dari tab Ringkasan Mutasi terlebih dahulu',
                                        style: context.subhead.copyWith(
                                          color: CupertinoColors.secondaryLabel.resolveFrom(context),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
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
    );
  }

  Widget _buildFilterPanel(List<dynamic> warehouses, dynamic selectedWarehouse, DateTimeRange range) {
    final company = ref.watch(selectedCompanyProvider);
    final now = DateTime.now();
    final isThisMonth = range.start.year == now.year &&
        range.start.month == now.month &&
        range.start.day == 1 &&
        range.end.day == now.day;
    final isToday = range.start.year == now.year &&
        range.start.month == now.month &&
        range.start.day == now.day &&
        range.end.day == now.day;
    final isLast30Days =
        range.start.isBefore(now.subtract(const Duration(days: 29))) &&
            range.start.isAfter(now.subtract(const Duration(days: 31))) &&
            range.end.day == now.day;

    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return CupertinoGlassContainer(
      borderRadius: 0,
      padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: company == null ? null : () => _showWarehousePicker(context, warehouses),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.m, vertical: CupertinoSpacing.m),
                    decoration: BoxDecoration(
                      color: company == null
                          ? CupertinoColors.tertiarySystemFill.resolveFrom(context)
                          : CupertinoColors.systemBackground.resolveFrom(context),
                      border: Border.all(color: separatorColor, width: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            company == null
                                ? 'Pilih Perusahaan Terlebih Dahulu'
                                : (selectedWarehouse != null ? selectedWarehouse.name : 'Pilih Gudang'),
                            style: context.footnote.copyWith(
                              color: company == null ? secondaryLabel : labelColor,
                              fontWeight: selectedWarehouse != null ? FontWeight.w500 : FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(CupertinoIcons.chevron_down, size: 14, color: secondaryLabel),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: CupertinoSpacing.m),
              Expanded(
                child: GestureDetector(
                  onTap: _selectDateRange,
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
                        Expanded(
                          child: Text(
                            'Periode: ${_formatDate(range.start)} - ${_formatDate(range.end)}',
                            style: context.caption1.copyWith(color: labelColor, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(CupertinoIcons.calendar, size: 16, color: secondaryLabel),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: CupertinoSpacing.m),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildPresetChip('Hari Ini', isToday, () => _selectPresetRange('today')),
                const SizedBox(width: CupertinoSpacing.s),
                _buildPresetChip('Bulan Ini', isThisMonth, () => _selectPresetRange('month')),
                const SizedBox(width: CupertinoSpacing.s),
                _buildPresetChip('30 Hari Terakhir', isLast30Days, () => _selectPresetRange('30days')),
                const SizedBox(width: CupertinoSpacing.s),
                _buildPresetChip('Rentang Kustom...', !isToday && !isThisMonth && !isLast30Days, _selectDateRange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(String label, bool isSelected, VoidCallback onTap) {
    final contextResolvedBg = isSelected
        ? CupertinoColors.activeBlue
        : CupertinoColors.tertiarySystemFill.resolveFrom(context);
    final labelColor = isSelected
        ? CupertinoColors.white
        : CupertinoColors.label.resolveFrom(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.m, vertical: CupertinoSpacing.s),
        decoration: BoxDecoration(
          color: contextResolvedBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: context.caption1.copyWith(
            color: labelColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryTabContent({required bool isWide}) {
    final listAsync = ref.watch(stockMutationSummaryListProvider);
    final company = ref.watch(selectedCompanyProvider);
    final warehouse = ref.watch(selectedWarehouseProvider);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.halfScreenMargin),
          child: CupertinoSearchTextField(
            controller: _searchController,
            placeholder: 'Cari SKU atau nama produk...',
            onChanged: (val) {
              ref.read(stockMutationSearchQueryProvider.notifier).setQuery(val);
            },
          ),
        ),
        Expanded(
          child: listAsync.when(
            data: (items) {
              if (company == null || warehouse == null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(CupertinoSpacing.xxl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.building_2_fill,
                          size: 64,
                          color: secondaryLabel.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: CupertinoSpacing.screenMargin),
                        Text(
                          'Pilih Perusahaan & Gudang Terlebih Dahulu',
                          style: context.headline.copyWith(
                            fontWeight: FontWeight.bold,
                            color: labelColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: CupertinoSpacing.s),
                        Text(
                          'Untuk melihat laporan mutasi dan kartu stok, silakan pilih perusahaan dan gudang pada filter di atas.',
                          style: context.footnote.copyWith(
                            color: secondaryLabel,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (items.isEmpty) {
                return Center(
                  child: Text(
                    'Tidak ada data mutasi untuk periode/kriteria ini',
                    style: context.body.copyWith(color: secondaryLabel),
                  ),
                );
              }

              final hasMore = ref.read(stockMutationSummaryListProvider.notifier).hasMore;

              return ListView.separated(
                controller: _summaryScrollController,
                padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.halfScreenMargin),
                itemCount: items.length + (hasMore ? 1 : 0),
                separatorBuilder: (context, index) => const SizedBox(height: CupertinoSpacing.s),
                itemBuilder: (context, index) {
                  if (index == items.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: CupertinoSpacing.screenMargin),
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  }

                  final item = items[index];
                  final isSelected = item.sku == _selectedSku;

                  return CupertinoGlassContainer(
                    borderColor: isSelected ? CupertinoColors.activeBlue : null,
                    padding: EdgeInsets.zero,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSku = item.sku;
                          _selectedProductName = item.productName;
                          _selectedProductUnit = item.unit;
                          if (!isWide) {
                            _selectedSegment = 1;
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.productName,
                              style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: CupertinoSpacing.xs),
                            Text(
                              'SKU: ${item.sku}',
                              style: context.caption1.copyWith(color: secondaryLabel),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.halfScreenMargin),
                              child: Container(height: 0.5, color: separatorColor),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildMiniStatCol('Awal', item.initialBalance, item.unit),
                                _buildMiniStatCol('Masuk', item.periodIn, item.unit, color: CupertinoColors.activeGreen),
                                _buildMiniStatCol('Keluar', item.periodOut, item.unit, color: CupertinoColors.destructiveRed),
                                _buildMiniStatCol('Akhir', item.endingBalance, item.unit, color: CupertinoColors.activeBlue, bold: true),
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
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (err, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                child: Text(
                  'Gagal memuat ringkasan mutasi: $err',
                  style: const TextStyle(color: CupertinoColors.destructiveRed),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStatCol(String label, int value, String unit, {Color? color, bool bold = false}) {
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: context.caption2.copyWith(color: secondaryLabel),
        ),
        const SizedBox(height: CupertinoSpacing.xs),
        Text(
          '$value $unit',
          style: context.caption1.copyWith(
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            color: color ?? labelColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCardView({required bool isWide}) {
    if (_selectedSku == null) return const SizedBox.shrink();

    final detailsAsync = ref.watch(stockCardDetailListProvider(_selectedSku!));
    final detailsNotifier = ref.watch(stockCardDetailListProvider(_selectedSku!).notifier);
    final summaryHeader = detailsNotifier.summaryHeader;
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return detailsAsync.when(
      data: (logs) {
        return Column(
          children: [
            _buildDetailHeaderWidget(summaryHeader),
            Expanded(
              child: logs.isEmpty
                  ? Center(
                      child: Text(
                        'Tidak ada riwayat transaksi mutasi untuk produk ini dalam periode terpilih',
                        style: context.subhead.copyWith(color: secondaryLabel),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.separated(
                      controller: _detailScrollController,
                      padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.halfScreenMargin),
                      itemCount: logs.length + (detailsNotifier.hasMore ? 1 : 0),
                      separatorBuilder: (context, index) => Container(height: 0.5, color: separatorColor),
                      itemBuilder: (context, index) {
                        if (index == logs.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: CupertinoSpacing.screenMargin),
                              child: CupertinoActivityIndicator(),
                            ),
                          );
                        }

                        final log = logs[index];
                        final isIncoming = log.inQty > 0;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.m),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    log.date,
                                    style: context.footnote.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.halfScreenMargin, vertical: CupertinoSpacing.xs),
                                    decoration: BoxDecoration(
                                      color: isIncoming
                                          ? CupertinoColors.activeGreen.withValues(alpha: 0.1)
                                          : CupertinoColors.destructiveRed.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      log.type.toUpperCase(),
                                      style: context.caption2.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isIncoming ? CupertinoColors.activeGreen : CupertinoColors.destructiveRed,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: CupertinoSpacing.s),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          log.description ?? 'Tanpa keterangan',
                                          style: context.footnote,
                                        ),
                                        if (log.refNumber != null) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            'Ref: ${log.refNumber}',
                                            style: context.caption2.copyWith(
                                              color: secondaryLabel,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: CupertinoSpacing.m),
                                  Text(
                                    isIncoming
                                        ? '+${log.inQty.toStringAsFixed(0)} ${_selectedProductUnit ?? ""}'
                                        : '-${log.outQty.toStringAsFixed(0)} ${_selectedProductUnit ?? ""}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isIncoming ? CupertinoColors.activeGreen : CupertinoColors.destructiveRed,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(CupertinoSpacing.xxl),
          child: Text(
            'Gagal memuat detail kartu stok: $err',
            style: const TextStyle(color: CupertinoColors.destructiveRed),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailHeaderWidget(StockMutationHeader? header) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return CupertinoGlassContainer(
      margin: const EdgeInsets.all(CupertinoSpacing.screenMargin),
      padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedProductName ?? 'Detail Kartu Stok',
            style: context.headline.copyWith(fontWeight: FontWeight.bold, color: labelColor),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: CupertinoSpacing.xs),
          Text(
            'SKU: $_selectedSku',
            style: context.footnote.copyWith(color: secondaryLabel),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.m),
            child: Container(height: 0.5, color: separatorColor),
          ),
          if (header != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHeaderStatCol('Awal', header.initialBalance),
                _buildHeaderStatCol('Masuk', header.totalIn, color: CupertinoColors.activeGreen),
                _buildHeaderStatCol('Keluar', header.totalOut, color: CupertinoColors.destructiveRed),
                _buildHeaderStatCol('Akhir', header.endingBalance, color: CupertinoColors.activeBlue, bold: true),
              ],
            )
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: CupertinoSpacing.halfScreenMargin),
                child: CupertinoActivityIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderStatCol(String label, int value, {Color? color, bool bold = false}) {
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    return Column(
      children: [
        Text(
          label,
          style: context.caption1.copyWith(color: secondaryLabel),
        ),
        const SizedBox(height: CupertinoSpacing.xs),
        Text(
          '$value',
          style: context.headline.copyWith(
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            color: color ?? labelColor,
          ),
        ),
        if (_selectedProductUnit != null) ...[
          const SizedBox(height: 2),
          Text(
            _selectedProductUnit!,
            style: context.caption2.copyWith(color: secondaryLabel.withValues(alpha: 0.6)),
          ),
        ],
      ],
    );
  }
}
