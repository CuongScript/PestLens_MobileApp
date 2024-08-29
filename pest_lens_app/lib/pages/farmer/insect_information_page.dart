import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/models/insect_information_model.dart';
import 'package:pest_lens_app/components/insect_card.dart';
import 'package:pest_lens_app/components/my_search_bar.dart';
import 'package:pest_lens_app/components/my_filter_button.dart';
import 'package:pest_lens_app/pages/farmer/insect_profile_page.dart';
import 'package:pest_lens_app/provider/filtered_insects_provider.dart';
import 'package:pest_lens_app/services/insect_information_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InsectInformationPage extends ConsumerStatefulWidget {
  const InsectInformationPage({Key? key}) : super(key: key);

  @override
  _InsectInformationPageState createState() => _InsectInformationPageState();
}

class _InsectInformationPageState extends ConsumerState<InsectInformationPage> {
  final InsectInformationService _service = InsectInformationService();
  String _searchQuery = '';
  List<String> _selectedFilters = [];

  final Map<String, List<String>> _filterGroups = {
    'Support Status': [
      'Currently Supported',
      'Future Supported',
    ],
  };

  @override
  void initState() {
    super.initState();
  }

  // void _showErrorSnackBar(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //       backgroundColor: Colors.red,
  //       duration: const Duration(seconds: 3),
  //     ),
  //   );
  // }

  void _handleFilterChanged(List<String> filters) {
    setState(() {
      _selectedFilters = filters;
    });
    _applyFilters();
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  void _applyFilters() {
    ref
        .read(filteredInsectsProvider.notifier)
        .filterInsects(_searchQuery, _selectedFilters);
  }

  void _removeFilter(String filter) {
    setState(() {
      _selectedFilters.remove(filter);
    });
    _applyFilters();
  }

  Future<String> _getInsectImage(InsectInformationModel insect) async {
    try {
      final images = await _service.fetchInsectImages(insect.englishName);
      return images.isNotEmpty ? images.first : '';
    } catch (e) {
      // print(
      //     '${AppLocalizations.of(context)!.errorFetchImg} ${insect.englishName}: $e');
      // _showErrorSnackBar(
      //     '${AppLocalizations.of(context)!.errorLoadImg} ${insect.englishName}');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<InsectInformationModel>> filteredInsects =
        ref.watch(filteredInsectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.insectInfo,
          style: CustomTextStyles.pageTitle,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 30, color: fontTitleColor),
            iconSize: 40,
            onPressed: () {
              ref.refresh(allInsectsProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        AppLocalizations.of(context)!.insectDataRefreshed)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: MySearchBar(
                    onChanged: _handleSearch,
                    hintText: AppLocalizations.of(context)!.searchInsect,
                  ),
                ),
                const SizedBox(width: 8),
                MyFilterButton(
                  selectedFilters: _selectedFilters,
                  onFilterChanged: _handleFilterChanged,
                  filterGroups: _filterGroups,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Wrap(
              spacing: 8,
              children: _selectedFilters
                  .map((filter) => Chip(
                        label: Text(filter),
                        onDeleted: () => _removeFilter(filter),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: filteredInsects.when(
              data: (insects) => GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: insects.length,
                itemBuilder: (context, index) {
                  final insect = insects[index];
                  return FutureBuilder<String>(
                    future: _getInsectImage(insect),
                    builder: (context, snapshot) {
                      String imagePath = snapshot.data ?? '';
                      return InsectCard(
                        imagePath: imagePath,
                        insectName: insect.englishName,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => InsectProfilePage(
                                  insectName: insect.englishName),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) {
                return Center(
                    child: Text(AppLocalizations.of(context)!.errorLoadInsect));
              },
            ),
          ),
        ],
      ),
    );
  }
}
