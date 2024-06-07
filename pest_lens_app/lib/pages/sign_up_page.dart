import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_back_button.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/components/my_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pest_lens_app/components/my_submit_button.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();

  void signUserUP() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            icon: const MyBackButton(),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              Text(AppLocalizations.of(context)!.createAccount,
                  style: CustomTextStyles.appName),
              const SizedBox(
                height: 37,
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
                height: 28,
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
                height: 28,
              ),
              MyTextField(
                controller: passwordController,
                obscureText: true,
                prefixIcon: const Icon(Icons.lock, color: Colors.black),
                hintText: AppLocalizations.of(context)!.logInPass,
                showRevealButton: true,
                textInputAction: TextInputAction
                    .done, //TextInputAction.done to stop and hide keyboard
                labelText: AppLocalizations.of(context)!.logInPass,
              ),
              const SizedBox(
                height: 28,
              ),
              MyTextField(
                controller: rePasswordController,
                obscureText: true,
                prefixIcon: const Icon(Icons.lock, color: Colors.black),
                hintText: AppLocalizations.of(context)!.reEnterPass,
                showRevealButton: true,
                textInputAction: TextInputAction
                    .done, //TextInputAction.done to stop and hide keyboard
                labelText: AppLocalizations.of(context)!.reEnterPass,
              ),

              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: true,
                      onChanged: (bool? value) {},
                    ),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.termAndPolicy,
                        style: CustomTextStyles.labelTextField,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 19,
              ),
              //Button
              MySubmitButton(
                onTap: signUserUP,
                buttonText: AppLocalizations.of(context)!.signUp,
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.alreadyAccount,
                    style: CustomTextStyles.labelTextField,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
