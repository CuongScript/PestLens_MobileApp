import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:pest_lens_app/pages/error/no_internet_page.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  ConnectivityWrapperState createState() => ConnectivityWrapperState();
}

class ConnectivityWrapperState extends State<ConnectivityWrapper> {
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      setState(() {
        _isConnected = results.contains(ConnectivityResult.none) ? false : true;
      });
    });
  }

  void _showNoInternetPage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const NoInternetPage(),
        ),
      );
    });
  }

  void _hideNoInternetPage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isConnected) {
      _showNoInternetPage();
    } else {
      _hideNoInternetPage();
    }

    return widget.child;
  }
}