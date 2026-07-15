import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/master_sync_repository.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_search_field.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/database/master_database.dart';

final localSuppliersProvider = StreamProvider<List<SuppliersTableData>>((ref) {
  final db = ref.watch(masterDatabaseProvider);
  return db.select(db.suppliersTable).watch();
});

class MasterSupplierListScreen extends ConsumerStatefulWidget {
  const MasterSupplierListScreen({super.key});

  @override
  ConsumerState<MasterSupplierListScreen> createState() => _MasterSupplierListScreenState();
}

class _MasterSupplierListScreenState extends ConsumerState<MasterSupplierListScreen> {
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
      await ref.read(masterSyncRepositoryProvider).syncSuppliers(force: true);
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  Future<void> _makeCall(String? phone) async {
    if (phone == null || phone.isEmpty) return;
    final Uri url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final suppliersAsync = ref.watch(localSuppliersProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Master Supplier (Read-Only)'),
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
                placeholder: 'Cari berdasarkan Nama atau Kode...',
                onChanged: (value) => setState(() => _searchQuery = value.trim()),
              ),
            ),
            
            Expanded(
              child: suppliersAsync.when(
                data: (suppliers) {
                  final filtered = suppliers.where((s) {
                    final query = _searchQuery.toLowerCase();
                    return s.code.toLowerCase().contains(query) || 
                           s.name.toLowerCase().contains(query);
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(child: Text('Supplier tidak ditemukan secara lokal'));
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final supplier = filtered[index];
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
                                    supplier.code,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: CupertinoColors.activeOrange,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: supplier.isActive 
                                          ? const Color(0x3330D158) 
                                          : const Color(0x33FF453A),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      supplier.isActive ? 'Aktif' : 'Non-aktif',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: supplier.isActive 
                                            ? const Color(0xFF30D158) 
                                            : const Color(0xFFFF453A),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                supplier.name,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              if (supplier.phone != null && supplier.phone!.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () => _makeCall(supplier.phone),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(CupertinoIcons.phone, size: 16, color: CupertinoColors.activeBlue),
                                      const SizedBox(width: 6),
                                      Text(
                                        supplier.phone!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: CupertinoColors.activeBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
