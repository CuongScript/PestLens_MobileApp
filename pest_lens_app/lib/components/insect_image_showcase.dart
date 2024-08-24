import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InsectImageShowcase extends StatefulWidget {
  final List<String> imageUrls;

  const InsectImageShowcase({super.key, required this.imageUrls});

  @override
  _InsectImageShowcaseState createState() => _InsectImageShowcaseState();
}

class _InsectImageShowcaseState extends State<InsectImageShowcase> {
  int _currentIndex = 0;
  late List<bool> _validImages;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _validImages = List.filled(widget.imageUrls.length, true);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _markImageAsInvalid(int index) {
    setState(() {
      _validImages[index] = false;
      _updateCurrentIndex();
    });
  }

  void _updateCurrentIndex() {
    if (!_validImages[_currentIndex]) {
      int newIndex = _validImages.indexWhere((isValid) => isValid);
      if (newIndex != -1) {
        _currentIndex = newIndex;
      }
    }
  }

  List<int> get _validIndices =>
      List.generate(widget.imageUrls.length, (index) => index)
          .where((index) => _validImages[index])
          .toList();

  @override
  Widget build(BuildContext context) {
    if (_validIndices.isEmpty) {
      return Container(
        height: 200,
        color: Colors.grey[300],
        child: Center(
          child: Text(AppLocalizations.of(context)!.noImg),
        ),
      );
    }

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: _validIndices.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = _validIndices[index];
                  });
                },
                itemBuilder: (context, index) {
                  int imageIndex = _validIndices[index];
                  return CachedNetworkImage(
                    imageUrl: widget.imageUrls[imageIndex],
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _markImageAsInvalid(imageIndex);
                      });
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.error, color: Colors.red),
                        ),
                      );
                    },
                    progressIndicatorBuilder: (context, url, downloadProgress) {
                      return Center(
                        child: CircularProgressIndicator(
                          value: downloadProgress.progress,
                        ),
                      );
                    },
                  );
                },
              ),
              Positioned(
                bottom: 8.0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _validIndices.map((index) {
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index
                            ? fontTitleColor
                            : Colors.grey.withOpacity(0.5),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _validIndices.length,
            itemBuilder: (context, index) {
              int imageIndex = _validIndices[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = imageIndex;
                  });
                  // Animate to the selected page
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _currentIndex == imageIndex
                          ? fontTitleColor
                          : Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrls[imageIndex],
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.error, color: Colors.red),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
