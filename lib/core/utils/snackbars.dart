import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../network/dio_error_user_message.dart';

class Snackbars {
  static void showSuccess(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showError(BuildContext context, Object error) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(_message(context, error)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static String _message(BuildContext context, Object error) {
    final text = userMessageForApiError(error);
    if (text.isEmpty) {
      return AppLocalizations.of(context).genericSomethingWentWrong;
    }
    return text;
  }
}

