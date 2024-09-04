import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_back_button.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/models/insect_information_model.dart';
import 'package:pest_lens_app/services/insect_information_service.dart';
import 'package:pest_lens_app/components/insect_image_showcase.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      SnackBar(
          content: Text(AppLocalizations.of(context)!.refreshInsectProfile)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.insectProfile,
          style: CustomTextStyles.pageTitle2,
        ),
        backgroundColor: primaryBackgroundColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            icon: const MyBackButton(),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 30, color: fontTitleColor),
            iconSize: 40,
            onPressed: _refreshProfile,
          )
        ],
      ),
      body: FutureBuilder<InsectInformationModel>(
        future: _insectFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    '${AppLocalizations.of(context)!.error}: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text(AppLocalizations.of(context)!.noData));
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
                        '${AppLocalizations.of(context)!.scienceName}: ${insect.scientificName}',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: AppLocalizations.of(context)!.size,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: ': ${insect.size}'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildProfileSection(
                          AppLocalizations.of(context)!.habitat, insect.habit),
                      _buildProfileSection(
                          AppLocalizations.of(context)!.impact, insect.impact),
                      _buildProfileSection(
                          AppLocalizations.of(context)!.behavior,
                          insect.behaviour),
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
