import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/company_provider.dart';
import '../../../core/widgets/adaptive_layout_builder.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_loading_indicator.dart';
import '../../../core/widgets/cupertino_mesh_background.dart';

class BankReconciliationScreen extends ConsumerStatefulWidget {
  const BankReconciliationScreen({super.key});

  @override
  ConsumerState<BankReconciliationScreen> createState() => _BankReconciliationScreenState();
}

class _BankReconciliationScreenState extends ConsumerState<BankReconciliationScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Rekonsiliasi Bank'),
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
    final company = ref.watch(currentCompanyProvider);

    return Padding(
      padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CupertinoGlassContainer(
            padding: const EdgeInsets.all(20),
            borderRadius: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    Text(
                      company?.name ?? 'Perusahaan',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    CupertinoButton.filled(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      borderRadius: BorderRadius.circular(12),
                      onPressed: () {
                        // Action for import bank statement
                      },
                      child: const Text('Impor Mutasi Bank', style: TextStyle(fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Fitur ini mencocokkan secara otomatis mutasi rekening bank dengan jurnal akuntansi di General Ledger (GL).',
                  style: TextStyle(color: CupertinoColors.secondaryLabel, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Sesi Rekonsiliasi Terakhir',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: CupertinoGlassContainer(
              padding: const EdgeInsets.all(16),
              borderRadius: 16,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.doc_checkmark_seal, size: 48, color: CupertinoColors.activeBlue),
                    SizedBox(height: 12),
                    Text(
                      'Belum ada sesi rekonsiliasi aktif.',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Pilih "Impor Mutasi Bank" untuk memulai pencocokan mutasi.',
                      style: TextStyle(fontSize: 13, color: CupertinoColors.secondaryLabel),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
