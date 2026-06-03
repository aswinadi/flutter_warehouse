import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:printing/printing.dart';
import '../providers/packing_list_provider.dart';
import '../models/packing_list.dart';
import 'package:dio/dio.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/widgets/company_switcher.dart';
import '../../../core/providers/warehouse_provider.dart';
import '../../../core/models/warehouse.dart';
import '../../../core/providers/company_provider.dart';
import '../../../core/config/app_config.dart';

// Enables drag scrolling for web
class _WebScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class PackingListScreen extends ConsumerStatefulWidget {
  const PackingListScreen({super.key});

  @override
  ConsumerState<PackingListScreen> createState() => _PackingListScreenState();
}

class _PackingListScreenState extends ConsumerState<PackingListScreen> {
  String? _selectedStatus = 'loading';
  int? _selectedId;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isDownloadingPdf = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll * 0.9) {
      ref.read(packingListsProvider(
        status: _selectedStatus,
        search: _searchQuery,
      ).notifier).loadMore();
    }
  }

  Future<void> _downloadAndPrintPdf(int containerId, String containerNumber) async {
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
      final pdfUrl = '${AppConfig.baseUrl.replaceAll('/api/v1/', '')}/pdf/containers/$containerId/packing-list';
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
        final fileName = 'PackingList_$containerNumber';
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
            throw Exception('Folder Downloads tidak ditemukan');
          }
        } else {
          await Printing.layoutPdf(
            name: fileName,
            onLayout: (format) async => Uint8List.fromList(response.data!),
          );
        }
      } else {
        throw Exception('Respon PDF kosong');
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

  void _showCreateContainerDialog(BuildContext context, bool isWide) async {
    final newId = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _CreateContainerDialog(),
    );

    if (newId != null && mounted) {
      setState(() {
        _selectedStatus = 'loading';
        _selectedId = newId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(packingListsProvider(
      status: _selectedStatus,
      search: _searchQuery,
    ));
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Packing / Kontainer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateContainerDialog(context, isWide),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _selectedId = null;
              });
              ref.invalidate(packingListsProvider);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const CompanySwitcher(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari kontainer atau nomor plat...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                            _selectedId = null;
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
                  _selectedId = null;
                });
              },
            ),
          ),
          SizedBox(
            height: 48,
            child: ScrollConfiguration(
              behavior: _WebScrollBehavior(),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    _buildFilterChip('Pemuatan', 'loading'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Ditutup', 'closed'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Dikirim', 'shipped'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Tiba', 'arrived'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Semua Status', null),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: listAsync.when(
              data: (containers) {
                if (containers.isEmpty) {
                  return const Center(child: Text('Tidak ada Daftar Packing yang ditemukan'));
                }

                if (isWide && (_selectedId == null || !containers.any((x) => x.id == _selectedId))) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && containers.isNotEmpty) {
                      setState(() {
                        _selectedId = containers.first.id;
                      });
                    }
                  });
                }

                final mainList = ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: containers.length + (ref.watch(packingListsProvider(status: _selectedStatus, search: _searchQuery).notifier).hasMore ? 1 : 0),
                  separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == containers.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final container = containers[index];
                    final isSelected = container.id == _selectedId;

                    return _ContainerCard(
                      container: container,
                      isSelected: isSelected,
                      onTap: () {
                        if (isWide) {
                          setState(() => _selectedId = container.id);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Scaffold(
                                appBar: AppBar(title: Text('Kontainer ${container.containerNumber}')),
                                body: _ContainerDetailView(
                                  containerId: container.id,
                                  onDownloadPdf: (id, number) => _downloadAndPrintPdf(id, number),
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
                      SizedBox(width: 360, child: mainList),
                      const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                      Expanded(
                        child: _selectedId != null
                            ? _ContainerDetailView(
                                containerId: _selectedId!,
                                onDownloadPdf: (id, number) => _downloadAndPrintPdf(id, number),
                              )
                            : const Center(child: Text('Pilih Daftar Packing untuk melihat detail')),
                      ),
                    ],
                  );
                } else {
                  return mainList;
                }
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? value) {
    final isSelected = _selectedStatus == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedStatus = selected ? value : null;
          _selectedId = null;
        });
      },
    );
  }
}

class _ContainerCard extends StatelessWidget {
  final PackingList container;
  final bool isSelected;
  final VoidCallback onTap;

