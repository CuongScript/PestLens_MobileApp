import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TextfieldValidator {
  static String? validateUsername(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.usernameRequired;
    }
    return null;
  }

  static String? validateEmail(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.emailRequired;
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return AppLocalizations.of(context)!.invalidEmail;
    }
    return null;
  }

  static String? validatePassword(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.passwordRequired;
    }
    if (value.length < 6) {
      return AppLocalizations.of(context)!.passwordTooShort;
    }
    return null;
  }

  static String? validateRePassword(
      String? value, String password, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.passwordRequired;
    }
    if (value != password) {
      return AppLocalizations.of(context)!.passwordMismatch;
    }
    return null;
  }
}
