import 'package:flutter/material.dart';
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
        return Colors.green;
      case 'assigned':
        return Colors.blue;
      case 'maintenance':
        return Colors.orange;
      case 'broken':
      case 'lost':
        return Colors.red;
      case 'retired':
        return Colors.grey;
      default:
        return Colors.blueGrey;
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        title: const Text('Detail Aset Hardware'),
      ),
      body: assetAsync.when(
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 12),
                Text(
                  'Gagal memuat detail aset: $err',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(assetDetailProvider(widget.assetId)),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(Asset asset, Color statusColor) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Padding(
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
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    asset.category,
                    style: const TextStyle(
                      color: Color(0xFF475569),
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
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${asset.brand ?? ''} ${asset.model ?? ''}'.trim(),
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF64748B),
              ),
            ),
            const Divider(height: 32, color: Color(0xFFE2E8F0)),
            // Asset Tag & S/N info
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ASSET TAG',
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        asset.assetTag,
                        style: const TextStyle(
                          color: Color(0xFF0F172A),
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
                  width: 1,
                  color: const Color(0xFFE2E8F0),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SERIAL NUMBER (S/N)',
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        asset.serialNumber ?? '—',
                        style: const TextStyle(
                          color: Color(0xFF0F172A),
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
      ),
    );
  }

  Widget _buildAssignmentCard(Asset asset) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.assignment_ind_outlined, color: Color(0xFF6E56CF)),
                SizedBox(width: 8),
                Text(
                  'Status Penempatan & Pengguna',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
              ],
            ),
            const Divider(height: 24, color: Color(0xFFF1F5F9)),
            _buildDetailRow('Perusahaan', asset.companyName ?? '—'),
            _buildDetailRow('Lokasi / Kantor', asset.officeName ?? '—'),
            _buildDetailRow('Pengguna / Karyawan', asset.employeeName ?? 'Belum Ditugaskan', valueStyle: asset.employeeName == null ? const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey) : null),
            _buildDetailRow('Tanggal Penyerahan', _formatDate(asset.assignedDate)),
          ],
        ),
      ),
    );
  }

  Widget _buildAcquisitionCard(Asset asset) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.shopping_bag_outlined, color: Color(0xFF6E56CF)),
                SizedBox(width: 8),
                Text(
                  'Informasi Pembelian & Garansi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
              ],
            ),
            const Divider(height: 24, color: Color(0xFFF1F5F9)),
            _buildDetailRow('Tanggal Pembelian', _formatDate(asset.purchaseDate)),
            _buildDetailRow('Harga Pembelian', _formatCurrency(asset.purchasePrice)),
            _buildDetailRow('Supplier', asset.supplierName ?? '—'),
            _buildDetailRow('Masa Garansi Habis', _formatDate(asset.warrantyExpiry)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(Asset asset) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.description_outlined, color: Color(0xFF6E56CF)),
                SizedBox(width: 8),
                Text(
                  'Spesifikasi Teknis & Catatan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
              ],
            ),
            const Divider(height: 24, color: Color(0xFFF1F5F9)),
            const Text(
              'Spesifikasi',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              (asset.specifications != null && asset.specifications!.isNotEmpty)
                  ? asset.specifications!
                  : 'Tidak ada spesifikasi khusus.',
              style: const TextStyle(color: Color(0xFF1E293B), fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              'Catatan Tambahan',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              (asset.notes != null && asset.notes!.isNotEmpty)
                  ? asset.notes!
                  : 'Tidak ada catatan tambahan.',
              style: const TextStyle(color: Color(0xFF1E293B), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotosSection(Asset asset) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            'Dokumentasi Kondisi Aset',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
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
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppBar(
                              title: Text(med.fileName),
                              leading: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InteractiveViewer(
                                child: Image.network(mediaUrl),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: isImage
                      ? Image.network(mediaUrl, fit: BoxFit.cover)
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.picture_as_pdf, color: Colors.red, size: 36),
                              SizedBox(height: 4),
                              Text(
                                'PDF Dokumen',
                                style: TextStyle(fontSize: 9, color: Colors.grey),
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
      child: ElevatedButton.icon(
        icon: const Icon(Icons.qr_code, color: Colors.white),
        label: const Text('PRINT QR BARCODE LABEL'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6E56CF),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onPressed: () {
          context.push('/pdf-preview?title=Barcode Aset ${Uri.encodeComponent(asset.assetTag)}&url_path=pdf/assets/single/${asset.id}');
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF64748B),
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
                  const TextStyle(
                    color: Color(0xFF1E293B),
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
