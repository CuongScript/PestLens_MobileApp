import 'package:flutter/material.dart';

class LanguageSelectionDropdown extends StatefulWidget {
  const LanguageSelectionDropdown({super.key});

  @override
  State<LanguageSelectionDropdown> createState() =>
      _LanguageSelectionDropdownState();
}

class _LanguageSelectionDropdownState extends State<LanguageSelectionDropdown> {
  String? _selectedLanguage = 'EN';
  final Map<String, String> _languages = {
    'EN': 'lib/assets/images/Flag_of_the_United_Kingdom.png',
    'VI': 'lib/assets/images/Flag_of_Vietnam.png',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLanguage,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
          style: const TextStyle(color: Colors.black, fontSize: 16),
          onChanged: (String? newValue) {
            setState(() {
              _selectedLanguage = newValue;
            });
          },
          items: _languages.entries.map<DropdownMenuItem<String>>((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Row(
                children: [
                  Image.asset(entry.value, width: 24, height: 24),
                  const SizedBox(width: 8),
                  Text(entry.key),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
