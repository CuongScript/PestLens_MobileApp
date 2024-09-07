import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pest_lens_app/models/account_status_enum.dart';
import 'package:pest_lens_app/models/role_enum.dart';
import 'package:pest_lens_app/models/user_full_info_model.dart';
import 'package:pest_lens_app/provider/list_all_users_provider.dart';

final filteredUsersProvider = StateNotifierProvider<FilteredUsersNotifier,
    AsyncValue<List<UserFullInfoModel>>>((ref) {
  final allUsersAsync = ref.watch(allUsersProvider);
  return FilteredUsersNotifier(allUsersAsync);
});

class FilteredUsersNotifier
    extends StateNotifier<AsyncValue<List<UserFullInfoModel>>> {
  AsyncValue<List<UserFullInfoModel>> _allUsers;

  FilteredUsersNotifier(this._allUsers) : super(_allUsers);

  void updateAllUsers(AsyncValue<List<UserFullInfoModel>> newUsers) {
    _allUsers = newUsers;
    state = _allUsers;
  }

  void filterUsers(String searchQuery, List<String> filters) {
    state = _allUsers.when(
      data: (users) {
        if (searchQuery.isEmpty && filters.isEmpty) {
          return AsyncValue.data(users);
        }

        final filteredUsers = users.where((user) {
          final matchesSearch = searchQuery.isEmpty ||
              user.username.toLowerCase().contains(searchQuery.toLowerCase()) ||
              user.email.toLowerCase().contains(searchQuery.toLowerCase());
          final matchesFilters = filters.isEmpty ||
              filters.any((filter) {
                switch (filter) {
                  case 'Active Users':
                  case 'Người dùng đang hoạt động':
                    return user.accountStatus == AccountStatusEnum.ACTIVE;
                  case 'New Users':
                  case 'Người dùng mới':
                    return user.newUser;
                  case 'Pending Users':
                  case 'Người dùng đang chờ xử lý':
                    return user.accountStatus == AccountStatusEnum.PENDING;
                  case 'Deactivated Users':
                  case 'Người dùng đã hủy kích hoạt':
                    return user.accountStatus == AccountStatusEnum.DEACTIVATED;
                  case 'Farmer Users':
                  case 'Nông dân':
                    return user.roles.contains(Role.ROLE_USER);
                  case 'Admin Users':
                  case 'Quản trị viên':
                    return user.roles.contains(Role.ROLE_ADMIN);
                  default:
                    return false;
                }
              });
          return matchesSearch && matchesFilters;
        }).toList();

        print('Filtered users count: ${filteredUsers.length}');
        return AsyncValue.data(filteredUsers);
      },
      loading: () => const AsyncValue.loading(),
      error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
    );
  }
}
