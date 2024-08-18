import 'package:flutter/material.dart';

class MyFilterButton extends StatefulWidget {
  final List<String> selectedFilters;
  final ValueChanged<List<String>> onFilterChanged;
  final Map<String, List<String>> filterGroups;

  const MyFilterButton({
    Key? key,
    required this.selectedFilters,
    required this.onFilterChanged,
    required this.filterGroups,
  }) : super(key: key);

  @override
  _MyFilterButtonState createState() => _MyFilterButtonState();
}

class _MyFilterButtonState extends State<MyFilterButton> {
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
      itemBuilder: (context) {
        return widget.filterGroups.entries.expand((group) {
          final List<PopupMenuEntry<String>> items = [
            PopupMenuItem<String>(
              enabled: false,
              child: Text(
                group.key,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ...group.value.map((filter) => CheckedPopupMenuItem<String>(
                  value: filter,
                  checked: widget.selectedFilters.contains(filter),
                  child: Text(filter),
                )),
            const PopupMenuDivider(),
          ];
          return items;
        }).toList()
          ..removeLast(); // Remove the last divider
      },
      icon: const Icon(Icons.filter_list, color: Colors.grey),
    );
  }
}
