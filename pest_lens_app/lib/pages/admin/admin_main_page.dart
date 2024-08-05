import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/dashboard_grid.dart';
import 'package:pest_lens_app/components/my_pie_chart.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/provider/dashboard_touch_provider.dart';
import 'package:pest_lens_app/provider/dashboard_uq_provider.dart';

class AdminMainPage extends ConsumerStatefulWidget {
  const AdminMainPage({super.key});

  @override
  ConsumerState<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends ConsumerState<AdminMainPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(dashboardUQProvider.notifier).fetchDashboardData());
  }

  @override
  Widget build(BuildContext context) {
    final dashboardData = ref.watch(dashboardUQProvider);
    final touchedIndex = ref.watch(dashBoardTouchedIndexProvider);
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        title: const Text('Dashboard', style: CustomTextStyles.pageTitle),
        elevation: 0,
      ),
      body: SafeArea(
        child: dashboardData.when(
          data: (items) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const PieChartWidget(),
                  DashboardGrid(items: items),
                ],
              ),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}
