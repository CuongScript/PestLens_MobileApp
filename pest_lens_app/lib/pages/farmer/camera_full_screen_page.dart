import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CameraFullScreenPage extends StatefulWidget {
  final String url;
  final String? token;

  const CameraFullScreenPage({super.key, required this.url, this.token});

  @override
  _CameraFullScreenPageState createState() => _CameraFullScreenPageState();
}

class _CameraFullScreenPageState extends State<CameraFullScreenPage> {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      );

    if (widget.token != null) {
      _controller.setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(widget.url)) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      );
      _controller.loadRequest(
        Uri.parse(widget.url),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );
    } else {
      _controller.loadRequest(Uri.parse(widget.url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.close),
      ),
    );
  }
}
