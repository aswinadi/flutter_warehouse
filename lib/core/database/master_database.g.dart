// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_database.dart';

// ignore_for_file: type=lint
class $CompaniesTableTable extends CompaniesTable
    with TableInfo<$CompaniesTableTable, CompaniesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompaniesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _companyCodeMeta =
      const VerificationMeta('companyCode');
  @override
  late final GeneratedColumn<String> companyCode = GeneratedColumn<String>(
      'company_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _companyNameMeta =
      const VerificationMeta('companyName');
  @override
  late final GeneratedColumn<String> companyName = GeneratedColumn<String>(
      'company_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, companyCode, companyName, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'companies_table';
  @override
  VerificationContext validateIntegrity(Insertable<CompaniesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('company_code')) {
      context.handle(
          _companyCodeMeta,
          companyCode.isAcceptableOrUnknown(
              data['company_code']!, _companyCodeMeta));
    } else if (isInserting) {
      context.missing(_companyCodeMeta);
    }
    if (data.containsKey('company_name')) {
      context.handle(
          _companyNameMeta,
          companyName.isAcceptableOrUnknown(
              data['company_name']!, _companyNameMeta));
    } else if (isInserting) {
      context.missing(_companyNameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CompaniesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompaniesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      companyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}company_code'])!,
      companyName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}company_name'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $CompaniesTableTable createAlias(String alias) {
    return $CompaniesTableTable(attachedDatabase, alias);
  }
}

