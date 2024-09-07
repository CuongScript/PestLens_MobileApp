import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/language_selection_dropdown.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/components/my_text_field.dart';
import 'package:pest_lens_app/components/my_submit_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pest_lens_app/models/role_enum.dart';
import 'package:pest_lens_app/models/user.dart';
import 'package:pest_lens_app/pages/admin/admin_tab_page.dart';
import 'package:pest_lens_app/pages/authen/forgot_password_page.dart';
import 'package:pest_lens_app/pages/authen/signup_page.dart';
import 'package:pest_lens_app/pages/farmer/farmer_tab_page.dart';
import 'package:pest_lens_app/services/connectivity_wrapper.dart';
import 'package:pest_lens_app/services/auth_service.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pest_lens_app/provider/notification_service_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void signUserIn() async {
    final messenger = ScaffoldMessenger.of(context);
    final invalidCredentialsText =
        AppLocalizations.of(context)!.invalidCredentials;

    User? user = await _authService.signUserIn(
      usernameController.text,
      passwordController.text,
    );

    if (user != null) {
      if (!mounted) return;
      _navigateBasedOnRole(user);
    } else {
      usernameController.clear();
      passwordController.clear();
      messenger.showSnackBar(
        SnackBar(content: Text(invalidCredentialsText)),
      );
    }
  }

  void signInWithGoogle() async {
    User? user = await _authService.signInWithGoogle();
    if (user != null) {
      if (!mounted) return;
      _navigateBasedOnRole(user);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to sign in with Google")),
      );
    }
  }

  void _navigateBasedOnRole(User user) async {
    final notificationService = ref.read(notificationServiceProvider);

    // Subscribe to topics based on user role
    if (user.roles.contains(Role.ROLE_ADMIN)) {
      await notificationService.subscribeToTopic('USER_CREATED');
      await notificationService.unsubscribeFromTopic('PEST_ALERT');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminTabPage()),
      );
    } else if (user.roles.contains(Role.ROLE_USER)) {
      await notificationService.subscribeToTopic('PEST_ALERT');
      await notificationService.unsubscribeFromTopic('USER_CREATED');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FarmerTabPage()),
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
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 90.0),
                    child: Image.asset('lib/assets/images/appIcon.png'),
                  ),
                  const SizedBox(height: 39.05),
                  const Text("InsectInsight", style: CustomTextStyles.appName),
                  const SizedBox(height: 56),
                  MyTextField(
                    controller: usernameController,
                    obscureText: false,
                    prefixIcon:
                        const Icon(Icons.email_outlined, color: Colors.black),
                    hintText:
                        // 'Enter ${AppLocalizations.of(context)!.username} or ${AppLocalizations.of(context)!.logInEmail}',
                        '',
                    showRevealButton: false,
                    textInputAction: TextInputAction.next,
                    labelText:
                        '${AppLocalizations.of(context)!.username} / ${AppLocalizations.of(context)!.logInEmail}',
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    controller: passwordController,
                    obscureText: true,
                    prefixIcon:
                        const Icon(Icons.lock_outline, color: Colors.black),
                    hintText:
                        // 'Enter ${AppLocalizations.of(context)!.logInPass}',
                        '',
                    showRevealButton: true,
                    textInputAction: TextInputAction.done,
                    labelText: AppLocalizations.of(context)!.logInPass,
                  ),
                  const SizedBox(height: 20),
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
                                      const ForgotPasswordPage()),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.logInForgotPass,
                            style: CustomTextStyles.forgotPass,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MySubmitButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()),
                          );
                        },
                        buttonText: AppLocalizations.of(context)!.signUp,
                        isFilled: false,
                      ),
                      MySubmitButton(
                        onTap: signUserIn,
                        buttonText: AppLocalizations.of(context)!.signIn,
                        isFilled: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: MySubmitButton(
                      onTap: signInWithGoogle,
                      buttonText: AppLocalizations.of(context)!.googleSignIn,
                      isFilled: true,
                      iconPath: 'lib/assets/images/google_logo.png',
                    ),
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
