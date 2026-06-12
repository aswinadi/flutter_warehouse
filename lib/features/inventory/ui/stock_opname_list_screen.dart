import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors, Divider, VerticalDivider, Icons, Scrollbar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/stock_opname_repository.dart';
import '../../../core/providers/company_provider.dart';
import '../../../core/providers/warehouse_provider.dart';
import '../../../core/models/warehouse.dart';
import '../../../core/widgets/company_switcher.dart';
import '../models/stock_opname.dart';

class StockOpnameListScreen extends ConsumerStatefulWidget {
  const StockOpnameListScreen({super.key});

  @override
  ConsumerState<StockOpnameListScreen> createState() => _StockOpnameListScreenState();
}

class _StockOpnameListScreenState extends ConsumerState<StockOpnameListScreen> {
  bool _isCreating = false;

  Future<void> _createNewSession() async {
    final selectedCompany = ref.read(selectedCompanyProvider);
    if (selectedCompany == null) return;

    setState(() => _isCreating = true);

    List<Warehouse> allWarehouses = [];
    try {
      allWarehouses = await ref.read(warehousesProvider.future);
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Gagal Memuat Gudang'),
            content: Text('Terjadi kesalahan: $e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
      }
      setState(() => _isCreating = false);
      return;
    }

    setState(() => _isCreating = false);

    final companyWarehouses = allWarehouses.where((w) => w.companyId == selectedCompany.id).toList();

    if (companyWarehouses.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Gudang Tidak Ditemukan'),
          content: const Text('Perusahaan yang dipilih tidak memiliki gudang terdaftar.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
      return;
    }

    dynamic selectedWarehouse = companyWarehouses.first;
    final notesController = TextEditingController();

    final success = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => CupertinoAlertDialog(
          title: const Text('Mulai Opname Baru'),
          content: Container(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Pilih gudang sasaran untuk melakukan audit inventaris:', style: TextStyle(fontSize: 13)),
                const SizedBox(height: 12),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  color: CupertinoColors.secondarySystemBackground.resolveFrom(context),
                  borderRadius: BorderRadius.circular(6),
                  minSize: 0,
                  onPressed: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => CupertinoActionSheet(
                        title: const Text('Pilih Gudang'),
                        actions: companyWarehouses.map((w) {
                          return CupertinoActionSheetAction(
                            child: Text(w.name),
                            onPressed: () {
                              setDialogState(() {
                                selectedWarehouse = w;
                              });
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                        cancelButton: CupertinoActionSheetAction(
                          child: const Text('Batal'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedWarehouse.name,
                        style: TextStyle(color: CupertinoColors.label.resolveFrom(context), fontSize: 14),
                      ),
                      const Icon(CupertinoIcons.chevron_down, size: 14, color: CupertinoColors.secondaryLabel),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                CupertinoTextField(
                  controller: notesController,
                  placeholder: 'Catatan/Keterangan',
                  placeholderStyle: const TextStyle(color: CupertinoColors.placeholderText, fontSize: 13),
                  maxLines: 2,
                  decoration: BoxDecoration(
                    border: Border.all(color: CupertinoColors.separator),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.all(8),
                ),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Batal'),
              onPressed: () => Navigator.pop(context, false),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Buat'),
            ),
          ],
        ),
      ),
    );

    if (success == true) {
      setState(() => _isCreating = true);
      try {
        final repo = ref.read(stockOpnameRepositoryProvider);
        final session = await repo.createSession(
          warehouseId: selectedWarehouse.id,
          notes: notesController.text.trim().isNotEmpty ? notesController.text.trim() : null,
        );

        // Immediately start the counting (create snapshot)
        await repo.startSession(session.id);

        ref.invalidate(activeStockOpnameSessionsProvider);

        if (mounted) {
          context.push('/stock-opname/${session.id}');
        }
      } catch (e) {
        if (mounted) {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Gagal Membuat'),
              content: Text('Terjadi kesalahan: $e'),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isCreating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeSessionsAsync = ref.watch(activeStockOpnameSessionsProvider());

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
        middle: Text(
          'Stock Opname',
          style: TextStyle(color: CupertinoColors.label.resolveFrom(context)),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _isCreating ? null : _createNewSession,
          child: const Icon(CupertinoIcons.add, color: CupertinoColors.activeBlue, size: 22),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const CompanySwitcher(),
            Expanded(
              child: _isCreating
                  ? const Center(child: CupertinoActivityIndicator())
                  : activeSessionsAsync.when(
                      data: (sessions) {
                        if (sessions.isEmpty) {
                          return const Center(
                            child: Text(
                              'Tidak ada sesi opname aktif.',
                              style: TextStyle(color: CupertinoColors.secondaryLabel, fontSize: 15),
                            ),
                          );
                        }

                        return Scrollbar(
                          child: ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: sessions.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final session = sessions[index];
                              return _StockOpnameSessionCard(session: session);
                            },
                          ),
                        );
                      },
                      loading: () => const Center(child: CupertinoActivityIndicator()),
                      error: (err, _) => Center(child: Text('Gagal memuat sesi opname: $err')),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StockOpnameSessionCard extends StatelessWidget {
  final StockOpname session;

  const _StockOpnameSessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final String dateStr = _formatDate(session.startedAt);

    return GestureDetector(
      onTap: () {
        context.push('/stock-opname/${session.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: CupertinoColors.separator.resolveFrom(context),
            width: 0.5,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  session.opnameNumber,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: CupertinoColors.activeOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: CupertinoColors.activeOrange, width: 0.5),
                  ),
                  child: Text(
                    session.status.toUpperCase(),
                    style: const TextStyle(
                      color: CupertinoColors.activeOrange,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(CupertinoIcons.house, size: 14, color: CupertinoColors.secondaryLabel),
                const SizedBox(width: 6),
                Text(
                  session.warehouseName ?? 'Gudang Utama',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(CupertinoIcons.time, size: 14, color: CupertinoColors.secondaryLabel),
                const SizedBox(width: 6),
                Text(
                  'Dimulai: $dateStr',
                  style: const TextStyle(color: CupertinoColors.secondaryLabel, fontSize: 12),
                ),
              ],
            ),
            if (session.notes != null && session.notes!.isNotEmpty) ...[
              const Divider(color: CupertinoColors.separator, height: 16),
              Text(
                session.notes!,
                style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: CupertinoColors.secondaryLabel),
              ),
            ]
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final parsed = DateTime.parse(dateStr);
      return '${parsed.day.toString().padLeft(2, '0')}-${parsed.month.toString().padLeft(2, '0')}-${parsed.year}';
    } catch (e) {
      if (dateStr.length > 10) {
        return dateStr.substring(0, 10);
      }
      return dateStr;
    }
  }
}
