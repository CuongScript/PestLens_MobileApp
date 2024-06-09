import 'package:flutter/material.dart';
import 'package:pest_lens_app/components/dashboard_card.dart';

class DashboardGrid extends StatelessWidget {
  final List<DashboardItem> items;

  const DashboardGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GridView.builder(
        physics:
            const NeverScrollableScrollPhysics(), // Prevent GridView from scrolling
        shrinkWrap: true, // Use only the space it needs
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: 2,
        ),
        itemBuilder: (context, index) {
          return DashboardCard(item: items[index]);
        },
      ),
    );
  }
}
