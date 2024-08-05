import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pest_lens_app/models/user_full_info_model.dart';
import 'package:pest_lens_app/services/admin_service.dart';

class AllUsersNotifier
    extends StateNotifier<AsyncValue<List<UserFullInfoModel>>> {
  final AdminService _adminService;

  AllUsersNotifier(this._adminService) : super(const AsyncValue.loading()) {
    fetchAllUsers();
  }

  Future<void> fetchAllUsers() async {
    try {
      state = const AsyncValue.loading();
      final usersJson = await _adminService.fetchUsers();
      developer.log('Received JSON: ${usersJson.toString()}');
      final users = usersJson.map((json) {
        try {
          return UserFullInfoModel.fromJson(json);
        } catch (e) {
          developer.log('Error parsing user: $json', error: e);
          rethrow;
        }
      }).toList();
      state = AsyncValue.data(users);
    } catch (e, stackTrace) {
      developer.log('Error fetching users', error: e, stackTrace: stackTrace);
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final allUsersProvider = StateNotifierProvider<AllUsersNotifier,
    AsyncValue<List<UserFullInfoModel>>>((ref) {
  final adminService = AdminService();
  return AllUsersNotifier(adminService);
});
