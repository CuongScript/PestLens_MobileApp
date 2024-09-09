import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:pest_lens_app/models/insect_alert_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InsectAlertBarChart extends StatefulWidget {
  final InsectAlertModel insectAlert;

  const InsectAlertBarChart({
    super.key,
    required this.insectAlert,
  });

  @override
  _InsectAlertBarChartState createState() => _InsectAlertBarChartState();
}

class _InsectAlertBarChartState extends State<InsectAlertBarChart> {
  late List<_ChartData> _chartData;
  late double _averageDifference;

  @override
  void initState() {
    super.initState();
    _updateChartData();
  }

  @override
  void didUpdateWidget(InsectAlertBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.insectAlert != widget.insectAlert) {
      _updateChartData();
    }
  }

  void _updateChartData() {
    _chartData = [
      _ChartData('Previous', widget.insectAlert.previousCount),
      _ChartData('Current', widget.insectAlert.currentCount),
    ];
    _averageDifference =
        (widget.insectAlert.currentCount - widget.insectAlert.previousCount) /
            2;
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    int daysBetween = widget.insectAlert.endDate
            .difference(widget.insectAlert.startDate)
            .inDays +
        1;

    return SizedBox(
      height: 380,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.averageAmountOf,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_formatDate(widget.insectAlert.startDate)} - ${_formatDate(widget.insectAlert.endDate)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    '${daysBetween} ${AppLocalizations.of(context)!.dates}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: const CategoryAxis(),
                primaryYAxis: const NumericAxis(),
                series: <CartesianSeries>[
                  ColumnSeries<_ChartData, String>(
                    dataSource: _chartData,
                    xValueMapper: (_ChartData data, _) => data.category,
                    yValueMapper: (_ChartData data, _) => data.count,
                    name: AppLocalizations.of(context)!.counting,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                  LineSeries<_ChartData, String>(
                    dataSource: _chartData,
                    xValueMapper: (_ChartData data, _) => data.category,
                    yValueMapper: (_ChartData data, _) =>
                        _averageDifference + widget.insectAlert.previousCount,
                    name: AppLocalizations.of(context)!.averageDif,
                    color: Colors.red,
                    width: 2,
                    markerSettings: const MarkerSettings(isVisible: true),
                  ),
                ],
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

class _ChartData {
  _ChartData(this.category, this.count);

  final String category;
  final int count;
}
