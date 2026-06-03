import 'dart:io';
import 'dart:typed_data';
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
