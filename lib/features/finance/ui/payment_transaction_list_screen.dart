import 'package:flutter/material.dart';
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

class _PaymentTransactionListScreenState extends ConsumerState<PaymentTransactionListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _noProofScrollController = ScrollController();
  final ScrollController _allScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  int? _selectedTransactionId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _noProofScrollController.addListener(_onNoProofScroll);
    _allScrollController.addListener(_onAllScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
      ref.read(paymentTransactionsListProvider.notifier).loadMore();
    }
  }

  void _onAllScroll() {
    if (!_allScrollController.hasClients) return;
    final maxScroll = _allScrollController.position.maxScrollExtent;
    final currentScroll = _allScrollController.position.pixels;
    if (currentScroll >= maxScroll * 0.9) {
      ref.read(paymentTransactionsListProvider.notifier).loadMore();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi Pembayaran Supplier'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(
              icon: Icon(Icons.receipt_long),
              text: 'Belum Unggah Bukti',
            ),
            Tab(
              icon: Icon(Icons.history),
              text: 'Semua Transaksi',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const CompanySwitcher(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nomor transaksi atau supplier...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                          ref
                              .read(paymentTransactionsListProvider.notifier)
                              .setSearchQuery('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                ref
                    .read(paymentTransactionsListProvider.notifier)
                    .setSearchQuery(value);
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent(isWide, hasProofFilter: false, controller: _noProofScrollController),
                _buildTabContent(isWide, hasProofFilter: null, controller: _allScrollController),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(bool isWide, {required bool? hasProofFilter, required ScrollController controller}) {
    // Set the filter on build of the tab
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(paymentTransactionsListProvider.notifier).setHasProof(hasProofFilter);
      }
    });

    final transactionsAsync = ref.watch(paymentTransactionsListProvider);

    if (isWide) {
      return Row(
        children: [
          SizedBox(
            width: 380,
            child: _buildListPanel(transactionsAsync, controller, isWide),
          ),
          const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE2E8F0)),
          Expanded(
            child: _selectedTransactionId != null
                ? PaymentTransactionDetailWidget(
                    transactionId: _selectedTransactionId!,
                    onUploadSuccess: () {
                      ref.invalidate(paymentTransactionsListProvider);
                    },
                  )
                : const Center(
                    child: Text(
                      'Pilih transaksi pembayaran untuk melihat detail',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
          ),
        ],
      );
    } else {
      return _buildListPanel(transactionsAsync, controller, isWide);
    }
  }

  Widget _buildListPanel(
    AsyncValue<List<PaymentTransaction>> transactionsAsync,
    ScrollController controller,
    bool isWide,
  ) {
    return transactionsAsync.when(
      data: (transactions) {
        if (transactions.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'Tidak ada transaksi pembayaran',
                style: TextStyle(color: Colors.grey, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return ListView.separated(
          controller: controller,
          padding: const EdgeInsets.all(16),
          itemCount: transactions.length + (ref.read(paymentTransactionsListProvider.notifier).hasMore ? 1 : 0),
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == transactions.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final trx = transactions[index];
            final isSelected = trx.id == _selectedTransactionId;

            return Card(
              elevation: isSelected ? 4 : 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: InkWell(
                onTap: () {
                  if (isWide) {
                    setState(() {
                      _selectedTransactionId = trx.id;
                    });
                  } else {
                    context.go('/payment-transactions/${trx.id}');
                  }
                },
                borderRadius: BorderRadius.circular(12),
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: trx.receiptPath != null
                                  ? Colors.green.shade50
                                  : Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              trx.receiptPath != null
                                  ? 'Bukti Terunggah'
                                  : 'Butuh Bukti',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: trx.receiptPath != null
                                    ? Colors.green.shade700
                                    : Colors.orange.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.business, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              trx.supplierName ?? 'Pemasok Tidak Diketahui',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            trx.transactionDate,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Pembayaran',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            _formatCurrency(trx.totalAmount),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.primary,
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
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 12),
              Text(
                'Gagal memuat transaksi: ${error.toString()}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(paymentTransactionsListProvider);
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
