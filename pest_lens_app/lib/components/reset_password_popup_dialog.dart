import 'package:flutter/material.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/pages/authen/login_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// This function shows a success or failure dialog for password reset
void showResetPasswordPopup(BuildContext context, bool success) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dialog from closing on tap outside
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              success ? Icons.check_circle : Icons.error,
              color: success ? Colors.green : Colors.red,
              size: 60,
            ),
            const SizedBox(height: 20),
            Text(
              success
                  ? AppLocalizations.of(context)!.passResetSuccess
                  : AppLocalizations.of(context)!.passResetFail,
              textAlign: TextAlign.center,
              style: CustomTextStyles.labelTextField,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (success) {
                  // Navigate to login page if reset was successful
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                } else {
                  // Dismiss the dialog and allow the user to try again
                  Navigator.pop(dialogContext);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    success ? Colors.green : Colors.red, // Button color
                foregroundColor: Colors.white, // Text color
              ),
              child: Text(success
                  ? AppLocalizations.of(context)!.goToLogin
                  : AppLocalizations.of(context)!.tryAgain),
            ),
          ],
        ),
      );
    },
  );
}
