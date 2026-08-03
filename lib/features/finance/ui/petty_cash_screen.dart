import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/company_provider.dart';
import '../../../core/widgets/adaptive_layout_builder.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_loading_indicator.dart';
import '../../../core/widgets/cupertino_mesh_background.dart';
import '../models/petty_cash.dart';
import '../services/accounting_api_service.dart';

class PettyCashScreen extends ConsumerStatefulWidget {
  const PettyCashScreen({super.key});

  @override
  ConsumerState<PettyCashScreen> createState() => _PettyCashScreenState();
}

class _PettyCashScreenState extends ConsumerState<PettyCashScreen> {
  bool _isLoading = false;
  List<PettyCashTransaction> _transactions = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPettyCash();
  }

  Future<void> _fetchPettyCash() async {
    final company = ref.read(currentCompanyProvider);
    if (company == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final api = ref.read(accountingApiServiceProvider);
      final list = await api.getPettyCash(company.id);
      setState(() {
        _transactions = list;
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
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Pengajuan Kas Kecil'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            // Open Create Form
          },
          child: const Icon(CupertinoIcons.add_circled),
        ),
      ),
      child: CupertinoMeshBackground(
        child: SafeArea(
          child: AdaptiveLayoutBuilder(
            mobileBuilder: (context, constraints) => _buildBody(currency, isDesktop: false),
            desktopBuilder: (context, constraints) => _buildBody(currency, isDesktop: true),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(NumberFormat currency, {required bool isDesktop}) {
    return Padding(
      padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CupertinoGlassLoadingIndicator())
                : _errorMessage != null
                    ? Center(child: Text(_errorMessage!, style: const TextStyle(color: CupertinoColors.systemRed)))
                    : _transactions.isEmpty
                        ? const Center(child: Text('Belum ada transaksi kas kecil.'))
                        : ListView.separated(
                            itemCount: _transactions.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = _transactions[index];
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
                                          currency.format(item.amount),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: CupertinoColors.activeBlue,
                                          ),
                                        ),
                                        _buildStatusBadge(item.status),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item.description,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Akun COA: ${item.coaCode}',
                                          style: const TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel),
                                        ),
                                        Text(
                                          item.transactionDate,
                                          style: const TextStyle(fontSize: 12, color: CupertinoColors.secondaryLabel),
                                        ),
                                      ],
                                    ),
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

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;

    switch (status) {
      case 'approved':
      case 'posted':
        color = CupertinoColors.activeGreen;
        label = 'Disetujui';
        break;
      case 'rejected':
        color = CupertinoColors.systemRed;
        label = 'Ditolak';
        break;
      default:
        color = CupertinoColors.activeOrange;
        label = 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
