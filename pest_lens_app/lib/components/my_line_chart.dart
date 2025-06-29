import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:pest_lens_app/models/insect_count_model.dart';
import 'package:pest_lens_app/services/insect_record_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    // Add missing dates with zero count
    if (isMultipleDays) {
      final allDates = List.generate(
        widget.endDate.difference(widget.startDate).inDays + 1,
        (index) => widget.startDate.add(Duration(days: index)),
      );

      final Map<DateTime, Map<String, dynamic>> dataMap = {
        for (var data in aggregatedData)
          (data['date'] as DateTime): Map<String, dynamic>.from(data)
      };

      for (final date in allDates) {
        if (!dataMap.containsKey(date)) {
          final Map<String, dynamic> emptyData = {'date': date};
          for (final insectType in insectTypes) {
            emptyData[insectType] = 0;
          }
          aggregatedData.add(emptyData);
        }
      }

      // Sort the aggregatedData again after adding missing dates
      aggregatedData.sort(
          (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));
    }

    List<CartesianSeries<Map<String, dynamic>, dynamic>> finalList =
        insectTypes.map((insectType) {
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

    return finalList;
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
                  Text(
                    AppLocalizations.of(context)!.histNumb,
                    style: const TextStyle(
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
                  ? Center(
                      child: Text(
                        AppLocalizations.of(context)!.noData,
                        style: const TextStyle(
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
