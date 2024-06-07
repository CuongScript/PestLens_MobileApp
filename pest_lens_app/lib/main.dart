// import 'package:flutter/material.dart';
// import 'package:pest_lens_app/pages/admin_main_page.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   Locale? _locale;

//   void setLocale(Locale locale) {
//     setState(() {
//       _locale = locale;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const AdminMainPage(),
//       theme: ThemeData(
//         dividerTheme: const DividerThemeData(
//           thickness: 2,
//           color: Colors.black,
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:pest_lens_app/l10n/l10n.dart';
import 'package:pest_lens_app/pages/splash_screen.dart'; // Import your splash screen
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(), // Set the home to SplashScreen
    );
  }
}