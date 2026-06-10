# iOS/Cupertino UI Migration & Styling Guide

The `flutter_warehouse` application's UI has been migrated from Material 3 to a native iOS/Cupertino-style design. This guide documents the design principles, theme setup, component mappings, and best practices for extending or maintaining this UI.

---

## 🎨 Theme & Dynamic Colors

### 1. Cupertino Theme Data
The root application configuration utilizes `CupertinoApp` with a customized `CupertinoThemeData` defined in `lib/main.dart`. It configures standard active colors (`CupertinoColors.activeBlue`), backgrounds, and text styling for light and dark modes:

- **Light Mode**: Standard clean backgrounds utilizing `CupertinoColors.systemGroupedBackground` and `CupertinoColors.systemBackground`.
- **Dark Mode**: High-contrast, pure-black background design (`Color(0xFF000000)`) with elevated grouped backgrounds (`Color(0xFF1C1C1E)`) mapping to Apple's dark-mode iOS standard.

### 2. Riverpod Global Theme Switching
The application uses a Riverpod provider to manage the theme configuration:
- **Provider**: `themeModeProvider` in `lib/core/providers/theme_provider.dart`
- **Supported Modes**: `ThemeModeState.light`, `ThemeModeState.dark`, or `ThemeModeState.system` (automatically resolves the local operating system's brightness).
- **Theme Toggle Widget**: A clean Cupertino-styled button renders on both the desktop sidebar and mobile navigation bars to cycle between states.

### 3. Resolving Colors Dynamically
In Cupertino design, colors must adapt automatically to the active dark or light brightness mode.
> [!IMPORTANT]
> When using standard iOS dynamic colors (such as `CupertinoColors.label`, `CupertinoColors.secondarySystemGroupedBackground`, or `CupertinoColors.separator`) inside styles and decorations (e.g. `BoxDecoration`, `TextStyle`), they must be resolved against the active `BuildContext`.
> Use the `.resolveFrom(context)` helper:
> ```dart
> color: CupertinoColors.label.resolveFrom(context)
> ```
> *Note: Do not mark parent containers containing resolved colors as `const` or it will throw a compile-time "Not a constant expression" syntax error.*

---

## 🧩 Component Mappings (Material vs Cupertino)

To keep the application visual layout clean and compliant with Apple Human Interface Guidelines (HIG), standard Material widgets are mapped to Cupertino widgets:

| Material 3 Component | Cupertino Replacement | Notes |
| :--- | :--- | :--- |
| `MaterialApp` | `CupertinoApp` | Roots the Cupertino text layout and localization. |
| `Scaffold` | `CupertinoPageScaffold` | Used for single screens. |
| `AppBar` | `CupertinoNavigationBar` / `CupertinoSliverNavigationBar` | Set `largeTitle` inside a `CustomScrollView` to enable dynamic title shrinking on scroll. |
| `BottomNavigationBar` | `CupertinoTabBar` | Translucent, blurred backdrop with SF Symbols. |
| `Card` | `Container` | Styled with `CupertinoColors.secondarySystemGroupedBackground` and subtle `Border.all` borders using `CupertinoColors.separator`. |
| `TextField` | `CupertinoTextField` | Borderless style or light gray outline, padded, utilizing placeholder text. |
| `ElevatedButton` / `TextButton` | `CupertinoButton.filled` / `CupertinoButton` | Cupertino button styles with dynamic activity indicators when busy. |
| `Switch` / `Checkbox` | `CupertinoSwitch` | Cupertino iOS switch toggle for boolean states (e.g., "Remember Me"). |
| `Dialog` / `BottomSheet` | `CupertinoAlertDialog` / `CupertinoActionSheet` | Replaced sidebar context menus and modal alerts. |
| `ExpansionTile` | `_SubMenuAccordion` | Custom non-material expandable section widget used in the sidebar. |

---

## 📱 Layout Strategy & Squircles

- **Responsive Viewports**: The app layout wraps content using the `responsive_framework` package inside `main_shell.dart`.
  - **Desktop/Tablet Layout (width >= 768px)**: Collapsible sidebar navigation utilizing `CupertinoColors.secondarySystemGroupedBackground`.
  - **Mobile Layout (width < 768px)**: Bottom tab bar using `CupertinoTabBar` with standard iOS system colors.
- **Squircles**: All rounded corners on buttons, inputs, and cards use a squircle standard (`BorderRadius.circular(10)` or `12`) to align with iOS rounded rectangle conventions.

---

## 🛠 Adding New Screens

When creating a new screen or migrating other sub-features, adhere to this template:

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CupertinoExampleScreen extends ConsumerWidget {
  const CupertinoExampleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Resolve dynamic colors
    final labelColor = CupertinoColors.label.resolveFrom(context);
    final bgColor = CupertinoColors.systemGroupedBackground.resolveFrom(context);

    return CupertinoPageScaffold(
      backgroundColor: bgColor,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Example Screen'),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.info),
              onPressed: () {},
            ),
          ),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Cupertino content goes here.',
                    style: TextStyle(color: labelColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```
