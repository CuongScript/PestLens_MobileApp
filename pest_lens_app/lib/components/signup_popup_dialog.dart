import 'package:flutter/material.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/pages/authen/login_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showSignupPopup(BuildContext context, bool success, {String? message}) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              success ? Icons.check_circle : Icons.error,
              color: success ? Colors.green : Colors.red,
              size: 50,
            ),
            const SizedBox(height: 20),
            Text(
              success
                  ? AppLocalizations.of(context)!.signupSuccess
                  : AppLocalizations.of(context)!.signUpFailed,
              style: CustomTextStyles.labelTextField,
            ),
            const SizedBox(height: 10),
            Text(
              message ??
                  (success
                      ? AppLocalizations.of(context)!.accountCreatedSuccess
                      : AppLocalizations.of(context)!.accountCreatedFailed),
              textAlign: TextAlign.center,
              style: CustomTextStyles.labelTextField,
            ),
            const SizedBox(height: 20),
            success
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.comeToLogin),
                  )
                : ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    child: Text(AppLocalizations.of(context)!.tryAgain),
                  ),
          ],
        ),
      );
    },
  );
}

void showImageUploadWarning(BuildContext context, VoidCallback onContinue) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.warning),
        content: Text(
          AppLocalizations.of(context)!.profileImgFail,
        ),
        actions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.continueSignup),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onContinue();
            },
          ),
        ],
      );
    },
  );
}
