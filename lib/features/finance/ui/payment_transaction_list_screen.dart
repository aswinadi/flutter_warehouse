import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider, Colors, DateTimeRange, showDateRangePicker, Theme, ColorScheme;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/company_switcher.dart';
import '../models/payment_transaction.dart';
import '../providers/payment_transaction_provider.dart';
import 'payment_transaction_detail_screen.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';

class PaymentTransactionListScreen extends ConsumerStatefulWidget {
  const PaymentTransactionListScreen({super.key});

  @override
  ConsumerState<PaymentTransactionListScreen> createState() =>
      _PaymentTransactionListScreenState();
}

class _PaymentTransactionListScreenState extends ConsumerState<PaymentTransactionListScreen> {
  final ScrollController _noProofScrollController = ScrollController();
  final ScrollController _allScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  int? _selectedTransactionId;
  int _selectedSegment = 0;

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
      _selectedTransactionId = null;
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
        _selectedTransactionId = null;
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
    _noProofScrollController.addListener(_onNoProofScroll);
    _allScrollController.addListener(_onAllScroll);
  }

  @override
  void dispose() {
    _noProofScrollController.dispose();
    _allScrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onNoProofScroll() {
    if (!_noProofScrollController.hasClients) return;
    final maxScroll = _noProofScrollController.position.maxScrollExtent;
    final currentScroll = _noProofScrollController.position.pixels;
    if (currentScroll >= maxScroll * 0.9) {
      ref.read(paymentTransactionsListProvider(
        hasProof: false,
        search: _searchQuery,
        startDate: _startDateStr,
        endDate: _endDateStr,
      ).notifier).loadMore();
    }
  }

  void _onAllScroll() {
    if (!_allScrollController.hasClients) return;
    final maxScroll = _allScrollController.position.maxScrollExtent;
    final currentScroll = _allScrollController.position.pixels;
    if (currentScroll >= maxScroll * 0.9) {
      ref.read(paymentTransactionsListProvider(
        hasProof: null,
        search: _searchQuery,
        startDate: _startDateStr,
        endDate: _endDateStr,
      ).notifier).loadMore();
    }
  }

  String _formatCurrency(double amount) {
    final str = amount.toStringAsFixed(0);
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return 'Rp ${str.replaceAllMapped(reg, (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final bgColor = CupertinoColors.systemGroupedBackground.resolveFrom(context);

    return CupertinoPageScaffold(
      backgroundColor: bgColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        middle: Text(
          'Transaksi Pembayaran Supplier',
          style: context.headline.copyWith(color: labelColor),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            final refreshed = await context.push<bool>('/payment-transactions/new');
            if (refreshed == true && mounted) {
              ref.invalidate(paymentTransactionsListProvider(
                hasProof: _selectedSegment == 0 ? false : null,
                search: _searchQuery,
                startDate: _startDateStr,
                endDate: _endDateStr,
              ));
            }
          },
          child: const Icon(CupertinoIcons.add, size: 24),
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
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.halfScreenMargin),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: CupertinoSlidingSegmentedControl<int>(
                groupValue: _selectedSegment,
                children: {
                  0: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.s, vertical: CupertinoSpacing.xs + 2),
                    child: Text('Belum Unggah Bukti', style: context.footnote),
                  ),
                  1: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.s, vertical: CupertinoSpacing.xs + 2),
                    child: Text('Semua Transaksi', style: context.footnote),
                  ),
                },
                onValueChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedSegment = value;
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.halfScreenMargin),
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: 'Cari nomor transaksi atau supplier...',
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                onSuffixTap: () {
                  setState(() {
                    _searchController.clear();
                    _searchQuery = '';
                  });
                },
              ),
            ),
            Expanded(
              child: _selectedSegment == 0
                  ? _buildTabContent(isWide, hasProofFilter: false, controller: _noProofScrollController)
                  : _buildTabContent(isWide, hasProofFilter: null, controller: _allScrollController),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(bool isWide, {required bool? hasProofFilter, required ScrollController controller}) {
    final transactionsAsync = ref.watch(paymentTransactionsListProvider(
      hasProof: hasProofFilter,
      search: _searchQuery,
      startDate: _startDateStr,
      endDate: _endDateStr,
    ));
    final secondaryBgColor = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);

    if (isWide) {
      return Row(
        children: [
          SizedBox(
            width: 380,
            child: _buildListPanel(transactionsAsync, controller, isWide, hasProofFilter),
          ),
          Container(
            width: 1,
            color: CupertinoColors.separator.resolveFrom(context),
          ),
          Expanded(
            child: Container(
              color: secondaryBgColor,
              child: _selectedTransactionId != null
                  ? PaymentTransactionDetailWidget(
                      transactionId: _selectedTransactionId!,
                      onUploadSuccess: () {
                        ref.invalidate(paymentTransactionsListProvider(
                          hasProof: hasProofFilter,
                          search: _searchQuery,
                          startDate: _startDateStr,
                          endDate: _endDateStr,
                        ));
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.creditcard, size: 48, color: secondaryLabelColor),
                          const SizedBox(height: CupertinoSpacing.l),
                          Text(
                            'Pilih transaksi pembayaran untuk melihat detail',
                            style: context.callout.copyWith(color: secondaryLabelColor),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      );
    } else {
      return _buildListPanel(transactionsAsync, controller, isWide, hasProofFilter);
    }
  }

  Widget _buildListPanel(
    AsyncValue<List<PaymentTransaction>> transactionsAsync,
    ScrollController controller,
    bool isWide,
    bool? hasProofFilter,
  ) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);

    return transactionsAsync.when(
      data: (transactions) {
        if (transactions.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(CupertinoSpacing.xxxl),
              child: Text(
                'Tidak ada transaksi pembayaran',
                style: context.callout.copyWith(color: secondaryLabelColor),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final hasMore = ref.watch(paymentTransactionsListProvider(
          hasProof: hasProofFilter,
          search: _searchQuery,
          startDate: _startDateStr,
          endDate: _endDateStr,
        ).notifier).hasMore;

        return ListView.separated(
          controller: controller,
          padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
          itemCount: transactions.length + (hasMore ? 1 : 0),
          separatorBuilder: (context, index) => const SizedBox(height: CupertinoSpacing.m),
          itemBuilder: (context, index) {
            if (index == transactions.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: CupertinoSpacing.screenMargin),
                  child: CupertinoActivityIndicator(),
                ),
              );
            }

            final trx = transactions[index];
            final isSelected = trx.id == _selectedTransactionId;

            return CupertinoGlassContainer(
              borderRadius: CupertinoSpacing.cardRadius + 2,
              backgroundColor: isSelected 
                  ? CupertinoColors.activeBlue.resolveFrom(context).withValues(alpha: 0.08)
                  : null,
              borderColor: isSelected
                  ? CupertinoColors.activeBlue.resolveFrom(context)
                  : null,
              padding: EdgeInsets.zero,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (isWide) {
                    setState(() {
                      _selectedTransactionId = trx.id;
                    });
                  } else {
                    context.go('/payment-transactions/${trx.id}');
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              trx.transactionNumber,
                              style: context.subhead.copyWith(
                                fontWeight: FontWeight.bold,
                                color: labelColor,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: CupertinoSpacing.s + 2, vertical: CupertinoSpacing.xs),
                            decoration: BoxDecoration(
                              color: trx.receiptPath != null
                                  ? CupertinoColors.systemGreen.withValues(alpha: 0.1)
                                  : CupertinoColors.systemOrange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: trx.receiptPath != null
                                    ? CupertinoColors.systemGreen
                                    : CupertinoColors.systemOrange,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              trx.receiptPath != null
                                  ? 'Bukti Terunggah'
                                  : 'Butuh Bukti',
                              style: context.caption1.copyWith(
                                fontWeight: FontWeight.w600,
                                color: trx.receiptPath != null
                                    ? CupertinoColors.systemGreen.resolveFrom(context)
                                    : CupertinoColors.systemOrange.resolveFrom(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: CupertinoSpacing.m),
                      Row(
                        children: [
                          Icon(CupertinoIcons.building_2_fill, size: 16, color: secondaryLabelColor),
                          const SizedBox(width: CupertinoSpacing.s),
                          Expanded(
                            child: Text(
                              trx.supplierName ?? 'Pemasok Tidak Diketahui',
                              style: context.subhead.copyWith(
                                color: labelColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: CupertinoSpacing.s),
                      Row(
                        children: [
                          Icon(CupertinoIcons.calendar, size: 16, color: secondaryLabelColor),
                          const SizedBox(width: CupertinoSpacing.s),
                          Text(
                            trx.transactionDate,
                            style: context.footnote.copyWith(
                              color: secondaryLabelColor,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: CupertinoSpacing.xl),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Pembayaran',
                            style: context.footnote.copyWith(
                              color: secondaryLabelColor,
                            ),
                          ),
                          Text(
                            _formatCurrency(trx.totalAmount),
                            style: context.subhead.copyWith(
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.activeBlue.resolveFrom(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.exclamationmark_triangle, color: CupertinoColors.systemRed, size: 48),
              const SizedBox(height: 12),
              Text(
                'Gagal memuat transaksi: ${error.toString()}',
                textAlign: TextAlign.center,
                style: TextStyle(color: CupertinoColors.systemRed.resolveFrom(context)),
              ),
              const SizedBox(height: 12),
              CupertinoButton.filled(
                onPressed: () {
                  ref.invalidate(paymentTransactionsListProvider(
                    hasProof: hasProofFilter,
                    search: _searchQuery,
                  ));
                },
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
