import 'package:flutter/material.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/pages/authen/login_page.dart';

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
              success ? "Signup Success" : "Signup Failed",
              style: CustomTextStyles.labelTextField,
            ),
            const SizedBox(height: 10),
            Text(
              message ??
                  (success
                      ? "Your account has been created successfully."
                      : "There was an error creating your account. Please try again."),
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
                    child: const Text("Proceed to Login"),
                  )
                : ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    child: const Text("Try Again"),
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
        title: const Text('Warning'),
        content: const Text(
          'Profile image upload failed, but the signup process can continue. '
          'You can try uploading your profile image later.',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            child: const Text('Continue Signup'),
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
