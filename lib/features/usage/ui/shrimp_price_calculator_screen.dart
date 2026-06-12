import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import '../providers/aquaculture_crud_provider.dart';

class ShrimpPriceCalculatorScreen extends ConsumerStatefulWidget {
  const ShrimpPriceCalculatorScreen({super.key});

  @override
  ConsumerState<ShrimpPriceCalculatorScreen> createState() => _ShrimpPriceCalculatorScreenState();
}

class _ShrimpPriceCalculatorScreenState extends ConsumerState<ShrimpPriceCalculatorScreen> {
  int? _selectedCompanyId;
  final _sizeController = TextEditingController();
  List<dynamic> _companies = [];
  List<dynamic> _contracts = [];

  bool _isLoading = false;
  String? _activeContractName;
  double? _calculatedPrice;
  String _calculationBreakdown = '';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _sizeController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    final repo = ref.read(aquacultureCrudRepositoryProvider);

    try {
      final futures = await Future.wait([
        repo.dio.get('wh/companies'),
        repo.listAll('contracts'),
      ]);

      setState(() {
        final Response companiesResponse = futures[0] as Response;
        _companies = companiesResponse.data['data'] as List;
        _companies.sort((a, b) => (a['company_name'] as String).compareTo(b['company_name'] as String));

        _contracts = futures[1] as List;
      });
    } catch (err) {
      debugPrint('Error loading calculator data: $err');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _calculatePrice() {
    setState(() {
      _calculatedPrice = null;
      _activeContractName = null;
      _calculationBreakdown = '';
    });

    if (_selectedCompanyId == null) return;
    final sizeText = _sizeController.text.trim();
    if (sizeText.isEmpty) return;

    final currentSize = double.tryParse(sizeText);
    if (currentSize == null || currentSize <= 0) return;

    final activeContracts = _contracts.where((c) =>
        c['company_id'] == _selectedCompanyId &&
        c['is_active'] == true).toList();

    if (activeContracts.isEmpty) {
      setState(() {
        _calculationBreakdown = 'Tidak ada kontrak aktif yang ditemukan untuk perusahaan ini.';
      });
      return;
    }

    activeContracts.sort((a, b) => (b['id'] as int).compareTo(a['id'] as int));
    final contract = activeContracts.first;
    _activeContractName = contract['name'];

    final brackets = contract['brackets'] as List? ?? [];
    Map<String, dynamic>? matched;

    for (var b in brackets) {
      final minSize = double.tryParse(b['min_size']?.toString() ?? '0') ?? 0;
      final maxSize = double.tryParse(b['max_size']?.toString() ?? '0') ?? 0;

      if (currentSize >= minSize && currentSize <= maxSize) {
        matched = b as Map<String, dynamic>;
        break;
      }
    }

    if (matched == null) {
      setState(() {
        _calculationBreakdown = 'Ukuran size ($currentSize) tidak masuk dalam range bracket kontrak.';
      });
      return;
    }

    final baseSize = double.tryParse(matched['base_size']?.toString() ?? '') ??
                     double.tryParse(matched['min_size']?.toString() ?? '') ?? 0.0;

    final basePrice = double.tryParse(matched['base_price']?.toString() ?? '') ?? 0.0;
    final increment = double.tryParse(matched['price_increment']?.toString() ?? '') ?? 0.0;
    final decrement = double.tryParse(matched['price_decrement']?.toString() ?? '') ?? 0.0;

    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    if (currentSize > baseSize) {
      final diff = currentSize - baseSize;
      final priceReduction = diff * decrement;
      _calculatedPrice = basePrice - priceReduction;

      _calculationBreakdown = '• Size udang ($currentSize) lebih besar dari ukuran dasar ($baseSize).\n'
          '• Berdasarkan ketentuan kontrak, harga berkurang ${currencyFormat.format(decrement)} per unit size.\n'
          '• Pengurangan harga: ${diff.toStringAsFixed(2)} x ${currencyFormat.format(decrement)} = ${currencyFormat.format(priceReduction)}\n'
          '• Perhitungan Akhir:\n  ${currencyFormat.format(basePrice)} - ${currencyFormat.format(priceReduction)} = ${currencyFormat.format(_calculatedPrice!)} / kg';
    } else if (currentSize < baseSize) {
      final diff = baseSize - currentSize;
      final priceBonus = diff * increment;
      _calculatedPrice = basePrice + priceBonus;

      _calculationBreakdown = '• Size udang ($currentSize) lebih kecil dari ukuran dasar ($baseSize), menandakan udang lebih besar.\n'
          '• Berdasarkan ketentuan kontrak, harga bertambah ${currencyFormat.format(increment)} per unit size.\n'
          '• Bonus kenaikan harga: ${diff.toStringAsFixed(2)} x ${currencyFormat.format(increment)} = ${currencyFormat.format(priceBonus)}\n'
          '• Perhitungan Akhir:\n  ${currencyFormat.format(basePrice)} + ${currencyFormat.format(priceBonus)} = ${currencyFormat.format(_calculatedPrice!)} / kg';
    } else {
      _calculatedPrice = basePrice;
      _calculationBreakdown = '• Size udang ($currentSize) pas dengan ukuran dasar ($baseSize).\n'
          '• Perhitungan Akhir: ${currencyFormat.format(basePrice)} / kg';
    }

    setState(() {});
  }

  void _showCompanyPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Pilih Perusahaan'),
        actions: _companies.map((c) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _selectedCompanyId = c['id'] as int;
              });
              _calculatePrice();
              Navigator.pop(context);
            },
            child: Text(c['company_name'] ?? ''),
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

  Widget _buildSelectField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: labelColor,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                    value,
                    style: TextStyle(fontSize: 15, color: labelColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(CupertinoIcons.chevron_down, size: 14, color: secondaryLabel),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final borderCol = CupertinoColors.separator.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);

    final selectedCompany = _companies.firstWhere((c) => c['id'] == _selectedCompanyId, orElse: () => null);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Kalkulator Harga Udang'),
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderCol, width: 0.5),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Informasi Ukuran & Perusahaan',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: labelColor),
                          ),
                          const SizedBox(height: 16),
                          _buildSelectField(
                            label: 'Perusahaan',
                            value: selectedCompany != null ? (selectedCompany['company_name'] ?? '') : 'Pilih Perusahaan',
                            onTap: _showCompanyPicker,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Size Udang Saat Ini (ekor/kg)',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: labelColor),
                          ),
                          const SizedBox(height: 6),
                          CupertinoTextField(
                            controller: _sizeController,
                            placeholder: 'Misal: 21.5',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            suffix: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Text('ekor/kg', style: TextStyle(color: secondaryLabel)),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemBackground.resolveFrom(context),
                              border: Border.all(color: borderCol, width: 0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onChanged: (val) => _calculatePrice(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_activeContractName != null) ...[
                      Container(
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderCol, width: 0.5),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hasil Perhitungan Harga',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: labelColor),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Kontrak Aktif: $_activeContractName',
                              style: TextStyle(fontSize: 14, color: secondaryLabel),
                            ),
                            if (_calculatedPrice != null) ...[
                              const SizedBox(height: 16),
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      currencyFormat.format(_calculatedPrice),
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                        color: CupertinoColors.activeGreen,
                                      ),
                                    ),
                                    Text(
                                      'per kilogram (kg)',
                                      style: TextStyle(fontSize: 12, color: secondaryLabel),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(height: 0.5, color: borderCol),
                              const SizedBox(height: 12),
                              Text(
                                'Rincian Perhitungan:',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: labelColor),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _calculationBreakdown,
                                style: TextStyle(fontSize: 13, height: 1.5, color: labelColor),
                              ),
                            ] else ...[
                              const SizedBox(height: 12),
                              Text(
                                _calculationBreakdown,
                                style: const TextStyle(fontSize: 14, color: CupertinoColors.destructiveRed),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}
