# Panduan Desain: iOS 26 Cupertino - Liquid Glass (Flutter)

Dokumen ini merupakan acuan desain resmi untuk proyek Flutter. Semua pengembangan antarmuka (UI) dan komponen harus mematuhi panduan, token, dan prinsip yang dijelaskan di bawah ini untuk memastikan konsistensi, keindahan estetika premium, dan performa yang optimal.

---

## 1. Visi Desain: iOS 26 & Liquid Glass

Desain **iOS 26 Liquid Glass** menggabungkan kesederhanaan struktural khas Apple Cupertino dengan estetika kaca cair masa depan (liquid glassmorphism). Gaya ini menekankan pada **refraksi cahaya**, **kedalaman spasial organic**, **transparansi dinamis**, dan **leakage warna** dari latar belakang.

### Karakteristik Utama:
- **Material Transkutan (Translucent Materials)**: Komponen utama melayang di atas latar belakang gradasi warna-warni dinamis (mesh gradients) menggunakan efek blur berkualitas tinggi.
- **Specular Border Highlights**: Garis tepi ultra-tipis (0.5pt) dengan warna putih transparan (pada mode gelap) atau hitam transparan (pada mode terang) untuk mensimulasikan pembiasan cahaya di tepi kaca.
- **Organic Depth**: Penggunaan tingkat blur (blur sigma) dan opasitas yang bervariasi untuk menciptakan hierarki visual (kedalaman spasial) dari elemen terdekat hingga terjauh.
- **Squircles**: Radius sudut yang sangat mulus khas iOS (continuous corner curves) pada semua elemen kartu dan tombol.

---

## 2. Sistem Token Desain

### A. Palet Warna (Liquid Glass Palette)

Warna dalam Liquid Glass tidak bersifat statis, melainkan adaptif terhadap pencahayaan latar belakang dan mode gelap/terang.

#### Latar Belakang & Gradasi Mesh (Backgrounds)
| Token | Deskripsi | Nilai Terang | Nilai Gelap |
|---|---|---|---|
| `{colors.bg-mesh-1}` | Aksen gradasi primer | `#E8F0FE` (Biru Muda) | `#0B1528` (Biru Gelap) |
| `{colors.bg-mesh-2}` | Aksen gradasi sekunder | `#F3E8FF` (Ungu Muda) | `#1A0B2E` (Ungu Gelap) |
| `{colors.bg-mesh-3}` | Aksen gradasi tersier | `#FFF1F2` (Rose Muda) | `#2A0815` (Rose Gelap) |

#### Translucency (Kaca Liquid)
| Token | Deskripsi | Nilai Terang (Light Mode) | Nilai Gelap (Dark Mode) |
|---|---|---|---|
| `{glass.surface-thin}` | Kaca tipis / Input | `Color(0x77FFFFFF)` (Opasitas ~45%) | `Color(0x331C1C1E)` (Opasitas ~20%) |
| `{glass.surface-medium}` | Kaca standar / Kartu | `Color(0xAAFFFFFF)` (Opasitas ~66%) | `Color(0x551C1C1E)` (Opasitas ~33%) |
| `{glass.surface-thick}` | Kaca tebal / Dialog / Sheet | `Color(0xEEFFFFFF)` (Opasitas ~93%) | `Color(0x881C1C1E)` (Opasitas ~53%) |
| `{glass.border-light}` | Specular border kaca | `Color(0x1F000000)` (Hitam 12%) | `Color(0x22FFFFFF)` (Putih 13%) |
| `{glass.border-strong}` | Border untuk kontrol aktif | `Color(0x3D000000)` (Hitam 24%) | `Color(0x44FFFFFF)` (Putih 27%) |

