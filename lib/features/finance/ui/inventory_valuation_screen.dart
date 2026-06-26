import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:dio/dio.dart';
import '../models/inventory_valuation.dart';
import '../providers/inventory_valuation_provider.dart';
import '../../../core/widgets/company_switcher.dart';
import '../../../core/providers/company_provider.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/config/app_config.dart';
import '../../../core/services/reporting_service.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';
import '../../../core/widgets/cupertino_glass_dialog.dart';

class InventoryValuationScreen extends ConsumerStatefulWidget {
  const InventoryValuationScreen({super.key});

  @override
  ConsumerState<InventoryValuationScreen> createState() => _InventoryValuationScreenState();
}

class _InventoryValuationScreenState extends ConsumerState<InventoryValuationScreen> {
  String? _searchText;
  final TextEditingController _searchController = TextEditingController();
  String? _selectedSku;
  InventoryValuation? _selectedItem;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  String _formatQty(double qty) {
    final formatter = NumberFormat.decimalPattern('id_ID');
    return formatter.format(qty);
  }

  Future<void> _downloadPdf() async {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const CupertinoGlassDialog(
        actions: [],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoActivityIndicator(radius: 14),
            SizedBox(height: CupertinoSpacing.m),
            Text('Menyiapkan file PDF...'),
          ],
        ),
      ),
    );

    try {
      final dio = ref.read(dioProvider);
      final selectedCompany = ref.read(selectedCompanyProvider);
      final showEmpty = ref.read(showEmptyValuationStockProvider);
      final List<String> params = [];
      if (selectedCompany != null) params.add('company_id=${selectedCompany.id}');
      if (showEmpty) params.add('show_empty=1');
      final String queryStr = params.isNotEmpty ? '?' + params.join('&') : '';
      final targetUrl = '${AppConfig.baseUrl.replaceAll('/api/v1/', '')}/pdf/inventory-valuation$queryStr';

      final response = await dio.get<List<int>>(
        targetUrl,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 120),
        ),
      );

      final bytes = Uint8List.fromList(response.data!);
      
      if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
        final dir = await getDownloadsDirectory();
        if (dir != null) {
          final filePath = '${dir.path}/Laporan_Valuasi_Inventaris.pdf';
          final file = File(filePath);
          await file.writeAsBytes(bytes);
          
          if (Platform.isWindows) {
            await Process.run('explorer.exe', [filePath.replaceAll('/', '\\')]);
          }
          
          if (mounted) Navigator.pop(context); // Dismiss loading

          if (mounted) {
            CupertinoGlassToast.showSuccess(context, 'Berhasil mengunduh PDF ke folder Downloads.');
          }
        } else {
          if (mounted) Navigator.pop(context); // Dismiss loading
        }
      } else {
        await Printing.sharePdf(bytes: bytes, filename: 'Laporan_Valuasi_Inventaris.pdf');
        if (mounted) Navigator.pop(context); // Dismiss loading
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // Dismiss loading
      if (mounted) {
        CupertinoGlassToast.showError(context, 'Gagal mengunduh PDF: $e');
      }
    }
  }

  Future<void> _downloadExcel() async {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const CupertinoGlassDialog(
        actions: [],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoActivityIndicator(radius: 14),
            SizedBox(height: CupertinoSpacing.m),
            Text('Menyiapkan file Excel...'),
          ],
        ),
      ),
    );

    try {
      final dio = ref.read(dioProvider);
      final selectedCompany = ref.read(selectedCompanyProvider);
      final showEmpty = ref.read(showEmptyValuationStockProvider);
      const apiPath = 'wh/inventory-report/valuation';
      
      final response = await dio.get(apiPath, queryParameters: {
        if (selectedCompany != null) 'company_id': selectedCompany.id,
        'show_empty': showEmpty ? 1 : 0,
        'detailed': 1,
      });

      final data = response.data['data'] as List? ?? [];
      final headers = ['NO', 'SKU', 'NAMA BARANG', 'GUDANG', 'QTY', 'SATUAN', 'HPP', 'TOTAL VALUASI'];
      final List<List<dynamic>> rows = [];

      for (int i = 0; i < data.length; i++) {
        final item = data[i];
        rows.add([
          i + 1,
          item['sku'] ?? 'N/A',
          item['product_name'] ?? 'N/A',
          item['warehouse_name'] ?? 'N/A',
          double.tryParse(item['quantity']?.toString() ?? '') ?? 0.0,
          item['product_unit'] ?? 'pcs',
          double.tryParse(item['hpp']?.toString() ?? '') ?? 0.0,
          double.tryParse(item['total_valuation']?.toString() ?? '') ?? 0.0,
        ]);
      }

      if (mounted) Navigator.pop(context); // Dismiss loading

      final service = ReportingService();
      if (mounted) {
        await service.exportToExcel(
          fileName: 'Laporan_Valuasi_Inventaris',
          headers: headers,
          rows: rows,
          context: context,
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // Dismiss loading
      if (mounted) {
        CupertinoGlassToast.showError(context, 'Gagal mengunduh Excel: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 900;
    final valuationAsync = ref.watch(inventoryValuationListProvider(_searchText));
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);
    final bgColor = CupertinoColors.systemGroupedBackground.resolveFrom(context);
    
    ref.listen(selectedCompanyProvider, (previous, next) {
      if (previous != next) {
        setState(() {
          _selectedSku = null;
          _selectedItem = null;
        });
      }
    });

    Widget buildLeftPane() {
      return Column(
        children: [
          const CompanySwitcher(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.halfScreenMargin),
            child: CupertinoSearchTextField(
              controller: _searchController,
              placeholder: 'Cari SKU atau Produk...',
              onChanged: (val) {
                if (val.isEmpty) {
                  setState(() {
                    _searchText = null;
                  });
                }
              },
              onSubmitted: (val) {
                setState(() {
                  _searchText = val.trim().isEmpty ? null : val.trim();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: CupertinoSpacing.screenMargin,
              vertical: CupertinoSpacing.xs,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tampilkan Stok Kosong',
                  style: context.subhead.copyWith(color: secondaryLabelColor),
                ),
                CupertinoSwitch(
                  value: ref.watch(showEmptyValuationStockProvider),
                  onChanged: (val) {
                    ref.read(showEmptyValuationStockProvider.notifier).state = val;
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: valuationAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Text(
                      'Tidak ada valuasi inventaris ditemukan',
                      style: context.body.copyWith(color: secondaryLabelColor),
                    ),
                  );
                }

                if (isLargeScreen && _selectedSku == null && items.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _selectedSku = items.first.sku;
                      _selectedItem = items.first;
                    });
                  });
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const SizedBox(height: CupertinoSpacing.m),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = isLargeScreen && item.sku == _selectedSku;

                    return CupertinoGlassContainer(
                      borderRadius: CupertinoSpacing.cardRadius + 2,
                      backgroundColor: isSelected 
                          ? CupertinoColors.activeBlue.withValues(alpha: 0.08) 
                          : null,
                      borderColor: isSelected 
                          ? CupertinoColors.activeBlue 
                          : null,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (isLargeScreen) {
                            setState(() {
                              _selectedSku = item.sku;
                              _selectedItem = item;
                            });
                          } else {
                            _showValuationDetailBottomSheet(context, item);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.productName,
                                      style: context.subhead.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: labelColor,
                                      ),
                                    ),
                                    const SizedBox(height: CupertinoSpacing.xs + 2),
                                    Text(
                                      'SKU: ${item.sku}',
                                      style: context.footnote.copyWith(
                                        color: secondaryLabelColor,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'HPP: ${_formatCurrency(item.hpp)}',
                                      style: context.footnote.copyWith(
                                        color: secondaryLabelColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: CupertinoSpacing.screenMargin),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _formatCurrency(item.totalValuation),
                                    style: context.footnote.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: CupertinoColors.activeBlue,
                                    ),
                                  ),
                                  const SizedBox(height: CupertinoSpacing.xs),
                                  Text(
                                    '${_formatQty(item.quantity)} ${item.productUnit}',
                                    style: context.caption1.copyWith(
                                      color: secondaryLabelColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (err, stack) => Center(
                child: Text(
                  'Error: $err',
                  style: context.body.copyWith(color: secondaryLabelColor),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return CupertinoPageScaffold(
      backgroundColor: bgColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        middle: Text(
          'Valuasi Inventaris',
          style: context.headline.copyWith(color: labelColor),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: const Size.square(32),
              onPressed: _downloadPdf,
              child: const Icon(CupertinoIcons.doc_text, size: 22),
            ),
            const SizedBox(width: CupertinoSpacing.s),
            CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: const Size.square(32),
              onPressed: _downloadExcel,
              child: const Icon(CupertinoIcons.table, size: 22),
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: isLargeScreen
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: buildLeftPane(),
                  ),
                  Container(
                    width: 1,
                    color: CupertinoColors.separator.resolveFrom(context),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                      child: _selectedSku != null && _selectedItem != null
                          ? ValuationDetailPane(item: _selectedItem!)
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.chart_bar, size: 48, color: secondaryLabelColor),
                                  const SizedBox(height: CupertinoSpacing.l),
                                  Text(
                                    'Pilih barang untuk melihat rincian valuasi',
                                    style: context.subhead.copyWith(color: secondaryLabelColor, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ],
              )
            : buildLeftPane(),
      ),
    );
  }

  void _showValuationDetailBottomSheet(BuildContext context, InventoryValuation item) {
    final double sheetHeight = MediaQuery.of(context).size.height * 0.85;
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: sheetHeight,
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              const SizedBox(height: CupertinoSpacing.m),
              Center(
                child: Container(
                  width: 36,
                  height: 5,
                  decoration: BoxDecoration(
                    color: CupertinoColors.separator.resolveFrom(context),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              const SizedBox(height: CupertinoSpacing.s),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.xl, vertical: CupertinoSpacing.s),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rincian Valuasi Barang',
                      style: context.title3.copyWith(
                        color: CupertinoColors.label.resolveFrom(context),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size.square(32),
                      child: Icon(
                        CupertinoIcons.xmark_circle_fill,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: ValuationDetailPane(item: item),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ValuationDetailPane extends ConsumerWidget {
  final InventoryValuation item;

  const ValuationDetailPane({super.key, required this.item});

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  String _formatQty(double qty) {
    final formatter = NumberFormat.decimalPattern('id_ID');
    return formatter.format(qty);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakdownAsync = ref.watch(inventoryValuationBreakdownProvider(item.sku));
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
          padding: const EdgeInsets.all(CupertinoSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.productName,
                style: context.title3.copyWith(
                  color: labelColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: CupertinoSpacing.s),
              Text(
                'SKU: ${item.sku}',
                style: context.subhead.copyWith(
                  color: secondaryLabelColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: CupertinoSpacing.l),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TOTAL STOK',
                        style: context.caption2.copyWith(color: secondaryLabelColor, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: CupertinoSpacing.xs),
                      Text(
                        '${_formatQty(item.quantity)} ${item.productUnit}',
                        style: context.callout.copyWith(color: labelColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'TOTAL VALUE',
                        style: context.caption2.copyWith(color: secondaryLabelColor, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: CupertinoSpacing.xs),
                      Text(
                        _formatCurrency(item.totalValuation),
                        style: context.title3.copyWith(color: CupertinoColors.activeBlue, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: breakdownAsync.when(
            data: (breakdowns) {
              if (breakdowns.isEmpty) {
                return Center(
                  child: Text(
                    'Tidak ada rincian gudang',
                    style: context.body.copyWith(color: secondaryLabelColor),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(CupertinoSpacing.xl),
                itemCount: breakdowns.length,
                itemBuilder: (context, index) {
                  final bd = breakdowns[index];
                  return CupertinoGlassContainer(
                    margin: const EdgeInsets.only(bottom: CupertinoSpacing.m),
                    padding: const EdgeInsets.all(CupertinoSpacing.l),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              bd.warehouseName,
                              style: context.subhead.copyWith(
                                color: labelColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              _formatCurrency(bd.totalValuation),
                              style: context.body.copyWith(
                                color: CupertinoColors.activeBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: CupertinoSpacing.s),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Lokasi: ${bd.locationCode}',
                              style: context.caption1.copyWith(
                                color: secondaryLabelColor,
                              ),
                            ),
                            Text(
                              '${_formatQty(bd.quantity)} ${item.productUnit}',
                              style: context.caption1.copyWith(
                                color: labelColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (err, stack) => Center(
              child: Text(
                'Gagal memuat rincian: $err',
                style: context.body.copyWith(color: secondaryLabelColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
