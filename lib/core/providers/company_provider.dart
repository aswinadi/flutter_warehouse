import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/company.dart';
import '../api/dio_client.dart';
import '../api/paginated_response.dart';

part 'company_provider.g.dart';

@riverpod
class Companies extends _$Companies {
  @override
  Future<List<Company>> build() async {
    final dio = ref.watch(dioProvider);
    final response = await dio.get('wh/companies');
    
    // Assuming the companies endpoint returns a paginated response or standard data wrapper
    if (response.data['data'] is List) {
      return (response.data['data'] as List)
          .map((json) => Company.fromJson(json))
          .toList();
    }
    return [];
  }
}

@riverpod
class SelectedCompany extends _$SelectedCompany {
  @override
  Company? build() {
    return null; // null means 'All Companies'
  }

  void selectCompany(Company? company) {
    state = company;
  }
}
