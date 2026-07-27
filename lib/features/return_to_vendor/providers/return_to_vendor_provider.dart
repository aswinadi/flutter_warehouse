import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/return_to_vendor.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/api/paginated_response.dart';
import '../../../core/providers/company_provider.dart';

class ReturnToVendorRepository {
  final Dio dio;

  ReturnToVendorRepository(this.dio);

  Future<PaginatedResponse<ReturnToVendor>> getReturnToVendors({
    int page = 1,
    int? companyId,
    int? supplierId,
    String? status,
  }) async {
    try {
      final Map<String, dynamic> query = {'page': page};
      if (companyId != null) query['company_id'] = companyId;
      if (supplierId != null) query['supplier_id'] = supplierId;
      if (status != null && status != 'all') query['status'] = status;

      final response = await dio.get('wh/return-to-vendors', queryParameters: query);

      final responseData = response.data;
      if (responseData == null || responseData is! Map<String, dynamic>) {
        return const PaginatedResponse<ReturnToVendor>(
          success: true,
          data: [],
        );
      }

      dynamic rawData = responseData['data'];
      List<dynamic> itemsList = [];

      if (rawData is List) {
        itemsList = rawData;
      } else if (rawData is Map && rawData['data'] is List) {
        itemsList = rawData['data'] as List;
      } else if (responseData['items'] is List) {
        itemsList = responseData['items'] as List;
      }

      final items = itemsList
          .map((item) => ReturnToVendor.fromJson(item as Map<String, dynamic>))
          .toList();

      return PaginatedResponse<ReturnToVendor>(
        success: true,
        data: items,
      );
    } catch (e) {
      return const PaginatedResponse<ReturnToVendor>(
        success: false,
        data: [],
      );
    }
  }

  Future<ReturnToVendor> getDetail(int id) async {
    final response = await dio.get('wh/return-to-vendors/$id');
    return ReturnToVendor.fromJson(response.data['data']);
  }

  Future<ReturnToVendor> createRtv(Map<String, dynamic> payload) async {
    final response = await dio.post('wh/return-to-vendors', data: payload);
    return ReturnToVendor.fromJson(response.data['data']);
  }

  Future<ReturnToVendor> approveRtv(int id) async {
    final response = await dio.post('wh/return-to-vendors/$id/approve');
    return ReturnToVendor.fromJson(response.data['data']);
  }

  Future<ReturnToVendor> shipRtv(int id) async {
    final response = await dio.post('wh/return-to-vendors/$id/ship');
    return ReturnToVendor.fromJson(response.data['data']);
  }
}

final returnToVendorRepositoryProvider = Provider<ReturnToVendorRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ReturnToVendorRepository(dio);
});

final returnToVendorListProvider = FutureProvider.family<PaginatedResponse<ReturnToVendor>, String>((ref, status) async {
  final repo = ref.watch(returnToVendorRepositoryProvider);
  final selectedCompany = ref.watch(selectedCompanyProvider);

  return repo.getReturnToVendors(
    page: 1,
    companyId: selectedCompany?.id,
    status: status,
  );
});

final returnToVendorDetailProvider = FutureProvider.family<ReturnToVendor, int>((ref, id) async {
  final repo = ref.watch(returnToVendorRepositoryProvider);
  return repo.getDetail(id);
});
