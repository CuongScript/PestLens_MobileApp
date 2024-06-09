import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/components/my_text_field.dart';
import 'package:pest_lens_app/components/my_submit_button.dart';
import 'package:pest_lens_app/components/round_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//Call package below for language pack
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//Sample call
// Text(AppLocalizations.of(context)!.key),

class LoginPage extends StatelessWidget {
  LoginPage({super.key, required this.onLocaleChange});

  //Locale change
  final Function(Locale) onLocaleChange;

  // Text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Sign user in method
  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                // Logo
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 90.0),
                  child: Image.asset(
                    'lib/assets/images/appIcon.png',
                  ),
                ),

                const SizedBox(
                  height: 39.05,
                ),

                // App name
                const Text("InsectInsight", style: CustomTextStyles.appName),

                const SizedBox(
                  height: 56,
                ),

                // Username textfield
                MyTextField(
                  controller: usernameController,
                  obscureText: false,
                  prefixIcon: const Icon(Icons.email, color: Colors.black),
                  hintText: AppLocalizations.of(context)!.logInEmail,
                  showRevealButton: false,
                  textInputAction: TextInputAction.next,
                  labelText: AppLocalizations.of(context)!.logInEmail,
                ),

                const SizedBox(
                  height: 13,
                ),

                // Password textfield
                MyTextField(
                  controller: passwordController,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock, color: Colors.black),
                  hintText: AppLocalizations.of(context)!.logInPass,
                  showRevealButton: true,
                  textInputAction: TextInputAction.done,
                  labelText: AppLocalizations.of(context)!.logInPass,
                ),

                const SizedBox(
                  height: 10,
                ),

                // Forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/forgot-password');
                        },
                        child: Text(
                          AppLocalizations.of(context)!.logInForgotPass,
                          style: CustomTextStyles.forgotPass,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                // Sign in button
                MySubmitButton(
                  onTap: signUserIn,
                  buttonText: AppLocalizations.of(context)!.signIn,
                ),

                const SizedBox(
                  height: 10,
                ),

                // Sign up button
                MySubmitButton(
                  onTap: () {
                    Navigator.pushNamed(context, '/sign-up');
                  },
                  buttonText: AppLocalizations.of(context)!.signUp,
                ),

                const SizedBox(
                  height: 50,
                ),

                // Viet+Eng icon button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Vietnam icon
                    GestureDetector(
                      onTap: () => onLocaleChange(const Locale('vi')),
                      child: const RoundTile(
                          imagePath: 'lib/assets/images/Flag_of_Vietnam.png'),
                    ),

                    const SizedBox(width: 25),

                    //English icon
                    GestureDetector(
                      onTap: () => onLocaleChange(const Locale('en')),
                      child: const RoundTile(
                          imagePath:
                              'lib/assets/images/Flag_of_the_United_Kingdom.png'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
