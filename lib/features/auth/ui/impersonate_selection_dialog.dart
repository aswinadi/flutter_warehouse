import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_search_field.dart';
import '../../../core/widgets/cupertino_glass_loading_indicator.dart';
import '../../../core/widgets/cupertino_glass_list_section.dart';
import '../../../core/widgets/cupertino_glass_toast.dart';
import '../providers/impersonation_provider.dart';

class ImpersonateSelectionDialog extends ConsumerStatefulWidget {
  const ImpersonateSelectionDialog({super.key});

  @override
  ConsumerState<ImpersonateSelectionDialog> createState() => _ImpersonateSelectionDialogState();
}

class _ImpersonateSelectionDialogState extends ConsumerState<ImpersonateSelectionDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = false;
  String _lastSearch = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers([String? query]) async {
    setState(() {
      _isLoading = true;
    });

    final notifier = ref.read(impersonationProvider.notifier);
    final results = await notifier.fetchImpersonationUsers(search: query);

    if (mounted) {
      setState(() {
        _users = results;
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String value) {
    if (value != _lastSearch) {
      _lastSearch = value;
      // Debounce logic or immediate search
      _loadUsers(value);
    }
  }

  Future<void> _handleImpersonate(BuildContext context, Map<String, dynamic> user) async {
    Navigator.of(context).pop(); // Close dialog first
    
    // Show glass loading progress or toast
    CupertinoGlassToast.showInfo(
      context,
      'Menyamar sebagai ${user['name']}...',
    );

    final success = await ref.read(impersonationProvider.notifier).startImpersonating(user['id']);

    if (mounted) {
      if (success) {
        CupertinoGlassToast.showSuccess(
          context,
          'Berhasil menyamar sebagai ${user['name']}',
        );
      } else {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Gagal Impersonasi'),
            content: const Text('Terjadi kesalahan saat memulai sesi impersonasi.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? CupertinoColors.white : CupertinoColors.black;
    final secondaryTextColor = isDark ? CupertinoColors.secondaryLabel.resolveFrom(context) : CupertinoColors.secondaryLabel;

    return Center(
      child: Container(
        width: 320,
        height: 480,
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: CupertinoGlassContainer(
          borderRadius: 24.0, // {radius.xl}
          blurSigma: 30.0,    // Level 4 (Overlay)
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pilih User Impersonate',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: 30,
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Icon(
                        CupertinoIcons.clear_circled,
                        color: CupertinoColors.secondaryLabel,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),

              // Search Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: CupertinoGlassSearchField(
                  controller: _searchController,
                  placeholder: 'Cari nama atau email...',
                  onChanged: _onSearchChanged,
                ),
              ),

              const SizedBox(height: 12),

              // Users List or Spinner
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CupertinoGlassLoadingIndicator(),
                      )
                    : _users.isEmpty
                        ? Center(
                            child: Text(
                              'User tidak ditemukan',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 14,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: CupertinoGlassListSection(
                              children: _users.map((user) {
                                final roles = (user['roles'] as List?)?.join(', ') ?? 'No Role';
                                final companyName = user['company']?['name'] ?? 'Semua Perusahaan';
                                return GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => _handleImpersonate(context, user),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    child: Row(
                                      children: [
                                        // User Avatar Icon
                                        Container(
                                          width: 38,
                                          height: 38,
                                          decoration: BoxDecoration(
                                            color: isDark ? const Color(0x22FFFFFF) : const Color(0x0A000000),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            CupertinoIcons.person_alt,
                                            color: isDark ? CupertinoColors.white : CupertinoColors.darkBackgroundGray,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // User Details
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                user['name'] ?? '',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: primaryTextColor,
                                                  decoration: TextDecoration.none,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                roles,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                  color: secondaryTextColor,
                                                  decoration: TextDecoration.none,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                companyName,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: CupertinoColors.activeBlue,
                                                  decoration: TextDecoration.none,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          CupertinoIcons.chevron_right,
                                          color: CupertinoColors.secondaryLabel,
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
