class RunningStockItem {
  final int id;
  final String sku;
  final String name;
  final String unit;
  final int? companyId;
  final double onHandQty;
  final double inTransitQty;
  final double orderedQty;
  final double totalQty;

  RunningStockItem({
    required this.id,
    required this.sku,
    required this.name,
    required this.unit,
    this.companyId,
    required this.onHandQty,
    required this.inTransitQty,
    required this.orderedQty,
    required this.totalQty,
  });

  factory RunningStockItem.fromJson(Map<String, dynamic> json) {
    return RunningStockItem(
      id: json['id'] as int? ?? 0,
      sku: json['sku'] as String? ?? '',
      name: json['name'] as String? ?? '',
      unit: json['unit'] as String? ?? 'pcs',
      companyId: json['company_id'] as int?,
      onHandQty: (json['on_hand_qty'] as num?)?.toDouble() ?? 0.0,
      inTransitQty: (json['in_transit_qty'] as num?)?.toDouble() ?? 0.0,
      orderedQty: (json['ordered_qty'] as num?)?.toDouble() ?? 0.0,
      totalQty: (json['total_qty'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'name': name,
      'unit': unit,
      'company_id': companyId,
      'on_hand_qty': onHandQty,
      'in_transit_qty': inTransitQty,
      'ordered_qty': orderedQty,
      'total_qty': totalQty,
    };
  }
}

class RunningStockFilterState {
  final bool filterOnHand;
  final bool filterInTransit;
  final bool filterOrdered;
  final bool showEmpty;

  const RunningStockFilterState({
    this.filterOnHand = true,
    this.filterInTransit = true,
    this.filterOrdered = true,
    this.showEmpty = false,
  });

  RunningStockFilterState copyWith({
    bool? filterOnHand,
    bool? filterInTransit,
    bool? filterOrdered,
    bool? showEmpty,
  }) {
    return RunningStockFilterState(
      filterOnHand: filterOnHand ?? this.filterOnHand,
      filterInTransit: filterInTransit ?? this.filterInTransit,
      filterOrdered: filterOrdered ?? this.filterOrdered,
      showEmpty: showEmpty ?? this.showEmpty,
    );
  }
}
