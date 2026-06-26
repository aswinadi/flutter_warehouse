import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/chart_of_account.dart';
import '../../../core/api/dio_client.dart';

part 'chart_of_account_repository.g.dart';

class ChartOfAccountRepository {
  final Dio dio;

  ChartOfAccountRepository(this.dio);

  Future<List<ChartOfAccount>> getChartOfAccounts({required int companyId}) async {
    final response = await dio.get('wh/coa', queryParameters: {
      'company_id': companyId,
    });

    final List<dynamic> data = response.data['data'] ?? [];
    return data.map((json) => ChartOfAccount.fromJson(json as Map<String, dynamic>)).toList();
  }
}

@riverpod
ChartOfAccountRepository chartOfAccountRepository(ChartOfAccountRepositoryRef ref) {
  return ChartOfAccountRepository(ref.watch(dioProvider));
}

@riverpod
Future<List<ChartOfAccount>> chartOfAccounts(ChartOfAccountsRef ref, {required int companyId}) async {
  return ref.watch(chartOfAccountRepositoryProvider).getChartOfAccounts(companyId: companyId);
}
