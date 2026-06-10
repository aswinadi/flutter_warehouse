import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/models/user.dart';
import '../../../core/config/menu_items.dart';
import '../../../core/widgets/main_shell.dart';
import '../../inventory/ui/barcode_lookup_bottom_sheet.dart';
import '../../../core/providers/theme_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  List<NavItemConfig> _filterMenuItems(User? user) {
    if (user == null) return [];
    
    final isSuperAdmin = user.roles.contains('super_admin');
    final effective = user.effectivePermissions;

    bool hasAccess(NavItemConfig item) {
      if (isSuperAdmin) return true;
      if (item.requiredPermissions == null || item.requiredPermissions!.isEmpty) return true;
      return item.requiredPermissions!.any((permission) => effective.contains(permission));
    }

    final List<NavItemConfig> filtered = [];
    for (var item in menuConfig) {
      if (item.subItems != null && item.subItems!.isNotEmpty) {
        final children = item.subItems!.where(hasAccess).toList();
        if (children.isNotEmpty) {
          filtered.add(NavItemConfig(
            icon: item.icon,
            labelBuilder: item.labelBuilder,
            path: item.path,
            requiredPermissions: item.requiredPermissions,
            subItems: children,
          ));
        }
      } else {
        if (hasAccess(item)) {
          filtered.add(item);
        }
      }
    }
    return filtered;
  }

  Color _getMenuColor(String? path) {
    switch (path) {
      case '/pr':
        return CupertinoColors.activeBlue;
      case '/approvals':
        return CupertinoColors.activeOrange;
      case '/po':
        return CupertinoColors.systemTeal;
      case '/receiving':
        return CupertinoColors.activeGreen;
      case '/inventory':
        return CupertinoColors.systemPurple;
      case '/usage':
        return CupertinoColors.systemBrown;
      case '/assets':
        return CupertinoColors.systemIndigo;
      default:
        return CupertinoColors.inactiveGray;
    }
  }

  void _showBarcodeLookup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      barrierColor: CupertinoColors.black.withValues(alpha: 0.4),
      builder: (context) => const BarcodeLookupBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isCollapsed = ref.watch(sidebarCollapsedProvider);
    final double sidebarWidth = isCollapsed ? 70.0 : 250.0;
    final l10n = AppLocalizations.of(context)!;

    final user = authState.valueOrNull?.maybeWhen(
      authenticated: (user, _) => user,
      orElse: () => null,
    );

    final navItems = _filterMenuItems(user);
    
    // Grouped section configurations based on menuConfig entries with sub-items
    final sections = navItems.where((item) => item.subItems != null && item.subItems!.isNotEmpty).toList();

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(l10n.dashboard),
            backgroundColor: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context).withValues(alpha: 0.96),
            border: Border(
              bottom: BorderSide(
                color: CupertinoColors.separator.resolveFrom(context),
                width: 0.5,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(
                    ref.watch(themeModeProvider) == ThemeModeState.dark 
                        ? CupertinoIcons.sun_max_fill 
                        : CupertinoIcons.moon_fill,
                    size: 20,
                  ),
                  onPressed: () {
                    ref.read(themeModeProvider.notifier).toggleTheme();
                  },
                ),
                const SizedBox(width: 8),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _showBarcodeLookup(context),
                  child: const Icon(
                    CupertinoIcons.qrcode_viewfinder,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                sections.map((section) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 28),
                    child: _buildMenuSection(
                      context,
                      title: section.labelBuilder(l10n),
                      sidebarWidth: sidebarWidth,
                      items: section.subItems!.map((childItem) {
                        return _MenuItem(
                          icon: childItem.icon,
                          label: childItem.labelBuilder(l10n),
                          onTap: () {
                            if (childItem.path != null) {
                              context.go(childItem.path!);
                            } else {
                              showCupertinoDialog(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                  title: const Text('Coming Soon'),
                                  content: Text(l10n.comingSoon),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: const Text('OK'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          color: _getMenuColor(childItem.path),
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(
    BuildContext context, {
    required String title,
    required List<_MenuItem> items,
    required double sidebarWidth,
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
    final double contentWidth = isDesktop ? screenWidth - sidebarWidth : screenWidth;
    final int crossAxisCount = contentWidth > 1000 ? 5 : (contentWidth > 600 ? 3 : 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold,
              color: CupertinoColors.label.resolveFrom(context),
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final double gridWidth = constraints.maxWidth;
            final double spacing = 12.0;
            final double totalSpacing = (crossAxisCount - 1) * spacing;
            final double cardWidth = (gridWidth - totalSpacing) / crossAxisCount;
            // Mathematically guarantees exactly 140.0 pixels height for the grid cells
            final double childAspectRatio = cardWidth / 140.0;

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: childAspectRatio,
              children: items.map((item) => _buildMenuCard(context, item)).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMenuCard(BuildContext context, _MenuItem item) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.separator.resolveFrom(context).withValues(alpha: 0.15),
          width: 0.5,
        ),
      ),
      child: GestureDetector(
        onTap: item.onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  item.icon,
                  size: 22,
                  color: item.color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12, 
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.label.resolveFrom(context),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });
}
