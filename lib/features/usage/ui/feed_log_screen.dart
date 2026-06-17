import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/widgets/company_switcher.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_dialog.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';
import '../models/feed_log.dart';
import '../providers/feed_log_provider.dart';
import 'package:flutter_app/l10n/app_localizations.dart';

class FeedLogScreen extends ConsumerStatefulWidget {
  const FeedLogScreen({super.key});

  @override
  ConsumerState<FeedLogScreen> createState() => _FeedLogScreenState();
}

class _FeedLogScreenState extends ConsumerState<FeedLogScreen> {
  final ScrollController _scrollController = ScrollController();

  final _feedCodeController = TextEditingController();
  final _amountController = TextEditingController();
  final _docController = TextEditingController();
  final _notesController = TextEditingController();

  AquacultureCycle? _selectedCycle;
  AquaculturePond? _selectedPond;
  DateTime _selectedDate = DateTime.now();

  FeedLog? _editingLog;
  bool _isSubmitting = false;

  // Tabs
  int _selectedSegment = 0;

  // Filters for History Tab
  AquacultureCycle? _filterCycle;
  AquaculturePond? _filterPond;
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _feedCodeController.dispose();
    _amountController.dispose();
    _docController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll * 0.9) {
      ref.read(feedLogsListProvider(
        cycleId: _filterCycle?.id,
        pondId: _filterPond?.id,
        startDate: _filterStartDate != null
            ? DateFormat('yyyy-MM-dd').format(_filterStartDate!)
            : null,
        endDate: _filterEndDate != null
            ? DateFormat('yyyy-MM-dd').format(_filterEndDate!)
            : null,
      ).notifier).loadMore();
    }
  }

  void _calculateDoc() {
    if (_selectedCycle == null || _selectedCycle!.stockingDate == null) {
      return;
    }
    try {
      final stockingDate = DateTime.parse(_selectedCycle!.stockingDate!);
      final diff = _selectedDate.difference(stockingDate).inDays + 1;
      if (diff >= 0) {
        _docController.text = diff.toString();
      } else {
        _docController.clear();
      }
    } catch (_) {
      _docController.clear();
    }
  }

  void _showCupertinoDatePicker({
    required DateTime initialDate,
    required ValueChanged<DateTime> onDateSelected,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        DateTime tempDate = initialDate;
        return Container(
          height: 300,
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
                      onPressed: () => Navigator.pop(context),
                    ),
                    CupertinoButton(
                      child: const Text('Selesai'),
                      onPressed: () {
                        onDateSelected(tempDate);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: initialDate,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (date) {
                    tempDate = date;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCyclePicker(List<AquacultureCycle> cycles, {bool isFilter = false}) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(isFilter ? 'Filter Siklus' : 'Pilih Siklus'),
        actions: [
          if (isFilter)
            CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  _filterCycle = null;
                  _filterPond = null;
                });
                Navigator.pop(context);
              },
              child: const Text('Semua Siklus'),
            ),
          ...cycles.map((c) {
            return CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  if (isFilter) {
                    _filterCycle = c;
                    _filterPond = null;
                  } else {
                    _selectedCycle = c;
                    _selectedPond = null;
                    _calculateDoc();
                  }
                });
                Navigator.pop(context);
              },
              child: Text(c.name),
            );
          }),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
      ),
    );
  }

  void _showPondPicker(List<AquaculturePond> ponds, {bool isFilter = false}) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(isFilter ? 'Filter Kolam' : 'Pilih Kolam'),
        actions: [
          if (isFilter)
            CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  _filterPond = null;
                });
                Navigator.pop(context);
              },
              child: const Text('Semua Kolam'),
            ),
          ...ponds.map((p) {
            return CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  if (isFilter) {
                    _filterPond = p;
                  } else {
                    _selectedPond = p;
                  }
                });
                Navigator.pop(context);
              },
              child: Text(p.name + (p.code != null ? ' (${p.code})' : '')),
            );
          }),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
      ),
    );
  }

  void _showNotification(String message, {bool isError = false}) {
    if (!mounted) return;
    if (isError) {
      CupertinoGlassToast.showError(context, message);
    } else {
      CupertinoGlassToast.showSuccess(context, message);
    }
  }

  void _resetForm() {
    setState(() {
      _editingLog = null;
      _selectedCycle = null;
      _selectedPond = null;
      _selectedDate = DateTime.now();
      _feedCodeController.clear();
      _amountController.clear();
      _docController.clear();
      _notesController.clear();
    });
  }

  void _loadForEdit(FeedLog log, List<AquacultureCycle> cycles, List<AquaculturePond> ponds) {
    setState(() {
      _editingLog = log;
      _selectedDate = DateTime.parse(log.date);
      _feedCodeController.text = log.feedCode ?? '';
      _amountController.text = log.amountKg.toString();
      _docController.text = log.doc?.toString() ?? '';
      _notesController.text = log.notes ?? '';

      try {
        _selectedCycle = cycles.firstWhere((c) => c.id == log.cycleId);
      } catch (_) {
        _selectedCycle = null;
      }

      try {
        _selectedPond = ponds.firstWhere((p) => p.id == log.pondId);
      } catch (_) {
        _selectedPond = null;
      }
    });
  }

  Future<void> _submitForm(bool isWide) async {
    if (_selectedCycle == null || _selectedPond == null) {
      _showNotification('Harap pilih Siklus dan Kolam', isError: true);
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showNotification('Harap masukkan jumlah pakan yang valid', isError: true);
      return;
    }

    int? doc;
    if (_docController.text.isNotEmpty) {
      doc = int.tryParse(_docController.text);
      if (doc == null) {
        _showNotification('Harap masukkan angka DOC yang valid', isError: true);
        return;
      }
    }

    setState(() {
      _isSubmitting = true;
    });

    final repository = ref.read(feedLogRepositoryProvider);

    final payload = {
      'cycle_id': _selectedCycle!.id,
      'pond_id': _selectedPond!.id,
      'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
      'feed_code': _feedCodeController.text.trim().isEmpty ? null : _feedCodeController.text.trim(),
      'amount_kg': amount,
      'doc': doc,
      'notes': _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    };

    try {
      if (_editingLog == null) {
        await repository.createFeedLog(payload);
        _showNotification('Log pakan berhasil dicatat.');
      } else {
        await repository.updateFeedLog(_editingLog!.id, payload);
        _showNotification('Log pakan berhasil diperbarui.');
      }

      _resetForm();
      ref.invalidate(feedLogsListProvider);

      if (!isWide) {
        setState(() {
          _selectedSegment = 1;
        });
      }
    } catch (e) {
      _showNotification('Gagal menyimpan data: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _deleteLog(int id) async {
    final confirm = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoGlassDialog(
        title: const Text('Hapus Log Pakan'),
        content: const Text('Apakah Anda yakin ingin menghapus data log pakan ini?'),
        actions: [
          CupertinoGlassDialogAction(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          CupertinoGlassDialogAction(
            isDestructive: true,
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ref.read(feedLogRepositoryProvider).deleteFeedLog(id);
        _showNotification('Log pakan berhasil dihapus.');
        ref.invalidate(feedLogsListProvider);
      } catch (e) {
        _showNotification('Gagal menghapus data: $e', isError: true);
      }
    }
  }

  Widget _buildSelectField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.subhead.copyWith(
            fontWeight: FontWeight.w600,
            color: labelColor,
          ),
        ),
        const SizedBox(height: CupertinoSpacing.xs),
        GestureDetector(
          onTap: onTap,
          child: CupertinoGlassContainer(
            padding: const EdgeInsets.symmetric(
              horizontal: CupertinoSpacing.m,
              vertical: CupertinoSpacing.m,
            ),
            borderRadius: CupertinoSpacing.buttonRadius,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: context.subhead.copyWith(color: labelColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(CupertinoIcons.chevron_down, size: 14, color: secondaryLabel),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    final l10n = AppLocalizations.of(context)!;
    final bgColor = CupertinoColors.systemGroupedBackground.resolveFrom(context);
    final navBarBg = CupertinoColors.systemBackground.resolveFrom(context);

    final cyclesAsync = ref.watch(feedCyclesProvider);
    final pondsAsync = ref.watch(feedPondsProvider(cycleId: _selectedCycle?.id));
    final filterPondsAsync = ref.watch(feedPondsProvider(cycleId: _filterCycle?.id));

    final cycles = cyclesAsync.maybeWhen(data: (list) => list, orElse: () => <AquacultureCycle>[]);
    final ponds = pondsAsync.maybeWhen(data: (list) => list, orElse: () => <AquaculturePond>[]);
    final filterPonds = filterPondsAsync.maybeWhen(data: (list) => list, orElse: () => <AquaculturePond>[]);

    return CupertinoPageScaffold(
      backgroundColor: bgColor,
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.feedManagement),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const CompanySwitcher(),
            if (!isWide)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: navBarBg,
                child: CupertinoSlidingSegmentedControl<int>(
                  groupValue: _selectedSegment,
                  children: {
                    0: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(CupertinoIcons.pencil_ellipsis_rectangle, size: 16),
                          const SizedBox(width: 6),
                          Text(l10n.addFeedLog, style: const TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                    1: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(CupertinoIcons.clock, size: 16),
                          const SizedBox(width: 6),
                          Text(l10n.feedLog, style: const TextStyle(fontSize: 13)),
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
              child: isWide
                  ? Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: _buildHistoryPane(cycles, filterPonds),
                        ),
                        Container(width: 0.5, color: CupertinoColors.separator.resolveFrom(context)),
                        Expanded(
                          flex: 4,
                          child: _buildFormPane(cycles, ponds, true),
                        ),
                      ],
                    )
                  : IndexedStack(
                      index: _selectedSegment,
                      children: [
                        _buildFormPane(cycles, ponds, false),
                        _buildHistoryPane(cycles, filterPonds),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormPane(List<AquacultureCycle> cycles, List<AquaculturePond> ponds, bool isWide) {
    final l10n = AppLocalizations.of(context)!;
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final borderCol = CupertinoColors.separator.resolveFrom(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _editingLog != null ? 'Ubah Catatan Pakan' : l10n.addFeedLog,
            style: context.title3.copyWith(
              fontWeight: FontWeight.bold,
              color: labelColor,
            ),
          ),
          const SizedBox(height: CupertinoSpacing.l),
          CupertinoGlassContainer(
            borderRadius: CupertinoSpacing.cardRadius,
            padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Cycle
                _buildSelectField(
                  label: l10n.cycle,
                  value: _selectedCycle != null ? _selectedCycle!.name : 'Pilih Siklus',
                  onTap: () => _showCyclePicker(cycles),
                ),
                const SizedBox(height: CupertinoSpacing.l),

                // Pond
                _buildSelectField(
                  label: l10n.pond,
                  value: _selectedPond != null
                      ? (_selectedPond!.name + (_selectedPond!.code != null ? ' (${_selectedPond!.code})' : ''))
                      : 'Pilih Kolam',
                  onTap: () => _showPondPicker(ponds),
                ),
                const SizedBox(height: CupertinoSpacing.l),

                // Date
                _buildSelectField(
                  label: 'Tanggal',
                  value: DateFormat('yyyy-MM-dd').format(_selectedDate),
                  onTap: () => _showCupertinoDatePicker(
                    initialDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                      _calculateDoc();
                    },
                  ),
                ),
                const SizedBox(height: CupertinoSpacing.l),

                // Feed Code
                Text(
                  l10n.feedCode,
                  style: context.subhead.copyWith(fontWeight: FontWeight.w600, color: labelColor),
                ),
                const SizedBox(height: CupertinoSpacing.xs),
                CupertinoTextField(
                  controller: _feedCodeController,
                  placeholder: 'Masukkan Kode Pakan',
                  padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.m, vertical: CupertinoSpacing.m),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground.resolveFrom(context),
                    border: Border.all(color: borderCol, width: 0.5),
                    borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                  ),
                ),
                const SizedBox(height: CupertinoSpacing.l),

                // Amount
                Text(
                  l10n.amountKg,
                  style: context.subhead.copyWith(fontWeight: FontWeight.w600, color: labelColor),
                ),
                const SizedBox(height: CupertinoSpacing.xs),
                CupertinoTextField(
                  controller: _amountController,
                  placeholder: '0.0',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  suffix: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text('kg', style: context.subhead.copyWith(color: secondaryLabel)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.m, vertical: CupertinoSpacing.m),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground.resolveFrom(context),
                    border: Border.all(color: borderCol, width: 0.5),
                    borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                  ),
                ),
                const SizedBox(height: CupertinoSpacing.l),

                // DOC
                Text(
                  l10n.doc,
                  style: context.subhead.copyWith(fontWeight: FontWeight.w600, color: labelColor),
                ),
                const SizedBox(height: CupertinoSpacing.xs),
                CupertinoTextField(
                  controller: _docController,
                  placeholder: 'Masukkan DOC',
                  keyboardType: TextInputType.number,
                  suffix: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text('Hari', style: context.subhead.copyWith(color: secondaryLabel)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.m, vertical: CupertinoSpacing.m),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground.resolveFrom(context),
                    border: Border.all(color: borderCol, width: 0.5),
                    borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                  ),
                ),
                const SizedBox(height: CupertinoSpacing.xs),
                Text(
                  'Terisi otomatis jika Siklus & Tanggal dipilih',
                  style: context.caption1.copyWith(color: secondaryLabel),
                ),
                const SizedBox(height: CupertinoSpacing.l),

                // Notes
                Text(
                  'Catatan',
                  style: context.subhead.copyWith(fontWeight: FontWeight.w600, color: labelColor),
                ),
                const SizedBox(height: CupertinoSpacing.xs),
                CupertinoTextField(
                  controller: _notesController,
                  placeholder: 'Tambahkan catatan jika ada',
                  maxLines: 3,
                  padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.m, vertical: CupertinoSpacing.m),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground.resolveFrom(context),
                    border: Border.all(color: borderCol, width: 0.5),
                    borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: CupertinoSpacing.xl),
          Row(
            children: [
              if (_editingLog != null) ...[
                Expanded(
                  child: CupertinoButton(
                    onPressed: _resetForm,
                    color: const CupertinoDynamicColor.withBrightness(
                      color: Color(0xFFE5E5EA),
                      darkColor: Color(0xFF2C2C2E),
                    ).resolveFrom(context),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                    child: Text(
                      'BATAL',
                      style: TextStyle(
                        color: CupertinoColors.label.resolveFrom(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: CupertinoSpacing.m),
              ],
              Expanded(
                child: CupertinoButton.filled(
                  onPressed: _isSubmitting ? null : () => _submitForm(isWide),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  borderRadius: BorderRadius.circular(CupertinoSpacing.buttonRadius),
                  child: _isSubmitting
                      ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                      : Text(
                          _editingLog != null ? 'PERBARUI' : 'SIMPAN',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryPane(List<AquacultureCycle> cycles, List<AquaculturePond> ponds) {
    final listAsync = ref.watch(feedLogsListProvider(
      cycleId: _filterCycle?.id,
      pondId: _filterPond?.id,
      startDate: _filterStartDate != null
          ? DateFormat('yyyy-MM-dd').format(_filterStartDate!)
          : null,
      endDate: _filterEndDate != null
          ? DateFormat('yyyy-MM-dd').format(_filterEndDate!)
          : null,
    ));

    final borderCol = CupertinoColors.separator.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return Column(
      children: [
        _buildFilterBar(cycles, ponds),
        Expanded(
          child: listAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(CupertinoSpacing.xxl),
                    child: Text(
                      'Tidak ada data log pakan untuk kriteria filter ini.',
                      style: context.subhead.copyWith(color: CupertinoColors.inactiveGray.resolveFrom(context)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              final notifier = ref.read(feedLogsListProvider(
                cycleId: _filterCycle?.id,
                pondId: _filterPond?.id,
                startDate: _filterStartDate != null
                    ? DateFormat('yyyy-MM-dd').format(_filterStartDate!)
                    : null,
                endDate: _filterEndDate != null
                    ? DateFormat('yyyy-MM-dd').format(_filterEndDate!)
                    : null,
              ).notifier);

              return CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: () => notifier.refresh(),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(CupertinoSpacing.m),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == items.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: CupertinoSpacing.l),
                                child: CupertinoActivityIndicator(),
                              ),
                            );
                          }

                          final item = items[index];
                          final pondName = item.pondName;

                          return CupertinoGlassContainer(
                            margin: const EdgeInsets.only(bottom: CupertinoSpacing.s),
                            borderRadius: CupertinoSpacing.cardRadius,
                            borderColor: _editingLog?.id == item.id
                                ? CupertinoColors.activeBlue.resolveFrom(context)
                                : borderCol,
                            padding: const EdgeInsets.all(CupertinoSpacing.m),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.activeBlue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.circle_grid_hex_fill,
                                    color: CupertinoColors.activeBlue,
                                  ),
                                ),
                                const SizedBox(width: CupertinoSpacing.m),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              [
                                                item.tambakName,
                                                item.blokName,
                                                item.modulName,
                                                pondName != null
                                                    ? (int.tryParse(pondName) != null
                                                        ? pondName.padLeft(2, '0')
                                                        : pondName)
                                                    : null
                                              ].where((s) => s != null && s.isNotEmpty).join(' - '),
                                              style: context.subhead.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: labelColor,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: CupertinoSpacing.s),
                                          Text(
                                            item.date,
                                            style: context.caption1.copyWith(color: secondaryLabel),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: CupertinoSpacing.xs),
                                      Text(
                                        'Siklus: ${item.cycleName ?? "-"}',
                                        style: context.footnote.copyWith(color: labelColor.withValues(alpha: 0.8)),
                                      ),
                                      const SizedBox(height: CupertinoSpacing.xs),
                                      Row(
                                        children: [
                                          if (item.feedCode != null) ...[
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: const CupertinoDynamicColor.withBrightness(
                                                  color: Color(0xFFF2F2F7),
                                                  darkColor: Color(0xFF1C1C1E),
                                                ).resolveFrom(context),
                                                border: Border.all(color: borderCol),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                'Pakan: ${item.feedCode}',
                                                style: context.caption2.copyWith(color: labelColor),
                                              ),
                                            ),
                                            const SizedBox(width: CupertinoSpacing.s),
                                          ],
                                          if (item.doc != null)
                                            Text(
                                              'DOC: ${item.doc} Hari',
                                              style: context.caption1.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: labelColor,
                                              ),
                                            ),
                                        ],
                                      ),
                                      if (item.notes != null) ...[
                                        const SizedBox(height: CupertinoSpacing.xs),
                                        Text(
                                          'Ket: ${item.notes}',
                                          style: context.caption1.copyWith(
                                            fontStyle: FontStyle.italic,
                                            color: secondaryLabel,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(width: CupertinoSpacing.m),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${item.amountKg.toStringAsFixed(1)} kg',
                                      style: context.subhead.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: CupertinoColors.activeBlue,
                                      ),
                                    ),
                                    const SizedBox(height: CupertinoSpacing.s),
                                    Row(
                                      children: [
                                        CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            _loadForEdit(item, cycles, ponds);
                                            final isWideLayout = MediaQuery.of(context).size.width > 900;
                                            if (!isWideLayout) {
                                              setState(() {
                                                _selectedSegment = 0;
                                              });
                                            }
                                          },
                                          child: const Icon(CupertinoIcons.pencil, size: 20, color: CupertinoColors.inactiveGray),
                                        ),
                                        const SizedBox(width: CupertinoSpacing.xs),
                                        CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () => _deleteLog(item.id),
                                          child: const Icon(CupertinoIcons.trash, size: 20, color: CupertinoColors.destructiveRed),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: items.length + (notifier.hasMore ? 1 : 0),
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CupertinoActivityIndicator()),
            error: (err, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(CupertinoSpacing.screenMargin),
                child: Text(
                  'Gagal memuat riwayat pakan: $err',
                  style: const TextStyle(color: CupertinoColors.destructiveRed),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar(List<AquacultureCycle> cycles, List<AquaculturePond> ponds) {
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);

    return Container(
      color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.m, vertical: CupertinoSpacing.m),
      child: Column(
        children: [
          Row(
            children: [
              // Cycle filter
              Expanded(
                child: _buildSelectField(
                  label: 'Siklus',
                  value: _filterCycle != null ? _filterCycle!.name : 'Semua Siklus',
                  onTap: () => _showCyclePicker(cycles, isFilter: true),
                ),
              ),
              const SizedBox(width: CupertinoSpacing.s),

              // Pond filter
              Expanded(
                child: _buildSelectField(
                  label: 'Kolam',
                  value: _filterPond != null
                      ? (_filterPond!.name + (_filterPond!.code != null ? ' (${_filterPond!.code})' : ''))
                      : 'Semua Kolam',
                  onTap: () => _showPondPicker(ponds, isFilter: true),
                ),
              ),
            ],
          ),
          const SizedBox(height: CupertinoSpacing.s),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _showCupertinoDatePicker(
                    initialDate: _filterStartDate ?? DateTime.now(),
                    onDateSelected: (date) {
                      setState(() {
                        _filterStartDate = date;
                      });
                    },
                  ),
                  child: CupertinoGlassContainer(
                    padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.s, vertical: CupertinoSpacing.m),
                    borderRadius: CupertinoSpacing.buttonRadius,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _filterStartDate == null
                              ? 'Tgl Mulai'
                              : DateFormat('dd/MM/yy').format(_filterStartDate!),
                          style: context.subhead.copyWith(color: CupertinoColors.label.resolveFrom(context)),
                        ),
                        Icon(CupertinoIcons.calendar, size: 14, color: secondaryLabel),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: CupertinoSpacing.s),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showCupertinoDatePicker(
                    initialDate: _filterEndDate ?? DateTime.now(),
                    onDateSelected: (date) {
                      setState(() {
                        _filterEndDate = date;
                      });
                    },
                  ),
                  child: CupertinoGlassContainer(
                    padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.s, vertical: CupertinoSpacing.m),
                    borderRadius: CupertinoSpacing.buttonRadius,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _filterEndDate == null
                              ? 'Tgl Selesai'
                              : DateFormat('dd/MM/yy').format(_filterEndDate!),
                          style: context.subhead.copyWith(color: CupertinoColors.label.resolveFrom(context)),
                        ),
                        Icon(CupertinoIcons.calendar, size: 14, color: secondaryLabel),
                      ],
                    ),
                  ),
                ),
              ),
              if (_filterCycle != null || _filterPond != null || _filterStartDate != null || _filterEndDate != null) ...[
                const SizedBox(width: CupertinoSpacing.s),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.clear_circled_solid, color: CupertinoColors.destructiveRed, size: 28),
                  onPressed: () {
                    setState(() {
                      _filterCycle = null;
                      _filterPond = null;
                      _filterStartDate = null;
                      _filterEndDate = null;
                    });
                  },
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