#### Warna Aksen & Teks
| Token | Deskripsi | Mode Terang | Mode Gelap |
|---|---|---|---|
| `{colors.primary}` | Cupertino Active Blue | `#007AFF` | `#0A84FF` |
| `{colors.success}` | Cupertino Active Green | `#34C759` | `#30D158` |
| `{colors.warning}` | Cupertino Active Orange | `#FF9500` | `#FF9F0A` |
| `{colors.danger}` | Cupertino Active Red | `#FF3B30` | `#FF453A` |
| `{colors.label}` | Teks utama | `#000000` | `#FFFFFF` |
| `{colors.secondary-label}` | Teks sekunder | `#3C3C43` (Opasitas 60%) | `#EBEBF5` (Opasitas 60%) |

---

### B. Skala Blur & Ketinggian (Blur & Depth Scale)

Kedalaman spasial diatur berdasarkan kekuatan blur (`blurSigma`) dan bayangan yang halus.

| Kedalaman | Blur Sigma | Opasitas | Shadow Treatment | Penggunaan |
|---|---|---|---|---|
| **Level 0 (Flat)** | `0` | 100% | Tanpa shadow | Latar belakang dasar screen |
| **Level 1 (Subtle)** | `10.0` | 45% (Thin) | `rgba(0,0,0,0.02)` | Input text field, progress bar |
| **Level 2 (Card)** | `15.0` | 66% (Medium) | `rgba(0,0,0,0.06)` shadow | Kartu utama, item list |
| **Level 3 (Floating)** | `20.0` | 75% | `rgba(0,0,0,0.12)` shadow | Floating Action Button, Toast |
| **Level 4 (Overlay)** | `30.0` | 93% (Thick) | `rgba(0,0,0,0.20)` shadow | Dialog popup, Action Sheet |

---

### C. Tipografi (iOS 26 Typography)

Menggunakan font sistem Apple (**SF Pro** atau **Inter** sebagai fallback) dengan penekanan pada keterbacaan di atas kaca transparan.

| Token | Ukuran (Size) | Ketebalan (Weight) | Letter Spacing | Penggunaan |
|---|---|---|---|---|
| `{typography.large-title}` | 34pt | Bold (700) | `0.38` | Judul utama halaman (Nav Bar) |
| `{typography.title-1}` | 28pt | SemiBold (600) | `0.34` | Judul section besar |
| `{typography.title-2}` | 22pt | Medium (500) | `0.35` | Judul kartu besar |
| `{typography.headline}` | 17pt | SemiBold (600) | `-0.41` | Header standar, judul dialog |
| `{typography.body}` | 17pt | Regular (400) | `-0.41` | Teks isi utama |
| `{typography.callout}` | 16pt | Medium (500) | `-0.32` | Label tombol utama, badge info |
| `{typography.subhead}` | 15pt | Regular (400) | `-0.24` | Deskripsi form, teks sekunder |
| `{typography.footnote}` | 13pt | Regular (400) | `-0.08` | Metadatar, waktu transaksi |
| `{typography.caption}` | 12pt | Medium (500) | `0.0` | Label navigasi bawah, tag chip |

---

### D. Geometri & Radius Sudut (Shapes)

Mengikuti standar kontinuasi sudut iOS (*Squircle*) agar tidak terkesan kasar atau kaku.

| Token | Radius | Penggunaan |
|---|---|---|
| `{radius.sm}` | `8.0` | Tombol kecil, tag chip, segmented control indicator |
| `{radius.md}` | `12.0` | Tombol utama, input text field, Toast |
| `{radius.lg}` | `16.0` | Kartu utama, card dashboard, item list |
| `{radius.xl}` | `24.0` | Bottom sheet, dialog popup |
| `{radius.full}` | `9999.0` | Badges, avatar bulat, search-pill |

---

## 3. Implementasi Komponen Utama di Flutter

Berikut adalah panduan kode implementasi widget yang telah disesuaikan dengan standar **Cupertino iOS 26 Liquid Glass**.

### A. Kontainer Kaca (`CupertinoGlassContainer`)

Widget dasar untuk membungkus elemen UI agar memiliki efek kaca transparan dinamis.

