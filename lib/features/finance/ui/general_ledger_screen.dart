import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show DataTable, DataColumn, DataRow, DataCell, Tooltip, WidgetStateProperty;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/providers/company_provider.dart';
import '../../../core/widgets/adaptive_layout_builder.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_loading_indicator.dart';
import '../../../core/widgets/cupertino_mesh_background.dart';
import '../services/accounting_api_service.dart';

class GeneralLedgerScreen extends ConsumerStatefulWidget {
  const GeneralLedgerScreen({super.key});

  @override
  ConsumerState<GeneralLedgerScreen> createState() => _GeneralLedgerScreenState();
}

class _GeneralLedgerScreenState extends ConsumerState<GeneralLedgerScreen> {
  bool _isLoadingCoas = false;
  bool _isLoadingLedger = false;
  List<dynamic> _coas = [];
  String? _selectedCoaCode;
  String? _selectedCoaName;

  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

  Map<String, dynamic>? _ledgerData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCoasAndLedger();
  }

  Future<void> _fetchCoasAndLedger() async {
    final company = ref.read(currentCompanyProvider);
    if (company == null) return;

    setState(() {
      _isLoadingCoas = true;
      _errorMessage = null;
    });

    try {
      final api = ref.read(accountingApiServiceProvider);
      final coaList = await api.getCoas(company.id);

      setState(() {
        _coas = coaList;
        _isLoadingCoas = false;
        if (_coas.isNotEmpty && _selectedCoaCode == null) {
          final firstPostable = _coas.firstWhere(
            (c) => (c['is_postable'] == true || c['is_postable'] == 1),
            orElse: () => _coas.first,
          );
          _selectedCoaCode = firstPostable['coa_code'] as String?;
          _selectedCoaName = firstPostable['coa_name'] as String?;
        }
      });

      if (_selectedCoaCode != null) {
        await _fetchLedger();
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoadingCoas = false;
      });
    }
  }

  Future<void> _fetchLedger() async {
    final company = ref.read(currentCompanyProvider);
    if (company == null || _selectedCoaCode == null) return;

    setState(() {
      _isLoadingLedger = true;
      _errorMessage = null;
    });

    final startStr = DateFormat('yyyy-MM-dd').format(_startDate);
    final endStr = DateFormat('yyyy-MM-dd').format(_endDate);

    try {
      final api = ref.read(accountingApiServiceProvider);
      final data = await api.getGeneralLedger(company.id, _selectedCoaCode!, startStr, endStr);

      setState(() {
        _ledgerData = data;
        _isLoadingLedger = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoadingLedger = false;
      });
    }
  }

  void _showCoaPicker(BuildContext context) {
    if (_coas.isEmpty) return;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 320,
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
              child: ListView.builder(
                itemCount: _coas.length,
                itemBuilder: (context, index) {
                  final item = _coas[index];
                  final code = item['coa_code'] as String;
                  final name = item['coa_name'] as String;
                  final isSelected = code == _selectedCoaCode;

                  return CupertinoListTile(
                    title: Text('$code - $name', style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? CupertinoColors.activeBlue : CupertinoColors.label,
                    )),
                    onTap: () {
                      setState(() {
                        _selectedCoaCode = code;
                        _selectedCoaName = name;
                      });
                      Navigator.pop(context);
                      _fetchLedger();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPresetPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Pilih Periode Tanggal'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
                _endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
              });
              _fetchLedger();
            },
            child: const Text('Bulan Ini'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _endDate = DateTime.now();
                _startDate = DateTime.now().subtract(const Duration(days: 30));
              });
              _fetchLedger();
            },
            child: const Text('30 Hari Terakhir'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _endDate = DateTime.now();
                _startDate = DateTime.now().subtract(const Duration(days: 90));
              });
              _fetchLedger();
            },
            child: const Text('3 Bulan Terakhir'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _startDate = DateTime(2020, 1, 1);
                _endDate = DateTime.now();
              });
              _fetchLedger();
            },
            child: const Text('Semua Waktu'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
      ),
    );
  }

  Future<void> _triggerRecalculation(BuildContext context) async {
    final company = ref.read(currentCompanyProvider);
    if (company == null) return;

    final startStr = DateFormat('yyyy-MM-dd').format(_startDate);

    final confirm = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Hitung Ulang HPP & Ledger'),
        content: Text('Jalankan kalkulasi ulang transaksi HPP dan mutasi Buku Besar untuk ${company.companyName} mulai tanggal $startStr?'),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: false,
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Proses'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoadingLedger = true);

    try {
      final api = ref.read(accountingApiServiceProvider);
      final res = await api.recalculateCogsLedger(company.id, fromDate: startStr);
      final msg = res['message'] as String? ?? 'Hitung ulang HPP dan Buku Besar berhasil diproses.';

      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Kalkulasi Selesai'),
            content: Text(msg),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      await _fetchLedger();
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingLedger = false);
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Gagal'),
            content: Text(e.toString()),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _exportGlCsv() async {
    final company = ref.read(currentCompanyProvider);
    if (company == null || _selectedCoaCode == null) return;
    final startStr = DateFormat('yyyy-MM-dd').format(_startDate);
    final endStr = DateFormat('yyyy-MM-dd').format(_endDate);

    final url = Uri.parse('/api/v1/wh/accounting/reports/export-excel?company_id=${company.id}&report_type=general_ledger&coa_code=$_selectedCoaCode&start_date=$startStr&end_date=$endStr');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _exportGlPdf() async {
    final company = ref.read(currentCompanyProvider);
    if (company == null || _selectedCoaCode == null) return;
    final startStr = DateFormat('yyyy-MM-dd').format(_startDate);
    final endStr = DateFormat('yyyy-MM-dd').format(_endDate);

    final url = Uri.parse('/api/v1/wh/accounting/reports/export-pdf?company_id=${company.id}&report_type=general_ledger&coa_code=$_selectedCoaCode&start_date=$startStr&end_date=$endStr');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Buku Besar (General Ledger)'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Tooltip(
              message: 'Ekspor Excel (CSV)',
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _exportGlCsv,
                child: const Icon(CupertinoIcons.arrow_down_square, size: 22, color: CupertinoColors.activeGreen),
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: 'Ekspor PDF',
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _exportGlPdf,
                child: const Icon(CupertinoIcons.doc_text, size: 22, color: CupertinoColors.systemRed),
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: 'Hitung Ulang HPP & Ledger',
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => _triggerRecalculation(context),
                child: const Icon(CupertinoIcons.arrow_2_circlepath_circle, size: 22, color: CupertinoColors.activeOrange),
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: 'Refresh Data',
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _fetchCoasAndLedger,
                child: const Icon(CupertinoIcons.refresh, size: 22),
              ),
            ),
          ],
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
    final dateFmt = DateFormat('dd/MM/yyyy');
    final periodLabel = '${dateFmt.format(_startDate)} - ${dateFmt.format(_endDate)}';

    return Padding(
      padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Bar (Perusahaan, Periode & Pilih Akun COA)
          CupertinoGlassContainer(
            padding: const EdgeInsets.all(16),
            borderRadius: 16,
            child: Column(
              children: [
                Row(
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
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      color: CupertinoColors.activeBlue.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                      onPressed: () => _showPresetPicker(context),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.calendar, size: 14, color: CupertinoColors.activeBlue),
                          const SizedBox(width: 6),
                          Text(periodLabel, style: const TextStyle(color: CupertinoColors.activeBlue, fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(height: 1, color: CupertinoColors.separator),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Pilih Akun COA: ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        color: CupertinoColors.systemFill,
                        borderRadius: BorderRadius.circular(10),
                        onPressed: () => _showCoaPicker(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                _selectedCoaCode != null ? '$_selectedCoaCode - $_selectedCoaName' : 'Pilih Akun...',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: CupertinoColors.label),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(CupertinoIcons.chevron_down, size: 16, color: CupertinoColors.secondaryLabel),
                          ],
                        ),
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
            child: _isLoadingCoas || _isLoadingLedger
                ? const Center(child: CupertinoGlassLoadingIndicator())
                : _errorMessage != null
                    ? Center(child: Text(_errorMessage!, style: const TextStyle(color: CupertinoColors.systemRed)))
                    : _ledgerData == null
                        ? const Center(child: Text('Pilih akun COA untuk melihat buku besar.'))
                        : _buildLedgerView(currency),
          ),
        ],
      ),
    );
  }

  Widget _buildLedgerView(NumberFormat currency) {
    final openingBal = (_ledgerData!['opening_balance'] as num? ?? 0).toDouble();
    final totalDeb = (_ledgerData!['total_debit'] as num? ?? 0).toDouble();
    final totalCred = (_ledgerData!['total_credit'] as num? ?? 0).toDouble();
    final endingBal = (_ledgerData!['ending_balance'] as num? ?? 0).toDouble();
    final lines = _ledgerData!['lines'] as List<dynamic>? ?? [];

    return Column(
      children: [
        // 4 Box Cards (Saldo Awal, Mutasi Debet, Mutasi Kredit, Saldo Akhir)
        Row(
          children: [
            Expanded(child: _summaryCard('Saldo Awal', currency.format(openingBal), CupertinoColors.activeBlue)),
            const SizedBox(width: 10),
            Expanded(child: _summaryCard('Mutasi Debet', currency.format(totalDeb), CupertinoColors.systemIndigo)),
            const SizedBox(width: 10),
            Expanded(child: _summaryCard('Mutasi Kredit', currency.format(totalCred), CupertinoColors.systemOrange)),
            const SizedBox(width: 10),
            Expanded(child: _summaryCard('Saldo Akhir', currency.format(endingBal), CupertinoColors.activeGreen, isBold: true)),
          ],
        ),
        const SizedBox(height: 16),

        // Mutasi Table
        Expanded(
          child: CupertinoGlassContainer(
            padding: const EdgeInsets.all(16),
            borderRadius: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Mutasi Transaksi Buku Besar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 24,
                        headingRowColor: WidgetStateProperty.all(CupertinoColors.systemGroupedBackground),
                        columns: const [
                          DataColumn(label: Text('Tanggal', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('No. Jurnal', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Keterangan', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Debet (IDR)', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                          DataColumn(label: Text('Kredit (IDR)', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                          DataColumn(label: Text('Saldo Berjalan', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                        ],
                        rows: [
                          // Baris Saldo Awal
                          DataRow(
                            color: WidgetStateProperty.all(CupertinoColors.activeBlue.withOpacity(0.1)),
                            cells: [
                              const DataCell(Text('-')),
                              const DataCell(Text('-')),
                              const DataCell(Text('SALDO AWAL PERIODE', style: TextStyle(fontWeight: FontWeight.bold))),
                              const DataCell(Text('-')),
                              const DataCell(Text('-')),
                              DataCell(Text(currency.format(openingBal), style: const TextStyle(fontWeight: FontWeight.bold))),
                            ],
                          ),
                          // Detail Lines
                          ...lines.map((item) {
                            final deb = (item['debit'] as num? ?? 0).toDouble();
                            final cred = (item['credit'] as num? ?? 0).toDouble();
                            final run = (item['running_balance'] as num? ?? 0).toDouble();

                            return DataRow(
                              cells: [
                                DataCell(Text(item['date'] ?? '')),
                                DataCell(Text(item['journal_number'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600))),
                                DataCell(Text(item['description'] ?? '')),
                                DataCell(Text(deb > 0 ? currency.format(deb) : '-')),
                                DataCell(Text(cred > 0 ? currency.format(cred) : '-')),
                                DataCell(Text(currency.format(run), style: const TextStyle(fontWeight: FontWeight.w600))),
                              ],
                            );
                          }),
                          // Total Row
                          DataRow(
                            color: WidgetStateProperty.all(CupertinoColors.activeGreen.withOpacity(0.15)),
                            cells: [
                              const DataCell(Text('-')),
                              const DataCell(Text('-')),
                              const DataCell(Text('TOTAL MUTASI & SALDO AKHIR', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataCell(Text(currency.format(totalDeb), style: const TextStyle(fontWeight: FontWeight.bold))),
                              DataCell(Text(currency.format(totalCred), style: const TextStyle(fontWeight: FontWeight.bold))),
                              DataCell(Text(currency.format(endingBal), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
