import 'package:flutter/material.dart';
import 'package:pest_lens_app/pages/admin_main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      home: const AdminMainPage(),
      theme: ThemeData(
        dividerTheme: const DividerThemeData(
          thickness: 2,
          color: Colors.black,
        ),
      ),
    );
  }
}
