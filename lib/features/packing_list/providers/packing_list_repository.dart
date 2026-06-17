import 'package:dio/dio.dart';
import '../models/packing_list.dart';
import '../../../core/api/paginated_response.dart';

class PackingListRepository {
  final Dio dio;

  PackingListRepository(this.dio);

  Future<PaginatedResponse<PackingList>> getPackingLists({
    int page = 1,
    String? search,
    String? status,
  }) async {
    final response = await dio.get('wh/containers', queryParameters: {
      'page': page,
      if (search != null && search.isNotEmpty) 'search': search,
      if (status != null && status.isNotEmpty) 'status': status,
    });

    return PaginatedResponse.fromJson(
      response.data,
      (json) => PackingList.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<PackingList> getPackingListDetail(int id) async {
    final response = await dio.get('wh/containers/$id');
    return PackingList.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<List<dynamic>> getAvailablePoItems(int id) async {
    final response = await dio.get('wh/containers/$id/available-items');
    return response.data['data'] as List<dynamic>;
  }

  Future<List<dynamic>> getAvailableInventoryItems(int id) async {
    final response = await dio.get('wh/containers/$id/available-inventories');
    return response.data['data'] as List<dynamic>;
  }

  Future<PackingList> updateManifest(int id, List<Map<String, dynamic>> items) async {
    final response = await dio.put('wh/containers/$id/manifest', data: {
      'items': items,
    });
    return PackingList.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<PackingList> createPackingList({
    required String containerNumber,
    required String carrierName,
    required String plateNumber,
    required int sourceWarehouseId,
    required int destinationWarehouseId,
    DateTime? estimatedDeparture,
    DateTime? closingDate,
  }) async {
    final response = await dio.post('wh/containers', data: {
      'container_number': containerNumber,
      'carrier_name': carrierName,
      'plate_number': plateNumber,
      'source_warehouse_id': sourceWarehouseId,
      'destination_warehouse_id': destinationWarehouseId,
      if (estimatedDeparture != null) 'estimated_departure': estimatedDeparture.toIso8601String(),
      if (closingDate != null) 'closing_date': closingDate.toIso8601String(),
    });
    return PackingList.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<PackingList> updateStatus(int id, String status) async {
    final response = await dio.put('wh/containers/$id/status', data: {
      'status': status,
    });
    return PackingList.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<PackingList> updatePackingList({
    required int id,
    required String containerNumber,
    required String carrierName,
    required String plateNumber,
    required int sourceWarehouseId,
    required int destinationWarehouseId,
    DateTime? estimatedDeparture,
    DateTime? closingDate,
  }) async {
    final response = await dio.put('wh/containers/$id', data: {
      'container_number': containerNumber,
      'carrier_name': carrierName,
      'plate_number': plateNumber,
      'source_warehouse_id': sourceWarehouseId,
      'destination_warehouse_id': destinationWarehouseId,
      'estimated_departure': estimatedDeparture?.toIso8601String(),
      'closing_date': closingDate?.toIso8601String(),
    });
    return PackingList.fromJson(response.data['data'] as Map<String, dynamic>);
  }
}
