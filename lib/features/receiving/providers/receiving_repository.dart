import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/receiving.dart';
import '../../purchase_order/models/purchase_order.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/api/paginated_response.dart';

part 'receiving_repository.g.dart';

@riverpod
ReceivingRepository receivingRepository(ReceivingRepositoryRef ref) {
  return ReceivingRepository(ref.watch(dioProvider));
}

class ReceivingRepository {
  final Dio dio;

  ReceivingRepository(this.dio);

  Future<void> createReceiving(CreateReceivingRequest request) async {
    await dio.post('wh/receivings', data: request.toJson());
  }

  Future<PaginatedResponse<ReceivingHistoryItem>> getReceivingHistory({
    int page = 1,
    int? companyId,
  }) async {
    final response = await dio.get('wh/receivings', queryParameters: {
      'page': page,
      if (companyId != null) 'company_id': companyId,
    });

    return PaginatedResponse.fromJson(
      response.data,
      (json) => ReceivingHistoryItem.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Map<String, dynamic>> getReceivingDetail(int id) async {
    final response = await dio.get('wh/receivings/$id');
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<PurchaseOrder> getPurchaseOrderDetail(int id) async {
    final response = await dio.get('wh/purchase-orders/$id');
    return PurchaseOrder.fromJson(response.data['data']);
  }

  Future<PurchaseOrder?> getPOByNumber(String poNumber) async {
    final response = await dio.get('wh/purchase-orders', queryParameters: {
      'search': poNumber,
    });
    final data = response.data['data'] as List;
    if (data.isNotEmpty) {
      final poId = data.first['id'] as int;
      return getPurchaseOrderDetail(poId);
    }
    return null;
  }

  Future<List<ReceivingContainer>> getReceivingContainers() async {
    final response = await dio.get('wh/receivings/containers');
    final data = response.data['data'] as List;
    return data.map((json) => ReceivingContainer.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<ReceivingContainerManifest> getContainerManifest(String number) async {
    final response = await dio.get('wh/receivings/containers/$number');
    return ReceivingContainerManifest.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> submitContainerReceiving(ContainerReceivingRequest request) async {
    await dio.post('wh/receivings/depo-sync', data: request.toJson());
  }

  Future<String> uploadPhoto(String filePath) async {
    final fileName = filePath.split('/').last;
    final formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      ),
    });

    final response = await dio.post(
      'wh/receivings/upload-photo',
      data: formData,
    );

    if (response.data['success'] == true) {
      return response.data['data']['path'] as String;
    } else {
      throw Exception(response.data['error'] ?? 'Failed to upload photo');
    }
  }
}

