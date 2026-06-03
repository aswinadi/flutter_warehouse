import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/company_switcher.dart';
import '../models/transfer.dart';
import '../providers/transfer_provider.dart';
import '../providers/transfer_repository.dart';

class TransferInScreen extends ConsumerStatefulWidget {
  const TransferInScreen({super.key});

  @override
  ConsumerState<TransferInScreen> createState() => _TransferInScreenState();
}

class _TransferInScreenState extends ConsumerState<TransferInScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _shippedScrollController = ScrollController();
  final ScrollController _historyScrollController = ScrollController();

  int? _selectedTransferId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _shippedScrollController.addListener(_onShippedScroll);
    _historyScrollController.addListener(_onHistoryScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _shippedScrollController.dispose();
    _historyScrollController.dispose();
    super.dispose();
  }

  void _onShippedScroll() {
    if (!_shippedScrollController.hasClients) return;
    final maxScroll = _shippedScrollController.position.maxScrollExtent;
    final currentScroll = _shippedScrollController.position.pixels;
    if (currentScroll >= maxScroll * 0.9) {
      ref.read(transfersListProvider(status: 'shipped').notifier).loadMore();
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
        title: const Text('Terima dari Cabang (Transfer In)'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.local_shipping), text: 'Dalam Perjalanan'),
            Tab(icon: Icon(Icons.history), text: 'Riwayat Penerimaan'),
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
                _buildInTransitTabContent(isWide),
                _buildHistoryTabContent(isWide),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInTransitTabContent(bool isWide) {
    final transfersAsync = ref.watch(transfersListProvider(status: 'shipped'));

    if (isWide) {
      return Row(
        children: [
          SizedBox(
            width: 380,
            child: _buildTransfersList(transfersAsync, _shippedScrollController, isWide),
          ),
          const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE2E8F0)),
          Expanded(
            child: _selectedTransferId != null
                ? _TransferReceiveForm(
                    key: ValueKey(_selectedTransferId),
                    transferId: _selectedTransferId!,
                    onCancel: () {
                      setState(() {
                        _selectedTransferId = null;
                      });
                    },
                    onSubmitSuccess: () {
                      setState(() {
                        _selectedTransferId = null;
                      });
                      ref.invalidate(transfersListProvider(status: 'shipped'));
                      ref.invalidate(transfersListProvider(status: 'received,cancelled'));
                    },
                  )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 64, color: Color(0xFF94A3B8)),
                        SizedBox(height: 16),
                        Text(
                          'Pilih transfer di sebelah kiri untuk mulai menerima barang',
                          style: TextStyle(fontSize: 14, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      );
    } else {
      return _selectedTransferId != null
          ? WillPopScope(
              onWillPop: () async {
                setState(() {
                  _selectedTransferId = null;
                });
                return false;
              },
              child: _TransferReceiveForm(
                transferId: _selectedTransferId!,
                onCancel: () {
                  setState(() {
                    _selectedTransferId = null;
                  });
                },
                onSubmitSuccess: () {
                  setState(() {
                    _selectedTransferId = null;
                  });
                  ref.invalidate(transfersListProvider(status: 'shipped'));
                  ref.invalidate(transfersListProvider(status: 'received,cancelled'));
                },
              ),
            )
          : _buildTransfersList(transfersAsync, _shippedScrollController, isWide);
    }
  }

  Widget _buildHistoryTabContent(bool isWide) {
    final transfersAsync = ref.watch(transfersListProvider(status: 'received,cancelled'));

    if (isWide) {
      return Row(
        children: [
          SizedBox(
            width: 380,
            child: _buildTransfersList(transfersAsync, _historyScrollController, isWide),
          ),
          const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE2E8F0)),
          Expanded(
            child: _selectedTransferId != null
                ? _TransferHistoryDetailView(
                    key: ValueKey(_selectedTransferId),
                    transferId: _selectedTransferId!,
                    onClose: () {
                      setState(() {
                        _selectedTransferId = null;
                      });
                    },
                  )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long, size: 64, color: Color(0xFF94A3B8)),
                        SizedBox(height: 16),
                        Text(
                          'Pilih transfer di sebelah kiri untuk melihat riwayat detail',
                          style: TextStyle(fontSize: 14, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      );
    } else {
      return _selectedTransferId != null
          ? WillPopScope(
              onWillPop: () async {
                setState(() {
                  _selectedTransferId = null;
                });
                return false;
              },
              child: _TransferHistoryDetailView(
                transferId: _selectedTransferId!,
                onClose: () {
                  setState(() {
                    _selectedTransferId = null;
                  });
                },
              ),
            )
          : _buildTransfersList(transfersAsync, _historyScrollController, isWide);
    }
  }

  Widget _buildTransfersList(AsyncValue<List<WarehouseTransfer>> transfersAsync, ScrollController controller, bool isWide) {
    return transfersAsync.when(
      data: (transfers) {
        if (transfers.isEmpty) {
          return const Center(child: Text('Tidak ada pengiriman ditemukan'));
        }
        final hasMore = ref.watch(transfersListProvider().notifier).hasMore;

        return ListView.separated(
          controller: controller,
          padding: const EdgeInsets.all(16),
          itemCount: transfers.length + (hasMore ? 1 : 0),
          separatorBuilder: (ctx, i) => const SizedBox(height: 12),
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
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: statusColor, width: 0.8),
                              ),
                              child: Text(
                                transfer.status.toUpperCase(),
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
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
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

// ----------------------------------------------------
// TRANSFER RECEIVE FORM
// ----------------------------------------------------
class _TransferReceiveForm extends ConsumerStatefulWidget {
  final int transferId;
  final VoidCallback onCancel;
  final VoidCallback onSubmitSuccess;

  const _TransferReceiveForm({
    super.key,
    required this.transferId,
    required this.onCancel,
    required this.onSubmitSuccess,
  });

  @override
  ConsumerState<_TransferReceiveForm> createState() => _TransferReceiveFormState();
}

class _TransferReceiveFormState extends ConsumerState<_TransferReceiveForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<int, double> _receivedQuantities = {};
  bool _isSubmitting = false;
  bool _initialized = false;

  void _initializeValues(WarehouseTransfer transfer) {
    if (_initialized) return;
    if (transfer.items != null) {
      for (final item in transfer.items!) {
        _receivedQuantities[item.id] = item.qtySent;
      }
    }
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(transferDetailProvider(widget.transferId));

    return detailAsync.when(
      data: (transfer) {
        _initializeValues(transfer);

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: widget.onCancel,
            ),
            title: Text('Terima Barang: ${transfer.transferNumber}'),
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
                  onPressed: () => _submitReceipt(transfer),
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
                          'Detail Pengiriman',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow('Gudang Asal', transfer.sourceWarehouse?.name ?? 'N/A'),
                        _buildDetailRow('Gudang Tujuan', transfer.destinationWarehouse?.name ?? 'N/A'),
                        _buildDetailRow('Sopir', transfer.driverName ?? 'N/A'),
                        _buildDetailRow('Nomor Polisi', transfer.vehiclePlate ?? 'N/A'),
                        _buildDetailRow('Catatan', transfer.notes ?? 'N/A'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Masukkan Jumlah Diterima',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 8),
                if (transfer.items == null || transfer.items!.isEmpty)
                  const Center(child: Text('Tidak ada item untuk diterima.'))
                else
                  ...transfer.items!.map((item) {
                    final currentQty = _receivedQuantities[item.id] ?? item.qtySent;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product?.name ?? 'Unknown Product',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'SKU: ${item.product?.sku ?? "N/A"}',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Dikirim: ${item.qtySent} ${item.product?.unit ?? "pcs"}',
                                    style: TextStyle(color: Colors.blue.shade700, fontSize: 12, fontWeight: FontWeight.w600),
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
                                      if (currentQty > 0.0) {
                                        setState(() {
                                          _receivedQuantities[item.id] = currentQty - 1;
                                        });
                                      }
                                    },
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      key: ValueKey('${item.id}_$currentQty'),
                                      initialValue: currentQty.toString(),
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (val) {
                                        final q = double.tryParse(val) ?? 0.0;
                                        _receivedQuantities[item.id] = q;
                                      },
                                      validator: (val) {
                                        final q = double.tryParse(val ?? '') ?? -1.0;
                                          if (q < 0) return 'Wajib diisi';
                                        return null;
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                    onPressed: () {
                                      setState(() {
                                        _receivedQuantities[item.id] = currentQty + 1;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error loading transfer details: $err')),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
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

  Future<void> _submitReceipt(WarehouseTransfer transfer) async {
    if (_isSubmitting) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final reqItems = _receivedQuantities.entries.map((e) {
        return ReceiveTransferItemRequest(
          transferItemId: e.key,
          qtyReceived: e.value,
        );
      }).toList();

      final request = ReceiveTransferRequest(items: reqItems);

      final repo = ref.read(transferRepositoryProvider);
      await repo.receiveTransfer(widget.transferId, request);

      _showTopNotification(context, 'Transfer diterima dan stok berhasil ditambahkan!');
      widget.onSubmitSuccess();
    } catch (e) {
      _showTopNotification(context, 'Gagal menerima transfer: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}

// ----------------------------------------------------
// TRANSFER HISTORY DETAIL VIEW
// ----------------------------------------------------
class _TransferHistoryDetailView extends ConsumerWidget {
  final int transferId;
  final VoidCallback onClose;

  const _TransferHistoryDetailView({
    super.key,
    required this.transferId,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(transferDetailProvider(transferId));

    return detailAsync.when(
      data: (transfer) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onClose,
            ),
            title: Text(transfer.transferNumber),
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
                            'Informasi Penerimaan',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green, width: 0.8),
                            ),
                            child: Text(
                              transfer.status.toUpperCase(),
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow('Gudang Asal', transfer.sourceWarehouse?.name ?? 'N/A'),
                      _buildDetailRow('Gudang Tujuan', transfer.destinationWarehouse?.name ?? 'N/A'),
                      _buildDetailRow('DO/Surat Jalan', transfer.doNumber ?? 'N/A'),
                      _buildDetailRow('Tanggal Kirim', transfer.transferDate),
                      if (transfer.driverName?.isNotEmpty == true)
                        _buildDetailRow('Sopir', transfer.driverName!),
                      if (transfer.vehiclePlate?.isNotEmpty == true)
                        _buildDetailRow('Nomor Polisi', transfer.vehiclePlate!),
                      if (transfer.receivedAt?.isNotEmpty == true)
                        _buildDetailRow('Diterima Tanggal', transfer.receivedAt!.split('T').first),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Daftar Item',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (transfer.items == null || transfer.items!.isEmpty)
                const Center(child: Text('Tidak ada item.'))
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
                          item.product?.name ?? 'Unknown Product',
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
                            Text(
                              'Diterima: ${item.qtyReceived ?? 0.0}',
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
