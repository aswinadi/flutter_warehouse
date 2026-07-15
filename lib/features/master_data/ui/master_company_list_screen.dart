import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/master_sync_repository.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_search_field.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/database/master_database.dart';

final localCompaniesProvider = StreamProvider<List<CompaniesTableData>>((ref) {
  final db = ref.watch(masterDatabaseProvider);
  return db.select(db.companiesTable).watch();
});

class MasterCompanyListScreen extends ConsumerStatefulWidget {
  const MasterCompanyListScreen({super.key});

  @override
  ConsumerState<MasterCompanyListScreen> createState() => _MasterCompanyListScreenState();
}

class _MasterCompanyListScreenState extends ConsumerState<MasterCompanyListScreen> {
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
      await ref.read(masterSyncRepositoryProvider).syncCompanies(force: true);
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final companiesAsync = ref.watch(localCompaniesProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Master Perusahaan (Read-Only)'),
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
              child: companiesAsync.when(
                data: (companies) {
                  final filtered = companies.where((c) {
                    final query = _searchQuery.toLowerCase();
                    return c.companyCode.toLowerCase().contains(query) || 
                           c.companyName.toLowerCase().contains(query);
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(child: Text('Perusahaan tidak ditemukan secara lokal'));
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final company = filtered[index];
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
                                    company.companyCode,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: CupertinoColors.activeBlue,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: company.isActive 
                                          ? const Color(0x3330D158) 
                                          : const Color(0x33FF453A),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      company.isActive ? 'Aktif' : 'Non-aktif',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: company.isActive 
                                            ? const Color(0xFF30D158) 
                                            : const Color(0xFFFF453A),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                company.companyName,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
