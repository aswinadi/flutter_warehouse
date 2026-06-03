import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'purchase_request_provider.dart';
import '../models/purchase_request.dart';

part 'purchase_request_detail_provider.g.dart';

@riverpod
Future<PurchaseRequest> purchaseRequestDetail(PurchaseRequestDetailRef ref, int id) async {
  final repository = ref.watch(purchaseRequestRepositoryProvider);
  return await repository.getPurchaseRequestDetail(id);
}
