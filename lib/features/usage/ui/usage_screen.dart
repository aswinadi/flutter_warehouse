import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/usage.dart';
import '../providers/usage_repository.dart';
import '../../inventory/models/inventory.dart';

class UsageScreen extends ConsumerStatefulWidget {
  const UsageScreen({super.key});

  @override
  ConsumerState<UsageScreen> createState() => _UsageScreenState();
}

class _UsageScreenState extends ConsumerState<UsageScreen> {
  Pond? _selectedPond;
  Inventory? _scannedItem;
  final _qtyController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  void _showPondPicker(List<Pond> ponds) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Pilih Kolam / Tambak'),
        actions: ponds.map((p) {
          return CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _selectedPond = p;
              });
              Navigator.pop(context);
            },
            child: Text(p.name + (p.code != null ? ' (${p.code})' : '')),
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
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground.resolveFrom(context),
              border: Border.all(color: separatorColor, width: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(fontSize: 15, color: labelColor),
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
    final pondsAsync = ref.watch(pondsProvider);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final borderCol = CupertinoColors.separator.resolveFrom(context);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Pemakaian Tambak'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              pondsAsync.when(
                data: (ponds) {
                  // If list is empty, use mock ponds to allow testing
                  final activePonds = ponds.isNotEmpty
                      ? ponds
                      : const [
                          Pond(id: 1, name: 'Kolam A1'),
                          Pond(id: 2, name: 'Kolam A2'),
                        ];
                  return _buildSelectField(
                    label: 'Pilih Kolam / Tambak',
                    value: _selectedPond != null ? _selectedPond!.name : 'Pilih Kolam',
                    onTap: () => _showPondPicker(activePonds),
                  );
                },
                loading: () => const Center(child: CupertinoActivityIndicator()),
                error: (err, _) => _buildSelectField(
                  label: 'Pilih Kolam / Tambak (Offline Mode)',
                  value: _selectedPond != null ? _selectedPond!.name : 'Pilih Kolam',
                  onTap: () => _showPondPicker(const [
                    Pond(id: 1, name: 'Kolam A1 (Offline)'),
                    Pond(id: 2, name: 'Kolam A2 (Offline)'),
                  ]),
                ),
              ),
              const SizedBox(height: 24),
              if (_scannedItem == null)
                _buildScanButton()
              else
                _buildScannedItemCard(cardBg, borderCol, labelColor, secondaryLabel),
              const Spacer(),
              CupertinoButton.filled(
                onPressed: (_selectedPond != null && _scannedItem != null && !_isLoading)
                    ? _submit
                    : null,
                borderRadius: BorderRadius.circular(10),
                child: _isLoading
                    ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                    : const Text(
                        'KIRIM PEMAKAIAN',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScanButton() {
    final themePrimary = CupertinoColors.activeBlue.resolveFrom(context);
    final borderCol = CupertinoColors.separator.resolveFrom(context);

    return GestureDetector(
      onTap: _scanBarcode,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderCol, width: 0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.qrcode_viewfinder,
              size: 48,
              color: themePrimary,
            ),
            const SizedBox(height: 12),
            Text(
              'PINDAI BARCODE BARANG',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: themePrimary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannedItemCard(
    Color bg,
    Color borderCol,
    Color labelColor,
    Color secondaryLabel,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderCol, width: 0.5),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _scannedItem!.productName ?? 'Item',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: labelColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Stok: ${_scannedItem!.quantity} ${_scannedItem!.unit ?? ""}',
                      style: TextStyle(
                        fontSize: 14,
                        color: secondaryLabel,
                      ),
                    ),
                  ],
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => setState(() => _scannedItem = null),
                child: Icon(
                  CupertinoIcons.clear_circled_solid,
                  color: CupertinoColors.inactiveGray.resolveFrom(context),
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Jumlah yang Digunakan',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          CupertinoTextField(
            controller: _qtyController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            placeholder: 'Masukkan jumlah',
            suffix: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                _scannedItem!.unit ?? 'kg',
                style: TextStyle(color: secondaryLabel),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground.resolveFrom(context),
              border: Border.all(color: borderCol, width: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _scanBarcode() async {
    setState(() {
      _scannedItem = const Inventory(
        id: 1,
        sku: 'FEED-001',
        productName: 'Shrimp Feed Gold',
        quantity: 100,
        status: 'available',
        unit: 'kg',
      );
    });
  }

  Future<void> _submit() async {
    if (_selectedPond == null || _scannedItem == null) return;
    final qty = double.tryParse(_qtyController.text);
    if (qty == null || qty <= 0) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Input Tidak Valid'),
          content: const Text('Harap masukkan jumlah pemakaian yang valid.'),
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

    setState(() {
      _isLoading = true;
    });

    try {
      final req = UsageRequest(
        pondId: _selectedPond!.id,
        inventoryId: _scannedItem!.id,
        quantity: qty,
      );
      await ref.read(usageRepositoryProvider).submitUsage(req);

      if (!mounted) return;
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Berhasil'),
          content: const Text('Pemakaian tambak berhasil dikirim.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  _scannedItem = null;
                  _qtyController.clear();
                });
              },
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Gagal'),
          content: Text('Gagal mengirim pemakaian: $e'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
