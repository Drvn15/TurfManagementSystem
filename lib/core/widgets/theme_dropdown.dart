import 'package:flutter/material.dart';
import 'theme_toggle.dart';

class ThemeDropdown extends StatelessWidget {
  const ThemeDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: ThemeSceneToggle(compact: true),
    );
  }
}
