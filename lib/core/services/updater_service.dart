import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ota_update/ota_update.dart';
import '../api/dio_client.dart';

final updaterServiceProvider = Provider<UpdaterService>((ref) {
  return UpdaterService(ref.watch(dioProvider));
});

class UpdaterService {
  final Dio _dio;

  UpdaterService(this._dio);

  Future<void> checkForUpdates(BuildContext context) async {
    try {
      // 1. Fetch latest metadata from backend
      final response = await _dio.get('wh/app-version');
      if (response.statusCode != 200) return;

      final data = response.data;
      if (data == null) return;

      // Extract details
      final String latestVersion = data['latest_version'] ?? '1.0.0';
      final int latestBuild = data['build_number'] ?? 1;
      final String apkUrl = data['apk_url'] ?? '';
      final String exeUrl = data['win_exe_url'] ?? '';
      final String releaseNotes = data['release_notes'] ?? 'Pembaruan sistem rutin.';

      // 2. Read current app version & build number
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final int currentBuild = int.tryParse(packageInfo.buildNumber) ?? 1;

      // 3. Compare builds
      if (latestBuild > currentBuild) {
        if (context.mounted) {
          _showUpdateDialog(context, latestVersion, releaseNotes, apkUrl, exeUrl);
        }
      }
    } catch (e) {
      debugPrint('Failed to check for updates: $e');
    }
  }

  void _showUpdateDialog(
    BuildContext context,
    String version,
    String notes,
    String apkUrl,
    String exeUrl,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Pembaruan Tersedia (v$version)',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Versi aplikasi baru telah dirilis. Silakan lakukan pembaruan untuk melanjutkan dengan fitur-fitur terbaru.',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            const Text(
              'Catatan Perubahan:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 6),
            Flexible(
              child: SingleChildScrollView(
                child: Text(
                  notes,
                  style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.4),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('NANTI', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6E56CF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _performUpdate(context, apkUrl, exeUrl);
            },
            child: const Text('UPDATE SEKARANG', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _performUpdate(BuildContext context, String apkUrl, String exeUrl) {
    if (kIsWeb) return;

    if (Platform.isAndroid) {
      _installAndroidApk(context, apkUrl);
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      _installDesktopApp(context, exeUrl);
    }
  }

  // --- ANDROID INSTALLER ---
  void _installAndroidApk(BuildContext context, String apkUrl) {
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
            Text('Mengunduh pembaruan aplikasi...'),
          ],
        ),
        duration: Duration(seconds: 4),
      ),
    );

    try {
      OtaUpdate().execute(
        apkUrl,
        destinationFilename: 'maxmar_warehouse_update.apk',
      ).listen(
        (OtaEvent event) {
          if (event.status == OtaStatus.INSTALLING) {
            debugPrint('Install screen opened successfully.');
          } else if (event.status == OtaStatus.DOWNLOADING) {
            debugPrint('Download Progress: ${event.value}%');
          }
        },
        onError: (err) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Gagal mengunduh update: $err'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Gagal menjalankan updater: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // --- DESKTOP INSTALLER (Windows / macOS) ---
  Future<void> _installDesktopApp(BuildContext context, String exeUrl) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final Uri url = Uri.parse(exeUrl);
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Tidak dapat membuka tautan updater: $exeUrl'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
