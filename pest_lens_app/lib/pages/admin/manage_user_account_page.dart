import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/components/my_search_bar.dart';
import 'package:pest_lens_app/components/my_user_account_filter_button.dart';
import 'package:pest_lens_app/dummy/user_dummy_data.dart';
import 'package:pest_lens_app/components/user_brief_info_row.dart';

class ManageUserAccountPage extends StatefulWidget {
  const ManageUserAccountPage({super.key});

  @override
  _ManageUserAccountPageState createState() => _ManageUserAccountPageState();
}

class _ManageUserAccountPageState extends State<ManageUserAccountPage> {
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
                    .toList(), // display filter list
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: dummyUsers.length,
                itemBuilder: (context, index) {
                  final user = dummyUsers[index];
                  return UserBriefInfoRow(user: user);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
