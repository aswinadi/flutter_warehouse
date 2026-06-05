import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/models/user.dart';
import '../config/menu_items.dart';
import '../../features/notifications/providers/notification_provider.dart';
import '../services/updater_service.dart';

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
        ref.read(lastActiveParentIndexProvider.notifier).state = activeParentIndex;
        if (activeParentIndex != -1) {
          ref.read(expandedMenuIndexProvider.notifier).state = activeParentIndex;
        }
      });
    }

    final currentExpandedIndex = expandedIndex ?? (activeParentIndex != -1 ? activeParentIndex : null);

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop)
            _buildSidebar(context, ref, navItems, isCollapsed, unreadCount, currentExpandedIndex),
          Expanded(
            child: SelectionArea(
              child: widget.child,
            ),
          ),
        ],
      ),
      bottomNavigationBar: isDesktop ? null : _buildBottomNav(context, navItems, unreadCount),
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
      color: Colors.blue[900],
      child: Column(
        children: [
          _buildHeader(context, ref, isCollapsed),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ...navItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  if (item.subItems != null && item.subItems!.isNotEmpty) {
                    return _buildSubMenu(context, item, isCollapsed, index, currentExpandedIndex, ref);
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.comingSoon)),
                          );
                        }
                      },
                    );
                  }
                }),
              ],
            ),
          ),
          _SidebarItem(
            icon: Icons.logout,
            label: l10n.logout,
            isCollapsed: isCollapsed,
            isActive: false,
            onTap: () {
              ref.read(authProvider.notifier).logout();
            },
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
  ) {
    final l10n = AppLocalizations.of(context)!;
    final isParentActive = _isRouteActive(context, item);
    final parentLabel = item.labelBuilder(l10n);

    if (isCollapsed) {
      // Collapsed: Show popup slide-out menu with styling matching design rules
      return Theme(
        key: ValueKey('${item.labelBuilder(l10n)}_collapsed'),
        data: Theme.of(context).copyWith(
          cardColor: Colors.blue[950],
          canvasColor: Colors.blue[950],
          colorScheme: Theme.of(context).colorScheme.copyWith(
            surface: Colors.blue[950],
          ),
          popupMenuTheme: PopupMenuThemeData(
            color: Colors.blue[950],
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.blue[850] ?? Colors.blue, width: 1),
            ),
          ),
        ),
        child: PopupMenuButton<String>(
          tooltip: parentLabel,
          offset: const Offset(70, 0),
          color: Colors.blue[950],
          surfaceTintColor: Colors.transparent, // Direct widget override for Material 3 tinting
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.blue[850] ?? Colors.blue, width: 1),
          ),
          child: SizedBox(
            height: 48,
            width: 70,
            child: Center(
              child: Icon(
                item.icon,
                color: isParentActive ? Colors.white : Colors.white70,
              ),
            ),
          ),
          onSelected: (path) {
            if (path.isNotEmpty) {
              context.go(path);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.comingSoon)),
              );
            }
          },
          itemBuilder: (context) => item.subItems!.map((subItem) {
            final isChildActive = subItem.path != null && GoRouterState.of(context).uri.path == subItem.path;
            return PopupMenuItem<String>(
              value: subItem.path ?? '',
              child: Row(
                children: [
                  Icon(subItem.icon, color: isChildActive ? Colors.white : Colors.white70, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    subItem.labelBuilder(l10n),
                    style: TextStyle(
                      color: isChildActive ? Colors.white : Colors.white70,
                      fontWeight: isChildActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    } else {
      // Expanded: Show accordion-style ExpansionTile
      final isExpanded = expandedIndex == index;
      return Theme(
        key: ValueKey('${item.labelBuilder(l10n)}_expanded'),
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          hoverColor: Colors.white12,
        ),
        child: ExpansionTile(
          key: Key('${item.labelBuilder(l10n)}_$isExpanded'),
          shape: const Border(),
          collapsedShape: const Border(),
          iconColor: Colors.white,
          collapsedIconColor: Colors.white70,
          initiallyExpanded: isExpanded,
          onExpansionChanged: (expanded) {
            if (expanded) {
              ref.read(expandedMenuIndexProvider.notifier).state = index;
            } else {
              if (ref.read(expandedMenuIndexProvider) == index) {
                ref.read(expandedMenuIndexProvider.notifier).state = -1; // Explicitly collapsed
              }
            }
          },
          title: Text(
            parentLabel,
            style: TextStyle(
              color: isParentActive ? Colors.white : Colors.white70,
              fontSize: 14,
              fontWeight: isParentActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          leading: SizedBox(
            width: 40,
            child: Icon(
              item.icon,
              color: isParentActive ? Colors.white : Colors.white70,
            ),
          ),
          childrenPadding: const EdgeInsets.only(left: 16),
          children: item.subItems!.map((subItem) {
            final isChildActive = subItem.path != null && GoRouterState.of(context).uri.path == subItem.path;
            return _SidebarItem(
              icon: subItem.icon,
              label: subItem.labelBuilder(l10n),
              isCollapsed: false,
              isActive: isChildActive,
              indentation: 24,
              onTap: () {
                if (subItem.path != null) {
                  context.go(subItem.path!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.comingSoon)),
                  );
                }
              },
            );
          }).toList(),
        ),
      );
    }
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, bool isCollapsed) {
    return SizedBox(
      height: 100,
      child: Row(
        children: [
          if (!isCollapsed)
            Expanded(
              child: const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'MAXMAR\nWAREHOUSE',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ),
            ),
          SizedBox(
            width: 70,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.white, size: 24),
                onPressed: () {
                  ref.read(sidebarCollapsedProvider.notifier).state = !isCollapsed;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildBottomNav(BuildContext context, List<NavItemConfig> navItems, int unreadCount) {
    final l10n = AppLocalizations.of(context)!;
    // Flatten children for mobile bottom navigation (showing first 5 active routes, excluding placeholders)
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
      return null; // Return null to prevent BottomNavigationBar assertion crash when items < 2
    }
    final selectedIndex = _calculateSelectedIndex(context, displayItems);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue[900],
      unselectedItemColor: Colors.grey,
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
              ? Badge(
                  label: Text('$unreadCount'),
                  child: Icon(item.icon),
                )
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

class _SidebarItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? Colors.white10 : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.white12,
        child: Stack(
          children: [
            Container(
              constraints: const BoxConstraints(minHeight: 48),
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(width: indentation),
                  SizedBox(
                    width: 70 - indentation,
                    child: Center(
                      child: badgeCount > 0
                          ? Badge(
                              label: Text('$badgeCount'),
                              child: Icon(
                                icon,
                                color: isActive ? Colors.white : Colors.white70,
                              ),
                            )
                          : Icon(
                              icon,
                              color: isActive ? Colors.white : Colors.white70,
                            ),
                    ),
                  ),
                  if (!isCollapsed)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          label,
                          style: TextStyle(
                            color: isActive ? Colors.white : Colors.white70,
                            fontSize: 14,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (isActive)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 4,
                child: Container(
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

