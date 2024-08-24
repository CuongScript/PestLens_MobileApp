import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pest_lens_app/provider/language_provider.dart'; // Ensure this points correctly

class LanguageSelectionDropdown extends ConsumerWidget {
  const LanguageSelectionDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? selectedLanguage = ref.watch(localeProvider).languageCode;

    Map<String, String> languageMap = {
      'en': 'lib/assets/images/Flag_of_the_United_Kingdom.png',
      'vi': 'lib/assets/images/Flag_of_Vietnam.png',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedLanguage,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
          style: const TextStyle(color: Colors.black, fontSize: 16),
          onChanged: (String? newValue) {
            if (newValue != null) {
              ref.read(localeProvider.notifier).setLocale(newValue);
            }
          },
          items: languageMap.entries.map<DropdownMenuItem<String>>((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    entry.value,
                    width: 24,
                    height: 24,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error); // Show an error icon if the image fails to load
                    }
                  ),
                  const SizedBox(width: 8),
                  Flexible( // Ensures text does not overflow
                    child: Text(entry.key.toUpperCase(), overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
