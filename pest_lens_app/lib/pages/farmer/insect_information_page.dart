import 'package:flutter/material.dart';
import 'package:pest_lens_app/services/insect_information_service.dart';
import 'package:pest_lens_app/models/insect_information_model.dart';
import 'package:pest_lens_app/components/insect_card.dart';
import 'package:pest_lens_app/components/my_search_bar.dart';
import 'package:pest_lens_app/utils/insect_information_preferences.dart';
import 'package:http/http.dart' as http;

class InsectInformationPage extends StatefulWidget {
  const InsectInformationPage({super.key});

  @override
  _InsectInformationPageState createState() => _InsectInformationPageState();
}

class _InsectInformationPageState extends State<InsectInformationPage> {
  final InsectInformationService _service = InsectInformationService();
  List<InsectInformationModel> _insects = [];
  List<InsectInformationModel> _filteredInsects = [];
  bool _isLoading = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadInsects();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _loadInsects() async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool shouldFetch =
          await InsectInformationPreferences.shouldFetchInsects();

      if (shouldFetch) {
        await _fetchAndCacheInsects();
      } else {
        final cachedInsects = await InsectInformationPreferences.getInsects();
        if (cachedInsects != null && cachedInsects.isNotEmpty) {
          setState(() {
            _insects = cachedInsects;
            _filteredInsects = cachedInsects;
          });
        } else {
          await _fetchAndCacheInsects();
        }
      }
    } catch (e) {
      print('Error loading insects: $e');
      _showErrorSnackBar('Failed to load insects. Please try again later.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchAndCacheInsects() async {
    try {
      final insects = await _service.fetchInsectInformation();
      await InsectInformationPreferences.saveInsects(insects);
      setState(() {
        _insects = insects;
        _filteredInsects = insects;
      });
    } catch (e) {
      print('Error fetching and caching insects: $e');
      _showErrorSnackBar(
          'Failed to fetch insect data. Please check your internet connection and try again.');
    }
  }

  void _filterInsects(String query) {
    setState(() {
      _searchQuery = query;
      _filteredInsects = _insects
          .where((insect) =>
              insect.englishName.toLowerCase().contains(query.toLowerCase()) ||
              insect.vietnameseName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<List<String>> _getInsectImages(InsectInformationModel insect) async {
    List<String>? cachedImages =
        await InsectInformationPreferences.getInsectImages(insect.englishName);
    if (cachedImages != null && cachedImages.isNotEmpty) {
      return cachedImages;
    }

    try {
      List<String> fetchedImages =
          await _service.fetchInsectImages(insect.englishName);
      // Filter out invalid URLs
      fetchedImages =
          fetchedImages.where((url) => url.startsWith('http')).toList();
      await InsectInformationPreferences.saveInsectImages(
          insect.englishName, fetchedImages);
      return fetchedImages;
    } on http.ClientException catch (e) {
      print('Network error fetching images for ${insect.englishName}: $e');
      _showErrorSnackBar(
          'Network error: Failed to load images for ${insect.englishName}');
      return [];
    } catch (e) {
      print('Error fetching images for ${insect.englishName}: $e');
      _showErrorSnackBar('Failed to load images for ${insect.englishName}');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insect Information'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _fetchAndCacheInsects().then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Insect data refreshed')),
                );
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MySearchBar(
              onChanged: _filterInsects,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _filteredInsects.length,
                    itemBuilder: (context, index) {
                      final insect = _filteredInsects[index];
                      return FutureBuilder<List<String>>(
                        future: _getInsectImages(insect),
                        builder: (context, snapshot) {
                          String imagePath = '';
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            imagePath = snapshot.data!.first;
                          }
                          return InsectCard(
                            imagePath: imagePath,
                            insectName: insect.englishName,
                            onTap: () {
                              // TODO: Navigate to insect detail page
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
