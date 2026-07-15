import 'package:drift/drift.dart';
import 'connection/connection.dart';

part 'master_database.g.dart';

// Tabel Perusahaan
class CompaniesTable extends Table {
  IntColumn get id => integer()();
  TextColumn get companyCode => text()();
  TextColumn get companyName => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  
  @override
  Set<Column> get primaryKey => {id};
}

// Tabel Supplier
class SuppliersTable extends Table {
  IntColumn get id => integer()();
  TextColumn get code => text()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

// Tabel Produk
class ProductsTable extends Table {
  IntColumn get id => integer()();
  TextColumn get sku => text()();
  TextColumn get name => text()();
  TextColumn get unit => text()();
  TextColumn get category => text()();
  IntColumn get minStock => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

// Tabel Metadata Sinkronisasi
class SyncMetadataTable extends Table {
  TextColumn get syncTable => text()();
  DateTimeColumn get lastSyncedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {syncTable};
}

@DriftDatabase(tables: [CompaniesTable, SuppliersTable, ProductsTable, SyncMetadataTable])
class MasterDatabase extends _$MasterDatabase {
  MasterDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;
}
