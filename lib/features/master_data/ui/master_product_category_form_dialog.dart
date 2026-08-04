import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_category_model.dart';
import '../providers/product_category_repository.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_switch.dart';
import '../../../core/theme/cupertino_spacing.dart';

class MasterProductCategoryFormDialog extends ConsumerStatefulWidget {
  final int companyId;
  final ProductCategoryModel? category;

  const MasterProductCategoryFormDialog({
    super.key,
    required this.companyId,
    this.category,
  });

  @override
  ConsumerState<MasterProductCategoryFormDialog> createState() => _MasterProductCategoryFormDialogState();
}

class _MasterProductCategoryFormDialogState extends ConsumerState<MasterProductCategoryFormDialog> {
  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  int? _selectedParentId;
  int? _inventoryAccountId;
  int? _cogsAccountId;
  int? _salesAccountId;
  int? _salesReturnAccountId;
  int? _salesDiscountAccountId;
  int? _purchaseReturnAccountId;
  int? _inventoryAdjustmentAccountId;
  int? _taxRateId;
  bool _isActive = true;

  bool _isSaving = false;
  bool _isLoadingCoa = true;
  List<ProductCategoryModel> _parentOptions = [];
  List<Map<String, dynamic>> _coaAccounts = [];

  @override
  void initState() {
    super.initState();
    final c = widget.category;
    _codeController = TextEditingController(text: c?.code ?? '');
    _nameController = TextEditingController(text: c?.name ?? '');
    _descriptionController = TextEditingController(text: c?.description ?? '');

    _selectedParentId = c?.parentId;
    _inventoryAccountId = c?.inventoryAccountId;
    _cogsAccountId = c?.cogsAccountId;
    _salesAccountId = c?.salesAccountId;
    _salesReturnAccountId = c?.salesReturnAccountId;
    _salesDiscountAccountId = c?.salesDiscountAccountId;
    _purchaseReturnAccountId = c?.purchaseReturnAccountId;
    _inventoryAdjustmentAccountId = c?.inventoryAdjustmentAccountId;
    _taxRateId = c?.taxRateId;
    _isActive = c?.isActive ?? true;

    _loadMasterOptions();
  }

