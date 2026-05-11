import 'package:flutter/material.dart';
import 'design_system.dart';

// Export must be at the top
export 'design_system.dart';
export 'theme_controller.dart';

// This class provides backward compatibility with old code
class AppTheme {
  // Map old color names to new design system
  static Color get purplePrimary => DesignSystem.primaryIndigo;
  static Color get purpleBackground => DesignSystem.backgroundLavender;
  static Color get purpleLight => DesignSystem.backgroundLight;
  static Color get purpleSecondary => DesignSystem.primaryIndigo;

  // Old theme getter
  static ThemeData get theme => DesignSystem.lightTheme;
  static ThemeData get lightTheme => DesignSystem.lightTheme;
  static ThemeData get darkTheme => DesignSystem.darkTheme;
}
