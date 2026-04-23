import '../../l10n/app_localizations.dart';

class Validators {
  static String? requiredField(AppLocalizations l10n, String? value) {
    if (value == null) return l10n.validationRequired;
    if (value.trim().isEmpty) return l10n.validationRequired;
    return null;
  }

  static String? email(AppLocalizations l10n, String? value) {
    final requiredError = requiredField(l10n, value);
    if (requiredError != null) return requiredError;

    final v = value!.trim();
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);
    if (!ok) return l10n.validationInvalidEmail;
    return null;
  }

  static String? password(AppLocalizations l10n, String? value) {
    final requiredError = requiredField(l10n, value);
    if (requiredError != null) return requiredError;
    if (value!.length < 6) return l10n.validationMinPassword;
    return null;
  }
}

