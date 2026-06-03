import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:printing/printing.dart';
import 'package:dio/dio.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/config/app_config.dart';
import '../../../core/widgets/company_switcher.dart';
import '../../purchase_order/providers/purchase_order_provider.dart';
import '../providers/receiving_provider.dart';
import '../providers/receiving_repository.dart';
import 'receiving_form_screen.dart';
import 'container_receiving_form_screen.dart';
import 'package:go_router/go_router.dart';

class ReceivingScanScreen extends ConsumerStatefulWidget {
  const ReceivingScanScreen({super.key});

  @override
  ConsumerState<ReceivingScanScreen> createState() => _ReceivingScanScreenState();
}

class _ReceivingScanScreenState extends ConsumerState<ReceivingScanScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _historyScrollController = ScrollController();
  final ScrollController _poScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  bool _isDownloadingPdf = false;
  int? _selectedPoId;
  String _receivingMode = 'vendor'; // 'vendor' or 'container'
  String? _selectedContainerNumber;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _historyScrollController.addListener(_onHistoryScroll);
    _poScrollController.addListener(_onPoScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _historyScrollController.dispose();
    _poScrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onHistoryScroll() {
    if (!_historyScrollController.hasClients) return;
    final maxScroll = _historyScrollController.position.maxScrollExtent;
    final currentScroll = _historyScrollController.position.pixels;
    if (currentScroll >= maxScroll * 0.9) {
      ref.read(receivingsHistoryProvider.notifier).loadMore();
    }
  }

  void _onPoScroll() {
    if (!_poScrollController.hasClients) return;
    final maxScroll = _poScrollController.position.maxScrollExtent;
    final currentScroll = _poScrollController.position.pixels;
    if (currentScroll >= maxScroll * 0.9) {
      ref.read(purchaseOrdersProvider(
        status: 'approved,ordered,partial',
        search: _searchQuery,
      ).notifier).loadMore();
    }
  }

  Future<void> _downloadAndPrintPdf(int receivingId, String receivingNumber) async {
    if (_isDownloadingPdf) return;
    setState(() => _isDownloadingPdf = true);

    bool dialogOpen = true;
    BuildContext? dialogContext;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        dialogContext = ctx;
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Membuat PDF...'),
            ],
          ),
        );
      },
    );

    try {
      final dio = ref.read(dioProvider);
      final pdfUrl = '${AppConfig.baseUrl.replaceAll('/api/v1/', '')}/pdf/receiving/$receivingId';
      final response = await dio.get<List<int>>(
        pdfUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (dialogOpen) {
        dialogOpen = false;
        if (dialogContext != null && dialogContext!.mounted) {
          Navigator.pop(dialogContext!);
        }
      }

      if (response.data != null && response.data!.isNotEmpty) {
        final fileName = 'Receipt_$receivingNumber';
        if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
          final downloadsDir = await getDownloadsDirectory();
          if (downloadsDir != null) {
            final filePath = p.join(downloadsDir.path, '$fileName.pdf');
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
              // ignore opening failure
            }

            if (mounted) {
              _showTopNotification(context, 'PDF berhasil diunduh ke folder Downloads: $fileName.pdf');
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
        }
      }
      if (mounted) {
        _showTopNotification(context, 'Gagal mengunduh PDF: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isDownloadingPdf = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 850;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Penerimaan Barang'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.list_alt), text: 'PO Terbuka / Kontainer'),
            Tab(icon: Icon(Icons.history), text: 'Riwayat'),
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
                _buildOpenPOsTabContent(isWide),
                _buildHistoryTabContent(isWide),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpenPOsTabContent(bool isWide) {
    final leftPanel = _buildOpenPOsTab(isWide);

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 380, child: leftPanel),
          const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE2E8F0)),
          Expanded(
            child: _selectedPoId != null
                ? ReceivingFormScreen(
                    key: ValueKey(_selectedPoId),
                    poId: _selectedPoId!,
                    embed: true,
                    onSubmitSuccess: () {
                      setState(() {
                        _selectedPoId = null;
                      });
                    },
                  )
                : _selectedContainerNumber != null
                    ? ContainerReceivingFormScreen(
                        key: ValueKey(_selectedContainerNumber),
                        containerNumber: _selectedContainerNumber!,
                        embed: true,
                        onSubmitSuccess: () {
                          setState(() {
                            _selectedContainerNumber = null;
                          });
                        },
                      )
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_long_outlined, size: 64, color: Color(0xFF94A3B8)),
                            SizedBox(height: 16),
                            Text(
                              'Pilih Pesanan Pembelian (PO) atau Kontainer untuk mulai menerima barang',
                              style: TextStyle(fontSize: 14, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      );
    } else {
      return leftPanel;
    }
  }

  Widget _buildHistoryTabContent(bool isWide) {
    final historyList = _buildHistoryTab();
    if (isWide) {
      return Center(
        child: SizedBox(
          width: 600,
          child: historyList,
        ),
      );
    } else {
      return historyList;
    }
  }

  Widget _buildOpenPOsTab(bool isWide) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _receivingMode = 'vendor';
                        _searchController.clear();
                        _searchQuery = '';
                        _selectedPoId = null;
                        _selectedContainerNumber = null;
                      });
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _receivingMode == 'vendor' ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: _receivingMode == 'vendor'
                            ? [
                                const BoxShadow(
                                  color: Color(0x0A0F0F0F),
                                  blurRadius: 4,
                                  offset: Offset(0, 1),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.storefront,
                            size: 16,
                            color: _receivingMode == 'vendor' ? const Color(0xFF4F46E5) : const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'PO Vendor',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: _receivingMode == 'vendor' ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _receivingMode = 'container';
                        _searchController.clear();
                        _searchQuery = '';
                        _selectedPoId = null;
                        _selectedContainerNumber = null;
                      });
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _receivingMode == 'container' ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: _receivingMode == 'container'
                            ? [
                                const BoxShadow(
                                  color: Color(0x0A0F0F0F),
                                  blurRadius: 4,
                                  offset: Offset(0, 1),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_shipping_outlined,
                            size: 16,
                            color: _receivingMode == 'container' ? const Color(0xFF4F46E5) : const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Kontainer',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: _receivingMode == 'container' ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: _receivingMode == 'vendor'
                  ? 'Cari nomor PO atau nama pemasok...'
                  : 'Cari nomor kontainer atau nama pemasok...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onChanged: (val) {
              setState(() {
                _searchQuery = val.trim();
              });
            },
          ),
        ),
        Expanded(
          child: _receivingMode == 'vendor' 
              ? _buildVendorPOsList(isWide) 
              : _buildContainersList(isWide),
        ),
      ],
    );
  }

  Widget _buildVendorPOsList(bool isWide) {
    final poAsync = ref.watch(purchaseOrdersProvider(
      status: 'approved,ordered,partial',
      search: _searchQuery,
    ));

    return poAsync.when(
      data: (orders) {
        if (orders.isEmpty) {
          return const Center(child: Text('Tidak ada Pesanan Pembelian (PO) tertunda yang ditemukan'));
        }
        final hasMore = ref.watch(purchaseOrdersProvider(
          status: 'approved,ordered,partial',
          search: _searchQuery,
        ).notifier).hasMore;

        return ListView.separated(
          controller: _poScrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: orders.length + (hasMore ? 1 : 0),
          separatorBuilder: (ctx, i) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == orders.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final po = orders[index];
            final progress = po.totalItems > 0 ? po.receivedItems / po.totalItems : 0.0;
            final isSelected = po.id == _selectedPoId;

            Color statusColor;
            switch (po.status.toLowerCase()) {
              case 'approved':
                statusColor = const Color(0xFF10B981);
                break;
              case 'ordered':
                statusColor = const Color(0xFF3B82F6);
                break;
              case 'partial':
                statusColor = const Color(0xFFF59E0B);
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
                    if (isWide) {
                      setState(() {
                        _selectedPoId = po.id;
                        _selectedContainerNumber = null;
                      });
                    } else {
                      context.push('/receiving/form?po_id=${po.id}');
                    }
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
                              po.poNumber,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: statusColor, width: 0.8),
                              ),
                              child: Text(
                                po.status.toUpperCase(),
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          po.supplierName,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1E293B)),
                        ),
                        const SizedBox(height: 8),
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.warehouse_outlined, size: 14, color: Color(0xFF4F46E5)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                po.warehouseName ?? 'Gudang N/A',
                                style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 6,
                                  backgroundColor: const Color(0xFFE2E8F0),
                                  valueColor: const AlwaysStoppedAnimation(Color(0xFF4F46E5)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${po.receivedItems}/${po.totalItems} barang',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5)),
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

  Widget _buildContainersList(bool isWide) {
    final containersAsync = ref.watch(receivingContainersProvider);

    return containersAsync.when(
      data: (containers) {
        final filtered = containers.where((c) {
          if (c.status.toLowerCase() != 'shipped') return false;
          final query = _searchQuery.toLowerCase();
          return c.containerNumber.toLowerCase().contains(query) ||
              c.supplierName.toLowerCase().contains(query) ||
              (c.destinationWarehouseName ?? '').toLowerCase().contains(query);
        }).toList();

        if (filtered.isEmpty) {
          return const Center(child: Text('Tidak ada kontainer dikirim yang ditemukan'));
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: filtered.length,
          separatorBuilder: (ctx, i) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final container = filtered[index];
            final isSelected = container.containerNumber == _selectedContainerNumber;
            final statusColor = const Color(0xFF3B82F6);

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
                    if (isWide) {
                      setState(() {
                        _selectedContainerNumber = container.containerNumber;
                        _selectedPoId = null;
                      });
                    } else {
                      context.push('/receiving/container-form?container_number=${container.containerNumber}');
                    }
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
                              container.containerNumber,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: statusColor, width: 0.8),
                              ),
                              child: Text(
                                container.status.toUpperCase(),
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          container.supplierName,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1E293B)),
                        ),
                        const SizedBox(height: 8),
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.warehouse_outlined, size: 14, color: Color(0xFF4F46E5)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Tujuan: ${container.destinationWarehouseName ?? "N/A"}',
                                style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (container.plateNumber?.isNotEmpty == true) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.local_shipping_outlined, size: 14, color: Color(0xFF64748B)),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Plat: ${container.plateNumber}',
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                ),
                              ),
                            ],
                          ),
                        ],
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

  void _showDetailDialog(BuildContext context, int receivingId, String receivingNumber) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: FutureBuilder<Map<String, dynamic>>(
                future: ref.read(receivingRepositoryProvider).getReceivingDetail(receivingId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          'Gagal memuat detail: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }

                  final data = snapshot.data;
                  if (data == null) {
                    return const Center(child: Text('Data tidak ditemukan'));
                  }

                  final date = data['transaction_date'] ?? '';
                  final supplier = data['supplier_name'] ?? 'N/A';
                  final notes = data['notes'] ?? '';
                  final truckNumber = data['truck_number'] ?? '';
                  final doNumber = data['delivery_order_number'] ?? '';
                  final items = data['items'] as List? ?? [];

                  return Column(
                    children: [
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 8, bottom: 8),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFCBD5E1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    receivingNumber,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tanggal: $date',
                                    style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                                  ),
                                ],
                              ),
                            ),
                            IconButton.filledTonal(
                              onPressed: () => _downloadAndPrintPdf(receivingId, receivingNumber),
                              icon: const Icon(Icons.print_outlined),
                              style: IconButton.styleFrom(
                                foregroundColor: const Color(0xFF4F46E5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Color(0xFFE2E8F0)),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.all(20),
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: Column(
                                children: [
                                  _buildDetailRow('Pemasok', supplier),
                                  const SizedBox(height: 8),
                                  _buildDetailRow('Surat Jalan (DO)', doNumber.isNotEmpty ? doNumber : '-'),
                                  const SizedBox(height: 8),
                                  _buildDetailRow('Nomor Plat Truk', truckNumber.isNotEmpty ? truckNumber : '-'),
                                  if (notes.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    _buildDetailRow('Catatan', notes),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                               'Barang yang Diterima',
                               style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...items.map((itemObj) {
                              final item = itemObj as Map<String, dynamic>;
                              final productName = item['product_name'] ?? 'Tidak Diketahui';
                              final sku = item['sku'] ?? 'N/A';
                              final qty = double.tryParse(item['quantity']?.toString() ?? '') ?? 0.0;
                              final location = item['location_name'] ?? 'Lokasi Utama';
                              final discrepancyType = item['discrepancy_type'] ?? 'none';
                              final discrepancyQty = double.tryParse(item['discrepancy_qty']?.toString() ?? '') ?? 0.0;
                              final discrepancyNote = item['discrepancy_note'] ?? '';
                              final photoPath = item['photo_path'] as String?;

                              String getDiscrepancyLabel(String type) {
                                switch (type.toLowerCase()) {
                                  case 'damaged':
                                    return 'BARANG RUSAK';
                                  case 'missing':
                                    return 'BARANG KURANG';
                                  case 'wrong':
                                  case 'wrong_item':
                                    return 'BARANG SALAH';
                                  default:
                                    return type.toUpperCase();
                                }
                              }

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'SKU: $sku  •  Lokasi: $location',
                                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Jumlah Diterima:', style: TextStyle(fontSize: 13, color: Color(0xFF475569))),
                                        Text(
                                          '${qty.toStringAsFixed(0)} unit',
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                                        ),
                                      ],
                                    ),
                                    if (discrepancyType != 'none') ...[
                                      const SizedBox(height: 12),
                                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.warning_amber_rounded,
                                            size: 16,
                                            color: discrepancyType == 'missing' ? Colors.orange : Colors.red,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Ketidaksesuaian: ${getDiscrepancyLabel(discrepancyType)}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: discrepancyType == 'missing' ? Colors.orange : Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (discrepancyQty > 0) ...[
                                        const SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text('Jumlah Ketidaksesuaian:', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                                            Text(
                                              '${discrepancyQty.toStringAsFixed(0)} unit',
                                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                            ),
                                          ],
                                        ),
                                      ],
                                      if (discrepancyNote.isNotEmpty) ...[
                                        const SizedBox(height: 6),
                                        Text(
                                          'Catatan: $discrepancyNote',
                                          style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Color(0xFF475569)),
                                        ),
                                      ],
                                      if (photoPath != null && photoPath.isNotEmpty) ...[
                                        const SizedBox(height: 12),
                                        const Text('Foto Pendukung:', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                                        const SizedBox(height: 8),
                                        GestureDetector(
                                          onTap: () {
                                            _showImagePreviewDialog(context, photoPath);
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              '${AppConfig.baseUrl.replaceAll('/api/v1/', '')}/storage/$photoPath',
                                              height: 120,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  height: 120,
                                                  color: const Color(0xFFF1F5F9),
                                                  child: const Center(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(Icons.broken_image_outlined, color: Colors.grey, size: 28),
                                                        SizedBox(height: 4),
                                                        Text('Gagal memuat gambar', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
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
              ),
            );
          },
        );
      },
    );
  }

  void _showImagePreviewDialog(BuildContext context, String photoPath) {
    final imageUrl = '${AppConfig.baseUrl.replaceAll('/api/v1/', '')}/storage/$photoPath';
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: InteractiveViewer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.broken_image, color: Colors.white, size: 48));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B), fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryTab() {
    final historyAsync = ref.watch(receivingsHistoryProvider);

    return historyAsync.when(
      data: (records) {
        if (records.isEmpty) {
          return const Center(child: Text('Tidak ada riwayat penerimaan barang yang ditemukan'));
        }
        final hasMore = ref.watch(receivingsHistoryProvider.notifier).hasMore;

        return ListView.separated(
          controller: _historyScrollController,
          padding: const EdgeInsets.all(16),
          itemCount: records.length + (hasMore ? 1 : 0),
          separatorBuilder: (ctx, i) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == records.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final record = records[index];

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showDetailDialog(context, record.id, record.receivingNumber),
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
                              record.receivingNumber,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                            ),
                            IconButton(
                              icon: const Icon(Icons.print_outlined, size: 20, color: Color(0xFF4F46E5)),
                              onPressed: () => _downloadAndPrintPdf(record.id, record.receivingNumber),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'PO: ${record.poNumber ?? "-"}',
                              style: const TextStyle(fontSize: 13, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                            ),
                            Text(
                              record.receivedAt.split('T').first,
                              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        const SizedBox(height: 8),
                        Text(
                          record.supplierName,
                          style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Gudang: ${record.warehouseName ?? "-"}',
                              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                            Text(
                              '${record.detailsCount} barang',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
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
      error: (err, _) => Center(child: Text('Gagal memuat riwayat: $err')),
    );
  }
}

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
