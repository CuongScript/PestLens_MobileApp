import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:pest_lens_app/dummy/insect_dummy_data.dart';
import 'package:pest_lens_app/models/insect_count_model.dart';

class MyLineChart extends StatefulWidget {
  const MyLineChart({super.key});

  List<FlSpot> processInsectData(List<InsectCountModel> insectCountList) {
    Map<int, double> dailyCounts = {};

    for (var insect in insectCountList) {
      int dayDifference = DateTime.now().difference(insect.date).inDays;
      if (dailyCounts.containsKey(dayDifference)) {
        dailyCounts[dayDifference] = dailyCounts[dayDifference]! + insect.count;
      } else {
        dailyCounts[dayDifference] = insect.count.toDouble();
      }
    }

    List<FlSpot> spots = [];
    dailyCounts.forEach((day, count) {
      spots.add(FlSpot(day.toDouble(), count));
    });

    return spots;
  }

  @override
  State<StatefulWidget> createState() {
    return _MyLineChartState();
  }
}

class _MyLineChartState extends State<MyLineChart> {
  DateTime baseDate = DateTime.now();
  List<FlSpot> processInsectData(List<InsectCountModel> insectCountList) {
// Group the counts by date
    Map<DateTime, int> totalCountsByDate = {};

    for (var insect in insectCountList) {
      // Round the date to the nearest day (ignoring time part)
      DateTime date =
          DateTime(insect.date.year, insect.date.month, insect.date.day);

      if (totalCountsByDate.containsKey(date)) {
        totalCountsByDate[date] = totalCountsByDate[date]! + insect.count;
      } else {
        totalCountsByDate[date] = insect.count;
      }
    }

    // Convert the totals to a list of FlSpot
    List<FlSpot> spots = [];

    // Sort the dates to ensure the graph is plotted correctly over time
    List<DateTime> sortedDates = totalCountsByDate.keys.toList()..sort();

    // Calculate the base date to make sure dates are represented as consecutive integers
    baseDate = sortedDates.first;

    for (var date in sortedDates) {
      double xValue = date.difference(baseDate).inDays.toDouble();
      spots.add(FlSpot(xValue, totalCountsByDate[date]!.toDouble()));
    }

    return spots;
  }

  double getMaxInsectCount(List<FlSpot> spotList) {
    double maxCount = 0;
    for (var spot in spotList) {
      if (spot.y > maxCount) {
        maxCount = spot.y;
      }
    }
    return maxCount;
  }

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = processInsectData(dummyInsectCountList);
    double maxY = getMaxInsectCount(spots);

    return Center(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Historical Chart Number Of Insects',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 30),
                IconButton(
                  onPressed: () {
                    // Open the setting for the chart
                  },
                  icon: const Icon(Icons.more_vert),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
              child: AspectRatio(
                aspectRatio: 1,
                child: LineChart(mainData(spots, maxY, baseDate)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

LineChartData mainData(List<FlSpot> spots, double maxY, DateTime baseDate) {
  return LineChartData(
    gridData: FlGridData(
      show: true,
      drawVerticalLine: true,
      horizontalInterval: maxY / 5,
      verticalInterval: 1,
      getDrawingHorizontalLine: (value) {
        return const FlLine(
          color: Color(0xff37434d),
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return const FlLine(
          color: Color(0xff37434d),
          strokeWidth: 1,
        );
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false, reservedSize: 40)),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: 1,
          getTitlesWidget: (value, media) =>
              bottomTitleWidgets(value, media, baseDate),
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: maxY / 5,
          getTitlesWidget: leftTitleWidgets,
          reservedSize: 40,
        ),
      ),
    ),
    borderData: FlBorderData(
      show: true,
      border: Border.all(color: const Color(0xff37434d)),
    ),
    minX: 0,
    maxX: spots.length.toDouble() - 1,
    minY: 0,
    maxY: maxY,
    lineBarsData: [
      LineChartBarData(
        spots: spots,
        isCurved: true,
        gradient: const LinearGradient(
          colors: [Color(0xff23b6e6), Color(0xff02d39a)],
        ),
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: const FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [const Color(0xff23b6e6), const Color(0xff02d39a)]
                .map((color) => color.withOpacity(0.3))
                .toList(),
          ),
        ),
      ),
    ],
  );
}

Widget bottomTitleWidgets(double value, TitleMeta meta, DateTime baseDate) {
  const style = TextStyle(
    color: Color(0xff68737d),
    fontWeight: FontWeight.bold,
    fontSize: 12, // Adjusted font size for better readability
  );

  DateTime date = baseDate.add(Duration(days: value.toInt()));
  ;
  String formattedDate = DateFormat('dd/mM').format(date);

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(formattedDate, style: style),
  );
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Color.fromARGB(255, 0, 0, 0),
    fontWeight: FontWeight.bold,
    fontSize: 12, // Adjust font size for better readability
  );

  int labelValue = value.toInt();

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(labelValue.toString(), style: style),
  );
}
