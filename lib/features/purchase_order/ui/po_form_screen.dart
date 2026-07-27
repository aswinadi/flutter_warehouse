import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider, DropdownButton, DropdownMenuItem, DropdownButtonHideUnderline;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/purchase_order_provider.dart';
import '../../../core/providers/company_provider.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/api/dio_client.dart';

class POFormScreen extends ConsumerStatefulWidget {
  const POFormScreen({super.key});

  @override
  ConsumerState<POFormScreen> createState() => _POFormScreenState();
}

class _POFormScreenState extends ConsumerState<POFormScreen> {
  DateTime _transactionDate = DateTime.now();
  DateTime _expectedDate = DateTime.now().add(const Duration(days: 7));
  
  int? _selectedWarehouseId;
  int? _selectedSupplierId;
  
  bool _isAdvancePayment = false;
  final TextEditingController _dpPercentageController = TextEditingController(text: '30');
  final TextEditingController _notesController = TextEditingController();
  
  List<Map<String, dynamic>> _items = [];
  bool _isSubmitting = false;

  // Master data for dropdowns
  List<dynamic> _warehouses = [];
  List<dynamic> _suppliers = [];
  List<dynamic> _products = [];
  bool _isLoadingMaster = true;

  @override
  void initState() {
    super.initState();
    _loadMasterData();
  }

