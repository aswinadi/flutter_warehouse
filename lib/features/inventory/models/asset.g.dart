// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AssetImpl _$$AssetImplFromJson(Map<String, dynamic> json) => _$AssetImpl(
      id: (json['id'] as num).toInt(),
      assetTag: json['asset_tag'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      brand: json['brand'] as String?,
      model: json['model'] as String?,
      serialNumber: json['serial_number'] as String?,
      purchaseDate: json['purchase_date'] as String?,
      purchasePrice: json['purchase_price'] as String?,
      supplierId: (json['supplier_id'] as num?)?.toInt(),
      supplierName: json['supplier_name'] as String?,
      warrantyExpiry: json['warranty_expiry'] as String?,
      status: json['status'] as String,
      employeeId: (json['employee_id'] as num?)?.toInt(),
      employeeName: json['employee_name'] as String?,
      officeId: (json['office_id'] as num?)?.toInt(),
      officeName: json['office_name'] as String?,
      assignedDate: json['assigned_date'] as String?,
      companyId: (json['company_id'] as num).toInt(),
      companyName: json['company_name'] as String?,
      specifications: json['specifications'] as String?,
      notes: json['notes'] as String?,
      media: (json['media'] as List<dynamic>?)
              ?.map((e) => MediaFile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$AssetImplToJson(_$AssetImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'asset_tag': instance.assetTag,
      'name': instance.name,
      'category': instance.category,
      'brand': instance.brand,
      'model': instance.model,
      'serial_number': instance.serialNumber,
      'purchase_date': instance.purchaseDate,
      'purchase_price': instance.purchasePrice,
      'supplier_id': instance.supplierId,
      'supplier_name': instance.supplierName,
      'warranty_expiry': instance.warrantyExpiry,
      'status': instance.status,
      'employee_id': instance.employeeId,
      'employee_name': instance.employeeName,
      'office_id': instance.officeId,
      'office_name': instance.officeName,
      'assigned_date': instance.assignedDate,
      'company_id': instance.companyId,
      'company_name': instance.companyName,
      'specifications': instance.specifications,
      'notes': instance.notes,
      'media': instance.media,
    };

_$AssetOfficeImpl _$$AssetOfficeImplFromJson(Map<String, dynamic> json) =>
    _$AssetOfficeImpl(
      id: (json['id'] as num).toInt(),
      officeName: json['office_name'] as String,
      companyId: (json['company_id'] as num).toInt(),
    );

Map<String, dynamic> _$$AssetOfficeImplToJson(_$AssetOfficeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'office_name': instance.officeName,
      'company_id': instance.companyId,
    };

_$AssetEmployeeImpl _$$AssetEmployeeImplFromJson(Map<String, dynamic> json) =>
    _$AssetEmployeeImpl(
      id: (json['id'] as num).toInt(),
      fullName: json['full_name'] as String,
      companyId: (json['company_id'] as num).toInt(),
    );

Map<String, dynamic> _$$AssetEmployeeImplToJson(_$AssetEmployeeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'company_id': instance.companyId,
    };
