import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';
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

class _ReceivingScanScreenState extends ConsumerState<ReceivingScanScreen> {
  final ScrollController _historyScrollController = ScrollController();
  final ScrollController _poScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  bool _isDownloadingPdf = false;
  int? _selectedPoId;
  String _receivingMode = 'vendor'; // 'vendor' or 'container'
  String? _selectedContainerNumber;
  int _selectedSegment = 0; // 0 for PO/Container, 1 for History

  @override
  void initState() {
    super.initState();
    _historyScrollController.addListener(_onHistoryScroll);
    _poScrollController.addListener(_onPoScroll);
  }

  @override
  void dispose() {
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

    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        dialogContext = ctx;
        return const CupertinoAlertDialog(
          content: Row(
            children: [
              CupertinoActivityIndicator(),
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
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final bgColor = CupertinoColors.systemGroupedBackground.resolveFrom(context);
    final navBarBg = CupertinoColors.systemBackground.resolveFrom(context);

    return CupertinoPageScaffold(
      backgroundColor: bgColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: navBarBg,
        middle: Text(
          'Penerimaan Barang',
          style: TextStyle(color: labelColor),
        ),
      ),
      child: SafeArea(
        child: Column(
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
                        Icon(CupertinoIcons.list_bullet, size: 16),
                        SizedBox(width: 6),
                        Text('PO Terbuka / Kontainer', style: TextStyle(fontSize: 13)),
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
                        Text('Riwayat', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                },
                onValueChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedSegment = val;
                    });
                  }
                },
              ),
            ),
            Expanded(
              child: _selectedSegment == 0
                  ? _buildOpenPOsTabContent(isWide)
                  : _buildHistoryTabContent(isWide),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpenPOsTabContent(bool isWide) {
    final leftPanel = _buildOpenPOsTab(isWide);
    final labelColor = CupertinoColors.label.resolveFrom(context);

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 380, child: leftPanel),
          Container(
            width: 0.5,
            color: CupertinoColors.separator.resolveFrom(context),
          ),
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
                              'Pilih Pesanan Pembelian (PO) atau Kontainer untuk mulai menerima barang',
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
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final navBarBg = CupertinoColors.systemBackground.resolveFrom(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(4),
            child: CupertinoSlidingSegmentedControl<String>(
              groupValue: _receivingMode,
              children: {
                'vendor': Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.home,
                        size: 14,
                        color: _receivingMode == 'vendor'
                            ? CupertinoColors.activeBlue.resolveFrom(context)
                            : CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'PO Vendor',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _receivingMode == 'vendor'
                              ? labelColor
                              : CupertinoColors.secondaryLabel.resolveFrom(context),
                        ),
                      ),
                    ],
                  ),
                ),
                'container': Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.bus,
                        size: 14,
                        color: _receivingMode == 'container'
                            ? CupertinoColors.activeBlue.resolveFrom(context)
                            : CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Kontainer',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _receivingMode == 'container'
                              ? labelColor
                              : CupertinoColors.secondaryLabel.resolveFrom(context),
                        ),
                      ),
                    ],
                  ),
                ),
              },
              onValueChanged: (val) {
                if (val != null) {
                  setState(() {
                    _receivingMode = val;
                    _searchController.clear();
                    _searchQuery = '';
                    _selectedPoId = null;
                    _selectedContainerNumber = null;
                  });
                }
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: CupertinoSearchTextField(
            controller: _searchController,
            placeholder: _receivingMode == 'vendor'
                ? 'Cari nomor PO atau nama pemasok...'
                : 'Cari nomor kontainer atau nama pemasok...',
            onChanged: (val) {
              setState(() {
                _searchQuery = val.trim();
              });
            },
            onSuffixTap: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
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
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

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
                child: Center(child: CupertinoActivityIndicator()),
              );
            }
            final po = orders[index];
            final progress = po.totalItems > 0 ? po.receivedItems / po.totalItems : 0.0;
            final isSelected = po.id == _selectedPoId;

            Color statusColor;
            switch (po.status.toLowerCase()) {
              case 'approved':
                statusColor = CupertinoColors.activeGreen;
                break;
              case 'ordered':
                statusColor = CupertinoColors.activeBlue;
                break;
              case 'partial':
                statusColor = CupertinoColors.systemOrange;
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
                  if (isWide) {
                    setState(() {
                      _selectedPoId = po.id;
                      _selectedContainerNumber = null;
                    });
                  } else {
                    context.push('/receiving/form?po_id=${po.id}');
                  }
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
                            po.poNumber,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
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
                              po.status.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        po.supplierName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: labelColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(height: 0.5, color: separatorColor),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.house,
                            size: 14,
                            color: CupertinoColors.activeBlue.resolveFrom(context),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              po.warehouseName ?? 'Gudang N/A',
                              style: TextStyle(
                                fontSize: 12,
                                color: CupertinoColors.secondaryLabel.resolveFrom(context),
                              ),
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
                            child: Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: const CupertinoDynamicColor.withBrightness(
                                  color: Color(0xFFE5E5EA),
                                  darkColor: Color(0xFF2C2C2E),
                                ).resolveFrom(context),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: progress.clamp(0.0, 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.activeBlue.resolveFrom(context),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${po.receivedItems}/${po.totalItems} barang',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.activeBlue.resolveFrom(context),
                            ),
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

  Widget _buildContainersList(bool isWide) {
    final containersAsync = ref.watch(receivingContainersProvider);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

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
            const statusColor = CupertinoColors.activeBlue;

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
                  if (isWide) {
                    setState(() {
                      _selectedContainerNumber = container.containerNumber;
                      _selectedPoId = null;
                    });
                  } else {
                    context.push('/receiving/container-form?container_number=${container.containerNumber}');
                  }
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
                            container.containerNumber,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
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
                              container.status.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        container.supplierName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: labelColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(height: 0.5, color: separatorColor),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.house,
                            size: 14,
                            color: CupertinoColors.activeBlue.resolveFrom(context),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Tujuan: ${container.destinationWarehouseName ?? "N/A"}',
                              style: TextStyle(
                                fontSize: 12,
                                color: CupertinoColors.secondaryLabel.resolveFrom(context),
                              ),
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
                            Icon(
                              CupertinoIcons.bus,
                              size: 14,
                              color: CupertinoColors.secondaryLabel.resolveFrom(context),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Plat: ${container.plateNumber}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  void _showDetailDialog(BuildContext context, int receivingId, String receivingNumber) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: CupertinoPageScaffold(
            backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
            navigationBar: CupertinoNavigationBar(
              backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
              middle: Text(receivingNumber),
              leading: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.printer, size: 22),
                onPressed: () => _downloadAndPrintPdf(receivingId, receivingNumber),
              ),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text('Tutup'),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            child: SafeArea(
              child: FutureBuilder<Map<String, dynamic>>(
                future: ref.read(receivingRepositoryProvider).getReceivingDetail(receivingId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CupertinoActivityIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          'Gagal memuat detail: ${snapshot.error}',
                          style: const TextStyle(color: CupertinoColors.destructiveRed),
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
                  final labelColor = CupertinoColors.label.resolveFrom(context);
                  final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
                  final separatorColor = CupertinoColors.separator.resolveFrom(context);

                  return ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: separatorColor, width: 0.5),
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
                      Text(
                        'Barang yang Diterima',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: labelColor,
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
                            color: cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: separatorColor, width: 0.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: labelColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'SKU: $sku  •  Lokasi: $location',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Jumlah Diterima:',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                                    ),
                                  ),
                                  Text(
                                    '${qty.toStringAsFixed(0)} unit',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: CupertinoColors.activeGreen,
                                    ),
                                  ),
                                ],
                              ),
                              if (discrepancyType != 'none') ...[
                                const SizedBox(height: 12),
                                Container(height: 0.5, color: separatorColor),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.exclamationmark_triangle,
                                      size: 16,
                                      color: discrepancyType == 'missing'
                                          ? CupertinoColors.systemOrange
                                          : CupertinoColors.destructiveRed,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Ketidaksesuaian: ${getDiscrepancyLabel(discrepancyType)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: discrepancyType == 'missing'
                                            ? CupertinoColors.systemOrange
                                            : CupertinoColors.destructiveRed,
                                      ),
                                    ),
                                  ],
                                ),
                                if (discrepancyQty > 0) ...[
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Jumlah Ketidaksesuaian:',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: CupertinoColors.secondaryLabel.resolveFrom(context),
                                        ),
                                      ),
                                      Text(
                                        '${discrepancyQty.toStringAsFixed(0)} unit',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: labelColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                if (discrepancyNote.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    'Catatan: $discrepancyNote',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic,
                                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                                    ),
                                  ),
                                ],
                                if (photoPath != null && photoPath.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    'Foto Pendukung:',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                                    ),
                                  ),
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
                                            color: const CupertinoDynamicColor.withBrightness(
                                              color: Color(0xFFF2F2F7),
                                              darkColor: Color(0xFF1C1C1E),
                                            ).resolveFrom(context),
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    CupertinoIcons.photo,
                                                    color: CupertinoColors.placeholderText.resolveFrom(context),
                                                    size: 28,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  const Text(
                                                    'Gagal memuat gambar',
                                                    style: TextStyle(fontSize: 11, color: CupertinoColors.inactiveGray),
                                                  ),
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
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _showImagePreviewDialog(BuildContext context, String photoPath) {
    final imageUrl = '${AppConfig.baseUrl.replaceAll('/api/v1/', '')}/storage/$photoPath';
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CupertinoPageScaffold(
        backgroundColor: CupertinoColors.black,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoColors.black.withOpacity(0.5),
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.xmark, color: CupertinoColors.white),
            onPressed: () => Navigator.pop(context),
          ),
          middle: const Text('Pratinjau Foto', style: TextStyle(color: CupertinoColors.white)),
        ),
        child: SafeArea(
          child: InteractiveViewer(
            child: Center(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(CupertinoIcons.photo, color: CupertinoColors.white, size: 48));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: labelColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryTab() {
    final historyAsync = ref.watch(receivingsHistoryProvider);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final cardBg = CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context);
    final separatorColor = CupertinoColors.separator.resolveFrom(context);

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
                child: Center(child: CupertinoActivityIndicator()),
              );
            }
            final record = records[index];

            return Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: separatorColor, width: 0.5),
              ),
              child: GestureDetector(
                onTap: () => _showDetailDialog(context, record.id, record.receivingNumber),
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: labelColor,
                            ),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            minSize: 0,
                            onPressed: () => _downloadAndPrintPdf(record.id, record.receivingNumber),
                            child: const Icon(
                              CupertinoIcons.printer,
                              size: 20,
                              color: CupertinoColors.activeBlue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'PO: ${record.poNumber ?? "-"}',
                            style: TextStyle(
                              fontSize: 13,
                              color: CupertinoColors.secondaryLabel.resolveFrom(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            record.receivedAt.split('T').first,
                            style: TextStyle(
                              fontSize: 12,
                              color: CupertinoColors.secondaryLabel.resolveFrom(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(height: 0.5, color: separatorColor),
                      const SizedBox(height: 8),
                      Text(
                        record.supplierName,
                        style: TextStyle(
                          fontSize: 13,
                          color: labelColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Gudang: ${record.warehouseName ?? "-"}',
                            style: TextStyle(
                              fontSize: 12,
                              color: CupertinoColors.secondaryLabel.resolveFrom(context),
                            ),
                          ),
                          Text(
                            '${record.detailsCount} barang',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.activeGreen,
                            ),
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
