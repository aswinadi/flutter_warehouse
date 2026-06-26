import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';
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
import '../../../core/widgets/cupertino_glass_toast.dart';
import '../../../core/widgets/cupertino_glass_dialog.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/providers/warehouse_provider.dart';
import '../../../core/models/warehouse.dart';
import '../../../core/providers/company_provider.dart';
import '../../../core/config/app_config.dart';

class _WebScrollBehavior extends CupertinoScrollBehavior {
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

    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        dialogContext = ctx;
        return Center(
          child: SizedBox(
            width: 200,
            height: 100,
            child: CupertinoGlassContainer(
              borderRadius: CupertinoSpacing.dialogRadius,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoActivityIndicator(),
                  SizedBox(width: 16),
                  Text(
                    'Membuat PDF...',
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 14,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
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
    final newId = await showCupertinoModalPopup<int>(
      context: context,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: const _CreateContainerDialog(),
      ),
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
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final bgColor = CupertinoColors.systemGroupedBackground.resolveFrom(context);
    final navBarBg = CupertinoColors.systemBackground.resolveFrom(context);

    Widget buildBody() {
      return Column(
        children: [
          const CompanySwitcher(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CupertinoSearchTextField(
              controller: _searchController,
              placeholder: 'Cari kontainer atau nomor plat...',
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim();
                  _selectedId = null;
                });
              },
              onSuffixTap: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
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
                  itemCount: containers.length +
                      (ref
                              .watch(packingListsProvider(status: _selectedStatus, search: _searchQuery).notifier)
                              .hasMore
                          ? 1
                          : 0),
                  separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == containers.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CupertinoActivityIndicator()),
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
                            CupertinoPageRoute(
                              builder: (_) => CupertinoPageScaffold(
                                navigationBar: CupertinoNavigationBar(
                                  middle: Text('Kontainer ${container.containerNumber}'),
                                  backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
                                ),
                                child: SafeArea(
                                  child: _ContainerDetailView(
                                    containerId: container.id,
                                    onDownloadPdf: (id, number) => _downloadAndPrintPdf(id, number),
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
                      SizedBox(width: 360, child: mainList),
                      Container(
                        width: 0.5,
                        color: CupertinoColors.separator.resolveFrom(context),
                      ),
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
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      );
    }

    return CupertinoPageScaffold(
      backgroundColor: bgColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: navBarBg,
        middle: Text(
          'Daftar Packing / Kontainer',
          style: TextStyle(color: labelColor),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.add),
              onPressed: () => _showCreateContainerDialog(context, isWide),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.refresh),
              onPressed: () {
                setState(() {
                  _selectedId = null;
                });
                ref.invalidate(packingListsProvider);
              },
            ),
          ],
        ),
      ),
      child: SafeArea(child: buildBody()),
    );
  }

  Widget _buildFilterChip(String label, String? value) {
    final isSelected = _selectedStatus == value;
    final labelColor = CupertinoColors.label.resolveFrom(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = value;
          _selectedId = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? CupertinoColors.activeBlue
              : CupertinoColors.tertiarySystemFill.resolveFrom(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? CupertinoColors.white : labelColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
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
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    Color statusColor;
    switch (container.status.toLowerCase()) {
      case 'draft':
      case 'planned':
      case 'loading':
        statusColor = CupertinoColors.inactiveGray;
        break;
      case 'shipped':
        statusColor = CupertinoColors.systemOrange;
        break;
      case 'arrived':
        statusColor = CupertinoColors.activeGreen;
        break;
      case 'closed':
        statusColor = CupertinoColors.systemPurple;
        break;
      default:
        statusColor = CupertinoColors.inactiveGray;
    }

    final cardColor = isSelected
        ? CupertinoColors.activeBlue.resolveFrom(context).withValues(alpha: 0.08)
        : null;

    return CupertinoGlassContainer(
      backgroundColor: cardColor,
      borderColor: isSelected ? CupertinoColors.activeBlue.resolveFrom(context) : separatorColor,
      borderRadius: CupertinoSpacing.cardRadius,
      padding: EdgeInsets.zero,
      child: GestureDetector(
        onTap: onTap,
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
                      container.status.toUpperCase(),
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                    ),
                  ),
                ],
              ),
              Builder(builder: (context) {
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
                    style: TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                  ),
                );
              }),
              const SizedBox(height: 8),
              Container(height: 0.5, color: separatorColor),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(CupertinoIcons.house, size: 14, color: CupertinoColors.activeBlue),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${container.sourceWarehouseName ?? "N/A"} ➔ ${container.destinationWarehouseName ?? "N/A"}',
                      style: TextStyle(fontSize: 12, color: labelColor, fontWeight: FontWeight.w500),
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
                    style: TextStyle(fontSize: 11, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                  ),
                  Text(
                    'Close: ${container.closingDate != null ? "${container.closingDate!.day.toString().padLeft(2, '0')}/${container.closingDate!.month.toString().padLeft(2, '0')}/${container.closingDate!.year}" : "-"}',
                    style: TextStyle(fontSize: 11, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${container.itemCount} item',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: CupertinoColors.activeBlue),
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

class _ContainerDetailView extends ConsumerWidget {
  final int containerId;
  final Function(int, String) onDownloadPdf;

  const _ContainerDetailView({
    required this.containerId,
    required this.onDownloadPdf,
  });

  Future<void> _updateContainerStatus(BuildContext context, WidgetRef ref, int id, String status) async {
    final result = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoGlassDialog(
        title: Text(status == 'shipped' ? 'Kirim Kontainer' : 'Tutup Kontainer'),
        content: Text(status == 'shipped'
            ? 'Apakah Anda yakin ingin menandai kontainer ini sebagai dikirim?'
            : 'Apakah Anda yakin ingin menutup daftar packing ini?'),
        actions: [
          CupertinoGlassDialogAction(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          CupertinoGlassDialogAction(
            isDestructive: status == 'cancelled',
            child: const Text('Konfirmasi'),
            onPressed: () => Navigator.pop(ctx, true),
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
        _showTopNotification(context, 'Gagal memperbarui status kontainer: ${_getErrorMessage(e)}', isError: true);
      }
    }
  }

  void _showEditContainerDialog(BuildContext context, WidgetRef ref, PackingList container) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: _CreateContainerDialog(container: container),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(packingListDetailProvider(containerId));
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return detailAsync.when(
      data: (container) {
        final isEditable = !['shipped', 'arrived', 'closed'].contains(container.status.toLowerCase());

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  CupertinoGlassContainer(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    borderRadius: 12,
                    borderColor: separatorColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Kontainer: ${container.containerNumber}',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: labelColor),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: CupertinoColors.activeBlue.resolveFrom(context), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CupertinoButton(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    minSize: 0,
                                    onPressed: () => onDownloadPdf(container.id, container.containerNumber),
                                    child: const Row(
                                      children: [
                                        Icon(CupertinoIcons.printer, size: 14),
                                        SizedBox(width: 4),
                                        Text('Unduh PDF', style: TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                ),
                                if (isEditable) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: CupertinoColors.activeBlue.resolveFrom(context), width: 0.5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: CupertinoButton(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      minSize: 0,
                                      onPressed: () => _showEditContainerDialog(context, ref, container),
                                      child: const Row(
                                        children: [
                                          Icon(CupertinoIcons.pencil, size: 14),
                                          SizedBox(width: 4),
                                          Text('Edit', style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            'Carrier: ${container.carrierName ?? "-"} • Plat Nomor: ${container.plateNumber ?? "-"}',
                            style: TextStyle(fontSize: 13, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(height: 0.5, color: separatorColor),
                        const SizedBox(height: 12),
                        _buildDetailRow(context, 'Gudang Sumber', container.sourceWarehouseName ?? 'N/A'),
                        const SizedBox(height: 6),
                        _buildDetailRow(context, 'Gudang Tujuan', container.destinationWarehouseName ?? 'N/A'),
                        const SizedBox(height: 6),
                        _buildDetailRow(
                          context,
                          'Estimasi Keberangkatan',
                          container.estimatedDeparture != null
                              ? "${container.estimatedDeparture!.day.toString().padLeft(2, '0')}/${container.estimatedDeparture!.month.toString().padLeft(2, '0')}/${container.estimatedDeparture!.year} ${container.estimatedDeparture!.hour.toString().padLeft(2, '0')}:${container.estimatedDeparture!.minute.toString().padLeft(2, '0')}"
                              : '-',
                        ),
                        const SizedBox(height: 6),
                        _buildDetailRow(
                          context,
                          'Tanggal Penutupan',
                          container.closingDate != null
                              ? "${container.closingDate!.day.toString().padLeft(2, '0')}/${container.closingDate!.month.toString().padLeft(2, '0')}/${container.closingDate!.year} ${container.closingDate!.hour.toString().padLeft(2, '0')}:${container.closingDate!.minute.toString().padLeft(2, '0')}"
                              : '-',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  CupertinoGlassContainer(
                    padding: const EdgeInsets.all(16),
                    borderRadius: 12,
                    borderColor: separatorColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isEditable || container.status.toLowerCase() == 'closed') ...[
                          Text(
                            'Detail Segel & Tindakan',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                          ),
                          const SizedBox(height: 8),
                          if (container.status.toLowerCase() == 'loading' ||
                              container.status.toLowerCase() == 'planned' ||
                              container.status.toLowerCase() == 'closed') ...[
                            Row(
                              children: [
                                if (container.status.toLowerCase() == 'loading' ||
                                    container.status.toLowerCase() == 'planned')
                                  Expanded(
                                    child: CupertinoButton.filled(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      onPressed: () =>
                                          _updateContainerStatus(context, ref, container.id, 'closed'),
                                      child: const Text('Tutup Daftar Packing', style: TextStyle(fontSize: 14)),
                                    ),
                                  ),
                                if (container.status.toLowerCase() == 'closed')
                                  Expanded(
                                    child: CupertinoButton.filled(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      onPressed: () =>
                                          _updateContainerStatus(context, ref, container.id, 'shipped'),
                                      child: const Text('Kirim / Keberangkatan', style: TextStyle(fontSize: 14)),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ],
                        Text(
                          'Barang Manifest',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                        ),
                        const SizedBox(height: 8),
                        if (isEditable)
                          SizedBox(
                            width: double.infinity,
                            child: CupertinoButton(
                              color: CupertinoColors.activeBlue,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              onPressed: () => _showEditManifestDialog(context, ref, container),
                              child: const Text('Edit Manifest', style: TextStyle(fontSize: 14, color: CupertinoColors.white)),
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
                        color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: separatorColor, width: 0.5),
                      ),
                      child: const Center(
                        child: Text(
                          'Belum ada barang di manifest daftar packing ini.',
                          style: TextStyle(color: CupertinoColors.inactiveGray, fontSize: 13),
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
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (err, _) => Center(child: Text('Gagal memuat detail: $err')),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            label,
            style: TextStyle(fontSize: 13, color: CupertinoColors.secondaryLabel.resolveFrom(context), fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 13, color: CupertinoColors.label.resolveFrom(context), fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  void _showEditManifestDialog(BuildContext context, WidgetRef ref, PackingList container) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: _EditManifestSheet(container: container),
      ),
    );
  }
}

class _ManifestItemCard extends StatelessWidget {
  final PackingListItem item;

  const _ManifestItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isPo = item.type == 'po';
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return CupertinoGlassContainer(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      borderRadius: 8,
      borderColor: separatorColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.productName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: labelColor),
                ),
              ),
              Text(
                '${item.plannedQty} ${item.unit}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: CupertinoColors.activeBlue),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SKU: ${item.sku}',
                style: TextStyle(fontSize: 11, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
              ),
              Text(
                isPo ? 'Ref: ${item.poNumber}' : 'Ref: Stok Internal',
                style: TextStyle(
                  fontSize: 11,
                  color: isPo ? CupertinoColors.activeGreen : CupertinoColors.secondaryLabel.resolveFrom(context),
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
  int _activeSegment = 0; // 0: Saat Ini, 1: Item PO, 2: Stok Gudang

  @override
  void initState() {
    super.initState();
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
        _showTopNotification(context, 'Error: ${_getErrorMessage(e)}', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Widget _buildManifestItemEditorRow(int index, Map<String, dynamic> item) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

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
                  item['product_name'] ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: labelColor),
                ),
                const SizedBox(height: 2),
                Text(
                  'SKU: ${item['sku'] ?? "-"} • Ref: ${item['po_number'] ?? "Internal"}',
                  style: TextStyle(fontSize: 11, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 32,
                onPressed: () {
                  if (item['planned_qty'] > 1) {
                    _updateQuantity(index, item['planned_qty'] - 1);
                  }
                },
                child: const Icon(CupertinoIcons.minus_circle, size: 20, color: CupertinoColors.secondaryLabel),
              ),
              SizedBox(
                width: 50,
                child: CupertinoTextField(
                  key: ValueKey('qty_${item['po_detail_id'] ?? item['inventory_id']}_${item['planned_qty']}'),
                  controller: TextEditingController(text: item['planned_qty'].toString())
                    ..selection = TextSelection.fromPosition(
                      TextPosition(offset: item['planned_qty'].toString().length),
                    ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: labelColor),
                  decoration: null,
                  onChanged: (val) {
                    final parsed = double.tryParse(val);
                    if (parsed != null && parsed > 0) {
                      _updateQuantity(index, parsed);
                    }
                  },
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 32,
                onPressed: () {
                  _updateQuantity(index, item['planned_qty'] + 1);
                },
                child: const Icon(CupertinoIcons.plus_circle, size: 20, color: CupertinoColors.secondaryLabel),
              ),
              Text(
                item['unit'] ?? '',
                style: TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
              ),
              const SizedBox(width: 8),
              CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 32,
                onPressed: () => _removeItem(index),
                child: const Icon(CupertinoIcons.trash, color: CupertinoColors.destructiveRed, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Edit Manifest'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Batal'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: CupertinoSlidingSegmentedControl<int>(
                groupValue: _activeSegment,
                children: {
                  0: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Text('Saat Ini (${_manifestItems.length})', style: const TextStyle(fontSize: 12)),
                  ),
                  1: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Text('Item PO', style: TextStyle(fontSize: 12)),
                  ),
                  2: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Text('Stok Gudang', style: TextStyle(fontSize: 12)),
                  ),
                },
                onValueChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _activeSegment = val;
                    });
                  }
                },
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _activeSegment,
                children: [
                  // Tab 0: Current manifest items
                  _manifestItems.isEmpty
                      ? const Center(child: Text('Belum ada barang di manifest.'))
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _manifestItems.length,
                          separatorBuilder: (ctx, i) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            return _buildManifestItemEditorRow(index, _manifestItems[index]);
                          },
                        ),
                  // Tab 1: PO items
                  _AvailablePoItemsView(
                    containerId: widget.container.id,
                    onAdd: _addItem,
                    manifestItems: _manifestItems,
                  ),
                  // Tab 2: Warehouse stock
                  _AvailableInventoryView(
                    containerId: widget.container.id,
                    onAdd: _addItem,
                    manifestItems: _manifestItems,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                border: Border(top: BorderSide(color: separatorColor, width: 0.5)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  onPressed: _isSaving ? null : _saveChanges,
                  child: _isSaving
                      ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                      : const Text('Simpan Perubahan', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvailablePoItemsView extends ConsumerWidget {
  final int containerId;
  final Function(Map<String, dynamic>) onAdd;
  final List<Map<String, dynamic>> manifestItems;

  const _AvailablePoItemsView({
    required this.containerId,
    required this.onAdd,
    required this.manifestItems,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(availablePoItemsProvider(containerId));

    return asyncItems.when(
      data: (items) {
        if (items.isEmpty) {
          return const Center(child: Text('Tidak ada item PO yang tersedia', style: TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel)));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final item = items[index];
            final isAdded = manifestItems.any((x) => x['type'] == 'po' && x['po_detail_id'] == item['po_detail_id']);
            return _AvailablePoItemCard(
              item: item,
              isAdded: isAdded,
              onAdd: onAdd,
            );
          },
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(fontSize: 12))),
    );
  }
}

class _AvailablePoItemCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final bool isAdded;
  final Function(Map<String, dynamic>) onAdd;

  const _AvailablePoItemCard({
    required this.item,
    required this.isAdded,
    required this.onAdd,
  });

  @override
  State<_AvailablePoItemCard> createState() => _AvailablePoItemCardState();
}

class _AvailablePoItemCardState extends State<_AvailablePoItemCard> {
  late TextEditingController _qtyController;

  @override
  void initState() {
    super.initState();
    final remainingQty = widget.item['remaining_qty'] ?? 1.0;
    _qtyController = TextEditingController(text: _formatQty(remainingQty));
  }

  String _formatQty(dynamic val) {
    if (val == null) return '1';
    final parsed = double.tryParse(val.toString());
    if (parsed == null) return val.toString();
    if (parsed == parsed.roundToDouble()) {
      return parsed.round().toString();
    }
    return parsed.toString();
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return CupertinoGlassContainer(
      padding: const EdgeInsets.all(12),
      borderRadius: 8,
      borderColor: separatorColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.item['product_name'] ?? 'Item', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: labelColor)),
          const SizedBox(height: 2),
          Text('SKU: ${widget.item['sku']} • Ref: ${widget.item['po_number']}', style: TextStyle(fontSize: 11, color: CupertinoColors.secondaryLabel.resolveFrom(context))),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sisa: ${widget.item['remaining_qty']} ${widget.item['unit']}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: labelColor)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!widget.isAdded) ...[
                    Text('Qty: ', style: TextStyle(fontSize: 11, color: CupertinoColors.secondaryLabel.resolveFrom(context))),
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 60,
                      height: 28,
                      child: CupertinoTextField(
                        controller: _qtyController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: labelColor, fontWeight: FontWeight.bold),
                        decoration: BoxDecoration(
                          border: Border.all(color: separatorColor, width: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  CupertinoButton(
                    color: widget.isAdded ? CupertinoColors.inactiveGray : CupertinoColors.activeBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minSize: 0,
                    borderRadius: BorderRadius.circular(6),
                    onPressed: widget.isAdded
                        ? null
                        : () {
                            final parsedQty = double.tryParse(_qtyController.text);
                            if (parsedQty == null || parsedQty <= 0) {
                              _showTopNotification(context, 'Kuantitas tidak valid', isError: true);
                              return;
                            }
                            widget.onAdd({
                              'type': 'po',
                              'po_detail_id': widget.item['po_detail_id'],
                              'inventory_id': null,
                              'po_number': widget.item['po_number'],
                              'sku': widget.item['sku'],
                              'product_name': widget.item['product_name'],
                              'planned_qty': parsedQty,
                              'unit': widget.item['unit'] ?? 'PCS',
                            });
                          },
                    child: Text(
                      widget.isAdded ? 'Sudah Ditambah' : 'Tambah',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: CupertinoColors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvailableInventoryView extends ConsumerWidget {
  final int containerId;
  final Function(Map<String, dynamic>) onAdd;
  final List<Map<String, dynamic>> manifestItems;

  const _AvailableInventoryView({
    required this.containerId,
    required this.onAdd,
    required this.manifestItems,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(availableInventoryItemsProvider(containerId));

    return asyncItems.when(
      data: (items) {
        if (items.isEmpty) {
          return const Center(child: Text('Tidak ada stok gudang yang tersedia', style: TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel)));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final item = items[index];
            final isAdded = manifestItems.any((x) => x['type'] == 'inventory' && x['inventory_id'] == item['inventory_id']);
            return _AvailableInventoryCard(
              item: item,
              isAdded: isAdded,
              onAdd: onAdd,
            );
          },
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(fontSize: 12))),
    );
  }
}

class _AvailableInventoryCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final bool isAdded;
  final Function(Map<String, dynamic>) onAdd;

  const _AvailableInventoryCard({
    required this.item,
    required this.isAdded,
    required this.onAdd,
  });

  @override
  State<_AvailableInventoryCard> createState() => _AvailableInventoryCardState();
}

class _AvailableInventoryCardState extends State<_AvailableInventoryCard> {
  late TextEditingController _qtyController;

  @override
  void initState() {
    super.initState();
    final balanceQty = widget.item['balance_qty'] ?? 1.0;
    _qtyController = TextEditingController(text: _formatQty(balanceQty));
  }

  String _formatQty(dynamic val) {
    if (val == null) return '1';
    final parsed = double.tryParse(val.toString());
    if (parsed == null) return val.toString();
    if (parsed == parsed.roundToDouble()) {
      return parsed.round().toString();
    }
    return parsed.toString();
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

    return CupertinoGlassContainer(
      padding: const EdgeInsets.all(12),
      borderRadius: 8,
      borderColor: separatorColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.item['product_name'] ?? 'Item', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: labelColor)),
          const SizedBox(height: 2),
          Text('SKU: ${widget.item['sku']}', style: TextStyle(fontSize: 11, color: CupertinoColors.secondaryLabel.resolveFrom(context))),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Stok: ${widget.item['balance_qty']} ${widget.item['unit']}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: labelColor)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!widget.isAdded) ...[
                    Text('Qty: ', style: TextStyle(fontSize: 11, color: CupertinoColors.secondaryLabel.resolveFrom(context))),
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 60,
                      height: 28,
                      child: CupertinoTextField(
                        controller: _qtyController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: labelColor, fontWeight: FontWeight.bold),
                        decoration: BoxDecoration(
                          border: Border.all(color: separatorColor, width: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  CupertinoButton(
                    color: widget.isAdded ? CupertinoColors.inactiveGray : CupertinoColors.activeBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minSize: 0,
                    borderRadius: BorderRadius.circular(6),
                    onPressed: widget.isAdded
                        ? null
                        : () {
                            final parsedQty = double.tryParse(_qtyController.text);
                            if (parsedQty == null || parsedQty <= 0) {
                              _showTopNotification(context, 'Kuantitas tidak valid', isError: true);
                              return;
                            }
                            widget.onAdd({
                              'type': 'inventory',
                              'po_detail_id': null,
                              'inventory_id': widget.item['inventory_id'],
                              'po_number': 'STOK GUDANG',
                              'sku': widget.item['sku'],
                              'product_name': widget.item['product_name'],
                              'planned_qty': parsedQty,
                              'unit': widget.item['unit'] ?? 'PCS',
                            });
                          },
                    child: Text(
                      widget.isAdded ? 'Sudah Ditambah' : 'Tambah',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: CupertinoColors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CreateContainerDialog extends ConsumerStatefulWidget {
  final PackingList? container;
  const _CreateContainerDialog({this.container});

  @override
  ConsumerState<_CreateContainerDialog> createState() => _CreateContainerDialogState();
}

class _CreateContainerDialogState extends ConsumerState<_CreateContainerDialog> {
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
  void initState() {
    super.initState();
    if (widget.container != null) {
      _containerNumberController.text = widget.container!.containerNumber;
      _carrierNameController.text = widget.container!.carrierName ?? '';
      _plateNumberController.text = widget.container!.plateNumber ?? '';
      _sourceWarehouseId = widget.container!.sourceWarehouseId;
      _destinationWarehouseId = widget.container!.destinationWarehouseId;
      _estimatedDeparture = widget.container!.estimatedDeparture;
      _closingDate = widget.container!.closingDate;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          final list = await ref.read(warehousesProvider.future);
          final match = list.firstWhere((w) => w.id == _sourceWarehouseId);
          if (mounted) {
            setState(() {
              _selectedCompanyId = match.companyId;
            });
          }
        } catch (_) {}
      });
    }
  }

  @override
  void dispose() {
    _containerNumberController.dispose();
    _carrierNameController.dispose();
    _plateNumberController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context, bool isDeparture) async {
    DateTime tempDateTime = isDeparture
        ? (_estimatedDeparture ?? DateTime.now())
        : (_closingDate ?? DateTime.now());

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Container(
              color: CupertinoColors.secondarySystemBackground.resolveFrom(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Batal'),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                  CupertinoButton(
                    child: const Text('Pilih'),
                    onPressed: () {
                      setState(() {
                        if (isDeparture) {
                          _estimatedDeparture = tempDateTime;
                        } else {
                          _closingDate = tempDateTime;
                        }
                      });
                      Navigator.pop(ctx);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                initialDateTime: tempDateTime,
                mode: CupertinoDatePickerMode.dateAndTime,
                use24hFormat: true,
                onDateTimeChanged: (dateTime) {
                  tempDateTime = dateTime;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_containerNumberController.text.trim().isEmpty) {
      _showTopNotification(context, 'Nomor kontainer wajib diisi', isError: true);
      return;
    }
    if (_carrierNameController.text.trim().isEmpty) {
      _showTopNotification(context, 'Nama pelayaran wajib diisi', isError: true);
      return;
    }
    if (_plateNumberController.text.trim().isEmpty) {
      _showTopNotification(context, 'Nomor plat wajib diisi', isError: true);
      return;
    }
    if (_selectedCompanyId == null) {
      _showTopNotification(context, 'Harap pilih perusahaan', isError: true);
      return;
    }
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
      if (widget.container != null) {
        await repo.updatePackingList(
          id: widget.container!.id,
          containerNumber: _containerNumberController.text.trim(),
          carrierName: _carrierNameController.text.trim(),
          plateNumber: _plateNumberController.text.trim(),
          sourceWarehouseId: _sourceWarehouseId!,
          destinationWarehouseId: _destinationWarehouseId!,
          estimatedDeparture: _estimatedDeparture,
          closingDate: _closingDate,
        );

        ref.invalidate(packingListDetailProvider(widget.container!.id));
        ref.invalidate(packingListsProvider);

        if (mounted) {
          Navigator.pop(context);
          _showTopNotification(context, 'Kontainer berhasil diperbarui');
        }
      } else {
        final newContainer = await repo.createPackingList(
          containerNumber: _containerNumberController.text.trim(),
          carrierName: _carrierNameController.text.trim(),
          plateNumber: _plateNumberController.text.trim(),
          sourceWarehouseId: _sourceWarehouseId!,
          destinationWarehouseId: _destinationWarehouseId!,
          estimatedDeparture: _estimatedDeparture,
          closingDate: _closingDate,
        );

        ref.invalidate(packingListsProvider);

        if (mounted) {
          Navigator.pop(context, newContainer.id);
          _showTopNotification(context, 'Kontainer berhasil dibuat');
        }
      }
    } catch (e) {
      if (mounted) {
        _showTopNotification(context, 'Gagal menyimpan kontainer: ${_getErrorMessage(e)}', isError: true);
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
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);
    final isEditing = widget.container != null;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        middle: Text(isEditing ? 'Edit Daftar Packing / Kontainer' : 'Buat Daftar Packing / Kontainer'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Batal'),
          onPressed: () => Navigator.pop(context),
        ),
        trailing: _isSaving
            ? const CupertinoActivityIndicator()
            : CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text(isEditing ? 'Simpan' : 'Buat'),
                onPressed: _submit,
              ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: separatorColor, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nomor Kontainer *', style: TextStyle(fontSize: 12, color: labelColor)),
                  const SizedBox(height: 6),
                  CupertinoTextField(
                    controller: _containerNumberController,
                    placeholder: 'mis. TAKU-002',
                  ),
                  const SizedBox(height: 12),
                  Text('Pelayaran (Carrier) *', style: TextStyle(fontSize: 12, color: labelColor)),
                  const SizedBox(height: 6),
                  CupertinoTextField(
                    controller: _carrierNameController,
                    placeholder: 'mis. TANTO, SPIL',
                  ),
                  const SizedBox(height: 12),
                  Text('Nomor Plat *', style: TextStyle(fontSize: 12, color: labelColor)),
                  const SizedBox(height: 6),
                  CupertinoTextField(
                    controller: _plateNumberController,
                    placeholder: 'mis. L 1234 AB',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: separatorColor, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Perusahaan *', style: TextStyle(fontSize: 12, color: labelColor)),
                  const SizedBox(height: 6),
                  companiesAsync.when(
                    data: (companiesList) {
                      return GestureDetector(
                        onTap: () {
                          showCupertinoModalPopup<int>(
                            context: context,
                            builder: (context) => CupertinoActionSheet(
                              title: const Text('Pilih Perusahaan'),
                              actions: companiesList.map((c) {
                                return CupertinoActionSheetAction(
                                  onPressed: () => Navigator.pop(context, c.id),
                                  child: Text(c.companyName),
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
                                _selectedCompanyId = val;
                                _sourceWarehouseId = null;
                                _destinationWarehouseId = null;
                              });
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: separatorColor, width: 0.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedCompanyId != null
                                    ? companiesList.firstWhere((c) => c.id == _selectedCompanyId).companyName
                                    : 'Pilih Perusahaan',
                                style: TextStyle(
                                  color: _selectedCompanyId != null ? labelColor : CupertinoColors.placeholderText.resolveFrom(context),
                                  fontSize: 14,
                                ),
                              ),
                              const Icon(CupertinoIcons.chevron_down, size: 14, color: CupertinoColors.inactiveGray),
                            ],
                          ),
                        ),
                      );
                    },
                    loading: () => const Center(child: CupertinoActivityIndicator()),
                    error: (err, _) => Text('Error: $err', style: const TextStyle(color: CupertinoColors.destructiveRed)),
                  ),
                  const SizedBox(height: 12),
                  Text('Gudang Sumber *', style: TextStyle(fontSize: 12, color: labelColor)),
                  const SizedBox(height: 6),
                  warehousesAsync.when(
                    data: (list) {
                      final filteredList = _selectedCompanyId == null
                          ? <Warehouse>[]
                          : list.where((w) => w.companyId == _selectedCompanyId).toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: _selectedCompanyId == null
                                ? null
                                : () {
                                    showCupertinoModalPopup<int>(
                                      context: context,
                                      builder: (context) => CupertinoActionSheet(
                                        title: const Text('Pilih Gudang Sumber'),
                                        actions: filteredList.map((w) {
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
                                        });
                                      }
                                    });
                                  },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedCompanyId == null
                                    ? const CupertinoDynamicColor.withBrightness(
                                          color: Color(0xFFF2F2F7),
                                          darkColor: Color(0xFF1C1C1E),
                                        ).resolveFrom(context)
                                    : CupertinoColors.tertiarySystemFill.resolveFrom(context),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: separatorColor, width: 0.5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _sourceWarehouseId != null
                                        ? filteredList.firstWhere((w) => w.id == _sourceWarehouseId).name
                                        : _selectedCompanyId == null
                                            ? 'Pilih perusahaan dahulu'
                                            : 'Pilih Gudang Sumber',
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
                          const SizedBox(height: 12),
                          Text('Gudang Tujuan *', style: TextStyle(fontSize: 12, color: labelColor)),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: _selectedCompanyId == null
                                ? null
                                : () {
                                    showCupertinoModalPopup<int>(
                                      context: context,
                                      builder: (context) => CupertinoActionSheet(
                                        title: const Text('Pilih Gudang Tujuan'),
                                        actions: filteredList
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
                                          _destinationWarehouseId = val;
                                        });
                                      }
                                    });
                                  },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedCompanyId == null
                                    ? const CupertinoDynamicColor.withBrightness(
                                          color: Color(0xFFF2F2F7),
                                          darkColor: Color(0xFF1C1C1E),
                                        ).resolveFrom(context)
                                    : CupertinoColors.tertiarySystemFill.resolveFrom(context),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: separatorColor, width: 0.5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _destinationWarehouseId != null
                                        ? filteredList.firstWhere((w) => w.id == _destinationWarehouseId).name
                                        : _selectedCompanyId == null
                                            ? 'Pilih perusahaan dahulu'
                                            : 'Pilih Gudang Tujuan',
                                    style: TextStyle(
                                      color: _destinationWarehouseId != null ? labelColor : CupertinoColors.placeholderText.resolveFrom(context),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Icon(CupertinoIcons.chevron_down, size: 14, color: CupertinoColors.inactiveGray),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const Center(child: CupertinoActivityIndicator()),
                    error: (err, _) => Text('Error: $err', style: const TextStyle(color: CupertinoColors.destructiveRed)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: separatorColor, width: 0.5),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _selectDateTime(context, true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _estimatedDeparture == null
                                  ? 'Estimasi Keberangkatan: Belum Diatur'
                                  : 'Estimasi Keberangkatan: ${_estimatedDeparture!.toLocal().toString().substring(0, 16)}',
                              style: TextStyle(fontSize: 14, color: labelColor),
                            ),
                          ),
                          const Icon(CupertinoIcons.calendar, color: CupertinoColors.inactiveGray),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 0.5, color: separatorColor),
                  GestureDetector(
                    onTap: () => _selectDateTime(context, false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _closingDate == null
                                  ? 'Tanggal Penutupan: Belum Diatur'
                                  : 'Tanggal Penutupan: ${_closingDate!.toLocal().toString().substring(0, 16)}',
                              style: TextStyle(fontSize: 14, color: labelColor),
                            ),
                          ),
                          const Icon(CupertinoIcons.calendar, color: CupertinoColors.inactiveGray),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showTopNotification(BuildContext context, String message, {bool isError = false}) {
  if (isError) {
    CupertinoGlassToast.showError(context, message);
  } else {
    CupertinoGlassToast.showSuccess(context, message);
  }
}

String _getErrorMessage(dynamic e) {
  if (e is DioException) {
    final responseData = e.response?.data;
    if (responseData is Map) {
      if (responseData['error'] != null) {
        return responseData['error'].toString();
      }
      if (responseData['message'] != null) {
        return responseData['message'].toString();
      }
    }
    return e.message ?? e.toString();
  }
  return e.toString();
}
