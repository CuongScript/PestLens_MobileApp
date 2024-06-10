import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_back_button.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/components/my_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pest_lens_app/components/my_submit_button.dart';


class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});

  final passController = TextEditingController();
  final rePassController = TextEditingController();

  void resetPass() {}

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
              Navigator.of(context).popUntil((route) => route.isFirst);
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
                AppLocalizations.of(context)!.resetPass,
                style: CustomTextStyles.appName,
              ),
              const SizedBox(
                height: 9,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Text(
                  AppLocalizations.of(context)!.textResetPass,
                  style: CustomTextStyles.forgotPass,
                ),
              ),
              const SizedBox(
                height: 49,
              ),
              MyTextField(
                controller: passController,
                obscureText: true,
                prefixIcon: const Icon(Icons.lock, color: Colors.black),
                hintText: AppLocalizations.of(context)!.logInPass,
                showRevealButton: true,
                textInputAction: TextInputAction
                    .next, //TextInputAction.done to stop and hide keyboard
                labelText: AppLocalizations.of(context)!.logInPass,
              ),
              const SizedBox(
                height: 20,
              ),
              MyTextField(
                controller: rePassController,
                obscureText: true,
                prefixIcon: const Icon(Icons.lock, color: Colors.black),
                hintText: AppLocalizations.of(context)!.reEnterPass,
                showRevealButton: true,
                textInputAction: TextInputAction
                    .next, //TextInputAction.done to stop and hide keyboard
                labelText: AppLocalizations.of(context)!.reEnterPass,
              ),
              const SizedBox(
                height: 33,
              ),
              MySubmitButton(
                onTap: () {
                  resetPass;
                  Navigator.of(context).popUntil((route) => route.isFirst);
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
