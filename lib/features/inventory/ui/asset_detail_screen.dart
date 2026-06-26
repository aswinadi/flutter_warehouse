import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/asset.dart';
import '../providers/asset_repository.dart';
import '../../../core/config/app_config.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';

class AssetDetailScreen extends StatelessWidget {
  final int assetId;
  const AssetDetailScreen({super.key, required this.assetId});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Detail Aset Hardware'),
      ),
      child: SafeArea(
        child: AssetDetailContent(assetId: assetId),
      ),
    );
  }
}

class AssetDetailContent extends ConsumerStatefulWidget {
  final int assetId;
  const AssetDetailContent({super.key, required this.assetId});

  @override
  ConsumerState<AssetDetailContent> createState() => _AssetDetailContentState();
}

class _AssetDetailContentState extends ConsumerState<AssetDetailContent> {
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return CupertinoColors.activeGreen;
      case 'assigned':
        return CupertinoColors.activeBlue;
      case 'maintenance':
        return CupertinoColors.systemOrange;
      case 'broken':
      case 'lost':
        return CupertinoColors.destructiveRed;
      case 'retired':
        return CupertinoColors.systemGrey;
      default:
        return CupertinoColors.systemGrey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return 'Available';
      case 'assigned':
        return 'Assigned';
      case 'maintenance':
        return 'In Maintenance';
      case 'broken':
        return 'Broken';
      case 'lost':
        return 'Lost';
      case 'retired':
        return 'Retired';
      default:
        return status;
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '—';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  String _formatCurrency(String? priceStr) {
    if (priceStr == null || priceStr.isEmpty) return '—';
    final price = double.tryParse(priceStr);
    if (price == null) return priceStr;
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(price);
  }

  String _getMediaUrl(String originalUrl) {
    if (originalUrl.startsWith('http')) {
      final uri = Uri.parse(originalUrl);
      final baseUri = Uri.parse(AppConfig.baseUrl);
      final newUri = uri.replace(
        scheme: baseUri.scheme,
        host: baseUri.host,
        port: baseUri.port,
      );
      return newUri.toString();
    }
    final base = AppConfig.baseUrl.replaceAll('/api/v1/', '');
    return '$base$originalUrl';
  }