  @override
  void dispose() {
    _dpPercentageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadMasterData() async {
    final company = ref.read(selectedCompanyProvider);
    if (company == null) return;

    setState(() => _isLoadingMaster = true);
    try {
      final dio = ref.read(dioProvider);
      final futures = await Future.wait([
        dio.get('wh/warehouses', queryParameters: {'company_id': company.id, 'per_page': 100}),
        dio.get('wh/suppliers', queryParameters: {'company_id': company.id, 'per_page': 100}),
        dio.get('wh/products', queryParameters: {'company_id': company.id, 'per_page': 200}),
      ]);

      setState(() {
        _warehouses = futures[0].data['data'] ?? [];
        _suppliers = futures[1].data['data'] ?? [];
        _products = futures[2].data['data'] ?? [];
        
        if (_warehouses.isNotEmpty) {
          _selectedWarehouseId = _warehouses.first['id'] as int;
        }
        if (_suppliers.isNotEmpty) {
          _selectedSupplierId = _suppliers.first['id'] as int;
        }
        _isLoadingMaster = false;
      });
    } catch (e) {
      if (mounted) setState(() => _isLoadingMaster = false);
    }
  }

  double get _totalPOAmount {
    return _items.fold(0.0, (sum, item) {
      final qty = (item['ordered_qty'] as num?)?.toDouble() ?? 0.0;
      final price = (item['unit_price'] as num?)?.toDouble() ?? 0.0;
      return sum + (qty * price);
    });
  }

  double get _calculatedDpAmount {
    if (!_isAdvancePayment) return 0.0;
    final pct = double.tryParse(_dpPercentageController.text) ?? 0.0;
    return (_totalPOAmount * pct) / 100;
  }

  void _addItem() {
    if (_products.isEmpty) return;
    final firstProd = _products.first;
    setState(() {
      _items.add({
        'product_id': firstProd['id'],
        'sku': firstProd['sku'] ?? '',
        'product_name': firstProd['name'] ?? '',
        'ordered_qty': 1.0,
        'unit': firstProd['base_unit'] ?? 'PCS',
        'unit_price': 100000.0,
      });
    });
  }

  Future<void> _submit() async {
    final company = ref.read(selectedCompanyProvider);
    if (company == null || _selectedWarehouseId == null || _selectedSupplierId == null || _items.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Peringatan'),
          content: const Text('Harap lengkapi semua field gudang, supplier, dan minimal 1 item produk.'),
          actions: [
            CupertinoDialogAction(child: const Text('OK'), onPressed: () => Navigator.pop(context)),
          ],
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final repository = ref.read(purchaseOrderRepositoryProvider);
      final dpPct = double.tryParse(_dpPercentageController.text) ?? 0.0;

      await repository.createPurchaseOrder(
        companyId: company.id,
        warehouseId: _selectedWarehouseId!,
        supplierId: _selectedSupplierId!,
        transactionDate: DateFormat('yyyy-MM-dd').format(_transactionDate),
        expectedDate: DateFormat('yyyy-MM-dd').format(_expectedDate),
        items: _items,
        isAdvancePayment: _isAdvancePayment,
        dpPercentage: _isAdvancePayment ? dpPct : null,
        dpAmount: _isAdvancePayment ? _calculatedDpAmount : null,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      ref.invalidate(purchaseOrdersProvider);

      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Berhasil'),
            content: const Text('Purchase Order berhasil dibuat dengan skema DP.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  context.pop();
                },
              )
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Gagal'),
            content: Text('Gagal membuat Purchase Order: $e'),
            actions: [
              CupertinoDialogAction(child: const Text('OK'), onPressed: () => Navigator.pop(context)),
            ],
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final company = ref.watch(selectedCompanyProvider);

    if (_isLoadingMaster) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Buat Purchase Order (PO)'),
          backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        ),
        child: const Center(child: CupertinoActivityIndicator()),
      );
    }

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        middle: Text('Buat Purchase Order (PO)', style: TextStyle(color: labelColor)),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(CupertinoSpacing.l),
          children: [
            // Company Card
            CupertinoGlassContainer(
              padding: const EdgeInsets.all(CupertinoSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Perusahaan', style: context.caption1.copyWith(color: CupertinoColors.secondaryLabel)),
                  const SizedBox(height: 4),
                  Text(company?.companyName ?? '-', style: context.headline.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: CupertinoSpacing.m),

            // Warehouse & Supplier Selection
            CupertinoGlassContainer(
              padding: const EdgeInsets.all(CupertinoSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gudang Tujuan', style: context.footnote.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground.resolveFrom(context),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _selectedWarehouseId,
                        isExpanded: true,
                        items: _warehouses.map((wh) {
                          return DropdownMenuItem<int>(
                            value: wh['id'] as int,
                            child: Text(wh['name'] as String? ?? 'Gudang'),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedWarehouseId = val),
                      ),
                    ),
                  ),
                  const SizedBox(height: CupertinoSpacing.m),
                  Text('Supplier', style: context.footnote.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground.resolveFrom(context),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _selectedSupplierId,
                        isExpanded: true,
                        items: _suppliers.map((s) {
                          return DropdownMenuItem<int>(
                            value: s['id'] as int,
                            child: Text(s['name'] as String? ?? 'Supplier'),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedSupplierId = val;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: CupertinoSpacing.m),

            // Advance Payment (DP) Toggle & Percent
            CupertinoGlassContainer(
              padding: const EdgeInsets.all(CupertinoSpacing.m),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Skema Uang Muka (DP)', style: context.body.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text('Aktifkan jika PO memerlukan DP sebelum barang tiba', style: context.caption1.copyWith(color: CupertinoColors.secondaryLabel)),
                        ],
                      ),
                      CupertinoSwitch(
                        value: _isAdvancePayment,
                        onChanged: (val) => setState(() => _isAdvancePayment = val),
                      ),
                    ],
                  ),
                  if (_isAdvancePayment) ...[
                    const Divider(height: CupertinoSpacing.l, thickness: 0.5),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Persentase DP (%)', style: context.footnote.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              CupertinoTextField(
                                controller: _dpPercentageController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                suffix: const Padding(padding: EdgeInsets.only(right: 10), child: Text('%')),
                                padding: const EdgeInsets.all(10),
                                onChanged: (val) => setState(() {}),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: CupertinoSpacing.m),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Estimasi DP (IDR)', style: context.footnote.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemFill.resolveFrom(context),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  formatWithCurrency(_calculatedDpAmount, 'IDR'),
                                  style: context.body.copyWith(fontWeight: FontWeight.bold, color: CupertinoColors.activeBlue),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: CupertinoSpacing.m),

            // Item Details
            CupertinoGlassContainer(
              padding: const EdgeInsets.all(CupertinoSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Item Produk (${_items.length})', style: context.headline.copyWith(fontWeight: FontWeight.bold)),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: _addItem,
                        child: const Row(
                          children: [
                            Icon(CupertinoIcons.add_circled, size: 18),
                            SizedBox(width: 4),
                            Text('Tambah Item'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_items.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text('Belum ada item ditambahkan. Tap Tambah Item di atas.', style: context.footnote.copyWith(color: CupertinoColors.secondaryLabel)),
                      ),
                    ),
                  ..._items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final subtotal = ((item['ordered_qty'] as num?)?.toDouble() ?? 0) * ((item['unit_price'] as num?)?.toDouble() ?? 0);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemBackground.resolveFrom(context),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<int>(
                                      value: item['product_id'] as int?,
                                      isExpanded: true,
                                      items: _products.map((p) {
                                        return DropdownMenuItem<int>(
                                          value: p['id'] as int,
                                          child: Text(p['name'] as String? ?? 'Produk', overflow: TextOverflow.ellipsis),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          final p = _products.firstWhere((element) => element['id'] == val, orElse: () => null);
                                          setState(() {
                                            item['product_id'] = val;
                                            item['sku'] = p?['sku'] ?? '';
                                            item['product_name'] = p?['name'] ?? '';
                                            item['unit'] = p?['base_unit'] ?? 'PCS';
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: const Icon(CupertinoIcons.trash, color: CupertinoColors.destructiveRed, size: 20),
                                onPressed: () => setState(() => _items.removeAt(index)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: CupertinoTextField(
                                  placeholder: 'Qty',
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  controller: TextEditingController(text: item['ordered_qty'].toString()),
                                  padding: const EdgeInsets.all(8),
                                  onChanged: (val) {
                                    item['ordered_qty'] = double.tryParse(val) ?? 1.0;
                                    setState(() {});
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: CupertinoTextField(
                                  placeholder: 'Harga Satuan',
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  controller: TextEditingController(text: item['unit_price'].toString()),
                                  padding: const EdgeInsets.all(8),
                                  onChanged: (val) {
                                    item['unit_price'] = double.tryParse(val) ?? 0.0;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text('Subtotal: ${formatWithCurrency(subtotal, 'IDR')}', style: context.footnote.copyWith(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: CupertinoSpacing.m),

            // Notes & Total Summary
            CupertinoGlassContainer(
              padding: const EdgeInsets.all(CupertinoSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Catatan PO', style: context.footnote.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  CupertinoTextField(
                    controller: _notesController,
                    placeholder: 'Masukkan catatan tambahan...',
                    maxLines: 2,
                    padding: const EdgeInsets.all(10),
                  ),
                  const Divider(height: CupertinoSpacing.l, thickness: 0.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total PO:', style: context.headline.copyWith(fontWeight: FontWeight.bold)),
                      Text(formatWithCurrency(_totalPOAmount, 'IDR'), style: context.title3.copyWith(fontWeight: FontWeight.bold, color: CupertinoColors.activeBlue)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: CupertinoSpacing.l),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: CupertinoSpacing.primaryButtonHeight,
              child: CupertinoButton(
                color: CupertinoColors.activeBlue,
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                    : const Text('Buat Purchase Order', style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.white)),
              ),
            ),
            const SizedBox(height: CupertinoSpacing.xl),
          ],
        ),
      ),
    );
  }
}
