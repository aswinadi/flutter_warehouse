import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' show showDateRangePicker, Theme, ThemeData, ColorScheme, DateTimeRange, Colors;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:printing/printing.dart';
import '../providers/purchase_request_provider.dart';
import '../models/purchase_request.dart';
import '../models/supplier.dart';
import '../widgets/pr_card.dart';
import '../../../core/widgets/company_switcher.dart';
import 'pr_approval_screen.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_dialog.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';

// ─── Sentinel values ──────────────────────────────────────────────────────────

/// Maps to 'approved' API status but triggers item-based display.
const _kApprovedItemsFilter = '_approved_items';

/// Triggers item-based Waiting Comparison view.
const _kWaitingComparisonFilter = 'waiting_comparison';

// Enables mouse + trackpad drag scrolling on Flutter Web.
class _WebScrollBehavior extends CupertinoScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

// ─── Global Toast Helper ──────────────────────────────────────────────────────

void _showNotification(BuildContext context, String message, {bool isError = false}) {
  if (isError) {
    CupertinoGlassToast.showError(context, message);
  } else {
    CupertinoGlassToast.showSuccess(context, message);
  }
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class PRListScreen extends ConsumerStatefulWidget {
  final String? initialStatus;
  const PRListScreen({super.key, this.initialStatus});

  @override
  ConsumerState<PRListScreen> createState() => _PRListScreenState();
}

class _PRListScreenState extends ConsumerState<PRListScreen> {
  String? _selectedStatus = 'submitted';
  int? _selectedPrId;
  _ItemWithPr? _selectedItem;
  String? _selectedGroupKey;
  bool _isGeneratingPos = false;
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
      _selectedPrId = null;
      _selectedItem = null;
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
              primary: Color(0xFF6E56CF),
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
        _selectedItem = null;
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

  String? get _apiStatus {
    if (_selectedStatus == 'vendor_approved' || _selectedStatus == 'po_created') {
      return 'vendor_approved,po_created';
    }
    return _selectedStatus == _kApprovedItemsFilter ? 'approved' : _selectedStatus;
  }

  bool get _isApprovedItemsView => _selectedStatus == _kApprovedItemsFilter;
  bool get _isWaitingComparisonView =>
      _selectedStatus == _kWaitingComparisonFilter;
  bool get _isWaitingBodView => _selectedStatus == 'waiting_bod_approval';
  bool get _isVendorApprovedOrPoCreatedView =>
      _selectedStatus == 'vendor_approved' || _selectedStatus == 'po_created';

  @override
  void initState() {
    super.initState();
    if (widget.initialStatus != null) {
      _selectedStatus = widget.initialStatus;
    }
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
      ref.read(purchaseRequestsProvider(
        status: _apiStatus,
        startDate: _startDateStr,
        endDate: _endDateStr,
      ).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final prAsync = ref.watch(purchaseRequestsProvider(
      status: _apiStatus,
      startDate: _startDateStr,
      endDate: _endDateStr,
    ));
    final isWide = MediaQuery.of(context).size.width > 900;
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);
    final systemGroupedBgColor = CupertinoColors.systemGroupedBackground.resolveFrom(context);
    final secondarySystemGroupedBgColor = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return CupertinoPageScaffold(
      backgroundColor: systemGroupedBgColor,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Purchase Requests'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.refresh, size: 24),
          onPressed: () {
            setState(() {
              _selectedPrId = null;
              _selectedItem = null;
            });
            ref.invalidate(purchaseRequestsProvider);
          },
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const CompanySwitcher(),
            
            // Date Filter Panel
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: secondarySystemGroupedBgColor,
                border: Border(bottom: BorderSide(color: separatorColor, width: 0.5)),
              ),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.calendar, size: 16, color: Color(0xFF6E56CF)),
                  const SizedBox(width: 8),
                  Text(
                    'Periode:',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: secondaryLabelColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showDatePresetPicker(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemBackground.resolveFrom(context),
                          border: Border.all(color: separatorColor, width: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _getDatePresetLabel(_datePreset),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: labelColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(CupertinoIcons.chevron_down, size: 14, color: secondaryLabelColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_startDate != null && _endDate != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      '${_startDate!.day}/${_startDate!.month}/${_startDate!.year} - ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                      style: TextStyle(fontSize: 12, color: secondaryLabelColor, fontWeight: FontWeight.w500),
                    ),
                  ],
                  if (_datePreset == 'custom') ...[
                    const SizedBox(width: 8),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: 0,
                      onPressed: _selectCustomDateRange,
                      child: const Icon(CupertinoIcons.calendar_badge_plus, size: 20, color: Color(0xFF6E56CF)),
                    ),
                  ],
                ],
              ),
            ),
            
            // Filter list in premium horizontal pills
            SizedBox(
              height: 52,
              child: Stack(
                children: [
                  ScrollConfiguration(
                    behavior: _WebScrollBehavior(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          _buildFilterChip('Menunggu', 'submitted'),
                          const SizedBox(width: 8),
                          _buildFilterChip('PR Disetujui', _kApprovedItemsFilter),
                          const SizedBox(width: 8),
                          _buildFilterChip('Menunggu Perbandingan', _kWaitingComparisonFilter),
                          const SizedBox(width: 8),
                          _buildFilterChip('Menunggu BOD', 'waiting_bod_approval'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Vendor Disetujui', 'vendor_approved'),
                          const SizedBox(width: 8),
                          _buildFilterChip('PO Dibuat', 'po_created'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Ditolak', 'rejected'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Semua', null),
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
                              systemGroupedBgColor.withOpacity(0.0),
                              systemGroupedBgColor,
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
              child: prAsync.when(
                data: (requests) {
                  if (requests.isEmpty) {
                    return const Center(child: Text('No Purchase Requests found'));
                  }
                  final hasMore =
                      ref.watch(purchaseRequestsProvider(status: _apiStatus).notifier).hasMore;
                  final showLoader = prAsync.isLoading && hasMore;

                  // ── WAITING COMPARISON — item-based view ──────────────────
                  if (_isWaitingComparisonView) {
                    return _buildWaitingComparisonView(
                      context,
                      requests: requests,
                      isWide: isWide,
                      showLoader: showLoader,
                    );
                  }

                  // ── WAITING BOD APPROVAL — item-based view ──────────────────
                  if (_isWaitingBodView) {
                    return _buildWaitingBodView(
                      context,
                      requests: requests,
                      isWide: isWide,
                      showLoader: showLoader,
                    );
                  }

                  // ── VENDOR APPROVED / PO CREATED — vendor-warehouse grouped view ──
                  if (_isVendorApprovedOrPoCreatedView) {
                    return _buildGroupedVendorWarehouseView(
                      context,
                      requests: requests,
                      isWide: isWide,
                      showLoader: showLoader,
                    );
                  }

                  // ── APPROVED PR — item-based view ─────────────────────────
                  if (_isApprovedItemsView) {
                    final allItems = requests
                        .expand((pr) => pr.details.map((item) => _ItemWithPr(item: item, pr: pr)))
                        .where((entry) => entry.item.approvedQty != null && entry.item.approvedQty! > 0)
                        .toList();
                    if (allItems.isNotEmpty &&
                        (_selectedItem == null ||
                            !allItems.any((x) => x.item.id == _selectedItem!.item.id))) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _selectedItem = allItems.first;
                          });
                        }
                      });
                    }

                    if (allItems.isEmpty) {
                      return const Center(child: Text('No approved items found'));
                    }

                    final mainList = ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: allItems.length + (showLoader ? 1 : 0),
                      separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        if (index == allItems.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CupertinoActivityIndicator()),
                          );
                        }
                        final entry = allItems[index];
                        final isSelected = _selectedItem?.item.id == entry.item.id;
                        return _ApprovedItemCard(
                          item: entry.item,
                          pr: entry.pr,
                          isSelected: isSelected,
                          onTap: () {
                            if (isWide) {
                              setState(() {
                                _selectedItem = entry;
                              });
                            } else {
                              context.push('/pr/${entry.pr.id}/approve');
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
                          Container(width: 0.5, color: separatorColor),
                          Expanded(
                            child: _selectedItem != null
                                ? _ApprovedItemDetailsView(entry: _selectedItem!)
                                : Center(
                                    child: Text(
                                      'Select an item to view details',
                                      style: TextStyle(color: secondaryLabelColor),
                                    ),
                                  ),
                          ),
                        ],
                      );
                    } else {
                      return mainList;
                    }
                  }

                  // ── STANDARD PR-BASED VIEW ────────────────────────────────
                  if (isWide) {
                    if (requests.isNotEmpty &&
                        (_selectedPrId == null || !requests.any((x) => x.id == _selectedPrId))) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _selectedPrId = requests.first.id;
                          });
                        }
                      });
                    }
                  }

                  final mainList = ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: requests.length + (showLoader ? 1 : 0),
                    separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index == requests.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CupertinoActivityIndicator()),
                        );
                      }
                      final pr = requests[index];
                      final isSelected = pr.id == _selectedPrId;
                      return PRCard(
                        pr: pr,
                        isSelected: isSelected,
                        onTap: () {
                          if (isWide) {
                            setState(() {
                              _selectedPrId = pr.id;
                            });
                          } else {
                            context.push('/pr/${pr.id}/approve');
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
                        Container(width: 0.5, color: separatorColor),
                        Expanded(
                          child: _selectedPrId != null
                              ? PRDetailsView(prId: _selectedPrId!)
                              : Center(
                                  child: Text(
                                    'Select a Purchase Request to view details',
                                    style: TextStyle(color: secondaryLabelColor),
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
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String? value) {
    final isSelected = _selectedStatus == value;
    final contextResolvedBg = isSelected
        ? const Color(0xFF6E56CF)
        : CupertinoColors.tertiarySystemFill.resolveFrom(context);
    final labelColor = isSelected
        ? CupertinoColors.white
        : CupertinoColors.label.resolveFrom(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = value;
          _selectedPrId = null;
          _selectedItem = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: contextResolvedBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  // ── Waiting Comparison item-based builder ─────────────────────────────────

  Widget _buildWaitingComparisonView(
    BuildContext context, {
    required List<PurchaseRequest> requests,
    required bool isWide,
    required bool showLoader,
  }) {
    final allItems = requests
        .expand((pr) => pr.details.map((item) => _ItemWithPr(item: item, pr: pr)))
        .where((entry) {
          final status = entry.item.status?.toLowerCase();
          if (status == 'approved' || status == 'waiting_comparison') {
            return true;
          }
          if (entry.item.approvedQty != null && entry.item.approvedQty! > 0) {
            final isExcluded = status == 'po_created' ||
                status == 'waiting_bod_approval' ||
                status == 'vendor_approved' ||
                status == 'rejected';
            return !isExcluded;
          }
          return false;
        })
        .toList();

    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    if (allItems.isEmpty) {
      return const Center(child: Text('No items awaiting comparison'));
    }

    // Auto-select first item on wide screens
    if (isWide &&
        (_selectedItem == null ||
            !allItems.any((x) => x.item.id == _selectedItem!.item.id))) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _selectedItem = allItems.first);
      });
    } else if (isWide && _selectedItem != null) {
      // Always sync _selectedItem to the fresh entry from the latest data,
      // so the right pane reflects updated vendor/comparison data after assignment.
      final freshEntry = allItems.where((x) => x.item.id == _selectedItem!.item.id).firstOrNull;
      if (freshEntry != null && !identical(freshEntry.pr, _selectedItem!.pr)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _selectedItem = freshEntry);
        });
      }
    }

    final mainList = ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: allItems.length + (showLoader ? 1 : 0),
      separatorBuilder: (ctx, i) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == allItems.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CupertinoActivityIndicator()),
          );
        }
        final entry = allItems[index];
        final isSelected = _selectedItem?.item.id == entry.item.id;
        final vendorCount = entry.pr.comparisons
            .where((c) => c.details.any((d) => d.purchaseRequestDetailId == entry.item.id))
            .length;

        return _ComparisonItemCard(
          item: entry.item,
          pr: entry.pr,
          vendorCount: vendorCount,
          isSelected: isSelected,
          onTap: () {
            if (isWide) {
              setState(() => _selectedItem = entry);
            } else {
              showCupertinoModalPopup(
                context: context,
                builder: (_) => Container(
                  height: MediaQuery.of(context).size.height * 0.85,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: CupertinoPageScaffold(
                    navigationBar: CupertinoNavigationBar(
                      middle: const Text('Detail Perbandingan'),
                      trailing: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Text('Tutup'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    child: SafeArea(
                      child: _ComparisonItemDetailView(
                        entry: entry,
                        onAssigned: () {
                          ref.invalidate(purchaseRequestsProvider);
                          ref.invalidate(prItemSuggestionsProvider);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        );
      },
    );

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 380, child: mainList),
          Container(width: 0.5, color: separatorColor),
          Expanded(
            child: _selectedItem != null
                ? _ComparisonItemDetailView(
                    entry: _selectedItem!,
                    onAssigned: () {
                      ref.invalidate(purchaseRequestsProvider);
                      ref.invalidate(prItemSuggestionsProvider);
                    },
                  )
                : Center(
                    child: Text(
                      'Select an item to assign a vendor',
                      style: TextStyle(color: secondaryLabelColor),
                    ),
                  ),
          ),
        ],
      );
    } else {
      return mainList;
    }
  }

  Widget _buildWaitingBodView(
    BuildContext context, {
    required List<PurchaseRequest> requests,
    required bool isWide,
    required bool showLoader,
  }) {
    final allItems = requests
        .expand((pr) => pr.details.map((item) => _ItemWithPr(item: item, pr: pr)))
        .where((entry) => entry.item.status?.toLowerCase() == 'waiting_bod_approval')
        .toList();

    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    if (allItems.isEmpty) {
      return const Center(child: Text('No items waiting BOD approval'));
    }

    // Auto-select first item on wide screens
    if (isWide &&
        (_selectedItem == null ||
            !allItems.any((x) => x.item.id == _selectedItem!.item.id))) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _selectedItem = allItems.first);
      });
    } else if (isWide && _selectedItem != null) {
      final freshEntry = allItems.where((x) => x.item.id == _selectedItem!.item.id).firstOrNull;
      if (freshEntry != null && !identical(freshEntry.pr, _selectedItem!.pr)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _selectedItem = freshEntry);
        });
      }
    }

    final mainList = ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: allItems.length + (showLoader ? 1 : 0),
      separatorBuilder: (ctx, i) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == allItems.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CupertinoActivityIndicator()),
          );
        }
        final entry = allItems[index];
        final isSelected = _selectedItem?.item.id == entry.item.id;
        final vendorCount = entry.pr.comparisons
            .where((c) => c.details.any((d) => d.purchaseRequestDetailId == entry.item.id))
            .length;

        return _ComparisonItemCard(
          item: entry.item,
          pr: entry.pr,
          vendorCount: vendorCount,
          isSelected: isSelected,
          onTap: () {
            if (isWide) {
              setState(() => _selectedItem = entry);
            } else {
              showCupertinoModalPopup(
                context: context,
                builder: (_) => Container(
                  height: MediaQuery.of(context).size.height * 0.85,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: CupertinoPageScaffold(
                    navigationBar: CupertinoNavigationBar(
                      middle: const Text('Persetujuan Vendor BOD'),
                      trailing: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Text('Tutup'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    child: SafeArea(
                      child: _WaitingBodItemDetailView(
                        entry: entry,
                        onApproved: () {
                          ref.invalidate(purchaseRequestsProvider);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        );
      },
    );

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 380, child: mainList),
          Container(width: 0.5, color: separatorColor),
          Expanded(
            child: _selectedItem != null
                ? _WaitingBodItemDetailView(
                    entry: _selectedItem!,
                    onApproved: () {
                      ref.invalidate(purchaseRequestsProvider);
                    },
                  )
                : Center(
                    child: Text(
                      'Select an item to approve vendor',
                      style: TextStyle(color: secondaryLabelColor),
                    ),
                  ),
          ),
        ],
      );
    } else {
      return mainList;
    }
  }

  Widget _buildGroupedVendorWarehouseView(
    BuildContext context, {
    required List<PurchaseRequest> requests,
    required bool isWide,
    required bool showLoader,
  }) {
    final Map<String, VendorWarehouseGroup> groups = {};

    for (final pr in requests) {
      for (final item in pr.details) {
        if (item.selectedComparisonId == null) continue;

        final comp = pr.comparisons.firstWhere(
          (c) => c.id == item.selectedComparisonId,
          orElse: () => const PurchaseRequestComparison(
            id: -1,
            supplierId: -1,
            supplierName: 'Unknown Supplier',
            totalAmount: 0,
            leadTimeDays: 0,
          ),
        );
        if (comp.id == -1) continue;

        final supplierId = comp.supplierId;
        final supplierName = comp.supplierName;
        final leadTimeDays = comp.leadTimeDays;

        final warehouseCode = item.warehouseCode ?? 'unknown';
        final warehouseName = item.warehouseName ?? 'Unknown Warehouse';

        final cd = comp.details.firstWhere(
          (d) => d.purchaseRequestDetailId == item.id,
          orElse: () => const ComparisonDetail(id: -1, purchaseRequestDetailId: -1, offeredUnitPrice: 0.0),
        );
        final offeredUnitPrice = cd.offeredUnitPrice;
        final approvedQty = item.approvedQty ?? item.qtyRequested;
        final subtotal = offeredUnitPrice * approvedQty;

        final matchingPOs = pr.purchaseOrders
            .where((po) => po.supplierName == comp.supplierName)
            .toList();

        final key = "$supplierId|$warehouseCode";

        if (!groups.containsKey(key)) {
          groups[key] = VendorWarehouseGroup(
            supplierId: supplierId,
            supplierName: supplierName,
            warehouseCode: warehouseCode,
            warehouseName: warehouseName,
            leadTimeDays: leadTimeDays,
            items: [],
            purchaseOrders: [],
            totalPrice: 0,
            totalItemCount: 0,
          );
        }

        final group = groups[key]!;
        group.items.add(GroupedItemDetail(
          item: item,
          pr: pr,
          offeredUnitPrice: offeredUnitPrice,
          subtotal: subtotal,
        ));

        for (final po in matchingPOs) {
          if (!group.purchaseOrders.any((p) => p.id == po.id)) {
            group.purchaseOrders.add(po);
          }
        }
      }
    }

    final List<VendorWarehouseGroup> groupedList = [];
    for (final group in groups.values) {
      final allPoCreated = group.items.every((entry) => entry.item.status == 'po_created');

      if (_selectedStatus == 'vendor_approved' && allPoCreated) continue;
      if (_selectedStatus == 'po_created' && !allPoCreated) continue;

      double totalPrice = 0;
      for (final itemDetail in group.items) {
        totalPrice += itemDetail.subtotal;
      }

      groupedList.add(VendorWarehouseGroup(
        supplierId: group.supplierId,
        supplierName: group.supplierName,
        warehouseCode: group.warehouseCode,
        warehouseName: group.warehouseName,
        leadTimeDays: group.leadTimeDays,
        items: group.items,
        purchaseOrders: group.purchaseOrders,
        totalPrice: totalPrice,
        totalItemCount: group.items.length,
      ));
    }

    final secondaryLabelColor = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    if (groupedList.isEmpty) {
      return Center(
        child: Text(
          _selectedStatus == 'vendor_approved'
              ? 'No vendor approved items awaiting PO'
              : 'No completed POs found',
          style: TextStyle(color: secondaryLabelColor),
        ),
      );
    }

    final hasSelectedGroup = groupedList.any((g) => "${g.supplierId}|${g.warehouseCode}" == _selectedGroupKey);
    if (_selectedGroupKey == null || !hasSelectedGroup) {
      final firstKey = "${groupedList.first.supplierId}|${groupedList.first.warehouseCode}";
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _selectedGroupKey = firstKey;
          });
        }
      });
    }

    final selectedGroup = groupedList.firstWhere(
      (g) => "${g.supplierId}|${g.warehouseCode}" == _selectedGroupKey,
      orElse: () => groupedList.first,
    );

    double selectedGroupTotalPrice = 0;
    for (final itemDetail in selectedGroup.items) {
      selectedGroupTotalPrice += itemDetail.subtotal;
    }
    final selectedGroupWithPrice = VendorWarehouseGroup(
      supplierId: selectedGroup.supplierId,
      supplierName: selectedGroup.supplierName,
      warehouseCode: selectedGroup.warehouseCode,
      warehouseName: selectedGroup.warehouseName,
      leadTimeDays: selectedGroup.leadTimeDays,
      items: selectedGroup.items,
      purchaseOrders: selectedGroup.purchaseOrders,
      totalPrice: selectedGroupTotalPrice,
      totalItemCount: selectedGroup.items.length,
    );

    final mainList = ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: groupedList.length + (showLoader ? 1 : 0),
      separatorBuilder: (ctx, i) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == groupedList.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CupertinoActivityIndicator()),
          );
        }
        final group = groupedList[index];
        final key = "${group.supplierId}|${group.warehouseCode}";
        final isSelected = _selectedGroupKey == key;

        return VendorWarehouseGroupCard(
          group: group,
          isSelected: isSelected,
          onTap: () {
            if (isWide) {
              setState(() {
                _selectedGroupKey = key;
              });
            } else {
              showCupertinoModalPopup(
                context: context,
                builder: (_) => Container(
                  height: MediaQuery.of(context).size.height * 0.85,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: CupertinoPageScaffold(
                    navigationBar: CupertinoNavigationBar(
                      middle: Text(group.supplierName),
                      trailing: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Text('Tutup'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    child: SafeArea(
                      child: _GroupedDetailsView(
                        group: group,
                        isGeneratingPos: _isGeneratingPos,
                        onProceedToPO: (selectedIds) => _handleProceedToPO(group, selectedIds),
                        onDownloadPdf: (url, poNo) => _downloadAndPrintPdf(context, url, poNo),
                      ),
                    ),
                  ),
                ),
              );
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
          Container(width: 0.5, color: separatorColor),
          Expanded(
            child: _GroupedDetailsView(
              group: selectedGroupWithPrice,
              isGeneratingPos: _isGeneratingPos,
              onProceedToPO: (selectedIds) => _handleProceedToPO(selectedGroupWithPrice, selectedIds),
              onDownloadPdf: (url, poNo) => _downloadAndPrintPdf(context, url, poNo),
            ),
          ),
        ],
      );
    } else {
      return mainList;
    }
  }

  Future<void> _handleProceedToPO(VendorWarehouseGroup group, List<int> selectedItemIds) async {
    setState(() => _isGeneratingPos = true);
    try {
      final prGroups = <int, List<GroupedItemDetail>>{};
      for (final itemDetail in group.items) {
        if (selectedItemIds.contains(itemDetail.item.id)) {
          prGroups.putIfAbsent(itemDetail.pr.id, () => []).add(itemDetail);
        }
      }

      final repo = ref.read(purchaseRequestRepositoryProvider);
      final List<dynamic> allCreatedPOs = [];

      await Future.wait(prGroups.entries.map((entry) async {
        final prId = entry.key;
        final details = entry.value;
        final compIds = details
            .map((d) => d.item.selectedComparisonId)
            .whereType<int>()
            .toSet()
            .toList();
        final detailItemIds = details.map((d) => d.item.id).toList();

        final createdPOs = await repo.generatePOs(
          prId,
          comparisonIds: compIds,
          itemIds: detailItemIds,
        );
        allCreatedPOs.addAll(createdPOs);
      }));

      ref.invalidate(purchaseRequestsProvider(
        status: _apiStatus,
        startDate: _startDateStr,
        endDate: _endDateStr,
      ));

      if (mounted) {
        await showCupertinoDialog(
          context: context,
          builder: (dialogCtx) {
            return CupertinoGlassDialog(
              title: const Text('POs Generated'),
              content: Padding(
                padding: const EdgeInsets.only(top: CupertinoSpacing.s),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Successfully generated Purchase Orders for selected vendor and destination warehouse. You can download the PDF documents below:',
                      style: TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: CupertinoSpacing.screenMargin),
                    if (allCreatedPOs.isEmpty)
                      const Text('No new PO generated (might be already created).', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))
                    else
                      ...allCreatedPOs.map((poRaw) {
                        final poNum = poRaw['po_number'] ?? 'PO';
                        final supplierName = poRaw['supplier_name'] ?? 'Supplier';
                        final pdfUrl = poRaw['pdf_url'];

                        return CupertinoGlassContainer(
                          margin: const EdgeInsets.only(bottom: CupertinoSpacing.s),
                          padding: const EdgeInsets.all(CupertinoSpacing.s),
                          child: Row(
                            children: [
                              const Icon(CupertinoIcons.doc_text, size: 18, color: Color(0xFF6E56CF)),
                              const SizedBox(width: CupertinoSpacing.s),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      poNum,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                    Text(
                                      supplierName,
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                              if (pdfUrl != null)
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  onPressed: () {
                                    _downloadAndPrintPdf(dialogCtx, pdfUrl, poNum);
                                  },
                                  child: const Icon(CupertinoIcons.cloud_download, color: CupertinoColors.activeBlue, size: 20),
                                ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              ),
              actions: [
                CupertinoGlassDialogAction(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        _showNotification(context, 'Gagal membuat PO: ${_getErrorMessage(e)}', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isGeneratingPos = false);
      }
    }
  }

  String _getErrorMessage(dynamic e) {
    if (e is DioException) {
      final responseData = e.response?.data;
      if (responseData is Map) {
        if (responseData['errors'] != null && responseData['errors'] is Map) {
          final errors = responseData['errors'] as Map;
          if (errors.isNotEmpty) {
            final firstErrorVal = errors.values.first;
            if (firstErrorVal is List && firstErrorVal.isNotEmpty) {
              return firstErrorVal.first.toString();
            }
            return firstErrorVal.toString();
          }
        }
        if (responseData['message'] != null) {
          return responseData['message'].toString();
        }
        if (responseData['error'] != null) {
          return responseData['error'].toString();
        }
      }
      return e.message ?? e.toString();
    }
    return e.toString();
  }

  Future<void> _downloadAndPrintPdf(BuildContext context, String url, String fileName) async {
    if (url.isEmpty) return;
    bool dialogOpen = false;
    BuildContext? dialogContext;
    try {
      await Future.delayed(Duration.zero);
      if (!context.mounted) return;

      showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (dCtx) {
          dialogContext = dCtx;
          return const Center(child: CupertinoActivityIndicator(radius: 16));
        },
      );
      dialogOpen = true;

      final dio = ref.read(dioProvider);
      final response = await dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (dialogOpen) {
        dialogOpen = false;
        if (dialogContext != null && dialogContext!.mounted) {
          Navigator.pop(dialogContext!);
        } else if (context.mounted) {
          Navigator.pop(context);
        }
      }

      if (response.data != null) {
        if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
          final dir = await getDownloadsDirectory();
          if (dir != null) {
            final filePath = p.join(dir.path, '$fileName.pdf');
            final file = File(filePath);
            await file.writeAsBytes(response.data!);

            try {
              if (Platform.isWindows) {
                await Process.run('explorer.exe', [filePath.replaceAll('/', '\\')]);
              } else if (Platform.isMacOS) {
                await Process.run('open', [filePath]);
              } else if (Platform.isLinux) {
                await Process.run('xdg-open', [filePath]);
              }
            } catch (e) {
              // Ignore explorer opening errors
            }

            if (context.mounted) {
              _showNotification(context, 'Downloaded PDF to Downloads folder: $fileName.pdf');
            }
          } else {
            throw Exception('Could not find Downloads folder');
          }
        } else {
          await Printing.layoutPdf(
            name: fileName,
            onLayout: (format) async => Uint8List.fromList(response.data!),
          );
        }
      } else {
        throw Exception('Empty PDF response');
      }
    } catch (e) {
      if (dialogOpen) {
        dialogOpen = false;
        if (dialogContext != null && dialogContext!.mounted) {
          Navigator.pop(dialogContext!);
        } else if (context.mounted) {
          Navigator.pop(context);
        }
      }
      if (context.mounted) {
        _showNotification(context, 'Failed to download PDF: $e', isError: true);
      }
    }
  }
}

String _getDurationText(String? approvedAt) {
  if (approvedAt == null || approvedAt.isEmpty) return 'Approved: N/A';
  try {
    String formattedStr = approvedAt.trim();
    if (!formattedStr.endsWith('Z') &&
        !formattedStr.contains('+') &&
        !RegExp(r'-\d{2}:\d{2}$').hasMatch(formattedStr)) {
      // Append 'Z' to treat the database timestamp as UTC if no offset is present
      formattedStr = '${formattedStr}Z';
    }
    final parsed = DateTime.parse(formattedStr).toLocal();
    final now = DateTime.now();
    final diff = now.difference(parsed);

    final dateStr = '${parsed.day.toString().padLeft(2, '0')}/${parsed.month.toString().padLeft(2, '0')}/${parsed.year}';

    if (diff.inDays > 0) {
      return 'Approved: $dateStr (${diff.inDays} days ago)';
    } else if (diff.inHours > 0) {
      return 'Approved: $dateStr (${diff.inHours} hours ago)';
    } else if (diff.inMinutes > 0) {
      return 'Approved: $dateStr (${diff.inMinutes} mins ago)';
    } else {
      return 'Approved: $dateStr (just now)';
    }
  } catch (e) {
    return 'Approved: $approvedAt';
  }
}

// ─── Data helpers ─────────────────────────────────────────────────────────────

class _ItemWithPr {
  final PurchaseRequestItem item;
  final PurchaseRequest pr;
  const _ItemWithPr({required this.item, required this.pr});
}

// ─── Comparison Item Card ─────────────────────────────────────────────────────

class _ComparisonItemCard extends StatelessWidget {
  final PurchaseRequestItem item;
  final PurchaseRequest pr;
  final int vendorCount;
  final bool isSelected;
  final VoidCallback? onTap;

  const _ComparisonItemCard({
    required this.item,
    required this.pr,
    required this.vendorCount,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasVendor = vendorCount > 0;
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);

    return GestureDetector(
      onTap: onTap,
      child: CupertinoGlassContainer(
        borderColor: isSelected ? const Color(0xFF6E56CF) : separatorColor,
        borderRadius: CupertinoSpacing.cardRadius,
        padding: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.itemName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: labelColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: hasVendor
                          ? CupertinoColors.activeGreen.withOpacity(0.12)
                          : CupertinoColors.destructiveRed.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: hasVendor ? CupertinoColors.activeGreen : CupertinoColors.destructiveRed,
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.home,
                          size: 12,
                          color: hasVendor ? CupertinoColors.activeGreen : CupertinoColors.destructiveRed,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          hasVendor ? '$vendorCount vendor' : 'No vendor',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: hasVendor ? CupertinoColors.activeGreen : CupertinoColors.destructiveRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                item.itemCode,
                style: TextStyle(color: secondaryLabel, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(CupertinoIcons.doc_text, size: 13, color: Color(0xFF6E56CF)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${pr.code}  •  ${pr.companyName ?? "Unknown"}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6E56CF),
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (pr.approvedAt != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(CupertinoIcons.calendar, size: 13, color: CupertinoColors.systemOrange),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        _getDurationText(pr.approvedAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: CupertinoColors.systemOrange,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 10),
              Container(height: 0.5, color: separatorColor),
              const SizedBox(height: 10),
              (() {
                final displayQty = item.approvedQty ?? item.qtyRequested;
                final qtyLabel = item.approvedQty != null ? 'Approved Qty' : 'Req Qty';
                final qtyColor = item.approvedQty != null
                    ? CupertinoColors.activeGreen
                    : labelColor;
                final refQty = item.approvedQty ?? item.qtyRequested;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(qtyLabel,
                            style: TextStyle(
                                color: item.approvedQty != null
                                    ? CupertinoColors.activeGreen
                                    : secondaryLabel,
                                fontSize: 11,
                                fontWeight: item.approvedQty != null
                                    ? FontWeight.bold
                                    : FontWeight.normal)),
                        const SizedBox(height: 2),
                        Text(
                          '$displayQty ${item.uom}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: qtyColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.archivebox,
                          size: 13,
                          color: item.currentStock < refQty
                              ? CupertinoColors.systemOrange
                              : secondaryLabel,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Stock: ${item.currentStock} ${item.uom}',
                          style: TextStyle(
                            fontSize: 11,
                            color: item.currentStock < refQty
                                ? CupertinoColors.systemOrange
                                : secondaryLabel,
                            fontWeight: item.currentStock < refQty
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              })(),
              if (!hasVendor) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6E56CF).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    children: [
                      Icon(CupertinoIcons.hand_point_right, size: 13, color: Color(0xFF6E56CF)),
                      SizedBox(width: 6),
                      Text(
                        'Tap to assign a vendor',
                        style: TextStyle(fontSize: 11, color: Color(0xFF6E56CF)),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Comparison Item Detail View (right panel on wide screen) ─────────────────

class _ComparisonItemDetailView extends ConsumerStatefulWidget {
  final _ItemWithPr entry;
  final VoidCallback? onAssigned;

  const _ComparisonItemDetailView({required this.entry, this.onAssigned});

  @override
  ConsumerState<_ComparisonItemDetailView> createState() =>
      _ComparisonItemDetailViewState();
}

class _ComparisonItemDetailViewState
    extends ConsumerState<_ComparisonItemDetailView> {
  bool _isSubmittingToBod = false;

  Future<void> _removeComparison(BuildContext context, int comparisonId) async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoGlassDialog(
        title: const Text('Hapus Vendor?'),
        content: const Text('Apakah Anda yakin ingin menghapus vendor ini dari daftar perbandingan?'),
        actions: [
          CupertinoGlassDialogAction(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          CupertinoGlassDialogAction(
            isDestructive: true,
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final prId = widget.entry.pr.id;
        await ref.read(purchaseRequestRepositoryProvider).removeVendorComparison(prId, comparisonId);
        
        ref.invalidate(purchaseRequestsProvider);
        ref.invalidate(prItemSuggestionsProvider);
        
        if (mounted) {
          _showNotification(context, 'Vendor comparison removed successfully.');
          if (widget.onAssigned != null) {
            widget.onAssigned!();
          }
        }
      } catch (e) {
        if (mounted) {
          _showNotification(context, 'Failed to remove vendor: $e', isError: true);
        }
      }
    }
  }

  Future<void> _submitToBod() async {
    setState(() => _isSubmittingToBod = true);
    try {
      await ref
          .read(purchaseRequestRepositoryProvider)
          .submitToBod(widget.entry.pr.id, itemIds: [widget.entry.item.id]);
      ref.invalidate(purchaseRequestsProvider);
      if (mounted) {
        _showNotification(context, 'Item submitted to BOD for vendor selection.');
      }
    } catch (e) {
      if (mounted) {
        _showNotification(context, 'Error: $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isSubmittingToBod = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.entry.item;
    final pr = widget.entry.pr;

    final assignedComparisons = pr.comparisons
        .where((c) => c.details.any((d) => d.purchaseRequestDetailId == item.id))
        .toList();

    final itemHasMin2Vendors = assignedComparisons.length >= 2;
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.itemName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: labelColor,
                        ),
                      ),
                    ),
                    if (item.costCode != null) ...[
                      const SizedBox(width: 12),
                      _Badge(item.costCode!),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(item.itemCode,
                    style: TextStyle(fontSize: 14, color: secondaryLabel)),
                const SizedBox(height: 12),
                Container(height: 0.5, color: separatorColor),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(CupertinoIcons.doc_text, size: 16, color: Color(0xFF6E56CF)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${pr.code}  •  ${pr.companyName ?? "Unknown"}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6E56CF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _MetaChip(
                      icon: CupertinoIcons.shopping_cart,
                      label: item.approvedQty != null
                          ? 'Approved: ${item.approvedQty} ${item.uom}'
                          : 'Req: ${item.qtyRequested} ${item.uom}',
                      strong: item.approvedQty != null,
                      warning: false,
                      color: item.approvedQty != null
                          ? CupertinoColors.activeGreen
                          : null,
                    ),
                    _MetaChip(
                      icon: CupertinoIcons.archivebox,
                      label: 'Stock: ${item.currentStock} ${item.uom}',
                      warning: item.currentStock <
                          (item.approvedQty ?? item.qtyRequested),
                    ),
                    if (pr.approvedAt != null)
                      _MetaChip(
                        icon: CupertinoIcons.calendar,
                        label: _getDurationText(pr.approvedAt),
                        warning: true,
                        color: const Color(0xFFFFF7ED),
                        textColor: const Color(0xFFC2410C),
                      ),
                  ],
                ),
                if (item.dtSpec != null && item.dtSpec!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _FieldBox(label: 'Spesifikasi', value: item.dtSpec!),
                ],
                if (item.dtNotes != null && item.dtNotes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _FieldBox(label: 'Keterangan', value: item.dtNotes!),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Assigned vendors ─────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                assignedComparisons.isEmpty
                    ? 'No Vendors Assigned'
                    : 'Vendors Assigned (${assignedComparisons.length})',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: labelColor,
                ),
              ),
              _AssignVendorButton(
                entry: widget.entry,
                onAssigned: () {
                  ref.invalidate(purchaseRequestsProvider);
                  ref.invalidate(prItemSuggestionsProvider);
                  widget.onAssigned?.call();
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (assignedComparisons.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFED7AA)),
              ),
              child: const Column(
                children: [
                  Icon(CupertinoIcons.house,
                      size: 36, color: Color(0xFFF97316)),
                  const SizedBox(height: 8),
                  Text(
                    'No vendor has been assigned to this item yet.',
                    style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFEA580C),
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Use "Assign Vendor" to add a quotation from a supplier.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF9A3412)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ...assignedComparisons.map((comp) {
              final compDetail =
                  comp.details.firstWhere((d) => d.purchaseRequestDetailId == item.id);
              final canRemove = pr.status != 'waiting_bod_approval' &&
                  pr.status != 'approved_by_bod' &&
                  pr.status != 'po_created';
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: separatorColor, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(CupertinoIcons.home, size: 16, color: Color(0xFF6E56CF)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            comp.supplierName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: labelColor,
                            ),
                          ),
                        ),
                        if (comp.status != null) ...[
                          _Badge(comp.status!.toUpperCase(),
                              color: const Color(0xFFEFF6FF),
                              textColor: const Color(0xFF1D4ED8)),
                          const SizedBox(width: 8),
                        ],
                        if (canRemove)
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            minSize: 0,
                            onPressed: () => _removeComparison(context, comp.id),
                            child: const Icon(
                              CupertinoIcons.trash,
                              size: 16,
                              color: CupertinoColors.destructiveRed,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _MetaChip(
                          icon: CupertinoIcons.money_dollar,
                          label: formatWithCurrency(compDetail.offeredUnitPrice, 'IDR'),
                          strong: true,
                        ),
                        const SizedBox(width: 8),
                        _MetaChip(
                          icon: CupertinoIcons.clock,
                          label: '${comp.leadTimeDays} days',
                        ),
                      ],
                    ),
                    if (comp.notes != null && comp.notes!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        comp.notes!,
                        style: TextStyle(
                            fontSize: 12, color: secondaryLabel, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ],
                ),
              );
            }),

          // ── Submit to BOD button (when item has min 2 vendors) ───────────
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: itemHasMin2Vendors ? const Color(0xFFF0FDF4) : const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: itemHasMin2Vendors ? const Color(0xFF86EFAC) : const Color(0xFFFED7AA)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      itemHasMin2Vendors ? CupertinoIcons.check_mark_circled : CupertinoIcons.exclamationmark_triangle,
                      size: 16,
                      color: itemHasMin2Vendors ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        itemHasMin2Vendors
                            ? 'This item has at least 2 vendors assigned'
                            : 'This item must have a minimum of 2 vendors assigned to submit to BOD',
                        style: TextStyle(
                          fontSize: 13,
                          color: itemHasMin2Vendors ? const Color(0xFF16A34A) : const Color(0xFFB45309),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    color: itemHasMin2Vendors ? const Color(0xFF16A34A) : CupertinoColors.tertiarySystemFill.resolveFrom(context),
                    onPressed: (itemHasMin2Vendors && !_isSubmittingToBod) ? _submitToBod : null,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    borderRadius: BorderRadius.circular(8),
                    child: _isSubmittingToBod
                        ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.paperplane, size: 18, color: itemHasMin2Vendors ? CupertinoColors.white : CupertinoColors.placeholderText.resolveFrom(context)),
                              const SizedBox(width: 8),
                              Text(
                                'Submit to BOD for Approval',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: itemHasMin2Vendors ? CupertinoColors.white : CupertinoColors.placeholderText.resolveFrom(context),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─── Assign Vendor Button ─────────────────────────────────────────────────────

class _AssignVendorButton extends StatelessWidget {
  final _ItemWithPr entry;
  final VoidCallback? onAssigned;

  const _AssignVendorButton({required this.entry, this.onAssigned});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      minSize: 0,
      color: const Color(0xFF6E56CF),
      borderRadius: BorderRadius.circular(8),
      onPressed: () {
        showCupertinoModalPopup(
          context: context,
          builder: (popupContext) => Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: const Text('Assign Vendor'),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Text('Tutup'),
                  onPressed: () => Navigator.pop(popupContext),
                ),
              ),
              child: SafeArea(
                child: _AssignVendorSheet(
                  entry: entry,
                  onAssigned: onAssigned,
                ),
              ),
            ),
          ),
        );
      },
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(CupertinoIcons.plus_app, size: 16, color: CupertinoColors.white),
          SizedBox(width: 6),
          Text(
            'Assign Vendor',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: CupertinoColors.white),
          ),
        ],
      ),
    );
  }
}

// ─── Assign Vendor Sheet ──────────────────────────────────────────────────────

class _AssignVendorSheet extends ConsumerStatefulWidget {
  final _ItemWithPr entry;
  final VoidCallback? onAssigned;

  const _AssignVendorSheet({required this.entry, this.onAssigned});

  @override
  ConsumerState<_AssignVendorSheet> createState() => _AssignVendorSheetState();
}

class _AssignVendorSheetState extends ConsumerState<_AssignVendorSheet> {
  int _selectedTabIndex = 0;

  // New Vendor tab state
  final _searchController = TextEditingController();
  String _searchQuery = '';
  Supplier? _selectedSupplier;
  final _priceController = TextEditingController();
  final _leadTimeController = TextEditingController(text: '7');
  final _notesController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _searchController.dispose();
    _priceController.dispose();
    _leadTimeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitAssignment({
    required int supplierId,
    required double price,
    int leadTimeDays = 7,
    String? notes,
  }) async {
    setState(() => _isSubmitting = true);
    try {
      await ref.read(purchaseRequestRepositoryProvider).assignVendorComparison(
        widget.entry.pr.id,
        supplierId: supplierId,
        leadTimeDays: leadTimeDays,
        notes: notes,
        items: [
          {
            'pr_detail_id': widget.entry.item.id,
            'price': price,
          }
        ],
      );
      ref.invalidate(purchaseRequestsProvider);
      ref.invalidate(prItemSuggestionsProvider);
      if (mounted) {
        Navigator.pop(context);
        _showNotification(context, 'Vendor assigned successfully.');
        widget.onAssigned?.call();
      }
    } catch (e) {
      if (mounted) {
        _showNotification(context, 'Error: $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.entry.item;
    final suggestionsAsync = ref.watch(prItemSuggestionsProvider(widget.entry.pr.id));
    final scrollController = ScrollController();

    return Column(
      children: [
        const SizedBox(height: 16),
        // Header info
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Icon(CupertinoIcons.plus_app, color: Color(0xFF6E56CF), size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Assign Vendor',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
                    Text(
                      item.itemName,
                      style: TextStyle(
                          fontSize: 12, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Custom Sliding Control for Tabs
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
          child: CupertinoSlidingSegmentedControl<int>(
            groupValue: _selectedTabIndex,
            onValueChanged: (val) {
              if (val != null) {
                setState(() => _selectedTabIndex = val);
              }
            },
            children: const {
              0: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('Historical Data', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ),
              1: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('New Vendor', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ),
            },
          ),
        ),
        const SizedBox(height: 8),

        // Tabs Content stack
        Expanded(
          child: _selectedTabIndex == 0
              ? _buildHistoricalTab(context, item, suggestionsAsync, scrollController)
              : _buildNewVendorTab(context, scrollController),
        ),
      ],
    );
  }

  // ── Historical Data tab ────────────────────────────────────────────────────

  Widget _buildHistoricalTab(
    BuildContext context,
    PurchaseRequestItem item,
    AsyncValue<List<dynamic>> suggestionsAsync,
    ScrollController scrollController,
  ) {
    return suggestionsAsync.when(
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (err, _) =>
          Center(child: Text('Error loading history: $err')),
      data: (suggestions) {
        final itemData = suggestions.firstWhere(
          (x) => x['pr_detail_id'] == item.id,
          orElse: () => null,
        );

        final lastVendor = itemData?['suggestions']?['last_vendor'];
        final cheapestVendor = itemData?['suggestions']?['cheapest'];
        final currentComparisons =
            (itemData?['current_comparisons'] as List<dynamic>?) ?? [];

        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            if (currentComparisons.isNotEmpty) ...[
              const _SectionHeader('Sudah Ditetapkan'),
              const SizedBox(height: 8),
              ...currentComparisons.map((c) => _CurrentComparisonTile(c)),
              const SizedBox(height: 20),
            ],

            if (lastVendor != null) ...[
              const _SectionHeader('Vendor Terakhir Digunakan'),
              const SizedBox(height: 8),
              _HistoricalVendorCard(
                icon: CupertinoIcons.clock,
                supplierName: lastVendor['supplier_name'] ?? 'Tidak Diketahui',
                price: lastVendor['price'] != null
                    ? (lastVendor['price'] as num).toDouble()
                    : null,
                leadTimeDays: lastVendor['lead_time_days'] as int? ?? 7,
                date: lastVendor['last_purchased_at'] as String?,
                accentColor: const Color(0xFF6E56CF),
                isSubmitting: _isSubmitting,
                onAssign: (price, leadTime) => _submitAssignment(
                  supplierId: lastVendor['supplier_id'] as int,
                  price: price,
                  leadTimeDays: leadTime,
                ),
              ),
              const SizedBox(height: 16),
            ],

            if (cheapestVendor != null) ...[
              const _SectionHeader('Vendor Termurah (Historis)'),
              const SizedBox(height: 8),
              _HistoricalVendorCard(
                icon: CupertinoIcons.money_dollar,
                supplierName: cheapestVendor['supplier_name'] ?? 'Tidak Diketahui',
                price: cheapestVendor['price'] != null
                    ? (cheapestVendor['price'] as num).toDouble()
                    : null,
                leadTimeDays: cheapestVendor['lead_time_days'] as int? ?? 7,
                accentColor: CupertinoColors.activeGreen,
                isSubmitting: _isSubmitting,
                onAssign: (price, leadTime) => _submitAssignment(
                  supplierId: cheapestVendor['supplier_id'] as int,
                  price: price,
                  leadTimeDays: leadTime,
                ),
              ),
              const SizedBox(height: 16),
            ],

            if (lastVendor == null && cheapestVendor == null && currentComparisons.isEmpty)
              const _EmptyState(
                icon: CupertinoIcons.clock,
                title: 'No purchase history',
                subtitle:
                    'No previous vendor data found for this item. Use "New Vendor" tab to assign manually.',
              ),
          ],
        );
      },
    );
  }

  // ── New Vendor tab ─────────────────────────────────────────────────────────

  Widget _buildNewVendorTab(BuildContext context, ScrollController scrollController) {
    final labelColor = CupertinoColors.label.resolveFrom(context);

    if (_selectedSupplier != null) {
      return ListView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selected Supplier',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  letterSpacing: 0.5,
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    _selectedSupplier = null;
                    _priceController.clear();
                    _leadTimeController.text = '7';
                    _notesController.clear();
                  });
                },
                child: const Row(
                  children: [
                    Icon(CupertinoIcons.refresh, size: 14),
                    SizedBox(width: 4),
                    Text('Change', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _SupplierTile(
            supplier: _selectedSupplier!,
            isSelected: true,
            onTap: () {
              setState(() {
                _selectedSupplier = null;
                _priceController.clear();
                _leadTimeController.text = '7';
                _notesController.clear();
              });
            },
          ),
          const SizedBox(height: 20),
          Container(height: 0.5, color: CupertinoColors.separator.resolveFrom(context)),
          const SizedBox(height: 16),
          Text(
            'Quote details for ${_selectedSupplier!.name}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: labelColor,
            ),
          ),
          const SizedBox(height: 16),
          
          const Text('Unit Price (IDR) *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          CupertinoTextField(
            controller: _priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefix: const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Rp ', style: TextStyle(color: CupertinoColors.placeholderText)),
            ),
            placeholder: '0',
          ),
          const SizedBox(height: 12),
          
          const Text('Lead Time (days)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          CupertinoTextField(
            controller: _leadTimeController,
            keyboardType: TextInputType.number,
            suffix: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Text('days', style: TextStyle(color: CupertinoColors.placeholderText)),
            ),
          ),
          const SizedBox(height: 12),
          
          const Text('Notes (optional)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          CupertinoTextField(
            controller: _notesController,
            maxLines: 2,
            placeholder: 'e.g. includes delivery, FOB terms...',
          ),
          const SizedBox(height: 20),
          
          SizedBox(
            width: double.infinity,
            child: CupertinoButton.filled(
              onPressed: _isSubmitting ? null : _submitNewVendor,
              child: _isSubmitting
                  ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.check_mark, size: 18),
                        SizedBox(width: 8),
                        Text('Save Vendor Assignment', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      );
    }

    final suppliersAsync = ref.watch(suppliersProvider(_searchQuery.isEmpty ? null : _searchQuery));

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        CupertinoSearchTextField(
          controller: _searchController,
          placeholder: 'Search supplier by name or code...',
          onChanged: (val) {
            _debounce?.cancel();
            _debounce = Timer(const Duration(milliseconds: 500), () {
              if (mounted) setState(() => _searchQuery = val.trim());
            });
          },
        ),
        const SizedBox(height: 12),

        suppliersAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CupertinoActivityIndicator()),
          ),
          error: (e, _) => Text('Error loading suppliers: $e',
              style: const TextStyle(color: CupertinoColors.destructiveRed)),
          data: (suppliers) {
            if (suppliers.isEmpty) {
              return const _EmptyState(
                icon: CupertinoIcons.search,
                title: 'No suppliers found',
                subtitle: 'Try a different search term.',
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${suppliers.length} suppliers found',
                    style: TextStyle(
                        fontSize: 12, color: CupertinoColors.secondaryLabel.resolveFrom(context))),
                const SizedBox(height: 8),
                ...suppliers.map((s) {
                  final isSelected = _selectedSupplier?.id == s.id;
                  return _SupplierTile(
                    supplier: s,
                    isSelected: isSelected,
                    onTap: () => setState(() {
                      _selectedSupplier = isSelected ? null : s;
                    }),
                  );
                }),
              ],
            );
          },
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Timer? _debounce;

  void _submitNewVendor() {
    final supplier = _selectedSupplier;
    if (supplier == null) return;
    final priceText = _priceController.text.trim();
    if (priceText.isEmpty) {
      _showNotification(context, 'Please enter the unit price', isError: true);
      return;
    }
    final price = double.tryParse(priceText.replaceAll(',', '.'));
    if (price == null || price < 0) {
      _showNotification(context, 'Invalid price value', isError: true);
      return;
    }
    final leadTime = int.tryParse(_leadTimeController.text.trim()) ?? 7;
    final notes = _notesController.text.trim();

    _submitAssignment(
      supplierId: supplier.id,
      price: price,
      leadTimeDays: leadTime,
      notes: notes.isEmpty ? null : notes,
    );
  }
}

// ─── Historical Vendor Card ───────────────────────────────────────────────────

class _HistoricalVendorCard extends StatefulWidget {
  final IconData icon;
  final String supplierName;
  final double? price;
  final int leadTimeDays;
  final String? date;
  final Color accentColor;
  final bool isSubmitting;
  final void Function(double price, int leadTime) onAssign;

  const _HistoricalVendorCard({
    required this.icon,
    required this.supplierName,
    this.price,
    required this.leadTimeDays,
    this.date,
    required this.accentColor,
    required this.isSubmitting,
    required this.onAssign,
  });

  @override
  State<_HistoricalVendorCard> createState() => _HistoricalVendorCardState();
}

class _HistoricalVendorCardState extends State<_HistoricalVendorCard> {
  late TextEditingController _priceCtrl;
  late TextEditingController _leadTimeCtrl;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _priceCtrl = TextEditingController(text: widget.price?.toStringAsFixed(0) ?? '');
    _leadTimeCtrl = TextEditingController(text: widget.leadTimeDays.toString());
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    _leadTimeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: separatorColor, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(widget.icon, size: 18, color: widget.accentColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.supplierName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: labelColor),
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 0,
                onPressed: () => setState(() => _editing = !_editing),
                child: Text(
                  _editing ? 'Cancel' : 'Edit Price',
                  style: TextStyle(fontSize: 12, color: widget.accentColor, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (!_editing) ...[
            if (widget.price != null)
              Text(
                formatWithCurrency(widget.price!, 'IDR'),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: widget.accentColor),
              )
            else
              Text('No price on record', style: TextStyle(color: secondaryLabel, fontSize: 13)),
            if (widget.date != null) ...[
              const SizedBox(height: 4),
              Text('Last purchased: ${widget.date}', style: TextStyle(fontSize: 12, color: secondaryLabel)),
            ],
          ] else ...[
            const Text('Unit Price (IDR)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            CupertinoTextField(
              controller: _priceCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefix: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Rp ', style: TextStyle(color: CupertinoColors.placeholderText)),
              ),
            ),
            const SizedBox(height: 8),
            const Text('Lead Time (days)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            CupertinoTextField(
              controller: _leadTimeCtrl,
              keyboardType: TextInputType.number,
              suffix: const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text('days', style: TextStyle(color: CupertinoColors.placeholderText)),
              ),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: widget.accentColor,
              borderRadius: BorderRadius.circular(8),
              onPressed: widget.isSubmitting
                  ? null
                  : () {
                      final price = double.tryParse(_priceCtrl.text.replaceAll(',', '.')) ?? widget.price ?? 0.0;
                      final leadTime = int.tryParse(_leadTimeCtrl.text) ?? widget.leadTimeDays;
                      widget.onAssign(price, leadTime);
                    },
              child: widget.isSubmitting
                  ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                  : const Text('Quick Assign', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: CupertinoColors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Supplier Tile ────────────────────────────────────────────────────────────

class _SupplierTile extends StatelessWidget {
  final Supplier supplier;
  final bool isSelected;
  final VoidCallback onTap;

  const _SupplierTile({
    required this.supplier,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final activeBg = const Color(0xFF6E56CF).withOpacity(0.08);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF6E56CF) : separatorColor,
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF6E56CF) : CupertinoColors.systemGroupedBackground.resolveFrom(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  CupertinoIcons.home,
                  size: 18,
                  color: isSelected ? CupertinoColors.white : secondaryLabel,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      supplier.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: isSelected ? const Color(0xFF6E56CF) : labelColor,
                      ),
                    ),
                    if (supplier.city != null || supplier.code != null)
                      Text(
                        [supplier.code, supplier.city]
                            .where((x) => x != null)
                            .join(' • '),
                        style: TextStyle(fontSize: 11, color: secondaryLabel),
                      ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(CupertinoIcons.check_mark_circled_solid, size: 20, color: Color(0xFF6E56CF)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Current Comparison Tile ──────────────────────────────────────────────────

class _CurrentComparisonTile extends StatelessWidget {
  final dynamic data;
  const _CurrentComparisonTile(this.data);

  @override
  Widget build(BuildContext context) {
    final name = data['supplier_name'] ?? 'Unknown';
    final price = data['price'] != null ? (data['price'] as num).toDouble() : null;
    final lead = data['lead_time_days'] as int? ?? 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFBBF7D0), width: 0.5),
      ),
      child: Row(
        children: [
          const Icon(CupertinoIcons.check_mark_circled, size: 16, color: Color(0xFF16A34A)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(name,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color(0xFF166534))),
          ),
          if (price != null)
            Text(formatWithCurrency(price, 'IDR'),
                style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF16A34A),
                    fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text('$lead d',
              style: TextStyle(fontSize: 11, color: CupertinoColors.secondaryLabel.resolveFrom(context))),
        ],
      ),
    );
  }
}

// ─── Small reusable widgets ───────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final Widget child;
  const _InfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: separatorColor, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const _Badge(
    this.text, {
    this.color = const Color(0xFFF1F5F9),
    this.textColor = const Color(0xFF475569),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: CupertinoColors.separator.resolveFrom(context), width: 0.5),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool warning;
  final bool strong;
  final Color? color;
  final Color? textColor;

  const _MetaChip({
    required this.icon,
    required this.label,
    this.warning = false,
    this.strong = false,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isBadge = textColor != null;
    final iconTextColor = textColor ?? color ?? (warning ? CupertinoColors.systemOrange : CupertinoColors.secondaryLabel.resolveFrom(context));
    
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: iconTextColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: iconTextColor,
            fontWeight: strong ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );

    if (isBadge) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: row,
      );
    }
    return row;
  }
}

class _FieldBox extends StatelessWidget {
  final String label;
  final String value;

  const _FieldBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final boxBg = CupertinoColors.systemGroupedBackground.resolveFrom(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: secondaryLabel)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: boxBg,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: separatorColor, width: 0.5),
          ),
          child: Text(value, style: TextStyle(fontSize: 12, color: labelColor)),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: CupertinoColors.secondaryLabel.resolveFrom(context),
        letterSpacing: 0.5,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(icon, size: 48, color: secondaryLabel.withOpacity(0.4)),
          const SizedBox(height: 12),
          Text(title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: secondaryLabel)),
          const SizedBox(height: 6),
          Text(subtitle,
              style: TextStyle(fontSize: 12, color: secondaryLabel.withOpacity(0.8)),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// ─── Approved Item Card ───────────────────────────────────────────────────────

class _ApprovedItemCard extends StatelessWidget {
  final PurchaseRequestItem item;
  final PurchaseRequest pr;
  final bool isSelected;
  final VoidCallback? onTap;

  const _ApprovedItemCard({
    required this.item,
    required this.pr,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);

    return GestureDetector(
      onTap: onTap,
      child: CupertinoGlassContainer(
        borderColor: isSelected ? const Color(0xFF6E56CF) : separatorColor,
        borderRadius: CupertinoSpacing.cardRadius,
        padding: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.itemName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: labelColor,
                      ),
                    ),
                  ),
                  if (item.costCode != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: separatorColor, width: 0.5),
                      ),
                      child: Text(
                        item.costCode!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: secondaryLabel,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(item.itemCode, style: TextStyle(color: secondaryLabel, fontSize: 12)),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(CupertinoIcons.doc_text, size: 13, color: Color(0xFF6E56CF)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${pr.code}  •  ${pr.companyName ?? "Unknown"}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6E56CF),
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  _buildMetadataIconText(
                    CupertinoIcons.calendar,
                    'Requested: ${pr.requestDate}',
                    secondaryLabel,
                  ),
                  if (pr.approvedBy != null && pr.approvedBy!.isNotEmpty)
                    _buildMetadataIconText(
                      CupertinoIcons.person,
                      'Approved By: ${pr.approvedBy}',
                      secondaryLabel,
                    ),
                  if (pr.approvedAt != null && pr.approvedAt!.isNotEmpty)
                    _buildMetadataIconText(
                      CupertinoIcons.check_mark_circled,
                      'Approved At: ${_formatDate(pr.approvedAt!)}',
                      secondaryLabel,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Container(height: 0.5, color: separatorColor),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Req Qty',
                        style: TextStyle(color: secondaryLabel, fontSize: 11),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${item.qtyRequested} ${item.uom}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: labelColor,
                        ),
                      ),
                    ],
                  ),
                  if (item.approvedQty != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Approved Qty',
                          style: TextStyle(
                            color: CupertinoColors.activeGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item.approvedQty} ${item.uom}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.activeGreen,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(CupertinoIcons.archivebox, size: 14, color: secondaryLabel),
                  const SizedBox(width: 4),
                  Text(
                    'Current Stock: ${item.currentStock} ${item.uom}',
                    style: TextStyle(
                      fontSize: 12,
                      color: item.currentStock < item.qtyRequested
                          ? CupertinoColors.systemOrange
                          : secondaryLabel,
                      fontWeight: item.currentStock < item.qtyRequested
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              if (item.dtSpec != null && item.dtSpec!.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: separatorColor, width: 0.5),
                  ),
                  child: Text(
                    'Spesifikasi: ${item.dtSpec}',
                    style: TextStyle(
                      fontSize: 12,
                      color: labelColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
              if (item.dtNotes != null && item.dtNotes!.trim().isNotEmpty) ...[
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: separatorColor, width: 0.5),
                  ),
                  child: Text(
                    'Keterangan: ${item.dtNotes}',
                    style: TextStyle(fontSize: 12, color: labelColor),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateTimeStr) {
    try {
      final parts = dateTimeStr.split(' ');
      if (parts.isNotEmpty) {
        final dateParts = parts[0].split('-');
        if (dateParts.length == 3) {
          return '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}';
        }
        return parts[0];
      }
    } catch (_) {}
    return dateTimeStr;
  }

  Widget _buildMetadataIconText(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 11, color: color),
        ),
      ],
    );
  }
}

