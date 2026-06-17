import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';
import '../api/dio_client.dart';
import '../config/app_config.dart';
import '../services/reporting_service.dart';
import '../providers/company_provider.dart';
import '../theme/cupertino_theme_extensions.dart';
import '../theme/cupertino_spacing.dart';
import '../widgets/cupertino_glass_toast.dart';

class PdfPreviewScreen extends ConsumerStatefulWidget {
  final String title;
  final String? urlPath;
  final String? pdfUrl;

  const PdfPreviewScreen({
    super.key,
    required this.title,
    this.urlPath,
    this.pdfUrl,
  });

  @override
  ConsumerState<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends ConsumerState<PdfPreviewScreen> {
  bool _isExporting = false;

  bool get _shouldShowExcel {
    if (widget.urlPath == null) return false;
    final path = widget.urlPath!;
    return path.contains('pdf/purchase-request/') ||
        path.contains('pdf/purchase-order/') ||
        path.contains('pdf/receiving/') ||
        path.contains('pdf/payment-request/') ||
        path.contains('pdf/invoice/') ||
        path.contains('pdf/warehouse-transfer/') ||
        (path.contains('pdf/containers/') && path.contains('/packing-list')) ||
        path.contains('pdf/inventory-valuation');
  }

  Future<void> _exportExcel() async {
    if (widget.urlPath == null) return;
    setState(() => _isExporting = true);
    try {
      final path = widget.urlPath!;
      final dio = ref.read(dioProvider);

      final String apiPath;
      final List<String> headers;
      final List<List<dynamic>> rows = [];
      final String fileName = widget.title.replaceAll(' ', '_');

      if (path.contains('pdf/purchase-request/')) {
        final id = RegExp(r'pdf/purchase-request/(\d+)').firstMatch(path)?.group(1);
        if (id == null) throw Exception('ID record tidak valid');
        apiPath = 'wh/purchase-requests/$id';
        headers = ['NO', 'ITEM DESCRIPTION', 'QTY', 'UNIT', 'STATUS', 'LOCATION'];

        final response = await dio.get(apiPath);
        final data = response.data['data'];
        final details = data['details'] as List? ?? [];

        for (int i = 0; i < details.length; i++) {
          final item = details[i];
          final spec = item['dt_spec'] as String?;
          final note = item['dt_notes'] as String?;
          String desc = item['item_name'] ?? 'N/A';
          if (item['item_code'] != null) {
            desc += ' (#${item['item_code']})';
          }
          if (spec != null && spec.trim().isNotEmpty) {
            desc += '\nSPEC: $spec';
          }
          if (note != null && note.trim().isNotEmpty) {
            desc += '\nNOTE: $note';
          }

          final isDone = item['status'] == 'po_created';
          final status = isDone ? 'PO OK' : 'PENDING';

          rows.add([
            i + 1,
            desc,
            item['qty_requested'] ?? 0.0,
            item['uom_order'] ?? 'N/A',
            status,
            item['warehouse_name'] ?? '-',
          ]);
        }
      } else if (path.contains('pdf/purchase-order/')) {
        final id = RegExp(r'pdf/purchase-order/(\d+)').firstMatch(path)?.group(1);
        if (id == null) throw Exception('ID record tidak valid');
        apiPath = 'wh/purchase-orders/$id';
        headers = ['NO', 'DESCRIPTION', 'QTY', 'UNIT', 'PRICE', 'SUBTOTAL'];

        final response = await dio.get(apiPath);
        final data = response.data['data'];
        final items = data['items'] as List? ?? [];

        for (int i = 0; i < items.length; i++) {
          final item = items[i];
          final spec = item['detail_spec'] as String?;
          final note = item['detail_notes'] as String?;
          String desc = item['product_name'] ?? 'N/A';
          if (item['sku'] != null) {
            desc += ' (#${item['sku']})';
          }
          if (spec != null && spec.trim().isNotEmpty) {
            desc += '\nSPEC: $spec';
          }
          if (note != null && note.trim().isNotEmpty) {
            desc += '\nNOTE: $note';
          }

          final qty = double.tryParse(item['ordered_qty']?.toString() ?? '') ?? 0.0;
          final price = double.tryParse(item['unit_price']?.toString() ?? '') ?? 0.0;
          final subtotal = qty * price;

          rows.add([
            i + 1,
            desc,
            qty,
            item['unit'] ?? 'N/A',
            price,
            subtotal,
          ]);
        }
      } else if (path.contains('pdf/receiving/')) {
        final id = RegExp(r'pdf/receiving/(\d+)').firstMatch(path)?.group(1);
        if (id == null) throw Exception('ID record tidak valid');
        apiPath = 'wh/receivings/$id';
        headers = ['NO', 'DESCRIPTION', 'RECEIVED QTY', 'LOCATION'];

        final response = await dio.get(apiPath);
        final data = response.data['data'];
        final items = data['items'] as List? ?? [];

        for (int i = 0; i < items.length; i++) {
          final item = items[i];
          String desc = item['product_name'] ?? 'N/A';
          if (item['sku'] != null) {
            desc += ' (#${item['sku']})';
          }

          final qty = double.tryParse(item['quantity']?.toString() ?? '') ?? 0.0;

          rows.add([
            i + 1,
            desc,
            qty,
            item['location_name'] ?? 'Lokasi Utama',
          ]);
        }
      } else if (path.contains('pdf/payment-request/')) {
        final id = RegExp(r'pdf/payment-request/(\d+)').firstMatch(path)?.group(1);
        if (id == null) throw Exception('ID record tidak valid');
        apiPath = 'wh/payment-requests/$id';
        headers = ['NO', 'INVOICE NUMBER', 'DUE DATE', 'AMOUNT'];

        final response = await dio.get(apiPath);
        final data = response.data['data'];
        final invoices = data['invoices'] as List? ?? [];

        for (int i = 0; i < invoices.length; i++) {
          final inv = invoices[i];
          final amount = double.tryParse(inv['amount']?.toString() ?? '') ?? 0.0;

          rows.add([
            i + 1,
            inv['invoice_number'] ?? 'N/A',
            inv['due_date'] ?? '-',
            amount,
          ]);
        }
      } else if (path.contains('pdf/invoice/')) {
        final id = RegExp(r'pdf/invoice/(\d+)').firstMatch(path)?.group(1);
        if (id == null) throw Exception('ID record tidak valid');
        apiPath = 'wh/invoices/$id';
        headers = ['NO', 'DESCRIPTION', 'QTY', 'UNIT', 'PRICE', 'SUBTOTAL'];

        final response = await dio.get(apiPath);
        final data = response.data['data'];
        final items = data['items'] as List? ?? [];

        for (int i = 0; i < items.length; i++) {
          final item = items[i];
          String desc = item['product_name'] ?? 'N/A';
          if (item['product_code'] != null) {
            desc += ' (#${item['product_code']})';
          }

          final qty = double.tryParse(item['quantity']?.toString() ?? '') ?? 0.0;
          final price = double.tryParse(item['unit_price']?.toString() ?? '') ?? 0.0;
          final subtotal = double.tryParse(item['subtotal']?.toString() ?? '') ?? (qty * price);

          rows.add([
            i + 1,
            desc,
            qty,
            item['unit'] ?? 'N/A',
            price,
            subtotal,
          ]);
        }
      } else if (path.contains('pdf/warehouse-transfer/')) {
        final id = RegExp(r'pdf/warehouse-transfer/(\d+)').firstMatch(path)?.group(1);
        if (id == null) throw Exception('ID record tidak valid');
        apiPath = 'wh/transfers/$id';
        headers = ['NO', 'DESCRIPTION', 'QTY SENT', 'UNIT'];

        final response = await dio.get(apiPath);
        final data = response.data['data'];
        final items = data['items'] as List? ?? [];

        for (int i = 0; i < items.length; i++) {
          final item = items[i];
          final product = item['product'] as Map<String, dynamic>? ?? {};
          String desc = product['name'] ?? 'N/A';
          if (product['sku'] != null) {
            desc += ' (#${product['sku']})';
          }

          final qty = double.tryParse(item['qty_sent']?.toString() ?? '') ?? 0.0;

          rows.add([
            i + 1,
            desc,
            qty,
            product['unit'] ?? 'N/A',
          ]);
        }
      } else if (path.contains('pdf/containers/') && path.contains('/packing-list')) {
        final id = RegExp(r'pdf/containers/(\d+)/packing-list').firstMatch(path)?.group(1);
        if (id == null) throw Exception('ID record tidak valid');
        apiPath = 'wh/containers/$id';
        headers = ['NO', 'PO', 'DESCRIPTION', 'QTY', 'SATUAN'];

        final response = await dio.get(apiPath);
        final data = response.data['data'];
        final items = data['items'] as List? ?? [];

        for (int i = 0; i < items.length; i++) {
          final item = items[i];
          rows.add([
            i + 1,
            item['po_number'] ?? 'N/A',
            '${item['product_name'] ?? 'N/A'} (#${item['sku'] ?? 'N/A'})',
            double.tryParse(item['planned_qty']?.toString() ?? '') ?? 0.0,
            item['unit'] ?? 'N/A',
          ]);
        }
      } else if (path.contains('pdf/inventory-valuation')) {
        final selectedCompany = ref.read(selectedCompanyProvider);
        apiPath = 'wh/inventory-report/valuation';
        headers = ['NO', 'SKU', 'NAMA BARANG', 'GUDANG', 'QTY', 'SATUAN', 'HPP', 'TOTAL VALUASI'];

        final response = await dio.get(apiPath, queryParameters: {
          if (selectedCompany != null) 'company_id': selectedCompany.id,
          'detailed': 1,
        });
        final data = response.data['data'] as List? ?? [];

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
      } else {
        throw Exception('Jenis ekspor tidak didukung');
      }

      final service = ReportingService();
      if (mounted) {
        await service.exportToExcel(
          fileName: fileName,
          headers: headers,
          rows: rows,
          context: context,
        );
      }
    } catch (e) {
      if (mounted) {
        CupertinoGlassToast.showError(context, 'Gagal mengekspor Excel: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCompany = ref.watch(selectedCompanyProvider);
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.title),
        trailing: _shouldShowExcel
            ? (_isExporting
                ? const CupertinoActivityIndicator()
                : CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: _exportExcel,
                    child: const Icon(CupertinoIcons.table),
                  ))
            : null,
      ),
      child: SafeArea(
        child: PdfPreview(
          build: (format) async {
            final dio = ref.read(dioProvider);
            String targetUrl;

            if (widget.pdfUrl != null && widget.pdfUrl!.isNotEmpty) {
              targetUrl = widget.pdfUrl!;
            } else if (widget.urlPath != null && widget.urlPath!.isNotEmpty) {
              targetUrl = '${AppConfig.baseUrl.replaceAll('/api/v1/', '')}/${widget.urlPath}';
            } else {
              throw Exception('PDF URL or path not specified');
            }

            if (selectedCompany != null && !targetUrl.contains('company_id=')) {
              final separator = targetUrl.contains('?') ? '&' : '?';
              targetUrl = '$targetUrl${separator}company_id=${selectedCompany.id}';
            }

            debugPrint('Fetching PDF from: $targetUrl');
            final response = await dio.get<List<int>>(
              targetUrl,
              options: Options(
                responseType: ResponseType.bytes,
                receiveTimeout: const Duration(seconds: 120),
              ),
            );

            if (response.data == null || response.data!.isEmpty) {
              throw Exception('Empty PDF response from server');
            }

            return Uint8List.fromList(response.data!);
          },
          allowSharing: true,
          allowPrinting: true,
          canChangePageFormat: false,
          canChangeOrientation: false,
          pdfFileName: '${widget.title.replaceAll(' ', '_')}.pdf',
          loadingWidget: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CupertinoActivityIndicator(),
                const SizedBox(height: CupertinoSpacing.l),
                Text(
                  'Memuat dokumen PDF...', 
                  style: context.subhead.copyWith(decoration: TextDecoration.none),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
