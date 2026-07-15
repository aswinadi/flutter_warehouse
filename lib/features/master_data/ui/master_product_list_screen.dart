import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/master_sync_repository.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_search_field.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/database/master_database.dart';

final localProductsProvider = StreamProvider<List<ProductsTableData>>((ref) {
  final db = ref.watch(masterDatabaseProvider);
  return db.select(db.productsTable).watch();
});

class MasterProductListScreen extends ConsumerStatefulWidget {
  const MasterProductListScreen({super.key});

  @override
  ConsumerState<MasterProductListScreen> createState() => _MasterProductListScreenState();
}

class _MasterProductListScreenState extends ConsumerState<MasterProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSyncing = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() => _isSyncing = true);
    try {
      await ref.read(masterSyncRepositoryProvider).syncProducts(force: true);
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(localProductsProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Master Produk (Read-Only)'),
        trailing: _isSyncing 
          ? const CupertinoActivityIndicator()
          : CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _handleRefresh,
              child: const Icon(CupertinoIcons.refresh),
            ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
              child: CupertinoGlassSearchField(
                controller: _searchController,
                placeholder: 'Cari berdasarkan SKU atau Nama...',
                onChanged: (value) => setState(() => _searchQuery = value.trim()),
              ),
            ),
            
            Expanded(
              child: productsAsync.when(
                data: (products) {
                  final filtered = products.where((p) {
                    final query = _searchQuery.toLowerCase();
                    return p.sku.toLowerCase().contains(query) || 
                           p.name.toLowerCase().contains(query);
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(child: Text('Produk tidak ditemukan secara lokal'));
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final product = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: CupertinoSpacing.screenMargin,
                          vertical: CupertinoSpacing.halfScreenMargin,
                        ),
                        child: CupertinoGlassContainer(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    product.sku,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: CupertinoColors.activeBlue,
                                    ),
                                  ),
                                  Text(
                                    product.unit,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: CupertinoColors.secondaryLabel,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product.name,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Kategori: ${product.category}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: CupertinoColors.secondaryLabel,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CupertinoActivityIndicator()),
                error: (e, s) => Center(child: Text('Error loading local cache: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
