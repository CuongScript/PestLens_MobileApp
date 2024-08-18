import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pest_lens_app/models/insect_information_model.dart';
import 'package:pest_lens_app/services/insect_information_service.dart';

final allInsectsProvider =
    FutureProvider<List<InsectInformationModel>>((ref) async {
  final insectService = InsectInformationService();
  return await insectService.fetchInsectInformation();
});

final filteredInsectsProvider = StateNotifierProvider<FilteredInsectsNotifier,
    AsyncValue<List<InsectInformationModel>>>((ref) {
  final allInsectsAsync = ref.watch(allInsectsProvider);
  return FilteredInsectsNotifier(allInsectsAsync);
});

class FilteredInsectsNotifier
    extends StateNotifier<AsyncValue<List<InsectInformationModel>>> {
  AsyncValue<List<InsectInformationModel>> _allInsects;

  FilteredInsectsNotifier(this._allInsects) : super(_allInsects);

  static const List<String> currentlySupportedInsects = [
    'Brown Plant Hopper',
    'Stem Borers',
    'Leaf Rollers',
    'Rice Asian Gall Midge',
    'Thrips',
  ];

  void updateAllInsects(AsyncValue<List<InsectInformationModel>> newInsects) {
    _allInsects = newInsects;
    state = _allInsects;
  }

  void filterInsects(String searchQuery, List<String> filters) {
    state = _allInsects.when(
      data: (insects) {
        if (searchQuery.isEmpty && filters.isEmpty) {
          return AsyncValue.data(insects);
        }

        final filteredInsects = insects.where((insect) {
          final matchesSearch = searchQuery.isEmpty ||
              insect.englishName
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              insect.vietnameseName
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());

          final matchesFilters = filters.isEmpty ||
              (filters.contains('Currently Supported') &&
                  currentlySupportedInsects.contains(insect.englishName)) ||
              (filters.contains('Future Supported') &&
                  !currentlySupportedInsects.contains(insect.englishName));

          return matchesSearch && matchesFilters;
        }).toList();

        return AsyncValue.data(filteredInsects);
      },
      loading: () => const AsyncValue.loading(),
      error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
    );
  }
}
