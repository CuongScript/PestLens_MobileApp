import 'package:fl_chart/fl_chart.dart';

class MinMaxFlSpot {
  final double min;
  final double max;

  MinMaxFlSpot(this.min, this.max);
}

MinMaxFlSpot getMinMax(List<FlSpot> spots) {
  double minY = double.infinity;
  double maxY = double.negativeInfinity;

  for (var spot in spots) {
    if (spot.y < minY) {
      minY = spot.y;
    }
    if (spot.y > maxY) {
      maxY = spot.y;
    }
  }

  // Adding some padding for better visualization
  minY = minY - (minY * 0.1);
  maxY = maxY + (maxY * 0.1);

  return MinMaxFlSpot(minY, maxY);
}
