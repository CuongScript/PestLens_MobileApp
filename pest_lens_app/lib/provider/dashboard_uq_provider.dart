import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:pest_lens_app/models/dashboard_item.dart';
import 'package:pest_lens_app/services/admin_service.dart';

class DashboardUQNotifier
    extends StateNotifier<AsyncValue<List<DashboardItem>>> {
  final AdminService _adminService;

  DashboardUQNotifier(this._adminService) : super(const AsyncValue.loading());

  Future<void> fetchDashboardData() async {
    try {
      state = const AsyncValue.loading();
      final users = await _adminService.fetchUsers();

      int activeUsers = 0;
      int newUsers = 0;
      int pendingUsers = 0;
      int inactiveUsers = 0;

      for (var user in users) {
        if (user['accountStatus'] == 'ACTIVE') activeUsers++;
        if (user['newUser'] == true) newUsers++;
        if (user['accountStatus'] == 'PENDING') pendingUsers++;
        if (user['accountStatus'] == 'DEACTIVATED') inactiveUsers++;
      }

      state = AsyncValue.data([
        DashboardItem('Active Users', activeUsers, Colors.green),
        DashboardItem('New Users', newUsers, Colors.blue),
        DashboardItem('Pending Users', pendingUsers, Colors.orange),
        DashboardItem('Deactivated Users', inactiveUsers, Colors.red),
      ]);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final dashboardUQProvider =
    StateNotifierProvider<DashboardUQNotifier, AsyncValue<List<DashboardItem>>>(
        (ref) {
  return DashboardUQNotifier(AdminService());
});
