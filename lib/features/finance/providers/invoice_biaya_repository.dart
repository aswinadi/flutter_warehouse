import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/invoice_biaya.dart';
import '../models/invoice_biaya_detail.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/api/paginated_response.dart';
import '../../../core/providers/company_provider.dart';

part 'invoice_biaya_repository.g.dart';

class InvoiceBiayaRepository {
  final Dio dio;

  InvoiceBiayaRepository(this.dio);

  Future<PaginatedResponse<InvoiceBiaya>> getInvoiceBiayas({
    int page = 1,
    String? status,
    int? companyId,
    String? startDate,
    String? endDate,
    bool? unpaidOnly,
  }) async {
    final response = await dio.get('wh/invoice-biaya', queryParameters: {
      'page': page,
      if (status != null) 'status': status,
      if (companyId != null) 'company_id': companyId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (unpaidOnly != null) 'unpaid_only': unpaidOnly,
    });

    return PaginatedResponse.fromJson(
      response.data,
      (json) => InvoiceBiaya.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<InvoiceBiaya> getInvoiceBiayaDetail(int id) async {
    final response = await dio.get('wh/invoice-biaya/$id');
    return InvoiceBiaya.fromJson(response.data['data']);
  }

  Future<InvoiceBiaya> createInvoiceBiaya({
    required int companyId,
    required int supplierId,
    required String vendorInvoiceNumber,
    required String invoiceDate,
    String? dueDate,
    required double amount,
    double? taxAmount,
    String? notes,
    String? taxInvoiceNumber,
    String? taxInvoiceDate,
    String? costCenterCode,
    String? jvType,
    List<InvoiceBiayaDetail>? details,
    List<XFile>? files,
  }) async {
    final formData = FormData.fromMap({
      'company_id': companyId,
      'supplier_id': supplierId,
      'vendor_invoice_number': vendorInvoiceNumber,
      'invoice_date': invoiceDate,
      if (dueDate != null) 'due_date': dueDate,
      'amount': amount,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (notes != null) 'notes': notes,
      if (taxInvoiceNumber != null) 'tax_invoice_number': taxInvoiceNumber,
      if (taxInvoiceDate != null) 'tax_invoice_date': taxInvoiceDate,
      if (costCenterCode != null) 'cost_center_code': costCenterCode,
      if (jvType != null) 'jv_type': jvType,
    });

    if (details != null && details.isNotEmpty) {
      for (int i = 0; i < details.length; i++) {
        final row = details[i];
        formData.fields.add(MapEntry('details[$i][coa_code]', row.coaCode));
        formData.fields.add(MapEntry('details[$i][coa_name]', row.coaName ?? ''));
        if (row.projectCode != null) {
          formData.fields.add(MapEntry('details[$i][project_code]', row.projectCode!));
        }
        if (row.costCode != null) {
          formData.fields.add(MapEntry('details[$i][cost_code]', row.costCode!));
        }
        formData.fields.add(MapEntry('details[$i][debit]', row.debit.toString()));
        formData.fields.add(MapEntry('details[$i][credit]', row.credit.toString()));
        if (row.staffName != null) {
          formData.fields.add(MapEntry('details[$i][staff_name]', row.staffName!));
        }
        if (row.notes != null) {
          formData.fields.add(MapEntry('details[$i][notes]', row.notes!));
        }
      }
    }

    if (files != null && files.isNotEmpty) {
      for (final file in files) {
        formData.files.add(MapEntry(
          'files[]',
          await MultipartFile.fromFile(
            file.path,
            filename: file.name,
          ),
        ));
      }
    }

    final response = await dio.post('wh/invoice-biaya', data: formData);
    return InvoiceBiaya.fromJson(response.data['data']);
  }

  Future<InvoiceBiaya> updateInvoiceBiaya(
    int id, {
    String? vendorInvoiceNumber,
    String? invoiceDate,
    String? dueDate,
    double? amount,
    double? taxAmount,
    String? notes,
    String? taxInvoiceNumber,
    String? taxInvoiceDate,
    String? costCenterCode,
    String? jvType,
    List<InvoiceBiayaDetail>? details,
    List<XFile>? files,
  }) async {
    final formData = FormData.fromMap({
      if (vendorInvoiceNumber != null) 'vendor_invoice_number': vendorInvoiceNumber,
      if (invoiceDate != null) 'invoice_date': invoiceDate,
      if (dueDate != null) 'due_date': dueDate,
      if (amount != null) 'amount': amount,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (notes != null) 'notes': notes,
      if (taxInvoiceNumber != null) 'tax_invoice_number': taxInvoiceNumber,
      if (taxInvoiceDate != null) 'tax_invoice_date': taxInvoiceDate,
      if (costCenterCode != null) 'cost_center_code': costCenterCode,
      if (jvType != null) 'jv_type': jvType,
    });

    if (details != null && details.isNotEmpty) {
      for (int i = 0; i < details.length; i++) {
        final row = details[i];
        formData.fields.add(MapEntry('details[$i][coa_code]', row.coaCode));
        formData.fields.add(MapEntry('details[$i][coa_name]', row.coaName ?? ''));
        if (row.projectCode != null) {
          formData.fields.add(MapEntry('details[$i][project_code]', row.projectCode!));
        }
        if (row.costCode != null) {
          formData.fields.add(MapEntry('details[$i][cost_code]', row.costCode!));
        }
        formData.fields.add(MapEntry('details[$i][debit]', row.debit.toString()));
        formData.fields.add(MapEntry('details[$i][credit]', row.credit.toString()));
        if (row.staffName != null) {
          formData.fields.add(MapEntry('details[$i][staff_name]', row.staffName!));
        }
        if (row.notes != null) {
          formData.fields.add(MapEntry('details[$i][notes]', row.notes!));
        }
      }
    }

    if (files != null && files.isNotEmpty) {
      for (final file in files) {
        formData.files.add(MapEntry(
          'files[]',
          await MultipartFile.fromFile(
            file.path,
            filename: file.name,
          ),
        ));
      }
    }

    final response = await dio.post('wh/invoice-biaya/$id', data: formData);
    return InvoiceBiaya.fromJson(response.data['data']);
  }

  Future<void> deleteInvoiceBiaya(int id) async {
    await dio.delete('wh/invoice-biaya/$id');
  }

  Future<InvoiceBiaya> markPending(int id) async {
    final response = await dio.post('wh/invoice-biaya/$id/mark-pending');
    return InvoiceBiaya.fromJson(response.data['data']);
  }
}

@riverpod
InvoiceBiayaRepository invoiceBiayaRepository(InvoiceBiayaRepositoryRef ref) {
  return InvoiceBiayaRepository(ref.watch(dioProvider));
}

@riverpod
class InvoiceBiayas extends _$InvoiceBiayas {
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;

  @override
  Future<List<InvoiceBiaya>> build({
    String? status,
    String? startDate,
    String? endDate,
    bool? unpaidOnly,
  }) async {
    ref.watch(invoiceBiayaRepositoryProvider);
    ref.watch(selectedCompanyProvider);

    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    return _fetchPage(1);
  }

  Future<List<InvoiceBiaya>> _fetchPage(int page) async {
    final repository = ref.read(invoiceBiayaRepositoryProvider);
    final selectedCompany = ref.read(selectedCompanyProvider);

    final response = await repository.getInvoiceBiayas(
      page: page,
      status: status,
      companyId: selectedCompany?.id,
      startDate: startDate,
      endDate: endDate,
      unpaidOnly: unpaidOnly,
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
    state = const AsyncLoading<List<InvoiceBiaya>>().copyWithPrevious(state);

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
Future<InvoiceBiaya> invoiceBiayaDetail(InvoiceBiayaDetailRef ref, int id) async {
  return ref.watch(invoiceBiayaRepositoryProvider).getInvoiceBiayaDetail(id);
}
