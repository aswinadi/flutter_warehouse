import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'inventory_provider.dart';
import '../models/inventory_breakdown.dart';

part 'inventory_breakdown_provider.g.dart';

@riverpod
Future<InventoryBreakdown> inventoryBreakdown(
  InventoryBreakdownRef ref,
  String barcodeCode,
) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  return repository.getInventoryBreakdown(barcodeCode);
}

@riverpod
Future<InventoryBreakdown> inventoryBreakdownBySku(
  InventoryBreakdownBySkuRef ref,
  String sku,
) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  return repository.getInventoryBreakdownBySku(sku);
}
