import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors; // kept for legacy Color references if needed
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/asset.dart';
import '../providers/asset_repository.dart';
import '../../../core/config/app_config.dart';

class AssetDetailScreen extends ConsumerStatefulWidget {
  final int assetId;
  const AssetDetailScreen({super.key, required this.assetId});

  @override
  ConsumerState<AssetDetailScreen> createState() => _AssetDetailScreenState();
}

class _AssetDetailScreenState extends ConsumerState<AssetDetailScreen> {
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

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Detail Aset Hardware'),
      ),
      child: SafeArea(
        child: assetAsync.when(
          data: (asset) {
            final statusColor = _getStatusColor(asset.status);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Panel Card
                  _buildHeaderCard(asset, statusColor),
                  const SizedBox(height: 16),

                  // Assignment & Location Card
                  _buildAssignmentCard(asset),
                  const SizedBox(height: 16),

                  // Acquisition & Commercial Card
                  _buildAcquisitionCard(asset),
                  const SizedBox(height: 16),

                  // Specs and Notes Card
                  _buildDetailsCard(asset),
                  const SizedBox(height: 16),

                  // Photos Section
                  if (asset.media.isNotEmpty) ...[
                    _buildPhotosSection(asset),
                    const SizedBox(height: 16),
                  ],

                  // Action Print Button
                  _buildPrintActionCard(asset),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (err, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.exclamationmark_triangle, color: CupertinoColors.destructiveRed, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Gagal memuat detail aset: $err',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: CupertinoColors.destructiveRed),
                  ),
                  const SizedBox(height: 16),
                  CupertinoButton.filled(
                    onPressed: () => ref.refresh(assetDetailProvider(widget.assetId)),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(Asset asset, Color statusColor) {
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: separatorColor, width: 0.5),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Category
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: separatorColor, width: 0.5),
                ),
                child: Text(
                  asset.category,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusLabel(asset.status),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            asset.name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: labelColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${asset.brand ?? ''} ${asset.model ?? ''}'.trim(),
            style: TextStyle(
              fontSize: 15,
              color: secondaryLabel,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                      style: TextStyle(color: secondaryLabel, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      asset.assetTag,
                      style: TextStyle(
                        color: labelColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                        fontSize: 15,
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
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SERIAL NUMBER (S/N)',
                      style: TextStyle(color: secondaryLabel, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      asset.serialNumber ?? '—',
                      style: TextStyle(
                        color: labelColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                        fontSize: 15,
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
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    const primaryAccent = Color(0xFF6E56CF);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: separatorColor, width: 0.5),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(CupertinoIcons.person_crop_square, color: primaryAccent, size: 20),
              const SizedBox(width: 8),
              Text(
                'Status Penempatan & Pengguna',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: labelColor),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Container(height: 0.5, color: separatorColor),
          ),
          _buildDetailRow('Perusahaan', asset.companyName ?? '—'),
          _buildDetailRow('Lokasi / Kantor', asset.officeName ?? '—'),
          _buildDetailRow('Pengguna / Karyawan', asset.employeeName ?? 'Belum Ditugaskan', valueStyle: asset.employeeName == null ? const TextStyle(fontStyle: FontStyle.italic, color: CupertinoColors.placeholderText) : null),
          _buildDetailRow('Tanggal Penyerahan', _formatDate(asset.assignedDate)),
        ],
      ),
    );
  }

  Widget _buildAcquisitionCard(Asset asset) {
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    const primaryAccent = Color(0xFF6E56CF);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: separatorColor, width: 0.5),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(CupertinoIcons.shopping_cart, color: primaryAccent, size: 20),
              const SizedBox(width: 8),
              Text(
                'Informasi Pembelian & Garansi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: labelColor),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Container(height: 0.5, color: separatorColor),
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
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    const primaryAccent = Color(0xFF6E56CF);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: separatorColor, width: 0.5),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(CupertinoIcons.doc_text, color: primaryAccent, size: 20),
              const SizedBox(width: 8),
              Text(
                'Spesifikasi Teknis & Catatan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: labelColor),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Container(height: 0.5, color: separatorColor),
          ),
          Text(
            'Spesifikasi',
            style: TextStyle(color: secondaryLabel, fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            (asset.specifications != null && asset.specifications!.isNotEmpty)
                ? asset.specifications!
                : 'Tidak ada spesifikasi khusus.',
            style: TextStyle(color: labelColor, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Text(
            'Catatan Tambahan',
            style: TextStyle(color: secondaryLabel, fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            (asset.notes != null && asset.notes!.isNotEmpty)
                ? asset.notes!
                : 'Tidak ada catatan tambahan.',
            style: TextStyle(color: labelColor, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosSection(Asset asset) {
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            'Dokumentasi Kondisi Aset',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: labelColor),
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
                          backgroundColor: CupertinoColors.black.withOpacity(0.5),
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
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 120,
                  decoration: BoxDecoration(
                    color: cardBg,
                    border: Border.all(color: separatorColor, width: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: isImage
                      ? Image.network(mediaUrl, fit: BoxFit.cover)
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(CupertinoIcons.doc_text_fill, color: CupertinoColors.systemRed, size: 36),
                              const SizedBox(height: 4),
                              Text(
                                'PDF Dokumen',
                                style: TextStyle(fontSize: 9, color: secondaryLabel),
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

  Widget _buildPrintActionCard(Asset asset) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton.filled(
        onPressed: () {
          context.push('/pdf-preview?title=Barcode Aset ${Uri.encodeComponent(asset.assetTag)}&url_path=pdf/assets/single/${asset.id}');
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.qrcode, size: 20),
            SizedBox(width: 8),
            Text('Print QR Barcode Label', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {TextStyle? valueStyle}) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                color: secondaryLabel,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: valueStyle ??
                  TextStyle(
                    color: labelColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
