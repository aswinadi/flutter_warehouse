import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/company_switcher.dart';
import '../models/feed_log.dart';
import '../providers/feed_log_provider.dart';
import 'package:flutter_app/l10n/app_localizations.dart';

class FeedLogScreen extends ConsumerStatefulWidget {
  const FeedLogScreen({super.key});

  @override
  ConsumerState<FeedLogScreen> createState() => _FeedLogScreenState();
}

class _FeedLogScreenState extends ConsumerState<FeedLogScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  final _formKey = GlobalKey<FormState>();
  final _feedCodeController = TextEditingController();
  final _amountController = TextEditingController();
  final _docController = TextEditingController();
  final _notesController = TextEditingController();

  AquacultureCycle? _selectedCycle;
  AquaculturePond? _selectedPond;
  DateTime _selectedDate = DateTime.now();

  FeedLog? _editingLog;
  bool _isSubmitting = false;

  // Filters for History Tab
  AquacultureCycle? _filterCycle;
  AquaculturePond? _filterPond;
  DateTimeRange? _filterDateRange;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
        startDate: _filterDateRange?.start != null
            ? DateFormat('Y-MM-dd').format(_filterDateRange!.start)
            : null,
        endDate: _filterDateRange?.end != null
            ? DateFormat('Y-MM-dd').format(_filterDateRange!.end)
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
      // Calculate difference in days. DOC is 1-indexed (stocking date is Day 1)
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _calculateDoc();
    }
  }

  Future<void> _selectFilterDateRange() async {
    final pickedRange = await showDateRangePicker(
      context: context,
      initialDateRange: _filterDateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (pickedRange != null) {
      setState(() {
        _filterDateRange = pickedRange;
      });
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

      // Match selected cycle and pond
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
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCycle == null || _selectedPond == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap pilih Siklus dan Kolam')),
      );
      return;
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
      'amount_kg': double.tryParse(_amountController.text) ?? 0.0,
      'doc': int.tryParse(_docController.text),
      'notes': _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    };

    try {
      if (_editingLog == null) {
        await repository.createFeedLog(payload);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Log pakan berhasil dicatat.')),
        );
      } else {
        await repository.updateFeedLog(_editingLog!.id, payload);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Log pakan berhasil diperbarui.')),
        );
      }

      _resetForm();

      // Refresh list
      ref.invalidate(feedLogsListProvider);

      if (!isWide) {
        _tabController.animateTo(1);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _deleteLog(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Log Pakan'),
        content: const Text('Apakah Anda yakin ingin menghapus data log pakan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('BATAL'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('HAPUS'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ref.read(feedLogRepositoryProvider).deleteFeedLog(id);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Log pakan berhasil dihapus.')),
        );
        ref.invalidate(feedLogsListProvider);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    final l10n = AppLocalizations.of(context)!;

    final cyclesAsync = ref.watch(feedCyclesProvider);
    final pondsAsync = ref.watch(feedPondsProvider);

    final cycles = cyclesAsync.maybeWhen(data: (list) => list, orElse: () => <AquacultureCycle>[]);
    final ponds = pondsAsync.maybeWhen(data: (list) => list, orElse: () => <AquaculturePond>[]);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.feedManagement),
        bottom: isWide
            ? null
            : TabBar(
                controller: _tabController,
                indicatorColor: Theme.of(context).colorScheme.primary,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(icon: const Icon(Icons.edit_note), text: l10n.addFeedLog),
                  Tab(icon: const Icon(Icons.history), text: l10n.feedLog),
                ],
              ),
      ),
      body: Column(
        children: [
          const CompanySwitcher(),
          Expanded(
            child: isWide
                ? Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: _buildHistoryPane(cycles, ponds),
                      ),
                      const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                      Expanded(
                        flex: 4,
                        child: _buildFormPane(cycles, ponds, true),
                      ),
                    ],
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildFormPane(cycles, ponds, false),
                      _buildHistoryPane(cycles, ponds),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormPane(List<AquacultureCycle> cycles, List<AquaculturePond> ponds, bool isWide) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _editingLog != null ? 'Ubah Catatan Pakan' : l10n.addFeedLog,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Cycle Dropdown
                    DropdownButtonFormField<AquacultureCycle>(
                      value: _selectedCycle,
                      decoration: InputDecoration(
                        labelText: l10n.cycle,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      items: cycles.map((c) {
                        return DropdownMenuItem(
                          value: c,
                          child: Text(c.name),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedCycle = val;
                        });
                        _calculateDoc();
                      },
                      validator: (value) => value == null ? 'Harap pilih siklus' : null,
                    ),
                    const SizedBox(height: 16),

                    // Pond Dropdown
                    DropdownButtonFormField<AquaculturePond>(
                      value: _selectedPond,
                      decoration: InputDecoration(
                        labelText: l10n.pond,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      items: ponds.map((p) {
                        return DropdownMenuItem(
                          value: p,
                          child: Text(p.name + (p.code != null ? ' (${p.code})' : '')),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedPond = val;
                        });
                      },
                      validator: (value) => value == null ? 'Harap pilih kolam' : null,
                    ),
                    const SizedBox(height: 16),

                    // Date Picker Input
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Tanggal',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        child: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Feed Code
                    TextFormField(
                      controller: _feedCodeController,
                      decoration: InputDecoration(
                        labelText: l10n.feedCode,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Feed Amount
                    TextFormField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: l10n.amountKg,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        suffixText: 'kg',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Harap masukkan jumlah pakan';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Harap masukkan angka desimal valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // DOC
                    TextFormField(
                      controller: _docController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.doc,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        suffixText: 'Hari',
                        helperText: 'Terisi otomatis jika Siklus & Tanggal dipilih',
                      ),
                      validator: (value) {
                        if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                          return 'Harap masukkan angka bulat valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Notes
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Catatan',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                if (_editingLog != null) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _resetForm,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('BATAL'),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : () => _submitForm(isWide),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(_editingLog != null ? 'PERBARUI' : 'SIMPAN'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryPane(List<AquacultureCycle> cycles, List<AquaculturePond> ponds) {
    final theme = Theme.of(context);

    // Retrieve active log list with filters
    final listAsync = ref.watch(feedLogsListProvider(
      cycleId: _filterCycle?.id,
      pondId: _filterPond?.id,
      startDate: _filterDateRange?.start != null
          ? DateFormat('yyyy-MM-dd').format(_filterDateRange!.start)
          : null,
      endDate: _filterDateRange?.end != null
          ? DateFormat('yyyy-MM-dd').format(_filterDateRange!.end)
          : null,
    ));

    return Column(
      children: [
        // Filter bar
        _buildFilterBar(cycles, ponds),
        // Feed logs list
        Expanded(
          child: listAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return const Center(
                  child: Text(
                    'Tidak ada data log pakan untuk kriteria filter ini.',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              final notifier = ref.read(feedLogsListProvider(
                cycleId: _filterCycle?.id,
                pondId: _filterPond?.id,
                startDate: _filterDateRange?.start != null
                    ? DateFormat('yyyy-MM-dd').format(_filterDateRange!.start)
                    : null,
                endDate: _filterDateRange?.end != null
                    ? DateFormat('yyyy-MM-dd').format(_filterDateRange!.end)
                    : null,
              ).notifier);

              return RefreshIndicator(
                onRefresh: () => notifier.refresh(),
                child: ListView.separated(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length + (notifier.hasMore ? 1 : 0),
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    if (index == items.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final item = items[index];

                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: _editingLog?.id == item.id
                              ? theme.colorScheme.primary
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.bubble_chart,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item.pondName ?? 'Kolam',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                      Text(
                                        item.date,
                                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Siklus: ${item.cycleName ?? "-"}',
                                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      if (item.feedCode != null) ...[
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            border: Border.all(color: Colors.grey.shade300),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            'Pakan: ${item.feedCode}',
                                            style: const TextStyle(fontSize: 11),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                      if (item.doc != null)
                                        Text(
                                          'DOC: ${item.doc} Hari',
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                        ),
                                    ],
                                  ),
                                  if (item.notes != null) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      'Ket: ${item.notes}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${item.amountKg.toStringAsFixed(1)} kg',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
                                      onPressed: () {
                                        _loadForEdit(item, cycles, ponds);
                                        // If mobile layout, switch to Form tab
                                        final isWideLayout = MediaQuery.of(context).size.width > 900;
                                        if (!isWideLayout) {
                                          _tabController.animateTo(0);
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                      onPressed: () => _deleteLog(item.id),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Gagal memuat riwayat pakan: $err',
                  style: const TextStyle(color: Colors.red),
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
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              // Cycle filter
              Expanded(
                child: DropdownButtonFormField<AquacultureCycle?>(
                  value: _filterCycle,
                  decoration: const InputDecoration(
                    labelText: 'Siklus',
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: [
                    const DropdownMenuItem<AquacultureCycle?>(
                      value: null,
                      child: Text('Semua Siklus'),
                    ),
                    ...cycles.map((c) => DropdownMenuItem(value: c, child: Text(c.name))),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _filterCycle = val;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),

              // Pond filter
              Expanded(
                child: DropdownButtonFormField<AquaculturePond?>(
                  value: _filterPond,
                  decoration: const InputDecoration(
                    labelText: 'Kolam',
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: [
                    const DropdownMenuItem<AquaculturePond?>(
                      value: null,
                      child: Text('Semua Kolam'),
                    ),
                    ...ponds.map((p) => DropdownMenuItem(value: p, child: Text(p.name))),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _filterPond = val;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _selectFilterDateRange,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _filterDateRange == null
                              ? 'Semua Periode Tanggal'
                              : 'Periode: ${DateFormat('dd/MM/yy').format(_filterDateRange!.start)} - ${DateFormat('dd/MM/yy').format(_filterDateRange!.end)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const Icon(Icons.date_range, size: 16, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
              if (_filterCycle != null || _filterPond != null || _filterDateRange != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.filter_list_off, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _filterCycle = null;
                      _filterPond = null;
                      _filterDateRange = null;
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
