import 'package:flutter/material.dart';
import 'package:pest_lens_app/pages/admin_main_page.dart';
import 'package:pest_lens_app/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminMainPage(),
    );
  }
}
