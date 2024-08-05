import 'package:flutter_riverpod/flutter_riverpod.dart';

// StateNotifier to manage the touched index of the pie chart
class DashboardTouchNotifier extends StateNotifier<int> {
  DashboardTouchNotifier() : super(-1);

  // Method to update the touched index
  void updateIndex(int newIndex) {
    state = (state == newIndex) ? -1 : newIndex;
  }
}

// Provider for the touched index
final dashBoardTouchedIndexProvider =
    StateNotifierProvider<DashboardTouchNotifier, int>((ref) {
  return DashboardTouchNotifier();
});
