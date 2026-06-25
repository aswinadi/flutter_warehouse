import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider, Colors, DateTimeRange, showDateRangePicker, Theme, MaterialScrollBehavior, ColorScheme;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/invoice_repository.dart';
import '../models/invoice.dart';
import 'invoice_approval_screen.dart';
import '../../../core/widgets/company_switcher.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';

// Enables mouse + trackpad drag scrolling on Flutter Web.
class _WebScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class InvoiceListScreen extends ConsumerStatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  ConsumerState<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends ConsumerState<InvoiceListScreen> {
  String? _selectedStatus; // null means "Semua"
  int? _selectedInvoiceId;
  final ScrollController _scrollController = ScrollController();

  DateTime? _startDate;
  DateTime? _endDate;
  String _datePreset = 'all';

  String? get _startDateStr => _startDate != null
      ? '${_startDate!.day.toString().padLeft(2, '0')}/${_startDate!.month.toString().padLeft(2, '0')}/${_startDate!.year}'
      : null;

  String? get _endDateStr => _endDate != null
      ? '${_endDate!.day.toString().padLeft(2, '0')}/${_endDate!.month.toString().padLeft(2, '0')}/${_endDate!.year}'
      : null;

  void _updateDatePreset(String preset) {
    setState(() {
      _datePreset = preset;
      if (preset == 'all') {
        _startDate = null;
        _endDate = null;
      } else if (preset == '30days') {
        _endDate = DateTime.now();
        _startDate = DateTime.now().subtract(const Duration(days: 30));
      } else if (preset == 'thisMonth') {
        _endDate = DateTime.now();
        _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
      } else if (preset == '90days') {
        _endDate = DateTime.now();
        _startDate = DateTime.now().subtract(const Duration(days: 90));
      }
      _selectedInvoiceId = null;
    });
  }

