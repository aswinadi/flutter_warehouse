import 'package:flutter/cupertino.dart';
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

class _TransferInScreenState extends ConsumerState<TransferInScreen> {
  final ScrollController _shippedScrollController = ScrollController();
  final ScrollController _historyScrollController = ScrollController();

  int? _selectedTransferId;
  int _selectedSegment = 0; // 0 for In Transit, 1 for History

  @override
  void initState() {
    super.initState();
    _shippedScrollController.addListener(_onShippedScroll);
    _historyScrollController.addListener(_onHistoryScroll);
  }

  @override
  void dispose() {
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
                      Icon(CupertinoIcons.bus, size: 16),
                      SizedBox(width: 6),
                      Text('Dalam Perjalanan', style: TextStyle(fontSize: 13)),
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
                      Text('Riwayat Penerimaan', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              },
              onValueChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedSegment = val;
                    _selectedTransferId = null; // Clear selection on tab change
                  });
                }
              },
            ),
          ),
          Expanded(
            child: _selectedSegment == 0
                ? _buildInTransitTabContent(isWide)
                : _buildHistoryTabContent(isWide),
          ),
        ],
      );
    }

    if (!isWide && _selectedTransferId != null) {
      // On mobile, if a transfer is selected, show detail/form full screen with back-gesture interception
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          setState(() {
            _selectedTransferId = null;
          });
        },
        child: CupertinoPageScaffold(
          backgroundColor: bgColor,
          child: _selectedSegment == 0
              ? _TransferReceiveForm(
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
              : _TransferHistoryDetailView(
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
          'Terima dari Cabang (Transfer In)',
          style: TextStyle(color: labelColor),
        ),
      ),
      child: SafeArea(child: buildMainContent()),
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
          Container(
            width: 0.5,
            color: CupertinoColors.separator.resolveFrom(context),
          ),
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
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.tray_arrow_down,
                          size: 64,
                          color: CupertinoColors.placeholderText.resolveFrom(context),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Pilih transfer di sebelah kiri untuk mulai menerima barang',
                          style: TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.secondaryLabel.resolveFrom(context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      );
    } else {
      return _buildTransfersList(transfersAsync, _shippedScrollController, isWide);
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
          Container(
            width: 0.5,
            color: CupertinoColors.separator.resolveFrom(context),
          ),
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
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.doc_text,
                          size: 64,
                          color: CupertinoColors.placeholderText.resolveFrom(context),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Pilih transfer di sebelah kiri untuk melihat riwayat detail',
                          style: TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.secondaryLabel.resolveFrom(context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      );
    } else {
      return _buildTransfersList(transfersAsync, _historyScrollController, isWide);
    }
  }

  Widget _buildTransfersList(
      AsyncValue<List<WarehouseTransfer>> transfersAsync, ScrollController controller, bool isWide) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

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
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: labelColor),
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
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
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
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return detailAsync.when(
      data: (transfer) {
        _initializeValues(transfer);

        return Column(
          children: [
            CupertinoNavigationBar(
              leading: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.xmark),
                onPressed: widget.onCancel,
              ),
              middle: Text(
                'Terima: ${transfer.transferNumber}',
                style: TextStyle(color: labelColor),
              ),
              trailing: _isSubmitting
                  ? const CupertinoActivityIndicator()
                  : CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(CupertinoIcons.checkmark),
                      onPressed: () => _submitReceipt(transfer),
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
                          'Detail Pengiriman',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: labelColor),
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow('Gudang Asal', transfer.sourceWarehouse?.name ?? 'N/A'),
                        const SizedBox(height: 4),
                        _buildDetailRow('Gudang Tujuan', transfer.destinationWarehouse?.name ?? 'N/A'),
                        const SizedBox(height: 4),
                        _buildDetailRow('Sopir', transfer.driverName ?? 'N/A'),
                        const SizedBox(height: 4),
                        _buildDetailRow('Nomor Polisi', transfer.vehiclePlate ?? 'N/A'),
                        const SizedBox(height: 4),
                        _buildDetailRow('Catatan', transfer.notes ?? 'N/A'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Masukkan Jumlah Diterima',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: labelColor),
                  ),
                  const SizedBox(height: 8),
                  if (transfer.items == null || transfer.items!.isEmpty)
                    const Center(child: Text('Tidak ada item untuk diterima.'))
                  else
                    ...transfer.items!.map((item) {
                      final currentQty = _receivedQuantities[item.id] ?? item.qtySent;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: separatorColor, width: 0.5),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product?.name ?? 'Unknown Product',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: labelColor),
                                  ),
                                  Text(
                                    'SKU: ${item.product?.sku ?? "N/A"}',
                                    style: TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Dikirim: ${item.qtySent} ${item.product?.unit ?? "pcs"}',
                                    style: const TextStyle(color: CupertinoColors.activeBlue, fontSize: 12, fontWeight: FontWeight.w600),
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
                                      if (currentQty > 0.0) {
                                        setState(() {
                                          _receivedQuantities[item.id] = currentQty - 1;
                                        });
                                      }
                                    },
                                    child: const Icon(CupertinoIcons.minus_circle, color: CupertinoColors.destructiveRed, size: 22),
                                  ),
                                  Expanded(
                                    child: CupertinoTextField(
                                      controller: TextEditingController(text: currentQty.toStringAsFixed(0))
                                        ..selection = TextSelection.fromPosition(
                                          TextPosition(offset: currentQty.toStringAsFixed(0).length),
                                        ),
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold, color: labelColor),
                                      decoration: null,
                                      onChanged: (val) {
                                        final q = double.tryParse(val) ?? 0.0;
                                        _receivedQuantities[item.id] = q;
                                      },
                                    ),
                                  ),
                                  CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    minSize: 32,
                                    onPressed: () {
                                      setState(() {
                                        _receivedQuantities[item.id] = currentQty + 1;
                                      });
                                    },
                                    child: const Icon(CupertinoIcons.plus_circle, color: CupertinoColors.activeGreen, size: 22),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
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
              style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context), fontSize: 13),
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

  Future<void> _submitReceipt(WarehouseTransfer transfer) async {
    if (_isSubmitting) return;

    // Validate quantites
    for (final e in _receivedQuantities.entries) {
      if (e.value < 0) {
        _showTopNotification(context, 'Jumlah diterima tidak boleh kurang dari 0', isError: true);
        return;
      }
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
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return detailAsync.when(
      data: (transfer) {
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
                              'Informasi Penerimaan',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: labelColor),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: CupertinoColors.activeGreen.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: CupertinoColors.activeGreen, width: 0.5),
                              ),
                              child: Text(
                                transfer.status.toUpperCase(),
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: CupertinoColors.activeGreen),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildDetailRow(context, 'Gudang Asal', transfer.sourceWarehouse?.name ?? 'N/A'),
                        const SizedBox(height: 4),
                        _buildDetailRow(context, 'Gudang Tujuan', transfer.destinationWarehouse?.name ?? 'N/A'),
                        const SizedBox(height: 4),
                        _buildDetailRow(context, 'DO/Surat Jalan', transfer.doNumber ?? 'N/A'),
                        const SizedBox(height: 4),
                        _buildDetailRow(context, 'Tanggal Kirim', transfer.transferDate),
                        const SizedBox(height: 4),
                        if (transfer.driverName?.isNotEmpty == true)
                          _buildDetailRow(context, 'Sopir', transfer.driverName!),
                        const SizedBox(height: 4),
                        if (transfer.vehiclePlate?.isNotEmpty == true)
                          _buildDetailRow(context, 'Nomor Polisi', transfer.vehiclePlate!),
                        const SizedBox(height: 4),
                        if (transfer.receivedAt?.isNotEmpty == true)
                          _buildDetailRow(context, 'Diterima Tanggal', transfer.receivedAt!.split('T').first),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Daftar Item',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: labelColor),
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
                                      item.product?.name ?? 'Unknown Product',
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
                                  Text(
                                    'Diterima: ${item.qtyReceived ?? 0.0}',
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
