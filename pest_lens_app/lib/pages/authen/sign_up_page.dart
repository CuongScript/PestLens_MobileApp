import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_back_button.dart';
import 'package:pest_lens_app/components/my_text_form_field.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pest_lens_app/components/my_submit_button.dart';
import 'package:pest_lens_app/locale_handler.dart';
import 'package:pest_lens_app/pages/authen/login_page.dart';
import 'package:pest_lens_app/utils/textfield_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pest_lens_app/utils/config.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  final usernameFieldKey = GlobalKey<FormFieldState>();
  final emailFieldKey = GlobalKey<FormFieldState>();
  final passwordFieldKey = GlobalKey<FormFieldState>();
  final rePasswordFieldKey = GlobalKey<FormFieldState>();
  bool isChecked = false;

  void _showPopup(bool success) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
              const SizedBox(height: 20),
              success
                  ? ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(
                              onLocaleChange: LocaleHandler.setLocale,
                            ),
                          ),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.comeToLogin),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.signupAgain),
                    ),
            ],
          ),
        );
      },
    );
  }

  void _signUserUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('${Config.apiUrl}/signup'));
      request.body = json.encode({
        "username": usernameController.text,
        "password": passwordController.text,
        "email": emailController.text
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        _showPopup(true);
      } else {
        _showPopup(false);
      }
    }
  }

  void _validateField(GlobalKey<FormFieldState> key) {
    final field = key.currentState;
    field?.validate();
  }

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
        child: Builder(
          builder: (BuildContext newContext) {
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100),
                    Text(
                      AppLocalizations.of(newContext)!.createAccount,
                      style: CustomTextStyles.appName,
                    ),
                    const SizedBox(height: 37),
                    MyTextFormField(
                      fieldKey: usernameFieldKey,
                      controller: usernameController,
                      obscureText: false,
                      prefixIcon: const Icon(Icons.person, color: Colors.black),
                      hintText: AppLocalizations.of(newContext)!.username,
                      showRevealButton: false,
                      textInputAction: TextInputAction.next,
                      labelText: AppLocalizations.of(newContext)!.username,
                      validator: (value) => TextfieldValidator.validateUsername(
                          value, newContext),
                      onChanged: (value) {
                        _validateField(usernameFieldKey);
                      },
                    ),
                    const SizedBox(height: 28),
                    MyTextFormField(
                      fieldKey: emailFieldKey,
                      controller: emailController,
                      obscureText: false,
                      prefixIcon: const Icon(Icons.email, color: Colors.black),
                      hintText: AppLocalizations.of(newContext)!.logInEmail,
                      showRevealButton: false,
                      textInputAction: TextInputAction.next,
                      labelText: AppLocalizations.of(newContext)!.logInEmail,
                      validator: (value) =>
                          TextfieldValidator.validateEmail(value, newContext),
                      onChanged: (value) {
                        _validateField(emailFieldKey);
                      },
                    ),
                    const SizedBox(height: 28),
                    MyTextFormField(
                      fieldKey: passwordFieldKey,
                      controller: passwordController,
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock, color: Colors.black),
                      hintText: AppLocalizations.of(newContext)!.logInPass,
                      showRevealButton: true,
                      textInputAction: TextInputAction.next,
                      labelText: AppLocalizations.of(newContext)!.logInPass,
                      validator: (value) => TextfieldValidator.validatePassword(
                          value, newContext),
                      onChanged: (value) {
                        _validateField(passwordFieldKey);
                      },
                    ),
                    const SizedBox(height: 28),
                    MyTextFormField(
                      fieldKey: rePasswordFieldKey,
                      controller: rePasswordController,
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock, color: Colors.black),
                      hintText: AppLocalizations.of(newContext)!.reEnterPass,
                      showRevealButton: true,
                      textInputAction: TextInputAction.done,
                      labelText: AppLocalizations.of(newContext)!.reEnterPass,
                      validator: (value) =>
                          TextfieldValidator.validateRePassword(
                              value, passwordController.text, newContext),
                      onChanged: (value) {
                        _validateField(rePasswordFieldKey);
                      },
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value ?? false;
                              });
                            },
                          ),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(newContext)!.termAndPolicy,
                              style: CustomTextStyles.labelTextField,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 19),
                    MySubmitButton(
                      onTap: _signUserUp,
                      buttonText: AppLocalizations.of(newContext)!.signUp,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          AppLocalizations.of(newContext)!.alreadyAccount,
                          style: CustomTextStyles.labelTextField,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
