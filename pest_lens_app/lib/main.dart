import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/l10n/l10n.dart';
import 'package:pest_lens_app/pages/welcome/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pest_lens_app/provider/language_provider.dart';
import 'package:pest_lens_app/provider/notification_service_provider.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize Settings
  await Settings.init(
    cacheProvider: SharePreferenceCache(),
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    ref.read(notificationServiceProvider).init();

    Locale currentLocale = ref.watch(localeProvider);
    ColorScheme _schemeColor = ColorScheme.fromSeed(
        seedColor: const Color(0xFFF2F6FF), background: Colors.white);

    return MaterialApp(
      locale: currentLocale,
      debugShowCheckedModeBanner: false,
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
      theme: ThemeData(
        colorScheme: _schemeColor,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF2F6FF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF2F6FF),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0064C3),
            foregroundColor: Colors.white,
            textStyle: CustomTextStyles.submitButton,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFE3ECFE),
          selectedItemColor: Color(0xFF3599EE),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
