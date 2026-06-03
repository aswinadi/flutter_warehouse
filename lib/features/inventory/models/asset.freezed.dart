// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Asset _$AssetFromJson(Map<String, dynamic> json) {
  return _Asset.fromJson(json);
}

/// @nodoc
mixin _$Asset {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'asset_tag')
  String get assetTag => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  String? get model => throw _privateConstructorUsedError;
  @JsonKey(name: 'serial_number')
  String? get serialNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'purchase_date')
  String? get purchaseDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'purchase_price')
  String? get purchasePrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_id')
  int? get supplierId => throw _privateConstructorUsedError;
  @JsonKey(name: 'supplier_name')
  String? get supplierName => throw _privateConstructorUsedError;
  @JsonKey(name: 'warranty_expiry')
  String? get warrantyExpiry => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'employee_id')
  int? get employeeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'employee_name')
  String? get employeeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'office_id')
  int? get officeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'office_name')
  String? get officeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'assigned_date')
  String? get assignedDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  int get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name')
  String? get companyName => throw _privateConstructorUsedError;
  String? get specifications => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<MediaFile> get media => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AssetCopyWith<Asset> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssetCopyWith<$Res> {
  factory $AssetCopyWith(Asset value, $Res Function(Asset) then) =
      _$AssetCopyWithImpl<$Res, Asset>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'asset_tag') String assetTag,
      String name,
      String category,
      String? brand,
      String? model,
      @JsonKey(name: 'serial_number') String? serialNumber,
      @JsonKey(name: 'purchase_date') String? purchaseDate,
      @JsonKey(name: 'purchase_price') String? purchasePrice,
      @JsonKey(name: 'supplier_id') int? supplierId,
      @JsonKey(name: 'supplier_name') String? supplierName,
      @JsonKey(name: 'warranty_expiry') String? warrantyExpiry,
      String status,
      @JsonKey(name: 'employee_id') int? employeeId,
      @JsonKey(name: 'employee_name') String? employeeName,
      @JsonKey(name: 'office_id') int? officeId,
      @JsonKey(name: 'office_name') String? officeName,
      @JsonKey(name: 'assigned_date') String? assignedDate,
      @JsonKey(name: 'company_id') int companyId,
      @JsonKey(name: 'company_name') String? companyName,
      String? specifications,
      String? notes,
      List<MediaFile> media});
}

/// @nodoc
class _$AssetCopyWithImpl<$Res, $Val extends Asset>
    implements $AssetCopyWith<$Res> {
  _$AssetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? assetTag = null,
    Object? name = null,
    Object? category = null,
    Object? brand = freezed,
    Object? model = freezed,
    Object? serialNumber = freezed,
    Object? purchaseDate = freezed,
    Object? purchasePrice = freezed,
    Object? supplierId = freezed,
    Object? supplierName = freezed,
    Object? warrantyExpiry = freezed,
    Object? status = null,
    Object? employeeId = freezed,
    Object? employeeName = freezed,
    Object? officeId = freezed,
    Object? officeName = freezed,
    Object? assignedDate = freezed,
    Object? companyId = null,
    Object? companyName = freezed,
    Object? specifications = freezed,
    Object? notes = freezed,
    Object? media = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      assetTag: null == assetTag
          ? _value.assetTag
          : assetTag // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      serialNumber: freezed == serialNumber
          ? _value.serialNumber
          : serialNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      purchaseDate: freezed == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as String?,
      purchasePrice: freezed == purchasePrice
          ? _value.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      warrantyExpiry: freezed == warrantyExpiry
          ? _value.warrantyExpiry
          : warrantyExpiry // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: freezed == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as int?,
      employeeName: freezed == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String?,
      officeId: freezed == officeId
          ? _value.officeId
          : officeId // ignore: cast_nullable_to_non_nullable
              as int?,
      officeName: freezed == officeName
          ? _value.officeName
          : officeName // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedDate: freezed == assignedDate
          ? _value.assignedDate
          : assignedDate // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      specifications: freezed == specifications
          ? _value.specifications
          : specifications // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      media: null == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as List<MediaFile>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AssetImplCopyWith<$Res> implements $AssetCopyWith<$Res> {
  factory _$$AssetImplCopyWith(
          _$AssetImpl value, $Res Function(_$AssetImpl) then) =
      __$$AssetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'asset_tag') String assetTag,
      String name,
      String category,
      String? brand,
      String? model,
      @JsonKey(name: 'serial_number') String? serialNumber,
      @JsonKey(name: 'purchase_date') String? purchaseDate,
      @JsonKey(name: 'purchase_price') String? purchasePrice,
      @JsonKey(name: 'supplier_id') int? supplierId,
      @JsonKey(name: 'supplier_name') String? supplierName,
      @JsonKey(name: 'warranty_expiry') String? warrantyExpiry,
      String status,
      @JsonKey(name: 'employee_id') int? employeeId,
      @JsonKey(name: 'employee_name') String? employeeName,
      @JsonKey(name: 'office_id') int? officeId,
      @JsonKey(name: 'office_name') String? officeName,
      @JsonKey(name: 'assigned_date') String? assignedDate,
      @JsonKey(name: 'company_id') int companyId,
      @JsonKey(name: 'company_name') String? companyName,
      String? specifications,
      String? notes,
      List<MediaFile> media});
}

