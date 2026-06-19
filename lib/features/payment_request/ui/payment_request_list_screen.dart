import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Divider, VerticalDivider, Scrollbar;
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
        padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.m, vertical: CupertinoSpacing.s),
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
    final listAsync = ref.watch(paymentRequestsProvider(status: _selectedStatus));
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
                        style: context.subhead.copyWith(color: CupertinoColors.secondaryLabel),
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
                              : Center(
                                  child: Text(
                                    'Pilih Permintaan Pembayaran untuk detail',
                                    style: context.body.copyWith(color: CupertinoColors.secondaryLabel),
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

    final labelColor = CupertinoColors.label.resolveFrom(context);

    return GestureDetector(
      onTap: onTap,
      child: CupertinoGlassContainer(
        borderColor: isSelected ? const Color(0xFF6E56CF) : null,
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
                    color: statusColor.withOpacity(0.12),
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
                  style: context.caption1.copyWith(color: CupertinoColors.secondaryLabel),
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
          Text(label, style: context.caption1.copyWith(color: CupertinoColors.secondaryLabel)),
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
