import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';
import '../api/dio_client.dart';
import '../config/app_config.dart';

class PdfPreviewScreen extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A), // Navy Slate
        foregroundColor: Colors.white,
        title: Text(title),
      ),
      body: PdfPreview(
        build: (format) async {
          final dio = ref.read(dioProvider);
          final String targetUrl;
          
          if (pdfUrl != null && pdfUrl!.isNotEmpty) {
            targetUrl = pdfUrl!;
          } else if (urlPath != null && urlPath!.isNotEmpty) {
            targetUrl = '${AppConfig.baseUrl.replaceAll('/api/v1/', '')}/$urlPath';
          } else {
            throw Exception('PDF URL or path not specified');
          }

          debugPrint('Fetching PDF from: $targetUrl');
          final response = await dio.get<List<int>>(
            targetUrl,
            options: Options(responseType: ResponseType.bytes),
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
        pdfFileName: '${title.replaceAll(' ', '_')}.pdf',
        loadingWidget: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF6E56CF)),
              SizedBox(height: 16),
              Text('Memuat dokumen PDF...'),
            ],
          ),
        ),
      ),
    );
  }
}
