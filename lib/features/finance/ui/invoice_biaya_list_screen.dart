import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider, VerticalDivider, Scrollbar, showDateRangePicker, Theme, ColorScheme, DateTimeRange;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/invoice_biaya.dart';
import '../providers/invoice_biaya_repository.dart';
import 'invoice_biaya_detail_screen.dart';
import '../../../core/widgets/company_switcher.dart';
import '../../../core/utils/currency_utils.dart';
import '../../payment_request/providers/payment_request_repository.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';
import '../../../core/widgets/cupertino_glass_dialog.dart';

class InvoiceBiayaListScreen extends ConsumerStatefulWidget {
  const InvoiceBiayaListScreen({super.key});

  @override
  ConsumerState<InvoiceBiayaListScreen> createState() => _InvoiceBiayaListScreenState();
}

class _InvoiceBiayaListScreenState extends ConsumerState<InvoiceBiayaListScreen> {
  String? _selectedStatus; // null means all
  int? _selectedInvoiceId;
  final ScrollController _scrollController = ScrollController();

  DateTime? _startDate;
  DateTime? _endDate;
  String _datePreset = 'all';

  // Selection mode for Payment Request creation
  bool _isSelectionMode = false;
  final Set<int> _selectedInvoiceIds = {};

  String? get _startDateStr => _startDate != null
      ? '${_startDate!.day.toString().padLeft(2, '0')}/${_startDate!.month.toString().padLeft(2, '0')}/${_startDate!.year}'
      : null;

