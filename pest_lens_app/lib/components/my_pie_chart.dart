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
  final int total = 100;

  final List<UserAccountStatus> data = [
    UserAccountStatus('Active Users', 10, Colors.blue),
    UserAccountStatus('New Users', 20, Colors.green),
    UserAccountStatus('Deactivated Users', 50, Colors.red),
    UserAccountStatus('Pending Users', 20, Colors.orange),
  ];

  void pieTouchHandler(
      charts.FlTouchEvent event, charts.PieTouchResponse? pieTouchResponse) {
    setState(() {
      if (pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
        touchedIndex = -1;
        return;
      }
      if (event is charts.FlTapUpEvent) {
        final index = pieTouchResponse.touchedSection!.touchedSectionIndex;
        touchedIndex = (touchedIndex == index) ? -1 : index;
      }
    });
  }

  List<charts.PieChartSectionData> _createSampleData() {
    return List.generate(data.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 16.0;
      final radius = isTouched ? 70.0 : 60.0;
      final color = data[i].color;

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

  List<Widget> _buildIndicators() {
    return List.generate((data.length / 2).ceil(), (i) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Indicator(
            color: data[i * 2].color,
            text: data[i * 2].type,
            isSquare: false,
            size: touchedIndex == i * 2 ? 18 : 16,
            textColor: touchedIndex == i * 2 ? Colors.black : Colors.grey,
          ),
          if (i * 2 + 1 < data.length)
            Indicator(
              color: data[i * 2 + 1].color,
              text: data[i * 2 + 1].type,
              isSquare: false,
              size: touchedIndex == i * 2 + 1 ? 18 : 16,
              textColor: touchedIndex == i * 2 + 1 ? Colors.black : Colors.grey,
            ),
        ],
      );
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
              height: 250,
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
                      centerSpaceRadius: 60, // Increase white space inside
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
            const SizedBox(height: 30),
            const Divider(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildIndicators(),
            ),
          ],
        ),
      ),
    );
  }
}

class UserAccountStatus {
  final String type;
  final int count;
  final Color color;

  UserAccountStatus(this.type, this.count, this.color);
}
