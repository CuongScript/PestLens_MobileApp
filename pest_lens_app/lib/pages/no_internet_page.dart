import 'package:flutter/material.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              'No internet connection!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please check your network',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your retry logic here
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
