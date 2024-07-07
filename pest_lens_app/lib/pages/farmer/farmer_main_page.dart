import 'package:flutter/material.dart';

class FarmerMainPage extends StatefulWidget {
  const FarmerMainPage({super.key});

  @override
  State<FarmerMainPage> createState() {
    return _FarmerMainPageState();
  }
}

class _FarmerMainPageState extends State<FarmerMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Main Page'),
      ),
    );
  }
}
