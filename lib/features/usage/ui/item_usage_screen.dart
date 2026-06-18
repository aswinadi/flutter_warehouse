import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../models/item_usage.dart';
import '../providers/item_usage_repository.dart';
import '../../inventory/models/inventory.dart';
import '../../inventory/providers/inventory_provider.dart';
import '../../../core/providers/company_provider.dart';
import '../../../core/models/company.dart';
import '../../../core/widgets/company_switcher.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';

const _primaryAccent = Color(0xFF6E56CF);
const _dangerColor = CupertinoColors.destructiveRed;

// ─────────────────────────────────────────────────────────────────────────────
// Main Screen
// ─────────────────────────────────────────────────────────────────────────────
class ItemUsageScreen extends ConsumerStatefulWidget {
  final Inventory? prefilledItem;

  const ItemUsageScreen({super.key, this.prefilledItem});

  @override
  ConsumerState<ItemUsageScreen> createState() => _ItemUsageScreenState();
}

class _ItemUsageScreenState extends ConsumerState<ItemUsageScreen> {
  // ── Header ──────────────────────────────────────────────────────────────────
  WarehouseOption? _selectedWarehouse;
  DateTime _usageDate = DateTime.now();

  // ── Usage lines ─────────────────────────────────────────────────────────────
  // One line = one item + one pond allocation.
  // The same inventory_id CAN appear multiple times (different ponds).
  final List<UsageLine> _lines = [];
  final List<TextEditingController> _qtyControllers = [];
  final List<String?> _lineErrors = [];

  // ── Search ───────────────────────────────────────────────────────────────────
  final _searchController = TextEditingController();
  bool _isLoadingItem = false;
  String? _itemError;

  // ── Notes & photo ────────────────────────────────────────────────────────────
  final _notesController = TextEditingController();
  XFile? _photoFile;

