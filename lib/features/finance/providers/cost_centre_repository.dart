import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/cost_centre.dart';
import '../models/cost_code.dart';
import '../../../core/api/dio_client.dart';

part 'cost_centre_repository.g.dart';

class CostCentreRepository {
  final Dio dio;

  CostCentreRepository(this.dio);

  Future<List<CostCentre>> getCostCentres({required int companyId}) async {
    final response = await dio.get('wh/item-usages/cost-centres', queryParameters: {
      'company_id': companyId,
    });

    final List<dynamic> data = response.data['data'] ?? [];
    return data.map((json) => CostCentre.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<List<CostCode>> getCostCodes({required int companyId}) async {
    final response = await dio.get('wh/cost-codes', queryParameters: {
      'company_id': companyId,
    });

    final List<dynamic> data = response.data['data'] ?? [];
    return data.map((json) => CostCode.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<List<dynamic>> getProratedPreview({required String parentCode, required double qty}) async {
    final response = await dio.get('wh/item-usages/cost-centres/$parentCode/children', queryParameters: {
      'qty': qty,
    });
    return response.data['data'] ?? [];
  }
}

@riverpod
CostCentreRepository costCentreRepository(CostCentreRepositoryRef ref) {
  return CostCentreRepository(ref.watch(dioProvider));
}

@riverpod
Future<List<CostCentre>> costCentres(CostCentresRef ref, {required int companyId}) async {
  return ref.watch(costCentreRepositoryProvider).getCostCentres(companyId: companyId);
}

@riverpod
Future<List<CostCode>> costCodes(CostCodesRef ref, {required int companyId}) async {
  return ref.watch(costCentreRepositoryProvider).getCostCodes(companyId: companyId);
}

@riverpod
Future<List<dynamic>> proratedPreview(ProratedPreviewRef ref, {required String parentCode, required double qty}) async {
  return ref.watch(costCentreRepositoryProvider).getProratedPreview(parentCode: parentCode, qty: qty);
}
