import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../widgets/cupertino_glass_toast.dart';

/// Downloads an Excel (.xlsx) file from [url] and saves it to the Downloads
/// folder on desktop or opens a share/save dialog on mobile/web.
///
/// [context]  – current BuildContext for showing toasts
/// [dio]      – the authenticated Dio instance
/// [url]      – full URL to the `/excel/*` endpoint
/// [fileName] – base filename (without extension), e.g. `'PO-MAX-001'`
Future<void> downloadExcel(
  BuildContext context,
  Dio dio,
  String url,
  String fileName,
) async {
  bool dialogOpen = true;
  BuildContext? dialogContext;

  showCupertinoDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      dialogContext = ctx;
      return Center(
        child: SizedBox(
          width: 220,
          height: 100,
          child: CupertinoPageScaffold(
            backgroundColor: CupertinoColors.black.withValues(alpha: 0.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.darkBackgroundGray.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoActivityIndicator(),
                    SizedBox(width: 12),
                    Text(
                      'Mengunduh Excel...',
                      style: TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 14,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  try {
    final response = await dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    if (dialogOpen) {
      dialogOpen = false;
      if (dialogContext != null && dialogContext!.mounted) {
        Navigator.pop(dialogContext!);
      }
    }

    if (response.data != null && response.data!.isNotEmpty) {
      final bytes = Uint8List.fromList(response.data!);
      final xlsxFileName = '$fileName.xlsx';

      if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
        final downloadsDir = await getDownloadsDirectory();
        if (downloadsDir != null) {
          final filePath = p.join(downloadsDir.path, xlsxFileName);
          final file = File(filePath);
          await file.writeAsBytes(bytes);

          try {
            if (Platform.isWindows) {
              await Process.run('explorer.exe', [filePath.replaceAll('/', '\\')]);
            } else if (Platform.isMacOS) {
              await Process.run('open', [filePath]);
            } else if (Platform.isLinux) {
              await Process.run('xdg-open', [filePath]);
            }
          } catch (_) {
            // ignore if open fails — file is still saved
          }

          if (context.mounted) {
            CupertinoGlassToast.showSuccess(
              context,
              'Excel berhasil diunduh ke Downloads: $xlsxFileName',
            );
          }
        } else {
          throw Exception('Folder Downloads tidak ditemukan');
        }
      } else {
        // Mobile / Web: save to app temp dir and open
        final tempDir = await getTemporaryDirectory();
        final filePath = p.join(tempDir.path, xlsxFileName);
        final file = File(filePath);
        await file.writeAsBytes(bytes);

        if (context.mounted) {
          CupertinoGlassToast.showSuccess(
            context,
            'Excel berhasil diunduh: $xlsxFileName',
          );
        }
      }
    } else {
      throw Exception('Respons Excel kosong');
    }
  } catch (e) {
    if (dialogOpen) {
      dialogOpen = false;
      if (dialogContext != null && dialogContext!.mounted) {
        Navigator.pop(dialogContext!);
      }
    }
    if (context.mounted) {
      CupertinoGlassToast.showError(context, 'Gagal mengunduh Excel: $e');
    }
  }
}
