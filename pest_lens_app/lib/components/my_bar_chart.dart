import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:pest_lens_app/models/insect_count_model.dart";
import "package:pest_lens_app/dummy/insect_dummy_data.dart";

class MyBarChart extends StatefulWidget {
  const MyBarChart({super.key});

  @override
  State<MyBarChart> createState() => _MyBarChartState();
}

class _MyBarChartState extends State<MyBarChart> {
  // Function to filter today's insect counts
  List<InsectCountModel> filterTodayInsectCounts() {
    final now = DateTime.now();
    return dummyInsectCountList.where((insect) {
      return insect.date.year == now.year &&
          insect.date.month == now.month &&
          insect.date.day == now.day;
    }).toList();
  }

  // Function to calculate the maximum count
  int calculateMaxCount(List<InsectCountModel> insectCounts) {
    return insectCounts.isEmpty
        ? 0
        : insectCounts
            .map((insect) => insect.count)
            .reduce((a, b) => a > b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    List<InsectCountModel> todayInsectCounts = filterTodayInsectCounts();
    int maxCount = calculateMaxCount(todayInsectCounts);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Agregation Number Of Insects',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Open the setting for the chart
                    },
                    icon: const Icon(Icons.more_vert),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
              child: AspectRatio(
                aspectRatio: 1,
                child: BarChart(mainData(todayInsectCounts, maxCount)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Function to generate BarChartData
BarChartData mainData(List<InsectCountModel> todayInsectCounts, int maxCount) {
  List<Color> barColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.cyan,
    Colors.pink,
    Colors.teal,
    Colors.amber,
    Colors.lime,
    Colors.indigo,
    // Add more colors if needed
  ];

  List<BarChartGroupData> barGroups =
      todayInsectCounts.asMap().entries.map((entry) {
    int index = entry.key;
    InsectCountModel insect = entry.value;
    return BarChartGroupData(
      x: index,
      barsSpace: 0,
      barRods: [
        BarChartRodData(
          toY: insect.count.toDouble(),
          borderRadius: BorderRadius.zero,
          width: 50,
          color: barColors[
              index % barColors.length], // Use different color for each bar
        ),
      ],
    );
  }).toList();

  return BarChartData(
    alignment: BarChartAlignment.center,
    barTouchData: BarTouchData(
      enabled: false,
    ),
    titlesData: FlTitlesData(
      show: true,
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: leftTitlesWidget,
          interval: maxCount / 5, // Adjust interval dynamically
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
          reservedSize: 30,
          getTitlesWidget: (value, meta) =>
              bottomTitleWidgets(value, meta, todayInsectCounts),
        ),
      ),
    ),
    barGroups: barGroups,
  );
}

Widget bottomTitleWidgets(
    double value, TitleMeta meta, List<InsectCountModel> todayInsectCounts) {
  const style = TextStyle(
    color: Color(0xff68737d),
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );
  String title = todayInsectCounts[value.toInt()].englishName;
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(title, style: style),
  );
}

Widget leftTitlesWidget(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Color.fromARGB(255, 0, 0, 0),
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(value.toInt().toString(), style: style),
  );
}
