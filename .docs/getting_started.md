# Getting Started

## Prerequisites
- Flutter SDK 3.10.x or later
- Dart SDK 3.x
- VS Code or Android Studio

## Initial Setup
1. Clone the repository into `c:\Projects\flutter_warehouse`.
2. Run dependency fetch:
   ```bash
   flutter pub get
   ```
3. Run code generation (Critical):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

## Development Workflow
When adding new models or providers:
1. Define the class (Freezed or Riverpod Notifier).
2. Add the `part 'filename.freezed.dart';` and `part 'filename.g.dart';` headers.
3. Run `dart run build_runner watch` to auto-generate code on save.

## Multi-Platform Builds
- **Android**: `flutter build apk`
- **Windows**: `flutter build windows`
- **Web**: `flutter build web`

## Deployment
Ensure the `baseUrl` in `core/api/dio_client.dart` points to the production Laravel API before building for release.
