import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/dio_client.dart';
import '../models/product_category_model.dart';

class ProductCategoryRepository {
  final Dio dio;

  ProductCategoryRepository(this.dio);

  Future<List<ProductCategoryModel>> getCategories({int? companyId, String? search}) async {
    final queryParams = <String, dynamic>{};
    if (companyId != null) queryParams['company_id'] = companyId;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    final response = await dio.get('wh/product-categories', queryParameters: queryParams);
    
    if (response.data != null && response.data['data'] != null) {
      final List list = response.data['data'];
      return list.map((e) => ProductCategoryModel.fromJson(e)).toList();
    }
    
    return [];
  }

  Future<ProductCategoryModel> createCategory(Map<String, dynamic> data) async {
    final response = await dio.post('wh/product-categories', data: data);
    return ProductCategoryModel.fromJson(response.data['data']);
  }

  Future<ProductCategoryModel> updateCategory(int id, Map<String, dynamic> data) async {
    final response = await dio.put('wh/product-categories/$id', data: data);
    return ProductCategoryModel.fromJson(response.data['data']);
  }

  Future<void> deleteCategory(int id) async {
    await dio.delete('wh/product-categories/$id');
  }

  Future<List<Map<String, dynamic>>> getCoaAccounts({int? companyId}) async {
    final response = await dio.get('wh/coa', queryParameters: companyId != null ? {'company_id': companyId} : null);
    if (response.data != null && response.data['data'] != null) {
      return List<Map<String, dynamic>>.from(response.data['data']);
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getTaxRates({int? companyId}) async {
    final response = await dio.get('wh/tax-rates', queryParameters: companyId != null ? {'company_id': companyId} : null);
    if (response.data != null && response.data['data'] != null) {
      return List<Map<String, dynamic>>.from(response.data['data']);
    }
    return [];
  }
}

final productCategoryRepositoryProvider = Provider<ProductCategoryRepository>((ref) {
  return ProductCategoryRepository(ref.watch(dioProvider));
});

final productCategoriesStreamProvider = FutureProvider.family<List<ProductCategoryModel>, int?>((ref, companyId) async {
  final repo = ref.watch(productCategoryRepositoryProvider);
  return repo.getCategories(companyId: companyId);
});
