import 'package:drift/drift.dart';
import 'package:drift/web.dart';

QueryExecutor openConnection() {
  return LazyDatabase(() async {
    return WebDatabase('master_data', logStatements: false);
  });
}
