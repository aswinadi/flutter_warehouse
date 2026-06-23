# Warehouse Flutter Project Architecture

## Tech Stack
- **Framework**: Flutter (Multi-platform: Android, Web, Windows)
- **State Management**: Riverpod 2.x (with code generation)
- **Networking**: Dio with custom Interceptors
- **Routing**: GoRouter (ShellRoute for adaptive UI)
- **Models**: Freezed (Immutable models)
- **Persistence**: Flutter Secure Storage (Auth Tokens)
- **Scanning**: Mobile Scanner (QR/Barcode)
- **Printing**: Network Raw Sockets (ZPL II & ESC/POS)
- **Reporting**: PDF & Excel (xlsx)

## Folder Structure
```text
lib/
├── core/
│   ├── api/          # Dio Client, Interceptors, Router
│   ├── config/       # Navigation items configuration (menu_items.dart)
│   ├── providers/    # Theme and Company Providers
│   ├── services/     # Printer, Reporting, Barcode Utils, Auto-Updater
│   ├── theme/        # Spacing and Theme extensions
│   └── widgets/      # MainShell (Adaptive UI), Company Switcher, PDF Preview
├── features/
│   ├── approvals/    # BOD Purchase Request approval workflows
│   ├── auth/         # Login & Session Management
│   ├── dashboard/    # Main navigation hub and summary cards
│   ├── finance/      # Inventory Valuation reports
│   ├── inventory/    # Stock view, Adjustments, Assets, and Stock Opname (Physical Count)
│   ├── invoice/      # Purchase Invoices (Faktur) and Expense Invoices
│   ├── notifications/# Push and in-app notifications
│   ├── packing_list/ # Branch packing lists & Container manifests
│   ├── payment_request/ # Payment Request creation & details
│   ├── purchase_order/ # PO tracking & progress
│   ├── purchase_request/ # PR listing, details, and creations
│   ├── receiving/    # Standard Supplier PO receiving & Container Depot receiving (Depo Sync)
│   ├── transfer/     # Inter-depot Transfer Out and Transfer In
│   └── usage/        # Aquaculture CRUDs (Tambak, Blok, Modul, Ponds, Cycles, Contracts) and Shrimp Price Calculator
└── main.dart         # Entry point & Cupertino theme setup
```

## State Management Pattern
We use **Riverpod Generator**. 
- Async data is handled via `FutureProvider` or `AsyncNotifier`.
- Authentication bearer tokens are injected automatically via the Dio Interceptor, whereas the active `company_id` is watched manually from `selectedCompanyProvider` and passed as required by repositories.

## Responsive Design
We use `responsive_framework` with standard breakpoints:
- **Mobile**: Bottom Navigation + Single Column
- **Desktop/Web**: Sidebar Navigation + Multi-column layouts

## UI & Theme Architecture
The application UI utilizes the iOS/Cupertino widget system:
- **Cupertino Foundation**: Swapped root `MaterialApp` with `CupertinoApp` and implemented dedicated `CupertinoThemeData` for styling.
- **Dynamic Light/Dark Mode**: Built a Riverpod provider (`themeModeProvider` in `lib/core/providers/theme_provider.dart`) to manage global theme states (`light`, `dark`, `system`).
- **Dynamic Color Resolution**: Dynamic semantic Cupertino colors (such as `CupertinoColors.label`, `CupertinoColors.secondarySystemGroupedBackground`, `CupertinoColors.separator`) are dynamically resolved using `.resolveFrom(context)` to adapt seamlessly to theme brightness toggles.

## Dynamic Navigation & Role-Based Access Control (RBAC)
We employ a centralized navigation configuration defined in [menu_items.dart](file:///C:/Projects/flutter_warehouse/lib/core/config/menu_items.dart) that acts as the single source of truth for both the Sidebar and the Dashboard Grid:
- **RBAC Model**: Extends the `User` model with `roles` and `permissions` matching Spatie / Filament Shield schemas.
- **Super Admin Bypass**: If a user carries the `super_admin` role, all permission requirements are bypassed automatically.
- **Permission Checking**: Dynamic evaluation uses `user.effectivePermissions`, which combines API-returned permissions with local rule overrides (e.g. mapping `approvalTypes` to `'approve_pr'`).
- **Placeholder Routes**: Navigation nodes with `path: null` are rendered as placeholder options with localized "coming soon" snackbars. They are automatically hidden on mobile bottom navigation bars.

## Localization & Internationalization (l10n)
Internationalization is powered by standard Flutter toolchain code-generation:
- **Config**: Configured in [l10n.yaml](file:///C:/Projects/flutter_warehouse/l10n.yaml) with translation keys placed in `lib/l10n/`.
- **Dictionaries**: Dictionaries are written in Application Resource Bundle format: [app_id.arb](file:///C:/Projects/flutter_warehouse/lib/l10n/app_id.arb) (Indonesian - default locale) and [app_en.arb](file:///C:/Projects/flutter_warehouse/lib/l10n/app_en.arb) (English - fallback locale).
- **Binding**: Resolved in widgets using standard delegate lookups `AppLocalizations.of(context)!` and dynamic label builder delegates: `labelBuilder: (l10n) => l10n.dashboard`.

