import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.subhead.copyWith(
            fontWeight: FontWeight.w600,
            color: labelColor,
          ),
        ),
        const SizedBox(height: CupertinoSpacing.s),
        GestureDetector(
          onTap: onTap,
          child: CupertinoGlassContainer(
            padding: const EdgeInsets.symmetric(
              horizontal: CupertinoSpacing.m,
              vertical: CupertinoSpacing.m,
            ),
            borderRadius: CupertinoSpacing.cardRadius,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: context.subhead.copyWith(color: labelColor),
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
          padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
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
              const SizedBox(height: CupertinoSpacing.xxl),
              if (_scannedItem == null)
                _buildScanButton()
              else
                _buildScannedItemCard(cardBg, borderCol, labelColor, secondaryLabel),
              const Spacer(),
              CupertinoButton.filled(
                onPressed: (_selectedPond != null && _scannedItem != null && !_isLoading)
                    ? _submit
                    : null,
                borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
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

    return GestureDetector(
      onTap: _scanBarcode,
      child: CupertinoGlassContainer(
        padding: const EdgeInsets.symmetric(vertical: 40),
        borderRadius: CupertinoSpacing.cardRadius,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.qrcode_viewfinder,
              size: 48,
              color: themePrimary,
            ),
            const SizedBox(height: CupertinoSpacing.m),
            Text(
              'PINDAI BARCODE BARANG',
              style: context.subhead.copyWith(
                fontWeight: FontWeight.w600,
                color: themePrimary,
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
    return CupertinoGlassContainer(
      borderRadius: CupertinoSpacing.cardRadius,
      padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
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
                      style: context.callout.copyWith(
                        fontWeight: FontWeight.bold,
                        color: labelColor,
                      ),
                    ),
                    const SizedBox(height: CupertinoSpacing.xs),
                    Text(
                      'Stok: ${_scannedItem!.quantity} ${_scannedItem!.unit ?? ""}',
                      style: context.subhead.copyWith(
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
          const SizedBox(height: CupertinoSpacing.l),
          Text(
            'Jumlah yang Digunakan',
            style: context.subhead.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: CupertinoSpacing.s),
          CupertinoTextField(
            controller: _qtyController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            placeholder: 'Masukkan jumlah',
            suffix: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                _scannedItem!.unit ?? 'kg',
                style: context.subhead.copyWith(color: secondaryLabel),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.m, vertical: CupertinoSpacing.m),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground.resolveFrom(context),
              border: Border.all(color: borderCol, width: 0.5),
              borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
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
      CupertinoGlassToast.showError(context, 'Harap masukkan jumlah pemakaian yang valid.');
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
      CupertinoGlassToast.showSuccess(context, 'Pemakaian tambak berhasil dikirim.');
      setState(() {
        _scannedItem = null;
        _qtyController.clear();
      });
    } catch (e) {
      if (!mounted) return;
      CupertinoGlassToast.showError(context, 'Gagal mengirim pemakaian: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
