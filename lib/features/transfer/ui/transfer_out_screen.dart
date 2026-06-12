import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/company_provider.dart';
import '../../../core/providers/warehouse_provider.dart';
import '../../../core/widgets/company_switcher.dart';
import '../models/transfer.dart';
import '../providers/transfer_provider.dart';
import '../providers/transfer_repository.dart';
import '../../inventory/models/inventory.dart';

class TransferOutScreen extends ConsumerStatefulWidget {
  const TransferOutScreen({super.key});

  @override
  ConsumerState<TransferOutScreen> createState() => _TransferOutScreenState();
}

class _TransferOutScreenState extends ConsumerState<TransferOutScreen> {
  final ScrollController _activeScrollController = ScrollController();
  final ScrollController _historyScrollController = ScrollController();
  int? _selectedTransferId;
  bool _isCreating = false;
  int _selectedSegment = 0; // 0 for Active, 1 for History

  @override
  void initState() {
    super.initState();
    _activeScrollController.addListener(_onActiveScroll);
    _historyScrollController.addListener(_onHistoryScroll);
  }

  @override
  void dispose() {
    _activeScrollController.dispose();
    _historyScrollController.dispose();
    super.dispose();
  }

  void _onActiveScroll() {
    if (!_activeScrollController.hasClients) return;
    final maxScroll = _activeScrollController.position.maxScrollExtent;
    final currentScroll = _activeScrollController.position.pixels;
    if (currentScroll >= maxScroll * 0.9) {
      ref.read(transfersListProvider(status: 'shipped,draft').notifier).loadMore();
    }
  }

