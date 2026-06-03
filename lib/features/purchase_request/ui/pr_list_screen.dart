import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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

// ─── Sentinel values ──────────────────────────────────────────────────────────

/// Maps to 'approved' API status but triggers item-based display.
const _kApprovedItemsFilter = '_approved_items';

/// Triggers item-based Waiting Comparison view.
const _kWaitingComparisonFilter = 'waiting_comparison';

// Enables mouse + trackpad drag scrolling on Flutter Web.
class _WebScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class PRListScreen extends ConsumerStatefulWidget {
  const PRListScreen({super.key});

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
        _selectedPrId = null;
        _selectedItem = null;
      });
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
  bool get _isVendorApprovedOrPoCreatedView =>
      _selectedStatus == 'vendor_approved' || _selectedStatus == 'po_created';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Requests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _selectedPrId = null;
                _selectedItem = null;
              });
              ref.invalidate(purchaseRequestsProvider);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const CompanySwitcher(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Color(0xFF4F46E5)),
                const SizedBox(width: 8),
                const Text(
                  'Periode:',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _datePreset,
                      dropdownColor: Colors.white,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B), fontWeight: FontWeight.w600),
                      onChanged: (val) {
                        if (val != null) {
                          _updateDatePreset(val);
                          if (val == 'custom') {
                            _selectCustomDateRange();
                          }
                        }
                      },
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('Semua Waktu')),
                        DropdownMenuItem(value: '30days', child: Text('30 Hari Terakhir')),
                        DropdownMenuItem(value: 'thisMonth', child: Text('Bulan Ini')),
                        DropdownMenuItem(value: '90days', child: Text('3 Bulan Terakhir')),
                        DropdownMenuItem(value: 'custom', child: Text('Pilih Tanggal...')),
                      ],
                    ),
                  ),
                ),
                if (_startDate != null && _endDate != null) ...[
                  Text(
                    '${_startDate!.day}/${_startDate!.month}/${_startDate!.year} - ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 8),
                ],
                if (_datePreset == 'custom')
                  IconButton(
                    icon: const Icon(Icons.date_range, size: 18, color: Color(0xFF4F46E5)),
                    onPressed: _selectCustomDateRange,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 52,
            child: Stack(
              children: [
                ScrollConfiguration(
                  behavior: _WebScrollBehavior(),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            Colors.white.withValues(alpha: 0.0),
                            Colors.white,
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
                          child: Center(child: CircularProgressIndicator()),
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
                        const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                        Expanded(
                          child: _selectedItem != null
                              ? _ApprovedItemDetailsView(entry: _selectedItem!)
                              : const Center(
                                  child: Text(
                                    'Select an item to view details',
                                    style: TextStyle(color: Color(0xFF64748B)),
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
                        child: Center(child: CircularProgressIndicator()),
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
                      const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                      Expanded(
                        child: _selectedPrId != null
                            ? PRDetailsView(prId: _selectedPrId!)
                            : const Center(
                                child: Text(
                                  'Select a Purchase Request to view details',
                                  style: TextStyle(color: Color(0xFF64748B)),
                                ),
                              ),
                      ),
                    ],
                  );
                } else {
                  return mainList;
                }
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
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
        .where((entry) => entry.item.status != 'po_created' && entry.item.status != 'waiting_bod_approval')
        .toList();

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
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final entry = allItems[index];
        final isSelected = _selectedItem?.item.id == entry.item.id;
        // Count how many comparisons cover this item
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
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => _ComparisonItemDetailSheet(
                  entry: entry,
                  vendorCount: vendorCount,
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
          const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE2E8F0)),
          Expanded(
            child: _selectedItem != null
                ? _ComparisonItemDetailView(
                    entry: _selectedItem!,
                    onAssigned: () {
                      ref.invalidate(purchaseRequestsProvider);
                      ref.invalidate(prItemSuggestionsProvider);
                    },
                  )
                : const Center(
                    child: Text(
                      'Select an item to assign a vendor',
                      style: TextStyle(color: Color(0xFF64748B)),
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
    // 1. Group items across requests by supplier + warehouse code
    final Map<String, VendorWarehouseGroup> groups = {};

    for (final pr in requests) {
      for (final item in pr.details) {
        if (item.selectedComparisonId == null) continue;

        // Find comparison corresponding to the selected comparison ID
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

        // Find offered price
        final cd = comp.details.firstWhere(
          (d) => d.purchaseRequestDetailId == item.id,
          orElse: () => const ComparisonDetail(id: -1, purchaseRequestDetailId: -1, offeredUnitPrice: 0.0),
        );
        final offeredUnitPrice = cd.offeredUnitPrice;
        final approvedQty = item.approvedQty ?? item.qtyRequested;
        final subtotal = offeredUnitPrice * approvedQty;

        // Find associated POs matching this supplier
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

    // Convert Map values to List and recalculate totals
    final List<VendorWarehouseGroup> groupedList = [];
    for (final group in groups.values) {
      final allPoCreated = group.items.every((entry) => entry.item.status == 'po_created');

      // Filter based on tab status
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

    if (groupedList.isEmpty) {
      return Center(
        child: Text(
          _selectedStatus == 'vendor_approved'
              ? 'No vendor approved items awaiting PO'
              : 'No completed POs found',
          style: const TextStyle(color: Color(0xFF64748B)),
        ),
      );
    }

    // 2. Select default group
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

    // Recalculate selected group's total price (since selectedGroup might be read directly from map)
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
            child: Center(child: CircularProgressIndicator()),
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
              // Mobile view: Show full screen modal or sheet
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => DraggableScrollableSheet(
                  initialChildSize: 0.9,
                  maxChildSize: 0.95,
                  minChildSize: 0.5,
                  builder: (ctx, scrollController) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            width: 36,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          Expanded(
                            child: _GroupedDetailsView(
                              group: group,
                              scrollController: scrollController,
                              isGeneratingPos: _isGeneratingPos,
                              onProceedToPO: () => _handleProceedToPO(group),
                              onDownloadPdf: (url, poNo) => _downloadAndPrintPdf(context, url, poNo),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
          const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE2E8F0)),
          Expanded(
            child: _GroupedDetailsView(
              group: selectedGroupWithPrice,
              isGeneratingPos: _isGeneratingPos,
              onProceedToPO: () => _handleProceedToPO(selectedGroupWithPrice),
              onDownloadPdf: (url, poNo) => _downloadAndPrintPdf(context, url, poNo),
            ),
          ),
        ],
      );
    } else {
      return mainList;
    }
  }

  Future<void> _handleProceedToPO(VendorWarehouseGroup group) async {
    setState(() => _isGeneratingPos = true);
    try {
      // Find all unique PRs involved in this group
      final prGroups = <int, List<GroupedItemDetail>>{};
      for (final itemDetail in group.items) {
        prGroups.putIfAbsent(itemDetail.pr.id, () => []).add(itemDetail);
      }

      final repo = ref.read(purchaseRequestRepositoryProvider);
      final List<dynamic> allCreatedPOs = [];

      // Concurrently generate POs for each PR
      await Future.wait(prGroups.entries.map((entry) async {
        final prId = entry.key;
        final details = entry.value;
        final compIds = details
            .map((d) => d.item.selectedComparisonId)
            .whereType<int>()
            .toSet()
            .toList();

        final createdPOs = await repo.generatePOs(prId, comparisonIds: compIds);
        allCreatedPOs.addAll(createdPOs);
      }));

      // Refresh list provider
      ref.invalidate(purchaseRequestsProvider(
        status: _apiStatus,
        startDate: _startDateStr,
        endDate: _endDateStr,
      ));

      if (mounted) {
        // Show success dialog
        await showDialog(
          context: context,
          builder: (dialogCtx) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.check_circle_outline, color: Color(0xFF10B981)),
                  SizedBox(width: 8),
                  Text('POs Generated'),
                ],
              ),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Successfully generated Purchase Orders for selected vendor and destination warehouse. You can download the PDF documents below:',
                      style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
                    ),
                    const SizedBox(height: 16),
                    if (allCreatedPOs.isEmpty)
                      const Text('No new PO generated (might be already created).', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))
                    else
                      ...allCreatedPOs.map((poRaw) {
                        final poNum = poRaw['po_number'] ?? 'PO';
                        final supplierName = poRaw['supplier_name'] ?? 'Supplier';
                        final pdfUrl = poRaw['pdf_url'];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.receipt_long_outlined, size: 18, color: Color(0xFF4F46E5)),
                              const SizedBox(width: 10),
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
                                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                    ),
                                  ],
                                ),
                              ),
                              if (pdfUrl != null)
                                IconButton(
                                  icon: const Icon(Icons.download_rounded, color: Color(0xFF4F46E5), size: 20),
                                  onPressed: () {
                                    _downloadAndPrintPdf(context, pdfUrl, poNum);
                                  },
                                ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Tutup'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuat PO: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGeneratingPos = false);
      }
    }
  }

  Future<void> _downloadAndPrintPdf(BuildContext context, String url, String fileName) async {
    if (url.isEmpty) return;
    bool dialogOpen = false;
    BuildContext? dialogContext;
    try {
      // Delay showing dialog to allow pending transitions/pops to complete
      await Future.delayed(Duration.zero);
      if (!context.mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dCtx) {
          dialogContext = dCtx;
          return const Center(child: CircularProgressIndicator());
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
          // Direct file saving for desktop
          final dir = await getDownloadsDirectory();
          if (dir != null) {
            final filePath = p.join(dir.path, '$fileName.pdf');
            final file = File(filePath);
            await file.writeAsBytes(response.data!);

            // Open the saved file using default platform app
            try {
              if (Platform.isWindows) {
                await Process.run('explorer.exe', [filePath.replaceAll('/', '\\')]);
              } else if (Platform.isMacOS) {
                await Process.run('open', [filePath]);
              } else if (Platform.isLinux) {
                await Process.run('xdg-open', [filePath]);
              }
            } catch (e) {
              // Ignore failure to open file
            }

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Downloaded PDF to Downloads folder: $fileName.pdf'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          } else {
            throw Exception('Could not find Downloads folder');
          }
        } else {
          // Fallback for Web/Mobile (layoutPdf shows save/preview UI)
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildFilterChip(String label, String? value) {
    final isSelected = _selectedStatus == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedStatus = selected ? value : null;
          _selectedPrId = null;
          _selectedItem = null;
        });
      },
    );
  }
}

