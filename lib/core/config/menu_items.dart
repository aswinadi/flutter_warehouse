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
        requiredPermissions: ['approve_pr', 'approve_po', 'approve_invoice'],
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
        labelBuilder: (l10n) => 'Penyesuaian Barang',
        path: '/inventory-adjustments',
        requiredPermissions: ['view_inventory'],
      ),
      NavItemConfig(
        icon: CupertinoIcons.minus_circle,
        labelBuilder: (l10n) => 'Pemakaian Barang',
        path: '/inventory-usages',
        requiredPermissions: ['view_inventory'],
      ),
      NavItemConfig(
        icon: CupertinoIcons.list_bullet,
        labelBuilder: (l10n) => 'Stock Opname',
        path: '/stock-opname',
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
    icon: CupertinoIcons.drop,
    labelBuilder: (l10n) => 'Akuakultur',
    subItems: [
      NavItemConfig(
        icon: CupertinoIcons.number,
        labelBuilder: (l10n) => 'Kalkulator Harga Jual Udang',
        path: '/aquaculture/calculator',
        requiredPermissions: ['view_usage'],
      ),
      NavItemConfig(
        icon: CupertinoIcons.arrow_2_circlepath,
        labelBuilder: (l10n) => 'Siklus',
        path: '/aquaculture/cycles',
        requiredPermissions: ['view_usage'],
      ),
      NavItemConfig(
        icon: CupertinoIcons.house,
        labelBuilder: (l10n) => 'Tambak',
        path: '/aquaculture/tambaks',
        requiredPermissions: ['view_usage'],
      ),
      NavItemConfig(
        icon: CupertinoIcons.grid,
        labelBuilder: (l10n) => 'Blok',
        path: '/aquaculture/bloks',
        requiredPermissions: ['view_usage'],
      ),
      NavItemConfig(
        icon: CupertinoIcons.doc_text,
        labelBuilder: (l10n) => 'Kontrak Jual Udang',
        path: '/aquaculture/contracts',
        requiredPermissions: ['view_usage'],
      ),
      NavItemConfig(
        icon: CupertinoIcons.square_grid_2x2,
        labelBuilder: (l10n) => 'Modul',
        path: '/aquaculture/moduls',
        requiredPermissions: ['view_usage'],
      ),
      NavItemConfig(
        icon: CupertinoIcons.chart_bar,
        labelBuilder: (l10n) => 'Feed Management',
        path: '/feed-logs',
        requiredPermissions: ['view_usage'],
      ),
      NavItemConfig(
        icon: CupertinoIcons.list_bullet,
        labelBuilder: (l10n) => 'Petak',
        path: '/aquaculture/ponds',
        requiredPermissions: ['view_usage'],
      ),
      NavItemConfig(
        icon: CupertinoIcons.drop,
        labelBuilder: (l10n) => 'Saprotam Logs',
        path: '/aquaculture/saprotam-logs',
        requiredPermissions: ['view_usage'],
      ),
    ],
  ),
  NavItemConfig(
    icon: CupertinoIcons.building_2_fill,
    labelBuilder: (l10n) => 'Cost Centre',
    path: '/cost-centers',
    requiredPermissions: ['view_usage'],
  ),
  NavItemConfig(
    icon: CupertinoIcons.creditcard,
    labelBuilder: (l10n) => l10n.finance,
    subItems: [
      NavItemConfig(
        icon: CupertinoIcons.doc_text,
        labelBuilder: (l10n) => 'Purchase Invoice (Faktur)',
        path: '/purchase-invoices',
        requiredPermissions: ['view_payments'],
      ),
      NavItemConfig(
        icon: CupertinoIcons.doc_text_viewfinder,
        labelBuilder: (l10n) => 'Invoice Biaya',
        path: '/invoice-biaya',
        requiredPermissions: ['view_payments'],
      ),
      NavItemConfig(
        icon: CupertinoIcons.paperplane,
        labelBuilder: (l10n) => 'Permintaan Pembayaran',
        path: '/payment-requests',
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
      NavItemConfig(
        icon: CupertinoIcons.tag,
        labelBuilder: (l10n) => 'Landed Cost (Biaya Tambahan)',
        path: '/landed-costs',
        requiredPermissions: ['view_payments'],
      ),
    ],
  ),
];