  void _onHistoryScroll() {
    if (!_historyScrollController.hasClients) return;
    final maxScroll = _historyScrollController.position.maxScrollExtent;
    final currentScroll = _historyScrollController.position.pixels;
    if (currentScroll >= maxScroll * 0.9) {
      ref.read(transfersListProvider(status: 'received,cancelled').notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final bgColor = CupertinoColors.systemGroupedBackground.resolveFrom(context);
    final navBarBg = CupertinoColors.systemBackground.resolveFrom(context);

    Widget buildMainContent() {
      return Column(
        children: [
          const CompanySwitcher(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: navBarBg,
            child: CupertinoSlidingSegmentedControl<int>(
              groupValue: _selectedSegment,
              children: const {
                0: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.paperplane, size: 16),
                      SizedBox(width: 6),
                      Text('Pengiriman Aktif', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
                1: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.time, size: 16),
                      SizedBox(width: 6),
                      Text('Riwayat Pengiriman', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              },
              onValueChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedSegment = val;
                    _selectedTransferId = null;
                    _isCreating = false;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: _selectedSegment == 0
                ? _buildActiveTabContent(isWide)
                : _buildHistoryTabContent(isWide),
          ),
        ],
      );
    }

    if (!isWide && (_isCreating || _selectedTransferId != null)) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          setState(() {
            _isCreating = false;
            _selectedTransferId = null;
          });
        },
        child: CupertinoPageScaffold(
          backgroundColor: bgColor,
          child: _isCreating
              ? _TransferCreateForm(
                  onCancel: () {
                    setState(() {
                      _isCreating = false;
                    });
                  },
                  onSubmitSuccess: () {
                    setState(() {
                      _isCreating = false;
                    });
                    ref.invalidate(transfersListProvider(status: 'shipped,draft'));
                    ref.invalidate(transfersListProvider(status: 'received,cancelled'));
                  },
                )
              : _TransferDetailView(
                  transferId: _selectedTransferId!,
                  onClose: () {
                    setState(() {
                      _selectedTransferId = null;
                    });
                  },
                ),
        ),
      );
    }

    return CupertinoPageScaffold(
      backgroundColor: bgColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: navBarBg,
        middle: Text(
          'Kirim ke Cabang (Transfer Out)',
          style: TextStyle(color: labelColor),
        ),
      ),
      child: SafeArea(child: buildMainContent()),
    );
  }

  Widget _buildActiveTabContent(bool isWide) {
    final transfersAsync = ref.watch(transfersListProvider(status: 'shipped,draft'));

    if (isWide) {
      return Row(
        children: [
          SizedBox(
            width: 380,
            child: _buildLeftPanel(transfersAsync, _activeScrollController, isWide,
                showCreateButton: true, statusFilter: 'shipped,draft'),
          ),
          Container(
            width: 0.5,
            color: CupertinoColors.separator.resolveFrom(context),
          ),
          Expanded(
            child: _buildRightPanel(statusFilter: 'shipped,draft'),
          ),
        ],
      );
    } else {
      return _buildLeftPanel(transfersAsync, _activeScrollController, isWide,
          showCreateButton: true, statusFilter: 'shipped,draft');
    }
  }

  Widget _buildHistoryTabContent(bool isWide) {
    final transfersAsync = ref.watch(transfersListProvider(status: 'received,cancelled'));

    if (isWide) {
      return Row(
        children: [
          SizedBox(
            width: 380,
            child: _buildLeftPanel(transfersAsync, _historyScrollController, isWide,
                showCreateButton: false, statusFilter: 'received,cancelled'),
          ),
          Container(
            width: 0.5,
            color: CupertinoColors.separator.resolveFrom(context),
          ),
          Expanded(
            child: _buildRightPanel(statusFilter: 'received,cancelled'),
          ),
        ],
      );
    } else {
      return _buildLeftPanel(transfersAsync, _historyScrollController, isWide,
          showCreateButton: false, statusFilter: 'received,cancelled');
    }
  }

  Widget _buildLeftPanel(
    AsyncValue<List<WarehouseTransfer>> transfersAsync,
    ScrollController controller,
    bool isWide, {
    required bool showCreateButton,
    required String statusFilter,
  }) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final navBg = CupertinoColors.systemBackground.resolveFrom(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transfers Out',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: labelColor),
              ),
              if (showCreateButton)
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minSize: 0,
                  color: CupertinoColors.activeBlue.resolveFrom(context),
                  borderRadius: BorderRadius.circular(8),
                  onPressed: () {
                    setState(() {
                      _isCreating = true;
                      _selectedTransferId = null;
                    });
                  },
                  child: const Row(
                    children: [
                      Icon(CupertinoIcons.add, size: 16, color: CupertinoColors.white),
                      SizedBox(width: 4),
                      Text('Kirim Baru', style: TextStyle(fontSize: 12, color: CupertinoColors.white)),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: _buildTransfersListView(transfersAsync, controller, isWide, statusFilter),
        ),
      ],
    );
  }

  Widget _buildTransfersListView(AsyncValue<List<WarehouseTransfer>> transfersAsync,
      ScrollController controller, bool isWide, String statusFilter) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return transfersAsync.when(
      data: (transfers) {
        if (transfers.isEmpty) {
          return const Center(child: Text('No outbound transfers found'));
        }
        final hasMore = ref.watch(transfersListProvider(status: statusFilter).notifier).hasMore;

        return ListView.separated(
          controller: controller,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: transfers.length + (hasMore ? 1 : 0),
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == transfers.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CupertinoActivityIndicator()),
              );
            }

            final transfer = transfers[index];
            final isSelected = transfer.id == _selectedTransferId;

            Color statusColor;
            switch (transfer.status.toLowerCase()) {
              case 'draft':
                statusColor = CupertinoColors.inactiveGray;
                break;
              case 'shipped':
                statusColor = CupertinoColors.activeBlue;
                break;
              case 'received':
                statusColor = CupertinoColors.activeGreen;
                break;
              case 'cancelled':
                statusColor = CupertinoColors.destructiveRed;
                break;
              default:
                statusColor = CupertinoColors.inactiveGray;
            }

            return Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected && isWide
                      ? CupertinoColors.activeBlue.resolveFrom(context)
                      : separatorColor,
                  width: isSelected && isWide ? 2.0 : 0.5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A0F0F0F),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTransferId = transfer.id;
                    _isCreating = false;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            transfer.transferNumber,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: labelColor,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: statusColor, width: 0.5),
                            ),
                            child: Text(
                              transfer.status.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(CupertinoIcons.arrow_up_right, size: 14, color: CupertinoColors.destructiveRed),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Asal: ${transfer.sourceWarehouse?.name ?? "Gudang Asal"}',
                              style: TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(CupertinoIcons.arrow_down_left, size: 14, color: CupertinoColors.activeGreen),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Tujuan: ${transfer.destinationWarehouse?.name ?? "Gudang Tujuan"}',
                              style: TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(height: 0.5, color: separatorColor),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            transfer.transferDate,
                            style: TextStyle(fontSize: 11, color: CupertinoColors.placeholderText.resolveFrom(context)),
                          ),
                          if (transfer.driverName?.isNotEmpty == true)
                            Row(
                              children: [
                                const Icon(CupertinoIcons.person, size: 12, color: CupertinoColors.inactiveGray),
                                const SizedBox(width: 2),
                                Text(
                                  transfer.driverName!,
                                  style: TextStyle(fontSize: 11, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
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
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (err, _) => Center(child: Text('Gagal: $err')),
    );
  }

  Widget _buildRightPanel({required String statusFilter}) {
    final labelColor = CupertinoColors.label.resolveFrom(context);

    if (_isCreating) {
      return _TransferCreateForm(
        onCancel: () {
          setState(() {
            _isCreating = false;
          });
        },
        onSubmitSuccess: () {
          setState(() {
            _isCreating = false;
          });
          ref.invalidate(transfersListProvider(status: 'shipped,draft'));
          ref.invalidate(transfersListProvider(status: 'received,cancelled'));
        },
      );
    }

    if (_selectedTransferId != null) {
      return _TransferDetailView(
        transferId: _selectedTransferId!,
        onClose: () {
          setState(() {
            _selectedTransferId = null;
          });
        },
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.arrow_2_circlepath,
            size: 64,
            color: CupertinoColors.placeholderText.resolveFrom(context),
          ),
          const SizedBox(height: 16),
          Text(
            'Pilih pengiriman di sebelah kiri untuk melihat rincian,\natau klik "Kirim Baru" untuk mengirim barang.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// CREATE TRANSFER FORM
// ----------------------------------------------------
class _TransferCreateForm extends ConsumerStatefulWidget {
  final VoidCallback onCancel;
  final VoidCallback onSubmitSuccess;

  const _TransferCreateForm({
    required this.onCancel,
    required this.onSubmitSuccess,
  });

  @override
  ConsumerState<_TransferCreateForm> createState() => _TransferCreateFormState();
}

class _TransferCreateFormState extends ConsumerState<_TransferCreateForm> {
  final _driverController = TextEditingController();
  final _plateController = TextEditingController();
  final _notesController = TextEditingController();

  int? _sourceWarehouseId;
  int? _destWarehouseId;

  // Selected items: Map of Inventory ID -> Selected Item Details
  final Map<int, _SelectedTransferItem> _selectedItems = {};
  bool _isSubmitting = false;

  @override
  void dispose() {
    _driverController.dispose();
    _plateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCompany = ref.watch(selectedCompanyProvider);
    final warehousesAsync = ref.watch(warehousesProvider);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    if (selectedCompany == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.briefcase, size: 48, color: CupertinoColors.systemOrange),
              const SizedBox(height: 12),
              Text(
                'Silakan pilih perusahaan terlebih dahulu',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: labelColor),
              ),
              const SizedBox(height: 8),
              const Text(
                'Transfer antar gudang harus berada dalam satu perusahaan.',
                textAlign: TextAlign.center,
                style: TextStyle(color: CupertinoColors.inactiveGray),
              ),
              const SizedBox(height: 16),
              CupertinoButton(
                onPressed: widget.onCancel,
                child: const Text('Kembali ke Daftar'),
              )
            ],
          ),
        ),
      );
    }

    return warehousesAsync.when(
      data: (allWarehouses) {
        final companyWarehouses = allWarehouses
            .where((w) => w.companyId == selectedCompany.id && w.isActive)
            .toList();

        return Column(
          children: [
            CupertinoNavigationBar(
              leading: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.xmark),
                onPressed: widget.onCancel,
              ),
              middle: Text(
                'Kirim Barang (Transfer Out)',
                style: TextStyle(color: labelColor),
              ),
              trailing: _isSubmitting
                  ? const CupertinoActivityIndicator()
                  : CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(CupertinoIcons.checkmark),
                      onPressed: _submitForm,
                    ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: separatorColor, width: 0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informasi Gudang',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: labelColor),
                        ),
                        const SizedBox(height: 12),
                        Text('Gudang Asal *', style: TextStyle(fontSize: 12, color: labelColor)),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () {
                            showCupertinoModalPopup<int>(
                              context: context,
                              builder: (context) => CupertinoActionSheet(
                                title: const Text('Pilih Gudang Asal'),
                                actions: companyWarehouses.map((w) {
                                  return CupertinoActionSheetAction(
                                    onPressed: () => Navigator.pop(context, w.id),
                                    child: Text(w.name),
                                  );
                                }).toList(),
                                cancelButton: CupertinoActionSheetAction(
                                  isDefaultAction: true,
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Batal'),
                                ),
                              ),
                            ).then((val) {
                              if (val != null) {
                                setState(() {
                                  _sourceWarehouseId = val;
                                  _selectedItems.clear(); // Clear items if source changes
                                  if (_destWarehouseId == val) {
                                    _destWarehouseId = null;
                                  }
                                });
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: separatorColor, width: 0.5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _sourceWarehouseId != null
                                      ? companyWarehouses.firstWhere((w) => w.id == _sourceWarehouseId).name
                                      : 'Pilih Gudang Asal',
                                  style: TextStyle(
                                    color: _sourceWarehouseId != null ? labelColor : CupertinoColors.placeholderText.resolveFrom(context),
                                    fontSize: 14,
                                  ),
                                ),
                                const Icon(CupertinoIcons.chevron_down, size: 14, color: CupertinoColors.inactiveGray),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text('Gudang Tujuan *', style: TextStyle(fontSize: 12, color: labelColor)),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () {
                            showCupertinoModalPopup<int>(
                              context: context,
                              builder: (context) => CupertinoActionSheet(
                                title: const Text('Pilih Gudang Tujuan'),
                                actions: companyWarehouses
                                    .where((w) => w.id != _sourceWarehouseId)
                                    .map((w) {
                                  return CupertinoActionSheetAction(
                                    onPressed: () => Navigator.pop(context, w.id),
                                    child: Text(w.name),
                                  );
                                }).toList(),
                                cancelButton: CupertinoActionSheetAction(
                                  isDefaultAction: true,
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Batal'),
                                ),
                              ),
                            ).then((val) {
                              if (val != null) {
                                setState(() {
                                  _destWarehouseId = val;
                                });
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: separatorColor, width: 0.5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _destWarehouseId != null
                                      ? companyWarehouses.firstWhere((w) => w.id == _destWarehouseId).name
                                      : 'Pilih Gudang Tujuan',
                                  style: TextStyle(
                                    color: _destWarehouseId != null ? labelColor : CupertinoColors.placeholderText.resolveFrom(context),
                                    fontSize: 14,
                                  ),
                                ),
                                const Icon(CupertinoIcons.chevron_down, size: 14, color: CupertinoColors.inactiveGray),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: separatorColor, width: 0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rincian Pengiriman',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: labelColor),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nama Sopir', style: TextStyle(fontSize: 12, color: labelColor)),
                                  const SizedBox(height: 6),
                                  CupertinoTextField(
                                    controller: _driverController,
                                    placeholder: 'Nama Sopir',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nomor Polisi', style: TextStyle(fontSize: 12, color: labelColor)),
                                  const SizedBox(height: 6),
                                  CupertinoTextField(
                                    controller: _plateController,
                                    placeholder: 'B 1234 CD',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text('Catatan', style: TextStyle(fontSize: 12, color: labelColor)),
                        const SizedBox(height: 6),
                        CupertinoTextField(
                          controller: _notesController,
                          maxLines: 2,
                          placeholder: 'Catatan pengiriman...',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Daftar Barang yang Dikirim',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: labelColor),
                      ),
                      if (_sourceWarehouseId != null)
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: CupertinoColors.activeBlue.resolveFrom(context), width: 0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CupertinoButton(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minSize: 0,
                            onPressed: () => _openAddItemDialog(context, _sourceWarehouseId!),
                            child: const Row(
                              children: [
                                Icon(CupertinoIcons.add, size: 14),
                                SizedBox(width: 4),
                                Text('Tambah Barang', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        )
                      else
                        const Text(
                          'Pilih gudang asal untuk menambahkan barang',
                          style: TextStyle(fontSize: 12, color: CupertinoColors.inactiveGray, fontStyle: FontStyle.italic),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_selectedItems.isEmpty)
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: separatorColor, width: 0.5),
                      ),
                      child: const Center(
                        child: Text(
                          'Belum ada barang dipilih. Klik "Tambah Barang" untuk menambahkan.',
                          style: TextStyle(color: CupertinoColors.inactiveGray),
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _selectedItems.length,
                      separatorBuilder: (ctx, i) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final itemKey = _selectedItems.keys.elementAt(index);
                        final item = _selectedItems[itemKey]!;

                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: separatorColor, width: 0.5),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.inventory.productName ?? 'Produk Tidak Dikenal',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: labelColor),
                                    ),
                                    Text(
                                      'SKU: ${item.inventory.sku}',
                                      style: TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                                    ),
                                    Text(
                                      'Stok Tersedia: ${item.inventory.quantity} ${item.inventory.unit ?? "pcs"}',
                                      style: const TextStyle(fontSize: 11, color: CupertinoColors.activeBlue),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: 140,
                                child: Row(
                                  children: [
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      minSize: 32,
                                      onPressed: () {
                                        if (item.quantity > 1.0) {
                                          setState(() {
                                            _selectedItems[itemKey] = item.copyWith(quantity: item.quantity - 1);
                                          });
                                        }
                                      },
                                      child: const Icon(CupertinoIcons.minus_circle, color: CupertinoColors.destructiveRed, size: 22),
                                    ),
                                    Expanded(
                                      child: CupertinoTextField(
                                        controller: TextEditingController(text: item.quantity.toStringAsFixed(0))
                                          ..selection = TextSelection.fromPosition(
                                            TextPosition(offset: item.quantity.toStringAsFixed(0).length),
                                          ),
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontWeight: FontWeight.bold, color: labelColor),
                                        decoration: null,
                                        onChanged: (val) {
                                          final q = double.tryParse(val) ?? 0.0;
                                          setState(() {
                                            _selectedItems[itemKey] = item.copyWith(quantity: q);
                                          });
                                        },
                                      ),
                                    ),
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      minSize: 32,
                                      onPressed: () {
                                        if (item.quantity < item.inventory.quantity) {
                                          setState(() {
                                            _selectedItems[itemKey] = item.copyWith(quantity: item.quantity + 1);
                                          });
                                        }
                                      },
                                      child: const Icon(CupertinoIcons.plus_circle, color: CupertinoColors.activeGreen, size: 22),
                                    ),
                                  ],
                                ),
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                minSize: 0,
                                onPressed: () {
                                  setState(() {
                                    _selectedItems.remove(itemKey);
                                  });
                                },
                                child: const Icon(CupertinoIcons.trash, color: CupertinoColors.destructiveRed, size: 20),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (err, _) => Center(child: Text('Error loading warehouses: $err')),
    );
  }

  void _openAddItemDialog(BuildContext context, int warehouseId) {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: _AddItemSearchDialog(
          warehouseId: warehouseId,
          onItemSelect: (inventory) {
            setState(() {
              if (_selectedItems.containsKey(inventory.id)) {
                final cur = _selectedItems[inventory.id]!;
                if (cur.quantity < inventory.quantity) {
                  _selectedItems[inventory.id] = cur.copyWith(quantity: cur.quantity + 1.0);
                }
              } else {
                _selectedItems[inventory.id] = _SelectedTransferItem(
                  inventory: inventory,
                  quantity: 1.0,
                );
              }
            });
            Navigator.pop(ctx);
          },
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_isSubmitting) return;

    if (_sourceWarehouseId == null) {
      _showTopNotification(context, 'Gudang asal wajib dipilih', isError: true);
      return;
    }
    if (_destWarehouseId == null) {
      _showTopNotification(context, 'Gudang tujuan wajib dipilih', isError: true);
      return;
    }

    if (_selectedItems.isEmpty) {
      _showTopNotification(context, 'Silakan tambahkan minimal satu barang untuk dikirim', isError: true);
      return;
    }

    // Validate quantities
    for (final e in _selectedItems.entries) {
      if (e.value.quantity <= 0) {
        _showTopNotification(context, 'Jumlah barang ${e.value.inventory.productName} harus lebih dari 0', isError: true);
        return;
      }
      if (e.value.quantity > e.value.inventory.quantity) {
        _showTopNotification(context, 'Jumlah barang ${e.value.inventory.productName} melebihi stok tersedia', isError: true);
        return;
      }
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final reqItems = _selectedItems.entries.map((e) {
        return CreateTransferItemRequest(
          inventoryId: e.key,
          quantity: e.value.quantity,
        );
      }).toList();

      final request = CreateTransferRequest(
        destinationWarehouseId: _destWarehouseId!,
        driverName: _driverController.text.trim().isNotEmpty ? _driverController.text.trim() : null,
        vehiclePlate: _plateController.text.trim().isNotEmpty ? _plateController.text.trim() : null,
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
        items: reqItems,
      );

      final repo = ref.read(transferRepositoryProvider);
      await repo.shipTransfer(request);

      _showTopNotification(context, 'Pengiriman keluar berhasil dibuat dan stok dipindahkan!');
      widget.onSubmitSuccess();
    } catch (e) {
      _showTopNotification(context, 'Gagal melakukan pengiriman transfer: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}

class _SelectedTransferItem {
  final Inventory inventory;
  final double quantity;

  _SelectedTransferItem({
    required this.inventory,
    required this.quantity,
  });

  _SelectedTransferItem copyWith({
    Inventory? inventory,
    double? quantity,
  }) {
    return _SelectedTransferItem(
      inventory: inventory ?? this.inventory,
      quantity: quantity ?? this.quantity,
    );
  }
}

// ----------------------------------------------------
// ADD ITEM SEARCH DIALOG
// ----------------------------------------------------
class _AddItemSearchDialog extends ConsumerStatefulWidget {
  final int warehouseId;
  final ValueChanged<Inventory> onItemSelect;

  const _AddItemSearchDialog({
    required this.warehouseId,
    required this.onItemSelect,
  });

  @override
  ConsumerState<_AddItemSearchDialog> createState() => _AddItemSearchDialogState();
}

class _AddItemSearchDialogState extends ConsumerState<_AddItemSearchDialog> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stockAsync = ref.watch(warehouseInventoryProvider(
      warehouseId: widget.warehouseId,
      search: _searchQuery.isEmpty ? null : _searchQuery,
    ));
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Pilih Barang dari Stok'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Tutup'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CupertinoSearchTextField(
                controller: _searchController,
                placeholder: 'Cari produk atau SKU...',
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.trim();
                  });
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: stockAsync.when(
                  data: (items) {
                    final availableItems = items.where((item) => item.quantity > 0).toList();

                    if (availableItems.isEmpty) {
                      return const Center(child: Text('Stok barang tidak tersedia'));
                    }

                    return ListView.separated(
                      itemCount: availableItems.length,
                      separatorBuilder: (ctx, i) => Container(height: 0.5, color: separatorColor),
                      itemBuilder: (context, index) {
                        final item = availableItems[index];
                        return GestureDetector(
                          onTap: () => widget.onItemSelect(item),
                          child: Container(
                            color: cardBg,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.productName ?? 'Produk Tidak Dikenal',
                                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: labelColor),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'SKU: ${item.sku}',
                                        style: TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${item.quantity} ${item.unit ?? "pcs"}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.activeBlue),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CupertinoActivityIndicator()),
                  error: (err, _) => Center(child: Text('Gagal: $err')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// TRANSFER DETAIL VIEW
// ----------------------------------------------------
class _TransferDetailView extends ConsumerWidget {
  final int transferId;
  final VoidCallback onClose;

  const _TransferDetailView({
    required this.transferId,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(transferDetailProvider(transferId));
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return detailAsync.when(
      data: (transfer) {
        Color statusColor;
        switch (transfer.status.toLowerCase()) {
          case 'draft':
            statusColor = CupertinoColors.inactiveGray;
            break;
          case 'shipped':
            statusColor = CupertinoColors.activeBlue;
            break;
          case 'received':
            statusColor = CupertinoColors.activeGreen;
            break;
          case 'cancelled':
            statusColor = CupertinoColors.destructiveRed;
            break;
          default:
            statusColor = CupertinoColors.inactiveGray;
        }

        return Column(
          children: [
            CupertinoNavigationBar(
              leading: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.back),
                onPressed: onClose,
              ),
              middle: Text(
                transfer.transferNumber,
                style: TextStyle(color: labelColor),
              ),
              trailing: (transfer.pdfUrl != null && transfer.pdfUrl!.isNotEmpty)
                  ? CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(CupertinoIcons.printer),
                      onPressed: () {
                        context.push('/pdf-preview?title=Surat Jalan ${transfer.transferNumber}&url_path=pdf/warehouse-transfer/${transfer.id}');
                      },
                    )
                  : null,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: separatorColor, width: 0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Informasi Pengiriman',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: labelColor),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: statusColor, width: 0.5),
                              ),
                              child: Text(
                                transfer.status.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(context, 'Gudang Asal', transfer.sourceWarehouse?.name ?? 'N/A'),
                        const SizedBox(height: 4),
                        _buildDetailRow(context, 'Gudang Tujuan', transfer.destinationWarehouse?.name ?? 'N/A'),
                        const SizedBox(height: 4),
                        _buildDetailRow(context, 'Nomor DO / Surat Jalan', transfer.doNumber ?? 'N/A'),
                        const SizedBox(height: 4),
                        _buildDetailRow(context, 'Tanggal Kirim', transfer.transferDate),
                        const SizedBox(height: 4),
                        if (transfer.driverName?.isNotEmpty == true)
                          _buildDetailRow(context, 'Sopir', transfer.driverName!),
                        const SizedBox(height: 4),
                        if (transfer.vehiclePlate?.isNotEmpty == true)
                          _buildDetailRow(context, 'Nomor Polisi', transfer.vehiclePlate!),
                        const SizedBox(height: 4),
                        if (transfer.notes?.isNotEmpty == true)
                          _buildDetailRow(context, 'Catatan', transfer.notes!),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Barang yang Dikirim',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: labelColor),
                  ),
                  const SizedBox(height: 8),
                  if (transfer.items == null || transfer.items!.isEmpty)
                    const Center(child: Text('Tidak ada barang dalam pengiriman ini'))
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: transfer.items!.length,
                      separatorBuilder: (ctx, i) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = transfer.items![index];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: separatorColor, width: 0.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product?.name ?? 'Produk Tidak Dikenal',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: labelColor),
                                    ),
                                    Text(
                                      'SKU: ${item.product?.sku ?? "N/A"}',
                                      style: TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Dikirim: ${item.qtySent}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.activeBlue),
                                  ),
                                  if (item.qtyReceived != null)
                                    Text(
                                      'Diterima: ${item.qtyReceived}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.activeGreen),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (err, _) => Center(child: Text('Error loading detail: $err')),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context), fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: CupertinoColors.label.resolveFrom(context)),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// TOP NOTIFICATION OVERLAY (HELPER)
// ----------------------------------------------------
void _showTopNotification(BuildContext context, String message, {bool isError = false}) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 24,
      left: 24,
      right: 24,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isError ? CupertinoColors.destructiveRed : CupertinoColors.activeGreen,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x42000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isError ? CupertinoIcons.exclamationmark_circle : CupertinoIcons.check_mark_circled,
                  color: CupertinoColors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    if (entry.mounted) {
                      entry.remove();
                    }
                  },
                  child: const Icon(CupertinoIcons.xmark, color: CupertinoColors.white, size: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);

  Future.delayed(const Duration(milliseconds: 2500), () {
    if (entry.mounted) {
      entry.remove();
    }
  });
}
