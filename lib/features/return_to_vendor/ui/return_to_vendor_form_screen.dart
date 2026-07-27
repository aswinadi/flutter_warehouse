import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/company_provider.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../providers/return_to_vendor_provider.dart';

class ReturnToVendorFormScreen extends ConsumerStatefulWidget {
  const ReturnToVendorFormScreen({super.key});

  @override
  ConsumerState<ReturnToVendorFormScreen> createState() =>
      _ReturnToVendorFormScreenState();
}

class _ReturnToVendorFormScreenState
    extends ConsumerState<ReturnToVendorFormScreen> {
  final _reasonController = TextEditingController();
  final _notesController = TextEditingController();

  int? _selectedSupplierId;
  int? _selectedWarehouseId;
  final DateTime _returnDate = DateTime.now();

  // Dynamic Item List
  final List<Map<String, dynamic>> _items = [];

  bool _isSubmitting = false;

  void _addItem() {
    setState(() {
      _items.add({
        'item_id': 1,
        'quantity': 1.0,
        'unit_price': 10000.0,
        'condition': 'damaged',
        'reason': 'Barang cacat fisik',
      });
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (_selectedSupplierId == null || _selectedWarehouseId == null || _items.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Peringatan'),
          content: const Text('Harap isi Supplier, Gudang, dan minimal 1 item retur.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      );
      return;
    }

    final selectedCompany = ref.read(selectedCompanyProvider);
    if (selectedCompany == null) return;

    setState(() => _isSubmitting = true);

    try {
      final payload = {
        'company_id': selectedCompany.id,
        'supplier_id': _selectedSupplierId,
        'warehouse_id': _selectedWarehouseId,
        'return_date': '${_returnDate.year}-${_returnDate.month.toString().padLeft(2, '0')}-${_returnDate.day.toString().padLeft(2, '0')}',
        'reason': _reasonController.text.trim(),
        'notes': _notesController.text.trim(),
        'items': _items,
      };

      await ref.read(returnToVendorRepositoryProvider).createRtv(payload);
      ref.invalidate(returnToVendorListProvider);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
            title: const Text('Gagal Menyimpan'),
            content: Text('Error: $e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(ctx),
              ),
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Buat Retur Supplier (RTV)'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _isSubmitting ? null : _submit,
          child: const Text('Simpan'),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(CupertinoSpacing.m),
          children: [
            const Text('Supplier ID:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            CupertinoTextField(
              keyboardType: TextInputType.number,
              placeholder: 'ID Supplier (misal: 1, 2)',
              onChanged: (val) => _selectedSupplierId = int.tryParse(val),
            ),
            const SizedBox(height: 12),

            const Text('Gudang ID:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            CupertinoTextField(
              keyboardType: TextInputType.number,
              placeholder: 'ID Gudang (misal: 1, 2)',
              onChanged: (val) => _selectedWarehouseId = int.tryParse(val),
            ),
            const SizedBox(height: 12),

            const Text('Alasan Retur:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            CupertinoTextField(
              controller: _reasonController,
              placeholder: 'Alasan utama retur ke supplier',
            ),
            const SizedBox(height: 12),

            const Text('Catatan Tambahan:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            CupertinoTextField(
              controller: _notesController,
              placeholder: 'Catatan internal...',
              maxLines: 2,
            ),
            const SizedBox(height: CupertinoSpacing.l),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Daftar Barang Retur (${_items.length})', style: context.title2.copyWith(fontWeight: FontWeight.bold)),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _addItem,
                  child: const Row(
                    children: [
                      Icon(CupertinoIcons.add_circled),
                      SizedBox(width: 4),
                      Text('Tambah Item'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ..._items.asMap().entries.map((entry) {
              final idx = entry.key;
              final item = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Item #${idx + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: const Icon(CupertinoIcons.delete, color: CupertinoColors.destructiveRed, size: 20),
                          onPressed: () => _removeItem(idx),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CupertinoTextField(
                            keyboardType: TextInputType.number,
                            placeholder: 'ID Produk (1)',
                            onChanged: (v) => item['item_id'] = int.tryParse(v) ?? 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CupertinoTextField(
                            keyboardType: TextInputType.number,
                            placeholder: 'Qty (1.0)',
                            onChanged: (v) => item['quantity'] = double.tryParse(v) ?? 1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CupertinoTextField(
                      keyboardType: TextInputType.number,
                      placeholder: 'Harga Satuan (Rp)',
                      onChanged: (v) => item['unit_price'] = double.tryParse(v) ?? 0.0,
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
