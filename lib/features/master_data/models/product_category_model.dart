class ProductCategoryModel {
  final int id;
  final int companyId;
  final String code;
  final String name;
  final int? parentId;
  final String? parentName;
  final String? description;
  final int? inventoryAccountId;
  final String? inventoryAccountName;
  final int? cogsAccountId;
  final String? cogsAccountName;
  final int? salesAccountId;
  final String? salesAccountName;
  final int? salesReturnAccountId;
  final String? salesReturnAccountName;
  final int? salesDiscountAccountId;
  final String? salesDiscountAccountName;
  final int? purchaseReturnAccountId;
  final String? purchaseReturnAccountName;
  final int? inventoryAdjustmentAccountId;
  final String? inventoryAdjustmentAccountName;
  final int? taxRateId;
  final String? taxRateName;
  final bool isActive;

  ProductCategoryModel({
    required this.id,
    required this.companyId,
    required this.code,
    required this.name,
    this.parentId,
    this.parentName,
    this.description,
    this.inventoryAccountId,
    this.inventoryAccountName,
    this.cogsAccountId,
    this.cogsAccountName,
    this.salesAccountId,
    this.salesAccountName,
    this.salesReturnAccountId,
    this.salesReturnAccountName,
    this.salesDiscountAccountId,
    this.salesDiscountAccountName,
    this.purchaseReturnAccountId,
    this.purchaseReturnAccountName,
    this.inventoryAdjustmentAccountId,
    this.inventoryAdjustmentAccountName,
    this.taxRateId,
    this.taxRateName,
    this.isActive = true,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: json['id'] as int,
      companyId: json['company_id'] as int,
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      parentId: json['parent_id'] as int?,
      parentName: json['parent'] != null ? json['parent']['name'] as String? : null,
      description: json['description'] as String?,
      inventoryAccountId: json['inventory_account_id'] as int?,
      inventoryAccountName: json['inventory_account'] != null ? json['inventory_account']['coa_name'] as String? : null,
      cogsAccountId: json['cogs_account_id'] as int?,
      cogsAccountName: json['cogs_account'] != null ? json['cogs_account']['coa_name'] as String? : null,
      salesAccountId: json['sales_account_id'] as int?,
      salesAccountName: json['sales_account'] != null ? json['sales_account']['coa_name'] as String? : null,
      salesReturnAccountId: json['sales_return_account_id'] as int?,
      salesReturnAccountName: json['sales_return_account'] != null ? json['sales_return_account']['coa_name'] as String? : null,
      salesDiscountAccountId: json['sales_discount_account_id'] as int?,
      salesDiscountAccountName: json['sales_discount_account'] != null ? json['sales_discount_account']['coa_name'] as String? : null,
      purchaseReturnAccountId: json['purchase_return_account_id'] as int?,
      purchaseReturnAccountName: json['purchase_return_account'] != null ? json['purchase_return_account']['coa_name'] as String? : null,
      inventoryAdjustmentAccountId: json['inventory_adjustment_account_id'] as int?,
      inventoryAdjustmentAccountName: json['inventory_adjustment_account'] != null ? json['inventory_adjustment_account']['coa_name'] as String? : null,
      taxRateId: json['tax_rate_id'] as int?,
      taxRateName: json['tax_rate'] != null ? json['tax_rate']['name'] as String? : null,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'code': code,
      'name': name,
      'parent_id': parentId,
      'description': description,
      'inventory_account_id': inventoryAccountId,
      'cogs_account_id': cogsAccountId,
      'sales_account_id': salesAccountId,
      'sales_return_account_id': salesReturnAccountId,
      'sales_discount_account_id': salesDiscountAccountId,
      'purchase_return_account_id': purchaseReturnAccountId,
      'inventory_adjustment_account_id': inventoryAdjustmentAccountId,
      'tax_rate_id': taxRateId,
      'is_active': isActive,
    };
  }
}
