import 'package:flutter/material.dart';
import 'package:pest_lens_app/components/dashboard_card.dart';
import 'package:pest_lens_app/models/dashboard_item.dart';

class DashboardGrid extends StatelessWidget {
  final List<DashboardItem> items;

  const DashboardGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 1.2,
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          // If count is 0, set index to a negative number
          final adjustedIndex = _getAdjustedIndex(index, item.count);
          return DashboardCard(
            item: item,
            index: adjustedIndex,
          );
        },
      ),
    );
  }

  int _getAdjustedIndex(int index, int count) {
    if (count == 0) return -2;
    return index > 0 ? index - 1 : index;
  }
}
