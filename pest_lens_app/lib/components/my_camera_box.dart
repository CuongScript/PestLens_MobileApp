import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:pest_lens_app/pages/farmer/camera_full_screen_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyCameraBox extends StatefulWidget {
  final String url;
  final String title;
  final String? token;

  const MyCameraBox({
    super.key,
    required this.url,
    required this.title,
    this.token,
  });

  @override
  _MyCameraBoxState createState() => _MyCameraBoxState();
}

class _MyCameraBoxState extends State<MyCameraBox> {
  late WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  Timer? _loadingTimer;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color.fromARGB(0, 255, 255, 255))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            _startLoadingTimer();
            _safeSetState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (String url) {
            _cancelLoadingTimer();
            _safeSetState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            _cancelLoadingTimer();
            _safeSetState(() {
              _hasError = true;
              _isLoading = false;
              _errorMessage = '${error.errorCode}: ${error.description}';
            });
          },
        ),
      );

    _loadHtmlContent();
  }

  void _loadHtmlContent() {
    final String htmlContent = '''
      <html>
        <body style="margin:0;padding:0;">
          <div style="width:100%;height:100%;">
            <iframe width="100%" height="100%" src="${widget.url}" frameborder="0" allowfullscreen></iframe>
            <p align="right" style="margin:0;padding:5px;">powered by <a href="https://rtsp.me" title="RTSP.ME - Free website RTSP video steaming service" target="_blank">rtsp.me</a></p>
          </div>
        </body>
      </html>
    ''';

    _controller.loadHtmlString(htmlContent);
  }

  void _startLoadingTimer() {
    _loadingTimer = Timer(const Duration(seconds: 10), () {
      _safeSetState(() {
        if (_isLoading) {
          _hasError = true;
          _isLoading = false;
          _errorMessage = 'Loading timed out after 10 seconds';
        }
      });
    });
  }

  void _cancelLoadingTimer() {
    _loadingTimer?.cancel();
    _loadingTimer = null;
  }

  void _safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  void _retry() {
    _safeSetState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });
    _loadHtmlContent();
  }

  void _goFullScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraFullScreenPage(
          url: widget.url,
          token: widget.token,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cancelLoadingTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
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
                Text(
                  widget.title,
                  style: const TextStyle(
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
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  if (!_hasError) WebViewWidget(controller: _controller),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  if (_hasError)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Camera not Available',
                              style: CustomTextStyles.cameraErrorMessage),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _retry,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
