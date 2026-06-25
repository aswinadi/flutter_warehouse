import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/company_provider.dart';
import '../models/company.dart';
import 'cupertino_glass_container.dart';

class CompanySwitcher extends ConsumerWidget {
  const CompanySwitcher({super.key});

  void _showPicker(
    BuildContext context,
    WidgetRef ref,
    List<Company> companies,
    Company? selectedCompany,
  ) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: const Text('Pilih Perusahaan'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                ref.read(selectedCompanyProvider.notifier).selectCompany(null);
              },
              child: Text(
                'Semua Perusahaan',
                style: TextStyle(
                  fontWeight: selectedCompany == null ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            ...companies.map((company) {
              final isSelected = selectedCompany?.id == company.id;
              return CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  ref.read(selectedCompanyProvider.notifier).selectCompany(company);
                },
                child: Text(
                  company.companyName,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            }),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companiesAsync = ref.watch(companiesProvider);
    final selectedCompany = ref.watch(selectedCompanyProvider);

    return companiesAsync.when(
      data: (companies) {
        if (companies.isEmpty) return const SizedBox.shrink();

        if (companies.length == 1 && selectedCompany == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(selectedCompanyProvider.notifier).selectCompany(companies.first);
          });
        }

        if (companies.length <= 1) return const SizedBox.shrink();

        final displayName = selectedCompany?.companyName ?? 'Semua Perusahaan';

        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: GestureDetector(
              onTap: () => _showPicker(context, ref, companies, selectedCompany),
              behavior: HitTestBehavior.opaque,
              child: CupertinoGlassContainer(
                borderRadius: 9999.0, // {radius.full}
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      CupertinoIcons.building_2_fill,
                      color: CupertinoColors.activeBlue,
                      size: 14.0,
                    ),
                    const SizedBox(width: 6.0),
                    Flexible(
                      child: Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    const Icon(
                      CupertinoIcons.chevron_down,
                      color: CupertinoColors.secondaryLabel,
                      size: 12.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0),
        child: Center(
          child: SizedBox(
            width: 16.0,
            height: 16.0,
            child: CupertinoActivityIndicator(radius: 8.0),
          ),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
