import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/payment_transaction.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/api/paginated_response.dart';
import '../../../core/providers/company_provider.dart';

part 'payment_transaction_provider.g.dart';

class PaymentTransactionRepository {
  final Dio dio;

  PaymentTransactionRepository(this.dio);

  Future<PaginatedResponse<PaymentTransaction>> getTransactions({
    int page = 1,
    int? companyId,
    int? supplierId,
    String? search,
    bool? hasProof,
  }) async {
    final response = await dio.get('wh/payment-transactions', queryParameters: {
      'page': page,
      if (companyId != null) 'company_id': companyId,
      if (supplierId != null) 'supplier_id': supplierId,
      if (search != null) 'search': search,
      if (hasProof != null) 'has_proof': hasProof,
    });

    return PaginatedResponse.fromJson(
      response.data,
      (json) => PaymentTransaction.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<PaymentTransaction> getTransactionDetail(int id) async {
    final response = await dio.get('wh/payment-transactions/$id');
    return PaymentTransaction.fromJson(response.data['data']);
  }

  Future<String> uploadProof(int id, String filePath) async {
    final fileName = filePath.split('/').last;
    final formData = FormData.fromMap({
      'proof': await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      ),
    });

    final response = await dio.post(
      'wh/payment-transactions/$id/upload-proof',
      data: formData,
    );

    if (response.data['success'] == true) {
      return response.data['data']['receipt_url'] as String;
    } else {
      throw Exception(response.data['error'] ?? 'Failed to upload proof');
    }
  }
}

@riverpod
PaymentTransactionRepository paymentTransactionRepository(PaymentTransactionRepositoryRef ref) {
  return PaymentTransactionRepository(ref.watch(dioProvider));
}

@riverpod
class PaymentTransactionsList extends _$PaymentTransactionsList {
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;

  @override
  Future<List<PaymentTransaction>> build({
    bool? hasProof,
    String? search,
  }) async {
    ref.watch(paymentTransactionRepositoryProvider);
    ref.watch(selectedCompanyProvider);

    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    return _fetchPage(1);
  }

  Future<List<PaymentTransaction>> _fetchPage(int page) async {
    final repository = ref.read(paymentTransactionRepositoryProvider);
    final selectedCompany = ref.read(selectedCompanyProvider);

    final response = await repository.getTransactions(
      page: page,
      companyId: selectedCompany?.id,
      search: (search?.isEmpty ?? true) ? null : search,
      hasProof: hasProof,
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
    state = const AsyncLoading<List<PaymentTransaction>>().copyWithPrevious(state);

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
Future<PaymentTransaction> paymentTransactionDetails(PaymentTransactionDetailsRef ref, int id) async {
  return ref.watch(paymentTransactionRepositoryProvider).getTransactionDetail(id);
}
