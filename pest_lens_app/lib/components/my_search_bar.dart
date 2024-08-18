import 'package:flutter/material.dart';

class MySearchBar extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String hintText;

  const MySearchBar({
    super.key,
    this.onChanged,
    this.hintText = 'Search',
  });

  @override
  _MySearchBarState createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.25),
      borderRadius: BorderRadius.circular(8),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {}); // Update to hide the clear button
                    widget.onChanged?.call(''); // Notify parent widget
                  },
                )
              : null,
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
        onChanged: (value) {
          setState(() {}); // Update to show or hide the clear button
          widget.onChanged?.call(value); // Notify parent widget
        },
      ),
    );
  }
}
