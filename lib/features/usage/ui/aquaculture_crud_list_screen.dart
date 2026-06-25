import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/widgets/company_switcher.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_dialog.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';
import '../providers/aquaculture_crud_config.dart';
import '../providers/aquaculture_crud_provider.dart';
import 'aquaculture_crud_form_screen.dart';

class AquacultureCrudListScreen extends ConsumerStatefulWidget {
  final String resource;

  const AquacultureCrudListScreen({super.key, required this.resource});

  @override
  ConsumerState<AquacultureCrudListScreen> createState() => _AquacultureCrudListScreenState();
}

class _AquacultureCrudListScreenState extends ConsumerState<AquacultureCrudListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  
  int? _selectedId;
  bool _isAdding = false;
  bool _isEditing = false;

  @override
  void didUpdateWidget(covariant AquacultureCrudListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.resource != widget.resource) {
      setState(() {
        _selectedId = null;
        _isAdding = false;
        _isEditing = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(aquacultureCrudListProvider(widget.resource).notifier).loadMore();
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '-';
    try {
      final dateTime = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(dateTime);
    } catch (_) {
      return dateStr;
    }
  }

  Future<void> _deleteRecord(int id) async {
    final l10nConfig = aquacultureCrudConfigs[widget.resource];
    final title = l10nConfig?.title ?? 'Data';
    final screenContext = context;

    showCupertinoDialog(
      context: context,
      builder: (dialogContext) => CupertinoGlassDialog(
        title: Text('Hapus $title'),
        content: const Text('Apakah Anda yakin ingin menghapus data ini secara permanen?'),
        actions: [
          CupertinoGlassDialogAction(
            isDestructive: true,
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await ref.read(aquacultureCrudRepositoryProvider).delete(widget.resource, id);
                ref.read(aquacultureCrudListProvider(widget.resource).notifier).refresh();
                if (screenContext.mounted) {
                  CupertinoGlassToast.showSuccess(screenContext, 'Data berhasil dihapus.');
                }
              } catch (err) {
                if (screenContext.mounted) {
                  CupertinoGlassToast.showError(screenContext, 'Gagal menghapus data: $err');
                }
              }
            },
            child: const Text('Hapus'),
          ),
          CupertinoGlassDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContent(dynamic item) {
    final res = widget.resource;
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    if (res == 'tambaks') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['name'] ?? '',
            style: context.callout.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: CupertinoSpacing.xs),
          Text(
            'Perusahaan: ${item['company']?['company_name'] ?? '-'}',
            style: context.subhead.copyWith(color: secondaryLabel),
          ),
        ],
      );
    } else if (res == 'bloks') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                item['name'] ?? '',
                style: context.callout.copyWith(fontWeight: FontWeight.bold),
              ),
              if (item['code'] != null && item['code'].toString().isNotEmpty) ...[
                const SizedBox(width: CupertinoSpacing.s),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: CupertinoColors.activeBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item['code'],
                    style: context.caption2.copyWith(color: CupertinoColors.activeBlue, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: CupertinoSpacing.xs),
          Text(
            'Tambak: ${item['tambak']?['name'] ?? '-'} (${item['tambak']?['company']?['company_name'] ?? ''})',
            style: context.subhead.copyWith(color: secondaryLabel),
          ),
        ],
      );
    } else if (res == 'moduls') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                item['name'] ?? '',
                style: context.callout.copyWith(fontWeight: FontWeight.bold),
              ),
              if (item['code'] != null && item['code'].toString().isNotEmpty) ...[
                const SizedBox(width: CupertinoSpacing.s),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: CupertinoColors.activeBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item['code'],
                    style: context.caption2.copyWith(color: CupertinoColors.activeBlue, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: CupertinoSpacing.xs),
          Text(
            'Blok: ${item['blok']?['name'] ?? '-'} | Tambak: ${item['blok']?['tambak']?['name'] ?? '-'}',
            style: context.subhead.copyWith(color: secondaryLabel),
          ),
        ],
      );
    } else if (res == 'ponds') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                item['name'] ?? '',
                style: context.callout.copyWith(fontWeight: FontWeight.bold),
              ),
              if (item['code'] != null && item['code'].toString().isNotEmpty) ...[
                const SizedBox(width: CupertinoSpacing.s),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: CupertinoColors.activeBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item['code'],
                    style: context.caption2.copyWith(color: CupertinoColors.activeBlue, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: CupertinoSpacing.s),
          Text(
            'Modul: ${item['modul']?['name'] ?? '-'} | Blok: ${item['modul']?['blok']?['name'] ?? '-'} | Tambak: ${item['modul']?['blok']?['tambak']?['name'] ?? '-'}',
            style: context.footnote.copyWith(color: secondaryLabel),
          ),
          if (item['length'] != null || item['width'] != null || item['depth'] != null) ...[
            const SizedBox(height: CupertinoSpacing.xs),
            Text(
              'Dimensi: ${item['length'] ?? '-'}m x ${item['width'] ?? '-'}m | Kedalaman: ${item['depth'] ?? '-'}m',
              style: context.footnote.copyWith(color: secondaryLabel),
            ),
          ],
        ],
      );
    } else if (res == 'cycles') {
      final isActive = item['is_active'] == true;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['name'] ?? '',
                style: context.callout.copyWith(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive ? CupertinoColors.activeGreen.withValues(alpha: 0.15) : CupertinoColors.systemGrey.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isActive ? 'Aktif' : 'Selesai',
                  style: context.caption1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isActive ? CupertinoColors.activeGreen : secondaryLabel,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: CupertinoSpacing.s),
          Text(
            'Modul: ${item['modul']?['name'] ?? '-'} | Tambak: ${item['modul']?['blok']?['tambak']?['name'] ?? '-'}',
            style: context.footnote.copyWith(color: secondaryLabel),
          ),
          const SizedBox(height: CupertinoSpacing.xs),
          Text(
            'Mulai Tebar: ${_formatDate(item['stocking_date'])}',
            style: context.footnote.copyWith(color: secondaryLabel),
          ),
        ],
      );
    } else if (res == 'contracts') {
      final isActive = item['is_active'] == true;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['name'] ?? '',
                style: context.callout.copyWith(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive ? CupertinoColors.activeGreen.withValues(alpha: 0.15) : CupertinoColors.systemGrey.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isActive ? 'Aktif' : 'Mati',
                  style: context.caption1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isActive ? CupertinoColors.activeGreen : secondaryLabel,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: CupertinoSpacing.s),
          Text(
            'No. Kontrak: ${item['contract_number'] ?? '-'}',
            style: context.footnote.copyWith(color: secondaryLabel),
          ),
          const SizedBox(height: CupertinoSpacing.xs),
          Text(
            'Pembeli: ${item['buyer_name'] ?? '-'} | Penjual: ${item['seller_name'] ?? '-'}',
            style: context.footnote.copyWith(color: secondaryLabel),
          ),
          const SizedBox(height: CupertinoSpacing.xs),
          Text(
            'Tanggal Kontrak: ${_formatDate(item['contract_date'])}',
            style: context.footnote.copyWith(color: secondaryLabel),
          ),
        ],
      );
    } else if (res == 'saprotam-logs') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['product_name'] ?? '',
                style: context.callout.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '${item['amount'] ?? '-'} ${item['unit'] ?? ''}',
                style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: CupertinoColors.activeBlue),
              ),
            ],
          ),
          const SizedBox(height: CupertinoSpacing.s),
          Text(
            'Petak: ${item['pond']?['name'] ?? '-'} | Siklus: ${item['cycle']?['name'] ?? '-'}',
            style: context.footnote.copyWith(color: secondaryLabel),
          ),
          const SizedBox(height: CupertinoSpacing.xs),
          Text(
            'Tanggal Penggunaan: ${_formatDate(item['date'])}',
            style: context.footnote.copyWith(color: secondaryLabel),
          ),
        ],
      );
    } else if (res == 'cost-centres') {
      final isActive = item['is_active'] == true;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['code'] ?? '',
                style: context.callout.copyWith(fontWeight: FontWeight.bold, color: CupertinoColors.activeBlue),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive ? CupertinoColors.activeGreen.withValues(alpha: 0.15) : CupertinoColors.systemGrey.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isActive ? 'Aktif' : 'Nonaktif',
                  style: context.caption2.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isActive ? CupertinoColors.activeGreen : secondaryLabel,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: CupertinoSpacing.s),
          Text(
            item['name'] ?? '',
            style: context.subhead.copyWith(fontWeight: FontWeight.w500),
          ),
          if (item['parent_code'] != null && item['parent_code'].toString().isNotEmpty) ...[
            const SizedBox(height: CupertinoSpacing.xs),
            Text(
              'Induk: ${item['parent_code']}',
              style: context.footnote.copyWith(color: secondaryLabel),
            ),
          ],
          const SizedBox(height: CupertinoSpacing.xs),
          Text(
            'Perusahaan: ${item['company']?['company_name'] ?? '-'}',
            style: context.footnote.copyWith(color: secondaryLabel),
          ),
        ],
      );
    }

    return Text(item.toString());
  }

  bool _matchesSearch(dynamic item, String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase();

    final name = (item['name']?.toString() ?? '').toLowerCase();
    final code = (item['code']?.toString() ?? '').toLowerCase();
    final companyName = (item['company']?['company_name']?.toString() ?? '').toLowerCase();
    final tambakName = (item['tambak']?['name']?.toString() ?? '').toLowerCase();
    final productName = (item['product_name']?.toString() ?? '').toLowerCase();

    return name.contains(q) || code.contains(q) || companyName.contains(q) || tambakName.contains(q) || productName.contains(q);
  }

  String _formatRupiah(num? value) {
    if (value == null) return '-';
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(value);
  }

  Widget _buildKeyValueRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: context.subhead.copyWith(
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: CupertinoSpacing.s),
          Expanded(
            child: Text(
              value,
              style: context.subhead.copyWith(
                color: CupertinoColors.label.resolveFrom(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContainer({required Widget child}) {
    return CupertinoGlassContainer(
      borderRadius: CupertinoSpacing.cardRadius,
      child: child,
    );
  }

  Widget _buildDetailFields(dynamic item) {
    final res = widget.resource;

    if (res == 'tambaks') {
      return _buildCardContainer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildKeyValueRow('Nama Tambak', item['name'] ?? '-'),
              _buildKeyValueRow('Perusahaan', item['company']?['company_name'] ?? '-'),
            ],
          ),
        ),
      );
    } else if (res == 'bloks') {
      return _buildCardContainer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildKeyValueRow('Nama Blok', item['name'] ?? '-'),
              _buildKeyValueRow('Kode Blok', item['code'] ?? '-'),
              _buildKeyValueRow('Tambak', item['tambak']?['name'] ?? '-'),
              _buildKeyValueRow('Perusahaan', item['tambak']?['company']?['company_name'] ?? '-'),
            ],
          ),
        ),
      );
    } else if (res == 'moduls') {
      return _buildCardContainer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildKeyValueRow('Nama Modul', item['name'] ?? '-'),
              _buildKeyValueRow('Kode Modul', item['code'] ?? '-'),
              _buildKeyValueRow('Blok', item['blok']?['name'] ?? '-'),
              _buildKeyValueRow('Tambak', item['blok']?['tambak']?['name'] ?? '-'),
              _buildKeyValueRow('Perusahaan', item['blok']?['tambak']?['company']?['company_name'] ?? '-'),
            ],
          ),
        ),
      );
    } else if (res == 'ponds') {
      return _buildCardContainer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildKeyValueRow('Nama Petak', item['name'] ?? '-'),
              _buildKeyValueRow('Kode Petak', item['code'] ?? '-'),
              _buildKeyValueRow('Panjang', '${item['length'] ?? '-'} m'),
              _buildKeyValueRow('Lebar', '${item['width'] ?? '-'} m'),
              _buildKeyValueRow('Kedalaman', '${item['depth'] ?? '-'} m'),
              _buildKeyValueRow('Luas', '${item['luas'] ?? '-'}'),
              _buildKeyValueRow('Luas (m2)', '${item['luas_m2'] ?? '-'} m²'),
              _buildKeyValueRow('Modul', item['modul']?['name'] ?? '-'),
              _buildKeyValueRow('Blok', item['modul']?['blok']?['name'] ?? '-'),
              _buildKeyValueRow('Tambak', item['modul']?['blok']?['tambak']?['name'] ?? '-'),
            ],
          ),
        ),
      );
    } else if (res == 'cycles') {
      final isActive = item['is_active'] == true;
      return _buildCardContainer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildKeyValueRow('Nama Siklus', item['name'] ?? '-'),
              _buildKeyValueRow('Status', isActive ? 'Aktif' : 'Selesai'),
              _buildKeyValueRow('Tanggal Tebar', _formatDate(item['stocking_date'])),
              _buildKeyValueRow('Estimasi Selesai', _formatDate(item['estimated_end_date'])),
              _buildKeyValueRow('Perusahaan', item['company']?['company_name'] ?? '-'),
              _buildKeyValueRow('Modul', item['modul']?['name'] ?? '-'),
              _buildKeyValueRow('Tambak', item['modul']?['blok']?['tambak']?['name'] ?? '-'),
              _buildKeyValueRow('G-Sheet Feed URL', item['google_sheet_feed_url'] ?? '-'),
              _buildKeyValueRow('G-Sheet Saprotam URL', item['google_sheet_saprotam_url'] ?? '-'),
            ],
          ),
        ),
      );
    } else if (res == 'contracts') {
      final isActive = item['is_active'] == true;
      final brackets = item['brackets'] as List? ?? [];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardContainer(
            child: Padding(
              padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
              child: Column(
                children: [
                  _buildKeyValueRow('Nama Kontrak', item['name'] ?? '-'),
                  _buildKeyValueRow('No. Kontrak', item['contract_number'] ?? '-'),
                  _buildKeyValueRow('Tanggal Kontrak', _formatDate(item['contract_date'])),
                  _buildKeyValueRow('Nama Penjual', item['seller_name'] ?? '-'),
                  _buildKeyValueRow('Nama Pembeli', item['buyer_name'] ?? '-'),
                  _buildKeyValueRow('Lokasi Panen', item['location'] ?? '-'),
                  _buildKeyValueRow('Estimasi Tonase', '${item['harvest_tonnage'] ?? '-'} kg'),
                  _buildKeyValueRow('Range Size', item['harvest_size_range'] ?? '-'),
                  _buildKeyValueRow('Tanggal Panen', _formatDate(item['harvest_date'])),
                  _buildKeyValueRow('Status', isActive ? 'Aktif' : 'Mati'),
                  _buildKeyValueRow('Termin Pembayaran', item['payment_terms'] ?? '-'),
                  _buildKeyValueRow('Rekening Bank', item['bank_info'] ?? '-'),
                  _buildKeyValueRow('Persentase Moulting', '${item['moulting_percentage'] ?? '-'}%'),
                  _buildKeyValueRow('Persentase US', '${item['us_percentage'] ?? '-'}%'),
                  _buildKeyValueRow('Ketentuan Lain', item['other_terms'] ?? '-'),
                  _buildKeyValueRow('Catatan Sampling', item['sampling_notes'] ?? '-'),
                ],
              ),
            ),
          ),
          const SizedBox(height: CupertinoSpacing.xl),
          Text(
            'Size Brackets & Prices',
            style: context.callout.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: CupertinoSpacing.s),
          if (brackets.isEmpty)
            Padding(
              padding: const EdgeInsets.all(CupertinoSpacing.s),
              child: Text(
                'Tidak ada size brackets untuk kontrak ini.',
                style: context.subhead.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context), fontStyle: FontStyle.italic),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: brackets.length,
              itemBuilder: (context, index) {
                final b = brackets[index];
                final minSize = b['min_size'] ?? '-';
                final maxSize = b['max_size'] ?? '-';
                final baseSize = b['base_size'] ?? '-';
                final basePrice = b['base_price'];
                final inc = b['price_increment'];
                final dec = b['price_decrement'];
                return _buildCardContainer(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: CupertinoSpacing.m),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Size: $minSize - $maxSize (Dasar: $baseSize)',
                              style: context.subhead.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _formatRupiah(basePrice),
                              style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: CupertinoColors.activeBlue),
                            ),
                          ],
                        ),
                        const SizedBox(height: CupertinoSpacing.xs),
                        Text(
                          'Increment: ${_formatRupiah(inc)} | Decrement: ${_formatRupiah(dec)}',
                          style: context.caption1.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      );
    } else if (res == 'saprotam-logs') {
      return _buildCardContainer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildKeyValueRow('Produk', item['product_name'] ?? '-'),
              _buildKeyValueRow('Jumlah', '${item['amount'] ?? '-'} ${item['unit'] ?? ''}'),
              _buildKeyValueRow('Tanggal', _formatDate(item['date'])),
              _buildKeyValueRow('Petak', item['pond']?['name'] ?? '-'),
              _buildKeyValueRow('Siklus', item['cycle']?['name'] ?? '-'),
              _buildKeyValueRow('Modul', item['pond']?['modul']?['name'] ?? '-'),
              _buildKeyValueRow('Tambak', item['pond']?['modul']?['blok']?['tambak']?['name'] ?? '-'),
            ],
          ),
        ),
      );
    } else if (res == 'cost-centres') {
      final isActive = item['is_active'] == true;
      return _buildCardContainer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildKeyValueRow('Kode Cost Centre', item['code'] ?? '-'),
              _buildKeyValueRow('Nama Cost Centre', item['name'] ?? '-'),
              _buildKeyValueRow('Parent Code', item['parent_code'] ?? '-'),
              _buildKeyValueRow('Tanggal Mulai', _formatDate(item['start_date'])),
              _buildKeyValueRow('Tanggal Selesai', _formatDate(item['end_date'])),
              _buildKeyValueRow('Luas', '${item['luas'] ?? '-'}'),
              _buildKeyValueRow('Luas (m2)', '${item['luas_m2'] ?? '-'} m²'),
              _buildKeyValueRow('Status', isActive ? 'Aktif' : 'Nonaktif'),
              _buildKeyValueRow('Perusahaan', item['company']?['company_name'] ?? '-'),
            ],
          ),
        ),
      );
    }

    return Text(item.toString());
  }

  Widget _buildDetailView(dynamic item) {
    if (item == null) {
      return Center(
        child: Text(
          'Pilih item untuk melihat detail.',
          style: context.subhead.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
        ),
      );
    }

    final id = item['id'] as int;
    final res = widget.resource;
    final config = aquacultureCrudConfigs[res];
    final title = config?.title ?? 'Data';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Detail $title',
                  style: context.title3.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        _isEditing = true;
                        _isAdding = false;
                      });
                    },
                    child: const Icon(CupertinoIcons.pencil, color: CupertinoColors.activeBlue),
                  ),
                  const SizedBox(width: CupertinoSpacing.s),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      await _deleteRecord(id);
                      setState(() {
                        _selectedId = null;
                      });
                    },
                    child: const Icon(CupertinoIcons.trash, color: CupertinoColors.destructiveRed),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: CupertinoSpacing.s),
          Container(height: 0.5, color: CupertinoColors.separator.resolveFrom(context)),
          const SizedBox(height: CupertinoSpacing.l),
          _buildDetailFields(item),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = aquacultureCrudConfigs[widget.resource];
    final title = config?.title ?? 'Data';
    final isWide = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    final asyncList = ref.watch(aquacultureCrudListProvider(widget.resource));
    final borderCol = CupertinoColors.separator.resolveFrom(context);

    final listContent = Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(CupertinoSpacing.m),
          child: CupertinoSearchTextField(
            controller: _searchController,
            placeholder: 'Cari...',
            onChanged: (val) => setState(() => _searchQuery = val),
          ),
        ),
        Expanded(
          child: asyncList.when(
            data: (list) {
              final filtered = list.where((item) => _matchesSearch(item, _searchQuery)).toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Text(
                    'Tidak ada data ditemukan.',
                    style: context.subhead.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                  ),
                );
              }

              if (isWide && filtered.isNotEmpty && _selectedId == null && !_isAdding) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _selectedId = filtered.first['id'] as int;
                    });
                  }
                });
              }

              final notifier = ref.read(aquacultureCrudListProvider(widget.resource).notifier);

              return CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: () => notifier.refresh(),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.m, vertical: CupertinoSpacing.s),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == filtered.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: CupertinoSpacing.l),
                              child: Center(child: CupertinoActivityIndicator()),
                            );
                          }

                          final item = filtered[index];
                          final id = item['id'] as int;
                          final isSelected = isWide && _selectedId == id;

                          return CupertinoGlassContainer(
                            margin: const EdgeInsets.only(bottom: CupertinoSpacing.s),
                            borderRadius: CupertinoSpacing.cardRadius,
                            borderColor: isSelected
                                ? CupertinoColors.activeBlue.resolveFrom(context)
                                : borderCol,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                if (isWide) {
                                  setState(() {
                                    _selectedId = id;
                                    _isEditing = false;
                                    _isAdding = false;
                                  });
                                } else {
                                  context.go('/aquaculture/${widget.resource}/edit/$id');
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.l, vertical: CupertinoSpacing.m),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(child: _buildCardContent(item)),
                                    if (!isWide)
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () => context.go('/aquaculture/${widget.resource}/edit/$id'),
                                            child: const Icon(CupertinoIcons.pencil, size: 20, color: CupertinoColors.activeBlue),
                                          ),
                                          const SizedBox(width: CupertinoSpacing.xs),
                                          CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () => _deleteRecord(id),
                                            child: const Icon(CupertinoIcons.trash, size: 20, color: CupertinoColors.destructiveRed),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: filtered.length + (notifier.hasMore ? 1 : 0),
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (err, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(CupertinoSpacing.xxl),
                child: Text(
                  'Error loading data: $err',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: CupertinoColors.destructiveRed),
                ),
              ),
            ),
          ),
        ),
      ],
    );

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        middle: Text(title),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            if (isWide) {
              setState(() {
                _isAdding = true;
                _selectedId = null;
                _isEditing = false;
              });
            } else {
              context.go('/aquaculture/${widget.resource}/create');
            }
          },
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const CompanySwitcher(),
            Expanded(
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: listContent,
                        ),
                        Container(width: 0.5, color: borderCol),
                        Expanded(
                          flex: 4,
                          child: Container(
                            color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                            child: _isAdding
                                ? AquacultureCrudFormScreen(
                                    resource: widget.resource,
                                    isEmbedded: true,
                                    onSaved: () {
                                      setState(() {
                                        _isAdding = false;
                                        _selectedId = null;
                                      });
                                      ref.read(aquacultureCrudListProvider(widget.resource).notifier).refresh();
                                    },
                                    onCancel: () {
                                      setState(() {
                                        _isAdding = false;
                                      });
                                    },
                                  )
                                : _isEditing
                                    ? AquacultureCrudFormScreen(
                                        resource: widget.resource,
                                        recordId: _selectedId,
                                        isEmbedded: true,
                                        onSaved: () {
                                          setState(() {
                                            _isEditing = false;
                                          });
                                          ref.read(aquacultureCrudListProvider(widget.resource).notifier).refresh();
                                        },
                                        onCancel: () {
                                          setState(() {
                                            _isEditing = false;
                                          });
                                        },
                                      )
                                    : asyncList.maybeWhen(
                                        data: (list) {
                                          final selectedItem = list.firstWhere(
                                            (item) => item['id'] == _selectedId,
                                            orElse: () => null,
                                          );
                                          return _buildDetailView(selectedItem);
                                        },
                                        orElse: () => _buildDetailView(null),
                                      ),
                          ),
                        ),
                      ],
                    )
                  : listContent,
            ),
          ],
        ),
      ),
    );
  }
}
