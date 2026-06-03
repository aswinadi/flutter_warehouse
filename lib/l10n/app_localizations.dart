import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @purchasing.
  ///
  /// In en, this message translates to:
  /// **'Purchasing'**
  String get purchasing;

  /// No description provided for @purchaseRequest.
  ///
  /// In en, this message translates to:
  /// **'Purchase Request'**
  String get purchaseRequest;

  /// No description provided for @vendorComparison.
  ///
  /// In en, this message translates to:
  /// **'Vendor Comparison'**
  String get vendorComparison;

  /// No description provided for @warehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get warehouse;

  /// No description provided for @packingList.
  ///
  /// In en, this message translates to:
  /// **'Packing List'**
  String get packingList;

  /// No description provided for @receiving.
  ///
  /// In en, this message translates to:
  /// **'Receiving'**
  String get receiving;

  /// No description provided for @sendToBranch.
  ///
  /// In en, this message translates to:
  /// **'Send to Branch'**
  String get sendToBranch;

  /// No description provided for @receiveFromBranch.
  ///
  /// In en, this message translates to:
  /// **'Receive from Branch'**
  String get receiveFromBranch;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Feature coming soon!'**
  String get comingSoon;

  /// No description provided for @approvals.
  ///
  /// In en, this message translates to:
  /// **'Approvals Workspace'**
  String get approvals;

  /// No description provided for @prTracking.
  ///
  /// In en, this message translates to:
  /// **'PR Tracking'**
  String get prTracking;

  /// No description provided for @purchaseOrders.
  ///
  /// In en, this message translates to:
  /// **'Purchase Orders'**
  String get purchaseOrders;

  /// No description provided for @pemakaian.
  ///
  /// In en, this message translates to:
  /// **'Usage'**
  String get pemakaian;

  /// No description provided for @operasionalTambak.
  ///
  /// In en, this message translates to:
  /// **'Farm Operations'**
  String get operasionalTambak;

  /// No description provided for @persetujuan.
  ///
  /// In en, this message translates to:
  /// **'Approvals'**
  String get persetujuan;

  /// No description provided for @inventoryStock.
  ///
  /// In en, this message translates to:
  /// **'Inventory Stock'**
  String get inventoryStock;

  /// No description provided for @finance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get finance;

  /// No description provided for @paymentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Payment Transactions'**
  String get paymentTransactions;

  /// No description provided for @transactionNumber.
  ///
  /// In en, this message translates to:
  /// **'Transaction No.'**
  String get transactionNumber;

  /// No description provided for @transactionDate.
  ///
  /// In en, this message translates to:
  /// **'Transaction Date'**
  String get transactionDate;

  /// No description provided for @sourceBank.
  ///
  /// In en, this message translates to:
  /// **'Source Bank'**
  String get sourceBank;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Paid'**
  String get totalAmount;

  /// No description provided for @uploadProof.
  ///
  /// In en, this message translates to:
  /// **'Upload Proof of Transfer'**
  String get uploadProof;

  /// No description provided for @selectImageSource.
  ///
  /// In en, this message translates to:
  /// **'Select Image Source'**
  String get selectImageSource;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @uploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Transfer proof uploaded successfully.'**
  String get uploadSuccess;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload transfer proof: {error}'**
  String uploadFailed(Object error);

  /// No description provided for @stockMutation.
  ///
  /// In en, this message translates to:
  /// **'Stock Mutation'**
  String get stockMutation;

  /// No description provided for @stockCard.
  ///
  /// In en, this message translates to:
  /// **'Stock Card'**
  String get stockCard;

  /// No description provided for @selectWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Select Warehouse'**
  String get selectWarehouse;

  /// No description provided for @initialBalance.
  ///
  /// In en, this message translates to:
  /// **'Initial'**
  String get initialBalance;

  /// No description provided for @periodIn.
  ///
  /// In en, this message translates to:
  /// **'In'**
  String get periodIn;

  /// No description provided for @periodOut.
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get periodOut;

  /// No description provided for @endingBalance.
  ///
  /// In en, this message translates to:
  /// **'Ending'**
  String get endingBalance;

  /// No description provided for @transactionType.
  ///
  /// In en, this message translates to:
  /// **'Transaction Type'**
  String get transactionType;

  /// No description provided for @refNo.
  ///
  /// In en, this message translates to:
  /// **'Ref No'**
  String get refNo;

  /// No description provided for @feedManagement.
  ///
  /// In en, this message translates to:
  /// **'Feed Management'**
  String get feedManagement;

  /// No description provided for @feedLog.
  ///
  /// In en, this message translates to:
  /// **'Feed Log'**
  String get feedLog;

  /// No description provided for @addFeedLog.
  ///
  /// In en, this message translates to:
  /// **'Record Feed'**
  String get addFeedLog;

  /// No description provided for @feedCode.
  ///
  /// In en, this message translates to:
  /// **'Feed Code'**
  String get feedCode;

  /// No description provided for @amountKg.
  ///
  /// In en, this message translates to:
  /// **'Amount (kg)'**
  String get amountKg;

  /// No description provided for @doc.
  ///
  /// In en, this message translates to:
  /// **'DOC (Days)'**
  String get doc;

  /// No description provided for @cycle.
  ///
  /// In en, this message translates to:
  /// **'Cycle'**
  String get cycle;

  /// No description provided for @pond.
  ///
  /// In en, this message translates to:
  /// **'Pond'**
  String get pond;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
