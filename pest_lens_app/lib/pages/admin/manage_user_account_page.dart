import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_slidable.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/components/my_search_bar.dart';
import 'package:pest_lens_app/components/my_user_account_filter_button.dart';
import 'package:pest_lens_app/pages/common/user_profile_detail_page.dart';
import 'package:pest_lens_app/provider/filtered_users_provider.dart';
import 'package:pest_lens_app/provider/list_all_users_provider.dart';
import 'package:pest_lens_app/models/user_full_info_model.dart';
import 'package:pest_lens_app/services/admin_service.dart';

class ManageUserAccountPage extends ConsumerStatefulWidget {
  const ManageUserAccountPage({super.key});

  @override
  ConsumerState<ManageUserAccountPage> createState() =>
      _ManageUserAccountPageState();
}

class _ManageUserAccountPageState extends ConsumerState<ManageUserAccountPage> {
  final List<String> _selectedFilters = [];
  String _searchQuery = '';
  final AdminService _adminService = AdminService();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(allUsersProvider.notifier).fetchAllUsers();
    });
  }

  void _handleFilterChanged(List<String> filters) {
    setState(() {
      _selectedFilters.clear();
      _selectedFilters.addAll(filters);
    });
    _applyFilters();
  }

  void _removeFilter(String filter) {
    setState(() {
      _selectedFilters.remove(filter);
    });
    _applyFilters();
  }

  void _handleSearch(String value) {
    setState(() {
      _searchQuery = value;
    });
    _applyFilters();
  }

  void _applyFilters() {
    ref
        .read(filteredUsersProvider.notifier)
        .filterUsers(_searchQuery, _selectedFilters);
  }

  Future<void> _handleUserStatusChange(
      UserFullInfoModel user, bool activate) async {
    try {
      bool success;
      if (activate) {
        success = await _adminService.activateUser(user.username);
      } else {
        success = await _adminService.deactivateUser(user.username);
      }

      if (success) {
        // Refresh the user list
        await ref.read(allUsersProvider.notifier).fetchAllUsers();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User status updated successfully')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update user status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsersAsync = ref.watch(filteredUsersProvider);

    // Update filtered users when all users change
    ref.listen<AsyncValue<List<UserFullInfoModel>>>(allUsersProvider,
        (_, next) {
      ref.read(filteredUsersProvider.notifier).updateAllUsers(next);
    });

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        title: const Text('User Accounts', style: CustomTextStyles.pageTitle),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: MySearchBar(
                      onChanged: _handleSearch,
                    ),
                  ),
                  const SizedBox(width: 8),
                  MyUserAccountFilterButton(
                    selectedFilters: List.from(_selectedFilters),
                    onFilterChanged: _handleFilterChanged,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 4,
                children: _selectedFilters
                    .map((filter) => Chip(
                          label: Text(filter),
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: () => _removeFilter(filter),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            Expanded(
              child: filteredUsersAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
                data: (users) {
                  if (users.isEmpty) {
                    return const Center(child: Text('No users found'));
                  }
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return MySlidable(
                        user: user,
                        onStatusChange: _handleUserStatusChange,
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserProfileDetailPage(
                                      user: user,
                                      onStatusChange: _handleUserStatusChange,
                                    )),
                          );
                          if (result == true) {
                            // Refresh the user list if changes were made
                            ref.read(allUsersProvider.notifier).fetchAllUsers();
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