  String? get _endDateStr => _endDate != null
      ? '${_endDate!.day.toString().padLeft(2, '0')}/${_endDate!.month.toString().padLeft(2, '0')}/${_endDate!.year}'
      : null;

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
      ref.read(invoiceBiayasProvider(
        status: _selectedStatus,
        startDate: _startDateStr,
        endDate: _endDateStr,
      ).notifier).loadMore();
    }
  }

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
              primary: Color(0xFF6E56CF), // Notion Purple
              onPrimary: CupertinoColors.white,
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

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedInvoiceIds.contains(id)) {
        _selectedInvoiceIds.remove(id);
      } else {
        _selectedInvoiceIds.add(id);
      }
    });
  }

  Future<void> _submitBulkPaymentRequest() async {
    if (_selectedInvoiceIds.isEmpty) return;

    DateTime requestDate = DateTime.now();
    final descriptionController = TextEditingController();

    final success = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoGlassDialog(
        title: const Text('Submit Payment Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Membuat permintaan pembayaran untuk ${_selectedInvoiceIds.length} Invoice Biaya.'),
            const SizedBox(height: CupertinoSpacing.m),
            CupertinoTextField(
              controller: descriptionController,
              placeholder: 'Keterangan/Alasan Pembayaran',
              placeholderStyle: context.subhead.copyWith(color: CupertinoColors.placeholderText.resolveFrom(context)),
              decoration: BoxDecoration(
                border: Border.all(color: CupertinoColors.separator.resolveFrom(context)),
                borderRadius: BorderRadius.circular(6),
              ),
              maxLines: 2,
              padding: const EdgeInsets.all(CupertinoSpacing.s),
            ),
          ],
        ),
        actions: [
          CupertinoGlassDialogAction(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context, false),
          ),
          CupertinoGlassDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ajukan'),
          ),
        ],
      ),
    );

    if (success == true) {
      try {
        final prRepository = ref.read(paymentRequestRepositoryProvider);
        await prRepository.dio.post('wh/payment-requests', data: {
          'invoice_type': 'biaya',
          'invoice_ids': _selectedInvoiceIds.toList(),
          'request_date': requestDate.toIso8601String().substring(0, 10),
          'description': descriptionController.text.isNotEmpty ? descriptionController.text : 'Payment Request Invoice Biaya',
        });

        if (mounted) {
          CupertinoGlassToast.showSuccess(context, 'Permintaan Pembayaran berhasil dibuat.');

          setState(() {
            _isSelectionMode = false;
            _selectedInvoiceIds.clear();
            _selectedInvoiceId = null;
          });

          ref.invalidate(invoiceBiayasProvider);
        }
      } catch (e) {
        if (mounted) {
          CupertinoGlassToast.showError(context, 'Gagal membuat permintaan: $e');
        }
      }
    }
  }

  Widget _buildFilterChip(String label, String? value) {
    final isSelected = _selectedStatus == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = value;
          _selectedInvoiceId = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.m, vertical: CupertinoSpacing.xs + 2),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6E56CF) : CupertinoColors.systemGroupedBackground.resolveFrom(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF6E56CF) : CupertinoColors.separator.resolveFrom(context),
          ),
        ),
        child: Text(
          label,
          style: context.caption1.copyWith(
            color: isSelected ? CupertinoColors.white : CupertinoColors.label.resolveFrom(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final invoicesAsync = ref.watch(invoiceBiayasProvider(
      status: _selectedStatus,
      startDate: _startDateStr,
      endDate: _endDateStr,
    ));
    final isWide = MediaQuery.of(context).size.width > 900;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        middle: Text(
          'Invoice Biaya',
          style: context.headline.copyWith(color: CupertinoColors.label.resolveFrom(context)),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(
                _isSelectionMode ? CupertinoIcons.xmark_circle : CupertinoIcons.checkmark_circle_fill,
                color: CupertinoColors.activeBlue,
                size: 22,
              ),
              onPressed: () {
                setState(() {
                  _isSelectionMode = !_isSelectionMode;
                  _selectedInvoiceIds.clear();
                });
              },
            ),
            const SizedBox(width: CupertinoSpacing.s),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.add, color: CupertinoColors.activeBlue, size: 22),
              onPressed: () {
                context.push('/invoice-biaya/create');
              },
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const CompanySwitcher(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.halfScreenMargin),
              decoration: BoxDecoration(
                color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                border: Border(bottom: BorderSide(color: CupertinoColors.separator.resolveFrom(context), width: 0.5)),
              ),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.calendar, size: 16, color: Color(0xFF6E56CF)),
                  const SizedBox(width: CupertinoSpacing.s),
                  Text(
                    'Periode:',
                    style: context.footnote.copyWith(fontWeight: FontWeight.bold, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                  ),
                  const SizedBox(width: CupertinoSpacing.m),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        onPressed: () {
                          // Standard action sheet for preset selection
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
                                  child: const Text('Batal'),
                                  onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          _datePreset == 'all' ? 'Semua Waktu' :
                          _datePreset == '30days' ? '30 Hari Terakhir' :
                          _datePreset == 'thisMonth' ? 'Bulan Ini' :
                          _datePreset == '90days' ? '3 Bulan Terakhir' : 'Kustom',
                          style: context.footnote.copyWith(color: const Color(0xFF6E56CF), fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  if (_startDate != null && _endDate != null) ...[
                    Text(
                      '${_startDate!.day}/${_startDate!.month} - ${_endDate!.day}/${_endDate!.month}',
                      style: context.caption1.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              height: 48,
              color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.halfScreenMargin),
                child: Row(
                  children: [
                    _buildFilterChip('Semua', null),
                    const SizedBox(width: CupertinoSpacing.s),
                    _buildFilterChip('Draft', 'draft'),
                    const SizedBox(width: CupertinoSpacing.s),
                    _buildFilterChip('Pending', 'pending'),
                    const SizedBox(width: CupertinoSpacing.s),
                    _buildFilterChip('Submitted', 'submitted'),
                    const SizedBox(width: CupertinoSpacing.s),
                    _buildFilterChip('Paid', 'paid'),
                    const SizedBox(width: CupertinoSpacing.s),
                    _buildFilterChip('Cancelled', 'cancelled'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: invoicesAsync.when(
                data: (invoices) {
                  if (invoices.isEmpty) {
                    return Center(
                      child: Text(
                        'Tidak ada invoice biaya yang ditemukan',
                        style: context.subhead.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                      ),
                    );
                  }

                  if (isWide) {
                    if (_selectedInvoiceId == null || !invoices.any((x) => x.id == _selectedInvoiceId)) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted && invoices.isNotEmpty) {
                          setState(() {
                            _selectedInvoiceId = invoices.first.id;
                          });
                        }
                      });
                    }
                  }

                  final hasMore = ref.watch(invoiceBiayasProvider(
                    status: _selectedStatus,
                    startDate: _startDateStr,
                    endDate: _endDateStr,
                  ).notifier).hasMore;
                  final showLoader = invoicesAsync.isLoading && hasMore;

                  final mainList = Scrollbar(
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                      itemCount: invoices.length + (showLoader ? 1 : 0),
                      separatorBuilder: (context, index) => const SizedBox(height: CupertinoSpacing.m),
                      itemBuilder: (context, index) {
                        if (index == invoices.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: CupertinoSpacing.screenMargin),
                            child: Center(child: CupertinoActivityIndicator()),
                          );
                        }
                        final invoice = invoices[index];
                        final isSelected = invoice.id == _selectedInvoiceId;
                        final isChecked = _selectedInvoiceIds.contains(invoice.id);

                        return _InvoiceBiayaCard(
                          invoice: invoice,
                          isSelected: isSelected,
                          isSelectionMode: _isSelectionMode,
                          isChecked: isChecked,
                          onTap: () {
                            if (_isSelectionMode) {
                              if (invoice.status == 'pending') {
                                _toggleSelection(invoice.id);
                              } else {
                                CupertinoGlassToast.showError(context, 'Hanya invoice dengan status PENDING yang dapat diajukan.');
                              }
                            } else {
                              if (isWide) {
                                setState(() {
                                  _selectedInvoiceId = invoice.id;
                                });
                              } else {
                                context.push('/invoice-biaya/${invoice.id}');
                              }
                            }
                          },
                        );
                      },
                    ),
                  );

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 360,
                          child: Column(
                            children: [
                              Expanded(child: mainList),
                              if (_isSelectionMode && _selectedInvoiceIds.isNotEmpty)
                                _buildBulkSubmitBar(),
                            ],
                          ),
                        ),
                        const VerticalDivider(width: 1, thickness: 0.5, color: CupertinoColors.separator),
                        Expanded(
                          child: _selectedInvoiceId != null
                              ? KeyedSubtree(
                                  key: ValueKey(_selectedInvoiceId),
                                  child: InvoiceBiayaDetailScreen(
                                    invoiceId: _selectedInvoiceId!,
                                    isEmbedded: true,
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    'Pilih Invoice untuk melihat detail',
                                    style: context.body.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                                  ),
                                ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        Expanded(child: mainList),
                        if (_isSelectionMode && _selectedInvoiceIds.isNotEmpty)
                          _buildBulkSubmitBar(),
                      ],
                    );
                  }
                },
                loading: () => const Center(child: CupertinoActivityIndicator()),
                error: (err, _) => Center(child: Text('Gagal memuat data: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulkSubmitBar() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(CupertinoSpacing.m),
        decoration: BoxDecoration(
          color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
          border: const Border(top: BorderSide(color: CupertinoColors.separator, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_selectedInvoiceIds.length} invoice terpilih',
              style: context.subhead.copyWith(fontWeight: FontWeight.bold),
            ),
            CupertinoButton(
              color: const Color(0xFF6E56CF),
              padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.halfScreenMargin),
              borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
              minimumSize: Size.zero,
              onPressed: _submitBulkPaymentRequest,
              child: Text(
                'Ajukan Pembayaran',
                style: context.footnote.copyWith(color: CupertinoColors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InvoiceBiayaCard extends StatelessWidget {
  final InvoiceBiaya invoice;
  final bool isSelected;
  final bool isSelectionMode;
  final bool isChecked;
  final VoidCallback onTap;

  const _InvoiceBiayaCard({
    required this.invoice,
    required this.isSelected,
    required this.isSelectionMode,
    required this.isChecked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (invoice.status.toLowerCase()) {
      case 'draft':
        statusColor = CupertinoColors.systemGrey;
        break;
      case 'pending':
        statusColor = CupertinoColors.activeOrange;
        break;
      case 'submitted':
        statusColor = CupertinoColors.activeBlue;
        break;
      case 'paid':
        statusColor = CupertinoColors.systemGreen;
        break;
      case 'cancelled':
        statusColor = CupertinoColors.systemRed;
        break;
      default:
        statusColor = CupertinoColors.systemGrey;
    }

    final isChecked = this.isChecked;
    final isSelected = this.isSelected;

    return CupertinoGlassContainer(
      borderRadius: CupertinoSpacing.cardRadius + 2,
      backgroundColor: isSelected 
          ? const Color(0xFF6E56CF).withValues(alpha: 0.08) 
          : null,
      borderColor: isSelected 
          ? const Color(0xFF6E56CF) 
          : null,
      padding: EdgeInsets.zero,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
          child: Row(
            children: [
              if (isSelectionMode) ...[
                Container(
                  margin: const EdgeInsets.only(right: CupertinoSpacing.m),
                  child: Icon(
                    isChecked ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.circle,
                    color: isChecked ? const Color(0xFF6E56CF) : CupertinoColors.inactiveGray,
                    size: 20,
                  ),
                ),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          invoice.invoiceNumber,
                          style: context.subhead.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.halfScreenMargin, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: statusColor, width: 0.5),
                          ),
                          child: Text(
                            invoice.status.toUpperCase(),
                            style: context.caption2.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: CupertinoSpacing.xs + 2),
                    Text(
                      invoice.supplierName ?? 'Pemasok Tidak Diketahui',
                      style: context.footnote.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: CupertinoSpacing.xs),
                    if (invoice.vendorInvoiceNumber != null && invoice.vendorInvoiceNumber!.isNotEmpty) ...[
                      Text(
                        'No. Invoice Vendor: ${invoice.vendorInvoiceNumber}',
                        style: context.caption1.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                      ),
                      const SizedBox(height: CupertinoSpacing.xs),
                    ],
                    Row(
                      children: [
                        const Icon(CupertinoIcons.time, size: 12, color: CupertinoColors.secondaryLabel),
                        const SizedBox(width: CupertinoSpacing.xs),
                        Text(
                          'Tanggal: ${_formatDate(invoice.invoiceDate)}',
                          style: context.caption1.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                        ),
                        if (invoice.dueDate != null) ...[
                          const SizedBox(width: CupertinoSpacing.m),
                          const Icon(CupertinoIcons.exclamationmark_triangle, size: 12, color: CupertinoColors.secondaryLabel),
                          const SizedBox(width: CupertinoSpacing.xs),
                          Text(
                            'Tempo: ${_formatDate(invoice.dueDate)}',
                            style: context.caption1.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                          ),
                        ],
                      ],
                    ),
                    const Divider(color: CupertinoColors.separator, height: CupertinoSpacing.m + 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Biaya',
                          style: context.caption1.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                        ),
                        Text(
                          formatWithCurrency(invoice.totalAmount, invoice.currency),
                          style: context.subhead.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
}
