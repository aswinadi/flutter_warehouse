import 'package:flutter/material.dart';
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

class _TransferOutScreenState extends ConsumerState<TransferOutScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _activeScrollController = ScrollController();
  final ScrollController _historyScrollController = ScrollController();
  int? _selectedTransferId;
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _activeScrollController.addListener(_onActiveScroll);
    _historyScrollController.addListener(_onHistoryScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kirim ke Cabang (Transfer Out)'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.send), text: 'Pengiriman Aktif'),
            Tab(icon: Icon(Icons.history), text: 'Riwayat Pengiriman'),
          ],
        ),
      ),
      body: Column(
        children: [
          const CompanySwitcher(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActiveTabContent(isWide),
                _buildHistoryTabContent(isWide),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTabContent(bool isWide) {
    final transfersAsync = ref.watch(transfersListProvider(status: 'shipped,draft'));

    if (isWide) {
      return Row(
        children: [
          SizedBox(
            width: 380,
            child: _buildLeftPanel(transfersAsync, _activeScrollController, isWide, showCreateButton: true, statusFilter: 'shipped,draft'),
          ),
          const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE2E8F0)),
          Expanded(
            child: _buildRightPanel(statusFilter: 'shipped,draft'),
          ),
        ],
      );
    } else {
      return _isCreating
          ? _buildMobileCreateForm()
          : _selectedTransferId != null
              ? _buildMobileDetailView()
              : _buildLeftPanel(transfersAsync, _activeScrollController, isWide, showCreateButton: true, statusFilter: 'shipped,draft');
    }
  }

  Widget _buildHistoryTabContent(bool isWide) {
    final transfersAsync = ref.watch(transfersListProvider(status: 'received,cancelled'));

    if (isWide) {
      return Row(
        children: [
          SizedBox(
            width: 380,
            child: _buildLeftPanel(transfersAsync, _historyScrollController, isWide, showCreateButton: false, statusFilter: 'received,cancelled'),
          ),
          const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE2E8F0)),
          Expanded(
            child: _buildRightPanel(statusFilter: 'received,cancelled'),
          ),
        ],
      );
    } else {
      return _selectedTransferId != null
          ? _buildMobileDetailView()
          : _buildLeftPanel(transfersAsync, _historyScrollController, isWide, showCreateButton: false, statusFilter: 'received,cancelled');
    }
  }

  Widget _buildLeftPanel(
    AsyncValue<List<WarehouseTransfer>> transfersAsync,
    ScrollController controller,
    bool isWide, {
    required bool showCreateButton,
    required String statusFilter,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transfers Out',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              if (showCreateButton)
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isCreating = true;
                      _selectedTransferId = null;
                    });
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Kirim Baru'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: transfersAsync.when(
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
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final transfer = transfers[index];
                  final isSelected = transfer.id == _selectedTransferId;

                  Color statusColor;
                  switch (transfer.status.toLowerCase()) {
                    case 'draft':
                      statusColor = Colors.grey;
                      break;
                    case 'shipped':
                      statusColor = const Color(0xFF3B82F6);
                      break;
                    case 'received':
                      statusColor = const Color(0xFF10B981);
                      break;
                    case 'cancelled':
                      statusColor = const Color(0xFFEF4444);
                      break;
                    default:
                      statusColor = Colors.grey;
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected && isWide ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
                        width: isSelected && isWide ? 2.0 : 1.0,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A0F0F0F),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedTransferId = transfer.id;
                            _isCreating = false;
                          });
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
                                  Text(
                                    transfer.transferNumber,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: statusColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: statusColor, width: 0.8),
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
                                  const Icon(Icons.logout, size: 14, color: Colors.red),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Asal: ${transfer.sourceWarehouse?.name ?? "Gudang Asal"}',
                                      style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.login, size: 14, color: Colors.green),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Tujuan: ${transfer.destinationWarehouse?.name ?? "Gudang Tujuan"}',
                                      style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Divider(height: 1, color: Color(0xFFF1F5F9)),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    transfer.transferDate,
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                                  ),
                                  if (transfer.driverName?.isNotEmpty == true)
                                    Row(
                                      children: [
                                        const Icon(Icons.person, size: 12, color: Color(0xFF64748B)),
                                        const SizedBox(width: 2),
                                        Text(
                                          transfer.driverName!,
                                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Gagal: $err')),
          ),
        ),
      ],
    );
  }

  Widget _buildRightPanel({required String statusFilter}) {
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

    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.swap_horiz, size: 64, color: Color(0xFF94A3B8)),
          SizedBox(height: 16),
          Text(
            'Pilih pengiriman di sebelah kiri untuk melihat rincian,\natau klik "Kirim Baru" untuk mengirim barang.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileCreateForm() {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        setState(() {
          _isCreating = false;
        });
      },
      child: _TransferCreateForm(
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
      ),
    );
  }

  Widget _buildMobileDetailView() {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        setState(() {
          _selectedTransferId = null;
        });
      },
      child: _TransferDetailView(
        transferId: _selectedTransferId!,
        onClose: () {
          setState(() {
            _selectedTransferId = null;
          });
        },
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
  final _formKey = GlobalKey<FormState>();
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

    if (selectedCompany == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.business, size: 48, color: Colors.orange),
              const SizedBox(height: 12),
              const Text(
                'Silakan pilih perusahaan terlebih dahulu',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Transfer antar gudang harus berada dalam satu perusahaan.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              TextButton(
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

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: widget.onCancel,
            ),
            title: const Text('Kirim Barang (Transfer Out)'),
            actions: [
              if (_isSubmitting)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    ),
                  ),
                )
              else
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: _submitForm,
                ),
            ],
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informasi Gudang',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Gudang Asal',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          value: _sourceWarehouseId,
                          items: companyWarehouses.map((w) {
                            return DropdownMenuItem<int>(
                              value: w.id,
                              child: Text(w.name),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _sourceWarehouseId = val;
                              _selectedItems.clear(); // Clear items if source changes
                              if (_destWarehouseId == val) {
                                _destWarehouseId = null;
                              }
                            });
                          },
                          validator: (val) => val == null ? 'Gudang asal wajib dipilih' : null,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Gudang Tujuan',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          value: _destWarehouseId,
                          items: companyWarehouses
                              .where((w) => w.id != _sourceWarehouseId)
                              .map((w) {
                            return DropdownMenuItem<int>(
                              value: w.id,
                              child: Text(w.name),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _destWarehouseId = val;
                            });
                          },
                          validator: (val) => val == null ? 'Gudang tujuan wajib dipilih' : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rincian Pengiriman',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _driverController,
                                decoration: const InputDecoration(
                                  labelText: 'Nama Sopir',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _plateController,
                                decoration: const InputDecoration(
                                  labelText: 'Nomor Polisi',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _notesController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'Catatan',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daftar Barang yang Dikirim',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    if (_sourceWarehouseId != null)
                      ElevatedButton.icon(
                        onPressed: () => _openAddItemDialog(context, _sourceWarehouseId!),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Tambah Barang'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                        ),
                      )
                    else
                      const Text(
                        'Pilih gudang asal untuk menambahkan barang',
                        style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_selectedItems.isEmpty)
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Center(
                      child: Text(
                        'Belum ada barang dipilih. Klik "Tambah Barang" untuk menambahkan.',
                        style: TextStyle(color: Colors.grey),
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

                      return Card(
                        margin: EdgeInsets.zero,
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.inventory.productName ?? 'Produk Tidak Dikenal',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'SKU: ${item.inventory.sku}',
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                    Text(
                                      'Stok Tersedia: ${item.inventory.quantity} ${item.inventory.unit ?? "pcs"}',
                                      style: TextStyle(fontSize: 11, color: Colors.blue.shade800),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: 140,
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                      onPressed: () {
                                        if (item.quantity > 1.0) {
                                          setState(() {
                                            _selectedItems[itemKey] = item.copyWith(quantity: item.quantity - 1);
                                          });
                                        }
                                      },
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: item.quantity.toString(),
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (val) {
                                          final q = double.tryParse(val) ?? 0.0;
                                          setState(() {
                                            _selectedItems[itemKey] = item.copyWith(quantity: q);
                                          });
                                        },
                                        validator: (val) {
                                          final q = double.tryParse(val ?? '') ?? 0.0;
                                          if (q <= 0) return 'Wajib';
                                          if (q > item.inventory.quantity) return 'Melebihi';
                                          return null;
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                      onPressed: () {
                                        if (item.quantity < item.inventory.quantity) {
                                          setState(() {
                                            _selectedItems[itemKey] = item.copyWith(quantity: item.quantity + 1);
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _selectedItems.remove(itemKey);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error loading warehouses: $err')),
    );
  }

  void _openAddItemDialog(BuildContext context, int warehouseId) {
    showDialog(
      context: context,
      builder: (ctx) {
        return _AddItemSearchDialog(
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
        );
      },
    );
  }

  Future<void> _submitForm() async {
    if (_isSubmitting) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedItems.isEmpty) {
      _showTopNotification(context, 'Silakan tambahkan minimal satu barang untuk dikirim', isError: true);
      return;
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

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 450,
        height: 500,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pilih Barang dari Stok',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari produk or SKU...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (val) {
                setState(() {
                  _searchQuery = val.trim();
                });
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: stockAsync.when(
                data: (items) {
                  // Filter out zero stock items
                  final availableItems = items.where((item) => item.quantity > 0).toList();

                  if (availableItems.isEmpty) {
                    return const Center(child: Text('Stok barang tidak tersedia'));
                  }

                  return ListView.separated(
                    itemCount: availableItems.length,
                    separatorBuilder: (ctx, i) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = availableItems[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          item.productName ?? 'Produk Tidak Dikenal',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        subtitle: Text('SKU: ${item.sku}'),
                        trailing: Text(
                          '${item.quantity} ${item.unit ?? "pcs"}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        onTap: () => widget.onItemSelect(item),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Gagal: $err')),
              ),
            ),
          ],
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

    return detailAsync.when(
      data: (transfer) {
        Color statusColor;
        switch (transfer.status.toLowerCase()) {
          case 'draft':
            statusColor = Colors.grey;
            break;
          case 'shipped':
            statusColor = const Color(0xFF3B82F6);
            break;
          case 'received':
            statusColor = const Color(0xFF10B981);
            break;
          case 'cancelled':
            statusColor = const Color(0xFFEF4444);
            break;
          default:
            statusColor = Colors.grey;
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onClose,
            ),
            title: Text(transfer.transferNumber),
            actions: [
              if (transfer.pdfUrl != null && transfer.pdfUrl!.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.print),
                  onPressed: () {
                    context.push('/pdf-preview?title=Surat Jalan ${transfer.transferNumber}&url_path=pdf/warehouse-transfer/${transfer.id}');
                  },
                ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Informasi Pengiriman',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: statusColor, width: 0.8),
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
                      _buildDetailRow('Gudang Asal', transfer.sourceWarehouse?.name ?? 'N/A'),
                      _buildDetailRow('Gudang Tujuan', transfer.destinationWarehouse?.name ?? 'N/A'),
                      _buildDetailRow('Nomor DO / Surat Jalan', transfer.doNumber ?? 'N/A'),
                      _buildDetailRow('Tanggal Kirim', transfer.transferDate),
                      if (transfer.driverName?.isNotEmpty == true)
                        _buildDetailRow('Sopir', transfer.driverName!),
                      if (transfer.vehiclePlate?.isNotEmpty == true)
                        _buildDetailRow('Nomor Polisi', transfer.vehiclePlate!),
                      if (transfer.notes?.isNotEmpty == true)
                        _buildDetailRow('Catatan', transfer.notes!),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Barang yang Dikirim',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                    return Card(
                      margin: EdgeInsets.zero,
                      child: ListTile(
                        title: Text(
                          item.product?.name ?? 'Produk Tidak Dikenal',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('SKU: ${item.product?.sku ?? "N/A"}'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Dikirim: ${item.qtySent}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                            ),
                            if (item.qtyReceived != null)
                              Text(
                                'Diterima: ${item.qtyReceived}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error loading detail: $err')),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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
          child: Material(
            color: Colors.transparent,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 250),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - value) * -20),
                    child: child,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isError ? Icons.error_outline : Icons.check_circle_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        if (entry.mounted) {
                          entry.remove();
                        }
                      },
                      child: const Icon(Icons.close, color: Colors.white, size: 18),
                    ),
                  ],
                ),
              ),
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
