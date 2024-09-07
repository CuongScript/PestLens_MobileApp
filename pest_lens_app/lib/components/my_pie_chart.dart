import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pest_lens_app/models/dashboard_item.dart';
import 'package:pest_lens_app/provider/dashboard_uq_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PieChartWidget extends ConsumerWidget {
  const PieChartWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(dashboardUQProvider);

    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
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
              height: 310,
              child: dataAsync.when(
                data: (data) => _buildDonutChart(context, data),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                    child:
                        Text('${AppLocalizations.of(context)!.error}: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonutChart(BuildContext context, List<DashboardItem> data) {
    final nonZeroData = data.where((item) => item.count > 0).toList();
    final total = nonZeroData.fold<int>(0, (sum, item) => sum + item.count);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final centerX = size.width / 2;
        final centerY = size.height / 2.2;

        return Stack(
          children: [
            SfCircularChart(
              margin: const EdgeInsets.all(0),
              legend: const Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                overflowMode: LegendItemOverflowMode.scroll,
                shouldAlwaysShowScrollbar: true,
                toggleSeriesVisibility: true,
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              series: <CircularSeries>[
                DoughnutSeries<DashboardItem, String>(
                  dataSource: nonZeroData,
                  xValueMapper: (DashboardItem item, _) => item.title,
                  yValueMapper: (DashboardItem item, _) => item.count,
                  pointColorMapper: (DashboardItem item, _) => item.color,
                  dataLabelMapper: (DashboardItem item, _) => '${item.count}',
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    connectorLineSettings:
                        ConnectorLineSettings(type: ConnectorType.curve),
                    textStyle: TextStyle(
                      fontSize: 16, // Increased font size
                      fontWeight: FontWeight.bold, // Made the text bold
                      color: Colors
                          .black, // Ensured text color is black for visibility
                    ),
                  ),
                  enableTooltip: true,
                  innerRadius: '50%',
                  explode: true,
                  explodeIndex: -1,
                  explodeOffset: '10%',
                ),
              ],
              tooltipBehavior: TooltipBehavior(
                enable: true,
                format: 'point.x : point.y',
              ),
            ),
            Positioned(
              left: centerX,
              top: centerY,
              child: Transform.translate(
                offset: const Offset(-50, -30),
                child: Container(
                  width: 100,
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    '${AppLocalizations.of(context)!.total}\n$total',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
