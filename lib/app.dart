import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/logo_splash_page.dart';
import 'screens/landing_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Turf Booking',

      // TEMPORARY: start with login
      home: const LoginScreen(),

      routes: {
        "/login": (context) => const LoginScreen(),
        "/landing": (context) => const LandingPage(),
        "/splash": (context) => const LogoSplashPage(),
      },
    );
  }
}
