import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_text_form_field.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/components/my_submit_button.dart';
import 'package:pest_lens_app/models/farmer_register_model.dart';
import 'package:pest_lens_app/provider/user_register_model_provider.dart';
import 'package:pest_lens_app/pages/authen/signup_profile_page.dart';
import 'package:pest_lens_app/utils/textfield_validator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pest_lens_app/components/signup_popup_dialog.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final rePasswordController = TextEditingController();
    final usernameFieldKey = GlobalKey<FormFieldState>();
    final emailFieldKey = GlobalKey<FormFieldState>();
    final passwordFieldKey = GlobalKey<FormFieldState>();
    final rePasswordFieldKey = GlobalKey<FormFieldState>();

    void signUserUp() async {
      if (formKey.currentState?.validate() ?? false) {
        // Update the user model with the latest data from form fields
        ref
            .read(userRegisterModelProvider.notifier)
            .updateModel(FarmerRegisterModel(
              username: usernameController.text,
              email: emailController.text,
              password: passwordController.text,
              firstName: "",
              lastName: "",
              phoneNumber: "",
              avatarUrl: null,
            ));

        // Navigate to the UserProfilePage
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SignupProfilePage()));
      } else {
        showSignupPopup(context, false);
      }
    }

    void validateField(GlobalKey<FormFieldState> key) {
      final field = key.currentState;
      field?.validate();
    }

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SafeArea(
        child: Builder(
          builder: (BuildContext newContext) {
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100),
                    Text(
                      AppLocalizations.of(context)!.createAccount,
                      style: CustomTextStyles.appName,
                    ),
                    const SizedBox(height: 37),
                    MyTextFormField(
                      fieldKey: usernameFieldKey,
                      controller: usernameController,
                      obscureText: false,
                      prefixIcon:
                          const Icon(Icons.person_outline, color: Colors.black),
                      hintText:
                          AppLocalizations.of(context)!.username,
                      showRevealButton: false,
                      textInputAction: TextInputAction.next,
                      labelText:
                          AppLocalizations.of(context)!.username,
                      validator: (value) => TextfieldValidator.validateUsername(
                          value, newContext),
                      onChanged: (value) {
                        validateField(usernameFieldKey);
                      },
                    ),
                    const SizedBox(height: 28),
                    MyTextFormField(
                      fieldKey: emailFieldKey,
                      controller: emailController,
                      obscureText: false,
                      prefixIcon:
                          const Icon(Icons.email_outlined, color: Colors.black),
                      hintText:
                          AppLocalizations.of(context)!.logInEmail, // Replace with actual string if using localization
                      showRevealButton: false,
                      textInputAction: TextInputAction.next,
                      labelText:
                          AppLocalizations.of(context)!.logInEmail, // Replace with actual string if using localization
                      validator: (value) =>
                          TextfieldValidator.validateEmail(value, newContext),
                      onChanged: (value) {
                        validateField(emailFieldKey);
                      },
                    ),
                    const SizedBox(height: 28),
                    MyTextFormField(
                      fieldKey: passwordFieldKey,
                      controller: passwordController,
                      obscureText: true,
                      prefixIcon:
                          const Icon(Icons.lock_outline, color: Colors.black),
                      hintText:
                          AppLocalizations.of(context)!.logInPass, // Replace with actual string if using localization
                      showRevealButton: true,
                      textInputAction: TextInputAction.next,
                      labelText:
                          AppLocalizations.of(context)!.logInPass, // Replace with actual string if using localization
                      validator: (value) => TextfieldValidator.validatePassword(
                          value, newContext),
                      onChanged: (value) {
                        validateField(passwordFieldKey);
                      },
                    ),
                    const SizedBox(height: 28),
                    MyTextFormField(
                      fieldKey: rePasswordFieldKey,
                      controller: rePasswordController,
                      obscureText: true,
                      prefixIcon:
                          const Icon(Icons.lock_outline, color: Colors.black),
                      hintText:
                          AppLocalizations.of(context)!.reEnterPass, // Replace with actual string if using localization
                      showRevealButton: true,
                      textInputAction: TextInputAction.done,
                      labelText:
                          AppLocalizations.of(context)!.reEnterPass, // Replace with actual string if using localization
                      validator: (value) =>
                          TextfieldValidator.validateRePassword(
                              value, passwordController.text, newContext),
                      onChanged: (value) {
                        validateField(rePasswordFieldKey);
                      },
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //sign up
                        MySubmitButton(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          buttonText: AppLocalizations.of(context)!.back,
                          isFilled: false,
                        ),
                        MySubmitButton(
                          onTap: signUserUp,
                          buttonText: AppLocalizations.of(context)!.next,
                          isFilled: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