  Future<void> _selectCustomDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4F46E5),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _selectedInvoiceId = null;
      });
    }
  }

  Future<void> _showPresetPicker() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Pilih Periode'),
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Semua Waktu'),
            onPressed: () {
              _updateDatePreset('all');
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('30 Hari Terakhir'),
            onPressed: () {
              _updateDatePreset('30days');
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Bulan Ini'),
            onPressed: () {
              _updateDatePreset('thisMonth');
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('3 Bulan Terakhir'),
            onPressed: () {
              _updateDatePreset('90days');
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Pilih Tanggal...'),
            onPressed: () {
              Navigator.pop(context);
              _selectCustomDateRange();
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll * 0.9) {
      ref.read(invoicesProvider(
        status: _selectedStatus,
        startDate: _startDateStr,
        endDate: _endDateStr,
      ).notifier).loadMore();
    }
  }

  Widget _buildFilterChip(String label, String? value) {
    final isSelected = _selectedStatus == value;
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final activeColor = CupertinoColors.activeBlue.resolveFrom(context);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = isSelected ? null : value;
          _selectedInvoiceId = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected 
              ? activeColor 
              : CupertinoColors.tertiarySystemFill.resolveFrom(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: context.footnote.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected 
                ? CupertinoColors.white 
                : labelColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final invoicesAsync = ref.watch(invoicesProvider(
      status: _selectedStatus,
      startDate: _startDateStr,
      endDate: _endDateStr,
    ));
    final isWide = MediaQuery.of(context).size.width > 900;
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);
    final bgColor = CupertinoColors.systemGroupedBackground.resolveFrom(context);
    final secondaryBgColor = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);

    return CupertinoPageScaffold(
      backgroundColor: bgColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        middle: Text(
          'Purchase Invoice (Faktur)',
          style: TextStyle(color: labelColor),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          minSize: 32,
          child: const Icon(CupertinoIcons.refresh, size: 22),
          onPressed: () {
            setState(() {
              _selectedInvoiceId = null;
            });
            ref.invalidate(invoicesProvider);
          },
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const CompanySwitcher(),
            GestureDetector(
              onTap: _showPresetPicker,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground.resolveFrom(context),
                  border: Border(bottom: BorderSide(color: CupertinoColors.separator.resolveFrom(context), width: 0.5)),
                ),
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.calendar, size: 16, color: CupertinoColors.activeBlue),
                    const SizedBox(width: 8),
                    Text(
                      'Periode:',
                      style: context.footnote.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _datePreset == 'all' ? 'Semua Waktu' :
                        _datePreset == '30days' ? '30 Hari Terakhir' :
                        _datePreset == 'thisMonth' ? 'Bulan Ini' :
                        _datePreset == '90days' ? '3 Bulan Terakhir' : 'Kustom...',
                        style: context.footnote.copyWith(fontWeight: FontWeight.w600, color: CupertinoColors.activeBlue),
                      ),
                    ),
                    if (_startDate != null && _endDate != null) ...[
                      Text(
                        '${_startDate!.day}/${_startDate!.month}/${_startDate!.year} - ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                        style: context.caption1.copyWith(color: secondaryLabelColor, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 8),
                    ],
                    const Icon(CupertinoIcons.chevron_down, size: 14, color: CupertinoColors.inactiveGray),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 52,
              child: Stack(
                children: [
                  ScrollConfiguration(
                    behavior: _WebScrollBehavior(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          _buildFilterChip('Semua', null),
                          const SizedBox(width: 8),
                          _buildFilterChip('Draft', 'draft'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Approved', 'approved'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Pending', 'pending'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Paid', 'paid'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Rejected', 'rejected'),
                          const SizedBox(width: 24),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    width: 48,
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              CupertinoColors.systemBackground.resolveFrom(context).withValues(alpha: 0.0),
                              CupertinoColors.systemBackground.resolveFrom(context),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: invoicesAsync.when(
                data: (invoices) {
                  if (invoices.isEmpty) {
                    return Center(
                      child: Text(
                        'Tidak ada invoice yang ditemukan',
                        style: context.subhead.copyWith(color: secondaryLabelColor),
                      ),
                    );
                  }

                  if (isWide) {
                    if (_selectedInvoiceId == null || !invoices.any((x) => x.id == _selectedInvoiceId)) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _selectedInvoiceId = invoices.first.id;
                          });
                        }
                      });
                    }
                  }

                  final hasMore = ref.watch(invoicesProvider(
                    status: _selectedStatus,
                    startDate: _startDateStr,
                    endDate: _endDateStr,
                  ).notifier).hasMore;
                  final showLoader = invoicesAsync.isLoading && hasMore;

                  final mainList = CustomScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      CupertinoSliverRefreshControl(
                        onRefresh: () async {
                          ref.invalidate(invoicesProvider);
                        },
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index == invoices.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(child: CupertinoActivityIndicator()),
                                );
                              }
                              final invoice = invoices[index];
                              final isSelected = invoice.id == _selectedInvoiceId;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: _InvoiceCard(
                                  invoice: invoice,
                                  isSelected: isSelected,
                                  onTap: () {
                                    if (isWide) {
                                      setState(() {
                                        _selectedInvoiceId = invoice.id;
                                      });
                                    } else {
                                      context.push('/approvals/invoice/${invoice.id}');
                                    }
                                  },
                                ),
                              );
                            },
                            childCount: invoices.length + (showLoader ? 1 : 0),
                          ),
                        ),
                      ),
                    ],
                  );

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 360,
                          child: mainList,
                        ),
                        Container(
                          width: 1,
                          color: CupertinoColors.separator.resolveFrom(context),
                        ),
                        Expanded(
                          child: _selectedInvoiceId != null
                              ? KeyedSubtree(
                                  key: ValueKey(_selectedInvoiceId),
                                  child: Container(
                                    color: secondaryBgColor,
                                    child: InvoiceApprovalScreen(
                                      invoiceId: _selectedInvoiceId!,
                                      isEmbedded: true,
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(CupertinoIcons.doc_text, size: 48, color: secondaryLabelColor),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Pilih Invoice untuk melihat detail',
                                        style: TextStyle(color: secondaryLabelColor),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    );
                  } else {
                    return mainList;
                  }
                },
                loading: () => const Center(child: CupertinoActivityIndicator()),
                error: (err, _) => Center(
                  child: Text(
                    'Gagal memuat data: $err',
                    style: TextStyle(color: secondaryLabelColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDate(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return '-';
  try {
    final parsed = DateTime.parse(dateStr);
    return '${parsed.day.toString().padLeft(2, '0')}-${parsed.month.toString().padLeft(2, '0')}-${parsed.year}';
  } catch (e) {
    if (dateStr.length > 10) {
      return dateStr.substring(0, 10);
    }
    return dateStr;
  }
}

class _InvoiceCard extends StatelessWidget {
  final Invoice invoice;
  final bool isSelected;
  final VoidCallback onTap;

  const _InvoiceCard({
    required this.invoice,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);
    final cardColor = isSelected
        ? CupertinoColors.activeBlue.resolveFrom(context).withValues(alpha: 0.08)
        : null;

    return CupertinoGlassContainer(
      backgroundColor: cardColor,
      borderColor: isSelected 
          ? CupertinoColors.activeBlue.resolveFrom(context) 
          : null,
      borderRadius: CupertinoSpacing.cardRadius,
      padding: const EdgeInsets.all(CupertinoSpacing.l),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  invoice.invoiceNumber,
                  style: context.callout.copyWith(
                    fontWeight: FontWeight.bold,
                    color: labelColor,
                  ),
                ),
                _StatusBadge(status: invoice.status),
              ],
            ),
            if (invoice.receivingNumber != null && invoice.receivingNumber!.isNotEmpty) ...[
              const SizedBox(height: CupertinoSpacing.xs),
              Text(
                'No. Penerimaan: ${invoice.receivingNumber}',
                style: context.footnote.copyWith(
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.activeBlue,
                ),
              ),
            ],
            const SizedBox(height: CupertinoSpacing.s),
            Text(
              invoice.supplierName ?? 'Internal',
              style: context.subhead.copyWith(
                fontWeight: FontWeight.w600,
                color: labelColor,
              ),
            ),
            const SizedBox(height: CupertinoSpacing.xs),
            if (invoice.vendorInvoiceNumber != null && invoice.vendorInvoiceNumber!.isNotEmpty) ...[
              Text(
                'No. Invoice Vendor: ${invoice.vendorInvoiceNumber}',
                style: context.footnote.copyWith(color: secondaryLabelColor),
              ),
              const SizedBox(height: CupertinoSpacing.xs),
            ],
            Row(
              children: [
                Icon(CupertinoIcons.calendar, size: 14, color: secondaryLabelColor),
                const SizedBox(width: CupertinoSpacing.xs),
                Text(
                  'Tanggal: ${_formatDate(invoice.invoiceDate)}',
                  style: context.footnote.copyWith(color: secondaryLabelColor),
                ),
                if (invoice.dueDate != null) ...[
                  const SizedBox(width: CupertinoSpacing.m),
                  Icon(CupertinoIcons.exclamationmark_shield_fill, size: 14, color: secondaryLabelColor),
                  const SizedBox(width: CupertinoSpacing.xs),
                  Text(
                    'Tempo: ${_formatDate(invoice.dueDate)}',
                    style: context.footnote.copyWith(color: secondaryLabelColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
            const Divider(height: CupertinoSpacing.xxl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Tagihan',
                  style: context.caption1.copyWith(color: secondaryLabelColor),
                ),
                Text(
                  formatWithCurrency(invoice.totalAmount, invoice.currency),
                  style: context.callout.copyWith(
                    fontWeight: FontWeight.bold,
                    color: labelColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    CupertinoDynamicColor color;
    switch (status.toLowerCase()) {
      case 'approved':
      case 'paid':
        color = CupertinoColors.systemGreen;
        break;
      case 'pending':
        color = CupertinoColors.systemOrange;
        break;
      case 'draft':
        color = CupertinoColors.systemGrey;
        break;
      case 'cancelled':
      case 'rejected':
        color = CupertinoColors.systemRed;
        break;
      default:
        color = CupertinoColors.systemBlue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 0.5),
      ),
      child: Text(
        status.toUpperCase(),
        style: context.caption2.copyWith(
          color: color.resolveFrom(context),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
