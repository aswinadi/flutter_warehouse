import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportingService {
  Future<void> generateAndShareExcel(String fileName, List<String> headers, List<List<dynamic>> rows) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    sheet.appendRow(headers.map((e) => TextCellValue(e)).toList());
    for (var row in rows) {
      sheet.appendRow(row.map((e) {
        if (e == null) return null;
        if (e is int) return IntCellValue(e);
        if (e is double) return DoubleCellValue(e);
        if (e is bool) return BoolCellValue(e);
        return TextCellValue(e.toString());
      }).toList());
    }

    final bytes = excel.encode();
    if (bytes != null) {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName.xlsx');
      await file.writeAsBytes(bytes);
      await Printing.sharePdf(bytes: Uint8List.fromList(bytes), filename: '$fileName.xlsx');
    }
  }

  Future<void> exportToExcel({
    required String fileName,
    required List<String> headers,
    required List<List<dynamic>> rows,
    BuildContext? context,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    sheet.appendRow(headers.map((e) => TextCellValue(e)).toList());
    for (var row in rows) {
      sheet.appendRow(row.map((e) {
        if (e == null) return null;
        if (e is int) return IntCellValue(e);
        if (e is double) return DoubleCellValue(e);
        if (e is bool) return BoolCellValue(e);
        return TextCellValue(e.toString());
      }).toList());
    }

    final bytes = excel.encode();
    if (bytes == null) {
      throw Exception('Gagal mengodekan file Excel');
    }

    final uint8Bytes = Uint8List.fromList(bytes);

    if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
      final dir = await getDownloadsDirectory();
      if (dir != null) {
        final filePath = '${dir.path}/$fileName.xlsx';
        final file = File(filePath);
        await file.writeAsBytes(uint8Bytes);

        // Open the saved file using default platform app
        try {
          if (Platform.isWindows) {
            await Process.run('explorer.exe', [filePath.replaceAll('/', '\\')]);
          } else if (Platform.isMacOS) {
            await Process.run('open', [filePath]);
          } else if (Platform.isLinux) {
            await Process.run('xdg-open', [filePath]);
          }
        } catch (e) {
          // Ignore failure to open file
        }

        if (context != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Berhasil mengunduh Excel ke folder Downloads: $fileName.xlsx'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } else {
        throw Exception('Tidak dapat menemukan folder Downloads');
      }
    } else {
      // Mobile / Web
      await Printing.sharePdf(bytes: uint8Bytes, filename: '$fileName.xlsx');
    }
  }

  Future<void> generateAndPrintPdf(String title, List<String> headers, List<List<String>> rows) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          children: [
            pw.Text(title, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headers: headers,
              data: rows,
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }
}

