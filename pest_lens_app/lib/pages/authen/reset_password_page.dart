import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:pest_lens_app/components/my_back_button.dart';
import 'package:pest_lens_app/components/my_text_form_field.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pest_lens_app/components/my_submit_button.dart';
import 'package:pest_lens_app/utils/config.dart';
import 'package:pest_lens_app/utils/textfield_validator.dart';
import 'package:pest_lens_app/components/reset_password_popup_dialog.dart';

class ResetPasswordPage extends StatelessWidget {
  final String token;
  ResetPasswordPage({super.key, required this.token});
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();

  Future<void> resetPass(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var response = await http
          .post(Uri.parse('${Config.apiUrl}/api/users/change-password'), body: {
        'token': token,
        'password': passwordController.text,
      });

      if (response.statusCode == 200) {
        showResetPasswordPopup(context, true);
        // Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        showResetPasswordPopup(context, false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 64),
                Text(
                  AppLocalizations.of(context)!.resetPass,
                  style: CustomTextStyles.appName,
                ),
                const SizedBox(height: 9),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Text(
                    AppLocalizations.of(context)!.textResetPass,
                    style: CustomTextStyles.forgotPass,
                  ),
                ),
                const SizedBox(height: 49),
                MyTextFormField(
                  controller: passwordController,
                  obscureText: true,
                  prefixIcon:
                      const Icon(Icons.lock_outline, color: Colors.black),
                  hintText: AppLocalizations.of(context)!.logInPass,
                  showRevealButton: true,
                  textInputAction: TextInputAction.next,
                  labelText: AppLocalizations.of(context)!.logInPass,
                  validator: (value) =>
                      TextfieldValidator.validatePassword(value, context),
                ),
                const SizedBox(height: 28),
                MyTextFormField(
                  controller: rePasswordController,
                  obscureText: true,
                  prefixIcon:
                      const Icon(Icons.lock_outline, color: Colors.black),
                  hintText: AppLocalizations.of(context)!.reEnterPass,
                  showRevealButton: true,
                  textInputAction: TextInputAction.done,
                  labelText: AppLocalizations.of(context)!.reEnterPass,
                  validator: (value) => TextfieldValidator.validateRePassword(
                      value, passwordController.text, context),
                ),
                const SizedBox(height: 33),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 45),
                  child: MySubmitButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        resetPass(context);
                      }
                    },
                    buttonText: AppLocalizations.of(context)!.sendCode,
                    isFilled: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
