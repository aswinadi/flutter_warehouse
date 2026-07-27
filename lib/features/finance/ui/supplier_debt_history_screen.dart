import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../core/widgets/company_switcher.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../providers/supplier_debt_provider.dart';

class SupplierDebtHistoryScreen extends ConsumerStatefulWidget {
  const SupplierDebtHistoryScreen({super.key});

  @override
  ConsumerState<SupplierDebtHistoryScreen> createState() =>
      _SupplierDebtHistoryScreenState();
}

class _SupplierDebtHistoryScreenState
    extends ConsumerState<SupplierDebtHistoryScreen> {
  int _selectedSegment = 0; // 0: Hutang (AP), 1: Piutang (AR), 2: Semua

  String? get _ledgerCategory {
    if (_selectedSegment == 0) return 'ap';
    if (_selectedSegment == 1) return 'ar';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    final historyAsync = ref.watch(supplierDebtHistoryProvider({
      'ledger_category': _ledgerCategory,
    }));

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Buku Hutang & Piutang Vendor'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: const Size(22, 22),
              child: const Icon(CupertinoIcons.refresh, size: 20),
              onPressed: () {
                ref.invalidate(supplierDebtHistoryProvider);
              },
            ),
            const SizedBox(width: 8),
            const CompanySwitcher(),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: CupertinoSpacing.m),

            // Segmented Switcher (AP vs AR vs Semua)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.m),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoSlidingSegmentedControl<int>(
                  groupValue: _selectedSegment,
                  children: const {
                    0: Padding(
                      padding: EdgeInsets.symmetric(vertical: CupertinoSpacing.s),
                      child: Text('Hutang Vendor (AP)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                    1: Padding(
                      padding: EdgeInsets.symmetric(vertical: CupertinoSpacing.s),
                      child: Text('Piutang Vendor (AR)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                    2: Padding(
                      padding: EdgeInsets.symmetric(vertical: CupertinoSpacing.s),
                      child: Text('Semua Ledger', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  },
                  onValueChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedSegment = val);
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: CupertinoSpacing.m),

            // Main List
            Expanded(
              child: historyAsync.when(
                data: (response) {
                  final items = response.data;
                  if (items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.doc_text, size: 48, color: secondaryLabel.withValues(alpha: 0.5)),
                          const SizedBox(height: CupertinoSpacing.m),
                          Text(
                            'Belum ada riwayat transaksi ledger vendor',
                            style: context.subhead.copyWith(color: secondaryLabel),
                          ),
                          const SizedBox(height: CupertinoSpacing.s),
                          CupertinoButton(
                            child: const Text('Muat Ulang'),
                            onPressed: () => ref.invalidate(supplierDebtHistoryProvider),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(CupertinoSpacing.m),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: CupertinoSpacing.s),
                    itemBuilder: (ctx, idx) {
                      final item = items[idx];
                      final isAp = item.ledgerCategory == 'ap';
                      final isIncrease = item.type == 'increase';

                      final badgeColor = isAp
                          ? CupertinoColors.systemOrange.resolveFrom(ctx)
                          : CupertinoColors.systemGreen.resolveFrom(ctx);

                      final typeColor = isIncrease
                          ? CupertinoColors.systemRed.resolveFrom(ctx)
                          : CupertinoColors.systemGreen.resolveFrom(ctx);

                      return CupertinoGlassContainer(
                        borderRadius: 16.0,
                        padding: const EdgeInsets.all(CupertinoSpacing.m),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item.supplierName ?? 'Supplier #${item.supplierId}',
                                    style: context.headline.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: labelColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: badgeColor.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    isAp ? 'AP (Hutang)' : 'AR (Piutang)',
                                    style: context.caption1.copyWith(
                                      color: badgeColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tanggal: ${item.transactionDate}',
                              style: context.footnote.copyWith(color: secondaryLabel),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isIncrease
                                          ? (isAp ? 'Hutang Bertambah' : 'Piutang Bertambah (RTV)')
                                          : (isAp ? 'Pembayaran Hutang' : 'Penerimaan Refund'),
                                      style: context.caption1.copyWith(
                                        color: typeColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      formatWithCurrency(item.amount, 'IDR'),
                                      style: context.title2.copyWith(
                                        color: typeColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Saldo Akhir',
                                      style: context.caption1.copyWith(color: secondaryLabel),
                                    ),
                                    Text(
                                      formatWithCurrency(item.balanceAfter, 'IDR'),
                                      style: context.subhead.copyWith(
                                        color: labelColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (item.notes != null && item.notes!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Catatan: ${item.notes}',
                                style: context.footnote.copyWith(
                                  color: secondaryLabel,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CupertinoActivityIndicator()),
                error: (err, stack) => Center(
                  child: Text('Error: $err', style: TextStyle(color: CupertinoColors.destructiveRed.resolveFrom(context))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
