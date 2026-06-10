import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/company_provider.dart';
import '../models/company.dart';

class CompanySwitcher extends ConsumerWidget {
  const CompanySwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companiesAsync = ref.watch(companiesProvider);
    final selectedCompany = ref.watch(selectedCompanyProvider);

    return companiesAsync.when(
      data: (companies) {
        if (companies.isEmpty) return const SizedBox.shrink();

        return Material(
          type: MaterialType.transparency,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Icon(Icons.business, color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Company?>(
                      isExpanded: true,
                      value: selectedCompany,
                      hint: Text('All Companies', style: TextStyle(color: Colors.grey.shade800, fontSize: 14, fontWeight: FontWeight.w500)),
                      dropdownColor: Colors.white,
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                      onChanged: (Company? newValue) {
                        ref.read(selectedCompanyProvider.notifier).selectCompany(newValue);
                      },
                      items: [
                        DropdownMenuItem<Company?>(
                          value: null,
                          child: Text('All Companies', style: TextStyle(color: Colors.grey.shade800, fontSize: 14, fontWeight: FontWeight.w500)),
                        ),
                        ...companies.map<DropdownMenuItem<Company?>>((Company company) {
                          return DropdownMenuItem<Company?>(
                            value: company,
                            child: Text(
                              company.companyName,
                              style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue),
          ),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
