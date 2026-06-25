import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show showDateRangePicker, Theme, ThemeData, ColorScheme, DateTimeRange, Colors;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../providers/purchase_order_provider.dart';
import '../models/purchase_order.dart';
import '../../../core/widgets/company_switcher.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/providers/company_provider.dart';
import 'po_approval_screen.dart';

class POListScreen extends ConsumerStatefulWidget {
  const POListScreen({super.key});

  @override
  ConsumerState<POListScreen> createState() => _POListScreenState();
}

class _POListScreenState extends ConsumerState<POListScreen> {
  final ScrollController _scrollController = ScrollController();
  int? _selectedPoId;

  DateTime? _startDate;
  DateTime? _endDate;
  String _datePreset = 'all';

  String? get _startDateStr => _startDate != null
      ? '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}'
      : null;

  String? get _endDateStr => _endDate != null
      ? '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}'
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
      _selectedPoId = null;
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
          data: ThemeData.light().copyWith(
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
        _selectedPoId = null;
      });
    }
  }

  void _showDatePresetPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Pilih Periode'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _updateDatePreset('all');
            },
            child: const Text('Semua Waktu'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _updateDatePreset('30days');
            },
            child: const Text('30 Hari Terakhir'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _updateDatePreset('thisMonth');
            },
            child: const Text('Bulan Ini'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _updateDatePreset('90days');
            },
            child: const Text('3 Bulan Terakhir'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _updateDatePreset('custom');
              _selectCustomDateRange();
            },
            child: const Text('Pilih Tanggal...'),
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

  String _getDatePresetLabel(String preset) {
    switch (preset) {
      case 'all':
        return 'Semua Waktu';
      case '30days':
        return '30 Hari Terakhir';
      case 'thisMonth':
        return 'Bulan Ini';
      case '90days':
        return '3 Bulan Terakhir';
      case 'custom':
        return 'Pilih Tanggal...';
      default:
        return preset;
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
      ref.read(purchaseOrdersProvider(
        dateFrom: _startDateStr,
        dateTo: _endDateStr,
      ).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final poAsync = ref.watch(purchaseOrdersProvider(
      dateFrom: _startDateStr,
      dateTo: _endDateStr,
    ));
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final isWide = MediaQuery.of(context).size.width > 900;

    ref.listen(selectedCompanyProvider, (previous, next) {
      if (previous != next) {
        setState(() {
          _selectedPoId = null;
        });
      }
    });

    Widget buildList(List<PurchaseOrder> orders, bool showLoader) {
      return ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
        itemCount: orders.length + (showLoader ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: CupertinoSpacing.m),
        itemBuilder: (context, index) {
          if (index == orders.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: CupertinoSpacing.screenMargin),
              child: Center(child: CupertinoActivityIndicator()),
            );
          }
          final po = orders[index];
          final isSelected = isWide && po.id == _selectedPoId;

          return _POCard(
            po: po,
            isSelected: isSelected,
            onTap: () {
              if (isWide) {
                setState(() {
                  _selectedPoId = po.id;
                });
              } else {
                context.push('/po/${po.id}');
              }
            },
          );
        },
      );
    }

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        middle: Text(
          AppLocalizations.of(context)!.purchaseOrders,
          style: TextStyle(color: labelColor),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          minimumSize: const Size(22, 22),
          child: const Icon(CupertinoIcons.refresh, size: 22),
          onPressed: () {
            setState(() {
              _selectedPoId = null;
            });
            ref.invalidate(purchaseOrdersProvider);
          },
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const CompanySwitcher(),
            
            // Date Filter Panel
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: CupertinoSpacing.screenMargin,
                vertical: CupertinoSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                border: Border(
                  bottom: BorderSide(
                    color: separatorColor,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.calendar, size: 16, color: CupertinoColors.activeBlue),
                  const SizedBox(width: 8),
                  Text(
                    'Periode:',
                    style: context.footnote.copyWith(
                      fontWeight: FontWeight.bold,
                      color: secondaryLabelColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showDatePresetPicker(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemBackground.resolveFrom(context),
                          border: Border.all(
                            color: separatorColor,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _getDatePresetLabel(_datePreset),
                                style: context.footnote.copyWith(
                                  color: labelColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              CupertinoIcons.chevron_down,
                              size: 14,
                              color: secondaryLabelColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_startDate != null && _endDate != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      '${_startDate!.day}/${_startDate!.month}/${_startDate!.year} - ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                      style: context.caption2.copyWith(
                        color: secondaryLabelColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  if (_datePreset == 'custom') ...[
                    const SizedBox(width: 8),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      onPressed: _selectCustomDateRange,
                      child: const Icon(CupertinoIcons.calendar_badge_plus, size: 20, color: CupertinoColors.activeBlue),
                    ),
                  ],
                ],
              ),
            ),
            
            Expanded(
              child: poAsync.when(
                data: (orders) {
                  if (orders.isEmpty) {
                    return Center(
                      child: Text(
                        'Tidak ada Pesanan Pembelian (PO) yang ditemukan',
                        style: context.subhead.copyWith(color: CupertinoColors.secondaryLabel),
                      ),
                    );
                  }

                  if (isWide && _selectedPoId == null && orders.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          _selectedPoId = orders.first.id;
                        });
                      }
                    });
                  }

                  final hasMore = ref.watch(purchaseOrdersProvider(
                    dateFrom: _startDateStr,
                    dateTo: _endDateStr,
                  ).notifier).hasMore;
                  final showLoader = poAsync.isLoading && hasMore;

                  final listWidget = buildList(orders, showLoader);

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 360,
                          child: listWidget,
                        ),
                        Container(
                          width: 0.5,
                          color: separatorColor,
                        ),
                        Expanded(
                          child: _selectedPoId != null
                              ? POApprovalScreen(
                                  poId: _selectedPoId!,
                                  isEmbedded: true,
                                  key: ValueKey(_selectedPoId),
                                )
                              : Center(
                                  child: Text(
                                    'Pilih PO untuk melihat rincian',
                                    style: context.subhead.copyWith(color: CupertinoColors.secondaryLabel),
                                  ),
                                ),
                        ),
                      ],
                    );
                  } else {
                    return listWidget;
                  }
                },
                loading: () => const Center(child: CupertinoActivityIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err', style: context.body)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _POCard extends StatelessWidget {
  final PurchaseOrder po;
  final bool isSelected;
  final VoidCallback onTap;

  const _POCard({
    required this.po,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final progress = po.totalItems > 0 ? po.receivedItems / po.totalItems : 0.0;

    return CupertinoGlassContainer(
      borderRadius: CupertinoSpacing.cardRadius,
      borderColor: isSelected ? CupertinoColors.activeBlue : null,
      backgroundColor: isSelected ? CupertinoColors.activeBlue.withValues(alpha: 0.08) : null,
      padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  po.poNumber,
                  style: context.headline.copyWith(
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.activeBlue.resolveFrom(context),
                  ),
                ),
                _StatusChip(status: po.status),
              ],
            ),
            const SizedBox(height: CupertinoSpacing.s),
            Text(
              po.supplierName,
              style: context.subhead.copyWith(fontWeight: FontWeight.bold, color: labelColor),
            ),
            const SizedBox(height: CupertinoSpacing.s),
            Row(
              children: [
                Icon(CupertinoIcons.calendar, size: 14, color: secondaryLabel),
                const SizedBox(width: CupertinoSpacing.xs),
                Text(
                  'Estimasi: ${po.expectedDate}',
                  style: context.footnote.copyWith(color: secondaryLabel),
                ),
              ],
            ),
            const SizedBox(height: CupertinoSpacing.m),
            // Custom iOS Progress Bar
            Container(
              height: 6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: CupertinoColors.systemFill.resolveFrom(context),
                borderRadius: BorderRadius.circular(3),
              ),
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.activeBlue.resolveFrom(context),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: CupertinoSpacing.s),
            Text(
              'Diterima: ${po.receivedItems} / ${po.totalItems} barang',
              style: context.caption1.copyWith(color: secondaryLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    CupertinoDynamicColor color;
    switch (status.toLowerCase()) {
      case 'completed':
        color = CupertinoColors.activeGreen;
        break;
      case 'partial':
        color = CupertinoColors.activeBlue;
        break;
      case 'pending':
        color = CupertinoColors.systemOrange;
        break;
      default:
        color = CupertinoColors.systemGrey;
    }

    final resolvedColor = color.resolveFrom(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.s, vertical: CupertinoSpacing.xs),
      decoration: BoxDecoration(
        color: resolvedColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: resolvedColor, width: 0.5),
      ),
      child: Text(
        status.toUpperCase(),
        style: context.caption2.copyWith(
          color: resolvedColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