class CompaniesTableData extends DataClass
    implements Insertable<CompaniesTableData> {
  final int id;
  final String companyCode;
  final String companyName;
  final bool isActive;
  const CompaniesTableData(
      {required this.id,
      required this.companyCode,
      required this.companyName,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['company_code'] = Variable<String>(companyCode);
    map['company_name'] = Variable<String>(companyName);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  CompaniesTableCompanion toCompanion(bool nullToAbsent) {
    return CompaniesTableCompanion(
      id: Value(id),
      companyCode: Value(companyCode),
      companyName: Value(companyName),
      isActive: Value(isActive),
    );
  }

  factory CompaniesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompaniesTableData(
      id: serializer.fromJson<int>(json['id']),
      companyCode: serializer.fromJson<String>(json['companyCode']),
      companyName: serializer.fromJson<String>(json['companyName']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'companyCode': serializer.toJson<String>(companyCode),
      'companyName': serializer.toJson<String>(companyName),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  CompaniesTableData copyWith(
          {int? id,
          String? companyCode,
          String? companyName,
          bool? isActive}) =>
      CompaniesTableData(
        id: id ?? this.id,
        companyCode: companyCode ?? this.companyCode,
        companyName: companyName ?? this.companyName,
        isActive: isActive ?? this.isActive,
      );
  CompaniesTableData copyWithCompanion(CompaniesTableCompanion data) {
    return CompaniesTableData(
      id: data.id.present ? data.id.value : this.id,
      companyCode:
          data.companyCode.present ? data.companyCode.value : this.companyCode,
      companyName:
          data.companyName.present ? data.companyName.value : this.companyName,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompaniesTableData(')
          ..write('id: $id, ')
          ..write('companyCode: $companyCode, ')
          ..write('companyName: $companyName, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, companyCode, companyName, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompaniesTableData &&
          other.id == this.id &&
          other.companyCode == this.companyCode &&
          other.companyName == this.companyName &&
          other.isActive == this.isActive);
}

class CompaniesTableCompanion extends UpdateCompanion<CompaniesTableData> {
  final Value<int> id;
  final Value<String> companyCode;
  final Value<String> companyName;
  final Value<bool> isActive;
  const CompaniesTableCompanion({
    this.id = const Value.absent(),
    this.companyCode = const Value.absent(),
    this.companyName = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  CompaniesTableCompanion.insert({
    this.id = const Value.absent(),
    required String companyCode,
    required String companyName,
    this.isActive = const Value.absent(),
  })  : companyCode = Value(companyCode),
        companyName = Value(companyName);
  static Insertable<CompaniesTableData> custom({
    Expression<int>? id,
    Expression<String>? companyCode,
    Expression<String>? companyName,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (companyCode != null) 'company_code': companyCode,
      if (companyName != null) 'company_name': companyName,
      if (isActive != null) 'is_active': isActive,
    });
  }

  CompaniesTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? companyCode,
      Value<String>? companyName,
      Value<bool>? isActive}) {
    return CompaniesTableCompanion(
      id: id ?? this.id,
      companyCode: companyCode ?? this.companyCode,
      companyName: companyName ?? this.companyName,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (companyCode.present) {
      map['company_code'] = Variable<String>(companyCode.value);
    }
    if (companyName.present) {
      map['company_name'] = Variable<String>(companyName.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompaniesTableCompanion(')
          ..write('id: $id, ')
          ..write('companyCode: $companyCode, ')
          ..write('companyName: $companyName, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $SuppliersTableTable extends SuppliersTable
    with TableInfo<$SuppliersTableTable, SuppliersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SuppliersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [id, code, name, phone, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'suppliers_table';
  @override
  VerificationContext validateIntegrity(Insertable<SuppliersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SuppliersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SuppliersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $SuppliersTableTable createAlias(String alias) {
    return $SuppliersTableTable(attachedDatabase, alias);
  }
}

class SuppliersTableData extends DataClass
    implements Insertable<SuppliersTableData> {
  final int id;
  final String code;
  final String name;
  final String? phone;
  final bool isActive;
  const SuppliersTableData(
      {required this.id,
      required this.code,
      required this.name,
      this.phone,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  SuppliersTableCompanion toCompanion(bool nullToAbsent) {
    return SuppliersTableCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      isActive: Value(isActive),
    );
  }

  factory SuppliersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SuppliersTableData(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  SuppliersTableData copyWith(
          {int? id,
          String? code,
          String? name,
          Value<String?> phone = const Value.absent(),
          bool? isActive}) =>
      SuppliersTableData(
        id: id ?? this.id,
        code: code ?? this.code,
        name: name ?? this.name,
        phone: phone.present ? phone.value : this.phone,
        isActive: isActive ?? this.isActive,
      );
  SuppliersTableData copyWithCompanion(SuppliersTableCompanion data) {
    return SuppliersTableData(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SuppliersTableData(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, name, phone, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SuppliersTableData &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.isActive == this.isActive);
}

class SuppliersTableCompanion extends UpdateCompanion<SuppliersTableData> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> name;
  final Value<String?> phone;
  final Value<bool> isActive;
  const SuppliersTableCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  SuppliersTableCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String name,
    this.phone = const Value.absent(),
    this.isActive = const Value.absent(),
  })  : code = Value(code),
        name = Value(name);
  static Insertable<SuppliersTableData> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (isActive != null) 'is_active': isActive,
    });
  }

  SuppliersTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? code,
      Value<String>? name,
      Value<String?>? phone,
      Value<bool>? isActive}) {
    return SuppliersTableCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SuppliersTableCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $ProductsTableTable extends ProductsTable
    with TableInfo<$ProductsTableTable, ProductsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String> sku = GeneratedColumn<String>(
      'sku', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _minStockMeta =
      const VerificationMeta('minStock');
  @override
  late final GeneratedColumn<int> minStock = GeneratedColumn<int>(
      'min_stock', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, sku, name, unit, category, minStock, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products_table';
  @override
  VerificationContext validateIntegrity(Insertable<ProductsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sku')) {
      context.handle(
          _skuMeta, sku.isAcceptableOrUnknown(data['sku']!, _skuMeta));
    } else if (isInserting) {
      context.missing(_skuMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('min_stock')) {
      context.handle(_minStockMeta,
          minStock.isAcceptableOrUnknown(data['min_stock']!, _minStockMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sku: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sku'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      minStock: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}min_stock'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $ProductsTableTable createAlias(String alias) {
    return $ProductsTableTable(attachedDatabase, alias);
  }
}

class ProductsTableData extends DataClass
    implements Insertable<ProductsTableData> {
  final int id;
  final String sku;
  final String name;
  final String unit;
  final String category;
  final int minStock;
  final bool isActive;
  const ProductsTableData(
      {required this.id,
      required this.sku,
      required this.name,
      required this.unit,
      required this.category,
      required this.minStock,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sku'] = Variable<String>(sku);
    map['name'] = Variable<String>(name);
    map['unit'] = Variable<String>(unit);
    map['category'] = Variable<String>(category);
    map['min_stock'] = Variable<int>(minStock);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ProductsTableCompanion toCompanion(bool nullToAbsent) {
    return ProductsTableCompanion(
      id: Value(id),
      sku: Value(sku),
      name: Value(name),
      unit: Value(unit),
      category: Value(category),
      minStock: Value(minStock),
      isActive: Value(isActive),
    );
  }

  factory ProductsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductsTableData(
      id: serializer.fromJson<int>(json['id']),
      sku: serializer.fromJson<String>(json['sku']),
      name: serializer.fromJson<String>(json['name']),
      unit: serializer.fromJson<String>(json['unit']),
      category: serializer.fromJson<String>(json['category']),
      minStock: serializer.fromJson<int>(json['minStock']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sku': serializer.toJson<String>(sku),
      'name': serializer.toJson<String>(name),
      'unit': serializer.toJson<String>(unit),
      'category': serializer.toJson<String>(category),
      'minStock': serializer.toJson<int>(minStock),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  ProductsTableData copyWith(
          {int? id,
          String? sku,
          String? name,
          String? unit,
          String? category,
          int? minStock,
          bool? isActive}) =>
      ProductsTableData(
        id: id ?? this.id,
        sku: sku ?? this.sku,
        name: name ?? this.name,
        unit: unit ?? this.unit,
        category: category ?? this.category,
        minStock: minStock ?? this.minStock,
        isActive: isActive ?? this.isActive,
      );
  ProductsTableData copyWithCompanion(ProductsTableCompanion data) {
    return ProductsTableData(
      id: data.id.present ? data.id.value : this.id,
      sku: data.sku.present ? data.sku.value : this.sku,
      name: data.name.present ? data.name.value : this.name,
      unit: data.unit.present ? data.unit.value : this.unit,
      category: data.category.present ? data.category.value : this.category,
      minStock: data.minStock.present ? data.minStock.value : this.minStock,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductsTableData(')
          ..write('id: $id, ')
          ..write('sku: $sku, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('category: $category, ')
          ..write('minStock: $minStock, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sku, name, unit, category, minStock, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductsTableData &&
          other.id == this.id &&
          other.sku == this.sku &&
          other.name == this.name &&
          other.unit == this.unit &&
          other.category == this.category &&
          other.minStock == this.minStock &&
          other.isActive == this.isActive);
}

class ProductsTableCompanion extends UpdateCompanion<ProductsTableData> {
  final Value<int> id;
  final Value<String> sku;
  final Value<String> name;
  final Value<String> unit;
  final Value<String> category;
  final Value<int> minStock;
  final Value<bool> isActive;
  const ProductsTableCompanion({
    this.id = const Value.absent(),
    this.sku = const Value.absent(),
    this.name = const Value.absent(),
    this.unit = const Value.absent(),
    this.category = const Value.absent(),
    this.minStock = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  ProductsTableCompanion.insert({
    this.id = const Value.absent(),
    required String sku,
    required String name,
    required String unit,
    required String category,
    this.minStock = const Value.absent(),
    this.isActive = const Value.absent(),
  })  : sku = Value(sku),
        name = Value(name),
        unit = Value(unit),
        category = Value(category);
  static Insertable<ProductsTableData> custom({
    Expression<int>? id,
    Expression<String>? sku,
    Expression<String>? name,
    Expression<String>? unit,
    Expression<String>? category,
    Expression<int>? minStock,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sku != null) 'sku': sku,
      if (name != null) 'name': name,
      if (unit != null) 'unit': unit,
      if (category != null) 'category': category,
      if (minStock != null) 'min_stock': minStock,
      if (isActive != null) 'is_active': isActive,
    });
  }

  ProductsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? sku,
      Value<String>? name,
      Value<String>? unit,
      Value<String>? category,
      Value<int>? minStock,
      Value<bool>? isActive}) {
    return ProductsTableCompanion(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      minStock: minStock ?? this.minStock,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (minStock.present) {
      map['min_stock'] = Variable<int>(minStock.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsTableCompanion(')
          ..write('id: $id, ')
          ..write('sku: $sku, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('category: $category, ')
          ..write('minStock: $minStock, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $SyncMetadataTableTable extends SyncMetadataTable
    with TableInfo<$SyncMetadataTableTable, SyncMetadataTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetadataTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _syncTableMeta =
      const VerificationMeta('syncTable');
  @override
  late final GeneratedColumn<String> syncTable = GeneratedColumn<String>(
      'sync_table', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastSyncedAtMeta =
      const VerificationMeta('lastSyncedAt');
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [syncTable, lastSyncedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<SyncMetadataTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sync_table')) {
      context.handle(_syncTableMeta,
          syncTable.isAcceptableOrUnknown(data['sync_table']!, _syncTableMeta));
    } else if (isInserting) {
      context.missing(_syncTableMeta);
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
          _lastSyncedAtMeta,
          lastSyncedAt.isAcceptableOrUnknown(
              data['last_synced_at']!, _lastSyncedAtMeta));
    } else if (isInserting) {
      context.missing(_lastSyncedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {syncTable};
  @override
  SyncMetadataTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadataTableData(
      syncTable: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_table'])!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at'])!,
    );
  }

  @override
  $SyncMetadataTableTable createAlias(String alias) {
    return $SyncMetadataTableTable(attachedDatabase, alias);
  }
}

class SyncMetadataTableData extends DataClass
    implements Insertable<SyncMetadataTableData> {
  final String syncTable;
  final DateTime lastSyncedAt;
  const SyncMetadataTableData(
      {required this.syncTable, required this.lastSyncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sync_table'] = Variable<String>(syncTable);
    map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    return map;
  }

  SyncMetadataTableCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataTableCompanion(
      syncTable: Value(syncTable),
      lastSyncedAt: Value(lastSyncedAt),
    );
  }

  factory SyncMetadataTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadataTableData(
      syncTable: serializer.fromJson<String>(json['syncTable']),
      lastSyncedAt: serializer.fromJson<DateTime>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'syncTable': serializer.toJson<String>(syncTable),
      'lastSyncedAt': serializer.toJson<DateTime>(lastSyncedAt),
    };
  }

  SyncMetadataTableData copyWith({String? syncTable, DateTime? lastSyncedAt}) =>
      SyncMetadataTableData(
        syncTable: syncTable ?? this.syncTable,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      );
  SyncMetadataTableData copyWithCompanion(SyncMetadataTableCompanion data) {
    return SyncMetadataTableData(
      syncTable: data.syncTable.present ? data.syncTable.value : this.syncTable,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataTableData(')
          ..write('syncTable: $syncTable, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(syncTable, lastSyncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadataTableData &&
          other.syncTable == this.syncTable &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class SyncMetadataTableCompanion
    extends UpdateCompanion<SyncMetadataTableData> {
  final Value<String> syncTable;
  final Value<DateTime> lastSyncedAt;
  final Value<int> rowid;
  const SyncMetadataTableCompanion({
    this.syncTable = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetadataTableCompanion.insert({
    required String syncTable,
    required DateTime lastSyncedAt,
    this.rowid = const Value.absent(),
  })  : syncTable = Value(syncTable),
        lastSyncedAt = Value(lastSyncedAt);
  static Insertable<SyncMetadataTableData> custom({
    Expression<String>? syncTable,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (syncTable != null) 'sync_table': syncTable,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetadataTableCompanion copyWith(
      {Value<String>? syncTable,
      Value<DateTime>? lastSyncedAt,
      Value<int>? rowid}) {
    return SyncMetadataTableCompanion(
      syncTable: syncTable ?? this.syncTable,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (syncTable.present) {
      map['sync_table'] = Variable<String>(syncTable.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataTableCompanion(')
          ..write('syncTable: $syncTable, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$MasterDatabase extends GeneratedDatabase {
  _$MasterDatabase(QueryExecutor e) : super(e);
  $MasterDatabaseManager get managers => $MasterDatabaseManager(this);
  late final $CompaniesTableTable companiesTable = $CompaniesTableTable(this);
  late final $SuppliersTableTable suppliersTable = $SuppliersTableTable(this);
  late final $ProductsTableTable productsTable = $ProductsTableTable(this);
  late final $SyncMetadataTableTable syncMetadataTable =
      $SyncMetadataTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [companiesTable, suppliersTable, productsTable, syncMetadataTable];
}

typedef $$CompaniesTableTableCreateCompanionBuilder = CompaniesTableCompanion
    Function({
  Value<int> id,
  required String companyCode,
  required String companyName,
  Value<bool> isActive,
});
typedef $$CompaniesTableTableUpdateCompanionBuilder = CompaniesTableCompanion
    Function({
  Value<int> id,
  Value<String> companyCode,
  Value<String> companyName,
  Value<bool> isActive,
});

class $$CompaniesTableTableFilterComposer
    extends Composer<_$MasterDatabase, $CompaniesTableTable> {
  $$CompaniesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get companyCode => $composableBuilder(
      column: $table.companyCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get companyName => $composableBuilder(
      column: $table.companyName, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));
}

class $$CompaniesTableTableOrderingComposer
    extends Composer<_$MasterDatabase, $CompaniesTableTable> {
  $$CompaniesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get companyCode => $composableBuilder(
      column: $table.companyCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get companyName => $composableBuilder(
      column: $table.companyName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$CompaniesTableTableAnnotationComposer
    extends Composer<_$MasterDatabase, $CompaniesTableTable> {
  $$CompaniesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get companyCode => $composableBuilder(
      column: $table.companyCode, builder: (column) => column);

  GeneratedColumn<String> get companyName => $composableBuilder(
      column: $table.companyName, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$CompaniesTableTableTableManager extends RootTableManager<
    _$MasterDatabase,
    $CompaniesTableTable,
    CompaniesTableData,
    $$CompaniesTableTableFilterComposer,
    $$CompaniesTableTableOrderingComposer,
    $$CompaniesTableTableAnnotationComposer,
    $$CompaniesTableTableCreateCompanionBuilder,
    $$CompaniesTableTableUpdateCompanionBuilder,
    (
      CompaniesTableData,
      BaseReferences<_$MasterDatabase, $CompaniesTableTable, CompaniesTableData>
    ),
    CompaniesTableData,
    PrefetchHooks Function()> {
  $$CompaniesTableTableTableManager(
      _$MasterDatabase db, $CompaniesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompaniesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompaniesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompaniesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> companyCode = const Value.absent(),
            Value<String> companyName = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              CompaniesTableCompanion(
            id: id,
            companyCode: companyCode,
            companyName: companyName,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String companyCode,
            required String companyName,
            Value<bool> isActive = const Value.absent(),
          }) =>
              CompaniesTableCompanion.insert(
            id: id,
            companyCode: companyCode,
            companyName: companyName,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CompaniesTableTableProcessedTableManager = ProcessedTableManager<
    _$MasterDatabase,
    $CompaniesTableTable,
    CompaniesTableData,
    $$CompaniesTableTableFilterComposer,
    $$CompaniesTableTableOrderingComposer,
    $$CompaniesTableTableAnnotationComposer,
    $$CompaniesTableTableCreateCompanionBuilder,
    $$CompaniesTableTableUpdateCompanionBuilder,
    (
      CompaniesTableData,
      BaseReferences<_$MasterDatabase, $CompaniesTableTable, CompaniesTableData>
    ),
    CompaniesTableData,
    PrefetchHooks Function()>;
typedef $$SuppliersTableTableCreateCompanionBuilder = SuppliersTableCompanion
    Function({
  Value<int> id,
  required String code,
  required String name,
  Value<String?> phone,
  Value<bool> isActive,
});
typedef $$SuppliersTableTableUpdateCompanionBuilder = SuppliersTableCompanion
    Function({
  Value<int> id,
  Value<String> code,
  Value<String> name,
  Value<String?> phone,
  Value<bool> isActive,
});

class $$SuppliersTableTableFilterComposer
    extends Composer<_$MasterDatabase, $SuppliersTableTable> {
  $$SuppliersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));
}

class $$SuppliersTableTableOrderingComposer
    extends Composer<_$MasterDatabase, $SuppliersTableTable> {
  $$SuppliersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$SuppliersTableTableAnnotationComposer
    extends Composer<_$MasterDatabase, $SuppliersTableTable> {
  $$SuppliersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$SuppliersTableTableTableManager extends RootTableManager<
    _$MasterDatabase,
    $SuppliersTableTable,
    SuppliersTableData,
    $$SuppliersTableTableFilterComposer,
    $$SuppliersTableTableOrderingComposer,
    $$SuppliersTableTableAnnotationComposer,
    $$SuppliersTableTableCreateCompanionBuilder,
    $$SuppliersTableTableUpdateCompanionBuilder,
    (
      SuppliersTableData,
      BaseReferences<_$MasterDatabase, $SuppliersTableTable, SuppliersTableData>
    ),
    SuppliersTableData,
    PrefetchHooks Function()> {
  $$SuppliersTableTableTableManager(
      _$MasterDatabase db, $SuppliersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SuppliersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SuppliersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SuppliersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              SuppliersTableCompanion(
            id: id,
            code: code,
            name: name,
            phone: phone,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String code,
            required String name,
            Value<String?> phone = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              SuppliersTableCompanion.insert(
            id: id,
            code: code,
            name: name,
            phone: phone,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SuppliersTableTableProcessedTableManager = ProcessedTableManager<
    _$MasterDatabase,
    $SuppliersTableTable,
    SuppliersTableData,
    $$SuppliersTableTableFilterComposer,
    $$SuppliersTableTableOrderingComposer,
    $$SuppliersTableTableAnnotationComposer,
    $$SuppliersTableTableCreateCompanionBuilder,
    $$SuppliersTableTableUpdateCompanionBuilder,
    (
      SuppliersTableData,
      BaseReferences<_$MasterDatabase, $SuppliersTableTable, SuppliersTableData>
    ),
    SuppliersTableData,
    PrefetchHooks Function()>;
typedef $$ProductsTableTableCreateCompanionBuilder = ProductsTableCompanion
    Function({
  Value<int> id,
  required String sku,
  required String name,
  required String unit,
  required String category,
  Value<int> minStock,
  Value<bool> isActive,
});
typedef $$ProductsTableTableUpdateCompanionBuilder = ProductsTableCompanion
    Function({
  Value<int> id,
  Value<String> sku,
  Value<String> name,
  Value<String> unit,
  Value<String> category,
  Value<int> minStock,
  Value<bool> isActive,
});

class $$ProductsTableTableFilterComposer
    extends Composer<_$MasterDatabase, $ProductsTableTable> {
  $$ProductsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sku => $composableBuilder(
      column: $table.sku, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get minStock => $composableBuilder(
      column: $table.minStock, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));
}

class $$ProductsTableTableOrderingComposer
    extends Composer<_$MasterDatabase, $ProductsTableTable> {
  $$ProductsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sku => $composableBuilder(
      column: $table.sku, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get minStock => $composableBuilder(
      column: $table.minStock, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$ProductsTableTableAnnotationComposer
    extends Composer<_$MasterDatabase, $ProductsTableTable> {
  $$ProductsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sku =>
      $composableBuilder(column: $table.sku, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get minStock =>
      $composableBuilder(column: $table.minStock, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$ProductsTableTableTableManager extends RootTableManager<
    _$MasterDatabase,
    $ProductsTableTable,
    ProductsTableData,
    $$ProductsTableTableFilterComposer,
    $$ProductsTableTableOrderingComposer,
    $$ProductsTableTableAnnotationComposer,
    $$ProductsTableTableCreateCompanionBuilder,
    $$ProductsTableTableUpdateCompanionBuilder,
    (
      ProductsTableData,
      BaseReferences<_$MasterDatabase, $ProductsTableTable, ProductsTableData>
    ),
    ProductsTableData,
    PrefetchHooks Function()> {
  $$ProductsTableTableTableManager(
      _$MasterDatabase db, $ProductsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> sku = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<int> minStock = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              ProductsTableCompanion(
            id: id,
            sku: sku,
            name: name,
            unit: unit,
            category: category,
            minStock: minStock,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String sku,
            required String name,
            required String unit,
            required String category,
            Value<int> minStock = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              ProductsTableCompanion.insert(
            id: id,
            sku: sku,
            name: name,
            unit: unit,
            category: category,
            minStock: minStock,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProductsTableTableProcessedTableManager = ProcessedTableManager<
    _$MasterDatabase,
    $ProductsTableTable,
    ProductsTableData,
    $$ProductsTableTableFilterComposer,
    $$ProductsTableTableOrderingComposer,
    $$ProductsTableTableAnnotationComposer,
    $$ProductsTableTableCreateCompanionBuilder,
    $$ProductsTableTableUpdateCompanionBuilder,
    (
      ProductsTableData,
      BaseReferences<_$MasterDatabase, $ProductsTableTable, ProductsTableData>
    ),
    ProductsTableData,
    PrefetchHooks Function()>;
typedef $$SyncMetadataTableTableCreateCompanionBuilder
    = SyncMetadataTableCompanion Function({
  required String syncTable,
  required DateTime lastSyncedAt,
  Value<int> rowid,
});
typedef $$SyncMetadataTableTableUpdateCompanionBuilder
    = SyncMetadataTableCompanion Function({
  Value<String> syncTable,
  Value<DateTime> lastSyncedAt,
  Value<int> rowid,
});

class $$SyncMetadataTableTableFilterComposer
    extends Composer<_$MasterDatabase, $SyncMetadataTableTable> {
  $$SyncMetadataTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get syncTable => $composableBuilder(
      column: $table.syncTable, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));
}

class $$SyncMetadataTableTableOrderingComposer
    extends Composer<_$MasterDatabase, $SyncMetadataTableTable> {
  $$SyncMetadataTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get syncTable => $composableBuilder(
      column: $table.syncTable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$SyncMetadataTableTableAnnotationComposer
    extends Composer<_$MasterDatabase, $SyncMetadataTableTable> {
  $$SyncMetadataTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get syncTable =>
      $composableBuilder(column: $table.syncTable, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);
}

class $$SyncMetadataTableTableTableManager extends RootTableManager<
    _$MasterDatabase,
    $SyncMetadataTableTable,
    SyncMetadataTableData,
    $$SyncMetadataTableTableFilterComposer,
    $$SyncMetadataTableTableOrderingComposer,
    $$SyncMetadataTableTableAnnotationComposer,
    $$SyncMetadataTableTableCreateCompanionBuilder,
    $$SyncMetadataTableTableUpdateCompanionBuilder,
    (
      SyncMetadataTableData,
      BaseReferences<_$MasterDatabase, $SyncMetadataTableTable,
          SyncMetadataTableData>
    ),
    SyncMetadataTableData,
    PrefetchHooks Function()> {
  $$SyncMetadataTableTableTableManager(
      _$MasterDatabase db, $SyncMetadataTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetadataTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetadataTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetadataTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> syncTable = const Value.absent(),
            Value<DateTime> lastSyncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncMetadataTableCompanion(
            syncTable: syncTable,
            lastSyncedAt: lastSyncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String syncTable,
            required DateTime lastSyncedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncMetadataTableCompanion.insert(
            syncTable: syncTable,
            lastSyncedAt: lastSyncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncMetadataTableTableProcessedTableManager = ProcessedTableManager<
    _$MasterDatabase,
    $SyncMetadataTableTable,
    SyncMetadataTableData,
    $$SyncMetadataTableTableFilterComposer,
    $$SyncMetadataTableTableOrderingComposer,
    $$SyncMetadataTableTableAnnotationComposer,
    $$SyncMetadataTableTableCreateCompanionBuilder,
    $$SyncMetadataTableTableUpdateCompanionBuilder,
    (
      SyncMetadataTableData,
      BaseReferences<_$MasterDatabase, $SyncMetadataTableTable,
          SyncMetadataTableData>
    ),
    SyncMetadataTableData,
    PrefetchHooks Function()>;

class $MasterDatabaseManager {
  final _$MasterDatabase _db;
  $MasterDatabaseManager(this._db);
  $$CompaniesTableTableTableManager get companiesTable =>
      $$CompaniesTableTableTableManager(_db, _db.companiesTable);
  $$SuppliersTableTableTableManager get suppliersTable =>
      $$SuppliersTableTableTableManager(_db, _db.suppliersTable);
  $$ProductsTableTableTableManager get productsTable =>
      $$ProductsTableTableTableManager(_db, _db.productsTable);
  $$SyncMetadataTableTableTableManager get syncMetadataTable =>
      $$SyncMetadataTableTableTableManager(_db, _db.syncMetadataTable);
}
