import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/company_provider.dart';
import '../../../core/providers/warehouse_provider.dart';
import '../../../core/widgets/company_switcher.dart';
import '../../../core/models/company.dart';
import '../../../core/models/warehouse.dart';
import '../models/stock_mutation.dart';
import '../providers/stock_mutation_provider.dart';

class StockMutationScreen extends ConsumerStatefulWidget {
  const StockMutationScreen({super.key});

  @override
  ConsumerState<StockMutationScreen> createState() => _StockMutationScreenState();
}

class _StockMutationScreenState extends ConsumerState<StockMutationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _summaryScrollController = ScrollController();
  final ScrollController _detailScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String? _selectedSku;
  String? _selectedProductName;
  String? _selectedProductUnit;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _summaryScrollController.addListener(_onSummaryScroll);
    _detailScrollController.addListener(_onDetailScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
      helpText: 'Pilih Rentang Tanggal Mutasi',
      confirmText: 'PILIH',
      cancelText: 'BATAL',
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

    // Get warehouses list filtered by active company
    final filteredWarehouses = warehousesAsync.maybeWhen(
      data: (list) => company != null
          ? list.where((w) => w.companyId == company.id).toList()
          : [],
      orElse: () => [],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mutasi Stok & Kartu Stok'),
        bottom: isWide
            ? null
            : TabBar(
                controller: _tabController,
                indicatorColor: Theme.of(context).colorScheme.primary,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(icon: Icon(Icons.list_alt), text: 'Ringkasan Mutasi'),
                  Tab(icon: Icon(Icons.history), text: 'Detail Kartu Stok'),
                ],
              ),
      ),
      body: Column(
        children: [
          const CompanySwitcher(),
          _buildFilterPanel(filteredWarehouses, warehouse, dateRange),
          Expanded(
            child: isWide
                ? Row(
                    children: [
                      SizedBox(
                        width: 480,
                        child: _buildSummaryTabContent(isWide: true),
                      ),
                      const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                      Expanded(
                        child: _selectedSku != null
                            ? _buildDetailCardView(isWide: true)
                            : const Center(
                                child: Text(
                                  'Pilih produk dari ringkasan mutasi di panel kiri untuk melihat Kartu Stok',
                                  style: TextStyle(color: Colors.grey, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                      ),
                    ],
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildSummaryTabContent(isWide: false),
                      _selectedSku != null
                          ? _buildDetailCardView(isWide: false)
                          : const Center(
                              child: Text(
                                'Harap pilih produk dari tab Ringkasan Mutasi terlebih dahulu',
                                style: TextStyle(color: Colors.grey, fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            ),
                    ],
                  ),
          ),
        ],
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      color: Colors.grey.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<dynamic>(
                  value: company == null ? null : selectedWarehouse,
                  decoration: InputDecoration(
                    labelText: company == null ? 'Pilih Perusahaan Terlebih Dahulu' : 'Pilih Gudang',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: company == null ? Colors.grey.shade100 : Colors.white,
                  ),
                  items: company == null
                      ? null
                      : warehouses.map((w) {
                          return DropdownMenuItem<dynamic>(
                            value: w,
                            child: Text(w.name),
                          );
                        }).toList(),
                  onChanged: company == null
                      ? null
                      : (val) {
                          ref.read(selectedWarehouseProvider.notifier).selectWarehouse(val);
                        },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: _selectDateRange,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Periode: ${_formatDate(range.start)} - ${_formatDate(range.end)}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.date_range, size: 16, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildPresetChip('Hari Ini', isToday, () => _selectPresetRange('today')),
                const SizedBox(width: 8),
                _buildPresetChip('Bulan Ini', isThisMonth, () => _selectPresetRange('month')),
                const SizedBox(width: 8),
                _buildPresetChip('30 Hari Terakhir', isLast30Days, () => _selectPresetRange('30days')),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Rentang Kustom...'),
                  selected: !isToday && !isThisMonth && !isLast30Days,
                  onSelected: (_) => _selectDateRange(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(String label, bool isSelected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
    );
  }

  Widget _buildSummaryTabContent({required bool isWide}) {
    final listAsync = ref.watch(stockMutationSummaryListProvider);
    final company = ref.watch(selectedCompanyProvider);
    final warehouse = ref.watch(selectedWarehouseProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari SKU atau nama produk...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                        ref.read(stockMutationSearchQueryProvider.notifier).setQuery('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
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
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.business_center_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Pilih Perusahaan & Gudang Terlebih Dahulu',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Untuk melihat laporan mutasi dan kartu stok, silakan pilih perusahaan dan gudang pada filter di atas.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (items.isEmpty) {
                return const Center(
                  child: Text(
                    'Tidak ada data mutasi untuk periode/kriteria ini',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              final hasMore = ref.read(stockMutationSummaryListProvider.notifier).hasMore;

              return ListView.separated(
                controller: _summaryScrollController,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                itemCount: items.length + (hasMore ? 1 : 0),
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  if (index == items.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final item = items[index];
                  final isSelected = item.sku == _selectedSku;

                  return Card(
                    elevation: isSelected ? 3 : 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedSku = item.sku;
                          _selectedProductName = item.productName;
                          _selectedProductUnit = item.unit;
                        });
                        if (!isWide) {
                          _tabController.animateTo(1);
                        }
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.productName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'SKU: ${item.sku}',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                            const Divider(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildMiniStatCol('Awal', item.initialBalance, item.unit),
                                _buildMiniStatCol('Masuk', item.periodIn, item.unit, color: Colors.green),
                                _buildMiniStatCol('Keluar', item.periodOut, item.unit, color: Colors.red),
                                _buildMiniStatCol('Akhir', item.endingBalance, item.unit, color: Colors.blue, bold: true),
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
              child: Text(
                'Gagal memuat ringkasan mutasi: $err',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStatCol(String label, int value, String unit, {Color? color, bool bold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 2),
        Text(
          '$value $unit',
          style: TextStyle(
            fontSize: 12,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            color: color,
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

    return detailsAsync.when(
      data: (logs) {
        return Column(
          children: [
            _buildDetailHeaderWidget(summaryHeader),
            Expanded(
              child: logs.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada riwayat transaksi mutasi untuk produk ini dalam periode terpilih',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.separated(
                      controller: _detailScrollController,
                      padding: const EdgeInsets.all(12),
                      itemCount: logs.length + (detailsNotifier.hasMore ? 1 : 0),
                      separatorBuilder: (context, index) => const Divider(height: 16),
                      itemBuilder: (context, index) {
                        if (index == logs.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final log = logs[index];
                        final isIncoming = log.inQty > 0;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    log.date,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isIncoming ? Colors.green.shade50 : Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      log.type.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: isIncoming ? Colors.green.shade700 : Colors.red.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          log.description ?? 'Tanpa keterangan',
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                        if (log.refNumber != null) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            'Ref: ${log.refNumber}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    isIncoming
                                        ? '+${log.inQty.toStringAsFixed(0)} ${_selectedProductUnit ?? ""}'
                                        : '-${log.outQty.toStringAsFixed(0)} ${_selectedProductUnit ?? ""}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isIncoming ? Colors.green.shade700 : Colors.red.shade700,
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
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            'Gagal memuat detail kartu stok: $err',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailHeaderWidget(StockMutationHeader? header) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedProductName ?? 'Detail Kartu Stok',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            'SKU: $_selectedSku',
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const Divider(height: 24),
          if (header != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHeaderStatCol('Awal', header.initialBalance),
                _buildHeaderStatCol('Masuk', header.totalIn, color: Colors.green),
                _buildHeaderStatCol('Keluar', header.totalOut, color: Colors.red),
                _buildHeaderStatCol('Akhir', header.endingBalance, color: Colors.blue, bold: true),
              ],
            )
          else
            const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderStatCol(String label, int value, {Color? color, bool bold = false}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 4),
        Text(
          '$value',
          style: TextStyle(
            fontSize: 16,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
        ),
        if (_selectedProductUnit != null) ...[
          const SizedBox(height: 2),
          Text(
            _selectedProductUnit!,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
          ),
        ],
      ],
    );
  }
}
