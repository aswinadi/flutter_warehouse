import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/providers/company_provider.dart';
import '../models/item_usage.dart';

class ItemUsageRepository {
  final Dio dio;

  ItemUsageRepository(this.dio);

  /// Fetch active ponds from active cycles, each resolved to their
  /// cost_centre_code.  Uses the dedicated endpoint that bypasses
  /// global CompanyScope issues on the backend.
  Future<List<ActivePond>> getActivePonds({int? companyId}) async {
    final params = <String, dynamic>{};
    if (companyId != null) params['company_id'] = companyId;

    final response = await dio.get(
      'wh/item-usages/active-ponds',
      queryParameters: params.isNotEmpty ? params : null,
    );
    final data = response.data['data'] as List;
    return data
        .map((e) => ActivePond.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch child cost centres with proportional qty preview for a parent CC.
  Future<List<CostCentreChild>> getChildren(
      String parentCode, double totalQty) async {
    final response = await dio.get(
      'wh/item-usages/cost-centres/$parentCode/children',
      queryParameters: {'qty': totalQty},
    );
    final data = response.data['data'] as List;
    return data
        .map((e) => CostCentreChild.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch warehouses for the given company.
  Future<List<WarehouseOption>> getWarehouses({int? companyId}) async {
    final params = <String, dynamic>{};
    if (companyId != null) params['company_id'] = companyId;

    final response = await dio.get(
      'wh/warehouses',
      queryParameters: params.isNotEmpty ? params : null,
    );
    final data = response.data['data'] as List;
    return data
        .map((e) => WarehouseOption.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Submit a multi-item usage transaction with per-line pond/cost_centre.
  Future<void> submitUsage({
    required List<UsageLine> items,
    required int warehouseId,
    required String usageDate,
    String? notes,
    XFile? photo,
  }) async {
    final formData = FormData();

    formData.fields.addAll([
      MapEntry('warehouse_id', warehouseId.toString()),
      MapEntry('usage_date', usageDate),
      if (notes != null && notes.isNotEmpty) MapEntry('notes', notes),
    ]);

    for (int i = 0; i < items.length; i++) {
      formData.fields.addAll([
        MapEntry('items[$i][inventory_id]', items[i].inventoryId.toString()),
        MapEntry('items[$i][quantity]', items[i].usageQty.toString()),
        MapEntry(
            'items[$i][cost_centre_code]', items[i].pond?.costCentreCode ?? ''),
      ]);
    }

    if (photo != null) {
      formData.files.add(MapEntry(
        'photo',
        await MultipartFile.fromFile(photo.path, filename: photo.name),
      ));
    }

    await dio.post(
      'wh/item-usages',
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
  }
}

final itemUsageRepositoryProvider = Provider<ItemUsageRepository>((ref) {
  return ItemUsageRepository(ref.watch(dioProvider));
});

/// Active ponds from active cycles for the selected company.
/// Returns [] if no company is selected yet.
final activePondsProvider =
    FutureProvider.autoDispose<List<ActivePond>>((ref) async {
  final company = ref.watch(selectedCompanyProvider);
  if (company == null) return [];
  final repo = ref.watch(itemUsageRepositoryProvider);
  return repo.getActivePonds(companyId: company.id);
});

/// Warehouses for the selected company.
/// Returns [] if no company is selected yet.
final warehousesProvider =
    FutureProvider.autoDispose<List<WarehouseOption>>((ref) async {
  final company = ref.watch(selectedCompanyProvider);
  if (company == null) return [];
  final repo = ref.watch(itemUsageRepositoryProvider);
  return repo.getWarehouses(companyId: company.id);
});
