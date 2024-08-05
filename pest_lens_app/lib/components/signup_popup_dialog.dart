// popup_dialog.dart
import 'package:flutter/material.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/pages/authen/login_page.dart';

// This function shows a success or failure dialog
void showSignupPopup(BuildContext context, bool success) {
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
                  ? "Signup Success"
                  : "Signup Failed", // Use localization if needed
              style: CustomTextStyles.labelTextField,
            ),
            const SizedBox(height: 20),
            success
                ? ElevatedButton(
                    onPressed: () {
                      // Use the main context to navigate
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text(
                        "Come to Login"), // Use localization if needed
                  )
                : ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    child: const Text(
                        "Signup Again"), // Use localization if needed
                  ),
          ],
        ),
      );
    },
  );
}
