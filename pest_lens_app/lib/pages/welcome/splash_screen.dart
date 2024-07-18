import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pest_lens_app/assets/colors.dart';

import 'package:pest_lens_app/models/role_enum.dart';
import 'package:pest_lens_app/models/user.dart';
import 'package:pest_lens_app/pages/admin/admin_main_page.dart';
import 'package:pest_lens_app/pages/authen/login_page.dart';
import 'package:pest_lens_app/pages/farmer/farmer_tab_page.dart';
import 'package:pest_lens_app/utils/user_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<Widget> _getNextScreen() async {
    User? user = await UserPreferences.getUser();

    if (user != null) {
      if (user.roles.contains(Role.ROLE_ADMIN)) {
        return const AdminMainPage();
      } else if (user.roles.contains(Role.ROLE_USER)) {
        return const FarmerTabPage();
      }
    }

    return const LoginPage();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getNextScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: primaryBackgroundColor,
            body: Center(
              child: Lottie.asset(
                'lib/assets/splash_animation/splash_animation.json',
                repeat: true,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            backgroundColor: primaryBackgroundColor,
            body: Center(
              child: Text('An error occurred!'),
            ),
          );
        } else {
          return AnimatedSplashScreen(
            splash: Stack(
              alignment: Alignment.center,
              children: [
                Lottie.asset(
                  'lib/assets/splash_animation/splash_animation.json',
                  repeat: true,
                ),
                Positioned(
                  bottom: 0, // Adjust this value as needed
                  child: Image.asset(
                    'lib/assets/images/appIcon.png',
                    width: 200,
                    height: 30,
                  ),
                ),
              ],
            ),
            nextScreen:
                snapshot.data!, // Set the next screen based on the check
            splashIconSize: 250,
            duration: 3500,
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.leftToRight,
            backgroundColor: primaryBackgroundColor,
          );
        }
      },
    );
  }
}
