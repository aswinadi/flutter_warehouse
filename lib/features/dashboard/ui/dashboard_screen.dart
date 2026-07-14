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
import '../../../core/theme/cupertino_theme_extensions.dart';
import '../../../core/theme/cupertino_spacing.dart';
import '../../../core/widgets/cupertino_glass_container.dart';
import '../../../core/widgets/cupertino_glass_dialog.dart';
import '../../auth/providers/impersonation_provider.dart';
import '../../auth/ui/impersonate_selection_dialog.dart';

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

    final impersonationState = ref.watch(impersonationProvider);
    final isImpersonating = impersonationState.valueOrNull?.isImpersonating ?? false;
    final canImpersonate = !isImpersonating && (user?.roles.contains('super_admin') ?? false);

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
                if (canImpersonate) ...[
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => const ImpersonateSelectionDialog(),
                      );
                    },
                    child: const Icon(
                      CupertinoIcons.person_crop_circle_badge_plus,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
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
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              try {
                await ref.refresh(authProvider.future);
              } catch (_) {}
            },
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: CupertinoSpacing.screenMargin, vertical: CupertinoSpacing.xl),
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
                                builder: (context) => CupertinoGlassDialog(
                                  title: const Text('Coming Soon'),
                                  content: Text(l10n.comingSoon),
                                  actions: [
                                    CupertinoGlassDialogAction(
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
    final int crossAxisCount = isDesktop ? (contentWidth > 1000 ? 6 : 5) : 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: context.title3.copyWith(
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
            // Mathematically guarantees exact height for the grid cells
            final double cardHeight = isDesktop ? 140.0 : 88.0;
            final double childAspectRatio = cardWidth / cardHeight;

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
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
    final double iconSize = isDesktop ? 22.0 : 18.0;
    final double paddingSize = isDesktop ? 8.0 : 6.0;

    return CupertinoGlassContainer(
      borderRadius: CupertinoSpacing.cardRadius,
      padding: EdgeInsets.zero,
      child: GestureDetector(
        onTap: item.onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 8.0 : 4.0,
            vertical: isDesktop ? 10.0 : 6.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(paddingSize),
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  item.icon,
                  size: iconSize,
                  color: item.color,
                ),
              ),
              SizedBox(height: isDesktop ? 8.0 : 4.0),
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: (isDesktop ? context.caption1 : context.caption2).copyWith(
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