  @override
  Widget build(BuildContext context) {
    final assetAsync = ref.watch(assetDetailProvider(widget.assetId));

    return assetAsync.when(
      data: (asset) {
        final statusColor = _getStatusColor(asset.status);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Panel Card
              _buildHeaderCard(asset, statusColor),
              const SizedBox(height: CupertinoSpacing.l),

              // Assignment & Location Card
              _buildAssignmentCard(asset),
              const SizedBox(height: CupertinoSpacing.l),

              // Acquisition & Commercial Card
              _buildAcquisitionCard(asset),
              const SizedBox(height: CupertinoSpacing.l),

              // Specs and Notes Card
              _buildDetailsCard(asset),
              const SizedBox(height: CupertinoSpacing.l),

              // Photos Section
              if (asset.media.isNotEmpty) ...[
                _buildPhotosSection(asset),
                const SizedBox(height: CupertinoSpacing.l),
              ],

              // Action Buttons (Edit & Print)
              _buildActionButtons(asset),
              const SizedBox(height: CupertinoSpacing.xxxl),
            ],
          ),
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(CupertinoSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.exclamationmark_triangle, color: CupertinoColors.destructiveRed, size: 48),
              const SizedBox(height: CupertinoSpacing.m),
              Text(
                'Gagal memuat detail aset: $err',
                textAlign: TextAlign.center,
                style: context.body.copyWith(color: CupertinoColors.destructiveRed),
              ),
              const SizedBox(height: CupertinoSpacing.l),
              CupertinoButton.filled(
                onPressed: () => ref.refresh(assetDetailProvider(widget.assetId)),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(Asset asset, Color statusColor) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return CupertinoGlassContainer(
      padding: const EdgeInsets.all(CupertinoSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Category
              Container(
                padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.halfScreenMargin, vertical: CupertinoSpacing.xs),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: separatorColor, width: 0.5),
                ),
                child: Text(
                  asset.category,
                  style: context.caption1.copyWith(
                    color: labelColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.m, vertical: CupertinoSpacing.xs),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusLabel(asset.status),
                  style: context.caption1.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: CupertinoSpacing.l),
          Text(
            asset.name,
            style: context.title2.copyWith(
              fontWeight: FontWeight.bold,
              color: labelColor,
            ),
          ),
          const SizedBox(height: CupertinoSpacing.s),
          Text(
            '${asset.brand ?? ''} ${asset.model ?? ''}'.trim(),
            style: context.subhead.copyWith(
              color: secondaryLabel,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.l),
            child: Container(height: 0.5, color: separatorColor),
          ),
          // Asset Tag & S/N info
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ASSET TAG',
                      style: context.caption2.copyWith(color: secondaryLabel, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: CupertinoSpacing.xs),
                    Text(
                      asset.assetTag,
                      style: context.subhead.copyWith(
                        color: labelColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 32,
                width: 0.5,
                color: separatorColor,
              ),
              const SizedBox(width: CupertinoSpacing.l),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SERIAL NUMBER (S/N)',
                      style: context.caption2.copyWith(color: secondaryLabel, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: CupertinoSpacing.xs),
                    Text(
                      asset.serialNumber ?? '—',
                      style: context.subhead.copyWith(
                        color: labelColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(Asset asset) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    const primaryAccent = CupertinoColors.activeBlue;

    return CupertinoGlassContainer(
      padding: const EdgeInsets.all(CupertinoSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(CupertinoIcons.person_crop_square, color: primaryAccent, size: 20),
              const SizedBox(width: CupertinoSpacing.s),
              Text(
                'Status Penempatan & Pengguna',
                style: context.headline.copyWith(fontWeight: FontWeight.bold, color: labelColor),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.m),
            child: Container(height: 0.5, color: CupertinoColors.separator.resolveFrom(context)),
          ),
          _buildDetailRow('Perusahaan', asset.companyName ?? '—'),
          _buildDetailRow('Lokasi / Kantor', asset.officeName ?? '—'),
          _buildDetailRow('Pengguna / Karyawan', asset.employeeName ?? 'Belum Ditugaskan', valueStyle: asset.employeeName == null ? context.subhead.copyWith(fontStyle: FontStyle.italic, color: CupertinoColors.placeholderText) : null),
          _buildDetailRow('Tanggal Penyerahan', _formatDate(asset.assignedDate)),
        ],
      ),
    );
  }

  Widget _buildAcquisitionCard(Asset asset) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    const primaryAccent = CupertinoColors.activeBlue;

    return CupertinoGlassContainer(
      padding: const EdgeInsets.all(CupertinoSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(CupertinoIcons.shopping_cart, color: primaryAccent, size: 20),
              const SizedBox(width: CupertinoSpacing.s),
              Text(
                'Informasi Pembelian & Garansi',
                style: context.headline.copyWith(fontWeight: FontWeight.bold, color: labelColor),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.m),
            child: Container(height: 0.5, color: CupertinoColors.separator.resolveFrom(context)),
          ),
          _buildDetailRow('Tanggal Pembelian', _formatDate(asset.purchaseDate)),
          _buildDetailRow('Harga Pembelian', _formatCurrency(asset.purchasePrice)),
          _buildDetailRow('Supplier', asset.supplierName ?? '—'),
          _buildDetailRow('Masa Garansi Habis', _formatDate(asset.warrantyExpiry)),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(Asset asset) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    const primaryAccent = CupertinoColors.activeBlue;

    return CupertinoGlassContainer(
      padding: const EdgeInsets.all(CupertinoSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(CupertinoIcons.doc_text, color: primaryAccent, size: 20),
              const SizedBox(width: CupertinoSpacing.s),
              Text(
                'Spesifikasi Teknis & Catatan',
                style: context.headline.copyWith(fontWeight: FontWeight.bold, color: labelColor),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.m),
            child: Container(height: 0.5, color: CupertinoColors.separator.resolveFrom(context)),
          ),
          Text(
            'Spesifikasi',
            style: context.footnote.copyWith(color: secondaryLabel, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: CupertinoSpacing.s),
          Text(
            (asset.specifications != null && asset.specifications!.isNotEmpty)
                ? asset.specifications!
                : 'Tidak ada spesifikasi khusus.',
            style: context.subhead.copyWith(color: labelColor),
          ),
          const SizedBox(height: CupertinoSpacing.l),
          Text(
            'Catatan Tambahan',
            style: context.footnote.copyWith(color: secondaryLabel, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: CupertinoSpacing.s),
          Text(
            (asset.notes != null && asset.notes!.isNotEmpty)
                ? asset.notes!
                : 'Tidak ada catatan tambahan.',
            style: context.subhead.copyWith(color: labelColor),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosSection(Asset asset) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.xs, vertical: CupertinoSpacing.s),
          child: Text(
            'Dokumentasi Kondisi Aset',
            style: context.headline.copyWith(fontWeight: FontWeight.bold, color: labelColor),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: asset.media.length,
            itemBuilder: (context, index) {
              final med = asset.media[index];
              final isImage = med.mimeType.startsWith('image/');
              final mediaUrl = _getMediaUrl(med.originalUrl);

              return GestureDetector(
                onTap: () {
                  if (med.mimeType == 'application/pdf') {
                    context.push('/pdf-preview?title=${Uri.encodeComponent(med.fileName)}&pdf_url=${Uri.encodeComponent(mediaUrl)}');
                  } else {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => CupertinoPageScaffold(
                        backgroundColor: CupertinoColors.black,
                        navigationBar: CupertinoNavigationBar(
                          backgroundColor: CupertinoColors.black.withValues(alpha: 0.5),
                          middle: Text(med.fileName, style: const TextStyle(color: CupertinoColors.white)),
                          leading: CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: const Icon(CupertinoIcons.xmark, color: CupertinoColors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        child: Center(
                          child: InteractiveViewer(
                            child: Image.network(mediaUrl),
                          ),
                        ),
                      ),
                    );
                  }
                },
                child: CupertinoGlassContainer(
                  margin: const EdgeInsets.only(right: CupertinoSpacing.m),
                  width: 120,
                  padding: EdgeInsets.zero,
                  child: isImage
                      ? Image.network(mediaUrl, fit: BoxFit.cover)
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(CupertinoIcons.doc_text_fill, color: CupertinoColors.systemRed, size: 36),
                              const SizedBox(height: CupertinoSpacing.xs),
                              Text(
                                'PDF Dokumen',
                                style: context.caption2.copyWith(fontSize: 9, color: secondaryLabel),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Asset asset) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: CupertinoButton(
            color: CupertinoColors.activeBlue,
            onPressed: () {
              context.push('/assets/${asset.id}/edit');
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.pencil, size: 20, color: CupertinoColors.white),
                SizedBox(width: CupertinoSpacing.s),
                Text('Edit Aset Hardware', style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.white)),
              ],
            ),
          ),
        ),
        const SizedBox(height: CupertinoSpacing.m),
        SizedBox(
          width: double.infinity,
          child: CupertinoButton(
            color: CupertinoColors.activeBlue,
            onPressed: () {
              context.push('/pdf-preview?title=Barcode Aset ${Uri.encodeComponent(asset.assetTag)}&url_path=pdf/assets/single/${asset.id}');
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.qrcode, size: 20, color: CupertinoColors.white),
                SizedBox(width: CupertinoSpacing.s),
                Text('Print QR Barcode Label', style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.white)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {TextStyle? valueStyle}) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: context.footnote.copyWith(
                color: secondaryLabel,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: CupertinoSpacing.s),
          Expanded(
            child: Text(
              value,
              style: valueStyle ??
                  context.subhead.copyWith(
                    color: labelColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
