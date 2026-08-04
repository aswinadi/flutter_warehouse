import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_category_model.dart';
import '../providers/product_category_repository.dart';
import 'master_product_category_form_dialog.dart';
import '../../../core/widgets/company_switcher.dart';
import '../../../core/providers/company_provider.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_search_field.dart';
import '../../../core/theme/cupertino_spacing.dart';

class MasterProductCategoryListScreen extends ConsumerStatefulWidget {
  const MasterProductCategoryListScreen({super.key});

  @override
  ConsumerState<MasterProductCategoryListScreen> createState() => _MasterProductCategoryListScreenState();
}

class _MasterProductCategoryListScreenState extends ConsumerState<MasterProductCategoryListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isRefreshing = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() => _isRefreshing = true);
    final company = ref.read(selectedCompanyProvider);
    ref.invalidate(productCategoriesStreamProvider(company?.id));
    await ref.read(productCategoriesStreamProvider(company?.id).future);
    if (mounted) setState(() => _isRefreshing = false);
  }

  void _openFormDialog(ProductCategoryModel? category) async {
    final company = ref.read(selectedCompanyProvider);
    final companyId = company?.id ?? category?.companyId ?? 1;

    final result = await Navigator.of(context).push<bool>(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MasterProductCategoryFormDialog(
          companyId: companyId,
          category: category,
        ),
      ),
    );

    if (result == true) {
      _refreshData();
    }
  }

  void _confirmDelete(ProductCategoryModel category) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Hapus Kategori'),
        content: Text('Apakah Anda yakin ingin menghapus kategori "${category.name}"?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                final repo = ref.read(productCategoryRepositoryProvider);
                await repo.deleteCategory(category.id);
                _refreshData();
              } catch (e) {
                if (mounted) {
                  showCupertinoDialog(
                    context: context,
                    builder: (c) => CupertinoAlertDialog(
                      title: const Text('Gagal Hapus'),
                      content: Text(e.toString()),
                      actions: [
                        CupertinoDialogAction(
                          onPressed: () => Navigator.pop(c),
                          child: const Text('OK'),
                        )
                      ],
                    ),
                  );
                }
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final company = ref.watch(selectedCompanyProvider);
    final categoriesAsync = ref.watch(productCategoriesStreamProvider(company?.id));

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Kategori & Mapping COA'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _isRefreshing
                ? const CupertinoActivityIndicator()
                : CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: _refreshData,
                    child: const Icon(CupertinoIcons.refresh),
                  ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => _openFormDialog(null),
              child: const Icon(CupertinoIcons.add),
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Company Filter
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: CupertinoSpacing.screenMargin,
                vertical: CupertinoSpacing.halfScreenMargin,
              ),
              child: CompanySwitcher(),
            ),

            // Search Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin),
              child: CupertinoGlassSearchField(
                controller: _searchController,
                placeholder: 'Cari Kode atau Nama Kategori...',
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
              ),
            ),
            const SizedBox(height: 12),

            // List View
            Expanded(
              child: categoriesAsync.when(
                data: (categories) {
                  final filtered = categories.where((cat) {
                    final q = _searchQuery.toLowerCase();
                    return cat.code.toLowerCase().contains(q) || cat.name.toLowerCase().contains(q);
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text('Belum ada kategori produk', style: TextStyle(color: CupertinoColors.secondaryLabel)),
                    );
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin),
                    itemBuilder: (context, index) {
                      final category = filtered[index];
                      final isSubCategory = category.parentId != null;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CupertinoGlassContainer(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isSubCategory ? CupertinoColors.systemTeal.withOpacity(0.2) : CupertinoColors.activeBlue.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          category.code,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: isSubCategory ? CupertinoColors.systemTeal : CupertinoColors.activeBlue,
                                          ),
                                        ),
                                      ),
                                      if (isSubCategory) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: CupertinoColors.systemOrange.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            'Sub (${category.parentName ?? "Parent"})',
                                            style: const TextStyle(fontSize: 10, color: CupertinoColors.systemOrange, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () => _openFormDialog(category),
                                        child: const Icon(CupertinoIcons.pencil, size: 20),
                                      ),
                                      CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () => _confirmDelete(category),
                                        child: const Icon(CupertinoIcons.trash, size: 20, color: CupertinoColors.destructiveRed),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                category.name,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              if (category.description != null && category.description!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  category.description!,
                                  style: const TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel),
                                ),
                              ],
                              const SizedBox(height: 12),

                              // COA Badges
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: [
                                  _buildCoaBadge('Aset', category.inventoryAccountName, CupertinoColors.activeGreen),
                                  _buildCoaBadge('HPP', category.cogsAccountName, CupertinoColors.systemIndigo),
                                  _buildCoaBadge('Sales', category.salesAccountName, CupertinoColors.activeOrange),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CupertinoActivityIndicator()),
                error: (err, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Terjadi Kesalahan: $err', style: const TextStyle(color: CupertinoColors.destructiveRed)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoaBadge(String label, String? accountName, Color color) {
    final isSet = accountName != null && accountName.isNotEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSet ? color.withOpacity(0.15) : CupertinoColors.systemGrey.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isSet ? color.withOpacity(0.4) : CupertinoColors.systemGrey.withOpacity(0.3)),
      ),
      child: Text(
        '$label: ${isSet ? accountName : "Belum di-set"}',
        style: TextStyle(
          fontSize: 11,
          fontWeight: isSet ? FontWeight.w600 : FontWeight.normal,
          color: isSet ? color : CupertinoColors.secondaryLabel,
        ),
      ),
    );
  }
}
