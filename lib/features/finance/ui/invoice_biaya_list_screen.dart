import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors, Divider, VerticalDivider, Icons, Scrollbar, showDatePicker, showDateRangePicker, Theme, ColorScheme, DateTimeRange;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/invoice_biaya.dart';
import '../providers/invoice_biaya_repository.dart';
import 'invoice_biaya_detail_screen.dart';
import 'invoice_biaya_form_screen.dart';
import '../../../core/widgets/company_switcher.dart';
import '../../../core/utils/currency_utils.dart';
import '../../payment_request/providers/payment_request_repository.dart';

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
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Submit Payment Request'),
        content: Container(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Membuat permintaan pembayaran untuk ${_selectedInvoiceIds.length} Invoice Biaya.'),
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: descriptionController,
                placeholder: 'Keterangan/Alasan Pembayaran',
                placeholderStyle: const TextStyle(color: CupertinoColors.placeholderText, fontSize: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: CupertinoColors.separator),
                  borderRadius: BorderRadius.circular(6),
                ),
                maxLines: 2,
                padding: const EdgeInsets.all(8),
              ),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context, false),
          ),
          CupertinoDialogAction(
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
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Sukses'),
              content: const Text('Permintaan Pembayaran berhasil dibuat.'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );

          setState(() {
            _isSelectionMode = false;
            _selectedInvoiceIds.clear();
            _selectedInvoiceId = null;
          });

          ref.invalidate(invoiceBiayasProvider);
        }
      } catch (e) {
        if (mounted) {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Gagal'),
              content: Text('Gagal membuat permintaan: $e'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6E56CF) : CupertinoColors.systemGroupedBackground.resolveFrom(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF6E56CF) : CupertinoColors.separator.resolveFrom(context),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? CupertinoColors.white : CupertinoColors.label.resolveFrom(context),
            fontSize: 12,
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
          style: TextStyle(color: CupertinoColors.label.resolveFrom(context)),
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
            const SizedBox(width: 8),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                border: Border(bottom: BorderSide(color: CupertinoColors.separator.resolveFrom(context), width: 0.5)),
              ),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.calendar, size: 16, color: Color(0xFF6E56CF)),
                  const SizedBox(width: 8),
                  const Text(
                    'Periode:',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: CupertinoColors.secondaryLabel),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 0,
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
                          style: const TextStyle(fontSize: 13, color: Color(0xFF6E56CF), fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  if (_startDate != null && _endDate != null) ...[
                    Text(
                      '${_startDate!.day}/${_startDate!.month} - ${_endDate!.day}/${_endDate!.month}',
                      style: const TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _buildFilterChip('Semua', null),
                    const SizedBox(width: 8),
                    _buildFilterChip('Draft', 'draft'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Pending', 'pending'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Submitted', 'submitted'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Paid', 'paid'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Cancelled', 'cancelled'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: invoicesAsync.when(
                data: (invoices) {
                  if (invoices.isEmpty) {
                    return const Center(
                      child: Text(
                        'Tidak ada invoice biaya yang ditemukan',
                        style: TextStyle(color: CupertinoColors.secondaryLabel, fontSize: 15),
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
                      padding: const EdgeInsets.all(16),
                      itemCount: invoices.length + (showLoader ? 1 : 0),
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        if (index == invoices.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
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
                                // Show warning
                                showCupertinoDialog(
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                    title: const Text('Status Tidak Valid'),
                                    content: const Text('Hanya invoice dengan status PENDING yang dapat diajukan.'),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: const Text('OK'),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                );
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
                              : const Center(
                                  child: Text(
                                    'Pilih Invoice untuk melihat detail',
                                    style: TextStyle(color: CupertinoColors.secondaryLabel),
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
          border: const Border(top: BorderSide(color: CupertinoColors.separator, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_selectedInvoiceIds.length} invoice terpilih',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            CupertinoButton(
              color: const Color(0xFF6E56CF),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              borderRadius: BorderRadius.circular(8),
              minSize: 0,
              onPressed: _submitBulkPaymentRequest,
              child: const Text(
                'Ajukan Pembayaran',
                style: TextStyle(color: CupertinoColors.white, fontSize: 13, fontWeight: FontWeight.bold),
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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF6E56CF) : CupertinoColors.separator.resolveFrom(context),
            width: isSelected ? 2.0 : 0.5,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (isSelectionMode) ...[
              Container(
                margin: const EdgeInsets.only(right: 12),
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
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: statusColor, width: 0.5),
                        ),
                        child: Text(
                          invoice.status.toUpperCase(),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    invoice.supplierName ?? 'Pemasok Tidak Diketahui',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (invoice.vendorInvoiceNumber != null && invoice.vendorInvoiceNumber!.isNotEmpty) ...[
                    Text(
                      'No. Invoice Vendor: ${invoice.vendorInvoiceNumber}',
                      style: const TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Row(
                    children: [
                      const Icon(CupertinoIcons.time, size: 12, color: CupertinoColors.secondaryLabel),
                      const SizedBox(width: 4),
                      Text(
                        'Tanggal: ${_formatDate(invoice.invoiceDate)}',
                        style: const TextStyle(color: CupertinoColors.secondaryLabel, fontSize: 12),
                      ),
                      if (invoice.dueDate != null) ...[
                        const SizedBox(width: 12),
                        const Icon(CupertinoIcons.exclamationmark_triangle, size: 12, color: CupertinoColors.secondaryLabel),
                        const SizedBox(width: 4),
                        Text(
                          'Tempo: ${_formatDate(invoice.dueDate)}',
                          style: const TextStyle(color: CupertinoColors.secondaryLabel, fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                  const Divider(color: CupertinoColors.separator, height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Biaya',
                        style: TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel),
                      ),
                      Text(
                        formatWithCurrency(invoice.totalAmount, invoice.currency),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
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
