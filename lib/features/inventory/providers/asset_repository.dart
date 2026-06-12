import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/asset.dart';
import '../../purchase_request/models/supplier.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/api/paginated_response.dart';
import '../../../core/providers/company_provider.dart';

part 'asset_repository.g.dart';

class AssetRepository {
  final Dio dio;

  AssetRepository(this.dio);

  Future<PaginatedResponse<Asset>> getAssets({
    int page = 1,
    String? status,
    String? category,
    String? search,
    int? companyId,
  }) async {
    final response = await dio.get('wh/assets', queryParameters: {
      'page': page,
      if (status != null && status != 'all') 'status': status,
      if (category != null && category != 'all') 'category': category,
      if (search != null && search.isNotEmpty) 'search': search,
      if (companyId != null) 'company_id': companyId,
    });

    return PaginatedResponse.fromJson(
      response.data,
      (json) => Asset.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Asset> getAssetDetail(int id) async {
    final response = await dio.get('wh/assets/$id');
    return Asset.fromJson(response.data['data']);
  }

  Future<Asset> getAssetByTag(String tag) async {
    final response = await dio.get('wh/assets/tag/$tag');
    return Asset.fromJson(response.data['data']);
  }

  Future<Asset> createAsset(Map<String, dynamic> data, {XFile? photoFile}) async {
    final formData = FormData();
    
    // Add text fields
    data.forEach((key, value) {
      if (value != null) {
        formData.fields.add(MapEntry(key, value.toString()));
      }
    });

    // Add photo if provided
    if (photoFile != null) {
      formData.files.add(MapEntry(
        'files[]',
        await MultipartFile.fromFile(photoFile.path, filename: photoFile.name),
      ));
    }

    final response = await dio.post(
      'wh/assets',
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
    return Asset.fromJson(response.data['data']);
  }

  Future<Asset> updateAsset(int id, Map<String, dynamic> data, {XFile? photoFile}) async {
    final formData = FormData();
    
    // Add text fields
    data.forEach((key, value) {
      if (value != null) {
        formData.fields.add(MapEntry(key, value.toString()));
      }
    });

    // Add photo if provided
    if (photoFile != null) {
      formData.files.add(MapEntry(
        'files[]',
        await MultipartFile.fromFile(photoFile.path, filename: photoFile.name),
      ));
    }

    final response = await dio.post(
      'wh/assets/$id',
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
    return Asset.fromJson(response.data['data']);
  }

  Future<List<AssetOffice>> getOffices({int? companyId}) async {
    final response = await dio.get('wh/offices', queryParameters: {
      if (companyId != null) 'company_id': companyId,
    });
    final List<dynamic> list = response.data['data'];
    return list.map((json) => AssetOffice.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<List<AssetEmployee>> getEmployees({int? companyId}) async {
    final response = await dio.get('wh/employees', queryParameters: {
      if (companyId != null) 'company_id': companyId,
    });
    final List<dynamic> list = response.data['data'];
    return list.map((json) => AssetEmployee.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<List<Supplier>> getSuppliers({int? companyId}) async {
    final response = await dio.get('wh/suppliers', queryParameters: {
      if (companyId != null) 'company_id': companyId,
    });
    final List<dynamic> list = response.data['data'];
    return list.map((json) => Supplier.fromJson(json as Map<String, dynamic>)).toList();
  }
}

@riverpod
AssetRepository assetRepository(AssetRepositoryRef ref) {
  return AssetRepository(ref.watch(dioProvider));
}

@riverpod
class AssetList extends _$AssetList {
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;

  @override
  Future<List<Asset>> build({String? search, String? category, String? status}) async {
    ref.watch(assetRepositoryProvider);
    ref.watch(selectedCompanyProvider);

    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    return _fetchPage(1);
  }

  Future<List<Asset>> _fetchPage(int page) async {
    final repository = ref.read(assetRepositoryProvider);
    final selectedCompany = ref.read(selectedCompanyProvider);
    final response = await repository.getAssets(
      page: page,
      search: search,
      category: category,
      status: status,
      companyId: selectedCompany?.id,
    );

    if (response.meta != null) {
      _hasMore = response.meta!.currentPage < response.meta!.lastPage;
    } else {
      _hasMore = response.data.isNotEmpty;
    }

    return response.data;
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;

    final currentList = state.value ?? [];
    state = const AsyncLoading<List<Asset>>().copyWithPrevious(state);

    try {
      final nextPage = _currentPage + 1;
      final response = await _fetchPage(nextPage);

      _currentPage = nextPage;
      state = AsyncValue.data([...currentList, ...response]);
    } catch (err, stack) {
      state = AsyncValue.error(err, stack);
    } finally {
      _isLoadingMore = false;
    }
  }
}

@riverpod
Future<Asset> assetDetail(AssetDetailRef ref, int id) async {
  return ref.watch(assetRepositoryProvider).getAssetDetail(id);
}

@riverpod
Future<List<AssetOffice>> assetOffices(AssetOfficesRef ref, {int? companyId}) async {
  return ref.watch(assetRepositoryProvider).getOffices(companyId: companyId);
}

@riverpod
Future<List<AssetEmployee>> assetEmployees(AssetEmployeesRef ref, {int? companyId}) async {
  return ref.watch(assetRepositoryProvider).getEmployees(companyId: companyId);
}

@riverpod
Future<List<Supplier>> assetSuppliers(AssetSuppliersRef ref, {int? companyId}) async {
  return ref.watch(assetRepositoryProvider).getSuppliers(companyId: companyId);
}
