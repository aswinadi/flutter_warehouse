# Changelog

All notable changes to the Maxmar Warehouse Flutter project will be documented in this file.

## [1.4.0] - 2026-06-05

### Added
- **Interactive Inventory Valuation Screen**:
  - Implemented a premium 2-pane interactive screen for the **Inventory Valuation Report** under the Finance (**Keuangan**) section.
  - Linked the `/inventory-valuation` route and restricted access using the Spatie `view_payments` permission constraint.
  - Integrated standard Riverpod providers (`inventoryValuationListProvider` and `inventoryValuationBreakdownProvider`) and lightweight Dart DTO models.
  - Built direct action triggers in the AppBar to directly export PDF and Excel reports bypassing the preview screen (saving files to native downloads on desktop, and invoking native share sheets on mobile).

### Fixed
- **Sidebar Key Reuse Layout Bug**:
  - Assigned unique `ValueKey` identifiers (`_collapsed`/`_expanded`) to the submenu themes in `main_shell.dart` to resolve the `RenderBox was not laid out` drawer animation crash.
- **PDF Request Download Timeout**:
  - Extended the `receiveTimeout` specifically to `120` seconds inside `pdf_preview_screen.dart` to prevent premature transfer aborts when fetching generated PDF reports over slow connections/ngrok tunnels.

## [1.3.0] - 2026-06-04

### Added
- **Global Text Copy-Paste Selection**:
  - Wrapped main route content with `SelectionArea` in `main_shell.dart` to make all screen text (product names, SKUs, barcode codes, transaction codes) fully copyable.

### Changed
- **Fluid Multi-Breakpoint Screen Adaptations**:
  - Replaced binary wide-screen toggle with dynamic width caps (`maxLayoutWidth` of 650px, 600px, 500px, or full-width) to fit 4K, Desktop, Laptop, and Tablet resolutions beautifully on the Stock Adjustment screen.
  - Re-positioned the submit button from the Scaffold's `bottomNavigationBar` directly into the bottom of the body `Column` inside the `ConstrainedBox`, solving horizontal content alignment displacement on wide screens.
  - Automatically stacked the manual SKU/barcode search field and search button vertically on narrow screen sizes (width < 400px) instead of horizontally to prevent cramped layout clipping.
- **Indonesian Number Formatting Localization**:
  - Configured the global formatter in `currency_utils.dart` to use the `id_ID` locale to format numeric values using a dot (`.`) as the thousand separator and a comma (`,`) as the decimal separator.

### Fixed
- **Purchase Order Loading Crash (Type Cast Mismatch)**:
  - Decorated quantities and pricing/amount fields (`ordered_qty`, `received_qty`, `remaining_qty`, `unit_price`, and `total_amount`) in the `PurchaseOrder` and `PurchaseOrderItem` models with `doubleFromJson` and `doubleOrNullFromJson` deserializers.
  - Resolved `type 'String' is not a subtype of type 'num?' in type cast` crash on Goods Receiving detail screen loading.
- **Payment Transactions Infinite Loading Loop**:
  - Refactored `PaymentTransactionsList` in `payment_transaction_provider.dart` to be a family provider accepting `hasProof` and `search` parameters directly.
  - Removed stateful side-effect setters (`setHasProof` and `setSearchQuery` calling `ref.invalidateSelf()`) and post-frame callbacks in `payment_transaction_list_screen.dart` that caused recursive trigger loops.

## [1.2.0] - 2026-06-03

### Added
- **Self-Hosted In-App Auto-Update System**:
  - Implemented version checking and download coordination in `UpdaterService` using `package_info_plus`, `ota_update`, and `url_launcher`.
  - Added background downloader and direct package installer execution on Android platforms.
  - Added browser-redirect download routing for Windows desktop and web environments.
  - Configured app startup trigger inside `main_shell.dart` following successful authentication.
- **Detailed Documentation**:
  - Added [Auto-Update System Documentation](.docs/update_system.md) describing the backend schema and platform integration details.

### Fixed
- **Dropdown Runtime Crash**: Resolved `NoSuchMethodError: Class '_$WarehouseImpl' has no instance getter 'warehouseName'` in Stock Mutation dropdown by updating target lookup code to map to the correct `.name` field.
- **QR Asset Verification Scan**: Implemented url parsing utility to extract raw asset codes (e.g. `AST-MAU-xxxxx`) from scanned URL pathways, preventing verification failures on web-linked QR code tags.
- **Company-Dependent Warehouse Filters**: Enforced sequential selection behavior on Stock Mutations. The warehouse dropdown now stays disabled until a company is active, and selection changes correctly purge state stores.
- **Windows Desktop Compile Error**: Cleaned cached CMake builds and resolved `url_launcher` package compiler issues.

## [1.1.0] - 2026-05-28

### Added
- **Multi-language Support (Localization)**:
  - Integrated `flutter_localizations` dependency and configured template class generation in `l10n.yaml`.
  - Added English (`app_en.arb`) and Indonesian (`app_id.arb`) dictionaries.
  - Set default application locale to Indonesian (`id`) inside `main.dart` with delegates registered.
  - Supported dynamic sidebar labels, tooltip/expansion categories, and coming-soon alerts.
- **Centralized Navigation Configuration**:
  - Created `lib/core/config/menu_items.dart` declaring all modules, paths, icons, required permissions, and nested submenus.
  - Aligned touch menu cards on the Dashboard screen and sidebar navigation to render from the identical configuration.
- **Dynamic Role-Based Access Control (RBAC)**:
  - Modified `User` model to support `roles` and `permissions` matching Spatie / Filament Shield permission standards.
  - Added an `effectivePermissions` getter to bridge legacy `approvalTypes` (e.g. mapping to `approve_pr` permission).
  - Implemented dynamic menu filtering logic in `main_shell.dart` and `dashboard_screen.dart` with a `super_admin` role bypass.
  - Automatically filtered out empty menu categories and sub-items based on current user permissions.

### Fixed
- **Layout & Overflow Errors**:
  - Resolved **Right Overflow (4.0px)** on sidebar collapse by replacing the left border container decoration in `_SidebarItem` with a `Stack` and absolute `Positioned` indicator.
  - Resolved **Bottom Overflow (33px & 10px)** on dashboard grid cards by wrapping `GridView.count` in a `LayoutBuilder` to compute constraints dynamically, removing default `Card` margins, and setting a robust constant height of `140.0` pixels.
  - Resolved **White-on-Grey Popup Menu Text Accessibility Bug**: Wrapped the collapsed sidebar's `PopupMenuButton` in a localized `Theme` widget with transparent `surfaceTintColor` to prevent Material 3 from overlaying a light lavender elevation tint on the dark navy dropdown container.
- **Empty Routes Safety**:
  - Safely caught items with unassigned routes (`path: null`) and launched localized coming-soon snackbar alerts rather than causing navigation crashes.
  - Filtered coming-soon items automatically from the mobile bottom navigation bar.
