import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/supplier_debt_history.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/api/paginated_response.dart';
import '../../../core/providers/company_provider.dart';

class SupplierDebtRepository {
  final Dio dio;

  SupplierDebtRepository(this.dio);

  Future<PaginatedResponse<SupplierDebtHistory>> getDebtHistory({
    int page = 1,
    int? companyId,
    int? supplierId,
    String? ledgerCategory, // 'ap' vs 'ar'
    String? type,
  }) async {
    try {
      final Map<String, dynamic> query = {'page': page};
      if (companyId != null) query['company_id'] = companyId;
      if (supplierId != null) query['supplier_id'] = supplierId;
      if (ledgerCategory != null) query['ledger_category'] = ledgerCategory;
      if (type != null) query['type'] = type;

      final response = await dio.get('wh/supplier-debt-histories', queryParameters: query);

      final responseData = response.data;
      if (responseData == null || responseData is! Map<String, dynamic>) {
        return const PaginatedResponse<SupplierDebtHistory>(
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
          .map((item) => SupplierDebtHistory.fromJson(item as Map<String, dynamic>))
          .toList();

      return PaginatedResponse<SupplierDebtHistory>(
        success: true,
        data: items,
      );
    } catch (e) {
      return const PaginatedResponse<SupplierDebtHistory>(
        success: false,
        data: [],
      );
    }
  }

  Future<SupplierLedgerSummary> getSupplierSummary(int supplierId, {int? companyId}) async {
    final Map<String, dynamic> query = {};
    if (companyId != null) query['company_id'] = companyId;

    final response = await dio.get('wh/suppliers/$supplierId/ledger-summary', queryParameters: query);

    final data = response.data['data'] ?? response.data;
    return SupplierLedgerSummary.fromJson(data);
  }
}

final supplierDebtRepositoryProvider = Provider<SupplierDebtRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return SupplierDebtRepository(dio);
});

final supplierDebtHistoryProvider = FutureProvider.family<PaginatedResponse<SupplierDebtHistory>, Map<String, dynamic>>((ref, params) async {
  final repo = ref.watch(supplierDebtRepositoryProvider);
  final selectedCompany = ref.watch(selectedCompanyProvider);

  return repo.getDebtHistory(
    page: params['page'] ?? 1,
    companyId: params['company_id'] ?? selectedCompany?.id,
    supplierId: params['supplier_id'],
    ledgerCategory: params['ledger_category'],
    type: params['type'],
  );
});
