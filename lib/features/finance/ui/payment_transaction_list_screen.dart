import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider, Colors;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/company_switcher.dart';
import '../models/payment_transaction.dart';
import '../providers/payment_transaction_provider.dart';
import 'payment_transaction_detail_screen.dart';

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

  @override
  void initState() {
    super.initState();
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
          style: TextStyle(color: labelColor),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const CompanySwitcher(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: CupertinoSlidingSegmentedControl<int>(
                groupValue: _selectedSegment,
                children: const {
                  0: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Text('Belum Unggah Bukti', style: TextStyle(fontSize: 13)),
                  ),
                  1: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Text('Semua Transaksi', style: TextStyle(fontSize: 13)),
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                        ));
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.creditcard, size: 48, color: secondaryLabelColor),
                          const SizedBox(height: 16),
                          Text(
                            'Pilih transaksi pembayaran untuk melihat detail',
                            style: TextStyle(color: secondaryLabelColor, fontSize: 16),
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
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Tidak ada transaksi pembayaran',
                style: TextStyle(color: secondaryLabelColor, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final hasMore = ref.watch(paymentTransactionsListProvider(
          hasProof: hasProofFilter,
          search: _searchQuery,
        ).notifier).hasMore;

        return ListView.separated(
          controller: controller,
          padding: const EdgeInsets.all(16),
          itemCount: transactions.length + (hasMore ? 1 : 0),
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == transactions.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: CupertinoActivityIndicator(),
                ),
              );
            }

            final trx = transactions[index];
            final isSelected = trx.id == _selectedTransactionId;

            return Container(
              decoration: BoxDecoration(
                color: isSelected 
                    ? CupertinoColors.activeBlue.resolveFrom(context).withValues(alpha: 0.08)
                    : CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? CupertinoColors.activeBlue.resolveFrom(context)
                      : CupertinoColors.separator.resolveFrom(context),
                  width: isSelected ? 2.0 : 0.5,
                ),
              ),
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              trx.transactionNumber,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: labelColor,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
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
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: trx.receiptPath != null
                                    ? CupertinoColors.systemGreen.resolveFrom(context)
                                    : CupertinoColors.systemOrange.resolveFrom(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(CupertinoIcons.building_2_fill, size: 16, color: secondaryLabelColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              trx.supplierName ?? 'Pemasok Tidak Diketahui',
                              style: TextStyle(
                                fontSize: 14,
                                color: labelColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(CupertinoIcons.calendar, size: 16, color: secondaryLabelColor),
                          const SizedBox(width: 8),
                          Text(
                            trx.transactionDate,
                            style: TextStyle(
                              fontSize: 13,
                              color: secondaryLabelColor,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Pembayaran',
                            style: TextStyle(
                              fontSize: 13,
                              color: secondaryLabelColor,
                            ),
                          ),
                          Text(
                            _formatCurrency(trx.totalAmount),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
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
