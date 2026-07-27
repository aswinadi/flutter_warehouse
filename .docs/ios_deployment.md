# iOS Deployment Guide for Maxmar Warehouse

Petunjuk lengkap untuk mengompilasi, menandatangani (signing), dan mendistribusikan aplikasi **Maxmar Warehouse** ke perangkat iOS (melalui TestFlight / App Store / Ad-Hoc Enterprise).

---

## 1. Persyaratan Lingkungan (Prerequisites)

1. **Sistem Operasi**: macOS dengan **Xcode 15+** terpasang.
2. **Apple Developer Account**: Akun pengembang Apple yang aktif (Individu/Organisasi).
3. **CocoaPods**: Pengelola dependensi native iOS.
   ```bash
   brew install cocoapods
   ```
4. **Flutter SDK**: Versi kompatibel dengan `pubspec.yaml` (Dart 3.x+).

---

## 2. Konfigurasi Proyek yang Telah Disiapkan

Aplikasi telah dikonfigurasi dengan pengaturan dasar iOS:

* **Bundle Identifier**: `com.maxmar.warehouse` (Diselaraskan dengan Android Application ID).
* **Izin Privasi (`ios/Runner/Info.plist`)**:
  * `NSCameraUsageDescription`: Untuk scanner Barcode/QR (`mobile_scanner`) & foto fisik stok.
  * `NSPhotoLibraryUsageDescription`: Untuk memilih gambar dari galeri (`image_picker`).
  * `NSPhotoLibraryAddUsageDescription`: Untuk menyimpan dokumen PDF/Laporan ke galeri.
* **Target Minimum iOS**: iOS 13.0.
* **Update System**: Penanganan iOS pada `updater_service.dart` diarahkan ke link TestFlight/App Store.

---

## 3. Konfigurasi Firebase (Jika Menggunakan Push Notification)

Jika fitur push notification Firebase FCM diaktifkan:
1. Buka [Firebase Console](https://console.firebase.google.com/).
2. Tambahkan aplikasi iOS baru dengan Bundle ID: `com.maxmar.warehouse`.
3. Unduh file `GoogleService-Info.plist`.
4. Buka proyek iOS di Xcode (`open ios/Runner.xcworkspace`).
5. Sret/drag file `GoogleService-Info.plist` ke dalam folder `Runner` di Xcode (pastikan centang *Copy items if needed* dan *Target: Runner*).

---

## 4. Langkah Kompilasi & Build Release (.ipa)

### Langkah A: Instalasikan Dependensi Native
```bash
flutter pub get
cd ios
pod install
cd ..
```

### Langkah B: Jalankan Command Build IPA
Untuk membuat bundle rilis iOS (`.ipa`):
```bash
flutter build ipa --release
```
Hasil file `.ipa` akan berada di folder:
`build/ios/archive/Runner.xcarchive` dan `build/ios/ipa/`

---

## 5. Distribusi ke TestFlight / App Store

### Cara 1: Menggunakan Xcode Organizer (Direkomendasikan)
1. Buka Xcode workspace:
   ```bash
   open ios/Runner.xcworkspace
   ```
2. Pilih target **Any iOS Device (arm64)** di toolbar atas Xcode.
3. Di menu bar, pilih **Product > Archive**.
4. Setelah proses kearsipan selesai, jendela **Organizer** akan terbuka.
5. Klik **Distribute App** > pilih **TestFlight & App Store** atau **Ad-Hoc**.
6. Ikuti petunjuk signing sertifikat dan upload otomatis ke App Store Connect.

### Cara 2: Menggunakan Command Line (CLI / Transporter)
1. Unduh aplikasi **Transporter** dari macOS App Store.
2. Drag & drop file `.ipa` yang ada di `build/ios/ipa/maxmar_warehouse.ipa` ke aplikasi Transporter, lalu klik **Deliver**.

---

## 6. Pertimbangan Khusus iOS

* **Desain UI**: Aplikasi sudah menggunakan guideline **iOS 26 Cupertino Liquid Glass** sesuai panduan [DESIGNS.md](file:///Users/aasaputra/Documents/projects/flutter_warehouse/DESIGNS.md).
* **Auto-Update**: Berbeda dengan Android (yang bisa download APK otomatis lewat `ota_update`), iOS membatasi instalasi binary di luar App Store/TestFlight. `updater_service.dart` akan mengarahkan pengguna iOS ke link App Store/TestFlight.
