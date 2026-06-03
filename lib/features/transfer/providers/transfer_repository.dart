import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/transfer.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/api/paginated_response.dart';

part 'transfer_repository.g.dart';

@riverpod
TransferRepository transferRepository(TransferRepositoryRef ref) {
  return TransferRepository(ref.watch(dioProvider));
}

class TransferRepository {
  final Dio dio;

  TransferRepository(this.dio);

  Future<PaginatedResponse<WarehouseTransfer>> getTransfers({
    int page = 1,
    int? companyId,
    int? sourceWarehouseId,
    int? destinationWarehouseId,
    String? status,
  }) async {
    final response = await dio.get('wh/transfers', queryParameters: {
      'page': page,
      if (companyId != null) 'company_id': companyId,
      if (sourceWarehouseId != null) 'source_warehouse_id': sourceWarehouseId,
      if (destinationWarehouseId != null) 'destination_warehouse_id': destinationWarehouseId,
      if (status != null) 'status': status,
    });

    return PaginatedResponse.fromJson(
      response.data,
      (json) => WarehouseTransfer.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<WarehouseTransfer> getTransferDetail(int id) async {
    final response = await dio.get('wh/transfers/$id');
    return WarehouseTransfer.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<WarehouseTransfer> shipTransfer(CreateTransferRequest request) async {
    final response = await dio.post('wh/transfers', data: request.toJson());
    return WarehouseTransfer.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> receiveTransfer(int id, ReceiveTransferRequest request) async {
    await dio.post('wh/transfers/$id/receive', data: request.toJson());
  }
}
