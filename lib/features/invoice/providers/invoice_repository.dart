import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/invoice.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/api/paginated_response.dart';
import '../../../core/providers/company_provider.dart';

import 'package:image_picker/image_picker.dart';

part 'invoice_repository.g.dart';

class InvoiceRepository {
  final Dio dio;

  InvoiceRepository(this.dio);

  Future<PaginatedResponse<Invoice>> getInvoices({
    int page = 1,
    String? status,
    int? companyId,
    String? startDate,
    String? endDate,
    bool history = false,
  }) async {
    final response = await dio.get('wh/invoices', queryParameters: {
      'page': page,
      if (status != null) 'status': status,
      if (companyId != null) 'company_id': companyId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (history) 'history': 1,
    });

    return PaginatedResponse.fromJson(
      response.data,
      (json) => Invoice.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Invoice> getInvoiceDetail(int id) async {
    final response = await dio.get('wh/invoices/$id');
    return Invoice.fromJson(response.data['data']);
  }

  Future<void> approveInvoice(int id) async {
    await dio.post('wh/invoices/$id/approve');
  }

  Future<void> rejectInvoice(int id, String reason) async {
    await dio.post('wh/invoices/$id/reject', data: {
      'reason': reason,
    });
  }

  Future<Invoice> verifyInvoice(int id, {String? vendorInvoiceNumber, XFile? imageFile}) async {
    final formData = FormData();
    if (vendorInvoiceNumber != null) {
      formData.fields.add(MapEntry('vendor_invoice_number', vendorInvoiceNumber));
    }
    if (imageFile != null) {
      formData.files.add(MapEntry(
        'files[]',
        await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.name,
        ),
      ));
    }

    final response = await dio.post('wh/invoices/$id', data: formData);
    return Invoice.fromJson(response.data['data']);
  }
}

@riverpod
InvoiceRepository invoiceRepository(InvoiceRepositoryRef ref) {
  return InvoiceRepository(ref.watch(dioProvider));
}

@riverpod
class Invoices extends _$Invoices {
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;

  @override
  Future<List<Invoice>> build({
    String? status,
    String? startDate,
    String? endDate,
    bool history = false,
  }) async {
    ref.watch(invoiceRepositoryProvider);
    ref.watch(selectedCompanyProvider);

    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    return _fetchPage(1);
  }

  Future<List<Invoice>> _fetchPage(int page) async {
    final repository = ref.read(invoiceRepositoryProvider);
    final selectedCompany = ref.read(selectedCompanyProvider);

    final response = await repository.getInvoices(
      page: page,
      status: status,
      companyId: selectedCompany?.id,
      startDate: startDate,
      endDate: endDate,
      history: history,
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
    state = const AsyncLoading<List<Invoice>>().copyWithPrevious(state);

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
Future<Invoice> invoiceDetail(InvoiceDetailRef ref, int id) async {
  return ref.watch(invoiceRepositoryProvider).getInvoiceDetail(id);
}
