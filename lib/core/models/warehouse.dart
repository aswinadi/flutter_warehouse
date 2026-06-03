import 'package:freezed_annotation/freezed_annotation.dart';

part 'warehouse.freezed.dart';
part 'warehouse.g.dart';

@freezed
class Warehouse with _$Warehouse {
  const factory Warehouse({
    required int id,
    @JsonKey(name: 'company_id') required int companyId,
    required String code,
    required String name,
    String? address,
    @JsonKey(name: 'is_active') required bool isActive,
  }) = _Warehouse;

  factory Warehouse.fromJson(Map<String, dynamic> json) =>
      _$WarehouseFromJson(json);
}