/// @nodoc
class __$$AssetImplCopyWithImpl<$Res>
    extends _$AssetCopyWithImpl<$Res, _$AssetImpl>
    implements _$$AssetImplCopyWith<$Res> {
  __$$AssetImplCopyWithImpl(
      _$AssetImpl _value, $Res Function(_$AssetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? assetTag = null,
    Object? name = null,
    Object? category = null,
    Object? brand = freezed,
    Object? model = freezed,
    Object? serialNumber = freezed,
    Object? purchaseDate = freezed,
    Object? purchasePrice = freezed,
    Object? supplierId = freezed,
    Object? supplierName = freezed,
    Object? warrantyExpiry = freezed,
    Object? status = null,
    Object? employeeId = freezed,
    Object? employeeName = freezed,
    Object? officeId = freezed,
    Object? officeName = freezed,
    Object? assignedDate = freezed,
    Object? companyId = null,
    Object? companyName = freezed,
    Object? specifications = freezed,
    Object? notes = freezed,
    Object? media = null,
  }) {
    return _then(_$AssetImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      assetTag: null == assetTag
          ? _value.assetTag
          : assetTag // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      serialNumber: freezed == serialNumber
          ? _value.serialNumber
          : serialNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      purchaseDate: freezed == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as String?,
      purchasePrice: freezed == purchasePrice
          ? _value.purchasePrice
          : purchasePrice // ignore: cast_nullable_to_non_nullable
              as String?,
      supplierId: freezed == supplierId
          ? _value.supplierId
          : supplierId // ignore: cast_nullable_to_non_nullable
              as int?,
      supplierName: freezed == supplierName
          ? _value.supplierName
          : supplierName // ignore: cast_nullable_to_non_nullable
              as String?,
      warrantyExpiry: freezed == warrantyExpiry
          ? _value.warrantyExpiry
          : warrantyExpiry // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: freezed == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as int?,
      employeeName: freezed == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String?,
      officeId: freezed == officeId
          ? _value.officeId
          : officeId // ignore: cast_nullable_to_non_nullable
              as int?,
      officeName: freezed == officeName
          ? _value.officeName
          : officeName // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedDate: freezed == assignedDate
          ? _value.assignedDate
          : assignedDate // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      specifications: freezed == specifications
          ? _value.specifications
          : specifications // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      media: null == media
          ? _value._media
          : media // ignore: cast_nullable_to_non_nullable
              as List<MediaFile>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AssetImpl implements _Asset {
  const _$AssetImpl(
      {required this.id,
      @JsonKey(name: 'asset_tag') required this.assetTag,
      required this.name,
      required this.category,
      this.brand,
      this.model,
      @JsonKey(name: 'serial_number') this.serialNumber,
      @JsonKey(name: 'purchase_date') this.purchaseDate,
      @JsonKey(name: 'purchase_price') this.purchasePrice,
      @JsonKey(name: 'supplier_id') this.supplierId,
      @JsonKey(name: 'supplier_name') this.supplierName,
      @JsonKey(name: 'warranty_expiry') this.warrantyExpiry,
      required this.status,
      @JsonKey(name: 'employee_id') this.employeeId,
      @JsonKey(name: 'employee_name') this.employeeName,
      @JsonKey(name: 'office_id') this.officeId,
      @JsonKey(name: 'office_name') this.officeName,
      @JsonKey(name: 'assigned_date') this.assignedDate,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'company_name') this.companyName,
      this.specifications,
      this.notes,
      final List<MediaFile> media = const []})
      : _media = media;

  factory _$AssetImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssetImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'asset_tag')
  final String assetTag;
  @override
  final String name;
  @override
  final String category;
  @override
  final String? brand;
  @override
  final String? model;
  @override
  @JsonKey(name: 'serial_number')
  final String? serialNumber;
  @override
  @JsonKey(name: 'purchase_date')
  final String? purchaseDate;
  @override
  @JsonKey(name: 'purchase_price')
  final String? purchasePrice;
  @override
  @JsonKey(name: 'supplier_id')
  final int? supplierId;
  @override
  @JsonKey(name: 'supplier_name')
  final String? supplierName;
  @override
  @JsonKey(name: 'warranty_expiry')
  final String? warrantyExpiry;
  @override
  final String status;
  @override
  @JsonKey(name: 'employee_id')
  final int? employeeId;
  @override
  @JsonKey(name: 'employee_name')
  final String? employeeName;
  @override
  @JsonKey(name: 'office_id')
  final int? officeId;
  @override
  @JsonKey(name: 'office_name')
  final String? officeName;
  @override
  @JsonKey(name: 'assigned_date')
  final String? assignedDate;
  @override
  @JsonKey(name: 'company_id')
  final int companyId;
  @override
  @JsonKey(name: 'company_name')
  final String? companyName;
  @override
  final String? specifications;
  @override
  final String? notes;
  final List<MediaFile> _media;
  @override
  @JsonKey()
  List<MediaFile> get media {
    if (_media is EqualUnmodifiableListView) return _media;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_media);
  }

  @override
  String toString() {
    return 'Asset(id: $id, assetTag: $assetTag, name: $name, category: $category, brand: $brand, model: $model, serialNumber: $serialNumber, purchaseDate: $purchaseDate, purchasePrice: $purchasePrice, supplierId: $supplierId, supplierName: $supplierName, warrantyExpiry: $warrantyExpiry, status: $status, employeeId: $employeeId, employeeName: $employeeName, officeId: $officeId, officeName: $officeName, assignedDate: $assignedDate, companyId: $companyId, companyName: $companyName, specifications: $specifications, notes: $notes, media: $media)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.assetTag, assetTag) ||
                other.assetTag == assetTag) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.serialNumber, serialNumber) ||
                other.serialNumber == serialNumber) &&
            (identical(other.purchaseDate, purchaseDate) ||
                other.purchaseDate == purchaseDate) &&
            (identical(other.purchasePrice, purchasePrice) ||
                other.purchasePrice == purchasePrice) &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.supplierName, supplierName) ||
                other.supplierName == supplierName) &&
            (identical(other.warrantyExpiry, warrantyExpiry) ||
                other.warrantyExpiry == warrantyExpiry) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.employeeName, employeeName) ||
                other.employeeName == employeeName) &&
            (identical(other.officeId, officeId) ||
                other.officeId == officeId) &&
            (identical(other.officeName, officeName) ||
                other.officeName == officeName) &&
            (identical(other.assignedDate, assignedDate) ||
                other.assignedDate == assignedDate) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.specifications, specifications) ||
                other.specifications == specifications) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._media, _media));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        assetTag,
        name,
        category,
        brand,
        model,
        serialNumber,
        purchaseDate,
        purchasePrice,
        supplierId,
        supplierName,
        warrantyExpiry,
        status,
        employeeId,
        employeeName,
        officeId,
        officeName,
        assignedDate,
        companyId,
        companyName,
        specifications,
        notes,
        const DeepCollectionEquality().hash(_media)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AssetImplCopyWith<_$AssetImpl> get copyWith =>
      __$$AssetImplCopyWithImpl<_$AssetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssetImplToJson(
      this,
    );
  }
}