// ─── Approved Item Details View ───────────────────────────────────────────────

class _ApprovedItemDetailsView extends ConsumerStatefulWidget {
  final _ItemWithPr entry;
  const _ApprovedItemDetailsView({required this.entry});

  @override
  ConsumerState<_ApprovedItemDetailsView> createState() =>
      _ApprovedItemDetailsViewState();
}

class _ApprovedItemDetailsViewState
    extends ConsumerState<_ApprovedItemDetailsView> {
  bool _isAutoAssigning = false;

  Future<void> _handleAutoAssign(String strategy) async {
    setState(() => _isAutoAssigning = true);
    try {
      final repo = ref.read(purchaseRequestRepositoryProvider);
      await repo.autoAssignVendors(widget.entry.pr.id, strategy: strategy);
      ref.invalidate(purchaseRequestsProvider);
      if (mounted) {
        _showNotification(context, 'Auto-assignment successful.');
      }
    } catch (e) {
      if (mounted) {
        _showNotification(context, 'Error auto-assigning: $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isAutoAssigning = false);
    }
  }

  void _showStrategySheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Auto-Assign Vendors'),
        message: const Text('Select strategy to automatically find and assign the best vendors based on buying history:'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _handleAutoAssign('lowest_price');
            },
            child: const Text('Lowest Price (Harga Terendah)'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _handleAutoAssign('last_supplier');
            },
            child: const Text('Last Supplier (Pemasok Terakhir)'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.entry.item;
    final pr = widget.entry.pr;
    final suggestionsAsync = ref.watch(prItemSuggestionsProvider(pr.id));
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.itemName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: labelColor,
                        ),
                      ),
                    ),
                    if (item.costCode != null) ...[
                      const SizedBox(width: 12),
                      _Badge(item.costCode!),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.itemCode,
                  style: TextStyle(fontSize: 14, color: secondaryLabel),
                ),
                const SizedBox(height: 16),
                Container(height: 0.5, color: separatorColor),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(CupertinoIcons.doc_text, size: 16, color: Color(0xFF6E56CF)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${pr.code}  •  ${pr.companyName ?? "Unknown"}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6E56CF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quantity & Stock Information',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: labelColor)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildQtyCard('Requested Qty', '${item.qtyRequested} ${item.uom}',
                          labelColor, CupertinoColors.systemGroupedBackground.resolveFrom(context)),
                    ),
                    if (item.approvedQty != null) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQtyCard('Approved Qty', '${item.approvedQty} ${item.uom}',
                            CupertinoColors.activeGreen, const Color(0xFFECFDF5)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                _buildQtyCard(
                    'Current Stock',
                    '${item.currentStock} ${item.uom}',
                    item.currentStock < item.qtyRequested
                        ? CupertinoColors.systemOrange
                        : secondaryLabel,
                    item.currentStock < item.qtyRequested
                        ? const Color(0xFFFEF3C7)
                        : CupertinoColors.systemGroupedBackground.resolveFrom(context)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Spesifikasi',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: labelColor)),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: separatorColor, width: 0.5)),
                  child: Text(
                    (item.dtSpec != null && item.dtSpec!.trim().isNotEmpty) ? item.dtSpec! : '-',
                    style: TextStyle(fontSize: 13, color: labelColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Keterangan',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: labelColor)),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: separatorColor, width: 0.5)),
                  child: Text(
                    (item.dtNotes != null && item.dtNotes!.trim().isNotEmpty) ? item.dtNotes! : '-',
                    style: TextStyle(fontSize: 13, color: labelColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Last Vendor Details',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: labelColor)),
                const SizedBox(height: 16),
                suggestionsAsync.when(
                  data: (suggestions) {
                    final itemData = suggestions.firstWhere(
                      (x) => x['pr_detail_id'] == item.id,
                      orElse: () => null,
                    );
                    final lastVendor = itemData?['suggestions']?['last_vendor'];
                    final cheapestVendor = itemData?['suggestions']?['cheapest'];

                    if (lastVendor == null && cheapestVendor == null) {
                      return Text(
                        'No purchase history found for this item.',
                        style: TextStyle(fontSize: 13, color: secondaryLabel, fontStyle: FontStyle.italic),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (lastVendor != null) ...[
                          _buildHistoryRow(CupertinoIcons.clock, 'Last Vendor', lastVendor['supplier_name'] ?? 'Unknown',
                              price: lastVendor['price'] != null ? formatWithCurrency(lastVendor['price'], 'IDR') : null,
                              date: lastVendor['last_purchased_at'] != null ? _formatDate(lastVendor['last_purchased_at']) : null),
                        ],
                        if (lastVendor != null && cheapestVendor != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Container(height: 0.5, color: separatorColor),
                          ),
                        if (cheapestVendor != null) ...[
                          _buildHistoryRow(CupertinoIcons.money_dollar, 'Cheapest Vendor', cheapestVendor['supplier_name'] ?? 'Unknown',
                              price: cheapestVendor['price'] != null ? formatWithCurrency(cheapestVendor['price'], 'IDR') : null),
                        ],
                      ],
                    );
                  },
                  loading: () => const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CupertinoActivityIndicator()),
                      ),
                  error: (err, _) => Text('Error loading history: $err',
                      style: TextStyle(color: CupertinoColors.destructiveRed, fontSize: 12)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton.filled(
              onPressed: _isAutoAssigning ? null : _showStrategySheet,
              child: _isAutoAssigning
                  ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.wand_stars, size: 18),
                        SizedBox(width: 8),
                        Text('Auto-Assign Vendors to this PR', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyCard(String label, String val, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: CupertinoColors.secondaryLabel.resolveFrom(context), fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(val, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }

  Widget _buildHistoryRow(IconData icon, String label, String supplierName, {String? price, String? date}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF6E56CF)),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: CupertinoColors.label.resolveFrom(context))),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(supplierName, style: TextStyle(fontSize: 13, color: CupertinoColors.label.resolveFrom(context), fontWeight: FontWeight.w600)),
              if (price != null) ...[
                const SizedBox(height: 4),
                Text('Price: $price', style: TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel.resolveFrom(context))),
              ],
              if (date != null) ...[
                const SizedBox(height: 2),
                Text('Purchased at: $date', style: TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel.resolveFrom(context))),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateTimeStr) {
    try {
      final parts = dateTimeStr.split(' ');
      if (parts.isNotEmpty) {
        final dateParts = parts[0].split('-');
        if (dateParts.length == 3) {
          return '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}';
        }
        return parts[0];
      }
    } catch (_) {}
    return dateTimeStr;
  }
}

// ─── Vendor Warehouse Grouping Data Structure ────────────────────────────────

class VendorWarehouseGroup {
  final int supplierId;
  final String supplierName;
  final String warehouseCode;
  final String warehouseName;
  final int leadTimeDays;
  final List<GroupedItemDetail> items;
  final List<PRAssociatedPO> purchaseOrders;
  final double totalPrice;
  final int totalItemCount;

  VendorWarehouseGroup({
    required this.supplierId,
    required this.supplierName,
    required this.warehouseCode,
    required this.warehouseName,
    required this.leadTimeDays,
    required this.items,
    required this.purchaseOrders,
    required this.totalPrice,
    required this.totalItemCount,
  });
}

class GroupedItemDetail {
  final PurchaseRequestItem item;
  final PurchaseRequest pr;
  final double offeredUnitPrice;
  final double subtotal;

  GroupedItemDetail({
    required this.item,
    required this.pr,
    required this.offeredUnitPrice,
    required this.subtotal,
  });
}

// ─── Vendor Warehouse Group Card ─────────────────────────────────────────────

class VendorWarehouseGroupCard extends StatelessWidget {
  final VendorWarehouseGroup group;
  final bool isSelected;
  final VoidCallback onTap;

  const VendorWarehouseGroupCard({
    super.key,
    required this.group,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final allPoCreated = group.items.every((entry) => entry.item.status == 'po_created');
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);

    return GestureDetector(
      onTap: onTap,
      child: CupertinoGlassContainer(
        borderColor: isSelected ? const Color(0xFF6E56CF) : separatorColor,
        borderRadius: CupertinoSpacing.cardRadius,
        padding: EdgeInsets.zero,
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
                      group.supplierName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: labelColor,
                      ),
                    ),
                  ),
                  if (allPoCreated)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: CupertinoColors.activeGreen.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: CupertinoColors.activeGreen.withOpacity(0.3)),
                      ),
                      child: const Text(
                        'PO Created',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.activeGreen,
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: CupertinoColors.activeBlue.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: CupertinoColors.activeBlue.withOpacity(0.3)),
                      ),
                      child: const Text(
                        'Awaiting PO',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Lead time: ${group.leadTimeDays} days',
                style: TextStyle(color: secondaryLabel, fontSize: 12),
              ),
              const SizedBox(height: 12),
              Container(height: 0.5, color: separatorColor),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(CupertinoIcons.home, size: 14, color: Color(0xFF6E56CF)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      group.warehouseName,
                      style: TextStyle(
                        fontSize: 13,
                        color: labelColor,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${group.totalItemCount} items',
                    style: TextStyle(fontSize: 13, color: secondaryLabel),
                  ),
                  Text(
                    formatWithCurrency(group.totalPrice, 'IDR'),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6E56CF),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Grouped Details View ───────────────────────────────────────────────────

class _GroupedDetailsView extends StatefulWidget {
  final VendorWarehouseGroup group;
  final ScrollController? scrollController;
  final bool isGeneratingPos;
  final Function(List<int> selectedItemIds) onProceedToPO;
  final Function(String url, String number) onDownloadPdf;

  const _GroupedDetailsView({
    required this.group,
    this.scrollController,
    required this.isGeneratingPos,
    required this.onProceedToPO,
    required this.onDownloadPdf,
  });

  @override
  State<_GroupedDetailsView> createState() => _GroupedDetailsViewState();
}

class _GroupedDetailsViewState extends State<_GroupedDetailsView> {
  late Set<int> _selectedItemIds;

  @override
  void initState() {
    super.initState();
    _initSelection();
  }

  @override
  void didUpdateWidget(_GroupedDetailsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.group != widget.group) {
      _initSelection();
    }
  }

  void _initSelection() {
    _selectedItemIds = widget.group.items
        .where((entry) => entry.item.status != 'po_created')
        .map((entry) => entry.item.id)
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final allPoCreated = widget.group.items.every((entry) => entry.item.status == 'po_created');
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);

    final selectedTotal = allPoCreated
        ? widget.group.totalPrice
        : widget.group.items
            .where((entry) => _selectedItemIds.contains(entry.item.id))
            .fold<double>(0, (sum, entry) => sum + entry.subtotal);

    final unOrderedItems = widget.group.items.where((entry) => entry.item.status != 'po_created').toList();
    final allUnOrderedSelected = unOrderedItems.isNotEmpty &&
        unOrderedItems.every((entry) => _selectedItemIds.contains(entry.item.id));

    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: widget.scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: separatorColor, width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.group.supplierName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: labelColor,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: allPoCreated
                                ? CupertinoColors.activeGreen.withOpacity(0.12)
                                : CupertinoColors.activeBlue.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: allPoCreated
                                    ? CupertinoColors.activeGreen.withOpacity(0.3)
                                    : CupertinoColors.activeBlue.withOpacity(0.3)),
                          ),
                          child: Text(
                            allPoCreated ? 'PO CREATED' : 'APPROVED',
                            style: TextStyle(
                              color: allPoCreated ? CupertinoColors.activeGreen : CupertinoColors.activeBlue,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(CupertinoIcons.home, size: 14, color: secondaryLabel),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Warehouse: ${widget.group.warehouseName}',
                            style: TextStyle(fontSize: 13, color: labelColor, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(CupertinoIcons.clock, size: 14, color: secondaryLabel),
                        const SizedBox(width: 6),
                        Text(
                          'Estimated Lead Time: ${widget.group.leadTimeDays} days',
                          style: TextStyle(fontSize: 13, color: secondaryLabel),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Container(height: 0.5, color: separatorColor),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Order Value:',
                          style: TextStyle(fontSize: 13, color: secondaryLabel, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          formatWithCurrency(selectedTotal, 'IDR'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6E56CF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Items to be Ordered',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: labelColor,
                    ),
                  ),
                  if (unOrderedItems.isNotEmpty)
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: 0,
                      onPressed: () {
                        setState(() {
                          if (allUnOrderedSelected) {
                            _selectedItemIds.clear();
                          } else {
                            _selectedItemIds.addAll(unOrderedItems.map((e) => e.item.id));
                          }
                        });
                      },
                      child: Text(
                        allUnOrderedSelected ? 'Deselect All' : 'Select All',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6E56CF),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              ...widget.group.items.map((entry) {
                final item = entry.item;
                final pr = entry.pr;
                final isOrdered = item.status == 'po_created';
                final isChecked = _selectedItemIds.contains(item.id);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: separatorColor, width: 0.5),
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.black.withOpacity(0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!isOrdered)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isChecked) {
                                _selectedItemIds.remove(item.id);
                              } else {
                                _selectedItemIds.add(item.id);
                              }
                            });
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Icon(
                              isChecked
                                  ? CupertinoIcons.checkmark_square_fill
                                  : CupertinoIcons.square,
                              color: isChecked
                                  ? const Color(0xFF6E56CF)
                                  : secondaryLabel,
                              size: 22,
                            ),
                          ),
                        ),
                      Expanded(
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
                                      item.itemName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: labelColor,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    formatWithCurrency(entry.subtotal, 'IDR'),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 13, color: labelColor),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.itemCode,
                                    style: TextStyle(color: secondaryLabel, fontSize: 12),
                                  ),
                                  Text(
                                    'Qty: ${item.approvedQty ?? item.qtyRequested} ${item.uom} @ ${formatWithCurrency(entry.offeredUnitPrice, "IDR")}',
                                    style: TextStyle(fontSize: 12, color: secondaryLabel),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Container(height: 0.5, color: separatorColor),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(CupertinoIcons.doc_text, size: 13, color: Color(0xFF6E56CF)),
                                      const SizedBox(width: 4),
                                      Text(
                                        pr.code,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF6E56CF),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (isOrdered)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: CupertinoColors.activeGreen.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        item.poNumber != null ? 'PO: ${item.poNumber}' : 'PO Created',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: CupertinoColors.activeGreen,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              if (item.dtSpec != null && item.dtSpec!.trim().isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Spesifikasi: ${item.dtSpec}',
                                  style: TextStyle(fontSize: 12, color: secondaryLabel, fontStyle: FontStyle.italic),
                                ),
                              ],
                              if (item.dtNotes != null && item.dtNotes!.trim().isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Keterangan: ${item.dtNotes}',
                                  style: TextStyle(fontSize: 12, color: secondaryLabel),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              if (widget.group.purchaseOrders.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  'Associated Purchase Orders',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: labelColor,
                  ),
                ),
                const SizedBox(height: 8),
                ...widget.group.purchaseOrders.map((po) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: separatorColor, width: 0.5),
                      ),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.doc_plaintext, color: Color(0xFF6E56CF), size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  po.poNumber,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: labelColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Status: ${po.status.toUpperCase()}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: po.status.toLowerCase() == 'ordered' ? CupertinoColors.activeGreen : secondaryLabel,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (po.pdfUrl != null && po.pdfUrl!.isNotEmpty)
                            CupertinoButton(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              minSize: 0,
                              color: const Color(0xFF6E56CF),
                              borderRadius: BorderRadius.circular(6),
                              onPressed: () => widget.onDownloadPdf(po.pdfUrl!, po.poNumber),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(CupertinoIcons.cloud_download, size: 14, color: CupertinoColors.white),
                                  SizedBox(width: 4),
                                  Text('PDF', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: CupertinoColors.white)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    )),
              ],
            ],
          ),
        ),

        if (!allPoCreated)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              border: Border(top: BorderSide(color: separatorColor, width: 0.5)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: CupertinoButton.filled(
                onPressed: widget.isGeneratingPos || _selectedItemIds.isEmpty
                    ? null
                    : () => widget.onProceedToPO(_selectedItemIds.toList()),
                child: widget.isGeneratingPos
                    ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.list_bullet, size: 18),
                          SizedBox(width: 8),
                          Text('Proceed to PO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Waiting BOD Item Detail View ───────────────────────────────────────────

class _WaitingBodItemDetailView extends ConsumerStatefulWidget {
  final _ItemWithPr entry;
  final VoidCallback? onApproved;

  const _WaitingBodItemDetailView({required this.entry, this.onApproved});

  @override
  ConsumerState<_WaitingBodItemDetailView> createState() =>
      _WaitingBodItemDetailViewState();
}

class _WaitingBodItemDetailViewState
    extends ConsumerState<_WaitingBodItemDetailView> {
  @override
  Widget build(BuildContext context) {
    final item = widget.entry.item;
    final pr = widget.entry.pr;

    final assignedComparisons = pr.comparisons
        .where((c) => c.details.any((d) => d.purchaseRequestDetailId == item.id))
        .toList();

    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.itemName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: labelColor,
                        ),
                      ),
                    ),
                    if (item.costCode != null) ...[
                      const SizedBox(width: 12),
                      _Badge(item.costCode!),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(item.itemCode,
                    style: TextStyle(fontSize: 14, color: secondaryLabel)),
                const SizedBox(height: 12),
                Container(height: 0.5, color: separatorColor),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(CupertinoIcons.doc_text, size: 16, color: Color(0xFF6E56CF)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${pr.code}  •  ${pr.companyName ?? "Unknown"}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6E56CF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _MetaChip(
                      icon: CupertinoIcons.shopping_cart,
                      label: item.approvedQty != null
                          ? 'Approved: ${item.approvedQty} ${item.uom}'
                          : 'Req: ${item.qtyRequested} ${item.uom}',
                      strong: item.approvedQty != null,
                      warning: false,
                      color: item.approvedQty != null
                          ? CupertinoColors.activeGreen
                          : null,
                    ),
                    _MetaChip(
                      icon: CupertinoIcons.archivebox,
                      label: 'Stock: ${item.currentStock} ${item.uom}',
                      warning: item.currentStock <
                          (item.approvedQty ?? item.qtyRequested),
                    ),
                  ],
                ),
                if (item.dtSpec != null && item.dtSpec!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _FieldBox(label: 'Spesifikasi', value: item.dtSpec!),
                ],
                if (item.dtNotes != null && item.dtNotes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _FieldBox(label: 'Keterangan', value: item.dtNotes!),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          Text(
            assignedComparisons.isEmpty
                ? 'No Vendors Assigned'
                : 'Perbandingan Vendor (${assignedComparisons.length})',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: labelColor,
            ),
          ),
          const SizedBox(height: 12),

          if (assignedComparisons.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFED7AA)),
              ),
              child: const Text('No vendor has been assigned to this item yet.'),
            )
          else
            ...assignedComparisons.map((comp) {
              final compDetail =
                  comp.details.firstWhere((d) => d.purchaseRequestDetailId == item.id);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: separatorColor,
                    width: 0.5,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comp.supplierName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: labelColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _MetaChip(
                                icon: CupertinoIcons.money_dollar,
                                label: formatWithCurrency(compDetail.offeredUnitPrice, 'IDR'),
                                strong: true,
                              ),
                              const SizedBox(width: 8),
                              _MetaChip(
                                icon: CupertinoIcons.clock,
                                label: '${comp.leadTimeDays} days',
                              ),
                            ],
                          ),
                          if (comp.notes != null && comp.notes!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              comp.notes!,
                              style: TextStyle(
                                  fontSize: 12, color: secondaryLabel, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
