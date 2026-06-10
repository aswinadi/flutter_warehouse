import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/app_localizations.dart';

class NavItemConfig {
  final IconData icon;
  final String Function(AppLocalizations) labelBuilder;
  final String? path;
  final List<String>? requiredPermissions;
  final List<NavItemConfig>? subItems;

  const NavItemConfig({
    required this.icon,
    required this.labelBuilder,
    this.path,
    this.requiredPermissions,
    this.subItems,
  });
}

final List<NavItemConfig> menuConfig = [
  NavItemConfig(
    icon: Icons.dashboard,
    labelBuilder: (l10n) => l10n.dashboard,
    path: '/',
  ),
  NavItemConfig(
    icon: Icons.notifications,
    labelBuilder: (l10n) => 'Pemberitahuan',
    path: '/notifications',
  ),
  NavItemConfig(
    icon: Icons.assignment_turned_in,
    labelBuilder: (l10n) => l10n.persetujuan,
    subItems: [
      NavItemConfig(
        icon: Icons.assignment_turned_in,
        labelBuilder: (l10n) => l10n.approvals,
        path: '/approvals',
        requiredPermissions: ['approve_pr'],
      ),
    ],
  ),
  NavItemConfig(
    icon: Icons.shopping_bag,
    labelBuilder: (l10n) => l10n.purchasing,
    subItems: [
      NavItemConfig(
        icon: Icons.shopping_cart,
        labelBuilder: (l10n) => l10n.purchaseRequest,
        path: '/pr',
        requiredPermissions: ['view_pr'],
      ),
      NavItemConfig(
        icon: Icons.receipt_long,
        labelBuilder: (l10n) => l10n.purchaseOrders,
        path: '/po',
        requiredPermissions: ['view_po'],
      ),
    ],
  ),
  NavItemConfig(
    icon: Icons.store,
    labelBuilder: (l10n) => l10n.warehouse,
    subItems: [
      NavItemConfig(
        icon: Icons.receipt_long,
        labelBuilder: (l10n) => l10n.packingList,
        path: '/packing-list',
        requiredPermissions: ['view_containers'],
      ),
      NavItemConfig(
        icon: Icons.qr_code_scanner,
        labelBuilder: (l10n) => l10n.receiving,
        path: '/receiving',
        requiredPermissions: ['view_receiving'],
      ),
      NavItemConfig(
        icon: Icons.send_to_mobile,
        labelBuilder: (l10n) => l10n.sendToBranch,
        path: '/transfer-out',
        requiredPermissions: ['view_inventory'],
      ),
      NavItemConfig(
        icon: Icons.move_to_inbox,
        labelBuilder: (l10n) => l10n.receiveFromBranch,
        path: '/transfer-in',
        requiredPermissions: ['view_receiving'],
      ),
      NavItemConfig(
        icon: Icons.inventory_2,
        labelBuilder: (l10n) => l10n.inventoryStock,
        path: '/inventory',
        requiredPermissions: ['view_inventory'],
      ),
      NavItemConfig(
        icon: Icons.history,
        labelBuilder: (l10n) => l10n.stockMutation,
        path: '/stock-mutation',
        requiredPermissions: ['view_inventory'],
      ),
      NavItemConfig(
        icon: Icons.settings_backup_restore,
        labelBuilder: (l10n) => 'Penyesuaian & Pemakaian',
        path: '/inventory-adjustments',
        requiredPermissions: ['view_inventory'],
      ),
      NavItemConfig(
        icon: Icons.computer,
        labelBuilder: (l10n) => 'Hardware Assets',
        path: '/assets',
        requiredPermissions: ['view_inventory'],
      ),
    ],
  ),
  NavItemConfig(
    icon: Icons.agriculture,
    labelBuilder: (l10n) => l10n.operasionalTambak,
    subItems: [
      NavItemConfig(
        icon: Icons.agriculture,
        labelBuilder: (l10n) => l10n.pemakaian,
        path: '/usage',
        requiredPermissions: ['view_usage'],
      ),
      NavItemConfig(
        icon: Icons.bubble_chart,
        labelBuilder: (l10n) => l10n.feedManagement,
        path: '/feed-logs',
        requiredPermissions: ['view_usage'],
      ),
    ],
  ),
  NavItemConfig(
    icon: Icons.account_balance_wallet,
    labelBuilder: (l10n) => l10n.finance,
    subItems: [
      NavItemConfig(
        icon: Icons.receipt,
        labelBuilder: (l10n) => 'Purchase Invoice',
        path: '/purchase-invoices',
        requiredPermissions: ['view_payments'],
      ),
      NavItemConfig(
        icon: Icons.payment,
        labelBuilder: (l10n) => l10n.paymentTransactions,
        path: '/payment-transactions',
        requiredPermissions: ['view_payments'],
      ),
    ],
  ),
];