  Future<void> _loadMasterOptions() async {
    final repo = ref.read(productCategoryRepositoryProvider);
    try {
      final categories = await repo.getCategories(companyId: widget.companyId);
      final coa = await repo.getCoaAccounts(companyId: widget.companyId);

      if (mounted) {
        setState(() {
          _parentOptions = categories.where((cat) => cat.id != widget.category?.id).toList();
          _coaAccounts = coa;
          _isLoadingCoa = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingCoa = false);
      }
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final code = _codeController.text.trim();
    final name = _nameController.text.trim();

    if (code.isEmpty || name.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Input Tidak Lengkap'),
          content: const Text('Kode dan Nama Kategori wajib diisi.'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            )
          ],
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final payload = <String, dynamic>{
      'company_id': widget.companyId,
      'code': code,
      'name': name,
      'parent_id': _selectedParentId,
      'description': _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      'inventory_account_id': _inventoryAccountId,
      'cogs_account_id': _cogsAccountId,
      'sales_account_id': _salesAccountId,
      'sales_return_account_id': _salesReturnAccountId,
      'sales_discount_account_id': _salesDiscountAccountId,
      'purchase_return_account_id': _purchaseReturnAccountId,
      'inventory_adjustment_account_id': _inventoryAdjustmentAccountId,
      'tax_rate_id': _taxRateId,
      'is_active': _isActive,
    };

    try {
      final repo = ref.read(productCategoryRepositoryProvider);
      if (widget.category == null) {
        await repo.createCategory(payload);
      } else {
        await repo.updateCategory(widget.category!.id, payload);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
            title: const Text('Gagal Menyimpan'),
            content: Text(e.toString()),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              )
            ],
          ),
        );
      }
    }
  }

  void _showCoaPicker(String title, int? currentId, ValueChanged<int?> onSelected) {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => Container(
        height: 320,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: CupertinoColors.tertiarySystemFill,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Selesai'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _coaAccounts.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return CupertinoListTile(
                      title: const Text('- Tidak Di-set (Kosong) -', style: TextStyle(color: CupertinoColors.systemGrey)),
                      trailing: currentId == null ? const Icon(CupertinoIcons.check_mark, color: CupertinoColors.activeBlue) : null,
                      onTap: () {
                        onSelected(null);
                        Navigator.pop(ctx);
                      },
                    );
                  }
                  final item = _coaAccounts[index - 1];
                  final id = item['id'] as int;
                  final code = item['coa_code'] as String? ?? '';
                  final name = item['coa_name'] as String? ?? '';
                  return CupertinoListTile(
                    title: Text('$code - $name'),
                    trailing: currentId == id ? const Icon(CupertinoIcons.check_mark, color: CupertinoColors.activeBlue) : null,
                    onTap: () {
                      onSelected(id);
                      Navigator.pop(ctx);
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.category == null ? 'Tambah Kategori Produk' : 'Edit Kategori & COA'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Batal'),
          onPressed: () => Navigator.pop(context),
        ),
        trailing: _isSaving
            ? const CupertinoActivityIndicator()
            : CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _handleSave,
                child: const Text('Simpan', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
          children: [
            // Section 1: Informasi Kategori
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'INFORMASI KATEGORI',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: CupertinoColors.secondaryLabel),
              ),
            ),
            CupertinoGlassContainer(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CupertinoTextField(
                    controller: _codeController,
                    placeholder: 'Kode Kategori (e.g. CAT-RAW)',
                    prefix: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(CupertinoIcons.barcode, color: CupertinoColors.systemGrey),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CupertinoTextField(
                    controller: _nameController,
                    placeholder: 'Nama Kategori (e.g. Bahan Baku)',
                    prefix: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(CupertinoIcons.tag, color: CupertinoColors.systemGrey),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Parent Picker
                  GestureDetector(
                    onTap: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (ctx) => Container(
                          height: 250,
                          color: CupertinoColors.systemBackground.resolveFrom(context),
                          child: ListView(
                            children: [
                              CupertinoListTile(
                                title: const Text('Kategori Utama (Top Level)'),
                                onTap: () {
                                  setState(() => _selectedParentId = null);
                                  Navigator.pop(ctx);
                                },
                              ),
                              ..._parentOptions.map((cat) => CupertinoListTile(
                                    title: Text(cat.name),
                                    onTap: () {
                                      setState(() => _selectedParentId = cat.id);
                                      Navigator.pop(ctx);
                                    },
                                  )),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: CupertinoColors.tertiarySystemFill,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Sub-Kategori Dari:'),
                          Text(
                            _selectedParentId == null
                                ? 'Kategori Utama'
                                : _parentOptions.firstWhere((element) => element.id == _selectedParentId, orElse: () => ProductCategoryModel(id: 0, companyId: 0, code: '', name: 'Utama')).name,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.activeBlue),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CupertinoTextField(
                    controller: _descriptionController,
                    placeholder: 'Deskripsi Kategori...',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Status Aktif'),
                      CupertinoGlassSwitch(
                        value: _isActive,
                        onChanged: (val) => setState(() => _isActive = val),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section 2: Mapping Akun COA
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'MAPPING AKUN COA (AKUNTANSI)',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: CupertinoColors.secondaryLabel),
              ),
            ),

            if (_isLoadingCoa)
              const Center(child: CupertinoActivityIndicator())
            else
              CupertinoGlassContainer(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildCoaTile('Akun Persediaan (114xx)', _inventoryAccountId, (val) => setState(() => _inventoryAccountId = val)),
                    Container(height: 1, color: CupertinoColors.separator, margin: const EdgeInsets.symmetric(vertical: 8)),
                    _buildCoaTile('Akun HPP (51xxx)', _cogsAccountId, (val) => setState(() => _cogsAccountId = val)),
                    Container(height: 1, color: CupertinoColors.separator, margin: const EdgeInsets.symmetric(vertical: 8)),
                    _buildCoaTile('Akun Penjualan (41xxx)', _salesAccountId, (val) => setState(() => _salesAccountId = val)),
                    Container(height: 1, color: CupertinoColors.separator, margin: const EdgeInsets.symmetric(vertical: 8)),
                    _buildCoaTile('Akun Retur Penjualan', _salesReturnAccountId, (val) => setState(() => _salesReturnAccountId = val)),
                    Container(height: 1, color: CupertinoColors.separator, margin: const EdgeInsets.symmetric(vertical: 8)),
                    _buildCoaTile('Akun Diskon Penjualan', _salesDiscountAccountId, (val) => setState(() => _salesDiscountAccountId = val)),
                    Container(height: 1, color: CupertinoColors.separator, margin: const EdgeInsets.symmetric(vertical: 8)),
                    _buildCoaTile('Akun Retur Pembelian', _purchaseReturnAccountId, (val) => setState(() => _purchaseReturnAccountId = val)),
                    Container(height: 1, color: CupertinoColors.separator, margin: const EdgeInsets.symmetric(vertical: 8)),
                    _buildCoaTile('Akun Selisih Stok / Opname', _inventoryAdjustmentAccountId, (val) => setState(() => _inventoryAdjustmentAccountId = val)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoaTile(String title, int? selectedId, ValueChanged<int?> onSelected) {
    final selectedCoa = _coaAccounts.firstWhere((c) => c['id'] == selectedId, orElse: () => {});
    final displayName = selectedCoa.isNotEmpty ? '${selectedCoa['coa_code']} - ${selectedCoa['coa_name']}' : 'Belum Dipilih';

    return GestureDetector(
      onTap: () => _showCoaPicker(title, selectedId, onSelected),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 12,
                    color: selectedId != null ? CupertinoColors.activeBlue : CupertinoColors.secondaryLabel,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(CupertinoIcons.chevron_right, size: 16, color: CupertinoColors.systemGrey),
        ],
      ),
    );
  }
}
