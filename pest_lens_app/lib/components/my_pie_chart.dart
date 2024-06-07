import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart' as charts;

class PieChartWidget extends StatefulWidget {
  const PieChartWidget({super.key});

  @override
  State<StatefulWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;
  final int total = 2695;

  pieTouchHandler(event, pieTouchResponse) {
    setState(() {
      if (pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
        touchedIndex = -1;
        return;
      }
      if (event is charts.FlTapUpEvent) {
        final index = pieTouchResponse.touchedSection!.touchedSectionIndex;
        if (touchedIndex == index) {
          touchedIndex = -1;
        } else {
          touchedIndex = index;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Users Account Distribution',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: charts.PieChart(
                charts.PieChartData(
                  pieTouchData: charts.PieTouchData(
                    touchCallback: pieTouchHandler,
                  ),
                  sections: _createSampleData(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 60,
                ),
              ),
            ),
            Center(
              child: Text(
                'Total\n$total',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<charts.PieChartSectionData> _createSampleData() {
    final data = [
      UserAccountStatus('Active Users', 917),
      UserAccountStatus('New Users', 606),
      UserAccountStatus('Deactivated Users', 383),
      UserAccountStatus('Pending Users', 789),
    ];

    return List.generate(data.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 16.0;
      final radius = isTouched ? 70.0 : 60.0;
      final color = Colors.primaries[i % Colors.primaries.length];

      return charts.PieChartSectionData(
        color: color,
        value: data[i].count.toDouble(),
        title: '${data[i].count}',
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

class UserAccountStatus {
  final String type;
  final int count;

  UserAccountStatus(this.type, this.count);
}