String _getDurationText(String? approvedAt) {
  if (approvedAt == null || approvedAt.isEmpty) return 'Approved: N/A';
  try {
    final parsed = DateTime.parse(approvedAt);
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A0F0F0F),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row: item name + vendor badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.itemName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Vendor count badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: hasVendor
                            ? const Color(0xFFDCFCE7)
                            : const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: hasVendor
                              ? const Color(0xFF16A34A)
                              : const Color(0xFFDC2626),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            hasVendor ? Icons.store_outlined : Icons.store_rounded,
                            size: 12,
                            color: hasVendor
                                ? const Color(0xFF16A34A)
                                : const Color(0xFFDC2626),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            hasVendor ? '$vendorCount vendor' : 'No vendor',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: hasVendor
                                  ? const Color(0xFF16A34A)
                                  : const Color(0xFFDC2626),
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
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                ),
                const SizedBox(height: 6),
                // PR reference
                Row(
                  children: [
                    const Icon(Icons.description_outlined, size: 13, color: Color(0xFF4F46E5)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${pr.code}  •  ${pr.companyName ?? "Unknown"}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4F46E5),
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
                      const Icon(Icons.calendar_today_outlined, size: 13, color: Color(0xFFEAB308)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _getDurationText(pr.approvedAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFD97706),
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 10),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 10),
                // Qty row — show approved qty (what will actually be ordered)
                (() {
                  final displayQty = item.approvedQty ?? item.qtyRequested;
                  final qtyLabel = item.approvedQty != null ? 'Approved Qty' : 'Req Qty';
                  final qtyColor = item.approvedQty != null
                      ? const Color(0xFF10B981)
                      : const Color(0xFF0F172A);
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
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFF64748B),
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
                      // Stock warning
                      Row(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 13,
                            color: item.currentStock < refQty
                                ? const Color(0xFFF59E0B)
                                : const Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Stock: ${item.currentStock} ${item.uom}',
                            style: TextStyle(
                              fontSize: 11,
                              color: item.currentStock < refQty
                                  ? const Color(0xFFF59E0B)
                                  : const Color(0xFF94A3B8),
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
                // Action hint when no vendor
                if (!hasVendor) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.touch_app_outlined, size: 13, color: Color(0xFF4F46E5)),
                        SizedBox(width: 6),
                        Text(
                          'Tap to assign a vendor',
                          style: TextStyle(fontSize: 11, color: Color(0xFF4F46E5)),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
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

  Future<void> _submitToBod() async {
    setState(() => _isSubmittingToBod = true);
    try {
      await ref
          .read(purchaseRequestRepositoryProvider)
          .submitToBod(widget.entry.pr.id);
      ref.invalidate(purchaseRequestsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PR submitted to BOD for vendor selection.'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmittingToBod = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.entry.item;
    final pr = widget.entry.pr;

    // Comparisons that have a quote for this specific item
    final assignedComparisons = pr.comparisons
        .where((c) => c.details.any((d) => d.purchaseRequestDetailId == item.id))
        .toList();

    // Check all items in the PR (that aren't already PO created or submitted to BOD) have at least 2 vendors
    final allItemsHaveMin2Vendors = pr.details
        .where((d) => d.status != 'po_created' && d.status != 'waiting_bod_approval')
        .every((detail) {
      final vendorCount = pr.comparisons
          .where((c) => c.details.any((d) => d.purchaseRequestDetailId == detail.id))
          .length;
      return vendorCount >= 2;
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Item header ──────────────────────────────────────────────────
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
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
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
                    style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.description_outlined, size: 16, color: Color(0xFF4F46E5)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${pr.code}  •  ${pr.companyName ?? "Unknown"}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4F46E5),
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
                      icon: Icons.shopping_basket_outlined,
                      label: item.approvedQty != null
                          ? 'Approved: ${item.approvedQty} ${item.uom}'
                          : 'Req: ${item.qtyRequested} ${item.uom}',
                      strong: item.approvedQty != null,
                      warning: false,
                      color: item.approvedQty != null
                          ? const Color(0xFF10B981)
                          : null,
                    ),
                    _MetaChip(
                      icon: Icons.inventory_2_outlined,
                      label: 'Stock: ${item.currentStock} ${item.uom}',
                      warning: item.currentStock <
                          (item.approvedQty ?? item.qtyRequested),
                    ),
                    if (pr.approvedAt != null)
                      _MetaChip(
                        icon: Icons.calendar_today_outlined,
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
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
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
              child: Column(
                children: [
                  const Icon(Icons.store_mall_directory_outlined,
                      size: 36, color: Color(0xFFF97316)),
                  const SizedBox(height: 8),
                  const Text(
                    'No vendor has been assigned to this item yet.',
                    style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFEA580C),
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  const Text(
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
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.store_outlined,
                            size: 16, color: Color(0xFF4F46E5)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            comp.supplierName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                        if (comp.status != null)
                          _Badge(comp.status!.toUpperCase(),
                              color: const Color(0xFFEFF6FF),
                              textColor: const Color(0xFF1D4ED8)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _MetaChip(
                          icon: Icons.price_change_outlined,
                          label: formatWithCurrency(compDetail.offeredUnitPrice, 'IDR'),
                          strong: true,
                        ),
                        const SizedBox(width: 8),
                        _MetaChip(
                          icon: Icons.schedule_outlined,
                          label: '${comp.leadTimeDays} days',
                        ),
                      ],
                    ),
                    if (comp.notes != null && comp.notes!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        comp.notes!,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF64748B), fontStyle: FontStyle.italic),
                      ),
                    ],
                  ],
                ),
              );
            }),

          // ── Submit to BOD button (when all items have min 2 vendors) ───────────
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: allItemsHaveMin2Vendors ? const Color(0xFFF0FDF4) : const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: allItemsHaveMin2Vendors ? const Color(0xFF86EFAC) : const Color(0xFFFED7AA)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      allItemsHaveMin2Vendors ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                      size: 16,
                      color: allItemsHaveMin2Vendors ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        allItemsHaveMin2Vendors
                            ? 'All items in this PR have at least 2 vendors assigned'
                            : 'Each item must have a minimum of 2 vendors assigned to submit to BOD',
                        style: TextStyle(
                          fontSize: 13,
                          color: allItemsHaveMin2Vendors ? const Color(0xFF16A34A) : const Color(0xFFB45309),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: (allItemsHaveMin2Vendors && !_isSubmittingToBod) ? _submitToBod : null,
                    icon: _isSubmittingToBod
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.send_outlined, size: 18),
                    label: const Text('Submit to BOD for Approval'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: allItemsHaveMin2Vendors ? const Color(0xFF16A34A) : Colors.grey.shade300,
                      foregroundColor: allItemsHaveMin2Vendors ? Colors.white : Colors.grey.shade500,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

// ─── Comparison Item Detail Sheet (mobile — bottom sheet) ─────────────────────

class _ComparisonItemDetailSheet extends ConsumerWidget {
  final _ItemWithPr entry;
  final int vendorCount;

  const _ComparisonItemDetailSheet({
    required this.entry,
    required this.vendorCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF8FAFC),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
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
            ],
          ),
        );
      },
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
    return ElevatedButton.icon(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => _AssignVendorSheet(
            entry: entry,
            onAssigned: onAssigned,
          ),
        );
      },
      icon: const Icon(Icons.add_business_outlined, size: 16),
      label: const Text('Assign Vendor'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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

class _AssignVendorSheetState extends ConsumerState<_AssignVendorSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // New Vendor tab state
  final _searchController = TextEditingController();
  String _searchQuery = '';
  Supplier? _selectedSupplier;
  final _priceController = TextEditingController();
  final _leadTimeController = TextEditingController(text: '7');
  final _notesController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vendor assigned successfully.'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        widget.onAssigned?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.entry.item;
    final suggestionsAsync = ref.watch(prItemSuggestionsProvider(widget.entry.pr.id));

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (ctx, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle + Header
              const SizedBox(height: 12),
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(Icons.add_business_outlined,
                        color: Color(0xFF4F46E5), size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Assign Vendor',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A))),
                          Text(
                            item.itemName,
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF64748B)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Tabs
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: const Color(0xFF4F46E5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF64748B),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Historical Data'),
                    Tab(text: 'New Vendor'),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Tab views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // ── Tab 1: Historical Data ──
                    _buildHistoricalTab(
                        context, item, suggestionsAsync, scrollController),

                    // ── Tab 2: New Vendor ──
                    _buildNewVendorTab(context, scrollController),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
      loading: () => const Center(child: CircularProgressIndicator()),
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
            // Current comparisons
            if (currentComparisons.isNotEmpty) ...[
              const _SectionHeader('Sudah Ditetapkan'),
              const SizedBox(height: 8),
              ...currentComparisons.map((c) => _CurrentComparisonTile(c)),
              const SizedBox(height: 20),
            ],

            // Last vendor suggestion
            if (lastVendor != null) ...[
              const _SectionHeader('Vendor Terakhir Digunakan'),
              const SizedBox(height: 8),
              _HistoricalVendorCard(
                icon: Icons.history,
                supplierName: lastVendor['supplier_name'] ?? 'Tidak Diketahui',
                price: lastVendor['price'] != null
                    ? (lastVendor['price'] as num).toDouble()
                    : null,
                leadTimeDays: lastVendor['lead_time_days'] as int? ?? 7,
                date: lastVendor['last_purchased_at'] as String?,
                accentColor: const Color(0xFF6366F1),
                isSubmitting: _isSubmitting,
                onAssign: (price, leadTime) => _submitAssignment(
                  supplierId: lastVendor['supplier_id'] as int,
                  price: price,
                  leadTimeDays: leadTime,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Cheapest vendor suggestion
            if (cheapestVendor != null) ...[
              const _SectionHeader('Vendor Termurah (Historis)'),
              const SizedBox(height: 8),
              _HistoricalVendorCard(
                icon: Icons.monetization_on_outlined,
                supplierName: cheapestVendor['supplier_name'] ?? 'Tidak Diketahui',
                price: cheapestVendor['price'] != null
                    ? (cheapestVendor['price'] as num).toDouble()
                    : null,
                leadTimeDays: cheapestVendor['lead_time_days'] as int? ?? 7,
                accentColor: const Color(0xFF10B981),
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
              _EmptyState(
                icon: Icons.history_toggle_off_outlined,
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

  Widget _buildNewVendorTab(
      BuildContext context, ScrollController scrollController) {
    if (_selectedSupplier != null) {
      return ListView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Selected Supplier',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.5,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedSupplier = null;
                    _priceController.clear();
                    _leadTimeController.text = '7';
                    _notesController.clear();
                  });
                },
                icon: const Icon(Icons.swap_horiz, size: 16),
                label: const Text('Change'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF4F46E5),
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
          const Divider(color: Color(0xFFE2E8F0)),
          const SizedBox(height: 16),
          Text(
            'Quote details for ${_selectedSupplier!.name}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          // Price field
          TextField(
            controller: _priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Unit Price (IDR) *',
              prefixText: 'Rp ',
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 12),
          // Lead time field
          TextField(
            controller: _leadTimeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Lead Time (days)',
              suffixText: 'days',
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 12),
          // Notes field
          TextField(
            controller: _notesController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Notes (optional)',
              hintText: 'e.g. includes delivery, FOB terms...',
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _submitNewVendor,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.save_outlined, size: 18),
              label: const Text('Save Vendor Assignment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
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
        // Search box
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search supplier by name or code...',
            prefixIcon: const Icon(Icons.search, size: 20),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
          onChanged: (val) {
            _debounce?.cancel();
            _debounce = Timer(const Duration(milliseconds: 500), () {
              if (mounted) setState(() => _searchQuery = val.trim());
            });
          },
        ),
        const SizedBox(height: 12),

        // Supplier list
        suppliersAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text('Error loading suppliers: $e',
              style: const TextStyle(color: Colors.red)),
          data: (suppliers) {
            if (suppliers.isEmpty) {
              return _EmptyState(
                icon: Icons.search_off_outlined,
                title: 'No suppliers found',
                subtitle: 'Try a different search term.',
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${suppliers.length} suppliers found',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF64748B))),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the unit price')),
      );
      return;
    }
    final price = double.tryParse(priceText.replaceAll(',', '.'));
    if (price == null || price < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid price value')),
      );
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
    _priceCtrl = TextEditingController(
        text: widget.price?.toStringAsFixed(0) ?? '');
    _leadTimeCtrl =
        TextEditingController(text: widget.leadTimeDays.toString());
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    _leadTimeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2))
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
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF0F172A)),
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _editing = !_editing),
                child: Text(
                  _editing ? 'Cancel' : 'Edit Price',
                  style: TextStyle(fontSize: 12, color: widget.accentColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (!_editing) ...[
            if (widget.price != null)
              Text(
                formatWithCurrency(widget.price!, 'IDR'),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: widget.accentColor),
              )
            else
              const Text('No price on record',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
            if (widget.date != null) ...[
              const SizedBox(height: 4),
              Text('Last purchased: ${widget.date}',
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF64748B))),
            ],
          ] else ...[
            TextField(
              controller: _priceCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Unit Price (IDR)',
                prefixText: 'Rp ',
                isDense: true,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _leadTimeCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Lead Time (days)',
                suffixText: 'days',
                isDense: true,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.isSubmitting
                  ? null
                  : () {
                      final price = double.tryParse(
                              _priceCtrl.text.replaceAll(',', '.')) ??
                          widget.price ??
                          0.0;
                      final leadTime =
                          int.tryParse(_leadTimeCtrl.text) ?? widget.leadTimeDays;
                      widget.onAssign(price, leadTime);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: widget.isSubmitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text('Quick Assign'),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFEEF2FF) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF4F46E5)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.store_outlined,
                    size: 18,
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
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
                          color: isSelected
                              ? const Color(0xFF4338CA)
                              : const Color(0xFF1E293B),
                        ),
                      ),
                      if (supplier.city != null || supplier.code != null)
                        Text(
                          [supplier.code, supplier.city]
                              .where((x) => x != null)
                              .join(' • '),
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xFF94A3B8)),
                        ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle,
                      size: 20, color: Color(0xFF4F46E5)),
              ],
            ),
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
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline,
              size: 16, color: Color(0xFF16A34A)),
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
              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(color: Color(0x0A0F0F0F), blurRadius: 8, offset: Offset(0, 2)),
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
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
    final iconTextColor = textColor ?? color ?? (warning ? const Color(0xFFF59E0B) : const Color(0xFF64748B));
    
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(value, style: const TextStyle(fontSize: 12, color: Color(0xFF334155))),
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
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Color(0xFF64748B),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(icon, size: 48, color: const Color(0xFFCBD5E1)),
          const SizedBox(height: 12),
          Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF64748B))),
          const SizedBox(height: 6),
          Text(subtitle,
              style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A0F0F0F),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.itemName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    if (item.costCode != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          item.costCode!,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(item.itemCode, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.description_outlined, size: 13, color: Color(0xFF4F46E5)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${pr.code}  •  ${pr.companyName ?? "Unknown"}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4F46E5),
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
                      Icons.calendar_today_outlined,
                      'Requested: ${pr.requestDate}',
                    ),
                    if (pr.approvedBy != null && pr.approvedBy!.isNotEmpty)
                      _buildMetadataIconText(
                        Icons.person_outline,
                        'Approved By: ${pr.approvedBy}',
                      ),
                    if (pr.approvedAt != null && pr.approvedAt!.isNotEmpty)
                      _buildMetadataIconText(
                        Icons.assignment_turned_in_outlined,
                        'Approved At: ${_formatDate(pr.approvedAt!)}',
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Req Qty',
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 11),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item.qtyRequested} ${item.uom}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
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
                              color: Color(0xFF10B981),
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
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.inventory_2_outlined, size: 14, color: Color(0xFF64748B)),
                    const SizedBox(width: 4),
                    Text(
                      'Current Stock: ${item.currentStock} ${item.uom}',
                      style: TextStyle(
                        fontSize: 12,
                        color: item.currentStock < item.qtyRequested
                            ? const Color(0xFFF59E0B)
                            : const Color(0xFF64748B),
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
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Spesifikasi: ${item.dtSpec}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF475569),
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
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Keterangan: ${item.dtNotes}',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                    ),
                  ),
                ],
              ],
            ),
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

  Widget _buildMetadataIconText(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: const Color(0xFF64748B)),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Auto-assignment successful.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error auto-assigning: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isAutoAssigning = false);
    }
  }

  Future<void> _showStrategyDialog() async {
    String selectedStrategy = 'lowest_price';
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Auto-Assign Vendors'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select strategy to automatically find and assign the best vendors based on buying history:',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 16),
                  RadioListTile<String>(
                    title: const Text('Lowest Price'),
                    subtitle: const Text(
                        'Finds vendors with the lowest historical price for these items.'),
                    value: 'lowest_price',
                    groupValue: selectedStrategy,
                    activeColor: const Color(0xFF4F46E5),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedStrategy = val);
                      }
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Last Supplier'),
                    subtitle: const Text(
                        'Selects the supplier from the most recent purchase order.'),
                    value: 'last_supplier',
                    groupValue: selectedStrategy,
                    activeColor: const Color(0xFF4F46E5),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedStrategy = val);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel',
                      style: TextStyle(color: Color(0xFF64748B))),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleAutoAssign(selectedStrategy);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Run Assignment'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.entry.item;
    final pr = widget.entry.pr;
    final suggestionsAsync = ref.watch(prItemSuggestionsProvider(pr.id));

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
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
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
                  style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.description_outlined,
                        size: 16, color: Color(0xFF4F46E5)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${pr.code}  •  ${pr.companyName ?? "Unknown"}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4F46E5),
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
                const Text('Quantity & Stock Information',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A))),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildQtyCard('Requested Qty',
                          '${item.qtyRequested} ${item.uom}',
                          const Color(0xFF0F172A), const Color(0xFFF1F5F9)),
                    ),
                    if (item.approvedQty != null) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQtyCard(
                            'Approved Qty',
                            '${item.approvedQty} ${item.uom}',
                            const Color(0xFF10B981),
                            const Color(0xFFECFDF5)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                _buildQtyCard(
                    'Current Stock',
                    '${item.currentStock} ${item.uom}',
                    item.currentStock < item.qtyRequested
                        ? const Color(0xFFD97706)
                        : const Color(0xFF475569),
                    item.currentStock < item.qtyRequested
                        ? const Color(0xFFFEF3C7)
                        : const Color(0xFFF8FAFC)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Spesifikasi',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A))),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFF1F5F9))),
                  child: Text(
                    (item.dtSpec != null && item.dtSpec!.trim().isNotEmpty)
                        ? item.dtSpec!
                        : '-',
                    style:
                        const TextStyle(fontSize: 13, color: Color(0xFF334155)),
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
                const Text('Keterangan',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A))),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFF1F5F9))),
                  child: Text(
                    (item.dtNotes != null && item.dtNotes!.trim().isNotEmpty)
                        ? item.dtNotes!
                        : '-',
                    style:
                        const TextStyle(fontSize: 13, color: Color(0xFF334155)),
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
                const Text('Last Vendor Details',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A))),
                const SizedBox(height: 16),
                suggestionsAsync.when(
                  data: (suggestions) {
                    final itemData = suggestions.firstWhere(
                      (x) => x['pr_detail_id'] == item.id,
                      orElse: () => null,
                    );
                    final lastVendor = itemData?['suggestions']?['last_vendor'];
                    final cheapestVendor =
                        itemData?['suggestions']?['cheapest'];

                    if (lastVendor == null && cheapestVendor == null) {
                      return const Text(
                        'No purchase history found for this item.',
                        style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                            fontStyle: FontStyle.italic),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (lastVendor != null) ...[
                          _buildHistoryRow(Icons.history, 'Last Vendor',
                              lastVendor['supplier_name'] ?? 'Unknown',
                              price: lastVendor['price'] != null
                                  ? formatWithCurrency(
                                      lastVendor['price'], 'IDR')
                                  : null,
                              date: lastVendor['last_purchased_at'] != null
                                  ? _formatDate(lastVendor['last_purchased_at'])
                                  : null),
                        ],
                        if (lastVendor != null && cheapestVendor != null)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
                          ),
                        if (cheapestVendor != null) ...[
                          _buildHistoryRow(
                              Icons.monetization_on_outlined,
                              'Cheapest Vendor',
                              cheapestVendor['supplier_name'] ?? 'Unknown',
                              price: cheapestVendor['price'] != null
                                  ? formatWithCurrency(
                                      cheapestVendor['price'], 'IDR')
                                  : null),
                        ],
                      ],
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, _) => Text('Error loading history: $err',
                      style: const TextStyle(color: Colors.red, fontSize: 12)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isAutoAssigning ? null : _showStrategyDialog,
              icon: _isAutoAssigning
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.auto_awesome, size: 18),
              label: const Text('Auto-Assign Vendors to this PR'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyCard(
      String label, String val, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration:
          BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(val,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }

  Widget _buildHistoryRow(IconData icon, String label, String supplierName,
      {String? price, String? date}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF4F46E5)),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A))),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(supplierName,
                  style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF1E293B),
                      fontWeight: FontWeight.w600)),
              if (price != null) ...[
                const SizedBox(height: 4),
                Text('Price: $price',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF64748B))),
              ],
              if (date != null) ...[
                const SizedBox(height: 2),
                Text('Purchased at: $date',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF64748B))),
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F0F0F),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
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
                        group.supplierName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    if (allPoCreated)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFA7F3D0)),
                        ),
                        child: const Text(
                          'PO Created',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF059669),
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: const Text(
                          'Awaiting PO',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D4ED8),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Lead time: ${group.leadTimeDays} days',
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.warehouse_outlined, size: 14, color: Color(0xFF4F46E5)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        group.warehouseName,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF475569),
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
                      style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                    ),
                    Text(
                      formatWithCurrency(group.totalPrice, 'IDR'),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4F46E5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GroupedDetailsView extends StatelessWidget {
  final VendorWarehouseGroup group;
  final ScrollController? scrollController;
  final bool isGeneratingPos;
  final VoidCallback onProceedToPO;
  final Function(String url, String number) onDownloadPdf;

  const _GroupedDetailsView({
    required this.group,
    this.scrollController,
    required this.isGeneratingPos,
    required this.onProceedToPO,
    required this.onDownloadPdf,
  });

  @override
  Widget build(BuildContext context) {
    final allPoCreated = group.items.every((entry) => entry.item.status == 'po_created');

    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              // Metadata header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A0F0F0F),
                      blurRadius: 8,
                      offset: Offset(0, 2),
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
                            group.supplierName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: allPoCreated ? const Color(0xFFECFDF5) : const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: allPoCreated ? const Color(0xFFA7F3D0) : const Color(0xFFBFDBFE)),
                          ),
                          child: Text(
                            allPoCreated ? 'PO CREATED' : 'APPROVED',
                            style: TextStyle(
                              color: allPoCreated ? const Color(0xFF059669) : const Color(0xFF1D4ED8),
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
                        const Icon(Icons.warehouse_outlined, size: 14, color: Color(0xFF64748B)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Warehouse: ${group.warehouseName}',
                            style: const TextStyle(fontSize: 13, color: Color(0xFF475569), fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 14, color: Color(0xFF64748B)),
                        const SizedBox(width: 6),
                        Text(
                          'Estimated Lead Time: ${group.leadTimeDays} days',
                          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                    const Divider(height: 24, color: Color(0xFFE2E8F0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Order Value:',
                          style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                        ),
                        Text(
                          formatWithCurrency(group.totalPrice, 'IDR'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4F46E5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Items to be Ordered',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),

              // Items details list
              ...group.items.map((entry) {
                final item = entry.item;
                final pr = entry.pr;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x06000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            Text(
                              formatWithCurrency(entry.subtotal, 'IDR'),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.itemCode,
                              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                            ),
                            Text(
                              'Qty: ${item.approvedQty ?? item.qtyRequested} ${item.uom} @ ${formatWithCurrency(entry.offeredUnitPrice, "IDR")}',
                              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                        const Divider(height: 20, color: Color(0xFFF1F5F9)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.description_outlined, size: 13, color: Color(0xFF4F46E5)),
                                const SizedBox(width: 4),
                                Text(
                                  pr.code,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF4F46E5),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            if (item.status == 'po_created')
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFECFDF5),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item.poNumber != null ? 'PO: ${item.poNumber}' : 'PO Created',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF059669),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (item.dtSpec != null && item.dtSpec!.trim().isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Spesifikasi: ${item.dtSpec}',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF475569), fontStyle: FontStyle.italic),
                          ),
                        ],
                        if (item.dtNotes != null && item.dtNotes!.trim().isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Keterangan: ${item.dtNotes}',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),

              // Generated POs
              if (group.purchaseOrders.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text(
                  'Associated Purchase Orders',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                ...group.purchaseOrders.map((po) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.receipt_long_outlined, color: Color(0xFF4F46E5), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              po.poNumber,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Status: ${po.status.toUpperCase()}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: po.status.toLowerCase() == 'ordered' ? const Color(0xFF059669) : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (po.pdfUrl != null && po.pdfUrl!.isNotEmpty)
                        OutlinedButton.icon(
                          onPressed: () => onDownloadPdf(po.pdfUrl!, po.poNumber),
                          icon: const Icon(Icons.download_outlined, size: 14),
                          label: const Text('PDF'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF4F46E5),
                            side: const BorderSide(color: Color(0xFF4F46E5)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                )),
              ],
            ],
          ),
        ),

        // Sticky Proceed to PO Button
        if (!allPoCreated)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isGeneratingPos ? null : onProceedToPO,
                icon: isGeneratingPos
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.playlist_add_check, size: 18),
                label: const Text('Proceed to PO'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

