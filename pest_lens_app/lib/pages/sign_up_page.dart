import 'package:flutter/material.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/components/my_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Create Account', style: CustomTextStyles.appName),
            const SizedBox(
              height: 16,
            ),
            MyTextField(
              controller: usernameController,
              obscureText: false,
              prefixIcon: const Icon(Icons.person, color: Colors.black),
              hintText: AppLocalizations.of(context)!.username,
              showRevealButton: false,
              textInputAction: TextInputAction
                  .next, //TextInputAction.done to stop and hide keyboard
              labelText: AppLocalizations.of(context)!.username,
            ),
            const SizedBox(
              height: 16,
            ),
            MyTextField(
              controller: emailController,
              obscureText: false,
              prefixIcon: const Icon(Icons.email, color: Colors.black),
              hintText: AppLocalizations.of(context)!.logInEmail,
              showRevealButton: false,
              textInputAction: TextInputAction
                  .next, //TextInputAction.done to stop and hide keyboard
              labelText: AppLocalizations.of(context)!.logInEmail,
            ),
            const SizedBox(
              height: 16,
            ),
            MyTextField(
              controller: passwordController,
              obscureText: false,
              prefixIcon: const Icon(Icons.lock, color: Colors.black),
              hintText: AppLocalizations.of(context)!.logInPass,
              showRevealButton: true,
              textInputAction: TextInputAction
                  .next, //TextInputAction.done to stop and hide keyboard
              labelText: AppLocalizations.of(context)!.logInPass,
            ),
            const SizedBox(
              height: 16,
            ),
            MyTextField(
              controller: rePasswordController,
              obscureText: false,
              prefixIcon: const Icon(Icons.lock, color: Colors.black),
              hintText: AppLocalizations.of(context)!.reEnterPass,
              showRevealButton: true,
              textInputAction: TextInputAction
                  .next, //TextInputAction.done to stop and hide keyboard
              labelText: AppLocalizations.of(context)!.reEnterPass,
            ),
            


            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Checkbox(
                  value: true,
                  onChanged: (bool? value) {},
                ),
                const Expanded(
                  child: Text('I accept the terms and privacy policy'),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            //Button
            const Spacer(),
            Center(
              child: TextButton(
                onPressed: () {
                  //Handle
                },
                child: const Text('Already have an account? Log in'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
