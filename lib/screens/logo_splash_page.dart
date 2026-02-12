import 'package:flutter/material.dart';
import 'loading_page.dart';

class LogoSplashPage extends StatefulWidget {
  const LogoSplashPage({super.key});

  @override
  State<LogoSplashPage> createState() => _LogoSplashPageState();
}

class _LogoSplashPageState extends State<LogoSplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoadingPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B5F3C),
      body: Center(
        child: Image.asset(
          'assets/icon/app_icon.png',
          width: 140,
        ),
      ),
    );
  }
}