  // ── Submit ───────────────────────────────────────────────────────────────────
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.prefilledItem != null) _addItemLine(widget.prefilledItem!);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _notesController.dispose();
    for (final c in _qtyControllers) {
      c.dispose();
    }
    super.dispose();
  }

  // ─── Line Management ─────────────────────────────────────────────────────────

  /// Adds a new usage line for [item]. Duplicates are allowed.
  void _addItemLine(Inventory item) {
    setState(() {
      _lines.add(UsageLine(
        inventoryId: item.id,
        productName: item.productName ?? 'Unknown',
        sku: item.sku,
        unit: item.unit,
        availableQty: item.quantity,
        usageQty: 0,
      ));
      _qtyControllers.add(TextEditingController());
      _lineErrors.add(null);
      _itemError = null;
    });
  }

  void _removeLine(int index) {
    _qtyControllers[index].dispose();
    setState(() {
      _lines.removeAt(index);
      _qtyControllers.removeAt(index);
      _lineErrors.removeAt(index);
    });
  }

  void _onQtyChanged(int index, String value) {
    final parsed = double.tryParse(value);
    setState(() {
      _lineErrors[index] = null;
      if (parsed != null && parsed > 0) {
        _lines[index] = _lines[index].copyWith(usageQty: parsed);
      }
    });
  }

  void _onPondSelected(int index, ActivePond pond) {
    setState(() {
      _lines[index] = _lines[index].copyWith(pond: pond);
      _lineErrors[index] = null;
    });
  }

  // ─── Total qty per inventory_id (for stock validation) ──────────────────────
  double _totalQtyForInventory(int inventoryId) {
    return _lines
        .where((l) => l.inventoryId == inventoryId)
        .fold(0.0, (sum, l) => sum + l.usageQty);
  }

  // ─── Search & Scan ───────────────────────────────────────────────────────────

  Future<void> _scanBarcode() async {
    final barcode = await showCupertinoModalPopup<String>(
      context: context,
      builder: (ctx) => const _BarcodeScannerSheet(),
    );
    if (barcode != null && barcode.isNotEmpty) {
      _lookupItem(_extractCode(barcode));
    }
  }

  String _extractCode(String raw) {
    final t = raw.trim();
    if (t.startsWith('http')) {
      try {
        final uri = Uri.parse(t);
        if (uri.pathSegments.isNotEmpty) {
          return uri.pathSegments.lastWhere((s) => s.isNotEmpty, orElse: () => t);
        }
      } catch (_) {}
    }
    return t;
  }

  Future<void> _lookupItem(String query) async {
    if (query.trim().isEmpty) return;
    setState(() {
      _isLoadingItem = true;
      _itemError = null;
    });
    try {
      final company = ref.read(selectedCompanyProvider);
      if (company == null) {
        setState(() => _itemError = 'Silakan pilih perusahaan terlebih dahulu.');
        return;
      }
      final repo = ref.read(inventoryRepositoryProvider);
      final paged = await repo.getInventory(
        search: query.trim(),
        companyId: company.id,
      );
      if (paged.data.length == 1) {
        _addItemLine(paged.data.first);
        _searchController.clear();
      } else if (paged.data.length > 1) {
        _showItemSheet(paged.data);
      } else {
        try {
          final item = await repo.getInventoryByBarcode(query.trim());
          _addItemLine(item);
          _searchController.clear();
        } catch (_) {
          setState(() => _itemError = 'Barang tidak ditemukan: "$query"');
        }
      }
    } catch (e) {
      String msg = e.toString();
      if (e is DioException) {
        final d = e.response?.data;
        if (d is Map && d['error']?['message'] != null) {
          msg = d['error']['message'].toString();
        }
      }
      setState(() => _itemError = msg);
    } finally {
      setState(() => _isLoadingItem = false);
    }
  }

  void _showItemSheet(List<Inventory> items) {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Pilih Barang'),
        message: Text('${items.length} barang ditemukan'),
        actions: items.map((item) {
          return CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(ctx);
              _addItemLine(item);
              _searchController.clear();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.productName ?? '-',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(
                  'SKU: ${item.sku}  •  Stok: ${item.quantity.toStringAsFixed(2)} ${item.unit ?? ""}',
                  style: const TextStyle(
                      fontSize: 12, color: CupertinoColors.secondaryLabel),
                ),
              ],
            ),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Batal'),
        ),
      ),
    );
  }

  // ─── Pond Picker ─────────────────────────────────────────────────────────────

  void _showPondPicker(int lineIndex) {
    final selectedCompany = ref.read(selectedCompanyProvider);
    if (selectedCompany == null) {
      CupertinoGlassToast.showError(
          context, 'Silakan pilih perusahaan terlebih dahulu.');
      return;
    }
    final pondsAsync = ref.read(activePondsProvider);

    // Still fetching — show inline loading instead of error
    if (pondsAsync is AsyncLoading) {
      CupertinoGlassToast.showInfo(context, 'Sedang memuat data petak…');
      return;
    }

    // Network / server error
    if (pondsAsync is AsyncError) {
      CupertinoGlassToast.showError(
          context, 'Gagal memuat petak: ${pondsAsync.error}');
      return;
    }

    final allPonds = pondsAsync.value ?? [];

    if (allPonds.isEmpty) {
      CupertinoGlassToast.showError(
          context,
          'Tidak ada petak aktif untuk perusahaan ini. '
          'Pastikan siklus aktif sudah dibuat.');
      return;
    }

    showCupertinoModalPopup(
      context: context,
      builder: (ctx) {
        String search = '';
        return StatefulBuilder(builder: (ctx2, setS) {
          final filtered = allPonds.where((p) {
            final q = search.toLowerCase();
            return p.shortLabel.toLowerCase().contains(q) ||
                (p.costCentreCode?.toLowerCase().contains(q) ?? false) ||
                p.cycleName.toLowerCase().contains(q) ||
                p.tambakName.toLowerCase().contains(q);
          }).toList();

          // Group by tambak+blok for nicer navigation
          final grouped = <String, List<ActivePond>>{};
          for (final p in filtered) {
            final groupKey = p.tambakName.isNotEmpty ? p.tambakName : 'Lainnya';
            grouped.putIfAbsent(groupKey, () => []).add(p);
          }

          final selectedPond = _lines[lineIndex].pond;

          return SizedBox(
            height: MediaQuery.of(ctx2).size.height * 0.80,
            child: CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: const Text('Pilih Petak'),
                leading: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.pop(ctx2),
                  child: const Text('Batal'),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                    child: CupertinoSearchTextField(
                      placeholder: 'Cari petak, kode CC, atau lokasi…',
                      onChanged: (v) => setS(() => search = v),
                    ),
                  ),
                  Expanded(
                    child: grouped.isEmpty
                        ? Center(
                            child: Text('Tidak ada petak ditemukan.',
                                style: TextStyle(
                                    color: CupertinoColors.secondaryLabel
                                        .resolveFrom(ctx2))))
                        : ListView(
                            children: grouped.entries.map((entry) {
                              return CupertinoListSection.insetGrouped(
                                header: Text(entry.key,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),
                                children: entry.value.map((pond) {
                                  final isSelected =
                                      selectedPond?.pondId == pond.pondId &&
                                          selectedPond?.cycleId == pond.cycleId;
                                  final hasCC = pond.costCentreCode != null;

                                  return CupertinoListTile(
                                    title: Text(
                                      pond.shortLabel, // e.g. "A1"
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: isSelected
                                            ? _primaryAccent
                                            : CupertinoColors.label
                                                .resolveFrom(ctx2),
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (hasCC)
                                          Text(pond.costCentreCode!,
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: CupertinoColors
                                                      .secondaryLabel
                                                      .resolveFrom(ctx2)))
                                        else
                                          Text('Cost centre belum tersedia',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: CupertinoColors
                                                      .systemOrange
                                                      .resolveFrom(ctx2))),
                                        Text('Siklus ${pond.cycleName}',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: CupertinoColors
                                                    .secondaryLabel
                                                    .resolveFrom(ctx2))),
                                      ],
                                    ),
                                    trailing: isSelected
                                        ? const Icon(
                                            CupertinoIcons.checkmark_alt,
                                            color: _primaryAccent,
                                            size: 18)
                                        : !hasCC
                                            ? Icon(
                                                CupertinoIcons.exclamationmark_triangle,
                                                color: CupertinoColors
                                                    .systemOrange
                                                    .resolveFrom(ctx2),
                                                size: 16)
                                            : null,
                                    onTap: () {
                                      if (!hasCC) {
                                        CupertinoGlassToast.showError(
                                            ctx2,
                                            'Petak ${pond.shortLabel} belum memiliki cost centre.');
                                        return;
                                      }
                                      Navigator.pop(ctx2);
                                      _onPondSelected(lineIndex, pond);
                                    },
                                  );
                                }).toList(),
                              );
                            }).toList(),
                          ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  // ─── Warehouse Picker ────────────────────────────────────────────────────────

  void _showWarehousePicker(List<WarehouseOption> warehouses) {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Pilih Gudang Asal'),
        actions: warehouses.map((w) {
          return CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _selectedWarehouse = w);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(w.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text('Kode: ${w.code}',
                    style: const TextStyle(
                        fontSize: 12, color: CupertinoColors.secondaryLabel)),
              ],
            ),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Batal'),
        ),
      ),
    );
  }

  // ─── Date Picker ─────────────────────────────────────────────────────────────

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(ctx),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Batal')),
                  CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Selesai',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _usageDate,
                maximumDate: DateTime.now(),
                onDateTimeChanged: (dt) => setState(() => _usageDate = dt),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Photo ───────────────────────────────────────────────────────────────────

  Future<void> _pickPhoto() async {
    final source = await showCupertinoModalPopup<ImageSource>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(ctx, ImageSource.camera),
            child: const Text('Ambil Foto dari Kamera'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(ctx, ImageSource.gallery),
            child: const Text('Pilih dari Galeri'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Batal'),
        ),
      ),
    );
    if (source == null) return;
    final image = await ImagePicker().pickImage(
        source: source, maxWidth: 1920, maxHeight: 1080, imageQuality: 80);
    if (image != null) setState(() => _photoFile = image);
  }

  // ─── Validation & Submit ─────────────────────────────────────────────────────

  bool get _canSubmit =>
      _lines.isNotEmpty &&
      _selectedWarehouse != null &&
      _lines.every((l) => l.usageQty > 0 && l.pond?.costCentreCode != null) &&
      !_isSubmitting;

  Future<void> _submit() async {
    bool hasError = false;

    // Validate each line
    for (int i = 0; i < _lines.length; i++) {
      final text = _qtyControllers[i].text.trim();
      final parsed = double.tryParse(text);
      if (parsed == null || parsed <= 0) {
        setState(() => _lineErrors[i] = 'Jumlah wajib diisi (> 0)');
        hasError = true;
      } else if (_lines[i].pond == null) {
        setState(() => _lineErrors[i] = 'Pilih petak untuk baris ini');
        hasError = true;
      } else if (_lines[i].pond?.costCentreCode == null) {
        setState(() => _lineErrors[i] = 'Petak belum memiliki cost centre');
        hasError = true;
      } else {
        setState(() {
          _lines[i] = _lines[i].copyWith(usageQty: parsed);
          _lineErrors[i] = null;
        });
      }
    }

    // Cross-line stock validation: total per inventory_id ≤ availableQty
    if (!hasError) {
      final grouped = <int, List<int>>{};
      for (int i = 0; i < _lines.length; i++) {
        grouped.putIfAbsent(_lines[i].inventoryId, () => []).add(i);
      }
      for (final entry in grouped.entries) {
        final indices = entry.value;
        final totalQty =
            indices.fold<double>(0.0, (s, i) => s + _lines[i].usageQty);
        final available = _lines[indices.first].availableQty;
        if (totalQty > available) {
          for (final i in indices) {
            setState(() => _lineErrors[i] =
                'Total melebihi stok ($totalQty > $available ${_lines[i].unit ?? ""})');
          }
          hasError = true;
        }
      }
    }

    if (hasError || _selectedWarehouse == null) {
      if (_selectedWarehouse == null) {
        CupertinoGlassToast.showError(context, 'Pilih gudang terlebih dahulu.');
      }
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await ref.read(itemUsageRepositoryProvider).submitUsage(
            items: _lines,
            warehouseId: _selectedWarehouse!.id,
            usageDate: DateFormat('yyyy-MM-dd').format(_usageDate),
            notes: _notesController.text.trim(),
            photo: _photoFile,
          );

      if (!mounted) return;
      CupertinoGlassToast.showSuccess(
          context, 'Pemakaian barang berhasil dikirim!');

      setState(() {
        for (final c in _qtyControllers) {
          c.dispose();
        }
        _lines.clear();
        _qtyControllers.clear();
        _lineErrors.clear();
        _notesController.clear();
        _photoFile = null;
        _selectedWarehouse = null;
        _usageDate = DateTime.now();
      });
    } catch (e) {
      if (mounted) CupertinoGlassToast.showError(context, 'Gagal: $e');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Listen to changes in the selected company to clear form state (prevent cross-company leakage)
    ref.listen<Company?>(selectedCompanyProvider, (previous, next) {
      if (previous != next) {
        setState(() {
          _selectedWarehouse = null;
          _lines.clear();
          for (final c in _qtyControllers) {
            c.dispose();
          }
          _qtyControllers.clear();
          _lineErrors.clear();
        });
      }
    });

    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth > 800 ? 600.0 : double.infinity;

    final warehousesAsync = ref.watch(warehousesProvider);
    // Watch activePondsProvider so it stays alive AND we can reflect loading state in UI
    final activePondsAsync = ref.watch(activePondsProvider);

    return CupertinoPageScaffold(
      backgroundColor:
          CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Pemakaian Barang'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/'),
          child: const Icon(CupertinoIcons.back, color: _primaryAccent),
        ),
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              children: [
                const CompanySwitcher(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── Section 1: Header ─────────────────────────────
                        _buildSectionHeader('1. Informasi Transaksi'),
                        const SizedBox(height: CupertinoSpacing.s),
                        _buildHeaderCard(warehousesAsync),

                        const SizedBox(height: CupertinoSpacing.xxl),

                        // ── Section 2: Item Lines ─────────────────────────
                        _buildSectionHeader('2. Daftar Pemakaian Barang'),
                        const SizedBox(height: CupertinoSpacing.xs),
                        _buildHint(),
                        const SizedBox(height: CupertinoSpacing.s),
                        _buildItemSearchRow(),
                        const SizedBox(height: CupertinoSpacing.m),
                        if (_lines.isEmpty) _buildEmptyPlaceholder(),
                        ..._lines.asMap().entries.map(
                            (e) => _buildLineCard(e.key, e.value, activePondsAsync)),

                        const SizedBox(height: CupertinoSpacing.xxl),

                        // ── Section 3: Notes & Photo ───────────────────────
                        _buildSectionHeader('3. Catatan & Bukti Foto (Opsional)'),
                        const SizedBox(height: CupertinoSpacing.s),
                        _buildNotesAndPhoto(),

                        const SizedBox(height: CupertinoSpacing.xxl),
                      ],
                    ),
                  ),
                ),
                _buildSubmitBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Widget Helpers ───────────────────────────────────────────────────────────

  Widget _buildSectionHeader(String title) => Text(
        title,
        style: context.callout
            .copyWith(fontWeight: FontWeight.bold, color: _primaryAccent),
      );

  Widget _buildHint() {
    return Text(
      'Barang yang sama boleh ditambahkan beberapa kali dengan petak berbeda.',
      style: context.caption1.copyWith(
          color: CupertinoColors.secondaryLabel.resolveFrom(context)),
    );
  }

  Widget _buildHeaderCard(AsyncValue<List<WarehouseOption>> warehousesAsync) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final sepColor = CupertinoColors.separator.resolveFrom(context);

    return CupertinoGlassContainer(
      padding: const EdgeInsets.all(CupertinoSpacing.m),
      borderRadius: CupertinoSpacing.cardRadius,
      child: Column(
        children: [
          // Warehouse
          GestureDetector(
            onTap: () {
              final selectedCompany = ref.read(selectedCompanyProvider);
              if (selectedCompany == null) {
                CupertinoGlassToast.showError(
                    context, 'Silakan pilih perusahaan terlebih dahulu.');
                return;
              }
              final ws = warehousesAsync.value ?? [];
              if (ws.isEmpty) {
                CupertinoGlassToast.showError(
                    context, 'Tidak ada gudang tersedia untuk perusahaan ini.');
              } else {
                _showWarehousePicker(ws);
              }
            },
            child: Row(
              children: [
                const Icon(CupertinoIcons.cube_box_fill,
                    color: _primaryAccent, size: 18),
                const SizedBox(width: CupertinoSpacing.m),
                Expanded(
                  child: warehousesAsync.when(
                    loading: () => const CupertinoActivityIndicator(),
                    error: (e, _) => Text('Error memuat gudang',
                        style: context.footnote.copyWith(color: _dangerColor)),
                    data: (_) => _selectedWarehouse == null
                        ? Text(
                            ref.watch(selectedCompanyProvider) == null
                                ? 'Pilih perusahaan terlebih dahulu…'
                                : 'Pilih Gudang Asal…',
                            style: context.subhead
                                .copyWith(color: secondaryLabel))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_selectedWarehouse!.name,
                                  style: context.subhead.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: labelColor)),
                              Text('Kode: ${_selectedWarehouse!.code}',
                                  style: context.caption1
                                      .copyWith(color: secondaryLabel)),
                            ],
                          ),
                  ),
                ),
                Icon(CupertinoIcons.chevron_down,
                    size: 14, color: secondaryLabel),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.m),
            child: Container(height: 0.5, color: sepColor),
          ),

          // Date
          GestureDetector(
            onTap: _showDatePicker,
            child: Row(
              children: [
                const Icon(CupertinoIcons.calendar,
                    color: _primaryAccent, size: 18),
                const SizedBox(width: CupertinoSpacing.m),
                Expanded(
                  child: Text(
                    'Tanggal: ${DateFormat('dd MMM yyyy').format(_usageDate)}',
                    style: context.subhead.copyWith(color: labelColor),
                  ),
                ),
                Icon(CupertinoIcons.chevron_down,
                    size: 14, color: secondaryLabel),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemSearchRow() {
    final hasCompany = ref.watch(selectedCompanyProvider) != null;
    final narrow = MediaQuery.of(context).size.width < 400;
    return Column(
      children: [
        if (narrow) ...[
          _buildSearchField(hasCompany),
          const SizedBox(height: CupertinoSpacing.s),
          Row(children: [
            Expanded(child: _buildScanBtn(hasCompany)),
            const SizedBox(width: CupertinoSpacing.s),
            Expanded(child: _buildCariBtn(hasCompany)),
          ]),
        ] else ...[
          Row(children: [
            Expanded(child: _buildSearchField(hasCompany)),
            const SizedBox(width: CupertinoSpacing.s),
            _buildScanBtn(hasCompany),
            const SizedBox(width: CupertinoSpacing.s),
            _buildCariBtn(hasCompany),
          ]),
        ],
        if (_itemError != null) ...[
          const SizedBox(height: CupertinoSpacing.s),
          Text(_itemError!,
              style: context.footnote.copyWith(color: _dangerColor)),
        ],
      ],
    );
  }

  Widget _buildSearchField(bool hasCompany) => CupertinoTextField(
        controller: _searchController,
        enabled: hasCompany,
        placeholder: hasCompany
            ? 'Cari nama barang, SKU, atau barcode…'
            : 'Pilih perusahaan dulu…',
        onSubmitted: hasCompany ? _lookupItem : null,
        suffix: _isLoadingItem
            ? const Padding(
                padding: EdgeInsets.only(right: 8),
                child: CupertinoActivityIndicator())
            : null,
      );

  Widget _buildScanBtn(bool hasCompany) => CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        color: hasCompany
            ? _primaryAccent.withValues(alpha: 0.1)
            : CupertinoColors.inactiveGray.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
        onPressed: hasCompany ? _scanBarcode : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.qrcode_viewfinder,
                color: hasCompany ? _primaryAccent : CupertinoColors.inactiveGray,
                size: 16),
            const SizedBox(width: 4),
            Text('Scan',
                style: TextStyle(
                    color: hasCompany ? _primaryAccent : CupertinoColors.inactiveGray,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ],
        ),
      );

  Widget _buildCariBtn(bool hasCompany) => CupertinoButton.filled(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
        disabledColor: CupertinoColors.quaternarySystemFill.resolveFrom(context),
        onPressed: (!hasCompany || _isLoadingItem)
            ? null
            : () => _lookupItem(_searchController.text),
        child: Text(
          'Cari',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: hasCompany ? CupertinoColors.white : CupertinoColors.inactiveGray,
          ),
        ),
      );

  Widget _buildEmptyPlaceholder() {
    final company = ref.watch(selectedCompanyProvider);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    return CupertinoGlassContainer(
      padding: const EdgeInsets.symmetric(
          vertical: 32, horizontal: CupertinoSpacing.m),
      borderRadius: CupertinoSpacing.cardRadius,
      child: Column(children: [
        Icon(
          company == null ? CupertinoIcons.building_2_fill : CupertinoIcons.cube_box,
          size: 40,
          color: secondaryLabel,
        ),
        const SizedBox(height: CupertinoSpacing.m),
        Text(
          company == null
              ? 'Silakan pilih perusahaan terlebih dahulu.'
              : 'Belum ada barang.\nScan barcode atau cari nama barang.',
          textAlign: TextAlign.center,
          style: context.subhead.copyWith(color: secondaryLabel),
        ),
      ]),
    );
  }

  Widget _buildLineCard(
      int index, UsageLine line, AsyncValue<List<ActivePond>> pondsAsync) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final sepColor = CupertinoColors.separator.resolveFrom(context);
    final hasError = _lineErrors.length > index && _lineErrors[index] != null;
    final pond = line.pond;
    final pondsLoading = pondsAsync is AsyncLoading;
    final pondsError = pondsAsync is AsyncError;

    // Count how many lines share the same inventory
    final sameItemCount =
        _lines.where((l) => l.inventoryId == line.inventoryId).length;
    final totalSameQty = _totalQtyForInventory(line.inventoryId);

    return Padding(
      padding: const EdgeInsets.only(bottom: CupertinoSpacing.m),
      child: CupertinoGlassContainer(
        padding: const EdgeInsets.all(CupertinoSpacing.m),
        borderRadius: CupertinoSpacing.cardRadius,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Item header ───────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _primaryAccent.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text('${index + 1}',
                      style: context.footnote.copyWith(
                          fontWeight: FontWeight.bold, color: _primaryAccent)),
                ),
                const SizedBox(width: CupertinoSpacing.s),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(line.productName,
                          style: context.subhead.copyWith(
                              fontWeight: FontWeight.bold, color: labelColor)),
                      const SizedBox(height: 2),
                      Row(children: [
                        Text(
                          'SKU: ${line.sku}  •  Stok: ${line.availableQty.toStringAsFixed(2)} ${line.unit ?? ""}',
                          style:
                              context.caption1.copyWith(color: secondaryLabel),
                        ),
                        if (sameItemCount > 1) ...[
                          const SizedBox(width: 6),
                          _buildBadge(
                              'Total: ${totalSameQty.toStringAsFixed(2)}',
                              CupertinoColors.systemOrange),
                        ],
                      ]),
                    ],
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(28, 28),
                  onPressed: () => _removeLine(index),
                  child: Icon(CupertinoIcons.clear_circled_solid,
                      color: secondaryLabel, size: 20),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.m),
              child: Container(height: 0.5, color: sepColor),
            ),

            // ── Qty input ─────────────────────────────────────────────────
            Row(
              children: [
                Text('Jumlah:',
                    style: context.subhead
                        .copyWith(fontWeight: FontWeight.w600, color: labelColor)),
                const SizedBox(width: CupertinoSpacing.m),
                Expanded(
                  child: CupertinoTextField(
                    controller: _qtyControllers[index],
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    placeholder: '0',
                    textAlign: TextAlign.end,
                    suffix: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(line.unit ?? 'pcs',
                          style: context.footnote
                              .copyWith(color: secondaryLabel)),
                    ),
                    onChanged: (v) => _onQtyChanged(index, v),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground
                          .resolveFrom(context),
                      border: Border.all(
                        color: hasError
                            ? _dangerColor
                            : CupertinoColors.separator.resolveFrom(context),
                        width: hasError ? 1.0 : 0.5,
                      ),
                      borderRadius: BorderRadius.circular(
                          CupertinoSpacing.buttonRadius),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: CupertinoSpacing.m),

            // ── Pond selector ─────────────────────────────────────────────
            GestureDetector(
              onTap: () => _showPondPicker(index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: CupertinoSpacing.m, vertical: 10),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground.resolveFrom(context),
                  border: Border.all(
                    color: (hasError && pond == null)
                        ? _dangerColor
                        : CupertinoColors.separator.resolveFrom(context),
                    width: 0.5,
                  ),
                  borderRadius:
                      BorderRadius.circular(CupertinoSpacing.buttonRadius),
                ),
                child: Row(
                  children: [
                    if (pondsLoading)
                      const SizedBox(
                          width: 16,
                          height: 16,
                          child: CupertinoActivityIndicator(radius: 8))
                    else if (pondsError)
                      Icon(CupertinoIcons.exclamationmark_triangle,
                          size: 16,
                          color: CupertinoColors.systemOrange
                              .resolveFrom(context))
                    else
                      Icon(
                        pond == null
                            ? CupertinoIcons.location
                            : CupertinoIcons.checkmark_circle_fill,
                        size: 16,
                        color: pond == null ? secondaryLabel : _primaryAccent,
                      ),
                    const SizedBox(width: CupertinoSpacing.s),
                    Expanded(
                      child: pondsLoading
                          ? Text('Memuat data petak…',
                              style: context.footnote
                                  .copyWith(color: secondaryLabel))
                          : pondsError
                              ? Text('Gagal memuat petak — ketuk untuk coba lagi',
                                  style: context.footnote.copyWith(
                                      color: CupertinoColors.systemOrange
                                          .resolveFrom(context)))
                              : pond == null
                                  ? Text('Pilih Petak…',
                                      style: context.footnote
                                          .copyWith(color: secondaryLabel))
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Big label: e.g. "A1"
                                        Text(
                                          pond.shortLabel,
                                          style: context.subhead.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: _primaryAccent),
                                        ),
                                        // Secondary: CC code + cycle
                                        Text(
                                          '${pond.costCentreCode ?? "—"}  •  Siklus ${pond.cycleName}',
                                          style: context.caption1
                                              .copyWith(color: secondaryLabel),
                                        ),
                                      ],
                                    ),
                    ),
                    if (!pondsLoading)
                      Icon(CupertinoIcons.chevron_right,
                          size: 12, color: secondaryLabel),
                  ],
                ),
              ),
            ),

            if (hasError) ...[
              const SizedBox(height: CupertinoSpacing.xs),
              Text(_lineErrors[index]!,
                  style: context.caption1.copyWith(color: _dangerColor)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotesAndPhoto() {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return CupertinoGlassContainer(
      padding: const EdgeInsets.all(CupertinoSpacing.m),
      borderRadius: CupertinoSpacing.cardRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Catatan',
              style: context.subhead
                  .copyWith(fontWeight: FontWeight.w600, color: labelColor)),
          const SizedBox(height: CupertinoSpacing.s),
          CupertinoTextField(
            controller: _notesController,
            placeholder: 'Tujuan penggunaan, lokasi, dsb.…',
            maxLines: 3,
            padding: const EdgeInsets.all(CupertinoSpacing.m),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground.resolveFrom(context),
              border: Border.all(
                  color: CupertinoColors.separator.resolveFrom(context),
                  width: 0.5),
              borderRadius:
                  BorderRadius.circular(CupertinoSpacing.buttonRadius),
            ),
          ),
          const SizedBox(height: CupertinoSpacing.l),
          Text('Bukti Foto',
              style: context.subhead
                  .copyWith(fontWeight: FontWeight.w600, color: labelColor)),
          const SizedBox(height: CupertinoSpacing.s),
          if (_photoFile != null) ...[
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(CupertinoSpacing.buttonRadius),
                  child: Image.file(File(_photoFile!.path),
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => setState(() => _photoFile = null),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: CupertinoColors.black, shape: BoxShape.circle),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(CupertinoIcons.clear,
                          color: CupertinoColors.white, size: 14),
                    ),
                  ),
                ),
              ],
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _pickPhoto,
              child: Text('Ganti Foto',
                  style: context.subhead.copyWith(color: _primaryAccent)),
            ),
          ] else ...[
            CupertinoButton(
              padding: const EdgeInsets.symmetric(
                  horizontal: CupertinoSpacing.m, vertical: CupertinoSpacing.m),
              color: _primaryAccent.withValues(alpha: 0.08),
              borderRadius:
                  BorderRadius.circular(CupertinoSpacing.buttonRadius),
              onPressed: _pickPhoto,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.camera,
                      color: _primaryAccent, size: 18),
                  const SizedBox(width: CupertinoSpacing.s),
                  Text('Tambah Foto Bukti',
                      style: context.subhead.copyWith(
                          color: _primaryAccent,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Text('Foto opsional tetapi disarankan untuk audit trail.',
                style: context.caption1.copyWith(color: secondaryLabel)),
          ],
        ],
      ),
    );
  }

  Widget _buildSubmitBar() {
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final allPondSet = _lines.every((l) => l.pond?.costCentreCode != null);

    return CupertinoGlassContainer(
      borderRadius: 0,
      padding: const EdgeInsets.symmetric(
          horizontal: CupertinoSpacing.screenMargin,
          vertical: CupertinoSpacing.m),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_lines.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: CupertinoSpacing.s),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_lines.length} baris${_selectedWarehouse != null ? ' • ${_selectedWarehouse!.code}' : ''}',
                      style: context.footnote.copyWith(color: secondaryLabel),
                    ),
                    if (!allPondSet)
                      _buildBadge('Petak belum lengkap', _dangerColor),
                  ],
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton.filled(
                onPressed: _canSubmit ? _submit : null,
                child: _isSubmitting
                    ? const CupertinoActivityIndicator(
                        color: CupertinoColors.white)
                    : const Text('KIRIM PEMAKAIAN BARANG',
                        style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label,
            style: context.caption2
                .copyWith(fontWeight: FontWeight.bold, color: color)),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Barcode Scanner Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────
class _BarcodeScannerSheet extends StatefulWidget {
  const _BarcodeScannerSheet();

  @override
  State<_BarcodeScannerSheet> createState() => _BarcodeScannerSheetState();
}

class _BarcodeScannerSheetState extends State<_BarcodeScannerSheet> {
  late MobileScannerController _controller;
  bool _scanned = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Stack(
          children: [
            MobileScanner(
              controller: _controller,
              onDetect: (capture) {
                if (_scanned) return;
                final barcode = capture.barcodes.firstOrNull;
                if (barcode?.rawValue != null) {
                  _scanned = true;
                  Navigator.pop(context, barcode!.rawValue!);
                }
              },
            ),
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: CupertinoColors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Arahkan ke barcode barang',
                      style: TextStyle(
                          color: CupertinoColors.white, fontSize: 14)),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: CupertinoButton(
                  color: CupertinoColors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(30),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 10),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal',
                      style: TextStyle(
                          color: CupertinoColors.black,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