  const _ContainerCard({
    required this.container,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (container.status.toLowerCase()) {
      case 'draft':
      case 'planned':
      case 'loading':
        statusColor = const Color(0xFF64748B);
        break;
      case 'shipped':
        statusColor = const Color(0xFFF59E0B);
        break;
      case 'arrived':
        statusColor = const Color(0xFF10B981);
        break;
      case 'closed':
        statusColor = const Color(0xFF8B5CF6);
        break;
      default:
        statusColor = Colors.grey;
    }

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
            color: Color(0x0A0F0F0F),
            blurRadius: 8,
            offset: Offset(0, 2),
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
                Builder(
                  builder: (context) {
                    final carrier = (container.carrierName != null && container.carrierName!.trim().isNotEmpty)
                        ? container.carrierName!.trim()
                        : '-';
                    final plate = (container.plateNumber != null && container.plateNumber!.trim().isNotEmpty)
                        ? container.plateNumber!.trim()
                        : '-';
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Carrier: $carrier • Plat: $plate',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                    );
                  }
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
                        '${container.sourceWarehouseName ?? "N/A"} ➔ ${container.destinationWarehouseName ?? "N/A"}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ETD: ${container.estimatedDeparture != null ? "${container.estimatedDeparture!.day.toString().padLeft(2, '0')}/${container.estimatedDeparture!.month.toString().padLeft(2, '0')}/${container.estimatedDeparture!.year}" : "-"}',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                    Text(
                      'Close: ${container.closingDate != null ? "${container.closingDate!.day.toString().padLeft(2, '0')}/${container.closingDate!.month.toString().padLeft(2, '0')}/${container.closingDate!.year}" : "-"}',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${container.itemCount} item',
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
  }
}

class _ContainerDetailView extends ConsumerWidget {
  final int containerId;
  final Function(int, String) onDownloadPdf;

  const _ContainerDetailView({
    required this.containerId,
    required this.onDownloadPdf,
  });

  Future<void> _updateContainerStatus(BuildContext context, WidgetRef ref, int id, String status) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(status == 'shipped' ? 'Kirim Kontainer' : 'Tutup Kontainer'),
        content: Text(status == 'shipped'
            ? 'Apakah Anda yakin ingin menandai kontainer ini sebagai dikirim?'
            : 'Apakah Anda yakin ingin menutup daftar packing ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: status == 'shipped' 
                ? const Color(0xFF4F46E5) 
                : status == 'arrived' 
                  ? const Color(0xFF10B981)
                  : const Color(0xFF0F172A),
              foregroundColor: Colors.white,
            ),
            child: const Text('Konfirmasi'),
          ),
        ],
      ),
    );

    if (result != true) return;

    try {
      final repo = ref.read(packingListRepositoryProvider);
      await repo.updateStatus(id, status);
      
      ref.invalidate(packingListDetailProvider(id));
      ref.invalidate(packingListsProvider);

      if (context.mounted) {
        _showTopNotification(context, 'Status kontainer berhasil diperbarui ke $status!');
      }
    } catch (e) {
      if (context.mounted) {
        _showTopNotification(context, 'Gagal memperbarui status kontainer: $e', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(packingListDetailProvider(containerId));

    return detailAsync.when(
      data: (container) {
        final isEditable = !['shipped', 'arrived', 'closed'].contains(container.status.toLowerCase());

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Kontainer: ${container.containerNumber}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => onDownloadPdf(container.id, container.containerNumber),
                              icon: const Icon(Icons.print_outlined, size: 16),
                              label: const Text('Unduh PDF'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF4F46E5),
                                side: const BorderSide(color: Color(0xFF4F46E5)),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            'Carrier: ${container.carrierName ?? "-"} • Plat Nomor: ${container.plateNumber ?? "-"}',
                            style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
                          ),
                        ),
                        const Divider(height: 24, color: Color(0xFFE2E8F0)),
                        _buildDetailRow('Gudang Sumber', container.sourceWarehouseName ?? 'N/A'),
                        const SizedBox(height: 6),
                        _buildDetailRow('Gudang Tujuan', container.destinationWarehouseName ?? 'N/A'),
                        const SizedBox(height: 6),
                        _buildDetailRow(
                          'Estimasi Keberangkatan',
                          container.estimatedDeparture != null
                              ? "${container.estimatedDeparture!.day.toString().padLeft(2, '0')}/${container.estimatedDeparture!.month.toString().padLeft(2, '0')}/${container.estimatedDeparture!.year} ${container.estimatedDeparture!.hour.toString().padLeft(2, '0')}:${container.estimatedDeparture!.minute.toString().padLeft(2, '0')}"
                              : '-',
                        ),
                        const SizedBox(height: 6),
                        _buildDetailRow(
                          'Tanggal Penutupan',
                          container.closingDate != null
                              ? "${container.closingDate!.day.toString().padLeft(2, '0')}/${container.closingDate!.month.toString().padLeft(2, '0')}/${container.closingDate!.year} ${container.closingDate!.hour.toString().padLeft(2, '0')}:${container.closingDate!.minute.toString().padLeft(2, '0')}"
                              : '-',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isEditable) ...[
                          const Text('Detail Segel & Tindakan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF475569))),
                          const SizedBox(height: 8),
                          if (container.status.toLowerCase() == 'loading' || 
                              container.status.toLowerCase() == 'planned' || 
                              container.status.toLowerCase() == 'closed') ...[
                            Row(
                              children: [
                                if (container.status.toLowerCase() == 'loading' || container.status.toLowerCase() == 'planned')
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => _updateContainerStatus(context, ref, container.id, 'closed'),
                                      icon: const Icon(Icons.lock_outline, size: 16),
                                      label: const Text('Tutup Daftar Packing'),
                                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A), foregroundColor: Colors.white),
                                    ),
                                  ),
                                if (container.status.toLowerCase() == 'closed')
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => _updateContainerStatus(context, ref, container.id, 'shipped'),
                                      icon: const Icon(Icons.local_shipping_outlined, size: 16),
                                      label: const Text('Kirim / Keberangkatan'),
                                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4F46E5), foregroundColor: Colors.white),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ],
                        const Text('Barang Manifest', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF475569))),
                        const SizedBox(height: 8),
                        if (isEditable)
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => _showEditManifestDialog(context, ref, container),
                              icon: const Icon(Icons.edit_note, size: 18),
                              label: const Text('Edit Manifest'),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (container.items.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Center(
                        child: Text(
                          'Belum ada barang di manifest daftar packing ini.',
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                        ),
                      ),
                    )
                  else
                    ...container.items.map((item) => _ManifestItemCard(item: item)),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Gagal memuat detail: $err')),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A), fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  void _showEditManifestDialog(BuildContext context, WidgetRef ref, PackingList container) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditManifestSheet(container: container),
    );
  }
}

