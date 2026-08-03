import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/dio_client.dart';
import '../models/accounting_period.dart';
import '../models/journal_master.dart';
import '../models/petty_cash.dart';

final accountingApiServiceProvider = Provider<AccountingApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return AccountingApiService(dio);
});

class AccountingApiService {
  final Dio _dio;

  AccountingApiService(this._dio);

  // ── Accounting Periods ──────────────────────────────────────────────────

  Future<List<AccountingPeriod>> getPeriods(int companyId, {int? year}) async {
    final response = await _dio.get('/v1/wh/accounting/periods', queryParameters: {
      'company_id': companyId,
      if (year != null) 'year': year,
    });
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => AccountingPeriod.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<AccountingPeriod> openPeriod(int companyId, int year, int month) async {
    final response = await _dio.post('/v1/wh/accounting/periods/open', data: {
      'company_id': companyId,
      'year': year,
      'month': month,
    });
    return AccountingPeriod.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<AccountingPeriod> closePeriod(int periodId) async {
    final response = await _dio.post('/v1/wh/accounting/periods/$periodId/close');
    return AccountingPeriod.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // ── Journals ─────────────────────────────────────────────────────────────

  Future<List<JournalMaster>> getJournals(int companyId, {String? journalType, int? year, int? month}) async {
    final response = await _dio.get('/v1/wh/accounting/journals', queryParameters: {
      'company_id': companyId,
      if (journalType != null) 'journal_type': journalType,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
    });
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => JournalMaster.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<JournalMaster> createJournal(Map<String, dynamic> payload) async {
    final response = await _dio.post('/v1/wh/accounting/journals', data: payload);
    return JournalMaster.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // ── Financial Reports ────────────────────────────────────────────────────

  Future<Map<String, dynamic>> getTrialBalance(int companyId, int year, int month) async {
    final response = await _dio.get('/v1/wh/accounting/trial-balance', queryParameters: {
      'company_id': companyId,
      'year': year,
      'month': month,
    });
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getIncomeStatement(int companyId, int year, int month) async {
    final response = await _dio.get('/v1/wh/accounting/income-statement', queryParameters: {
      'company_id': companyId,
      'year': year,
      'month': month,
    });
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getBalanceSheet(int companyId, int year, int month) async {
    final response = await _dio.get('/v1/wh/accounting/balance-sheet', queryParameters: {
      'company_id': companyId,
      'year': year,
      'month': month,
    });
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getApAging(int companyId, {String? asOf}) async {
    final response = await _dio.get('/v1/wh/accounting/ap-aging', queryParameters: {
      'company_id': companyId,
      if (asOf != null) 'as_of': asOf,
    });
    return response.data['data'] as Map<String, dynamic>;
  }

  // ── Petty Cash ───────────────────────────────────────────────────────────

  Future<List<PettyCashTransaction>> getPettyCash(int companyId, {String? status}) async {
    final response = await _dio.get('/v1/wh/accounting/petty-cash', queryParameters: {
      'company_id': companyId,
      if (status != null) 'status': status,
    });
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => PettyCashTransaction.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<PettyCashTransaction> approvePettyCash(int id) async {
    final response = await _dio.put('/v1/wh/accounting/petty-cash/$id/approve');
    return PettyCashTransaction.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // ── General Ledger & COA ────────────────────────────────────────────────
  Future<Map<String, dynamic>> getGeneralLedger(
    int companyId,
    String coaCode,
    String startDate,
    String endDate,
  ) async {
    final response = await _dio.get('/v1/wh/accounting/general-ledger', queryParameters: {
      'company_id': companyId,
      'coa_code': coaCode,
      'start_date': startDate,
      'end_date': endDate,
    });
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<List<dynamic>> getCoas(int companyId) async {
    final response = await _dio.get('/v1/wh/accounting/coa', queryParameters: {
      'company_id': companyId,
    });
    return response.data['data'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> recalculateCogsLedger(int companyId, {String? fromDate}) async {
    final response = await _dio.post('/v1/wh/accounting/recalculate-cogs-ledger', data: {
      'company_id': companyId,
      if (fromDate != null) 'from_date': fromDate,
    });
    return response.data as Map<String, dynamic>;
  }
}
