# Changelog

All notable changes to the Maxmar Warehouse Flutter project will be documented in this file.

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
