import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/warehouse.dart';
import '../api/dio_client.dart';

part 'warehouse_provider.g.dart';

@riverpod
class Warehouses extends _$Warehouses {
  @override
  Future<List<Warehouse>> build() async {
    final dio = ref.watch(dioProvider);
    final response = await dio.get('wh/warehouses');
    
    if (response.data['data'] is List) {
      return (response.data['data'] as List)
          .map((json) => Warehouse.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
