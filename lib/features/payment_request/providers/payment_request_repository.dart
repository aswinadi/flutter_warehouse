import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/payment_request.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/api/paginated_response.dart';
import '../../../core/providers/company_provider.dart';

part 'payment_request_repository.g.dart';

class PaymentRequestRepository {
  final Dio dio;

  PaymentRequestRepository(this.dio);

  Future<PaginatedResponse<PaymentRequest>> getPaymentRequests({
    int page = 1,
    String? status,
    int? companyId,
  }) async {
    final response = await dio.get('wh/payment-requests', queryParameters: {
      'page': page,
      if (status != null) 'status': status,
      if (companyId != null) 'company_id': companyId,
    });

    return PaginatedResponse.fromJson(
      response.data,
      (json) => PaymentRequest.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<PaymentRequest> getPaymentRequestDetail(int id) async {
    final response = await dio.get('wh/payment-requests/$id');
    return PaymentRequest.fromJson(response.data['data']);
  }

  Future<void> approvePaymentRequest(int id, {String? notes}) async {
    await dio.post('wh/payment-requests/$id/approve', data: {
      if (notes != null) 'notes': notes,
    });
  }

  Future<void> rejectPaymentRequest(int id, String reason, {String? notes}) async {
    await dio.post('wh/payment-requests/$id/reject', data: {
      'reason': reason,
      if (notes != null) 'notes': notes,
    });
  }
}

@riverpod
PaymentRequestRepository paymentRequestRepository(PaymentRequestRepositoryRef ref) {
  return PaymentRequestRepository(ref.watch(dioProvider));
}

@riverpod
class PaymentRequests extends _$PaymentRequests {
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;

  @override
  Future<List<PaymentRequest>> build({String? status}) async {
    ref.watch(paymentRequestRepositoryProvider);
    ref.watch(selectedCompanyProvider);

    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    return _fetchPage(1);
  }

  Future<List<PaymentRequest>> _fetchPage(int page) async {
    final repository = ref.read(paymentRequestRepositoryProvider);
    final selectedCompany = ref.read(selectedCompanyProvider);

    final response = await repository.getPaymentRequests(
      page: page,
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
    state = const AsyncLoading<List<PaymentRequest>>().copyWithPrevious(state);

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
Future<PaymentRequest> paymentRequestDetail(PaymentRequestDetailRef ref, int id) async {
  return ref.watch(paymentRequestRepositoryProvider).getPaymentRequestDetail(id);
}
