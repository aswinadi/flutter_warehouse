import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Tooltip;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/company_provider.dart';
import '../../../core/widgets/adaptive_layout_builder.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_loading_indicator.dart';
import '../../../core/widgets/cupertino_mesh_background.dart';
import '../services/accounting_api_service.dart';

class FinancialReportsScreen extends ConsumerStatefulWidget {
  const FinancialReportsScreen({super.key});

  @override
  ConsumerState<FinancialReportsScreen> createState() => _FinancialReportsScreenState();
}

class _FinancialReportsScreenState extends ConsumerState<FinancialReportsScreen> {
  int _selectedSegment = 0; // 0 = Laba Rugi, 1 = Neraca, 2 = Trial Balance
  bool _isLoading = false;
  Map<String, dynamic>? _reportData;
  String? _errorMessage;

  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;

  static const List<String> _months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  Future<void> _fetchReport() async {
    final company = ref.read(currentCompanyProvider);
    if (company == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final api = ref.read(accountingApiServiceProvider);
      Map<String, dynamic> data;

      if (_selectedSegment == 0) {
        data = await api.getIncomeStatement(company.id, _selectedYear, _selectedMonth);
      } else if (_selectedSegment == 1) {
        data = await api.getBalanceSheet(company.id, _selectedYear, _selectedMonth);
      } else {
        data = await api.getTrialBalance(company.id, _selectedYear, _selectedMonth);
      }

      setState(() {
        _reportData = data;
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
                  _fetchReport();
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
                  _fetchReport();
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
        middle: const Text('Laporan Keuangan'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Tooltip(
              message: 'Ekspor Excel (CSV)',
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  // Export Excel / CSV
                },
                child: const Icon(CupertinoIcons.doc_text, size: 22),
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: 'Ekspor PDF',
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  // Export PDF
                },
                child: const Icon(CupertinoIcons.arrow_down_doc, size: 22),
              ),
            ),
          ],
        ),
      ),
      child: CupertinoMeshBackground(
        child: SafeArea(
          child: AdaptiveLayoutBuilder(
            mobileBuilder: (context, constraints) => _buildContent(currency, isDesktop: false),
            desktopBuilder: (context, constraints) => _buildContent(currency, isDesktop: true),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(NumberFormat currency, {required bool isDesktop}) {
    return Padding(
      padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
      child: Column(
        children: [
          // Segment Control
          SizedBox(
            width: double.infinity,
            child: CupertinoSegmentedControl<int>(
              groupValue: _selectedSegment,
              onValueChanged: (val) {
                setState(() => _selectedSegment = val);
                _fetchReport();
              },
              children: const {
                0: Padding(padding: EdgeInsets.all(8), child: Text('Laba Rugi')),
                1: Padding(padding: EdgeInsets.all(8), child: Text('Neraca')),
                2: Padding(padding: EdgeInsets.all(8), child: Text('Trial Balance')),
              },
            ),
          ),
          const SizedBox(height: 12),

          // Period Selector Bar
          CupertinoGlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            borderRadius: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(CupertinoIcons.calendar, size: 18, color: CupertinoColors.activeBlue),
                    SizedBox(width: 8),
                    Text('Periode:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                Row(
                  children: [
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      color: CupertinoColors.activeBlue.withOpacity(0.15),
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
                      color: CupertinoColors.activeBlue.withOpacity(0.15),
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

          Expanded(
            child: _isLoading
                ? const Center(child: CupertinoGlassLoadingIndicator())
                : _errorMessage != null
                    ? Center(child: Text(_errorMessage!, style: const TextStyle(color: CupertinoColors.systemRed)))
                    : _reportData == null
                        ? const Center(child: Text('Pilih periode laporan.'))
                        : SingleChildScrollView(
                            child: _selectedSegment == 0
                                ? _buildIncomeStatementView(currency)
                                : _selectedSegment == 1
                                    ? _buildBalanceSheetView(currency)
                                    : _buildTrialBalanceView(currency),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeStatementView(NumberFormat currency) {
    final totalRev = (_reportData!['total_revenue'] as num? ?? 0).toDouble();
    final totalCogs = (_reportData!['total_cogs'] as num? ?? 0).toDouble();
    final grossProfit = (_reportData!['gross_profit'] as num? ?? 0).toDouble();
    final totalExp = (_reportData!['total_expenses'] as num? ?? 0).toDouble();
    final netProfit = (_reportData!['net_profit'] as num? ?? 0).toDouble();

    return Column(
      children: [
        CupertinoGlassContainer(
          padding: const EdgeInsets.all(20),
          borderRadius: 20,
          child: Column(
            children: [
              _summaryRow('Total Pendapatan (Revenue)', currency.format(totalRev), CupertinoColors.activeGreen),
              const SizedBox(height: 8),
              _summaryRow('Beban Pokok (COGS)', currency.format(totalCogs), CupertinoColors.systemRed),
              const SizedBox(height: 12),
              Container(height: 1, color: CupertinoColors.separator),
              const SizedBox(height: 12),
              _summaryRow('Laba Kotor (Gross Profit)', currency.format(grossProfit), CupertinoColors.activeBlue, isBold: true),
              const SizedBox(height: 8),
              _summaryRow('Beban Operasional', currency.format(totalExp), CupertinoColors.systemOrange),
              const SizedBox(height: 12),
              Container(height: 1, color: CupertinoColors.separator),
              const SizedBox(height: 12),
              _summaryRow('Laba Bersih (Net Profit)', currency.format(netProfit),
                  netProfit >= 0 ? CupertinoColors.activeGreen : CupertinoColors.systemRed,
                  isBold: true, fontSize: 18),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceSheetView(NumberFormat currency) {
    final assets = (_reportData!['total_assets'] as num? ?? 0).toDouble();
    final liabilities = (_reportData!['total_liabilities'] as num? ?? 0).toDouble();
    final equity = (_reportData!['total_equity'] as num? ?? 0).toDouble();
    final totalPasiva = liabilities + equity;
    final isBalanced = _reportData!['is_balanced'] as bool? ?? true;

    final aktivaCard = CupertinoGlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: CupertinoColors.activeBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('AKTIVA (ASET)', style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.activeBlue)),
          ),
          const SizedBox(height: 16),
          _summaryRow('Total Aset (Assets)', currency.format(assets), CupertinoColors.activeBlue, isBold: true),
          const SizedBox(height: 20),
          Container(height: 1, color: CupertinoColors.separator),
          const SizedBox(height: 12),
          _summaryRow('TOTAL AKTIVA', currency.format(assets), CupertinoColors.activeBlue, isBold: true, fontSize: 16),
        ],
      ),
    );

    final pasivaCard = CupertinoGlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: CupertinoColors.systemIndigo.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('PASIVA (LIABILITAS & EKUITAS)', style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.systemIndigo)),
          ),
          const SizedBox(height: 16),
          _summaryRow('Total Liabilitas (Kewajiban)', currency.format(liabilities), CupertinoColors.systemRed),
          const SizedBox(height: 8),
          _summaryRow('Total Ekuitas (Modal)', currency.format(equity), CupertinoColors.activeGreen),
          const SizedBox(height: 12),
          Container(height: 1, color: CupertinoColors.separator),
          const SizedBox(height: 12),
          _summaryRow('TOTAL PASIVA', currency.format(totalPasiva), CupertinoColors.label, isBold: true, fontSize: 16),
        ],
      ),
    );

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              // Skontro 2-column layout (Tablet / Web / Desktop)
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: aktivaCard),
                  const SizedBox(width: 16),
                  Expanded(child: pasivaCard),
                ],
              );
            }
            // Stacked layout (Mobile)
            return Column(
              children: [
                aktivaCard,
                const SizedBox(height: 16),
                pasivaCard,
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isBalanced
                ? CupertinoColors.activeGreen.withOpacity(0.15)
                : CupertinoColors.systemRed.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            isBalanced ? '✓ Status Skontro: Balance (Seimbang)' : '⚠ Status Skontro: Tidak Seimbang',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isBalanced ? CupertinoColors.activeGreen : CupertinoColors.systemRed,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrialBalanceView(NumberFormat currency) {
    final items = _reportData!['items'] as List<dynamic>? ?? [];
    final grandDebit = (_reportData!['grand_debit'] as num? ?? 0).toDouble();
    final grandCredit = (_reportData!['grand_credit'] as num? ?? 0).toDouble();

    return Column(
      children: [
        CupertinoGlassContainer(
          padding: const EdgeInsets.all(16),
          borderRadius: 16,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Grand Total Debit', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(currency.format(grandDebit),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.activeGreen)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Grand Total Kredit', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(currency.format(grandCredit),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.systemRed)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) {
          final coaCode = item['coa_code'] as String;
          final coaName = item['coa_name'] as String;
          final balance = (item['ending_balance'] as num).toDouble();

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: CupertinoGlassContainer(
              padding: const EdgeInsets.all(12),
              borderRadius: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text('$coaCode - $coaName', style: const TextStyle(fontSize: 14))),
                  Text(currency.format(balance),
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _summaryRow(String label, String value, Color color, {bool isBold = false, double fontSize = 15}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: color)),
      ],
    );
  }
}