abstract class _Asset implements Asset {
  const factory _Asset(
      {required final int id,
      @JsonKey(name: 'asset_tag') required final String assetTag,
      required final String name,
      required final String category,
      final String? brand,
      final String? model,
      @JsonKey(name: 'serial_number') final String? serialNumber,
      @JsonKey(name: 'purchase_date') final String? purchaseDate,
      @JsonKey(name: 'purchase_price') final String? purchasePrice,
      @JsonKey(name: 'supplier_id') final int? supplierId,
      @JsonKey(name: 'supplier_name') final String? supplierName,
      @JsonKey(name: 'warranty_expiry') final String? warrantyExpiry,
      required final String status,
      @JsonKey(name: 'employee_id') final int? employeeId,
      @JsonKey(name: 'employee_name') final String? employeeName,
      @JsonKey(name: 'office_id') final int? officeId,
      @JsonKey(name: 'office_name') final String? officeName,
      @JsonKey(name: 'assigned_date') final String? assignedDate,
      @JsonKey(name: 'company_id') required final int companyId,
      @JsonKey(name: 'company_name') final String? companyName,
      final String? specifications,
      final String? notes,
      final List<MediaFile> media}) = _$AssetImpl;

  factory _Asset.fromJson(Map<String, dynamic> json) = _$AssetImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'asset_tag')
  String get assetTag;
  @override
  String get name;
  @override
  String get category;
  @override
  String? get brand;
  @override
  String? get model;
  @override
  @JsonKey(name: 'serial_number')
  String? get serialNumber;
  @override
  @JsonKey(name: 'purchase_date')
  String? get purchaseDate;
  @override
  @JsonKey(name: 'purchase_price')
  String? get purchasePrice;
  @override
  @JsonKey(name: 'supplier_id')
  int? get supplierId;
  @override
  @JsonKey(name: 'supplier_name')
  String? get supplierName;
  @override
  @JsonKey(name: 'warranty_expiry')
  String? get warrantyExpiry;
  @override
  String get status;
  @override
  @JsonKey(name: 'employee_id')
  int? get employeeId;
  @override
  @JsonKey(name: 'employee_name')
  String? get employeeName;
  @override
  @JsonKey(name: 'office_id')
  int? get officeId;
  @override
  @JsonKey(name: 'office_name')
  String? get officeName;
  @override
  @JsonKey(name: 'assigned_date')
  String? get assignedDate;
  @override
  @JsonKey(name: 'company_id')
  int get companyId;
  @override
  @JsonKey(name: 'company_name')
  String? get companyName;
  @override
  String? get specifications;
  @override
  String? get notes;
  @override
  List<MediaFile> get media;
  @override
  @JsonKey(ignore: true)
  _$$AssetImplCopyWith<_$AssetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AssetOffice _$AssetOfficeFromJson(Map<String, dynamic> json) {
  return _AssetOffice.fromJson(json);
}

