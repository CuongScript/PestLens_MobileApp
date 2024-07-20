import 'package:flutter/material.dart';
import 'package:pest_lens_app/pages/farmer/camera_full_screen_page.dart';
import 'package:video_player/video_player.dart';

class MyCameraBox extends StatefulWidget {
  final String url;

  const MyCameraBox({super.key, required this.url});

  @override
  _MyCameraBoxState createState() => _MyCameraBoxState();
}

class _MyCameraBoxState extends State<MyCameraBox> {
  late VideoPlayerController _videoPlayerController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.url))
          ..initialize().then((_) {
            setState(() {
              _isInitialized = true;
              _videoPlayerController.play();
            });
          }).catchError((error) {
            print('Error initializing video player: $error');
          });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _goFullScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraFullScreenPage(
          controller: _videoPlayerController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Live Camera Feed',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.fullscreen),
                    onPressed: _goFullScreen,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
              child: _isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            _isInitialized
                ? VideoProgressIndicator(
                    _videoPlayerController,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                      backgroundColor: Colors.grey,
                      playedColor: Colors.blue,
                      bufferedColor: Colors.lightBlue,
                    ),
                  )
                : Container(),
            _isInitialized
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          _videoPlayerController.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        onPressed: () {
                          setState(() {
                            _videoPlayerController.value.isPlaying
                                ? _videoPlayerController.pause()
                                : _videoPlayerController.play();
                          });
                        },
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
