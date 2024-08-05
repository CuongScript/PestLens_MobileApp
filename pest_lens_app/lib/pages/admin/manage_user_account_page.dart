import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/components/my_search_bar.dart';
import 'package:pest_lens_app/components/my_user_account_filter_button.dart';
import 'package:pest_lens_app/components/user_brief_info_row.dart';
import 'package:pest_lens_app/provider/list_all_users_provider.dart';

class ManageUserAccountPage extends ConsumerStatefulWidget {
  const ManageUserAccountPage({super.key});

  @override
  ConsumerState<ManageUserAccountPage> createState() =>
      _ManageUserAccountPageState();
}

class _ManageUserAccountPageState extends ConsumerState<ManageUserAccountPage> {
  final List<String> _selectedFilters = [];

  void _handleFilterChanged(List<String> filters) {
    setState(() {
      _selectedFilters.clear();
      _selectedFilters.addAll(filters); // Add new filters
    });
  }

  void _removeFilter(String filter) {
    setState(() {
      _selectedFilters.remove(filter);
    });
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(allUsersProvider);

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
                      onChanged: (value) {
                        // Handle search logic here
                        print("Search text: $value");
                      },
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
              child: usersAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
                data: (users) => ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return UserBriefInfoRow(user: user);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
