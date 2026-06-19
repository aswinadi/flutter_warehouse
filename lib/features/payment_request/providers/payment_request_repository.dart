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
    int? perPage,
  }) async {
    final response = await dio.get('wh/payment-requests', queryParameters: {
      'page': page,
      'status': ?status,
      'company_id': ?companyId,
      'per_page': ?perPage,
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
      'notes': ?notes,
    });
  }

  Future<void> rejectPaymentRequest(int id, String reason, {String? notes}) async {
    await dio.post('wh/payment-requests/$id/reject', data: {
      'reason': reason,
      'notes': ?notes,
    });
  }

  Future<List<AvailableInvoice>> getAvailableInvoices({required int companyId}) async {
    final futures = await Future.wait([
      dio.get('wh/invoices', queryParameters: {
        'unpaid_only': true,
        'company_id': companyId,
        'per_page': 200,
      }),
      dio.get('wh/invoice-biaya', queryParameters: {
        'unpaid_only': true,
        'company_id': companyId,
        'per_page': 200,
      }),
      dio.get('wh/landed-costs', queryParameters: {
        'unpaid_only': true,
        'company_id': companyId,
        'per_page': 200,
      }),
    ]);

    final List<dynamic> supplierList = futures[0].data['data'] ?? [];
    final List<dynamic> biayaList = futures[1].data['data'] ?? [];
    final List<dynamic> landedList = futures[2].data['data'] ?? [];

    final list = <AvailableInvoice>[];
    for (final item in supplierList) {
      list.add(AvailableInvoice.fromSupplierInvoice(item as Map<String, dynamic>));
    }
    for (final item in biayaList) {
      list.add(AvailableInvoice.fromBiayaInvoice(item as Map<String, dynamic>));
    }
    for (final item in landedList) {
      list.add(AvailableInvoice.fromLandedCost(item as Map<String, dynamic>));
    }

    // Sort by due date (closest/overdue first)
    list.sort((a, b) {
      final aDate = a.dueDate ?? a.invoiceDate;
      final bDate = b.dueDate ?? b.invoiceDate;
      return aDate.compareTo(bDate);
    });

    return list;
  }

  Future<void> createPaymentRequest({
    required List<Map<String, dynamic>> invoices,
    required String requestDate,
    String? description,
  }) async {
    await dio.post('wh/payment-requests', data: {
      'invoices': invoices,
      'request_date': requestDate,
      'description': ?description,
    });
  }

  Future<void> payPaymentRequest(
    int id, {
    required List<Map<String, dynamic>> invoices,
    String? bankName,
    String? bankAccount,
    String? transferReference,
    String? notes,
  }) async {
    await dio.post('wh/payment-requests/$id/pay', data: {
      'invoices': invoices,
      'bank_name': ?bankName,
      'bank_account': ?bankAccount,
      'transfer_reference': ?transferReference,
      'notes': ?notes,
    });
  }

  Future<Map<String, dynamic>> getInvoiceDetailRaw(int id, String type) async {
    final endpoint = type == 'supplier'
        ? 'wh/invoices/$id'
        : type == 'biaya'
            ? 'wh/invoice-biaya/$id'
            : 'wh/landed-costs/$id';
    final response = await dio.get(endpoint);
    return response.data['data'] as Map<String, dynamic>;
  }
}

@riverpod
PaymentRequestRepository paymentRequestRepository(PaymentRequestRepositoryRef ref) {
  return PaymentRequestRepository(ref.watch(dioProvider));
}

@riverpod
Future<List<AvailableInvoice>> availableInvoices(AvailableInvoicesRef ref, {required int companyId}) async {
  return ref.watch(paymentRequestRepositoryProvider).getAvailableInvoices(companyId: companyId);
}

@riverpod
Future<Map<String, dynamic>> invoiceDetailPreview(InvoiceDetailPreviewRef ref, {required int id, required String type}) async {
  return ref.watch(paymentRequestRepositoryProvider).getInvoiceDetailRaw(id, type);
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
