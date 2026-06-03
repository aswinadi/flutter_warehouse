import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/invoice_repository.dart';
import '../models/invoice.dart';
import 'invoice_approval_screen.dart';
import '../../../core/widgets/company_switcher.dart';
import '../../../core/utils/currency_utils.dart';

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
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedStatus = selected ? value : null;
          _selectedInvoiceId = null;
        });
      },
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        title: const Text('Purchase Invoice (Faktur)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _selectedInvoiceId = null;
              });
              ref.invalidate(invoicesProvider);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const CompanySwitcher(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Color(0xFF4F46E5)),
                const SizedBox(width: 8),
                const Text(
                  'Periode:',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _datePreset,
                      dropdownColor: Colors.white,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B), fontWeight: FontWeight.w600),
                      onChanged: (val) {
                        if (val != null) {
                          _updateDatePreset(val);
                          if (val == 'custom') {
                            _selectCustomDateRange();
                          }
                        }
                      },
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('Semua Waktu')),
                        DropdownMenuItem(value: '30days', child: Text('30 Hari Terakhir')),
                        DropdownMenuItem(value: 'thisMonth', child: Text('Bulan Ini')),
                        DropdownMenuItem(value: '90days', child: Text('3 Bulan Terakhir')),
                        DropdownMenuItem(value: 'custom', child: Text('Pilih Tanggal...')),
                      ],
                    ),
                  ),
                ),
                if (_startDate != null && _endDate != null) ...[
                  Text(
                    '${_startDate!.day}/${_startDate!.month}/${_startDate!.year} - ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 8),
                ],
                if (_datePreset == 'custom')
                  IconButton(
                    icon: const Icon(Icons.date_range, size: 18, color: Color(0xFF4F46E5)),
                    onPressed: _selectCustomDateRange,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
              ],
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
                            Colors.white.withValues(alpha: 0.0),
                            Colors.white,
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
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(invoicesProvider);
              },
              child: invoicesAsync.when(
                data: (invoices) {
                  if (invoices.isEmpty) {
                    return const Center(
                      child: Text(
                        'Tidak ada invoice yang ditemukan',
                        style: TextStyle(color: Color(0xFF64748B), fontSize: 15),
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

                  final mainList = ListView.separated(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: invoices.length + (showLoader ? 1 : 0),
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index == invoices.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final invoice = invoices[index];
                      final isSelected = invoice.id == _selectedInvoiceId;
                      return _InvoiceCard(
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
                      );
                    },
                  );

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 360,
                          child: mainList,
                        ),
                        const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                        Expanded(
                          child: _selectedInvoiceId != null
                              ? KeyedSubtree(
                                  key: ValueKey(_selectedInvoiceId),
                                  child: InvoiceApprovalScreen(
                                    invoiceId: _selectedInvoiceId!,
                                    isEmbedded: true,
                                  ),
                                )
                              : const Center(
                                  child: Text(
                                    'Pilih Invoice untuk melihat detail',
                                    style: TextStyle(color: Color(0xFF64748B)),
                                  ),
                                ),
                        ),
                      ],
                    );
                  } else {
                    return mainList;
                  }
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Gagal memuat data: $err')),
              ),
            ),
          ),
        ],
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A0F0F0F),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                        fontSize: 16,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    _StatusBadge(status: invoice.status),
                  ],
                ),
                if (invoice.receivingNumber != null && invoice.receivingNumber!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'No. Penerimaan: ${invoice.receivingNumber}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF4F46E5),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  invoice.supplierName ?? 'Internal',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                if (invoice.vendorInvoiceNumber != null && invoice.vendorInvoiceNumber!.isNotEmpty) ...[
                  Text(
                    'No. Invoice Vendor: ${invoice.vendorInvoiceNumber}',
                    style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
                  ),
                  const SizedBox(height: 4),
                ],
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Color(0xFF64748B)),
                    const SizedBox(width: 4),
                    Text(
                      'Tanggal: ${_formatDate(invoice.invoiceDate)}',
                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                    ),
                    if (invoice.dueDate != null) ...[
                      const SizedBox(width: 12),
                      const Icon(Icons.warning_amber, size: 14, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Text(
                        'Tempo: ${_formatDate(invoice.dueDate)}',
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                      ),
                    ],
                  ],
                ),
                const Divider(height: 24, color: Color(0xFFE2E8F0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Tagihan',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    Text(
                      formatWithCurrency(invoice.totalAmount, invoice.currency),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
    Color color;
    switch (status.toLowerCase()) {
      case 'approved':
      case 'paid':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      case 'draft':
        color = Colors.grey;
        break;
      case 'cancelled':
      case 'rejected':
        color = Colors.red;
        break;
      default:
        color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
