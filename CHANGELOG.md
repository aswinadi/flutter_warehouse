# Changelog

All notable changes to the Maxmar Warehouse Flutter project will be documented in this file.

## [1.6.2] - 2026-06-24

### Added
- **Web Deployment Configuration**:
  - Implemented a premium dark-themed loading screen with double-ring glowing animations in `web/index.html`.
  - Added a MutationObserver and window event listener to automatically hide and remove the loading screen as soon as the Flutter framework initializes and renders.
  - Replaced the default Flutter favicon with the official Maxmar logo (`web/favicon.png`).
  - Added [deployment_shared_hosting.md](file:///c:/Projects/flutter_warehouse/.docs/deployment_shared_hosting.md) documentation and the `deploy.ps1` PowerShell script to automate web compilation, `.htaccess` injection, and force-pushing static assets to a dedicated `release-web` branch.

### Fixed
- **In-App Auto-Update System (Web Platform)**:
  - Modified [updater_service.dart](file:///c:/Projects/flutter_warehouse/lib/core/services/updater_service.dart) to skip version checks on the Web platform. Web users run the latest assets on reload, eliminating the redundant update pop-up on shared hosting deployments.

## [1.6.1] - 2026-06-23

### Fixed
- **Payment Request Form Error Handling**:
  - Imported `package:dio/dio.dart` in `payment_request_form_screen.dart` and implemented the `_getErrorMessage` helper method to extract and display actual error messages sent from the server. This replaces the generic `DioException` dialog content with user-friendly errors, such as indicating if an invoice is not in the correct status.

## [1.6.0] - 2026-06-11

### Added
- **Stock Opname (Physical Count) Module**:
  - Implemented `StockOpname` and `StockOpnameItem` models.
  - Built `StockOpnameRepository` mapping to lifecycle backend API routes.
  - Implemented `StockOpnameListScreen` to manage, create, and list sessions.
  - Developed `StockOpnameSessionScreen` supporting a dual split-pane layout on wide screens and a floating scanner overlay on mobile.
  - Integrated `MobileScanner` camera overlay for scanning SKU barcodes.
  - Designed a custom, touch-friendly numeric keypad modal allowing quick count edits (`+1`, `-1`, `Clear`, `Backspace`).
  - Added GoRouter routes mapping and a "Stock Opname" menu item config.
- **Documentation**:
  - Created [stock_opname.md](file:///c:/Projects/flutter_warehouse/.docs/stock_opname.md) detailing the Stock Opname lifecycle, API routes, and adaptive layout structure.

### Fixed
- **Valuasi Inventaris (Inventory Valuation) 404 Error**:
  - Cleared route configuration cache on the backend, resolving the 404 bad response and allowing the client to access `/api/v1/wh/inventory-report/valuation` and `/api/v1/wh/inventory-report/valuation/{sku}` correctly.

## [1.5.0] - 2026-06-11

### Added
- **Otomatis Buat Petak (Jumlah) Field**:
  - Configured the `jumlah_petak` (Otomatis Buat Petak) field on the Modul CRUD configuration in [aquaculture_crud_config.dart](file:///c:/Projects/flutter_warehouse/lib/features/usage/providers/aquaculture_crud_config.dart).
  - Added support for displaying `field.placeholder` as `hintText` in text and number fields in [aquaculture_crud_form_screen.dart](file:///c:/Projects/flutter_warehouse/lib/features/usage/ui/aquaculture_crud_form_screen.dart) to show inline help instructions.
- **Documentation**:
  - Created [aquaculture_crud.md](file:///c:/Projects/flutter_warehouse/.docs/aquaculture_crud.md) detailing the aquaculture CRUD layout system, company filtering, and auto-creation of Ponds and Cost Centres.

## [1.4.0] - 2026-06-10

### Added
- **iOS/Cupertino UI Theme & Foundations**:
  - Replaced root `MaterialApp` with `CupertinoApp` to align with native iOS design principles.
  - Implemented dynamic global theme switching (`light`, `dark`, or `system` modes) utilizing Riverpod (`themeModeProvider` in `theme_provider.dart`).
  - Added dedicated iOS theme configuration using `CupertinoThemeData` for automatic light/dark mode adaptation.
  - Replaced standard Material `Icons` with native Apple `CupertinoIcons` (e.g., `CupertinoIcons.square_grid_2x2` for dashboard, `CupertinoIcons.qrcode_viewfinder` for receiving, `CupertinoIcons.checkmark_seal` for approvals, `CupertinoIcons.tree` for operasional tambak).
- **Responsive Shell Layout Navigation**:
  - Custom responsive layout using `CupertinoTabBar` for mobile and a custom navigation sidebar drawer for desktop/tablet platforms.
  - Replaced Material context menus on collapsed sidebars with native Cupertino sheet popups (`showCupertinoModalPopup` and `CupertinoActionSheet`).
  - Implemented a custom lightweight submenu accordion (`_SubMenuAccordion`) to run independent of Material's `ExpansionTile`.
- **Cupertino Screens Migration**:
  - **Login Screen**: Migrated to `CupertinoPageScaffold`, using `CupertinoTextField` for text entry, `CupertinoSwitch` for "Remember Me" toggle, and `CupertinoButton.filled` for login execution with custom dynamic label styling.
  - **Dashboard Screen**: Migrated to `CupertinoPageScaffold` using `CupertinoSliverNavigationBar` with scrolling large titles. Replaced Material `Card` widgets with iOS-styled rounded containers and dynamic separator lines.
- **Interactive Inventory Valuation Screen**:
  - Implemented a premium 2-pane interactive screen for the **Inventory Valuation Report** under the Finance (**Keuangan**) section.
  - Linked the `/inventory-valuation` route and restricted access using the Spatie `view_payments` permission constraint.
  - Integrated standard Riverpod providers (`inventoryValuationListProvider` and `inventoryValuationBreakdownProvider`) and lightweight Dart DTO models.
  - Built direct action triggers in the AppBar to directly export PDF and Excel reports bypassing the preview screen (saving files to native downloads on desktop, and invoking native share sheets on mobile).

### Fixed
- **Compilation/Syntax Error in main_shell.dart**:
  - Resolved dynamic text style resolution issues inside the header title by removing the `const` keyword on the wrapping `Expanded` widget, fixing `Not a constant expression` compile errors on web/desktop.
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
