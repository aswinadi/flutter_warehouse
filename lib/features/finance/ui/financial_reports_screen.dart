import 'package:flutter/cupertino.dart';
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

  final int _year = DateTime.now().year;
  final int _month = DateTime.now().month;

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
        data = await api.getIncomeStatement(company.id, _year, _month);
      } else if (_selectedSegment == 1) {
        data = await api.getBalanceSheet(company.id, _year, _month);
      } else {
        data = await api.getTrialBalance(company.id, _year, _month);
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

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Laporan Keuangan'),
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
              const Divider(height: 24),
              _summaryRow('Laba Kotor (Gross Profit)', currency.format(grossProfit), CupertinoColors.activeBlue, isBold: true),
              const SizedBox(height: 8),
              _summaryRow('Beban Operasional', currency.format(totalExp), CupertinoColors.systemOrange),
              const Divider(height: 24),
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
    final isBalanced = _reportData!['is_balanced'] as bool? ?? true;

    return Column(
      children: [
        CupertinoGlassContainer(
          padding: const EdgeInsets.all(20),
          borderRadius: 20,
          child: Column(
            children: [
              _summaryRow('Total Aset (Assets)', currency.format(assets), CupertinoColors.activeBlue, isBold: true),
              const Divider(height: 24),
              _summaryRow('Total Liabilitas (Kewajiban)', currency.format(liabilities), CupertinoColors.systemRed),
              const SizedBox(height: 8),
              _summaryRow('Total Ekuitas (Modal)', currency.format(equity), CupertinoColors.activeGreen),
              const Divider(height: 24),
              _summaryRow('Liabilitas + Ekuitas', currency.format(liabilities + equity), CupertinoColors.label, isBold: true),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isBalanced
                      ? CupertinoColors.activeGreen.withOpacity(0.15)
                      : CupertinoColors.systemRed.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isBalanced ? '✓ Neraca Seimbang' : '⚠ Neraca Tidak Seimbang',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isBalanced ? CupertinoColors.activeGreen : CupertinoColors.systemRed,
                  ),
                ),
              ),
            ],
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
                mainAxisAlignment: MainAxisAlignment.between,
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
                mainAxisAlignment: MainAxisAlignment.between,
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
      mainAxisAlignment: MainAxisAlignment.between,
      children: [
        Text(label, style: TextStyle(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: color)),
      ],
    );
  }
}
