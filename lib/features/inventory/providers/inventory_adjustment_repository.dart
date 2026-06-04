import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/dio_client.dart';

part 'inventory_adjustment_repository.g.dart';

class InventoryAdjustmentRepository {
  final Dio dio;

  InventoryAdjustmentRepository(this.dio);

  Future<void> adjustStock({
    required int inventoryId,
    required double quantity,
    required String reasonType,
    String? notes,
    XFile? photoFile,
  }) async {
    final formData = FormData();

    formData.fields.addAll([
      MapEntry('inventory_id', inventoryId.toString()),
      MapEntry('quantity', quantity.toString()),
      MapEntry('reason_type', reasonType),
      if (notes != null && notes.isNotEmpty) MapEntry('notes', notes),
    ]);

    if (photoFile != null) {
      formData.files.add(MapEntry(
        'photo',
        await MultipartFile.fromFile(
          photoFile.path,
          filename: photoFile.name,
        ),
      ));
    }

    await dio.post(
      'wh/inventory-adjustments',
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }
}

@riverpod
InventoryAdjustmentRepository inventoryAdjustmentRepository(
    InventoryAdjustmentRepositoryRef ref) {
  return InventoryAdjustmentRepository(ref.watch(dioProvider));
}
