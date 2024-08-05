import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TextfieldValidator {
  static String? validateUsername(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return "Username is required"; // Directly provided error message
    }

    // Check for minimum and maximum length requirements
    if (value.length < 3 || value.length > 20) {
      return "Username must be between 3 and 20 characters long"; // Direct error message for length
    }

    // Regular expression to ensure the username contains only letters, numbers, underscores, or dashes
    String pattern = r'^[a-zA-Z0-9_-]+$';
    RegExp regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return "Username can only contain letters, numbers, underscores, and dashes"; // Direct error message for character restriction
    }

    return null;
  }

  static String? validateFirstName(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return "First Name Required"; // Check if the field is empty
    }

    // Regular expression pattern to validate that the name is alphabetic
    // and allows spaces, apostrophes, and hyphens (common in names)
    String pattern = r"^[a-zA-Z\s'-]+$";
    RegExp regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return "Invalid first name"; // Validation message if the pattern does not match
    }

    return null; // Return null if the first name is valid
  }

  static String? validateLastName(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return "Last Name Required"; // Check if the field is empty
    }

    // Similar validation as for first name
    String pattern = r"^[a-zA-Z\s'-]+$";
    RegExp regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return "Invalid last name"; // Validation message if the pattern does not match
    }

    return null; // Return null if the last name is valid
  }

  static String? validatePhoneNumber(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return "Phone number is required"; // Check if the field is empty
    }

    // Regular expression pattern to validate a phone number
    // This pattern will match most international phone numbers
    String pattern = r'(^\+?\d{1,4}?[\d\s]{5,}$)';
    RegExp regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return "Enter a valid phone number"; // Validation message if the pattern does not match
    }

    return null; // Return null if the phone number is valid
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
