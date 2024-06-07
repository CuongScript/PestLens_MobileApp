import 'package:flutter/material.dart';
import 'package:pest_lens_app/components/chart_indicator.dart';
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
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Divider(),
            SizedBox(
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  charts.PieChart(
                    charts.PieChartData(
                      pieTouchData: charts.PieTouchData(
                        touchCallback: pieTouchHandler,
                      ),
                      sections: _createSampleData(),
                      sectionsSpace: 1,
                      centerSpaceRadius: 60,
                    ),
                  ),
                  Center(
                    child: Text(
                      'Total\n$total',
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
            ),
            const SizedBox(height: 16),
            const Divider(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Indicator(color: Colors.blue, text: "active", isSquare: false),
                Indicator(color: Colors.green, text: "new", isSquare: false),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Indicator(
                    color: Colors.red, text: "deactivated", isSquare: false),
                Indicator(
                    color: Colors.orange, text: "pending", isSquare: false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<charts.PieChartSectionData> _createSampleData() {
    final data = [
      UserAccountStatus('Active Users', 10),
      UserAccountStatus('New Users', 20),
      UserAccountStatus('Deactivated Users', 50),
      UserAccountStatus('Pending Users', 20),
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
