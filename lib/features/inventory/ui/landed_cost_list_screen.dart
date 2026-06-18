import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Scrollbar, Colors, DateTimeRange, showDateRangePicker, Theme, ColorScheme;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/landed_cost_repository.dart';
import '../../../core/providers/company_provider.dart';
import '../../../core/models/company.dart';
import '../../../core/widgets/company_switcher.dart';
import '../models/landed_cost.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';
import '../../../core/utils/currency_utils.dart';

class LandedCostListScreen extends ConsumerStatefulWidget {
  const LandedCostListScreen({super.key});

  @override
  ConsumerState<LandedCostListScreen> createState() => _LandedCostListScreenState();
}

class _LandedCostListScreenState extends ConsumerState<LandedCostListScreen> {
  String? _selectedStatus = 'all'; // 'all', 'draft', 'pending', 'approved'
  final ScrollController _scrollController = ScrollController();

  String? get _filterStatus => _selectedStatus == 'all' ? null : _selectedStatus;

  DateTime? _startDate;
  DateTime? _endDate;
  String _datePreset = 'all';

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
      ref.read(landedCostListProvider(
        status: _filterStatus,
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

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'approved':
        bgColor = CupertinoColors.systemGreen.withValues(alpha: 0.15);
        textColor = CupertinoColors.systemGreen;
        break;
      case 'pending':
        bgColor = CupertinoColors.systemOrange.withValues(alpha: 0.15);
        textColor = CupertinoColors.systemOrange;
        break;
      case 'cancelled':
        bgColor = CupertinoColors.systemRed.withValues(alpha: 0.15);
        textColor = CupertinoColors.systemRed;
        break;
      case 'draft':
      default:
        bgColor = CupertinoColors.systemGrey.withValues(alpha: 0.15);
        textColor = CupertinoColors.systemGrey;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedStatus == value;
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final activeColor = CupertinoColors.activeBlue.resolveFrom(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor
              : CupertinoColors.tertiarySystemFill.resolveFrom(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: context.footnote.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? CupertinoColors.white
                : labelColor,
          ),
        ),
      ),
    );
  }

  Future<void> _handleAddNewLandedCost(Company? selectedCompany) async {
    if (selectedCompany == null) {
      // Fetch companies list and show picker
      try {
        final companies = await ref.read(companiesProvider.future);
        if (mounted) {
          if (companies.isEmpty) {
            CupertinoGlassToast.showError(context, 'Tidak ada data perusahaan.');
            return;
          }
          showCupertinoModalPopup(
            context: context,
            builder: (context) => CupertinoActionSheet(
              title: const Text('Pilih Perusahaan untuk Landed Cost'),
              actions: companies.map((c) {
                return CupertinoActionSheetAction(
                  child: Text(c.companyName),
                  onPressed: () {
                    ref.read(selectedCompanyProvider.notifier).selectCompany(c);
                    Navigator.pop(context);
                    context.push('/landed-costs/create');
                  },
                );
              }).toList(),
              cancelButton: CupertinoActionSheetAction(
                child: const Text('Batal'),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          CupertinoGlassToast.showError(context, 'Gagal memuat daftar perusahaan: $e');
        }
      }
    } else {
      context.push('/landed-costs/create');
    }
  }

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(landedCostListProvider(
      status: _filterStatus,
      startDate: _startDateStr,
      endDate: _endDateStr,
    ));
    final selectedCompany = ref.watch(selectedCompanyProvider);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final borderCol = CupertinoColors.separator.resolveFrom(context);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        middle: Text(
          'Landed Cost',
          style: TextStyle(color: labelColor),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _handleAddNewLandedCost(selectedCompany),
          child: const Icon(CupertinoIcons.add_circled, size: 24),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Company Selector
            const CompanySwitcher(),

            // Period Filter
            GestureDetector(
              onTap: _showPresetPicker,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground.resolveFrom(context),
                  border: Border(bottom: BorderSide(color: borderCol, width: 0.5)),
                ),
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.calendar, size: 16, color: CupertinoColors.activeBlue),
                    const SizedBox(width: 8),
                    Text(
                      'Periode:',
                      style: context.footnote.copyWith(fontWeight: FontWeight.bold, color: labelColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _datePreset == 'all' ? 'Semua Waktu' :
                        _datePreset == '30days' ? '30 Hari Terakhir' :
                        _datePreset == 'thisMonth' ? 'Bulan Ini' :
                        _datePreset == '90days' ? '3 Bulan Terakhir' : 'Kustom...',
                        style: context.footnote.copyWith(fontWeight: FontWeight.w600, color: CupertinoColors.activeBlue),
                      ),
                    ),
                    if (_startDate != null && _endDate != null) ...[
                      Text(
                        '${_startDate!.day}/${_startDate!.month}/${_startDate!.year} - ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                        style: context.caption1.copyWith(color: secondaryLabel, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 8),
                    ],
                    const Icon(CupertinoIcons.chevron_down, size: 14, color: CupertinoColors.inactiveGray),
                  ],
                ),
              ),
            ),

            // Choice Chips Filter
            SizedBox(
              height: 52,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _buildFilterChip('Semua', 'all'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Draft', 'draft'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Pending', 'pending'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Selesai', 'approved'),
                  ],
                ),
              ),
            ),

            // Main List
            Expanded(
              child: listState.when(
                data: (list) {
                  if (list.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.square_list, size: 48, color: secondaryLabel),
                          const SizedBox(height: CupertinoSpacing.m),
                          Text(
                            'Tidak ada landed cost',
                            style: context.subhead.copyWith(color: secondaryLabel),
                          ),
                        ],
                      ),
                    );
                  }

                  return Scrollbar(
                    controller: _scrollController,
                    child: CustomScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        CupertinoSliverRefreshControl(
                          onRefresh: () async {
                            ref.invalidate(landedCostListProvider);
                          },
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.all(CupertinoSpacing.m),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final cost = list[index];
                                final isDraft = cost.status.toLowerCase() == 'draft';

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: CupertinoSpacing.m),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (isDraft) {
                                        context.push('/landed-costs/${cost.id}/edit');
                                      } else {
                                        context.push('/landed-costs/${cost.id}');
                                      }
                                    },
                                    child: CupertinoGlassContainer(
                                      borderRadius: CupertinoSpacing.cardRadius,
                                      padding: const EdgeInsets.all(CupertinoSpacing.m),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                cost.referenceNumber,
                                                style: context.callout.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: labelColor,
                                                ),
                                              ),
                                              _buildStatusBadge(cost.status),
                                            ],
                                          ),
                                          const SizedBox(height: CupertinoSpacing.xs),
                                          Text(
                                            _formatDate(cost.postingDate),
                                            style: context.caption1.copyWith(color: secondaryLabel),
                                          ),
                                          const SizedBox(height: CupertinoSpacing.s),
                                          Container(
                                            height: 0.5,
                                            color: borderCol,
                                          ),
                                          const SizedBox(height: CupertinoSpacing.s),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Pemasok/Transporter',
                                                      style: context.caption2.copyWith(color: secondaryLabel),
                                                    ),
                                                    Text(
                                                      cost.supplierName,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: context.footnote.copyWith(
                                                        color: labelColor,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Total Biaya',
                                                    style: context.caption2.copyWith(color: secondaryLabel),
                                                  ),
                                                  Text(
                                                    formatWithCurrency(cost.totalAmount, cost.currency),
                                                    style: context.callout.copyWith(
                                                      color: labelColor,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              childCount: list.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const Center(
                  child: CupertinoActivityIndicator(),
                ),
                error: (err, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(CupertinoIcons.exclamationmark_triangle, size: 36, color: CupertinoColors.systemRed),
                        const SizedBox(height: 12),
                        Text(
                          'Gagal memuat landed cost:\n$err',
                          textAlign: TextAlign.center,
                          style: context.subhead.copyWith(color: secondaryLabel),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
