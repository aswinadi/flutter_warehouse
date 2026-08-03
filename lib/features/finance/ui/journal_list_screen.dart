import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/company_provider.dart';
import '../../../core/widgets/adaptive_layout_builder.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_loading_indicator.dart';
import '../../../core/widgets/cupertino_mesh_background.dart';
import '../models/journal_master.dart';
import '../services/accounting_api_service.dart';

class JournalListScreen extends ConsumerStatefulWidget {
  const JournalListScreen({super.key});

  @override
  ConsumerState<JournalListScreen> createState() => _JournalListScreenState();
}

class _JournalListScreenState extends ConsumerState<JournalListScreen> {
  String _selectedType = 'ALL';
  bool _isLoading = false;
  List<JournalMaster> _journals = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchJournals();
  }

  Future<void> _fetchJournals() async {
    final company = ref.read(currentCompanyProvider);
    if (company == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final api = ref.read(accountingApiServiceProvider);
      final results = await api.getJournals(
        company.id,
        journalType: _selectedType == 'ALL' ? null : _selectedType,
      );
      setState(() {
        _journals = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Jurnal Umum'),
      ),
      child: CupertinoMeshBackground(
        child: SafeArea(
          child: AdaptiveLayoutBuilder(
            mobileBuilder: (context, constraints) => _buildBody(currencyFormatter, isDesktop: false),
            desktopBuilder: (context, constraints) => _buildBody(currencyFormatter, isDesktop: true),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(NumberFormat currencyFormatter, {required bool isDesktop}) {
    return Padding(
      padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['ALL', 'AUTO', 'JV', 'JM', 'REV'].map((type) {
                final isSelected = _selectedType == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedType = type;
                      });
                      _fetchJournals();
                    },
                    child: CupertinoGlassContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      borderRadius: 20,
                      backgroundColor: isSelected ? CupertinoColors.activeBlue.withOpacity(0.2) : null,
                      borderColor: isSelected ? CupertinoColors.activeBlue : null,
                      child: Text(
                        type == 'ALL' ? 'Semua Tipe' : type,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? CupertinoColors.activeBlue : CupertinoColors.label,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // List Body
          Expanded(
            child: _isLoading
                ? const Center(child: CupertinoGlassLoadingIndicator())
                : _errorMessage != null
                    ? Center(child: Text(_errorMessage!, style: const TextStyle(color: CupertinoColors.systemRed)))
                    : _journals.isEmpty
                        ? const Center(child: Text('Belum ada jurnal transaksi.'))
                        : ListView.separated(
                            itemCount: _journals.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final journal = _journals[index];
                              return CupertinoGlassContainer(
                                padding: const EdgeInsets.all(16),
                                borderRadius: 16,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          journal.journalNumber,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _getTypeColor(journal.journalType).withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            journal.journalType,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: _getTypeColor(journal.journalType),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      journal.description ?? '-',
                                      style: const TextStyle(color: CupertinoColors.secondaryLabel, fontSize: 14),
                                    ),
                                    const SizedBox(height: 12),

                                    // Line items list
                                    ...journal.details.map((detail) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                '${detail.coaCode} - ${detail.coaName}',
                                                style: const TextStyle(fontSize: 13),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                detail.debit > 0
                                                    ? currencyFormatter.format(detail.debit)
                                                    : currencyFormatter.format(detail.credit),
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: detail.debit > 0
                                                      ? CupertinoColors.activeGreen
                                                      : CupertinoColors.systemRed,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'AUTO':
        return CupertinoColors.activeBlue;
      case 'JV':
        return CupertinoColors.activeOrange;
      case 'JM':
        return CupertinoColors.systemPurple;
      case 'REV':
        return CupertinoColors.systemRed;
      default:
        return CupertinoColors.systemGrey;
    }
  }
}
