import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:pest_lens_app/models/insect_count_model.dart';
import 'package:pest_lens_app/services/insect_record_service.dart';

class MyLineChart extends StatefulWidget {
  final VoidCallback onCalendarButtonPressed;
  final List<InsectCountModel> insectData;
  final DateTime startDate;
  final DateTime endDate;

  const MyLineChart({
    super.key,
    required this.onCalendarButtonPressed,
    required this.insectData,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<StatefulWidget> createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
  final InsectRecordService _insectRecordService = InsectRecordService();

  List<String> _getInsectTypes() {
    return widget.insectData
        .map((insect) => insect.englishName)
        .toSet()
        .toList();
  }

  List<CartesianSeries<Map<String, dynamic>, dynamic>> _getSeriesData() {
    if (widget.insectData.isEmpty) {
      return [];
    }

    final isMultipleDays =
        widget.endDate.difference(widget.startDate).inDays > 0;
    final aggregatedData = isMultipleDays
        ? _insectRecordService.calculateInsectTotalsByDate(widget.insectData)
        : _insectRecordService.calculateInsectTotalsByHour(widget.insectData);

    final insectTypes = _getInsectTypes();

    return insectTypes.map((insectType) {
      return LineSeries<Map<String, dynamic>, dynamic>(
        name: insectType,
        dataSource: aggregatedData,
        xValueMapper: (Map<String, dynamic> data, _) =>
            isMultipleDays ? data['date'] : data['hour'],
        yValueMapper: (Map<String, dynamic> data, _) => data[insectType] ?? 0,
        color: _insectRecordService.getInsectColor(insectType),
        width: 4,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isMultipleDays =
        widget.endDate.difference(widget.startDate).inDays > 0;

    return SizedBox(
      height: 360,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
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
                    'Historical Number of Insects',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onCalendarButtonPressed,
                    icon: const Icon(Icons.edit_calendar_sharp),
                  )
                ],
              ),
            ),
            Expanded(
              child: widget.insectData.isEmpty
                  ? const Center(
                      child: Text(
                        'No data available',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                      child: SfCartesianChart(
                        primaryXAxis: isMultipleDays
                            ? DateTimeAxis(
                                dateFormat: DateFormat('dd/MM'),
                                intervalType: DateTimeIntervalType.days,
                                interval: 1,
                              )
                            : const NumericAxis(
                                minimum: 0,
                                maximum: 24,
                                interval: 4,
                              ),
                        series: _getSeriesData(),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        legend: const Legend(
                          isVisible: true,
                          position: LegendPosition.bottom,
                          shouldAlwaysShowScrollbar: true,
                          overflowMode: LegendItemOverflowMode.scroll,
                          toggleSeriesVisibility: true,
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
