class InventoryValuation {
  final String sku;
  final String productName;
  final String productUnit;
  final double quantity;
  final double hpp;
  final double totalValuation;

  InventoryValuation({
    required this.sku,
    required this.productName,
    required this.productUnit,
    required this.quantity,
    required this.hpp,
    required this.totalValuation,
  });

  factory InventoryValuation.fromJson(Map<String, dynamic> json) {
    return InventoryValuation(
      sku: json['sku'] ?? '',
      productName: json['product_name'] ?? 'Unknown',
      productUnit: json['product_unit'] ?? 'pcs',
      quantity: double.tryParse(json['quantity']?.toString() ?? '') ?? 0.0,
      hpp: double.tryParse(json['hpp']?.toString() ?? '') ?? 0.0,
      totalValuation: double.tryParse(json['total_valuation']?.toString() ?? '') ?? 0.0,
    );
  }
}

class InventoryValuationBreakdown {
  final String warehouseName;
  final String locationCode;
  final double quantity;
  final double hpp;
  final double totalValuation;

  InventoryValuationBreakdown({
    required this.warehouseName,
    required this.locationCode,
    required this.quantity,
    required this.hpp,
    required this.totalValuation,
  });

  factory InventoryValuationBreakdown.fromJson(Map<String, dynamic> json) {
    return InventoryValuationBreakdown(
      warehouseName: json['warehouse_name'] ?? 'Unknown Warehouse',
      locationCode: json['location_code'] ?? 'Belum Ditentukan',
      quantity: double.tryParse(json['quantity']?.toString() ?? '') ?? 0.0,
      hpp: double.tryParse(json['hpp']?.toString() ?? '') ?? 0.0,
      totalValuation: double.tryParse(json['total_valuation']?.toString() ?? '') ?? 0.0,
    );
  }
}