/// @nodoc
mixin _$AssetOffice {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'office_name')
  String get officeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  int get companyId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AssetOfficeCopyWith<AssetOffice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssetOfficeCopyWith<$Res> {
  factory $AssetOfficeCopyWith(
          AssetOffice value, $Res Function(AssetOffice) then) =
      _$AssetOfficeCopyWithImpl<$Res, AssetOffice>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'office_name') String officeName,
      @JsonKey(name: 'company_id') int companyId});
}

/// @nodoc
class _$AssetOfficeCopyWithImpl<$Res, $Val extends AssetOffice>
    implements $AssetOfficeCopyWith<$Res> {
  _$AssetOfficeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? officeName = null,
    Object? companyId = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      officeName: null == officeName
          ? _value.officeName
          : officeName // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AssetOfficeImplCopyWith<$Res>
    implements $AssetOfficeCopyWith<$Res> {
  factory _$$AssetOfficeImplCopyWith(
          _$AssetOfficeImpl value, $Res Function(_$AssetOfficeImpl) then) =
      __$$AssetOfficeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'office_name') String officeName,
      @JsonKey(name: 'company_id') int companyId});
}

/// @nodoc
class __$$AssetOfficeImplCopyWithImpl<$Res>
    extends _$AssetOfficeCopyWithImpl<$Res, _$AssetOfficeImpl>
    implements _$$AssetOfficeImplCopyWith<$Res> {
  __$$AssetOfficeImplCopyWithImpl(
      _$AssetOfficeImpl _value, $Res Function(_$AssetOfficeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? officeName = null,
    Object? companyId = null,
  }) {
    return _then(_$AssetOfficeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      officeName: null == officeName
          ? _value.officeName
          : officeName // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AssetOfficeImpl implements _AssetOffice {
  const _$AssetOfficeImpl(
      {required this.id,
      @JsonKey(name: 'office_name') required this.officeName,
      @JsonKey(name: 'company_id') required this.companyId});

  factory _$AssetOfficeImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssetOfficeImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'office_name')
  final String officeName;
  @override
  @JsonKey(name: 'company_id')
  final int companyId;

  @override
  String toString() {
    return 'AssetOffice(id: $id, officeName: $officeName, companyId: $companyId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssetOfficeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.officeName, officeName) ||
                other.officeName == officeName) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, officeName, companyId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AssetOfficeImplCopyWith<_$AssetOfficeImpl> get copyWith =>
      __$$AssetOfficeImplCopyWithImpl<_$AssetOfficeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssetOfficeImplToJson(
      this,
    );
  }
}

