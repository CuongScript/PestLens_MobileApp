import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pest_lens_app/models/dashboard_item.dart';
import 'package:pest_lens_app/provider/dashboard_touch_provider.dart';

class DashboardCard extends ConsumerWidget {
  final DashboardItem item;
  final int index;

  const DashboardCard({super.key, required this.item, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final touchedIndex = ref.watch(dashBoardTouchedIndexProvider);

    return Card(
      color: index == touchedIndex
          ? Colors.grey[300]
          : Colors.white, // Highlight if selected
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Color(0xFF0064c3),
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow
                      .ellipsis, // Prevents overflow by showing ellipsis
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                item.count.toString(),
                style: const TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow:
                    TextOverflow.ellipsis, // Apply ellipsis here too if needed
              ),
            ],
          ),
        ),
      ),
    );
  }
}
