// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get loginTitle => 'Вход';

  @override
  String get registerAction => 'Регистрация';

  @override
  String get emailLabel => 'Эл. почта';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String get nameLabel => 'Имя';

  @override
  String get continueButton => 'Продолжить';

  @override
  String get createAccountButton => 'Создать аккаунт';

  @override
  String get registerTitle => 'Регистрация';

  @override
  String get loginAction => 'Вход';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get settingsAppearanceSection => 'Оформление';

  @override
  String get settingsThemeLabel => 'Тема';

  @override
  String get settingsLanguageLabel => 'Язык';

  @override
  String get themeOptionSystem => 'Как в системе';

  @override
  String get themeOptionLight => 'Светлая';

  @override
  String get themeOptionDark => 'Тёмная';

  @override
  String get languageOptionSystem => 'Как в системе';

  @override
  String get languageOptionRussian => 'Русский';

  @override
  String get languageOptionEnglish => 'English';

  @override
  String get defaultCurrencyLabel => 'Валюта по умолчанию';

  @override
  String get transferCommentLabel => 'Данные для перевода';

  @override
  String get transferCommentHint =>
      'Карта/телефон и банк (например: Тинькофф +7… / Сбер **** 1234)';

  @override
  String get currencyCodeHint => 'USD / EUR / RUB';

  @override
  String get saveButton => 'Сохранить';

  @override
  String get logoutButton => 'Выйти';

  @override
  String get debugClearHiveButton => 'Удалить сохраненные на устройстве данные';

  @override
  String get clearStorageDialogTitle => 'Очистить локальные данные?';

  @override
  String get clearStorageDialogBody =>
      'Будут удалены токены, флаг онбординга и кэш на этом устройстве.';

  @override
  String get cancelButton => 'Отмена';

  @override
  String get clearButton => 'Очистить';

  @override
  String get localStorageClearedMessage => 'Локальные данные очищены';

  @override
  String get groupsTitle => 'Группы';

  @override
  String get notificationsTooltip => 'Уведомления';

  @override
  String get noGroupsTitle => 'Пока нет групп';

  @override
  String get noGroupsMessage =>
      'Создайте группу или вступите по коду приглашения.';

  @override
  String get addGroupButton => 'Добавить группу';

  @override
  String get createGroupMenu => 'Создать группу';

  @override
  String get joinByCodeMenu => 'Вступить по коду';

  @override
  String get createGroupSheetTitle => 'Создать группу';

  @override
  String get joinGroupSheetTitle => 'Вступить в группу';

  @override
  String get joinFromLinkIntro =>
      'Введите код приглашения или используйте код из ссылки.';

  @override
  String get currencyLabel => 'Валюта';

  @override
  String get createButton => 'Создать';

  @override
  String get joinButton => 'Вступить';

  @override
  String get inviteCodeLabel => 'Код приглашения';

  @override
  String get inviteCodeHint => 'например ABC123';

  @override
  String get groupFallbackTitle => 'Группа';

  @override
  String get balanceSectionTitle => 'Баланс';

  @override
  String get noBalanceTitle => 'Баланса пока нет';

  @override
  String get noBalanceMessage => 'Создайте чек, чтобы увидеть балансы.';

  @override
  String get billsSectionTitle => 'Чеки';

  @override
  String get noBillsTitle => 'Чеков пока нет';

  @override
  String get noBillsMessage => 'Нажмите «Добавить чек», чтобы создать первый.';

  @override
  String get addBillButton => 'Добавить чек';

  @override
  String get deleteBillDialogTitle => 'Удалить чек?';

  @override
  String deleteBillDialogContent(String billTitle) {
    return '«$billTitle» будет удалён для всех в группе. Это действие нельзя отменить.';
  }

  @override
  String get deleteButton => 'Удалить';

  @override
  String get inviteButton => 'Пригласить';

  @override
  String inviteCodeRow(String code) {
    return 'Код приглашения: $code';
  }

  @override
  String get inviteCodeEmpty => 'Код приглашения: —';

  @override
  String get copyInviteCodeTooltip => 'Скопировать код';

  @override
  String get noInviteCodeTooltip => 'Кода приглашения пока нет';

  @override
  String get inviteCodeCopiedSnackbar => 'Код скопирован';

  @override
  String membersCurrencyLine(int count, String currency) {
    return 'Участников: $count • $currency';
  }

  @override
  String get deleteBillTooltip => 'Удалить чек';

  @override
  String get billFallbackTitle => 'Чек';

  @override
  String get scanReceiptTooltip => 'Сканировать чек';

  @override
  String get noLineItemsTitle => 'Нет позиций';

  @override
  String get noLineItemsMessage => 'Добавьте позиции, чтобы разделить чек.';

  @override
  String get addItemButton => 'Добавить позицию';

  @override
  String get totalLabel => 'Итого';

  @override
  String get splitButton => 'Разделить';

  @override
  String get deleteLineItemDialogTitle => 'Удалить позицию?';

  @override
  String deleteLineItemDialogContent(String itemName) {
    return 'Удалить «$itemName» из чека? Это нельзя отменить.';
  }

  @override
  String get editTooltip => 'Изменить';

  @override
  String get deleteTooltip => 'Удалить';

  @override
  String get addItemSheetTitle => 'Добавить позицию';

  @override
  String get editItemSheetTitle => 'Изменить позицию';

  @override
  String get priceLabel => 'Цена';

  @override
  String get quantityLabel => 'Количество';

  @override
  String get addSheetButton => 'Добавить';

  @override
  String get saveSheetButton => 'Сохранить';

  @override
  String get invalidNumberValidation => 'Неверное число';

  @override
  String get resultTitle => 'Результат';

  @override
  String get billSummaryTitle => 'Итог по чеку';

  @override
  String get whoPaysTooltip => 'Кто платит?';

  @override
  String get loadingText => 'Загрузка…';

  @override
  String get changeSplitButton => 'Изменить разделение';

  @override
  String get settleBillButton => 'Закрыть чек';

  @override
  String get shareButton => 'Поделиться';

  @override
  String get billSettledMessage => 'Чек закрыт';

  @override
  String get rouletteTitle => 'Рулетка';

  @override
  String get whoPaysTitle => 'Кто платит?';

  @override
  String get winnerLabel => 'Победитель';

  @override
  String get participantsLabel => 'Участники';

  @override
  String get rouletteMinMembersMessage =>
      'Добавьте в группу хотя бы двух участников, чтобы крутить рулетку.';

  @override
  String get spinButton => 'Крутить';

  @override
  String get spinningButton => 'Крутим…';

  @override
  String roulettePaysMessage(String name) {
    return '$name платит!';
  }

  @override
  String get scanReceiptTitle => 'Сканирование чека';

  @override
  String get tabQr => 'QR';

  @override
  String get tabOcr => 'OCR';

  @override
  String get tabManual => 'Вручную';

  @override
  String get scanWebManualIntro =>
      'Сканирование доступно только в мобильном приложении. Вставьте строку фискального QR или текст чека ниже.';

  @override
  String get fiscalQrLabel => 'Строка фискального QR';

  @override
  String get fiscalQrHint => 't=20201017T1923&s=1498.00&fn=...';

  @override
  String get parseQrButton => 'Разобрать QR';

  @override
  String get receiptTextForOcrLabel => 'Текст чека (вставка OCR)';

  @override
  String get parseTextButton => 'Разобрать текст';

  @override
  String get takePhotoButton => 'Сделать фото';

  @override
  String get chooseFromGalleryButton => 'Выбрать из галереи';

  @override
  String get qrPointCameraHint => 'Наведите камеру на QR-код чека.';

  @override
  String get scanOcrDescription =>
      'OCR: латиница (английский, суммы в \$ € £). Подходит для английских чеков; кириллица на устройстве распознаётся слабо — для российских фискальных чеков используйте вкладку QR.\n\nРаспознавание: латиница (английский, валюты). Для чеков РФ — вкладка QR.';

  @override
  String importLinesQuestion(int count) {
    return 'Импортировать $count поз.?';
  }

  @override
  String get importButton => 'Импорт';

  @override
  String get onboardingHeadline => 'Делите счёт честно';

  @override
  String get onboardingDescription =>
      'Создавайте группы, добавляйте позиции, делите сумму и закрывайте долги — всё в одном месте.';

  @override
  String get getStartedButton => 'Начать';

  @override
  String get notificationsTitle => 'Уведомления';

  @override
  String get noNotificationsTitle => 'Нет уведомлений';

  @override
  String get noNotificationsMessage =>
      'Здесь будут обновления по чекам и группам.';

  @override
  String get newBillSheetTitle => 'Новый чек';

  @override
  String get scanningMobileOnlyBanner =>
      'Сканирование доступно только в мобильном приложении.';

  @override
  String get scanReceiptQrOption => 'Сканировать QR чека';

  @override
  String get photoReceiptOcrOption => 'Фото чека (OCR)';

  @override
  String get enterManuallyOption => 'Ввести вручную';

  @override
  String get billDetailsTitle => 'Детали чека';

  @override
  String get titleFieldLabel => 'Название';

  @override
  String get createBillDefaultReceiptTitle => 'Чек';

  @override
  String get createBillManualDefaultTitle => 'Новый чек';

  @override
  String get errorGenericTitle => 'Что-то пошло не так';

  @override
  String get retryButton => 'Повторить';

  @override
  String get appBrandSideTitle => 'Dealer';

  @override
  String get validationRequired => 'Обязательное поле';

  @override
  String get validationInvalidEmail => 'Неверный email';

  @override
  String get validationMinPassword => 'Минимум 6 символов';

  @override
  String get genericSomethingWentWrong => 'Что-то пошло не так';

  @override
  String shareGroupInviteBody(String code) {
    return 'Присоединяйтесь к группе\nКод: $code';
  }

  @override
  String get splitScreenTitle => 'Разделение';

  @override
  String get summaryLabel => 'Сводка';

  @override
  String get doneButton => 'Готово';

  @override
  String get sharePaymentDetailsHeader => 'Мои реквизиты для перевода';

  @override
  String lineTotalLabel(String amount) {
    return 'Сумма строки: $amount';
  }

  @override
  String splitSelectAtLeastOnePerson(String itemName) {
    return 'Выберите хотя бы одного человека для «$itemName»';
  }

  @override
  String get errorNoTextRecognized => 'Текст не распознан';

  @override
  String get errorCouldNotParseOcrLines =>
      'Не удалось разобрать позиции из текста OCR';

  @override
  String get errorCouldNotParseQrFromImage =>
      'Не удалось найти QR-код на выбранном изображении';

  @override
  String get errorNoLinesInPaste => 'В тексте не найдено позиций';

  @override
  String get tippingMenuButtonTooltip => 'Добавить чаевые';

  @override
  String get tipSheetTitle => 'Чаевые';

  @override
  String get tipModePercent => 'Процент от суммы';

  @override
  String get tipModeFixed => 'Фиксированная сумма';

  @override
  String get tipPercentFieldLabel => 'Процент (%)';

  @override
  String get tipPercentFieldHint => 'например 10';

  @override
  String tipFixedFieldLabel(String currency) {
    return 'Сумма ($currency)';
  }

  @override
  String tipSubtotalLabel(String amount, String currency) {
    return 'Сумма без чаевых: $amount $currency';
  }

  @override
  String get tipAddAction => 'Добавить в чек';

  @override
  String get tipSuccessSnackbar => 'Чаевые добавлены';

  @override
  String get tipErrorSubtotalZero =>
      'Сумма позиций равна нулю — сначала добавьте позиции.';

  @override
  String get tipErrorPercentRange => 'Введите процент от 0 до 100.';

  @override
  String get tipErrorFixedPositive => 'Введите сумму больше 0.';

  @override
  String tipLineNamePercent(String percent) {
    return 'Чаевые ($percent%)';
  }

  @override
  String get tipLineNameFixed => 'Чаевые (фикс)';
}
