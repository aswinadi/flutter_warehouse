// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get dashboard => 'Dashboard';

  @override
  String get purchasing => 'Purchasing';

  @override
  String get purchaseRequest => 'Purchase Request';

  @override
  String get vendorComparison => 'Vendor Comparison';

  @override
  String get warehouse => 'Warehouse';

  @override
  String get packingList => 'Packing List';

  @override
  String get receiving => 'Receiving';

  @override
  String get sendToBranch => 'Send to Branch';

  @override
  String get receiveFromBranch => 'Receive from Branch';

  @override
  String get logout => 'Logout';

  @override
  String get comingSoon => 'Feature coming soon!';

  @override
  String get approvals => 'Approvals Workspace';

  @override
  String get prTracking => 'PR Tracking';

  @override
  String get purchaseOrders => 'Purchase Orders';

  @override
  String get pemakaian => 'Usage';

  @override
  String get operasionalTambak => 'Farm Operations';

  @override
  String get persetujuan => 'Approvals';

  @override
  String get inventoryStock => 'Inventory Stock';

  @override
  String get finance => 'Finance';

  @override
  String get paymentTransactions => 'Payment Transactions';

  @override
  String get transactionNumber => 'Transaction No.';

  @override
  String get transactionDate => 'Transaction Date';

  @override
  String get sourceBank => 'Source Bank';

  @override
  String get totalAmount => 'Total Paid';

  @override
  String get uploadProof => 'Upload Proof of Transfer';

  @override
  String get selectImageSource => 'Select Image Source';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get uploadSuccess => 'Transfer proof uploaded successfully.';

  @override
  String uploadFailed(Object error) {
    return 'Failed to upload transfer proof: $error';
  }

  @override
  String get stockMutation => 'Stock Mutation';

  @override
  String get stockCard => 'Stock Card';

  @override
  String get selectWarehouse => 'Select Warehouse';

  @override
  String get initialBalance => 'Initial';

  @override
  String get periodIn => 'In';

  @override
  String get periodOut => 'Out';

  @override
  String get endingBalance => 'Ending';

  @override
  String get transactionType => 'Transaction Type';

  @override
  String get refNo => 'Ref No';

  @override
  String get feedManagement => 'Feed Management';

  @override
  String get feedLog => 'Feed Log';

  @override
  String get addFeedLog => 'Record Feed';

  @override
  String get feedCode => 'Feed Code';

  @override
  String get amountKg => 'Amount (kg)';

  @override
  String get doc => 'DOC (Days)';

  @override
  String get cycle => 'Cycle';

  @override
  String get pond => 'Pond';
}