```dart
import 'dart:ui';
import 'package:flutter/cupertino.dart';

class CupertinoGlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blurSigma;
  final EdgeInsetsGeometry? padding;
  final double borderWidth;

  const CupertinoGlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 16.0, // Menggunakan {radius.lg}
    this.blurSigma = 15.0,    // Menggunakan Level 2 (Card)
    this.padding = const EdgeInsets.all(16.0),
    this.borderWidth = 0.5,   // Specular border tipis
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;

    final defaultBg = isDark
        ? const Color(0x551C1C1E) // Kaca gelap adaptif
        : const Color(0xAAFFFFFF); // Kaca terang adaptif

    final defaultBorder = isDark
        ? const Color(0x22FFFFFF) // Specular highlight putih
        : const Color(0x1F000000); // Specular highlight hitam

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: defaultBg,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: defaultBorder,
              width: borderWidth,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
```

---

### B. Dialog Kaca (`CupertinoGlassDialog`)

Tampilan popup modal yang elegan dengan tingkat kekacaan tebal untuk mengisolasi konten dialog.

```dart
import 'package:flutter/cupertino.dart';
import 'cupertino_glass_container.dart';

class CupertinoGlassDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<CupertinoGlassDialogAction> actions;

  const CupertinoGlassDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40.0),
        child: CupertinoGlassContainer(
          borderRadius: 24.0, // {radius.xl}
          blurSigma: 30.0,   // Level 4 (Overlay)
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.41,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      content,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.08,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const Container(height: 0.5, color: Color(0x1F000000)),
              Row(
                children: actions.map((action) => Expanded(child: action)).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CupertinoGlassDialogAction extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isDestructive;

  const CupertinoGlassDialogAction({
    super.key,
    required this.label,
    required this.onPressed,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: isDestructive ? CupertinoColors.destructiveRed : CupertinoColors.activeBlue,
          fontWeight: isDestructive ? FontWeight.w400 : FontWeight.w600,
          fontSize: 17,
        ),
      ),
    );
  }
}
```

### C. Tombol Pilihan & Kontrol Segmen (Choice Chips & Segmented Control)

Di dalam panduan desain **iOS 26 Liquid Glass**, pemilihan opsi diatur menggunakan dua jenis gaya berdasarkan fungsinya:

1. **Gaya Pill (Pill Style) — Direkomendasikan untuk Choice Chips / Filter Dinamis**
   - **Bentuk**: Oval/kapsul penuh (`{radius.full}` / `9999.0`).
   - **Fungsi**: Digunakan untuk filter data dinamis, opsi multi-select, atau tag pilihan (contoh: memfilter kategori item, status pengiriman, atau filter area gudang).
   - **Estetika**: Menggunakan latar belakang kaca tipis (`{glass.surface-thin}`) dan border halus saat tidak aktif. Ketika dipilih, ia akan bertransisi menjadi warna solid yang menyala dengan kontras tinggi (misalnya warna biru aksen).

2. **Gaya Tab Tersegmentasi (Segmented Control) — Direkomendasikan untuk Pilihan Eksklusif Tunggal**
   - **Bentuk**: Persegi bersudut melengkung halus (`{radius.sm}` atau `8.0`).
   - **Fungsi**: Digunakan untuk beralih di antara opsi eksklusif yang bersifat statis dan terbatas (2 sampai 4 opsi saja, contoh: memilih periode "Harian / Mingguan / Bulanan" atau status persetujuan "Menunggu / Disetujui / Ditolak").
   - **Estetika**: Wadah luar berupa kaca tipis panjang dengan sudut melengkung, dan tombol yang aktif berupa sliding solid-pill putih (atau abu-abu pada mode gelap) dengan bayangan halus yang meluncur secara organik.

