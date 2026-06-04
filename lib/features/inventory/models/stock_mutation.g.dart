// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_mutation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StockMutationSummaryImpl _$$StockMutationSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$StockMutationSummaryImpl(
      sku: json['sku'] as String,
      productName: json['product_name'] as String,
      unit: json['unit'] as String,
      initialBalance: (json['initial_balance'] as num).toInt(),
      periodIn: (json['period_in'] as num).toInt(),
      periodOut: (json['period_out'] as num).toInt(),
      endingBalance: (json['ending_balance'] as num).toInt(),
      packagings: json['packagings'] as List<dynamic>? ?? const [],
    );

Map<String, dynamic> _$$StockMutationSummaryImplToJson(
        _$StockMutationSummaryImpl instance) =>
    <String, dynamic>{
      'sku': instance.sku,
      'product_name': instance.productName,
      'unit': instance.unit,
      'initial_balance': instance.initialBalance,
      'period_in': instance.periodIn,
      'period_out': instance.periodOut,
      'ending_balance': instance.endingBalance,
      'packagings': instance.packagings,
    };

_$StockMutationDetailImpl _$$StockMutationDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$StockMutationDetailImpl(
      id: (json['id'] as num).toInt(),
      date: json['date'] as String,
      type: json['type'] as String,
      sku: json['sku'] as String,
      productName: json['product_name'] as String,
      unit: json['unit'] as String,
      description: stringOrNullFromJson(json['description']),
      refNumber: stringOrNullFromJson(json['ref_number']),
      inQty: doubleFromJson(json['in_qty']),
      outQty: doubleFromJson(json['out_qty']),
    );

Map<String, dynamic> _$$StockMutationDetailImplToJson(
        _$StockMutationDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'type': instance.type,
      'sku': instance.sku,
      'product_name': instance.productName,
      'unit': instance.unit,
      'description': instance.description,
      'ref_number': instance.refNumber,
      'in_qty': instance.inQty,
      'out_qty': instance.outQty,
    };

_$StockMutationHeaderImpl _$$StockMutationHeaderImplFromJson(
        Map<String, dynamic> json) =>
    _$StockMutationHeaderImpl(
      initialBalance: (json['initial_balance'] as num).toInt(),
      totalIn: (json['total_in'] as num).toInt(),
      totalOut: (json['total_out'] as num).toInt(),
      endingBalance: (json['ending_balance'] as num).toInt(),
    );

Map<String, dynamic> _$$StockMutationHeaderImplToJson(
        _$StockMutationHeaderImpl instance) =>
    <String, dynamic>{
      'initial_balance': instance.initialBalance,
      'total_in': instance.totalIn,
      'total_out': instance.totalOut,
      'ending_balance': instance.endingBalance,
    };
