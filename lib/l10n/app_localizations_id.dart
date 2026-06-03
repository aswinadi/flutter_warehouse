// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get dashboard => 'Dashboard';

  @override
  String get purchasing => 'Pengadaan barang';

  @override
  String get purchaseRequest => 'Permintaan Pembelian (PR)';

  @override
  String get vendorComparison => 'Perbandingan Vendor';

  @override
  String get warehouse => 'Gudang';

  @override
  String get packingList => 'Daftar Packing';

  @override
  String get receiving => 'Penerimaan Barang';

  @override
  String get sendToBranch => 'Kirim ke Cabang';

  @override
  String get receiveFromBranch => 'Terima dari Cabang';

  @override
  String get logout => 'Keluar';

  @override
  String get comingSoon => 'Fitur segera hadir!';

  @override
  String get approvals => 'Workspace Persetujuan';

  @override
  String get prTracking => 'Pelacakan PR';

  @override
  String get purchaseOrders => 'Pesanan Pembelian (PO)';

  @override
  String get pemakaian => 'Pemakaian';

  @override
  String get operasionalTambak => 'Operasional Tambak';

  @override
  String get persetujuan => 'Persetujuan';

  @override
  String get inventoryStock => 'Stok Barang';

  @override
  String get finance => 'Keuangan';

  @override
  String get paymentTransactions => 'Transaksi Pembayaran';

  @override
  String get transactionNumber => 'No. Transaksi';

  @override
  String get transactionDate => 'Tanggal Transaksi';

  @override
  String get sourceBank => 'Bank Sumber';

  @override
  String get totalAmount => 'Total Bayar';

  @override
  String get uploadProof => 'Unggah Bukti Transfer';

  @override
  String get selectImageSource => 'Pilih Sumber Gambar';

  @override
  String get camera => 'Kamera';

  @override
  String get gallery => 'Galeri';

  @override
  String get uploadSuccess => 'Bukti transfer berhasil diunggah.';

  @override
  String uploadFailed(Object error) {
    return 'Gagal mengunggah bukti transfer: $error';
  }

  @override
  String get stockMutation => 'Mutasi Stok';

  @override
  String get stockCard => 'Kartu Stok';

  @override
  String get selectWarehouse => 'Pilih Gudang';

  @override
  String get initialBalance => 'Stok Awal';

  @override
  String get periodIn => 'Masuk';

  @override
  String get periodOut => 'Keluar';

  @override
  String get endingBalance => 'Stok Akhir';

  @override
  String get transactionType => 'Tipe Transaksi';

  @override
  String get refNo => 'No. Ref';

  @override
  String get feedManagement => 'Pemberian Pakan';

  @override
  String get feedLog => 'Log Pakan';

  @override
  String get addFeedLog => 'Catat Pakan';

  @override
  String get feedCode => 'Kode Pakan';

  @override
  String get amountKg => 'Jumlah Pakan (kg)';

  @override
  String get doc => 'DOC (Hari)';

  @override
  String get cycle => 'Siklus';

  @override
  String get pond => 'Kolam';
}
