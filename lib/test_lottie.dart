import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TestLottieScreen extends StatelessWidget {
  const TestLottieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lottie Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Test 1: Simple built-in animation
            const Text('Test 1: Built-in animation:'),
            const SizedBox(height: 10),
            Lottie.asset('assets/Final.json',
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.red,
                  child: Text('Error: $error'),
                );
              },
            ),

            const SizedBox(height: 20),

            // Test 2: Network animation (to verify Lottie works)
            const Text('Test 2: Network animation (if this works, Lottie is fine):'),
            const SizedBox(height: 10),
            Lottie.network(
              'https://lottie.host/8e2c8c0a-9c6c-4b3c-8f0d-8c9b0f6c1c3d/Animation.json',
              height: 100,
              errorBuilder: (context, error, stackTrace) {
                return Text('Network error: $error');
              },
            ),
          ],
        ),
      ),
    );
  }
}