import 'package:flutter/material.dart';
import 'screens/logo_splash_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Turf Booking',
      home: LogoSplashPage(),
    );
  }
}