abstract class _AssetOffice implements AssetOffice {
  const factory _AssetOffice(
          {required final int id,
          @JsonKey(name: 'office_name') required final String officeName,
          @JsonKey(name: 'company_id') required final int companyId}) =
      _$AssetOfficeImpl;

  factory _AssetOffice.fromJson(Map<String, dynamic> json) =
      _$AssetOfficeImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'office_name')
  String get officeName;
  @override
  @JsonKey(name: 'company_id')
  int get companyId;
  @override
  @JsonKey(ignore: true)
  _$$AssetOfficeImplCopyWith<_$AssetOfficeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AssetEmployee _$AssetEmployeeFromJson(Map<String, dynamic> json) {
  return _AssetEmployee.fromJson(json);
}

/// @nodoc
mixin _$AssetEmployee {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'full_name')
  String get fullName => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  int get companyId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AssetEmployeeCopyWith<AssetEmployee> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssetEmployeeCopyWith<$Res> {
  factory $AssetEmployeeCopyWith(
          AssetEmployee value, $Res Function(AssetEmployee) then) =
      _$AssetEmployeeCopyWithImpl<$Res, AssetEmployee>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'full_name') String fullName,
      @JsonKey(name: 'company_id') int companyId});
}

/// @nodoc
class _$AssetEmployeeCopyWithImpl<$Res, $Val extends AssetEmployee>
    implements $AssetEmployeeCopyWith<$Res> {
  _$AssetEmployeeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? companyId = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AssetEmployeeImplCopyWith<$Res>
    implements $AssetEmployeeCopyWith<$Res> {
  factory _$$AssetEmployeeImplCopyWith(
          _$AssetEmployeeImpl value, $Res Function(_$AssetEmployeeImpl) then) =
      __$$AssetEmployeeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'full_name') String fullName,
      @JsonKey(name: 'company_id') int companyId});
}

/// @nodoc
class __$$AssetEmployeeImplCopyWithImpl<$Res>
    extends _$AssetEmployeeCopyWithImpl<$Res, _$AssetEmployeeImpl>
    implements _$$AssetEmployeeImplCopyWith<$Res> {
  __$$AssetEmployeeImplCopyWithImpl(
      _$AssetEmployeeImpl _value, $Res Function(_$AssetEmployeeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? companyId = null,
  }) {
    return _then(_$AssetEmployeeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AssetEmployeeImpl implements _AssetEmployee {
  const _$AssetEmployeeImpl(
      {required this.id,
      @JsonKey(name: 'full_name') required this.fullName,
      @JsonKey(name: 'company_id') required this.companyId});

  factory _$AssetEmployeeImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssetEmployeeImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'full_name')
  final String fullName;
  @override
  @JsonKey(name: 'company_id')
  final int companyId;

  @override
  String toString() {
    return 'AssetEmployee(id: $id, fullName: $fullName, companyId: $companyId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssetEmployeeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, fullName, companyId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AssetEmployeeImplCopyWith<_$AssetEmployeeImpl> get copyWith =>
      __$$AssetEmployeeImplCopyWithImpl<_$AssetEmployeeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssetEmployeeImplToJson(
      this,
    );
  }
}

abstract class _AssetEmployee implements AssetEmployee {
  const factory _AssetEmployee(
          {required final int id,
          @JsonKey(name: 'full_name') required final String fullName,
          @JsonKey(name: 'company_id') required final int companyId}) =
      _$AssetEmployeeImpl;

  factory _AssetEmployee.fromJson(Map<String, dynamic> json) =
      _$AssetEmployeeImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'full_name')
  String get fullName;
  @override
  @JsonKey(name: 'company_id')
  int get companyId;
  @override
  @JsonKey(ignore: true)
  _$$AssetEmployeeImplCopyWith<_$AssetEmployeeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
