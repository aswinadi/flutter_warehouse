/// Data models for Item Usage / Pemakaian Barang feature.
library;

// --------------------------------------------------------------------------
// ActivePond — a pond from an active cycle, resolved to its cost_centre_code.
// This replaces the raw CostCentre picker with a more user-friendly pond picker.
// --------------------------------------------------------------------------
class ActivePond {
  final int pondId;
  final String pondName;     // raw pond name, e.g. "1"
  final String modulName;    // modul name, e.g. "A"
  final String blokName;
  final String tambakName;
  final int cycleId;
  final String cycleName;    // e.g. "25"
  final String? costCentreCode;   // e.g. "ATT.MR01.2026.25" (null if not yet created)
  final String? parentCostCentreCode;
  final double luasM2;
  final bool ccIsActive;
  final String shortLabel;   // e.g. "A1"
  final String displayLabel; // e.g. "A1 — ATT.MR01.2026.25 (Siklus 25)"

  const ActivePond({
    required this.pondId,
    required this.pondName,
    required this.modulName,
    required this.blokName,
    required this.tambakName,
    required this.cycleId,
    required this.cycleName,
    this.costCentreCode,
    this.parentCostCentreCode,
    required this.luasM2,
    required this.ccIsActive,
    required this.shortLabel,
    required this.displayLabel,
  });

  factory ActivePond.fromJson(Map<String, dynamic> json) => ActivePond(
        pondId: (json['pond_id'] as num).toInt(),
        pondName: json['pond_name'] as String,
        modulName: json['modul_name'] as String,
        blokName: json['blok_name'] as String? ?? '',
        tambakName: json['tambak_name'] as String? ?? '',
        cycleId: (json['cycle_id'] as num).toInt(),
        cycleName: json['cycle_name'] as String,
        costCentreCode: json['cost_centre_code'] as String?,
        parentCostCentreCode: json['parent_cost_centre_code'] as String?,
        luasM2: (json['luas_m2'] as num?)?.toDouble() ?? 0,
        ccIsActive: (json['cc_is_active'] as bool?) ?? false,
        shortLabel: json['short_label'] as String? ??
            '${json['modul_name']}${json['pond_name']}',
        displayLabel: json['display_label'] as String? ??
            '${json['modul_name']}${json['pond_name']}',
      );
}

// --------------------------------------------------------------------------
// CostCentreChild — a child with its projected qty split (from preview API).
// --------------------------------------------------------------------------
class CostCentreChild {
  final String code;
  final String name;
  final double luasM2;
  final double? sharePercent;
  final double qty;

  const CostCentreChild({
    required this.code,
    required this.name,
    required this.luasM2,
    this.sharePercent,
    required this.qty,
  });

  factory CostCentreChild.fromJson(Map<String, dynamic> json) =>
      CostCentreChild(
        code: json['code'] as String,
        name: json['name'] as String,
        luasM2: (json['luas_m2'] as num?)?.toDouble() ?? 0,
        sharePercent: (json['share_percent'] as num?)?.toDouble(),
        qty: (json['qty'] as num).toDouble(),
      );
}

// --------------------------------------------------------------------------
// WarehouseOption — simple warehouse for picker.
// --------------------------------------------------------------------------
class WarehouseOption {
  final int id;
  final String code;
  final String name;

  const WarehouseOption({
    required this.id,
    required this.code,
    required this.name,
  });

  factory WarehouseOption.fromJson(Map<String, dynamic> json) =>
      WarehouseOption(
        id: (json['id'] as num).toInt(),
        code: json['code'] as String,
        name: json['name'] as String,
      );

  String get displayLabel => '$code — $name';
}

// --------------------------------------------------------------------------
// UsageLine — one item+pond allocation entry on the usage form.
// The same inventory item can appear multiple times with different ponds.
// --------------------------------------------------------------------------
class UsageLine {
  final int inventoryId;
  final String productName;
  final String sku;
  final String? unit;
  final double availableQty;
  final double usageQty;
  final ActivePond? pond; // per-line pond selection (nullable until set)

  const UsageLine({
    required this.inventoryId,
    required this.productName,
    required this.sku,
    this.unit,
    required this.availableQty,
    required this.usageQty,
    this.pond,
  });

  UsageLine copyWith({
    double? usageQty,
    ActivePond? pond,
    bool clearPond = false,
  }) =>
      UsageLine(
        inventoryId: inventoryId,
        productName: productName,
        sku: sku,
        unit: unit,
        availableQty: availableQty,
        usageQty: usageQty ?? this.usageQty,
        pond: clearPond ? null : (pond ?? this.pond),
      );

  Map<String, dynamic> toJson() => {
        'inventory_id': inventoryId,
        'quantity': usageQty,
        'cost_centre_code': pond?.costCentreCode ?? '',
      };
}
