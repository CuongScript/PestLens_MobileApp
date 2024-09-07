import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:pest_lens_app/models/insect_count_model.dart';
import 'package:pest_lens_app/services/insect_record_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyBarChart extends StatefulWidget {
  final VoidCallback onCalendarButtonPressed;
  final List<InsectCountModel> insectData;
  final DateTime startDate;
  final DateTime endDate;

  const MyBarChart({
    super.key,
    required this.onCalendarButtonPressed,
    required this.insectData,
    required this.startDate,
    required this.endDate,
  });

  @override
  _MyBarChartState createState() => _MyBarChartState();
}

class _MyBarChartState extends State<MyBarChart> {
  final InsectRecordService _insectRecordService = InsectRecordService();
  late List<Map<String, dynamic>> _insectTotals;

  @override
  void initState() {
    super.initState();
    _updateInsectTotals();
  }

  @override
  void didUpdateWidget(MyBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.insectData != widget.insectData ||
        oldWidget.startDate != widget.startDate ||
        oldWidget.endDate != widget.endDate) {
      _updateInsectTotals();
    }
  }

  void _updateInsectTotals() {
    _insectTotals = _insectRecordService.calculateInsectTotalByType(
      widget.insectData,
      widget.startDate,
      widget.endDate,
    );
  }

  List<ColumnSeries<Map<String, dynamic>, String>> _getSeriesData() {
    return _insectTotals.map((insect) {
      return ColumnSeries<Map<String, dynamic>, String>(
        dataSource: [insect],
        xValueMapper: (Map<String, dynamic> data, _) =>
            data['insectType'] as String,
        yValueMapper: (Map<String, dynamic> data, _) => data['count'] as int,
        name: insect['insectType'] as String,
        color:
            _insectRecordService.getInsectColor(insect['insectType'] as String),
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        width: 1.0,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.arggeNumber,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onCalendarButtonPressed,
                    icon: const Icon(Icons.edit_calendar_sharp),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _insectTotals.isEmpty
                  ? Center(
                      child: Text(
                        AppLocalizations.of(context)!.noData,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  : SfCartesianChart(
                      primaryXAxis: const CategoryAxis(
                        isVisible: false, // Hide x-axis
                      ),
                      primaryYAxis: const NumericAxis(),
                      series: _getSeriesData(),
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
                      tooltipBehavior: TooltipBehavior(enable: true),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
