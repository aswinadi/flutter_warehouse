import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/models/user.dart';
import '../config/menu_items.dart';
import '../../features/notifications/providers/notification_provider.dart';
import '../services/updater_service.dart';
import '../providers/theme_provider.dart';

final sidebarCollapsedProvider = StateProvider<bool>((ref) => false);
final expandedMenuIndexProvider = StateProvider<int?>((ref) => null);
final lastActiveParentIndexProvider = StateProvider<int?>((ref) => null);

class MainShell extends ConsumerStatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(updaterServiceProvider).checkForUpdates(context);
    });
  }

  bool _isRouteActive(BuildContext context, NavItemConfig item) {
    final String location = GoRouterState.of(context).uri.path;
    if (item.path != null) {
      return location == item.path || (item.path != '/' && location.startsWith(item.path!));
    }
    if (item.subItems != null) {
      return item.subItems!.any((sub) {
        final path = sub.path;
        if (path == null) return false;
        return location == path || (path != '/' && location.startsWith(path));
      });
    }
    return false;
  }

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

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
    final authState = ref.watch(authProvider);
    final isCollapsed = ref.watch(sidebarCollapsedProvider);
    final unreadCount = ref.watch(unreadNotificationCountProvider).valueOrNull ?? 0;

    final user = authState.valueOrNull?.maybeWhen(
      authenticated: (user, _) => user,
      orElse: () => null,
    );

    final navItems = _filterMenuItems(user);

    // Calculate active parent index
    final activeParentIndex = navItems.indexWhere((item) =>
        item.subItems != null && item.subItems!.isNotEmpty && _isRouteActive(context, item));

    final expandedIndex = ref.watch(expandedMenuIndexProvider);
    final lastActiveParent = ref.watch(lastActiveParentIndexProvider);

    // Auto-update expanded state when active parent index changes (e.g. on navigation)
    if (activeParentIndex != lastActiveParent) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(lastActiveParentIndexProvider.notifier).state = activeParentIndex;
        if (activeParentIndex != -1) {
          ref.read(expandedMenuIndexProvider.notifier).state = activeParentIndex;
        }
      });
    }

    final currentExpandedIndex = expandedIndex ?? (activeParentIndex != -1 ? activeParentIndex : null);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Row(
          children: [
            if (isDesktop)
              _buildSidebar(context, ref, navItems, isCollapsed, unreadCount, currentExpandedIndex),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: widget.child,
                  ),
                  if (!isDesktop)
                    _buildBottomNav(context, navItems, unreadCount),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar(
    BuildContext context,
    WidgetRef ref,
    List<NavItemConfig> navItems,
    bool isCollapsed,
    int unreadCount,
    int? currentExpandedIndex,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isCollapsed ? 70 : 265,
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(context),
        border: Border(
          right: BorderSide(
            color: CupertinoColors.separator.resolveFrom(context),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(context, ref, isCollapsed),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              children: [
                ...navItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  if (item.subItems != null && item.subItems!.isNotEmpty) {
                    return _buildSubMenu(context, item, isCollapsed, index, currentExpandedIndex, ref, unreadCount);
                  } else {
                    return _SidebarItem(
                      icon: item.icon,
                      label: item.labelBuilder(l10n),
                      isCollapsed: isCollapsed,
                      isActive: _isRouteActive(context, item),
                      badgeCount: item.path == '/notifications' ? unreadCount : 0,
                      onTap: () {
                        if (item.path != null) {
                          context.go(item.path!);
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
                    );
                  }
                }),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _SidebarItem(
              icon: CupertinoIcons.square_arrow_right,
              label: l10n.logout,
              isCollapsed: isCollapsed,
              isActive: false,
              onTap: () {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: Text(l10n.logout),
                    content: const Text('Apakah Anda yakin ingin keluar?'),
                    actions: [
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        child: const Text('Keluar'),
                        onPressed: () {
                          Navigator.pop(context);
                          ref.read(authProvider.notifier).logout();
                        },
                      ),
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        child: const Text('Batal'),
                        onPressed: () => Navigator.pop(context),
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

  Widget _buildSubMenu(
    BuildContext context,
    NavItemConfig item,
    bool isCollapsed,
    int index,
    int? expandedIndex,
    WidgetRef ref,
    int unreadCount,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final parentLabel = item.labelBuilder(l10n);

    if (isCollapsed) {
      // Collapsed: Show CupertinoActionSheet popup on tap
      final isParentActive = _isRouteActive(context, item);
      return GestureDetector(
        onTap: () {
          showCupertinoModalPopup(
            context: context,
            builder: (context) => CupertinoActionSheet(
              title: Text(parentLabel),
              actions: item.subItems!.map((subItem) {
                return CupertinoActionSheetAction(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(subItem.icon, color: CupertinoColors.activeBlue, size: 20),
                      const SizedBox(width: 12),
                      Text(subItem.labelBuilder(l10n)),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    if (subItem.path != null) {
                      context.go(subItem.path!);
                    }
                  },
                );
              }).toList(),
              cancelButton: CupertinoActionSheetAction(
                isDefaultAction: true,
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
            ),
          );
        },
        child: Container(
          height: 48,
          width: 70,
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: isParentActive ? CupertinoColors.activeBlue.resolveFrom(context).withValues(alpha: 0.12) : CupertinoColors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Icon(
              item.icon,
              color: isParentActive ? CupertinoColors.activeBlue.resolveFrom(context) : CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ),
        ),
      );
    } else {
      // Expanded: Custom Cupertino Accordion UI
      return _SubMenuAccordion(
        item: item,
        isCollapsed: isCollapsed,
        index: index,
        expandedIndex: expandedIndex,
        ref: ref,
        isRouteActive: (itm) => _isRouteActive(context, itm),
        parentLabel: parentLabel,
        unreadCount: unreadCount,
      );
    }
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, bool isCollapsed) {
    final themeMode = ref.watch(themeModeProvider);
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
        children: [
          if (!isCollapsed)
            Expanded(
              child: Text(
                'MAXMAR\nWAREHOUSE',
                style: TextStyle(
                  color: CupertinoColors.label.resolveFrom(context),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isCollapsed) ...[
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minSize: 32,
                  child: Icon(
                    themeMode == ThemeModeState.dark 
                        ? CupertinoIcons.sun_max_fill 
                        : CupertinoIcons.moon_fill,
                    color: CupertinoColors.activeBlue,
                    size: 20,
                  ),
                  onPressed: () {
                    ref.read(themeModeProvider.notifier).toggleTheme();
                  },
                ),
                const SizedBox(width: 8),
              ],
              CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 32,
                child: Icon(
                  isCollapsed ? CupertinoIcons.sidebar_right : CupertinoIcons.sidebar_left,
                  color: CupertinoColors.activeBlue,
                  size: 22,
                ),
                onPressed: () {
                  ref.read(sidebarCollapsedProvider.notifier).state = !isCollapsed;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, List<NavItemConfig> navItems, int unreadCount) {
    final l10n = AppLocalizations.of(context)!;
    // Flatten children for mobile bottom navigation (showing first 5 active routes)
    final List<NavItemConfig> flatItems = [];
    for (var item in navItems) {
      if (item.subItems != null) {
        flatItems.addAll(item.subItems!.where((sub) => sub.path != null));
      } else {
        if (item.path != null) {
          flatItems.add(item);
        }
      }
    }

    final displayItems = flatItems.take(5).toList();
    if (displayItems.length < 2) {
      return const SizedBox.shrink(); 
    }
    final selectedIndex = _calculateSelectedIndex(context, displayItems);

    return CupertinoTabBar(
      activeColor: CupertinoColors.activeBlue,
      inactiveColor: CupertinoColors.inactiveGray,
      currentIndex: selectedIndex,
      onTap: (index) => context.go(displayItems[index].path!),
      items: displayItems.map((item) {
        final label = item.labelBuilder(l10n);
        final shortLabel = (label == 'Purchase Request' || label == 'Permintaan Pembelian (PR)') ? 'PR' :
                           (label == 'Vendor Comparison' || label == 'Perbandingan Vendor') ? 'Vendor' :
                           (label == 'Packing list' || label == 'Packing List' || label == 'Daftar Packing') ? 'Packing' :
                           (label == 'Penerimaan Barang' || label == 'Receiving') ? 'Terima' :
                           (label == 'Kirim ke Cabang' || label == 'Send to Branch') ? 'Kirim' :
                           (label == 'Terima dari Cabang' || label == 'Receive from Branch') ? 'Terima' : label;

        final isNotifications = item.path == '/notifications';

        return BottomNavigationBarItem(
          icon: isNotifications && unreadCount > 0
              ? _BadgeIcon(icon: item.icon, count: unreadCount)
              : Icon(item.icon),
          label: shortLabel,
        );
      }).toList(),
    );
  }

  int _calculateSelectedIndex(BuildContext context, List<NavItemConfig> navItems) {
    final String location = GoRouterState.of(context).uri.path;
    int selectedIndex = 0;
    for (int i = 0; i < navItems.length; i++) {
      if (navItems[i].path != null &&
          (location == navItems[i].path ||
           (navItems[i].path != '/' && location.startsWith(navItems[i].path!)))) {
        selectedIndex = i;
      }
    }
    return selectedIndex;
  }
}

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isCollapsed;
  final bool isActive;
  final double indentation;
  final VoidCallback onTap;
  final int badgeCount;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isCollapsed,
    required this.isActive,
    this.indentation = 0,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final activeBg = CupertinoColors.activeBlue.resolveFrom(context).withValues(alpha: 0.12);
    final hoverBg = CupertinoColors.inactiveGray.resolveFrom(context).withValues(alpha: 0.08);
    final bg = widget.isActive 
        ? activeBg 
        : (_isHovered ? hoverBg : CupertinoColors.transparent);

    final textColor = widget.isActive 
        ? CupertinoColors.activeBlue.resolveFrom(context) 
        : CupertinoColors.label.resolveFrom(context);

    final iconColor = widget.isActive 
        ? CupertinoColors.activeBlue.resolveFrom(context) 
        : CupertinoColors.secondaryLabel.resolveFrom(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          constraints: const BoxConstraints(minHeight: 40),
          child: Row(
            children: [
              SizedBox(width: widget.indentation),
              Icon(widget.icon, color: iconColor, size: 20),
              if (!widget.isCollapsed) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: widget.isActive ? FontWeight.w600 : widget.isActive ? FontWeight.bold : FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.badgeCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemRed,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${widget.badgeCount}',
                      style: const TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SubMenuAccordion extends StatefulWidget {
  final NavItemConfig item;
  final bool isCollapsed;
  final int index;
  final int? expandedIndex;
  final WidgetRef ref;
  final bool Function(NavItemConfig) isRouteActive;
  final String parentLabel;
  final int unreadCount;

  const _SubMenuAccordion({
    required this.item,
    required this.isCollapsed,
    required this.index,
    required this.expandedIndex,
    required this.ref,
    required this.isRouteActive,
    required this.parentLabel,
    required this.unreadCount,
  });

  @override
  State<_SubMenuAccordion> createState() => _SubMenuAccordionState();
}

class _SubMenuAccordionState extends State<_SubMenuAccordion> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isExpanded = widget.expandedIndex == widget.index;
    final isParentActive = widget.isRouteActive(widget.item);

    final activeBg = CupertinoColors.activeBlue.resolveFrom(context).withValues(alpha: 0.06);
    final hoverBg = CupertinoColors.inactiveGray.resolveFrom(context).withValues(alpha: 0.04);
    final bg = isParentActive 
        ? activeBg 
        : (_isHovered ? hoverBg : CupertinoColors.transparent);

    final textColor = isParentActive 
        ? CupertinoColors.activeBlue.resolveFrom(context) 
        : CupertinoColors.label.resolveFrom(context);

    final iconColor = isParentActive 
        ? CupertinoColors.activeBlue.resolveFrom(context) 
        : CupertinoColors.secondaryLabel.resolveFrom(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: () {
              if (isExpanded) {
                widget.ref.read(expandedMenuIndexProvider.notifier).state = -1;
              } else {
                widget.ref.read(expandedMenuIndexProvider.notifier).state = widget.index;
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              constraints: const BoxConstraints(minHeight: 40),
              child: Row(
                children: [
                  Icon(widget.item.icon, color: iconColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.parentLabel,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: isParentActive ? FontWeight.w600 : FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    isExpanded ? CupertinoIcons.chevron_down : CupertinoIcons.chevron_right,
                    color: CupertinoColors.tertiaryLabel,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isExpanded)
          ...widget.item.subItems!.map((subItem) {
            final isChildActive = subItem.path != null && 
                GoRouterState.of(context).uri.path == subItem.path;
            final l10n = AppLocalizations.of(context)!;
            return _SidebarItem(
              icon: subItem.icon,
              label: subItem.labelBuilder(l10n),
              isCollapsed: false,
              isActive: isChildActive,
              indentation: 16,
              onTap: () {
                if (subItem.path != null) {
                  context.go(subItem.path!);
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
            );
          }),
      ],
    );
  }
}

class _BadgeIcon extends StatelessWidget {
  final IconData icon;
  final int count;

  const _BadgeIcon({required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        Positioned(
          right: -6,
          top: -3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: CupertinoColors.systemRed,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: const BoxConstraints(
              minWidth: 14,
              minHeight: 14,
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                color: CupertinoColors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
