import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_back_button.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/components/my_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pest_lens_app/components/my_submit_button.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final emailController = TextEditingController();

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
            children: [
              const SizedBox(
                height: 64,
              ),
              Text(
                AppLocalizations.of(context)!.logInForgotPass,
                style: CustomTextStyles.appName,
              ),
              const SizedBox(
                height: 9,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Text(
                  AppLocalizations.of(context)!.textForgotPass,
                  style: CustomTextStyles.forgotPass,
                ),
              ),
              const SizedBox(
                height: 49,
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
                height: 33,
              ),
              MySubmitButton(
                onTap: () {
                  Navigator.pushNamed(context, '/verify-email');
                },
                buttonText: AppLocalizations.of(context)!.sendCode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
