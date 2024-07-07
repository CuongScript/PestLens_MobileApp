import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/dashboard_card.dart';
import 'package:pest_lens_app/components/dashboard_grid.dart';
import 'package:pest_lens_app/components/my_pie_chart.dart';
import 'package:pest_lens_app/components/my_text_style.dart';

class AdminMainPage extends StatelessWidget {
  const AdminMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DashboardItem> items = [
      const DashboardItem('Active Users', '10'),
      const DashboardItem('New Users', '20'),
      const DashboardItem('Deactivated Users', '50'),
      const DashboardItem('Pending Users', '20'),
    ];

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        title: const Text('Dashboard', style: CustomTextStyles.pageTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              const PieChartWidget(),
              const SizedBox(height: 10),
              DashboardGrid(items: items),
            ],
          ),
        ),
      ),
    );
  }
}
