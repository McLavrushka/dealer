import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('ru'),
  ];

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @registerAction.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerAction;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'name@example.com'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountButton;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerTitle;

  /// No description provided for @loginAction.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginAction;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @settingsAppearanceSection.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceSection;

  /// No description provided for @settingsThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeLabel;

  /// No description provided for @settingsLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageLabel;

  /// No description provided for @themeOptionSystem.
  ///
  /// In en, this message translates to:
  /// **'Same as device'**
  String get themeOptionSystem;

  /// No description provided for @themeOptionLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeOptionLight;

  /// No description provided for @themeOptionDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeOptionDark;

  /// No description provided for @languageOptionSystem.
  ///
  /// In en, this message translates to:
  /// **'Same as device'**
  String get languageOptionSystem;

  /// No description provided for @languageOptionRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get languageOptionRussian;

  /// No description provided for @languageOptionEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageOptionEnglish;

  /// No description provided for @defaultCurrencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Default currency'**
  String get defaultCurrencyLabel;

  /// No description provided for @transferCommentLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment details'**
  String get transferCommentLabel;

  /// No description provided for @transferCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Card/phone and preferred bank (e.g. Tinkoff +7… / Sber **** 1234)'**
  String get transferCommentHint;

  /// No description provided for @currencyCodeHint.
  ///
  /// In en, this message translates to:
  /// **'USD / EUR / RUB'**
  String get currencyCodeHint;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @logoutButton.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutButton;

  /// No description provided for @debugClearHiveButton.
  ///
  /// In en, this message translates to:
  /// **'Clean all app memory'**
  String get debugClearHiveButton;

  /// No description provided for @clearStorageDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear local storage?'**
  String get clearStorageDialogTitle;

  /// No description provided for @clearStorageDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This will remove tokens, onboarding flag, and cached data on this device.'**
  String get clearStorageDialogBody;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @clearButton.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearButton;

  /// No description provided for @localStorageClearedMessage.
  ///
  /// In en, this message translates to:
  /// **'Local storage cleared'**
  String get localStorageClearedMessage;

  /// No description provided for @groupsTitle.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groupsTitle;

  /// No description provided for @notificationsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTooltip;

  /// No description provided for @noGroupsTitle.
  ///
  /// In en, this message translates to:
  /// **'No groups yet'**
  String get noGroupsTitle;

  /// No description provided for @noGroupsMessage.
  ///
  /// In en, this message translates to:
  /// **'Create a group or join by invite code.'**
  String get noGroupsMessage;

  /// No description provided for @addGroupButton.
  ///
  /// In en, this message translates to:
  /// **'Add group'**
  String get addGroupButton;

  /// No description provided for @createGroupMenu.
  ///
  /// In en, this message translates to:
  /// **'Create group'**
  String get createGroupMenu;

  /// No description provided for @joinByCodeMenu.
  ///
  /// In en, this message translates to:
  /// **'Join by code'**
  String get joinByCodeMenu;

  /// No description provided for @createGroupSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Create group'**
  String get createGroupSheetTitle;

  /// No description provided for @joinGroupSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Join group'**
  String get joinGroupSheetTitle;

  /// No description provided for @joinFromLinkIntro.
  ///
  /// In en, this message translates to:
  /// **'Enter the invite code or use the one from the link.'**
  String get joinFromLinkIntro;

  /// No description provided for @currencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currencyLabel;

  /// No description provided for @createButton.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createButton;

  /// No description provided for @joinButton.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get joinButton;

  /// No description provided for @inviteCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Invite code'**
  String get inviteCodeLabel;

  /// No description provided for @inviteCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. ABC123'**
  String get inviteCodeHint;

  /// No description provided for @groupFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get groupFallbackTitle;

  /// No description provided for @balanceSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balanceSectionTitle;

  /// No description provided for @noBalanceTitle.
  ///
  /// In en, this message translates to:
  /// **'No balance yet'**
  String get noBalanceTitle;

  /// No description provided for @noBalanceMessage.
  ///
  /// In en, this message translates to:
  /// **'Create a bill to see balances.'**
  String get noBalanceMessage;

  /// No description provided for @billsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get billsSectionTitle;

  /// No description provided for @noBillsTitle.
  ///
  /// In en, this message translates to:
  /// **'No bills yet'**
  String get noBillsTitle;

  /// No description provided for @noBillsMessage.
  ///
  /// In en, this message translates to:
  /// **'Tap “Add bill” to create your first one.'**
  String get noBillsMessage;

  /// No description provided for @addBillButton.
  ///
  /// In en, this message translates to:
  /// **'Add bill'**
  String get addBillButton;

  /// No description provided for @deleteBillDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete bill?'**
  String get deleteBillDialogTitle;

  /// No description provided for @deleteBillDialogContent.
  ///
  /// In en, this message translates to:
  /// **'\"{billTitle}\" will be removed for everyone in this group. This cannot be undone.'**
  String deleteBillDialogContent(String billTitle);

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @inviteButton.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get inviteButton;

  /// No description provided for @inviteCodeRow.
  ///
  /// In en, this message translates to:
  /// **'Invite code: {code}'**
  String inviteCodeRow(String code);

  /// No description provided for @inviteCodeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Invite code: —'**
  String get inviteCodeEmpty;

  /// No description provided for @copyInviteCodeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Copy invite code'**
  String get copyInviteCodeTooltip;

  /// No description provided for @noInviteCodeTooltip.
  ///
  /// In en, this message translates to:
  /// **'No invite code yet'**
  String get noInviteCodeTooltip;

  /// No description provided for @inviteCodeCopiedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Invite code copied'**
  String get inviteCodeCopiedSnackbar;

  /// No description provided for @membersCurrencyLine.
  ///
  /// In en, this message translates to:
  /// **'{count} members • {currency}'**
  String membersCurrencyLine(int count, String currency);

  /// No description provided for @deleteBillTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete bill'**
  String get deleteBillTooltip;

  /// No description provided for @billFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Bill'**
  String get billFallbackTitle;

  /// No description provided for @scanReceiptTooltip.
  ///
  /// In en, this message translates to:
  /// **'Scan receipt'**
  String get scanReceiptTooltip;

  /// No description provided for @noLineItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'No line items'**
  String get noLineItemsTitle;

  /// No description provided for @noLineItemsMessage.
  ///
  /// In en, this message translates to:
  /// **'Add items to split this bill.'**
  String get noLineItemsMessage;

  /// No description provided for @addItemButton.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get addItemButton;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @splitButton.
  ///
  /// In en, this message translates to:
  /// **'Split'**
  String get splitButton;

  /// No description provided for @deleteLineItemDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete line item?'**
  String get deleteLineItemDialogTitle;

  /// No description provided for @deleteLineItemDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{itemName}\" from this bill? This cannot be undone.'**
  String deleteLineItemDialogContent(String itemName);

  /// No description provided for @editTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editTooltip;

  /// No description provided for @deleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteTooltip;

  /// No description provided for @addItemSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get addItemSheetTitle;

  /// No description provided for @editItemSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get editItemSheetTitle;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceLabel;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantityLabel;

  /// No description provided for @addSheetButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addSheetButton;

  /// No description provided for @saveSheetButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveSheetButton;

  /// No description provided for @invalidNumberValidation.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get invalidNumberValidation;

  /// No description provided for @resultTitle.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get resultTitle;

  /// No description provided for @billSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Bill summary'**
  String get billSummaryTitle;

  /// No description provided for @whoPaysTooltip.
  ///
  /// In en, this message translates to:
  /// **'Who pays?'**
  String get whoPaysTooltip;

  /// No description provided for @loadingText.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loadingText;

  /// No description provided for @changeSplitButton.
  ///
  /// In en, this message translates to:
  /// **'Change split'**
  String get changeSplitButton;

  /// No description provided for @settleBillButton.
  ///
  /// In en, this message translates to:
  /// **'Settle bill'**
  String get settleBillButton;

  /// No description provided for @shareButton.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareButton;

  /// No description provided for @billSettledMessage.
  ///
  /// In en, this message translates to:
  /// **'Bill settled'**
  String get billSettledMessage;

  /// No description provided for @rouletteTitle.
  ///
  /// In en, this message translates to:
  /// **'Roulette'**
  String get rouletteTitle;

  /// No description provided for @whoPaysTitle.
  ///
  /// In en, this message translates to:
  /// **'Who pays?'**
  String get whoPaysTitle;

  /// No description provided for @winnerLabel.
  ///
  /// In en, this message translates to:
  /// **'Winner'**
  String get winnerLabel;

  /// No description provided for @participantsLabel.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participantsLabel;

  /// No description provided for @rouletteMinMembersMessage.
  ///
  /// In en, this message translates to:
  /// **'Add at least two members to the group to spin.'**
  String get rouletteMinMembersMessage;

  /// No description provided for @spinButton.
  ///
  /// In en, this message translates to:
  /// **'Spin'**
  String get spinButton;

  /// No description provided for @spinningButton.
  ///
  /// In en, this message translates to:
  /// **'Spinning…'**
  String get spinningButton;

  /// No description provided for @roulettePaysMessage.
  ///
  /// In en, this message translates to:
  /// **'{name} pays!'**
  String roulettePaysMessage(String name);

  /// No description provided for @scanReceiptTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan receipt'**
  String get scanReceiptTitle;

  /// No description provided for @tabQr.
  ///
  /// In en, this message translates to:
  /// **'QR'**
  String get tabQr;

  /// No description provided for @tabOcr.
  ///
  /// In en, this message translates to:
  /// **'OCR'**
  String get tabOcr;

  /// No description provided for @tabManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get tabManual;

  /// No description provided for @scanWebManualIntro.
  ///
  /// In en, this message translates to:
  /// **'Scanning is only available in the mobile app. Paste a fiscal QR string or raw receipt text below.'**
  String get scanWebManualIntro;

  /// No description provided for @fiscalQrLabel.
  ///
  /// In en, this message translates to:
  /// **'Fiscal QR string'**
  String get fiscalQrLabel;

  /// No description provided for @fiscalQrHint.
  ///
  /// In en, this message translates to:
  /// **'t=20201017T1923&s=1498.00&fn=...'**
  String get fiscalQrHint;

  /// No description provided for @parseQrButton.
  ///
  /// In en, this message translates to:
  /// **'Parse QR'**
  String get parseQrButton;

  /// No description provided for @receiptTextForOcrLabel.
  ///
  /// In en, this message translates to:
  /// **'Receipt text (OCR paste)'**
  String get receiptTextForOcrLabel;

  /// No description provided for @parseTextButton.
  ///
  /// In en, this message translates to:
  /// **'Parse text'**
  String get parseTextButton;

  /// No description provided for @takePhotoButton.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhotoButton;

  /// No description provided for @chooseFromGalleryButton.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGalleryButton;

  /// No description provided for @qrPointCameraHint.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at the receipt QR code.'**
  String get qrPointCameraHint;

  /// No description provided for @scanOcrDescription.
  ///
  /// In en, this message translates to:
  /// **'OCR: Latin script (English, amounts with \$ € £). Best for English or Romanized slips; Cyrillic is weak on-device — use the QR tab for Russian fiscal receipts.\n\nRecognition: Latin (English, currencies). Cyrillic is weak — for RF receipts use the QR tab.'**
  String get scanOcrDescription;

  /// No description provided for @importLinesQuestion.
  ///
  /// In en, this message translates to:
  /// **'Import {count} item(s)?'**
  String importLinesQuestion(int count);

  /// No description provided for @importButton.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get importButton;

  /// No description provided for @onboardingHeadline.
  ///
  /// In en, this message translates to:
  /// **'Split bills fairly'**
  String get onboardingHeadline;

  /// No description provided for @onboardingDescription.
  ///
  /// In en, this message translates to:
  /// **'Create groups, add items, split the total, and settle up — all in one place.'**
  String get onboardingDescription;

  /// No description provided for @getStartedButton.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStartedButton;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @noNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotificationsTitle;

  /// No description provided for @noNotificationsMessage.
  ///
  /// In en, this message translates to:
  /// **'You will see bill and group updates here.'**
  String get noNotificationsMessage;

  /// No description provided for @newBillSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'New bill'**
  String get newBillSheetTitle;

  /// No description provided for @scanningMobileOnlyBanner.
  ///
  /// In en, this message translates to:
  /// **'Scanning is only available in the mobile app.'**
  String get scanningMobileOnlyBanner;

  /// No description provided for @scanReceiptQrOption.
  ///
  /// In en, this message translates to:
  /// **'Scan receipt QR'**
  String get scanReceiptQrOption;

  /// No description provided for @photoReceiptOcrOption.
  ///
  /// In en, this message translates to:
  /// **'Photo receipt (OCR)'**
  String get photoReceiptOcrOption;

  /// No description provided for @enterManuallyOption.
  ///
  /// In en, this message translates to:
  /// **'Enter manually'**
  String get enterManuallyOption;

  /// No description provided for @billDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Bill details'**
  String get billDetailsTitle;

  /// No description provided for @titleFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleFieldLabel;

  /// No description provided for @createBillDefaultReceiptTitle.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get createBillDefaultReceiptTitle;

  /// No description provided for @createBillManualDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'New bill'**
  String get createBillManualDefaultTitle;

  /// No description provided for @errorGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGenericTitle;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @appBrandSideTitle.
  ///
  /// In en, this message translates to:
  /// **'Dealer'**
  String get appBrandSideTitle;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get validationRequired;

  /// No description provided for @validationInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get validationInvalidEmail;

  /// No description provided for @validationMinPassword.
  ///
  /// In en, this message translates to:
  /// **'Min 6 characters'**
  String get validationMinPassword;

  /// No description provided for @genericSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get genericSomethingWentWrong;

  /// No description provided for @shareGroupInviteBody.
  ///
  /// In en, this message translates to:
  /// **'Join my group\nCode: {code}'**
  String shareGroupInviteBody(String code);

  /// No description provided for @splitScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Split'**
  String get splitScreenTitle;

  /// No description provided for @summaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summaryLabel;

  /// No description provided for @doneButton.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneButton;

  /// No description provided for @sharePaymentDetailsHeader.
  ///
  /// In en, this message translates to:
  /// **'My payment details'**
  String get sharePaymentDetailsHeader;

  /// No description provided for @lineTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Line total: {amount}'**
  String lineTotalLabel(String amount);

  /// No description provided for @splitSelectAtLeastOnePerson.
  ///
  /// In en, this message translates to:
  /// **'Select at least one person for \"{itemName}\"'**
  String splitSelectAtLeastOnePerson(String itemName);

  /// No description provided for @errorNoTextRecognized.
  ///
  /// In en, this message translates to:
  /// **'No text recognized'**
  String get errorNoTextRecognized;

  /// No description provided for @errorCouldNotParseOcrLines.
  ///
  /// In en, this message translates to:
  /// **'Could not parse positions from OCR text'**
  String get errorCouldNotParseOcrLines;

  /// No description provided for @errorCouldNotParseQrFromImage.
  ///
  /// In en, this message translates to:
  /// **'No QR code found in the selected image'**
  String get errorCouldNotParseQrFromImage;

  /// No description provided for @errorNoLinesInPaste.
  ///
  /// In en, this message translates to:
  /// **'No line items found in text'**
  String get errorNoLinesInPaste;

  /// No description provided for @tippingMenuButtonTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add tip'**
  String get tippingMenuButtonTooltip;

  /// No description provided for @tipSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add tip'**
  String get tipSheetTitle;

  /// No description provided for @tipModePercent.
  ///
  /// In en, this message translates to:
  /// **'Percent of subtotal'**
  String get tipModePercent;

  /// No description provided for @tipModeFixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed amount'**
  String get tipModeFixed;

  /// No description provided for @tipPercentFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Percent (%)'**
  String get tipPercentFieldLabel;

  /// No description provided for @tipPercentFieldHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 10'**
  String get tipPercentFieldHint;

  /// No description provided for @tipFixedFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount ({currency})'**
  String tipFixedFieldLabel(String currency);

  /// No description provided for @tipSubtotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Subtotal (without tips): {amount} {currency}'**
  String tipSubtotalLabel(String amount, String currency);

  /// No description provided for @tipAddAction.
  ///
  /// In en, this message translates to:
  /// **'Add to bill'**
  String get tipAddAction;

  /// No description provided for @tipSuccessSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Tip added'**
  String get tipSuccessSnackbar;

  /// No description provided for @tipErrorSubtotalZero.
  ///
  /// In en, this message translates to:
  /// **'Subtotal is zero — add items before a tip.'**
  String get tipErrorSubtotalZero;

  /// No description provided for @tipErrorPercentRange.
  ///
  /// In en, this message translates to:
  /// **'Enter a percent between 0 and 100.'**
  String get tipErrorPercentRange;

  /// No description provided for @tipErrorFixedPositive.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than 0.'**
  String get tipErrorFixedPositive;

  /// No description provided for @tipLineNamePercent.
  ///
  /// In en, this message translates to:
  /// **'Tip ({percent}%)'**
  String tipLineNamePercent(String percent);

  /// No description provided for @tipLineNameFixed.
  ///
  /// In en, this message translates to:
  /// **'Tip (fixed amount)'**
  String get tipLineNameFixed;
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
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
