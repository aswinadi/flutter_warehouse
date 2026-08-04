import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_repository.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final List<List<Offset>> _strokes = [];
  List<Offset> _currentStroke = [];
  bool _isSaving = false;

  void _clearCanvas() {
    setState(() {
      _strokes.clear();
      _currentStroke.clear();
    });
  }

  Future<void> _pickSignatureFromGallery() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 400,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64Image = 'data:image/png;base64,${base64Encode(bytes)}';
        await _uploadSignature(base64Image);
      }
    } catch (e) {
      if (mounted) {
        CupertinoGlassToast.showError(context, 'Gagal memilih gambar dari galeri: $e');
      }
    }
  }

  Future<void> _saveDrawnSignature() async {
    if (_strokes.isEmpty) {
      CupertinoGlassToast.showError(context, 'Silakan gambar tanda tangan terlebih dahulu pada kanvas.');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 600, 300));

      final paint = Paint()
        ..color = const Color(0xFF000000)
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 4.0
        ..isAntiAlias = true;

      // Draw white background
      canvas.drawRect(
        const Rect.fromLTWH(0, 0, 600, 300),
        Paint()..color = const Color(0xFFFFFFFF),
      );

      for (final stroke in _strokes) {
        for (int i = 0; i < stroke.length - 1; i++) {
          canvas.drawLine(stroke[i], stroke[i + 1], paint);
        }
      }

      final picture = recorder.endRecording();
      final img = await picture.toImage(600, 300);
      final ByteData? pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);

      if (pngBytes != null) {
        final base64Image = 'data:image/png;base64,${base64Encode(pngBytes.buffer.asUint8List())}';
        await _uploadSignature(base64Image);
      }
    } catch (e) {
      if (mounted) {
        CupertinoGlassToast.showError(context, 'Gagal memproses gambar TTD: $e');
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _uploadSignature(String signatureData) async {
    setState(() => _isSaving = true);
    try {
      final repo = AuthRepositoryImpl(ref.read(dioProvider));
      await repo.updateSignature(signatureData);
      
      // Refresh Auth User State
      await ref.read(authProvider.notifier).refreshUser();

      if (mounted) {
        _clearCanvas();
        CupertinoGlassToast.showSuccess(context, 'Tanda tangan digital berhasil diperbarui!');
      }
    } catch (e) {
      if (mounted) {
        CupertinoGlassToast.showError(context, 'Gagal mengunggah TTD: $e');
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.valueOrNull?.maybeWhen(
      authenticated: (user, _) => user,
      orElse: () => null,
    );

    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);

    if (user == null) {
      return const CupertinoPageScaffold(
        child: Center(child: CupertinoActivityIndicator()),
      );
    }

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Profil Saya'),
            backgroundColor: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context).withValues(alpha: 0.96),
            border: Border(
              bottom: BorderSide(
                color: CupertinoColors.separator.resolveFrom(context),
                width: 0.5,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // User Card
                CupertinoGlassContainer(
                  borderRadius: CupertinoSpacing.cardRadius,
                  padding: const EdgeInsets.all(CupertinoSpacing.xl),
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: CupertinoColors.activeBlue.resolveFrom(context).withValues(alpha: 0.15),
                        ),
                        child: Center(
                          child: Text(
                            user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.activeBlue,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: CupertinoSpacing.l),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: context.headline.copyWith(
                                fontWeight: FontWeight.bold,
                                color: labelColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.email,
                              style: context.footnote.copyWith(
                                color: secondaryLabelColor,
                              ),
                            ),
                            if (user.roles.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                children: user.roles.map((role) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.activeBlue.resolveFrom(context).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      role,
                                      style: context.caption2.copyWith(
                                        color: CupertinoColors.activeBlue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: CupertinoSpacing.l),

                // Digital Signature Section Header
                Text(
                  'TANDA TANGAN DIGITAL PROFIL',
                  style: context.caption1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: secondaryLabelColor,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: CupertinoSpacing.s),

                // Existing Signature Preview Card
                CupertinoGlassContainer(
                  borderRadius: CupertinoSpacing.cardRadius,
                  padding: const EdgeInsets.all(CupertinoSpacing.l),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'TTD Profil Saat Ini',
                            style: context.subhead.copyWith(
                              fontWeight: FontWeight.w600,
                              color: labelColor,
                            ),
                          ),
                          if (user.signatureUrl != null)
                            const Icon(
                              CupertinoIcons.checkmark_seal_fill,
                              color: CupertinoColors.activeGreen,
                              size: 20,
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: CupertinoColors.separator.resolveFrom(context),
                            width: 0.8,
                          ),
                        ),
                        child: user.signatureUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  user.signatureUrl!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Center(
                                    child: Text(
                                      'Gagal memuat gambar TTD',
                                      style: TextStyle(color: CupertinoColors.systemRed),
                                    ),
                                  ),
                                ),
                              )
                            : const Center(
                                child: Text(
                                  'Belum ada TTD profil. Gambar pada kanvas di bawah untuk menambahkan.',
                                  style: TextStyle(
                                    color: CupertinoColors.placeholderText,
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: CupertinoSpacing.l),

                // Signature Drawing Canvas Card
                CupertinoGlassContainer(
                  borderRadius: CupertinoSpacing.cardRadius,
                  padding: const EdgeInsets.all(CupertinoSpacing.l),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Kanvas Tanda Tangan Baru',
                            style: context.subhead.copyWith(
                              fontWeight: FontWeight.w600,
                              color: labelColor,
                            ),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            minSize: 28,
                            onPressed: _clearCanvas,
                            child: const Text(
                              'Hapus Coretan',
                              style: TextStyle(fontSize: 13, color: CupertinoColors.systemRed),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Interactive Drawing Canvas
                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: CupertinoColors.activeBlue.resolveFrom(context).withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                        ),
                        child: GestureDetector(
                          onPanStart: (details) {
                            setState(() {
                              _currentStroke = [details.localPosition];
                              _strokes.add(_currentStroke);
                            });
                          },
                          onPanUpdate: (details) {
                            setState(() {
                              _currentStroke.add(details.localPosition);
                            });
                          },
                          child: CustomPaint(
                            painter: _SignaturePainter(_strokes),
                            size: Size.infinite,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: CupertinoButton(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              color: CupertinoColors.secondarySystemFill.resolveFrom(context),
                              borderRadius: BorderRadius.circular(10),
                              onPressed: _isSaving ? null : _pickSignatureFromGallery,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.photo, size: 18, color: labelColor),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Pilih Foto',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: labelColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: CupertinoButton.filled(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              borderRadius: BorderRadius.circular(10),
                              onPressed: _isSaving ? null : _saveDrawnSignature,
                              child: _isSaving
                                  ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                                  : const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(CupertinoIcons.square_pencil, size: 18, color: CupertinoColors.white),
                                        SizedBox(width: 6),
                                        Text(
                                          'Simpan TTD Profil',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: CupertinoSpacing.xxl),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<List<Offset>> strokes;

  _SignaturePainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF000000)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.5
      ..isAntiAlias = true;

    for (final stroke in strokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(stroke[i], stroke[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}
