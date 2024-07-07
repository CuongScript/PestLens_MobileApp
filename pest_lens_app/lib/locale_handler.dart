import 'package:flutter/material.dart';
import 'package:pest_lens_app/pages/authen/forgot_password.dart';
import 'package:pest_lens_app/pages/authen/login_page.dart';
import 'package:pest_lens_app/pages/authen/reset_password.dart';
import 'package:pest_lens_app/pages/authen/verify_email.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pest_lens_app/l10n/l10n.dart';
import 'package:pest_lens_app/pages/authen/sign_up_page.dart';

class LocaleHandler extends StatefulWidget {
  const LocaleHandler({super.key});

  @override
  LocaleHandlerState createState() => LocaleHandlerState();
}

class LocaleHandlerState extends State<LocaleHandler> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: LoginPage(
        onLocaleChange: setLocale,
      ),
      routes: {
        '/sign-up': (context) => const SignUpPage(),
        '/forgot-password': (context) => ForgotPassword(),
        '/verify-email': (context) => const VerifyEmail(),
        '/reset-password': (context) => ResetPassword(),
      },
    );
  }
}
