import 'package:fl_chart/fl_chart.dart';
import "package:flutter/material.dart";
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_pie_chart.dart';
import 'package:pest_lens_app/components/my_text_style.dart';

class AdminMainPage extends StatelessWidget {
  const AdminMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        title: const Text('Dashboard', style: CustomTextStyles.pageTitle),
      ),
      body: const SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  PieChartWidget(),
                  SizedBox(
                    height: 16,
                  )
                ],
              ))),
    );
  }
}
