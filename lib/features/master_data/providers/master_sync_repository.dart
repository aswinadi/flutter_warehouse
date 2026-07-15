import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/database/master_database.dart';

final masterDatabaseProvider = Provider<MasterDatabase>((ref) {
  final db = MasterDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final masterSyncRepositoryProvider = Provider<MasterSyncRepository>((ref) {
  return MasterSyncRepository(
    dio: ref.watch(dioProvider),
    db: ref.watch(masterDatabaseProvider),
  );
});

class MasterSyncRepository {
  final Dio dio;
  final MasterDatabase db;

  MasterSyncRepository({required this.dio, required this.db});

  // Melakukan sinkronisasi global berdasarkan status timestamp dari backend
  Future<void> syncAll({bool force = false}) async {
    if (force) {
      try {
        // Picu backend Filament untuk mengambil data terbaru dari legacy terlebih dahulu
        await dio.post('/wh/master-sync-trigger');
      } catch (e) {
        // Tetap lanjutkan sync lokal meskipun trigger ke legacy gagal (menggunakan data cache backend terakhir)
      }
    }

    try {
      // 1. Coba fetch master-sync-check untuk mengetahui apakah ada perubahan
      final response = await dio.get('/wh/master-sync-check');
      if (response.data['success'] == true) {
        final serverTimestamps = response.data['data'] as Map<String, dynamic>;
        
        await _syncTableIfNeeded('companies', serverTimestamps['companies'], syncCompanies, force: force);
        await _syncTableIfNeeded('suppliers', serverTimestamps['suppliers'], syncSuppliers, force: force);
        await _syncTableIfNeeded('products', serverTimestamps['products'], syncProducts, force: force);
        return;
      }
    } catch (e) {
      // Fallback ke sync berbasis TTL lokal jika endpoint sync-check belum tersedia
    }

    // Fallback: Sync manual per tabel
    await syncCompanies(force: force);
    await syncSuppliers(force: force);
    await syncProducts(force: force);
  }

  Future<void> _syncTableIfNeeded(
    String tableName,
    String? serverTimestampStr,
    Future<void> Function({bool force}) syncFunction, {
    bool force = false,
  }) async {
    if (force || serverTimestampStr == null) {
      await syncFunction(force: true);
      return;
    }

    final localMetadata = await (db.select(db.syncMetadataTable)
          ..where((t) => t.syncTable.equals(tableName)))
        .getSingleOrNull();

    if (localMetadata == null) {
      await syncFunction(force: true);
      return;
    }

    try {
      final serverTime = DateTime.parse(serverTimestampStr);
      if (serverTime.isAfter(localMetadata.lastSyncedAt)) {
        await syncFunction(force: true);
      }
    } catch (_) {
      // Jika parsing gagal, lakukan sync saja
      await syncFunction(force: true);
    }
  }

  // Sinkronisasi Tabel Perusahaan (Companies)
  Future<void> syncCompanies({bool force = false}) async {
    if (force) {
      await _triggerBackendRemoteSync();
    }
    if (!force && !await _shouldSyncLocalTtl('companies')) return;

    try {
      final response = await dio.get('/wh/companies');
      if (response.data['success'] == true) {
        final List data = response.data['data'];
        
        await db.transaction(() async {
          await db.delete(db.companiesTable).go();
          for (var item in data) {
            await db.into(db.companiesTable).insertOnConflictUpdate(
              CompaniesTableCompanion.insert(
                id: Value(item['id']),
                companyCode: item['company_code'] ?? '',
                companyName: item['company_name'] ?? '',
                isActive: Value(item['is_active'] ?? true),
              ),
            );
          }
          await _updateSyncMetadata('companies');
        });
      }
    } catch (_) {
      // Silently catch error to allow offline cache usage
    }
  }

  // Sinkronisasi Tabel Supplier
  Future<void> syncSuppliers({bool force = false}) async {
    if (force) {
      await _triggerBackendRemoteSync();
    }
    if (!force && !await _shouldSyncLocalTtl('suppliers')) return;

    try {
      final response = await dio.get('/wh/suppliers');
      if (response.data['success'] == true) {
        final List data = response.data['data'];
        
        await db.transaction(() async {
          await db.delete(db.suppliersTable).go();
          for (var item in data) {
            await db.into(db.suppliersTable).insertOnConflictUpdate(
              SuppliersTableCompanion.insert(
                id: Value(item['id']),
                code: item['code'] ?? '',
                name: item['name'] ?? '',
                phone: Value(item['phone']),
                isActive: Value(item['is_active'] ?? true),
              ),
            );
          }
          await _updateSyncMetadata('suppliers');
        });
      }
    } catch (_) {
      // Silently catch error
    }
  }

  // Sinkronisasi Tabel Produk
  Future<void> syncProducts({bool force = false}) async {
    if (force) {
      await _triggerBackendRemoteSync();
    }
    if (!force && !await _shouldSyncLocalTtl('products')) return;

    try {
      final response = await dio.get('/wh/products');
      if (response.data['success'] == true) {
        final List data = response.data['data'];
        
        await db.transaction(() async {
          await db.delete(db.productsTable).go();
          for (var item in data) {
            await db.into(db.productsTable).insertOnConflictUpdate(
              ProductsTableCompanion.insert(
                id: Value(item['id']),
                sku: item['sku'] ?? '',
                name: item['name'] ?? '',
                unit: item['unit'] ?? '',
                category: item['category'] ?? '',
                minStock: Value(item['min_stock'] ?? 0),
                isActive: Value(item['is_active'] ?? true),
              ),
            );
          }
          await _updateSyncMetadata('products');
        });
      }
    } catch (_) {
      // Silently catch error
    }
  }

  Future<bool> _shouldSyncLocalTtl(String table) async {
    final query = await (db.select(db.syncMetadataTable)
          ..where((t) => t.syncTable.equals(table)))
        .getSingleOrNull();
    if (query == null) return true;
    
    final difference = DateTime.now().difference(query.lastSyncedAt);
    return difference.inDays >= 1; // Sync otomatis jika cache > 1 hari
  }

  Future<void> _updateSyncMetadata(String table) async {
    await db.into(db.syncMetadataTable).insertOnConflictUpdate(
      SyncMetadataTableCompanion.insert(
        syncTable: table,
        lastSyncedAt: DateTime.now(),
      ),
    );
  }

  Future<void> _triggerBackendRemoteSync() async {
    try {
      await dio.post('/wh/master-sync-trigger');
    } catch (_) {}
  }
}
