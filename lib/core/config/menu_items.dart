import 'package:flutter/cupertino.dart';
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
    icon: CupertinoIcons.square_grid_2x2,
    labelBuilder: (l10n) => l10n.dashboard,
    path: '/',
  ),
  NavItemConfig(
    icon: CupertinoIcons.bell,
    labelBuilder: (l10n) => 'Pemberitahuan',
    path: '/notifications',
  ),
  NavItemConfig(
    icon: CupertinoIcons.checkmark_seal,
    labelBuilder: (l10n) => l10n.persetujuan,
    subItems: [
      NavItemConfig(
        icon: CupertinoIcons.checkmark_seal,
        labelBuilder: (l10n) => l10n.approvals,
        path: '/approvals',
        requiredPermissions: ['approve_pr'],
      ),
    ],
  ),
  NavItemConfig(
    icon: CupertinoIcons.bag,
    labelBuilder: (l10n) => l10n.purchasing,
    subItems: [
      NavItemConfig(
        icon: CupertinoIcons.cart,
        labelBuilder: (l10n) => l10n.purchaseRequest,
        path: '/pr',
        requiredPermissions: ['view_pr'],
      ),
      NavItemConfig(
        icon: CupertinoIcons.doc_plaintext,
        labelBuilder: (l10n) => l10n.purchaseOrders,
        path: '/po',
        requiredPermissions: ['view_po'],
      ),
    ],
  ),
  NavItemConfig(
    icon: CupertinoIcons.house,
    labelBuilder: (l10n) => l10n.warehouse,
    subItems: [
      NavItemConfig(
        icon: CupertinoIcons.doc_plaintext,
        labelBuilder: (l10n) => l10n.packingList,
        path: '/packing-list',
        requiredPermissions: ['view_containers'],
      ),
      NavItemConfig(
        icon: CupertinoIcons.qrcode_viewfinder,
        labelBuilder: (l10n) => l10n.receiving,
        path: '/receiving',
        requiredPermissions: ['view_receiving'],
      ),
      NavItemConfig(
        icon: CupertinoIcons.arrow_up_square,
        labelBuilder: (l10n) => l10n.sendToBranch,
        path: '/transfer-out',
        requiredPermissions: ['view_inventory'],
      ),
      NavItemConfig(
        icon: CupertinoIcons.arrow_down_square,
        labelBuilder: (l10n) => l10n.receiveFromBranch,
        path: '/transfer-in',
        requiredPermissions: ['view_receiving'],
      ),
      NavItemConfig(
        icon: CupertinoIcons.archivebox,
        labelBuilder: (l10n) => l10n.inventoryStock,
        path: '/inventory',
        requiredPermissions: ['view_inventory'],
      ),
      NavItemConfig(
        icon: CupertinoIcons.time,
        labelBuilder: (l10n) => l10n.stockMutation,
        path: '/stock-mutation',
        requiredPermissions: ['view_inventory'],
      ),
      NavItemConfig(
        icon: CupertinoIcons.arrow_counterclockwise,
        labelBuilder: (l10n) => 'Penyesuaian & Pemakaian',
        path: '/inventory-adjustments',
        requiredPermissions: ['view_inventory'],
      ),
      NavItemConfig(
        icon: CupertinoIcons.desktopcomputer,
        labelBuilder: (l10n) => 'Hardware Assets',
        path: '/assets',
        requiredPermissions: ['view_inventory'],
      ),
    ],
  ),
  NavItemConfig(
    icon: CupertinoIcons.tree,
    labelBuilder: (l10n) => l10n.operasionalTambak,
    subItems: [
      NavItemConfig(
        icon: CupertinoIcons.tree,
        labelBuilder: (l10n) => l10n.pemakaian,
        path: '/usage',
        requiredPermissions: ['view_usage'],
      ),
      NavItemConfig(
        icon: CupertinoIcons.wind,
        labelBuilder: (l10n) => l10n.feedManagement,
        path: '/feed-logs',
        requiredPermissions: ['view_usage'],
      ),
    ],
  ),
  NavItemConfig(
    icon: CupertinoIcons.creditcard,
    labelBuilder: (l10n) => l10n.finance,
    subItems: [
      NavItemConfig(
        icon: CupertinoIcons.doc_text,
        labelBuilder: (l10n) => 'Purchase Invoice',
        path: '/purchase-invoices',
        requiredPermissions: ['view_payments'],
      ),
      NavItemConfig(
        icon: CupertinoIcons.creditcard,
        labelBuilder: (l10n) => l10n.paymentTransactions,
        path: '/payment-transactions',
        requiredPermissions: ['view_payments'],
      ),
      NavItemConfig(
        icon: CupertinoIcons.chart_bar_square,
        labelBuilder: (l10n) => 'Valuasi Inventaris',
        path: '/inventory-valuation',
        requiredPermissions: ['view_payments'],
      ),
    ],
  ),
];
