import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            SizedBox(width: 12),
            Text('Menyiapkan file PDF...'),
          ],
        ),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      final dio = ref.read(dioProvider);
      final selectedCompany = ref.read(selectedCompanyProvider);
      final String queryStr = selectedCompany != null ? '?company_id=${selectedCompany.id}' : '';
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
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('Berhasil mengunduh PDF ke folder Downloads.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await Printing.sharePdf(bytes: bytes, filename: 'Laporan_Valuasi_Inventaris.pdf');
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Gagal mengunduh PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _downloadExcel() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            SizedBox(width: 12),
            Text('Menyiapkan file Excel...'),
          ],
        ),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      final dio = ref.read(dioProvider);
      final selectedCompany = ref.read(selectedCompanyProvider);
      const apiPath = 'wh/inventory-report/valuation';
      
      final response = await dio.get(apiPath, queryParameters: {
        if (selectedCompany != null) 'company_id': selectedCompany.id,
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

      final service = ReportingService();
      await service.exportToExcel(
        fileName: 'Laporan_Valuasi_Inventaris',
        headers: headers,
        rows: rows,
        context: context,
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Gagal mengunduh Excel: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 900;
    final valuationAsync = ref.watch(inventoryValuationListProvider(_searchText));
    
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari SKU atau Produk...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchText = null;
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (val) {
                setState(() {
                  _searchText = val.trim().isEmpty ? null : val.trim();
                });
              },
            ),
          ),
          Expanded(
            child: valuationAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada valuasi inventaris ditemukan'),
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
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = isLargeScreen && item.sku == _selectedSku;

                    return Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFF6E56CF) : CupertinoColors.separator.resolveFrom(context),
                          width: isSelected ? 2 : 0.5,
                        ),
                      ),
                      color: isSelected 
                          ? const Color(0xFF6E56CF).withValues(alpha: 0.08) 
                          : CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                      child: ListTile(
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
                        title: Text(
                          item.productName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.label.resolveFrom(context),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SKU: ${item.sku}',
                                style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'HPP: ${_formatCurrency(item.hpp)}',
                                style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                              ),
                            ],
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _formatCurrency(item.totalValuation),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6E56CF),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${_formatQty(item.quantity)} ${item.productUnit}',
                              style: TextStyle(
                                fontSize: 12,
                                color: CupertinoColors.secondaryLabel.resolveFrom(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        foregroundColor: CupertinoColors.label.resolveFrom(context),
        title: const Text('Valuasi Inventaris'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            tooltip: 'Unduh PDF',
            onPressed: _downloadPdf,
          ),
          IconButton(
            icon: const Icon(Icons.table_view_outlined),
            tooltip: 'Ekspor Excel',
            onPressed: _downloadExcel,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isLargeScreen
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: buildLeftPane(),
                ),
                const VerticalDivider(
                  width: 1,
                  color: Colors.white10,
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
                                Icon(Icons.analytics_outlined, size: 48, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                                const SizedBox(height: 16),
                                Text(
                                  'Pilih barang untuk melihat rincian valuasi',
                                  style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context), fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            )
          : buildLeftPane(),
    );
  }

  void _showValuationDetailBottomSheet(BuildContext context, InventoryValuation item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final double sheetHeight = MediaQuery.of(context).size.height * 0.85;
        return Container(
          height: sheetHeight,
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: CupertinoColors.separator.resolveFrom(context),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rincian Valuasi Barang',
                      style: TextStyle(
                        color: CupertinoColors.label.resolveFrom(context),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: CupertinoColors.label.resolveFrom(context)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Divider(color: CupertinoColors.separator.resolveFrom(context)),
              Expanded(
                child: ValuationDetailPane(item: item),
              ),
            ],
          ),
        );
      },
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

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.productName,
                style: TextStyle(
                  color: CupertinoColors.label.resolveFrom(context),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'SKU: ${item.sku}',
                style: TextStyle(
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TOTAL STOK',
                        style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context), fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_formatQty(item.quantity)} ${item.productUnit}',
                        style: TextStyle(color: CupertinoColors.label.resolveFrom(context), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'TOTAL VALUE',
                        style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context), fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatCurrency(item.totalValuation),
                        style: const TextStyle(color: Color(0xFF6E56CF), fontSize: 18, fontWeight: FontWeight.bold),
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
                    style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: breakdowns.length,
                itemBuilder: (context, index) {
                  final bd = breakdowns[index];
                  return Card(
                    color: CupertinoColors.systemBackground.resolveFrom(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                bd.warehouseName,
                                style: TextStyle(
                                  color: CupertinoColors.label.resolveFrom(context),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                _formatCurrency(bd.totalValuation),
                                style: const TextStyle(
                                  color: Color(0xFF6E56CF),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Lokasi: ${bd.locationCode}',
                                style: TextStyle(
                                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '${_formatQty(bd.quantity)} ${item.productUnit}',
                                style: TextStyle(
                                  color: CupertinoColors.label.resolveFrom(context),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Text(
                'Gagal memuat rincian: $err',
                style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
