import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Tooltip, LinearProgressIndicator;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/company_provider.dart';
import '../../../core/widgets/adaptive_layout_builder.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_loading_indicator.dart';
import '../../../core/widgets/cupertino_mesh_background.dart';
import '../services/accounting_api_service.dart';

class BudgetVsActualScreen extends ConsumerStatefulWidget {
  const BudgetVsActualScreen({super.key});

  @override
  ConsumerState<BudgetVsActualScreen> createState() => _BudgetVsActualScreenState();
}

class _BudgetVsActualScreenState extends ConsumerState<BudgetVsActualScreen> {
  bool _isLoading = false;
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;
  String? _selectedCostCentre;

  Map<String, dynamic>? _budgetData;
  String? _errorMessage;

  static const List<String> _months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  @override
  void initState() {
    super.initState();
    _fetchBudgetData();
  }

  Future<void> _fetchBudgetData() async {
    final company = ref.read(currentCompanyProvider);
    if (company == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final api = ref.read(accountingApiServiceProvider);
      final data = await api.getBudgetVsActual(
        company.id,
        _selectedYear,
        _selectedMonth,
        costCentreCode: _selectedCostCentre,
      );

      setState(() {
        _budgetData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showMonthPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerRight,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pop(context),
                child: const Text('Selesai', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 36,
                scrollController: FixedExtentScrollController(initialItem: _selectedMonth - 1),
                onSelectedItemChanged: (index) {
                  setState(() => _selectedMonth = index + 1);
                  _fetchBudgetData();
                },
                children: _months.map((m) => Center(child: Text(m))).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showYearPicker(BuildContext context) {
    final years = List.generate(5, (index) => DateTime.now().year - 2 + index);
    final initialIndex = years.indexOf(_selectedYear);

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerRight,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pop(context),
                child: const Text('Selesai', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 36,
                scrollController: FixedExtentScrollController(initialItem: initialIndex >= 0 ? initialIndex : 2),
                onSelectedItemChanged: (index) {
                  setState(() => _selectedYear = years[index]);
                  _fetchBudgetData();
                },
                children: years.map((y) => Center(child: Text('$y'))).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Analisis Budget vs Actual'),
        trailing: Tooltip(
          message: 'Refresh Data',
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _fetchBudgetData,
            child: const Icon(CupertinoIcons.refresh, size: 22),
          ),
        ),
      ),
      child: CupertinoMeshBackground(
        child: SafeArea(
          child: AdaptiveLayoutBuilder(
            mobileBuilder: (context, constraints) => _buildBody(currency, isDesktop: false),
            desktopBuilder: (context, constraints) => _buildBody(currency, isDesktop: true),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(NumberFormat currency, {required bool isDesktop}) {
    final company = ref.watch(currentCompanyProvider);

    return Padding(
      padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Bar
          CupertinoGlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            borderRadius: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(CupertinoIcons.building_2_fill, size: 18, color: CupertinoColors.activeBlue),
                    const SizedBox(width: 8),
                    Text(
                      company?.companyName ?? 'Perusahaan',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      color: CupertinoColors.activeBlue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      onPressed: () => _showMonthPicker(context),
                      child: Text(
                        _months[_selectedMonth - 1],
                        style: const TextStyle(color: CupertinoColors.activeBlue, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      color: CupertinoColors.activeBlue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      onPressed: () => _showYearPicker(context),
                      child: Text(
                        '$_selectedYear',
                        style: const TextStyle(color: CupertinoColors.activeBlue, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Main Content
          Expanded(
            child: _isLoading
                ? const Center(child: CupertinoGlassLoadingIndicator())
                : _errorMessage != null
                    ? Center(child: Text(_errorMessage!, style: const TextStyle(color: CupertinoColors.systemRed)))
                    : _budgetData == null
                        ? const Center(child: Text('Tidak ada data anggaran.'))
                        : _buildDashboardContent(currency),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(NumberFormat currency) {
    final totalBudget = (_budgetData!['total_budget'] as num? ?? 0).toDouble();
    final totalActual = (_budgetData!['total_actual'] as num? ?? 0).toDouble();
    final totalVariance = (_budgetData!['total_variance'] as num? ?? 0).toDouble();
    final items = _budgetData!['items'] as List<dynamic>? ?? [];

    final overallPct = totalBudget > 0 ? (totalActual / totalBudget) * 100 : 0.0;

    return Column(
      children: [
        // 4 Summary Cards
        Row(
          children: [
            Expanded(child: _summaryCard('Total Anggaran', currency.format(totalBudget), CupertinoColors.activeBlue)),
            const SizedBox(width: 10),
            Expanded(child: _summaryCard('Total Realisasi', currency.format(totalActual), CupertinoColors.systemIndigo)),
            const SizedBox(width: 10),
            Expanded(child: _summaryCard('Sisa Pagu', currency.format(totalVariance), totalVariance < 0 ? CupertinoColors.systemRed : CupertinoColors.activeGreen)),
            const SizedBox(width: 10),
            Expanded(child: _summaryCard('Realisasi (%)', '${overallPct.toStringAsFixed(1)}%', overallPct > 100 ? CupertinoColors.systemRed : CupertinoColors.activeGreen, isBold: true)),
          ],
        ),
        const SizedBox(height: 16),

        // Items List
        Expanded(
          child: items.isEmpty
              ? const Center(child: Text('Belum ada rincian anggaran untuk periode ini.'))
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final bAmt = (item['budget_amount'] as num? ?? 0).toDouble();
                    final aAmt = (item['actual_amount'] as num? ?? 0).toDouble();
                    final variance = (item['variance'] as num? ?? 0).toDouble();
                    final isOver = item['is_over_budget'] == true;
                    final pct = bAmt > 0 ? (aAmt / bAmt) : (aAmt > 0 ? 1.0 : 0.0);
                    final clampedProgress = pct.clamp(0.0, 1.0);

                    final Color progressColor = isOver
                        ? CupertinoColors.systemRed
                        : pct >= 0.8
                            ? CupertinoColors.systemOrange
                            : CupertinoColors.activeGreen;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: CupertinoGlassContainer(
                        padding: const EdgeInsets.all(16),
                        borderRadius: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${item['coa_code']} - ${item['coa_name']}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    if (item['cost_centre_code'] != null) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: CupertinoColors.activeBlue.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          item['cost_centre_code'],
                                          style: const TextStyle(fontSize: 11, color: CupertinoColors.activeBlue, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                if (isOver)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.systemRed,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'OVER BUDGET',
                                      style: TextStyle(color: CupertinoColors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Progress Bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: clampedProgress,
                                minHeight: 8,
                                backgroundColor: CupertinoColors.systemFill,
                                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                              ),
                            ),
                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Anggaran: ${currency.format(bAmt)}', style: const TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel)),
                                Text('Realisasi: ${currency.format(aAmt)}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: progressColor)),
                                Text('Sisa: ${currency.format(variance)}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: variance < 0 ? CupertinoColors.systemRed : CupertinoColors.activeGreen)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _summaryCard(String title, String value, Color color, {bool isBold = false}) {
    return CupertinoGlassContainer(
      padding: const EdgeInsets.all(12),
      borderRadius: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              fontSize: 14,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