class _ManifestItemCard extends StatelessWidget {
  final PackingListItem item;

  const _ManifestItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isPo = item.type == 'po';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.productName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                ),
              ),
              Text(
                '${item.plannedQty} ${item.unit}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF4F46E5)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SKU: ${item.sku}',
                style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
              Text(
                isPo ? 'Ref: ${item.poNumber}' : 'Ref: Stok Internal',
                style: TextStyle(
                  fontSize: 11,
                  color: isPo ? const Color(0xFF059669) : const Color(0xFF64748B),
                  fontWeight: isPo ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EditManifestSheet extends ConsumerStatefulWidget {
  final PackingList container;

  const _EditManifestSheet({required this.container});

  @override
  ConsumerState<_EditManifestSheet> createState() => _EditManifestSheetState();
}

class _EditManifestSheetState extends ConsumerState<_EditManifestSheet> {
  late List<Map<String, dynamic>> _manifestItems;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    // Initialize state with current manifest items from container
    _manifestItems = widget.container.items.map((item) {
      return {
        'type': item.type,
        'po_detail_id': item.poDetailId,
        'inventory_id': item.inventoryId,
        'po_number': item.poNumber,
        'sku': item.sku,
        'product_name': item.productName,
        'planned_qty': item.plannedQty,
        'unit': item.unit,
      };
    }).toList();
  }

  void _removeItem(int index) {
    setState(() {
      _manifestItems.removeAt(index);
    });
  }

  void _updateQuantity(int index, double val) {
    setState(() {
      _manifestItems[index]['planned_qty'] = val;
    });
  }

  void _addItem(Map<String, dynamic> item) {
    // Check if item already exists in local list to avoid duplicates
    final exists = _manifestItems.any((x) =>
        x['type'] == item['type'] &&
        (item['type'] == 'po'
            ? x['po_detail_id'] == item['po_detail_id']
            : x['inventory_id'] == item['inventory_id']));

    if (exists) {
      _showTopNotification(context, 'Item sudah ditambahkan ke manifest', isError: true);
      return;
    }

    setState(() {
      _manifestItems.add(item);
    });

    _showTopNotification(context, 'Menambahkan ${item['product_name']} ke manifest');
  }

  Future<void> _saveChanges() async {
    setState(() => _isSaving = true);
    try {
      final repo = ref.read(packingListRepositoryProvider);

      // Clean payload for API backend
      final payload = _manifestItems.map((item) {
        return {
          'type': item['type'],
          'po_detail_id': item['po_detail_id'],
          'inventory_id': item['inventory_id'],
          'planned_qty': item['planned_qty'],
        };
      }).toList();

      await repo.updateManifest(widget.container.id, payload);
      ref.invalidate(packingListDetailProvider(widget.container.id));
      ref.invalidate(packingListsProvider);

      if (mounted) {
        Navigator.pop(context);
        _showTopNotification(context, 'Manifest berhasil diperbarui!');
      }
    } catch (e) {
      if (mounted) {
        _showTopNotification(context, 'Error: $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Widget _buildManifestItemEditorRow(int index, Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['product_name'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 2),
                Text(
                  'SKU: ${item['sku'] ?? "-"} • Ref: ${item['po_number'] ?? "Internal"}',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, size: 20, color: Color(0xFF64748B)),
                onPressed: () {
                  if (item['planned_qty'] > 1) {
                    _updateQuantity(index, item['planned_qty'] - 1);
                  }
                },
              ),
              SizedBox(
                width: 50,
                child: TextFormField(
                  key: ValueKey('qty_${item['po_detail_id'] ?? item['inventory_id']}_${item['planned_qty']}'),
                  initialValue: item['planned_qty'].toString(),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  onChanged: (val) {
                    final parsed = double.tryParse(val);
                    if (parsed != null && parsed > 0) {
                      _updateQuantity(index, parsed);
                    }
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 20, color: Color(0xFF64748B)),
                onPressed: () {
                  _updateQuantity(index, item['planned_qty'] + 1);
                },
              ),
              Text(
                item['unit'] ?? '',
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                onPressed: () => _removeItem(index),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 750;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF8FAFC),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Edit Manifest', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: isWide
                    ? DefaultTabController(
                        length: 2,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Panel: Current manifest items to edit
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                                    child: Text('Barang Saat Ini di Daftar Packing', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF475569))),
                                  ),
                                  Expanded(
                                    child: _manifestItems.isEmpty
                                        ? const Center(child: Text('Belum ada barang di manifest. Tambahkan dari panel kanan!'))
                                        : ListView.separated(
                                            controller: scrollController,
                                            padding: const EdgeInsets.all(16),
                                            itemCount: _manifestItems.length,
                                            separatorBuilder: (ctx, i) => const SizedBox(height: 10),
                                            itemBuilder: (context, index) {
                                              return _buildManifestItemEditorRow(index, _manifestItems[index]);
                                            },
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            const VerticalDivider(width: 1),
                            // Right Panel: Available items to select and add
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  const TabBar(
                                    tabs: [
                                      Tab(text: 'Item PO'),
                                      Tab(text: 'Stok Gudang'),
                                    ],
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      children: [
                                        _AvailablePoItemsView(containerId: widget.container.id, onAdd: _addItem),
                                        _AvailableInventoryView(containerId: widget.container.id, onAdd: _addItem),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            TabBar(
                              tabs: [
                                Tab(text: 'Saat Ini (${_manifestItems.length})'),
                                const Tab(text: 'Item PO'),
                                const Tab(text: 'Stok Gudang'),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  // Tab 0: Current manifest items
                                  _manifestItems.isEmpty
                                      ? const Center(child: Text('Belum ada barang di manifest. Tambahkan dari tab lain!'))
                                      : ListView.separated(
                                          controller: scrollController,
                                          padding: const EdgeInsets.all(16),
                                          itemCount: _manifestItems.length,
                                          separatorBuilder: (ctx, i) => const SizedBox(height: 10),
                                          itemBuilder: (context, index) {
                                            return _buildManifestItemEditorRow(index, _manifestItems[index]);
                                          },
                                        ),
                                  // Tab 1: PO items
                                  _AvailablePoItemsView(containerId: widget.container.id, onAdd: _addItem),
                                  // Tab 2: Warehouse Stock
                                  _AvailableInventoryView(containerId: widget.container.id, onAdd: _addItem),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              const Divider(height: 1),
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isSaving
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Simpan Perubahan', style: TextStyle(fontWeight: FontWeight.bold)),
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

class _AvailablePoItemsView extends ConsumerWidget {
  final int containerId;
  final Function(Map<String, dynamic>) onAdd;

  const _AvailablePoItemsView({required this.containerId, required this.onAdd});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(availablePoItemsProvider(containerId));

    return asyncItems.when(
      data: (items) {
        if (items.isEmpty) {
          return const Center(child: Text('Tidak ada item PO yang tersedia', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['product_name'] ?? 'Item', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 2),
                  Text('SKU: ${item['sku']} • Ref: ${item['po_number']}', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sisa: ${item['remaining_qty']} ${item['unit']}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
                      ElevatedButton(
                        onPressed: () {
                          onAdd({
                            'type': 'po',
                            'po_detail_id': item['po_detail_id'],
                            'inventory_id': null,
                            'po_number': item['po_number'],
                            'sku': item['sku'],
                            'product_name': item['product_name'],
                            'planned_qty': 1.0, // Default start qty
                            'unit': item['unit'] ?? 'PCS',
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Tambah'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(fontSize: 12))),
    );
  }
}

class _AvailableInventoryView extends ConsumerWidget {
  final int containerId;
  final Function(Map<String, dynamic>) onAdd;

  const _AvailableInventoryView({required this.containerId, required this.onAdd});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(availableInventoryItemsProvider(containerId));

    return asyncItems.when(
      data: (items) {
        if (items.isEmpty) {
          return const Center(child: Text('Tidak ada stok gudang yang tersedia', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['product_name'] ?? 'Item', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 2),
                  Text('SKU: ${item['sku']}', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Stok: ${item['balance_qty']} ${item['unit']}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
                      ElevatedButton(
                        onPressed: () {
                          onAdd({
                            'type': 'inventory',
                            'po_detail_id': null,
                            'inventory_id': item['inventory_id'],
                            'po_number': 'STOK GUDANG',
                            'sku': item['sku'],
                            'product_name': item['product_name'],
                            'planned_qty': 1.0, // Default start qty
                            'unit': item['unit'] ?? 'PCS',
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Tambah'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(fontSize: 12))),
    );
  }
}

class _CreateContainerDialog extends ConsumerStatefulWidget {
  const _CreateContainerDialog();

  @override
  ConsumerState<_CreateContainerDialog> createState() => _CreateContainerDialogState();
}

class _CreateContainerDialogState extends ConsumerState<_CreateContainerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _containerNumberController = TextEditingController();
  final _carrierNameController = TextEditingController();
  final _plateNumberController = TextEditingController();
  
  int? _selectedCompanyId;
  int? _sourceWarehouseId;
  int? _destinationWarehouseId;
  DateTime? _estimatedDeparture;
  DateTime? _closingDate;
  bool _isSaving = false;

  @override
  void dispose() {
    _containerNumberController.dispose();
    _carrierNameController.dispose();
    _plateNumberController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context, bool isDeparture) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate == null) return;

    if (!context.mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) return;

    setState(() {
      final combined = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      if (isDeparture) {
        _estimatedDeparture = combined;
      } else {
        _closingDate = combined;
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_sourceWarehouseId == null || _destinationWarehouseId == null) {
      _showTopNotification(context, 'Harap pilih gudang sumber dan tujuan', isError: true);
      return;
    }
    if (_sourceWarehouseId == _destinationWarehouseId) {
      _showTopNotification(context, 'Gudang sumber dan tujuan tidak boleh sama', isError: true);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final repo = ref.read(packingListRepositoryProvider);
      final newContainer = await repo.createPackingList(
        containerNumber: _containerNumberController.text.trim(),
        carrierName: _carrierNameController.text.trim(),
        plateNumber: _plateNumberController.text.trim(),
        sourceWarehouseId: _sourceWarehouseId!,
        destinationWarehouseId: _destinationWarehouseId!,
        estimatedDeparture: _estimatedDeparture,
        closingDate: _closingDate,
      );

      // Invalidate list provider to trigger fresh fetch
      ref.invalidate(packingListsProvider);

      if (mounted) {
        Navigator.pop(context, newContainer.id);
        _showTopNotification(context, 'Kontainer berhasil dibuat');
      }
    } catch (e) {
      if (mounted) {
        _showTopNotification(context, 'Gagal membuat kontainer: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final companiesAsync = ref.watch(companiesProvider);
    final warehousesAsync = ref.watch(warehousesProvider);

    return AlertDialog(
      title: const Text('Buat Daftar Packing / Kontainer'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _containerNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Kontainer',
                    hintText: 'mis. TAKU-002',
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _carrierNameController,
                  decoration: const InputDecoration(
                    labelText: 'Pelayaran (Carrier)',
                    hintText: 'mis. TANTO, SPIL',
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _plateNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Plat',
                    hintText: 'mis. L 1234 AB',
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                companiesAsync.when(
                  data: (companiesList) {
                    return DropdownButtonFormField<int>(
                      value: _selectedCompanyId,
                      decoration: const InputDecoration(labelText: 'Perusahaan'),
                      items: companiesList.map((c) {
                        return DropdownMenuItem<int>(
                          value: c.id,
                          child: Text(c.companyName),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedCompanyId = val;
                          _sourceWarehouseId = null;
                          _destinationWarehouseId = null;
                        });
                      },
                      validator: (val) => val == null ? 'Wajib diisi' : null,
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                  error: (err, _) => Text('Gagal memuat perusahaan: $err', style: const TextStyle(color: Colors.red)),
                ),
                const SizedBox(height: 12),
                warehousesAsync.when(
                  data: (list) {
                    final filteredList = _selectedCompanyId == null
                        ? <Warehouse>[]
                        : list.where((w) => w.companyId == _selectedCompanyId).toList();

                    return Column(
                      children: [
                        DropdownButtonFormField<int>(
                          initialValue: _sourceWarehouseId,
                          key: ValueKey('source_$_selectedCompanyId'),
                          decoration: InputDecoration(
                            labelText: 'Gudang Sumber',
                            hintText: _selectedCompanyId == null ? 'Pilih Perusahaan terlebih dahulu' : 'Pilih Gudang Sumber',
                          ),
                          items: filteredList.map((w) {
                            return DropdownMenuItem<int>(
                              value: w.id,
                              child: Text(w.name),
                            );
                          }).toList(),
                          onChanged: _selectedCompanyId == null ? null : (val) => setState(() => _sourceWarehouseId = val),
                          validator: (val) => val == null ? 'Wajib diisi' : null,
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<int>(
                          initialValue: _destinationWarehouseId,
                          key: ValueKey('dest_$_selectedCompanyId'),
                          decoration: InputDecoration(
                            labelText: 'Gudang Tujuan',
                            hintText: _selectedCompanyId == null ? 'Pilih Perusahaan terlebih dahulu' : 'Pilih Gudang Tujuan',
                          ),
                          items: filteredList.map((w) {
                            return DropdownMenuItem<int>(
                              value: w.id,
                              child: Text(w.name),
                            );
                          }).toList(),
                          onChanged: _selectedCompanyId == null ? null : (val) => setState(() => _destinationWarehouseId = val),
                          validator: (val) => val == null ? 'Wajib diisi' : null,
                        ),
                      ],
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                  error: (err, _) => Text('Gagal memuat gudang: $err', style: const TextStyle(color: Colors.red)),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(_estimatedDeparture == null 
                    ? 'Estimasi Keberangkatan: Belum Diatur' 
                    : 'Estimasi Keberangkatan: ${_estimatedDeparture!.toLocal().toString().substring(0, 16)}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDateTime(context, true),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(_closingDate == null 
                    ? 'Tanggal Penutupan: Belum Diatur' 
                    : 'Tanggal Penutupan: ${_closingDate!.toLocal().toString().substring(0, 16)}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDateTime(context, false),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4F46E5),
            foregroundColor: Colors.white,
          ),
          child: _isSaving 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text('Buat'),
        ),
      ],
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

  // Automatically remove after 2.5 seconds
  Future.delayed(const Duration(milliseconds: 2500), () {
    if (entry.mounted) {
      entry.remove();
    }
  });
}
