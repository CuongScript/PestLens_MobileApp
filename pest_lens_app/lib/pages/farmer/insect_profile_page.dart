import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/models/insect_information_model.dart';
import 'package:pest_lens_app/services/insect_information_service.dart';
import 'package:pest_lens_app/components/insect_image_showcase.dart';

class InsectProfilePage extends ConsumerStatefulWidget {
  final String insectName;

  const InsectProfilePage({Key? key, required this.insectName})
      : super(key: key);

  @override
  _InsectProfilePageState createState() => _InsectProfilePageState();
}

class _InsectProfilePageState extends ConsumerState<InsectProfilePage> {
  late Future<InsectInformationModel> _insectFuture;
  final InsectInformationService _service = InsectInformationService();

  @override
  void initState() {
    super.initState();
    _insectFuture = _service.fetchInsectDetails(widget.insectName);
  }

  Future<void> _refreshProfile() async {
    setState(() {
      _insectFuture = _service.fetchInsectDetails(widget.insectName);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Refreshing insect profile...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insect Profile'),
        backgroundColor: primaryBackgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshProfile,
          ),
        ],
      ),
      body: FutureBuilder<InsectInformationModel>(
        future: _insectFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          final insect = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InsectImageShowcase(imageUrls: insect.imageUrls),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        insect.englishName,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: fontTitleColor,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Scientific Name: ${insect.scientificName}',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Size',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: ': ${insect.size}'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildProfileSection('Habitat', insect.habit),
                      _buildProfileSection('Impact', insect.impact),
                      _buildProfileSection('Behavior', insect.behaviour),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: fontTitleColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        Divider(color: Colors.grey[300]),
        const SizedBox(height: 16),
      ],
    );
  }
}
