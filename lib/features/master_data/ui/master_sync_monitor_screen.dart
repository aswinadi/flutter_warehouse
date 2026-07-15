import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/master_sync_repository.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/database/master_database.dart';

// Providers untuk memantau metadata sinkronisasi masing-masing tabel
final syncMetadataProvider = StreamProvider<List<SyncMetadataTableData>>((ref) {
  final db = ref.watch(masterDatabaseProvider);
  return db.select(db.syncMetadataTable).watch();
});

// Providers untuk menghitung baris data lokal
final productCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(masterDatabaseProvider);
  return db.select(db.productsTable).watch().map((list) => list.length);
});

final supplierCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(masterDatabaseProvider);
  return db.select(db.suppliersTable).watch().map((list) => list.length);
});

final companyCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(masterDatabaseProvider);
  return db.select(db.companiesTable).watch().map((list) => list.length);
});

class MasterSyncMonitorScreen extends ConsumerStatefulWidget {
  const MasterSyncMonitorScreen({super.key});

  @override
  ConsumerState<MasterSyncMonitorScreen> createState() => _MasterSyncMonitorScreenState();
}

class _MasterSyncMonitorScreenState extends ConsumerState<MasterSyncMonitorScreen> {
  bool _isSyncing = false;
  String? _syncErrorMessage;

  Future<void> _triggerSyncAll() async {
    setState(() {
      _isSyncing = true;
      _syncErrorMessage = null;
    });

    try {
      await ref.read(masterSyncRepositoryProvider).syncAll(force: true);
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Sinkronisasi Sukses'),
            content: const Text('Semua Master Data lokal telah diperbarui dengan data server terbaru.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _syncErrorMessage = 'Gagal terhubung ke server backend (Filament): $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'Belum pernah';
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime.toLocal());
  }

  Widget _buildMonitorCard({
    required String title,
    required int count,
    required DateTime? lastSynced,
    required IconData icon,
    required Color iconColor,
  }) {
    final isOutdated = lastSynced == null || 
        DateTime.now().difference(lastSynced).inDays >= 1;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CupertinoGlassContainer(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Jumlah Data: $count baris',
                    style: const TextStyle(fontSize: 14, color: CupertinoColors.secondaryLabel),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Sync Terakhir: ${_formatDate(lastSynced)}',
                    style: TextStyle(
                      fontSize: 12, 
                      color: isOutdated ? CupertinoColors.systemRed : CupertinoColors.secondaryLabel,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isOutdated ? CupertinoIcons.exclamationmark_triangle_fill : CupertinoIcons.check_mark_circled_solid,
              color: isOutdated ? CupertinoColors.systemYellow : CupertinoColors.systemGreen,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final metadataAsync = ref.watch(syncMetadataProvider);
    final productCount = ref.watch(productCountProvider).value ?? 0;
    final supplierCount = ref.watch(supplierCountProvider).value ?? 0;
    final companyCount = ref.watch(companyCountProvider).value ?? 0;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Monitor Sinkronisasi Backend'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Status Sinkronisasi Cache Lokal',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Berikut adalah status sinkronisasi master data yang disimpan secara lokal pada perangkat Anda untuk mempercepat akses dan mengurangi beban server backend (Filament).',
                style: TextStyle(fontSize: 14, color: CupertinoColors.secondaryLabel),
              ),
              const SizedBox(height: 24),
              
              Expanded(
                child: metadataAsync.when(
                  data: (metadataList) {
                    final mapMeta = { for (var e in metadataList) e.syncTable : e.lastSyncedAt };
                    
                    return ListView(
                      children: [
                        _buildMonitorCard(
                          title: 'Produk',
                          count: productCount,
                          lastSynced: mapMeta['products'],
                          icon: CupertinoIcons.cube_box,
                          iconColor: CupertinoColors.activeBlue,
                        ),
                        _buildMonitorCard(
                          title: 'Supplier',
                          count: supplierCount,
                          lastSynced: mapMeta['suppliers'],
                          icon: CupertinoIcons.bus,
                          iconColor: CupertinoColors.activeOrange,
                        ),
                        _buildMonitorCard(
                          title: 'Perusahaan',
                          count: companyCount,
                          lastSynced: mapMeta['companies'],
                          icon: CupertinoIcons.building_2_fill,
                          iconColor: CupertinoColors.systemPurple,
                        ),
                        
                        if (_syncErrorMessage != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            _syncErrorMessage!,
                            style: const TextStyle(color: CupertinoColors.systemRed, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ]
                      ],
                    );
                  },
                  loading: () => const Center(child: CupertinoActivityIndicator()),
                  error: (e, s) => Center(child: Text('Gagal memuat metadata sinkronisasi: $e')),
                ),
              ),
              
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  color: CupertinoColors.activeBlue,
                  borderRadius: BorderRadius.circular(12),
                  onPressed: _isSyncing ? null : _triggerSyncAll,
                  child: _isSyncing 
                    ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.arrow_2_circlepath,
                            color: CupertinoColors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Sinkronkan Sekarang',
                            style: TextStyle(
                              color: CupertinoColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
