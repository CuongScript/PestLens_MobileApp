import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/language_selection_dropdown.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/components/my_text_field.dart';
import 'package:pest_lens_app/components/my_submit_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pest_lens_app/models/role_enum.dart';
import 'package:pest_lens_app/models/user.dart';
import 'package:pest_lens_app/pages/admin/admin_main_page.dart';
import 'package:pest_lens_app/pages/authen/forgot_password_page.dart';
import 'package:pest_lens_app/pages/authen/sign_up_page.dart';
import 'package:pest_lens_app/pages/farmer/farmer_tab_page.dart';
import 'package:pest_lens_app/services/connectivity_wrapper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pest_lens_app/utils/config.dart';
import 'package:pest_lens_app/utils/user_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Sign user in method
  void signUserIn() async {
    final messenger = ScaffoldMessenger.of(context);
    final invalidCredentialsText =
        AppLocalizations.of(context)!.invalidCredentials;
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('${Config.apiUrl}/login'));
    request.body = json.encode({
      "username": usernameController.text,
      "password": passwordController.text
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      User user = User.fromJson(jsonResponse);

      // Save user information
      await UserPreferences.saveUser(user);

      // Check if the widget is still mounted before navigating
      if (!mounted) return;

      // Navigate based on role
      if (user.roles.contains(Role.ROLE_ADMIN)) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminMainPage()),
        );
      } else if (user.roles.contains(Role.ROLE_USER)) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FarmerTabPage()),
        );
      }
    } else {
      // Clear the input fields
      usernameController.clear();
      passwordController.clear();

      // Show an error message to the user
      messenger.showSnackBar(
        SnackBar(
          content: Text(invalidCredentialsText),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      child: Scaffold(
        backgroundColor: primaryBackgroundColor,
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [LanguageSelectionDropdown()],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  // Logo
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 90.0),
                    child: Image.asset(
                      'lib/assets/images/appIcon.png',
                    ),
                  ),

                  const SizedBox(height: 39.05),

                  // App name
                  const Text("InsectInsight", style: CustomTextStyles.appName),

                  const SizedBox(height: 56),

                  // Username textfield
                  MyTextField(
                    controller: usernameController,
                    obscureText: false,
                    prefixIcon:
                        const Icon(Icons.email_outlined, color: Colors.black),
                    hintText: AppLocalizations.of(context)!.logInEmail,
                    showRevealButton: false,
                    textInputAction: TextInputAction.next,
                    labelText: AppLocalizations.of(context)!.logInEmail,
                  ),

                  const SizedBox(height: 20),

                  // Password textfield
                  MyTextField(
                    controller: passwordController,
                    obscureText: true,
                    prefixIcon:
                        const Icon(Icons.lock_outline, color: Colors.black),
                    hintText: AppLocalizations.of(context)!.logInPass,
                    showRevealButton: true,
                    textInputAction: TextInputAction.done,
                    labelText: AppLocalizations.of(context)!.logInPass,
                  ),

                  const SizedBox(height: 20),

                  // Forgot password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordPage(),
                                ),
                              );
                            },
                            child: Text(
                              AppLocalizations.of(context)!.logInForgotPass,
                              style: CustomTextStyles.forgotPass,
                            ))
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //sign up
                      MySubmitButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                        buttonText: AppLocalizations.of(context)!.signUp,
                        isFilled: false,
                      ),

                      // Sign in button
                      MySubmitButton(
                        onTap: signUserIn,
                        buttonText: AppLocalizations.of(context)!.signIn,
                        isFilled: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
