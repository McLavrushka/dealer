// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginTitle => 'Login';

  @override
  String get registerAction => 'Register';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get nameLabel => 'Name';

  @override
  String get continueButton => 'Continue';

  @override
  String get createAccountButton => 'Create account';

  @override
  String get registerTitle => 'Register';

  @override
  String get loginAction => 'Login';

  @override
  String get profileTitle => 'Profile';

  @override
  String get settingsAppearanceSection => 'Appearance';

  @override
  String get settingsThemeLabel => 'Theme';

  @override
  String get settingsLanguageLabel => 'Language';

  @override
  String get themeOptionSystem => 'Same as device';

  @override
  String get themeOptionLight => 'Light';

  @override
  String get themeOptionDark => 'Dark';

  @override
  String get languageOptionSystem => 'Same as device';

  @override
  String get languageOptionRussian => 'Russian';

  @override
  String get languageOptionEnglish => 'English';

  @override
  String get defaultCurrencyLabel => 'Default currency';

  @override
  String get transferCommentLabel => 'Payment details';

  @override
  String get transferCommentHint =>
      'Card/phone and preferred bank (e.g. Tinkoff +7… / Sber **** 1234)';

  @override
  String get currencyCodeHint => 'USD / EUR / RUB';

  @override
  String get saveButton => 'Save';

  @override
  String get profileSavedMessage => 'Profile saved';

  @override
  String get logoutButton => 'Logout';

  @override
  String get debugClearHiveButton => 'Clean all app memory';

  @override
  String get clearStorageDialogTitle => 'Clear local storage?';

  @override
  String get clearStorageDialogBody =>
      'This will remove tokens, onboarding flag, and cached data on this device.';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get clearButton => 'Clear';

  @override
  String get localStorageClearedMessage => 'Local storage cleared';

  @override
  String get groupsTitle => 'Groups';

  @override
  String get notificationsTooltip => 'Notifications';

  @override
  String get noGroupsTitle => 'No groups yet';

  @override
  String get noGroupsMessage => 'Create a group or join by invite code.';

  @override
  String get addGroupButton => 'Add group';

  @override
  String get createGroupMenu => 'Create group';

  @override
  String get joinByCodeMenu => 'Join by code';

  @override
  String get createGroupSheetTitle => 'Create group';

  @override
  String get joinGroupSheetTitle => 'Join group';

  @override
  String get joinFromLinkIntro =>
      'Enter the invite code or use the one from the link.';

  @override
  String get currencyLabel => 'Currency';

  @override
  String get createButton => 'Create';

  @override
  String get joinButton => 'Join';

  @override
  String get inviteCodeLabel => 'Invite code';

  @override
  String get inviteCodeHint => 'e.g. ABC123';

  @override
  String get groupFallbackTitle => 'Group';

  @override
  String get balanceSectionTitle => 'Balance';

  @override
  String get noBalanceTitle => 'No balance yet';

  @override
  String get noBalanceMessage => 'Create a bill to see balances.';

  @override
  String get billsSectionTitle => 'Bills';

  @override
  String get noBillsTitle => 'No bills yet';

  @override
  String get noBillsMessage => 'Tap “Add bill” to create your first one.';

  @override
  String get addBillButton => 'Add bill';

  @override
  String get deleteBillDialogTitle => 'Delete bill?';

  @override
  String deleteBillDialogContent(String billTitle) {
    return '\"$billTitle\" will be removed for everyone in this group. This cannot be undone.';
  }

  @override
  String get deleteButton => 'Delete';

  @override
  String get inviteButton => 'Invite';

  @override
  String inviteCodeRow(String code) {
    return 'Invite code: $code';
  }

  @override
  String get inviteCodeEmpty => 'Invite code: —';

  @override
  String get copyInviteCodeTooltip => 'Copy invite code';

  @override
  String get noInviteCodeTooltip => 'No invite code yet';

  @override
  String get inviteCodeCopiedSnackbar => 'Invite code copied';

  @override
  String membersCurrencyLine(int count, String currency) {
    return '$count members • $currency';
  }

  @override
  String get deleteBillTooltip => 'Delete bill';

  @override
  String get billFallbackTitle => 'Bill';

  @override
  String get scanReceiptTooltip => 'Scan receipt';

  @override
  String get noLineItemsTitle => 'No line items';

  @override
  String get noLineItemsMessage => 'Add items to split this bill.';

  @override
  String get addItemButton => 'Add item';

  @override
  String get totalLabel => 'Total';

  @override
  String get splitButton => 'Split';

  @override
  String get deleteLineItemDialogTitle => 'Delete line item?';

  @override
  String deleteLineItemDialogContent(String itemName) {
    return 'Remove \"$itemName\" from this bill? This cannot be undone.';
  }

  @override
  String get editTooltip => 'Edit';

  @override
  String get deleteTooltip => 'Delete';

  @override
  String get addItemSheetTitle => 'Add item';

  @override
  String get editItemSheetTitle => 'Edit item';

  @override
  String get priceLabel => 'Price';

  @override
  String get quantityLabel => 'Quantity';

  @override
  String get addSheetButton => 'Add';

  @override
  String get saveSheetButton => 'Save';

  @override
  String get invalidNumberValidation => 'Invalid number';

  @override
  String get resultTitle => 'Result';

  @override
  String get billSummaryTitle => 'Bill summary';

  @override
  String get whoPaysTooltip => 'Who pays?';

  @override
  String get loadingText => 'Loading…';

  @override
  String get changeSplitButton => 'Change split';

  @override
  String get settleBillButton => 'Settle bill';

  @override
  String get shareButton => 'Share';

  @override
  String get billSettledMessage => 'Bill settled';

  @override
  String get rouletteTitle => 'Roulette';

  @override
  String get whoPaysTitle => 'Who pays?';

  @override
  String get winnerLabel => 'Winner';

  @override
  String get participantsLabel => 'Participants';

  @override
  String get rouletteMinMembersMessage =>
      'Add at least two members to the group to spin.';

  @override
  String get spinButton => 'Spin';

  @override
  String get spinningButton => 'Spinning…';

  @override
  String roulettePaysMessage(String name) {
    return '$name pays!';
  }

  @override
  String get scanReceiptTitle => 'Scan receipt';

  @override
  String get tabQr => 'QR';

  @override
  String get tabOcr => 'OCR';

  @override
  String get tabManual => 'Manual';

  @override
  String get scanWebManualIntro =>
      'Scanning is only available in the mobile app. Paste a fiscal QR string or raw receipt text below.';

  @override
  String get fiscalQrLabel => 'Fiscal QR string';

  @override
  String get fiscalQrHint => 't=20201017T1923&s=1498.00&fn=...';

  @override
  String get parseQrButton => 'Parse QR';

  @override
  String get receiptTextForOcrLabel => 'Receipt text (OCR paste)';

  @override
  String get parseTextButton => 'Parse text';

  @override
  String get takePhotoButton => 'Take photo';

  @override
  String get chooseFromGalleryButton => 'Choose from gallery';

  @override
  String get qrPointCameraHint => 'Point the camera at the receipt QR code.';

  @override
  String get scanOcrDescription =>
      'OCR: Latin script (English, amounts with \$ € £). Best for English or Romanized slips; Cyrillic is weak on-device — use the QR tab for Russian fiscal receipts.\n\nRecognition: Latin (English, currencies). Cyrillic is weak — for RF receipts use the QR tab.';

  @override
  String importLinesQuestion(int count) {
    return 'Import $count item(s)?';
  }

  @override
  String get importButton => 'Import';

  @override
  String get onboardingHeadline => 'Split bills fairly';

  @override
  String get onboardingDescription =>
      'Create groups, add items, split the total, and settle up — all in one place.';

  @override
  String get getStartedButton => 'Get started';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get noNotificationsTitle => 'No notifications';

  @override
  String get noNotificationsMessage =>
      'You will see bill and group updates here.';

  @override
  String get newBillSheetTitle => 'New bill';

  @override
  String get scanningMobileOnlyBanner =>
      'Scanning is only available in the mobile app.';

  @override
  String get scanReceiptQrOption => 'Scan receipt QR';

  @override
  String get photoReceiptOcrOption => 'Photo receipt (OCR)';

  @override
  String get enterManuallyOption => 'Enter manually';

  @override
  String get billDetailsTitle => 'Bill details';

  @override
  String get titleFieldLabel => 'Title';

  @override
  String get createBillDefaultReceiptTitle => 'Receipt';

  @override
  String get createBillManualDefaultTitle => 'New bill';

  @override
  String get errorGenericTitle => 'Something went wrong';

  @override
  String get retryButton => 'Retry';

  @override
  String get appBrandSideTitle => 'Dealer';

  @override
  String get validationRequired => 'Required';

  @override
  String get validationInvalidEmail => 'Invalid email';

  @override
  String get validationMinPassword => 'Min 6 characters';

  @override
  String get genericSomethingWentWrong => 'Something went wrong';

  @override
  String shareGroupInviteBody(String code) {
    return 'Join my group\nCode: $code';
  }

  @override
  String get splitScreenTitle => 'Split';

  @override
  String get summaryLabel => 'Summary';

  @override
  String get doneButton => 'Done';

  @override
  String get sharePaymentDetailsHeader => 'My payment details';

  @override
  String lineTotalLabel(String amount) {
    return 'Line total: $amount';
  }

  @override
  String splitSelectAtLeastOnePerson(String itemName) {
    return 'Select at least one person for \"$itemName\"';
  }

  @override
  String get errorNoTextRecognized => 'No text recognized';

  @override
  String get errorCouldNotParseOcrLines =>
      'Could not parse positions from OCR text';

  @override
  String get errorCouldNotParseQrFromImage =>
      'No QR code found in the selected image';

  @override
  String get errorNoLinesInPaste => 'No line items found in text';

  @override
  String get tippingMenuButtonTooltip => 'Add tip';

  @override
  String get tipSheetTitle => 'Add tip';

  @override
  String get tipModePercent => 'Percent of subtotal';

  @override
  String get tipModeFixed => 'Fixed amount';

  @override
  String get tipPercentFieldLabel => 'Percent (%)';

  @override
  String get tipPercentFieldHint => 'e.g. 10';

  @override
  String tipFixedFieldLabel(String currency) {
    return 'Amount ($currency)';
  }

  @override
  String tipSubtotalLabel(String amount, String currency) {
    return 'Subtotal (without tips): $amount $currency';
  }

  @override
  String get tipAddAction => 'Add to bill';

  @override
  String get tipSuccessSnackbar => 'Tip added';

  @override
  String get tipErrorSubtotalZero =>
      'Subtotal is zero — add items before a tip.';

  @override
  String get tipErrorPercentRange => 'Enter a percent between 0 and 100.';

  @override
  String get tipErrorFixedPositive => 'Enter an amount greater than 0.';

  @override
  String tipLineNamePercent(String percent) {
    return 'Tip ($percent%)';
  }

  @override
  String get tipLineNameFixed => 'Tip (fixed amount)';
}
