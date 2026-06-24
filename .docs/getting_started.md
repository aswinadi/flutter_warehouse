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
Build command format is:
- **Android**: `flutter build apk`
- **Windows**: `flutter build windows`
- **Web**: `flutter build web`

### Build Versioning for Production Releases
To control version names and code increments when building for release (which dictates the behavior of the auto-update triggers), override the default `pubspec.yaml` version info at build time using the `--build-name` and `--build-number` parameters:
```bash
# Example building version 1.2.0 with build number 2
flutter build apk --release --build-name=1.2.0 --build-number=2
flutter build windows --release --build-name=1.2.0 --build-number=2
```
*Note: In Android, `--build-name` maps to `versionName` and `--build-number` maps to `versionCode`. In Windows, `--build-name` maps to major/minor/patch versions and `--build-number` maps to build suffix.*

## Deployment
- **Mobile (Android/iOS) & Desktop (Windows)**:
  1. Ensure the `baseUrl` in `core/api/dio_client.dart` points to the production Laravel API before building.
  2. Build the target platform artifacts with the updated `--build-number`.
  3. Upload the compiled APK/EXE files to the shared hosting web server download folder.
  4. Update the JSON manifest on the server (`/api/v1/wh/app-version`) with the corresponding `build_number` and URLs.
- **Web (Shared Hosting)**:
  - For step-by-step instructions on deploying the web application to shared hosting (e.g. at `warehouse.maxmar.net/user`), see the [deployment_shared_hosting.md](deployment_shared_hosting.md) guide.
