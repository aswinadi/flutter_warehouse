import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors, Divider, VerticalDivider, Scrollbar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/payment_request_repository.dart';
import '../models/payment_request.dart';
import 'payment_request_detail_screen.dart';
import '../../../core/widgets/company_switcher.dart';
import '../../../core/utils/currency_utils.dart';

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
      ref.read(paymentRequestsProvider(status: _selectedStatus).notifier).loadMore();
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
    final listAsync = ref.watch(paymentRequestsProvider(status: _selectedStatus));
    final isWide = MediaQuery.of(context).size.width > 900;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        middle: Text(
          'Permintaan Pembayaran',
          style: TextStyle(color: CupertinoColors.label.resolveFrom(context)),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const CompanySwitcher(),
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
                    _buildFilterChip('Pending', 'pending'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Approved', 'approved'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Completed / Paid', 'completed'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Rejected', 'rejected'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: listAsync.when(
                data: (items) {
                  if (items.isEmpty) {
                    return const Center(
                      child: Text(
                        'Tidak ada permintaan pembayaran',
                        style: TextStyle(color: CupertinoColors.secondaryLabel, fontSize: 15),
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

                  final hasMore = ref.watch(paymentRequestsProvider(status: _selectedStatus).notifier).hasMore;
                  final showLoader = listAsync.isLoading && hasMore;

                  final mainList = ScrollConfiguration(
                    behavior: _InvoiceWebScrollBehavior(),
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length + (showLoader ? 1 : 0),
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        if (index == items.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CupertinoActivityIndicator()),
                          );
                        }
                        final pr = items[index];
                        final isSelected = pr.id == _selectedPrId;

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
                              : const Center(
                                  child: Text(
                                    'Pilih Permintaan Pembayaran untuk detail',
                                    style: TextStyle(color: CupertinoColors.secondaryLabel),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pr.requestNumber,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: statusColor, width: 0.5),
                  ),
                  child: Text(
                    pr.status.toUpperCase(),
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
            _buildInfoRow('Pengaju', pr.requestorName),
            _buildInfoRow('Pemasok', pr.supplierNames ?? '-'),
            _buildInfoRow('Tanggal', pr.requestDate),
            if (pr.dueDate != null) ...[
              _buildInfoRow('Tempo Terdekat', pr.dueDate!),
            ],
            const Divider(color: CupertinoColors.separator, height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Tagihan',
                  style: TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel),
                ),
                Text(
                  formatWithCurrency(pr.totalAmount, pr.currency),
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
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