#### Kode Implementasi Choice Chip Kaca (`CupertinoGlassChoiceChip`)
```dart
import 'dart:ui';
import 'package:flutter/cupertino.dart';

class CupertinoGlassChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const CupertinoGlassChoiceChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;

    // Definisikan warna glass adaptif
    final bgInactive = isDark 
        ? const Color(0x22FFFFFF) // Putih transparan tipis pada dark mode
        : const Color(0x11000000); // Hitam transparan tipis pada light mode
    
    final bgActive = CupertinoTheme.of(context).primaryColor.withOpacity(0.85);

    final borderInactive = isDark ? const Color(0x1FFFFFFF) : const Color(0x0F000000);
    final borderActive = CupertinoTheme.of(context).primaryColor.withOpacity(0.3);

    final textColor = isSelected
        ? CupertinoColors.white
        : (isDark ? CupertinoColors.lightBackgroundGray : CupertinoColors.darkBackgroundGray);

    return GestureDetector(
      onTap: () => onSelected(!isSelected),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9999.0), // {radius.full}
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: isSelected ? bgActive : bgInactive,
              borderRadius: BorderRadius.circular(9999.0),
              border: Border.all(
                color: isSelected ? borderActive : borderInactive,
                width: 0.5,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 13.0, // {typography.footnote}
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

### D. Kontrol Input Tambahan (Search, Checkbox, Checklist, & Radio)

Untuk melengkapi kontrol interaktif di aplikasi, berikut adalah panduan dan implementasi visual untuk elemen pencarian, kotak centang (*checkbox*), daftar centang (*checklist*), dan tombol opsi (*radio/option button*):

---

#### 1. Search Text (Input Pencarian Kaca)
- **Bentuk**: Kapsul/Pill penuh (`{radius.full}`).
- **Estetika**: Menggunakan latar belakang kaca tipis `{glass.surface-thin}` dengan pembiasan `blurSigma: 10.0` dan border specular tipis (0.5pt). Ikon pencarian berada di sisi kiri dan tombol hapus teks di sisi kanan.
- **Fokus**: Saat disentuh (focus), border kaca berubah menjadi warna biru aksen (`{colors.primary}`) dan latar belakang kaca menjadi sedikit lebih terang untuk meningkatkan visibilitas.

```dart
class CupertinoGlassSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final ValueChanged<String>? onChanged;

  const CupertinoGlassSearchField({
    super.key,
    required this.controller,
    this.placeholder = 'Cari...',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    
    final defaultBg = isDark ? const Color(0x331C1C1E) : const Color(0x77FFFFFF);
    final defaultBorder = isDark ? const Color(0x22FFFFFF) : const Color(0x1F000000);

    return ClipRRect(
      borderRadius: BorderRadius.circular(9999.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: CupertinoSearchTextField(
          controller: controller,
          placeholder: placeholder,
          onChanged: onChanged,
          placeholderStyle: TextStyle(
            color: isDark ? const Color(0x99FFFFFF) : const Color(0x993C3C43),
            fontSize: 15.0,
          ),
          style: TextStyle(
            color: isDark ? CupertinoColors.white : CupertinoColors.black,
            fontSize: 15.0,
          ),
          decoration: BoxDecoration(
            color: defaultBg,
            borderRadius: BorderRadius.circular(9999.0),
            border: Border.all(
              color: defaultBorder,
              width: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
```

---

#### 2. Checkbox (Kotak Centang Kaca)
- **Bentuk**: Squircle kecil bersudut melengkung halus (`{radius.sm}` / `8.0`).
- **Fungsi**: Digunakan untuk opsi biner mandiri yang memerlukan persetujuan pengguna.
- **Estetika**: 
  - *Unchecked*: Kontainer transparan tipis dengan border specular 0.5pt.
  - *Checked*: Berubah warna menjadi biru aksen solid (`{colors.primary}`) dengan ikon centang putih `CupertinoIcons.checkmark` berukuran kecil.

```dart
class CupertinoGlassCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CupertinoGlassCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;

    final bgInactive = isDark ? const Color(0x22FFFFFF) : const Color(0x11000000);
    final borderInactive = isDark ? const Color(0x33FFFFFF) : const Color(0x22000000);
    final primaryColor = CupertinoTheme.of(context).primaryColor;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 22.0,
        height: 22.0,
        decoration: BoxDecoration(
          color: value ? primaryColor : bgInactive,
          borderRadius: BorderRadius.circular(6.0), // Continuous Squircle {radius.sm}
          border: Border.all(
            color: value ? primaryColor : borderInactive,
            width: 0.8,
          ),
        ),
        child: value
            ? const Icon(
                CupertinoIcons.checkmark,
                size: 14.0,
                color: CupertinoColors.white,
              )
            : null,
      ),
    );
  }
}
```

---

#### 3. Checklist (Daftar Centang Baris)
- **Bentuk**: Baris list transparan datar dengan kontainer kaca terpisah.
- **Estetika**: Setiap baris berupa `CupertinoGlassContainer` dengan ketebalan sedang (`{glass.surface-medium}`). Bila baris dipilih, indikator centang berupa `CupertinoIcons.checkmark` berwarna biru aksen akan muncul di sisi paling kanan (*trailing*), dan baris tersebut dapat memiliki efek sorotan (*highlight*) warna biru transparan yang halus di latar belakangnya.

---

#### 4. Option Button (Radio Button Kaca)
- **Bentuk**: Lingkaran sempurna (`{radius.full}`).
- **Fungsi**: Memilih satu dari beberapa opsi eksklusif.
- **Estetika**:
  - *Unselected*: Lingkaran luar berupa kaca transparan dengan border specular tipis, bagian tengah kosong.
  - *Selected*: Lingkaran luar diisi warna aksen transparan, dan di tengah terdapat lingkaran solid berwarna putih (atau warna aksen pekat) dengan ukuran yang lebih kecil (rasio diameter ~50%).

```dart
class CupertinoGlassRadioButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const CupertinoGlassRadioButton({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final primaryColor = CupertinoTheme.of(context).primaryColor;

    final bgInactive = isDark ? const Color(0x22FFFFFF) : const Color(0x11000000);
    final borderInactive = isDark ? const Color(0x33FFFFFF) : const Color(0x22000000);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22.0,
        height: 22.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? primaryColor.withOpacity(0.2) : bgInactive,
          border: Border.all(
            color: isSelected ? primaryColor : borderInactive,
            width: 1.0,
          ),
        ),
        child: isSelected
            ? Center(
                child: Container(
                  width: 10.0,
                  height: 10.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: CupertinoColors.white,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
```

---

### E. Switch / Toggle Kaca (`CupertinoGlassSwitch`)
- **Fungsi**: Mengubah pengaturan biner (on/off) secara instan.
- **Estetika**: Jalur sakelar menggunakan kaca tipis (`{glass.surface-thin}`). Saat aktif (on), jalur berubah warna menjadi hijau solid aksen (`{colors.success}`) dengan opasitas 85%, dipadukan dengan tombol geser bulat putih solid yang meluncur secara organik.

```dart
class CupertinoGlassSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CupertinoGlassSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
      activeColor: CupertinoColors.activeGreen.withOpacity(0.85),
      trackColor: isDark 
          ? const Color(0x33FFFFFF) // Kaca tipis gelap
          : const Color(0x22000000), // Kaca tipis terang
      thumbColor: CupertinoColors.white,
    );
  }
}
```

---

### F. Toast / Notifikasi Melayang (`CupertinoGlassToast`)
- **Fungsi**: Menyajikan umpan balik transien yang cepat tanpa menghentikan aktivitas pengguna (misal: "Gudang diubah", "Sukses menyimpan data").
- **Estetika**: Mengambang di atas layar (`{radius.full}`) dengan blur tinggi (`blurSigma: 20.0` / Level 3), warna dasar kaca tebal (`{glass.surface-thick}`), serta bayangan halus. Dilengkapi animasi masuk meluncur halus (*slide-in*).

```dart
import 'dart:ui';
import 'package:flutter/cupertino.dart';

class CupertinoGlassToast extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color iconColor;

  const CupertinoGlassToast({
    super.key,
    required this.message,
    required this.icon,
    required this.iconColor,
  });

  // Fungsi static untuk memicu Overlay Toast di aplikasi
  static void show(
    BuildContext context, 
    String message, {
    IconData icon = CupertinoIcons.info, 
    Color iconColor = CupertinoColors.activeBlue,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16.0,
        left: 16.0,
        right: 16.0,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, -20 * (1.0 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: SafeArea(
            top: false,
            child: CupertinoGlassToast(
              message: message,
              icon: icon,
              iconColor: iconColor,
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 3), () {
      entry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final defaultBg = isDark ? const Color(0x771C1C1E) : const Color(0xDDFFFFFF);

    return Align(
      alignment: Alignment.topCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9999.0), // {radius.full}
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: defaultBg,
              borderRadius: BorderRadius.circular(9999.0),
              border: Border.all(
                color: isDark ? const Color(0x22FFFFFF) : const Color(0x1F000000),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: iconColor, size: 20.0),
                const SizedBox(width: 10.0),
                Flexible(
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

---

### G. Bottom Sheet / Action Sheet Kaca (`CupertinoGlassBottomSheet`)
- **Fungsi**: Menu lembaran tarik bawah yang meluncur dari bagian bawah layar untuk menu tambahan, daftar aksi, atau form input cepat.
- **Estetika**: Radius sudut bagian atas melengkung lebar (`{radius.xl}` / `24.0`). Menggunakan kaca tebal adaptif dengan blur penuh `30.0` (Level 4 - Overlay).

```dart
class CupertinoGlassBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;

  const CupertinoGlassBottomSheet({
    super.key,
    required this.title,
    required this.child,
  });

  static void show(BuildContext context, {required String title, required Widget child}) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoGlassBottomSheet(title: title, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final defaultBg = isDark ? const Color(0x991C1C1E) : const Color(0xEEFFFFFF);

    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom + 16.0,
              top: 16.0,
              left: 16.0,
              right: 16.0,
            ),
            decoration: BoxDecoration(
              color: defaultBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
              border: Border.all(
                color: isDark ? const Color(0x22FFFFFF) : const Color(0x1F000000),
                width: 0.5,
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36.0,
                      height: 5.0,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0x44FFFFFF) : const Color(0x22000000),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Flexible(child: child),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

---

### H. Loading Indicator / Spinner Kaca (`CupertinoGlassLoadingIndicator`)
- **Fungsi**: Dialog pemuatan sistem yang memblokir layar sementara selama proses sinkronisasi API.
- **Estetika**: Kontainer kaca kecil simetris di visual center (`110x110` pt), membungkus `CupertinoActivityIndicator` dengan deskripsi teks sekunder yang bersih di bawahnya.

```dart
class CupertinoGlassLoadingIndicator extends StatelessWidget {
  final String? message;

  const CupertinoGlassLoadingIndicator({
    super.key,
    this.message,
  });

  static void show(BuildContext context, {String? message}) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoGlassLoadingIndicator(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoGlassContainer(
        width: 110.0,
        height: 110.0,
        borderRadius: 16.0,
        blurSigma: 20.0,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CupertinoActivityIndicator(
              radius: 14.0,
            ),
            if (message != null) ...[
              const SizedBox(height: 12.0),
              Text(
                message!,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: CupertinoColors.secondaryLabel,
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
```

---

### I. Grouped List / Card List Kaca (`CupertinoGlassListSection`)
- **Fungsi**: Menyusun daftar menu, informasi baris detail, atau pengaturan profil.
- **Estetika**: Membungkus beberapa `CupertinoListTile` ke dalam satu `CupertinoGlassContainer` terpadu. Antar baris diberi separator garis pemisah tipis `0.5pt` dengan margin kiri `16pt` untuk meluruskan teks.

```dart
class CupertinoGlassListSection extends StatelessWidget {
  final String? header;
  final List<Widget> children;

  const CupertinoGlassListSection({
    super.key,
    this.header,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;
    final dividerColor = isDark ? const Color(0x1AFFFFFF) : const Color(0x0A000000);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header != null)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text(
              header!.toUpperCase(),
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
          ),
        CupertinoGlassContainer(
          padding: EdgeInsets.zero,
          borderRadius: 16.0,
          child: Column(
            children: List.generate(children.length, (index) {
              return Column(
                children: [
                  children[index],
                  if (index < children.length - 1)
                    Container(
                      height: 0.5,
                      margin: const EdgeInsets.only(left: 54.0), // Menyesuaikan offset ikon list tile
                      color: dividerColor,
                    ),
                ],
              );
            }),
          ),
        ),
    );
  }
}
```

---

### J. Kartu & Item List Aktif (Active/Selected Card List Item)
- **Fungsi**: Menunjukkan item yang sedang aktif/terpilih pada daftar master (Master View) dalam tata letak split screen (Tablet/Desktop).
- **Estetika**:
  - *Unselected*: Menggunakan border tipis default kaca (`null`) dan latar belakang default kaca (`null`) agar konsisten dengan efek glassmorphism dasar.
  - *Selected/Active*:
    - **Border**: Highlight menggunakan warna aksen biru aktif (`CupertinoColors.activeBlue`).
    - **Background**: Menggunakan warna aksen biru aktif dengan opasitas tipis (`CupertinoColors.activeBlue.withValues(alpha: 0.08)`).
- **Aturan**:
  - Penanda aktif (`isSelected`) hanya boleh ditampilkan secara visual apabila layar berada dalam mode lebar (`isWide`) di mana panel daftar dan detail tampil berdampingan, guna menghindari getaran visual (flashing) saat navigasi berpindah di layar ponsel (Mobile).

```dart
CupertinoGlassContainer(
  borderRadius: CupertinoSpacing.cardRadius,
  borderColor: isSelected ? CupertinoColors.activeBlue.resolveFrom(context) : null,
  backgroundColor: isSelected ? CupertinoColors.activeBlue.resolveFrom(context).withValues(alpha: 0.08) : null,
  child: child,
)
```

---

## 4. Panduan Desain Layout & Grid

1. **Gunakan Latar Belakang Gradien Halus**:
   - Liquid Glass membutuhkan variasi warna di latar belakang dasar agar pembiasan (blur) terlihat menonjol. Gunakan widget `BoxDecoration` dengan `RadialGradient` atau `LinearGradient` pada root screen.
2. **Margin Layar Standar (16pt)**:
   - Gunakan padding konstan `16.0` (`CupertinoSpacing.screenMargin`) di sisi kiri dan kanan layar untuk menyelaraskan elemen secara grid.
3. **Ketebalan Grid Baris**:
   - Untuk daftar item di atas kaca, gunakan jarak pemisah `8.0` atau `12.0` pt antar kartu agar kedalamannya tetap terasa dan tidak terlihat menumpuk terlalu rapat.

---

## 5. Arsitektur & Aturan Multi-Company (Company Filter)

Karena aplikasi ini digunakan oleh beberapa perusahaan secara bersamaan (*multi-tenant*), seluruh halaman (screen) wajib mematuhi aturan manajemen dan filter perusahaan berikut:

### A. Penempatan & UX Selector
1. **Penempatan di Navigation Bar**: 
   - Selector perusahaan wajib diletakkan di header halaman (misalnya di area trailing `CupertinoSliverNavigationBar` atau di bawah judul utama sebagai sub-header yang tipis).
   - Gunakan bentuk pill glassmorphic transparan (`{radius.full}`) dengan border 0.5pt dan teks nama perusahaan yang sedang terpilih.
2. **Interaksi Picker**:
   - Ketika selector diketuk, aplikasi harus memicu sheet pop-up Cupertino (`showCupertinoModalPopup` dengan `CupertinoActionSheet`) atau dialog kaca khusus (`CupertinoGlassDialog`) yang memuat daftar perusahaan yang tersedia.
   - Transisi perubahan perusahaan harus diiringi dengan indikator pemuatan (*glass loading spinner*) sebelum konten layar diperbarui.

### B. Aturan Hak Akses & Cross-Company
1. **Hak Akses Terbatas (Standard User)**:
   - Pengguna dengan akses standar hanya dapat melihat data dari satu perusahaan tempat mereka bernaung.
   - Pada profil pengguna ini, selector perusahaan harus **dinonaktifkan (disabled)** atau disembunyikan sepenuhnya dari layar, dengan filter query API otomatis dikunci ke ID perusahaan milik pengguna tersebut (`company_id`).
2. **Hak Akses Cross-Company (Superadmin / Management)**:
   - Pengguna dengan hak akses khusus (seperti Superadmin, Direktur, atau tim Audit) diperbolehkan melihat data lintas perusahaan (*cross-company*).
   - Untuk pengguna ini, selector perusahaan harus **aktif dan dapat diubah**.
   - Selector juga harus menyediakan opsi **"Semua Perusahaan" (All Companies)** di dalam daftar pilihan untuk menampilkan agregasi data dari seluruh unit bisnis di layar dashboard atau laporan.

### C. Konsistensi State
- Pilihan filter perusahaan harus disimpan ke dalam state global (misalnya menggunakan Riverpod/Bloc) agar ketika pengguna berpindah ke screen lain, filter perusahaan yang dipilih tetap bertahan (*persistent state*), kecuali halaman tersebut merupakan detail transaksi spesifik yang terikat pada satu entitas.

---

## 6. Do's & Don'ts (Boleh & Tidak Boleh)

### Boleh (Do):
- **Gunakan kontras teks yang kuat**: Karena latar belakang bersifat transparan, pastikan teks di atas kontainer kaca menggunakan warna label adaptif (`CupertinoColors.label.resolveFrom(context)`).
- **Pertahankan ketebalan border 0.5**: Ini adalah kunci dari visual "kaca yang nyata". Border yang terlalu tebal akan membuat container tampak seperti plastik.
- **Implementasikan getaran haptik (Haptic Feedback)**: Hubungkan interaksi tombol kaca dengan getaran lembut (`HapticFeedback.lightImpact()`) untuk meningkatkan sensasi fisik.

### Tidak Boleh (Don't):
- **Jangan menumpuk `BackdropFilter` secara bertingkat**: Melakukan *nested blur* (kontainer kaca di dalam kontainer kaca lainnya dengan efek blur aktif pada keduanya) sangat membebani GPU perangkat. Gunakan container transparan biasa (tanpa blur) untuk elemen anak.
- **Jangan gunakan drop shadow yang terlalu pekat**: Shadow pada kaca harus sangat tipis dan halus agar tidak merusak ilusi transparansi.
- **Jangan gunakan latar belakang polos putih/hitam pekat tanpa gradasi**: Efek liquid glassmorphism tidak akan terlihat bekerja jika latar belakangnya polos satu warna datar.

---

## 7. Tips Optimasi Performa Rendering di Flutter

Efek pembiasan (`BackdropFilter`) adalah proses rendering yang cukup berat. Ikuti panduan ini agar aplikasi tetap berjalan lancar pada 60fps / 120fps:
1. **Gunakan Caching pada Gambar/Latar Belakang**: Latar belakang gradien harus statis atau tidak mengalami animasi pergeseran warna yang terlalu cepat agar rasterizer tidak memproses ulang blur pada setiap frame.
2. **Ganti Blur dengan Opasitas Sederhana Saat Scrolling Cepat**: Jika pengguna sedang melakukan scrolling cepat pada list, pertimbangkan untuk menurunkan nilai `blurSigma` atau mematikannya sementara menggunakan kondisi dinamis, kemudian mengaktifkannya kembali saat scroll melambat.
3. **Bungkus dengan `RepaintBoundary`**: Letakkan komponen kompleks yang mengandung `BackdropFilter` di dalam widget `RepaintBoundary` untuk mencegah pemrosesan ulang lukisan (repainting) pada elemen-elemen tetangga yang tidak berubah.
