import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/locale_handler.dart';
import 'package:pest_lens_app/pages/farmer/farmer_tab_page.dart';

class SplashScreen extends StatelessWidget {
  // const SplashScreen({Key? key}) : super(key: key);
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      // nextScreen: const LocaleHandler(), // Set the next screen to LocaleHandler
      nextScreen: const TabPage(),
      splashIconSize: 250,
      duration: 3500,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.leftToRight,
      backgroundColor: primaryBackgroundColor,
    );
  }
}
