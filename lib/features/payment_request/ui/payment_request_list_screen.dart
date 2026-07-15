import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider, VerticalDivider, Scrollbar, Colors, DateTimeRange, showDateRangePicker, Theme, ColorScheme;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/payment_request_repository.dart';
import '../models/payment_request.dart';
import 'payment_request_detail_screen.dart';
import '../../../core/widgets/company_switcher.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';

class PaymentRequestListScreen extends ConsumerStatefulWidget {
  const PaymentRequestListScreen({super.key});

  @override
  ConsumerState<PaymentRequestListScreen> createState() => _PaymentRequestListScreenState();
}

class _InvoiceWebScrollBehavior extends CupertinoScrollBehavior {
  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return Scrollbar(controller: details.controller, child: child);
  }
}

class _PaymentRequestListScreenState extends ConsumerState<PaymentRequestListScreen> {
  String? _selectedStatus; // null means all
  int? _selectedPrId;
  final ScrollController _scrollController = ScrollController();

  DateTime? _startDate;
  DateTime? _endDate;
  String _datePreset = 'thisMonth';

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
      _selectedPrId = null;
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
              primary: CupertinoColors.activeBlue,
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
        _selectedPrId = null;
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
    _datePreset = 'thisMonth';
    _endDate = DateTime.now();
    _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
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
      ref.read(paymentRequestsProvider(
        status: _selectedStatus,
        startDate: _startDateStr,
        endDate: _endDateStr,
      ).notifier).loadMore();
    }
  }

  Widget _buildFilterChip(String label, String? value) {
    final isSelected = _selectedStatus == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = value;
          _selectedPrId = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.m, vertical: CupertinoSpacing.s),
        decoration: BoxDecoration(
          color: isSelected ? CupertinoColors.activeBlue : CupertinoColors.systemGroupedBackground.resolveFrom(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? CupertinoColors.activeBlue : CupertinoColors.separator.resolveFrom(context),
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
    final listAsync = ref.watch(paymentRequestsProvider(
      status: _selectedStatus,
      startDate: _startDateStr,
      endDate: _endDateStr,
    ));
    final isWide = MediaQuery.of(context).size.width > 900;
    final labelColor = CupertinoColors.label.resolveFrom(context);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        middle: Text(
          'Permintaan Pembayaran',
          style: TextStyle(color: labelColor),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add, size: 22),
          onPressed: () => context.push('/payment-requests/new'),
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
                      style: context.footnote.copyWith(
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _datePreset == 'all' ? 'Semua Waktu' :
                        _datePreset == '30days' ? '30 Hari Terakhir' :
                        _datePreset == 'thisMonth' ? 'Bulan Ini' :
                        _datePreset == '90days' ? '3 Bulan Terakhir' : 'Kustom...',
                        style: context.footnote.copyWith(
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.label.resolveFrom(context),
                        ),
                      ),
                    ),
                    if (_startDate != null && _endDate != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        '${_startDate!.day}/${_startDate!.month}/${_startDate!.year} - ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                        style: context.footnote.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                      ),
                    ],
                    const Icon(CupertinoIcons.chevron_down, size: 14, color: CupertinoColors.secondaryLabel),
                  ],
                ),
              ),
            ),
            Container(
              height: CupertinoSpacing.primaryButtonHeight,
              color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.s),
                child: Row(
                  children: [
                    _buildFilterChip('Semua', null),
                    const SizedBox(width: CupertinoSpacing.s),
                    _buildFilterChip('Pending', 'pending'),
                    const SizedBox(width: CupertinoSpacing.s),
                    _buildFilterChip('Approved', 'approved'),
                    const SizedBox(width: CupertinoSpacing.s),
                    _buildFilterChip('Completed / Paid', 'completed'),
                    const SizedBox(width: CupertinoSpacing.s),
                    _buildFilterChip('Rejected', 'rejected'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: listAsync.when(
                data: (items) {
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'Tidak ada permintaan pembayaran',
                        style: context.subhead.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                      ),
                    );
                  }

                  if (isWide) {
                    if (_selectedPrId == null || !items.any((x) => x.id == _selectedPrId)) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted && items.isNotEmpty) {
                          setState(() {
                            _selectedPrId = items.first.id;
                          });
                        }
                      });
                    }
                  }

                  final hasMore = ref.watch(paymentRequestsProvider(
                    status: _selectedStatus,
                    startDate: _startDateStr,
                    endDate: _endDateStr,
                  ).notifier).hasMore;
                  final showLoader = listAsync.isLoading && hasMore;

                  final mainList = ScrollConfiguration(
                    behavior: _InvoiceWebScrollBehavior(),
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                      itemCount: items.length + (showLoader ? 1 : 0),
                      separatorBuilder: (context, index) => const SizedBox(height: CupertinoSpacing.m),
                      itemBuilder: (context, index) {
                        if (index == items.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: CupertinoSpacing.screenMargin),
                            child: Center(child: CupertinoActivityIndicator()),
                          );
                        }
                        final pr = items[index];
                        final isSelected = isWide && pr.id == _selectedPrId;

                        return _PaymentRequestCard(
                          pr: pr,
                          isSelected: isSelected,
                          onTap: () {
                            if (isWide) {
                              setState(() {
                                _selectedPrId = pr.id;
                              });
                            } else {
                              context.push('/payment-requests/${pr.id}');
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
                          child: mainList,
                        ),
                        const VerticalDivider(width: 1, thickness: 0.5, color: CupertinoColors.separator),
                        Expanded(
                          child: _selectedPrId != null
                              ? KeyedSubtree(
                                  key: ValueKey(_selectedPrId),
                                  child: PaymentRequestDetailScreen(
                                    prId: _selectedPrId!,
                                    isEmbedded: true,
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    'Pilih Permintaan Pembayaran untuk detail',
                                    style: context.body.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
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
                error: (err, _) => Center(child: Text('Gagal memuat: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentRequestCard extends StatelessWidget {
  final PaymentRequest pr;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentRequestCard({
    required this.pr,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (pr.status.toLowerCase()) {
      case 'pending':
        statusColor = CupertinoColors.activeOrange;
        break;
      case 'approved':
        statusColor = CupertinoColors.activeBlue;
        break;
      case 'completed':
      case 'paid':
        statusColor = CupertinoColors.systemGreen;
        break;
      case 'rejected':
        statusColor = CupertinoColors.systemRed;
        break;
      default:
        statusColor = CupertinoColors.systemGrey;
    }

    return GestureDetector(
      onTap: onTap,
      child: CupertinoGlassContainer(
        borderColor: isSelected ? CupertinoColors.activeBlue : null,
        backgroundColor: isSelected ? CupertinoColors.activeBlue.withValues(alpha: 0.08) : null,
        borderRadius: CupertinoSpacing.cardRadius,
        padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pr.requestNumber,
                  style: context.subhead.copyWith(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.s, vertical: CupertinoSpacing.xs),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: statusColor, width: 0.5),
                  ),
                  child: Text(
                    pr.status.toUpperCase(),
                    style: context.caption2.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: CupertinoSpacing.s),
            _buildInfoRow(context, 'Pengaju', pr.requestorName),
            _buildInfoRow(context, 'Pemasok', pr.supplierNames ?? '-'),
            _buildInfoRow(context, 'Tanggal', pr.requestDate),
            if (pr.dueDate != null) ...[
              _buildInfoRow(context, 'Tempo Terdekat', pr.dueDate!),
            ],
            Divider(color: CupertinoColors.separator.resolveFrom(context), height: CupertinoSpacing.l),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Tagihan',
                  style: context.caption1.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                ),
                Text(
                  formatWithCurrency(pr.totalAmount, pr.currency),
                  style: context.subhead.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: CupertinoSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.caption1.copyWith(color: CupertinoColors.secondaryLabel.resolveFrom(context))),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.caption1.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
