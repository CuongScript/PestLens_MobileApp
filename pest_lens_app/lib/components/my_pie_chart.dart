import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart' as charts;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pest_lens_app/models/dashboard_item.dart';
import 'package:pest_lens_app/provider/dashboard_touch_provider.dart';
import 'package:pest_lens_app/provider/dashboard_uq_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PieChartWidget extends ConsumerWidget {
  const PieChartWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(dashboardUQProvider);
    final touchedIndex = ref.watch(dashBoardTouchedIndexProvider);
    final touchNotifier = ref.read(dashBoardTouchedIndexProvider.notifier);

    void pieTouchHandler(
        charts.FlTouchEvent event, charts.PieTouchResponse? pieTouchResponse) {
      if (pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
        touchNotifier.updateIndex(-1);
        return;
      }
      if (event is charts.FlTapUpEvent) {
        final index = pieTouchResponse.touchedSection!.touchedSectionIndex;
        touchNotifier.updateIndex(index);
      }
    }

    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.userAccDistri,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Divider(),
            SizedBox(
              height: 250,
              child: dataAsync.when(
                data: (data) => Stack(
                  alignment: Alignment.center,
                  children: [
                    charts.PieChart(
                      charts.PieChartData(
                        pieTouchData: charts.PieTouchData(
                          touchCallback: pieTouchHandler,
                        ),
                        sections: _createSampleData(data, touchedIndex),
                        sectionsSpace: 1,
                        centerSpaceRadius: 60,
                      ),
                    ),
                    Center(
                      child: Text(
                        '${AppLocalizations.of(context)!.total}\n${data.fold<int>(0, (sum, item) => sum + item.count)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('${AppLocalizations.of(context)!.error}: $error')),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  List<charts.PieChartSectionData> _createSampleData(
      List<DashboardItem> data, int touchedIndex) {
    // Filter out items with count 0
    final nonZeroData = data.where((item) => item.count > 0).toList();

    return List.generate(nonZeroData.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 16.0;
      final radius = isTouched ? 70.0 : 60.0;
      final item = nonZeroData[i];
      return charts.PieChartSectionData(
        color: item.color,
        value: item.count.toDouble(),
        title: '${item.count}',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        titlePositionPercentageOffset: 1.4,
      );
    });
  }
}
