import 'package:flutter/material.dart';

class MyUserAccountFilterButton extends StatefulWidget {
  final List<String> selectedFilters;
  final ValueChanged<List<String>> onFilterChanged;

  const MyUserAccountFilterButton({
    super.key,
    required this.selectedFilters,
    required this.onFilterChanged,
  });

  @override
  _MyUserAccountFilterButtonState createState() =>
      _MyUserAccountFilterButtonState();
}

class _MyUserAccountFilterButtonState extends State<MyUserAccountFilterButton> {
  final List<String> _filterOptions = [
    'Active Users',
    'New Users',
    'Pending Users',
    'Deactivated Users',
    'Farmer Users',
    'Admin Users',
  ];

  void _toggleFilter(String filter) {
    setState(() {
      if (widget.selectedFilters.contains(filter)) {
        widget.selectedFilters.remove(filter);
      } else {
        widget.selectedFilters.add(filter);
      }
    });
    widget.onFilterChanged(widget.selectedFilters);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: _toggleFilter,
      itemBuilder: (context) => _filterOptions
          .map((filter) => CheckedPopupMenuItem<String>(
                value: filter,
                checked: widget.selectedFilters.contains(filter),
                child: Text(filter),
              ))
          .toList(),
      icon: const Icon(Icons.filter_list, color: Colors.grey),
    );
  }
}
