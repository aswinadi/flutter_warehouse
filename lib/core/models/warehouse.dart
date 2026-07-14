import 'package:freezed_annotation/freezed_annotation.dart';

part 'warehouse.freezed.dart';
part 'warehouse.g.dart';

@freezed
class WarehouseArea with _$WarehouseArea {
  const factory WarehouseArea({
    required int id,
    @JsonKey(name: 'warehouse_id') int? warehouseId,
    required String name,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _WarehouseArea;

  factory WarehouseArea.fromJson(Map<String, dynamic> json) =>
      _$WarehouseAreaFromJson(json);
}

@freezed
class Warehouse with _$Warehouse {
  const factory Warehouse({
    required int id,
    @JsonKey(name: 'company_id') required int companyId,
    required String code,
    required String name,
    String? address,
    @JsonKey(name: 'is_active') required bool isActive,
    @Default([]) List<WarehouseArea> areas,
  }) = _Warehouse;

  factory Warehouse.fromJson(Map<String, dynamic> json) =>
      _$WarehouseFromJson(json);
}
