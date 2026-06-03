import 'package:freezed_annotation/freezed_annotation.dart';
import '../../invoice/models/invoice.dart';

part 'asset.freezed.dart';
part 'asset.g.dart';

@freezed
class Asset with _$Asset {
  const factory Asset({
    required int id,
    @JsonKey(name: 'asset_tag') required String assetTag,
    required String name,
    required String category,
    String? brand,
    String? model,
    @JsonKey(name: 'serial_number') String? serialNumber,
    @JsonKey(name: 'purchase_date') String? purchaseDate,
    @JsonKey(name: 'purchase_price') String? purchasePrice,
    @JsonKey(name: 'supplier_id') int? supplierId,
    @JsonKey(name: 'supplier_name') String? supplierName,
    @JsonKey(name: 'warranty_expiry') String? warrantyExpiry,
    required String status,
    @JsonKey(name: 'employee_id') int? employeeId,
    @JsonKey(name: 'employee_name') String? employeeName,
    @JsonKey(name: 'office_id') int? officeId,
    @JsonKey(name: 'office_name') String? officeName,
    @JsonKey(name: 'assigned_date') String? assignedDate,
    @JsonKey(name: 'company_id') required int companyId,
    @JsonKey(name: 'company_name') String? companyName,
    String? specifications,
    String? notes,
    @Default([]) List<MediaFile> media,
  }) = _Asset;

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
}

@freezed
class AssetOffice with _$AssetOffice {
  const factory AssetOffice({
    required int id,
    @JsonKey(name: 'office_name') required String officeName,
    @JsonKey(name: 'company_id') required int companyId,
  }) = _AssetOffice;

  factory AssetOffice.fromJson(Map<String, dynamic> json) => _$AssetOfficeFromJson(json);
}

@freezed
class AssetEmployee with _$AssetEmployee {
  const factory AssetEmployee({
    required int id,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'company_id') required int companyId,
  }) = _AssetEmployee;

  factory AssetEmployee.fromJson(Map<String, dynamic> json) => _$AssetEmployeeFromJson(json);
}
