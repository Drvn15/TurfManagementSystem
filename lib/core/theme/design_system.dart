import 'package:flutter/material.dart';

// 🎯 CENTRALIZED DESIGN SYSTEM
// All design decisions in one place - Single source of truth

class DesignSystem {
  // ==================== COLORS ====================
  // Primary Palette
  static const Color primaryIndigo = Color(0xFF0C0E68);
  static const Color primaryLight = Color(0xFF3A3E8F);
  static const Color primaryDark = Color(0xFF07094A);

  // Background Palette
  static const Color backgroundLavender = Color(0xFFDADBFA);
  static const Color backgroundLight = Color(0xFFEFF0FF);
  static const Color backgroundWhite = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF0C0E68);
  static const Color textSecondary = Color(0xFF5A5A7A);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textLight = Color(0xFF8A8AA3);

  // Semantic Colors
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFED6C02);
  static const Color info = Color(0xFF0288D1);

  // UI Element Colors
  static const Color borderLight = Color(0xFFE0E0F0);
  static const Color borderFocus = primaryIndigo;
  static const Color shadowColor = Color(0xFF0C0E68);
  static const Color overlayLight = Color(0x1A0C0E68);
  static const Color overlayMedium = Color(0x330C0E68);

  // Gradient Definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryIndigo,
      primaryLight,
    ],
  );

  static const LinearGradient lavenderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      backgroundLavender,
      backgroundLight,
    ],
  );

  // ==================== TYPOGRAPHY ====================
  // Font Families
  static const String fontFamilyPrimary = 'Poppins';
  static const String fontFamilySecondary = 'Inter';

  // Font Sizes
  static const double fontSizeDisplay1 = 34;
  static const double fontSizeDisplay2 = 28;
  static const double fontSizeH1 = 32;
  static const double fontSizeH2 = 28;
  static const double fontSizeH3 = 24;
  static const double fontSizeH4 = 20;
  static const double fontSizeH5 = 18;
  static const double fontSizeH6 = 16;
  static const double fontSizeBodyLarge = 16;
  static const double fontSizeBodyMedium = 14;
  static const double fontSizeBodySmall = 12;
  static const double fontSizeCaption = 12;
  static const double fontSizeButton = 16;
  static const double fontSizeOverline = 10;

  // Font Weights
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  // Letter Spacing
  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0;
  static const double letterSpacingWide = 0.5;

  // Line Heights
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.8;

  // Text Styles - Predefined
  static const TextStyle displayLarge = TextStyle(
    fontSize: fontSizeDisplay1,
    fontWeight: fontWeightBold,
    color: textPrimary,
    letterSpacing: letterSpacingTight,
    height: lineHeightTight,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: fontSizeDisplay2,
    fontWeight: fontWeightBold,
    color: textPrimary,
    letterSpacing: letterSpacingTight,
    height: lineHeightTight,
  );

  static const TextStyle headline1 = TextStyle(
    fontSize: fontSizeH1,
    fontWeight: fontWeightBold,
    color: textPrimary,
    height: lineHeightTight,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: fontSizeH2,
    fontWeight: fontWeightSemiBold,
    color: textPrimary,
    height: lineHeightTight,
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: fontSizeH3,
    fontWeight: fontWeightSemiBold,
    color: textPrimary,
    height: lineHeightTight,
  );

  static const TextStyle headline4 = TextStyle(
    fontSize: fontSizeH4,
    fontWeight: fontWeightMedium,
    color: textPrimary,
    height: lineHeightTight,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: fontSizeBodyLarge,
    fontWeight: fontWeightRegular,
    color: textPrimary,
    height: lineHeightNormal,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: fontSizeBodyMedium,
    fontWeight: fontWeightRegular,
    color: textSecondary,
    height: lineHeightNormal,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: fontSizeBodySmall,
    fontWeight: fontWeightRegular,
    color: textLight,
    height: lineHeightNormal,
  );

  static const TextStyle button = TextStyle(
    fontSize: fontSizeButton,
    fontWeight: fontWeightMedium,
    color: textWhite,
    height: lineHeightTight,
  );

  static const TextStyle caption = TextStyle(
    fontSize: fontSizeCaption,
    fontWeight: fontWeightRegular,
    color: textLight,
    height: lineHeightNormal,
  );

  // ==================== SPACING ====================
  static const double spacing2 = 2;
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;
  static const double spacing40 = 40;
  static const double spacing48 = 48;
  static const double spacing56 = 56;
  static const double spacing64 = 64;
  static const double spacing80 = 80;
  static const double spacing96 = 96;

  // Padding shortcuts
  static const EdgeInsets paddingAll4 = EdgeInsets.all(spacing4);
  static const EdgeInsets paddingAll8 = EdgeInsets.all(spacing8);
  static const EdgeInsets paddingAll12 = EdgeInsets.all(spacing12);
  static const EdgeInsets paddingAll16 = EdgeInsets.all(spacing16);
  static const EdgeInsets paddingAll24 = EdgeInsets.all(spacing24);
  static const EdgeInsets paddingAll32 = EdgeInsets.all(spacing32);

  static const EdgeInsets paddingHorizontal16 = EdgeInsets.symmetric(horizontal: spacing16);
  static const EdgeInsets paddingHorizontal24 = EdgeInsets.symmetric(horizontal: spacing24);
  static const EdgeInsets paddingVertical8 = EdgeInsets.symmetric(vertical: spacing8);
  static const EdgeInsets paddingVertical16 = EdgeInsets.symmetric(vertical: spacing16);
  static const EdgeInsets paddingVertical24 = EdgeInsets.symmetric(vertical: spacing24);

  // Margin shortcuts
  static const EdgeInsets marginAll16 = EdgeInsets.all(spacing16);
  static const EdgeInsets marginAll24 = EdgeInsets.all(spacing24);
  static const EdgeInsets marginBottom16 = EdgeInsets.only(bottom: spacing16);
  static const EdgeInsets marginBottom24 = EdgeInsets.only(bottom: spacing24);

  // Gap sizing
  static const SizedBox gap4 = SizedBox(height: spacing4, width: spacing4);
  static const SizedBox gap8 = SizedBox(height: spacing8, width: spacing8);
  static const SizedBox gap12 = SizedBox(height: spacing12, width: spacing12);
  static const SizedBox gap16 = SizedBox(height: spacing16, width: spacing16);
  static const SizedBox gap24 = SizedBox(height: spacing24, width: spacing24);
  static const SizedBox gap32 = SizedBox(height: spacing32, width: spacing32);

  // ==================== BORDER RADIUS ====================
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusXLarge = 20;
  static const double radiusRound = 100;

  static BorderRadius get borderRadiusSmall => BorderRadius.circular(radiusSmall);
  static BorderRadius get borderRadiusMedium => BorderRadius.circular(radiusMedium);
  static BorderRadius get borderRadiusLarge => BorderRadius.circular(radiusLarge);
  static BorderRadius get borderRadiusXLarge => BorderRadius.circular(radiusXLarge);
  static BorderRadius get borderRadiusRound => BorderRadius.circular(radiusRound);

  // Border radius shortcuts
  static const RoundedRectangleBorder cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(radiusXLarge)),
  );

  static const RoundedRectangleBorder buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(radiusLarge)),
  );

  static const RoundedRectangleBorder inputShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(radiusMedium)),
  );

  // ==================== BORDERS ====================
  static Border borderLightBorder = Border.all(
    color: borderLight,
    width: 1,
  );

  static Border borderFocusBorder = Border.all(
    color: borderFocus,
    width: 2,
  );

  static Border borderErrorBorder = Border.all(
    color: error,
    width: 1,
  );

  static const UnderlineInputBorder underlineBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: primaryIndigo, width: 1),
  );

  // ==================== SHADOWS ====================
  static List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: shadowColor.withOpacity(0.05),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: shadowColor.withOpacity(0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: shadowColor.withOpacity(0.12),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  // ==================== DECORATIONS ====================
  static BoxDecoration cardDecoration = BoxDecoration(
    color: backgroundLavender,
    borderRadius: borderRadiusXLarge,
    boxShadow: shadowMedium,
  );

  static BoxDecoration lavenderCardDecoration = BoxDecoration(
    color: backgroundLavender,
    borderRadius: borderRadiusXLarge,
  );

  static BoxDecoration whiteCardDecoration = BoxDecoration(
    color: backgroundWhite,
    borderRadius: borderRadiusLarge,
    boxShadow: shadowSmall,
  );

  static BoxDecoration primaryButtonDecoration = BoxDecoration(
    color: primaryIndigo,
    borderRadius: borderRadiusLarge,
    boxShadow: shadowSmall,
  );

  static BoxDecoration inputDecoration = BoxDecoration(
    color: backgroundWhite,
    borderRadius: borderRadiusMedium,
    border: borderLightBorder,
  );

  static BoxDecoration inputFocusDecoration = BoxDecoration(
    color: backgroundWhite,
    borderRadius: borderRadiusMedium,
    border: borderFocusBorder,
  );

  static BoxDecoration circularIconDecoration = BoxDecoration(
    color: backgroundLavender,
    shape: BoxShape.circle,
    border: Border.all(color: primaryIndigo),
  );

  // ==================== DURATIONS ====================
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration animationPage = Duration(milliseconds: 400);

  // ==================== OPACITIES ====================
  static const double opacityDisabled = 0.38;
  static const double opacityHint = 0.6;
  static const double opacityOverlayLight = 0.1;
  static const double opacityOverlayMedium = 0.2;
  static const double opacityOverlayHeavy = 0.3;

  // ==================== ELEVATIONS ====================
  static const double elevation0 = 0;
  static const double elevation1 = 1;
  static const double elevation2 = 2;
  static const double elevation4 = 4;
  static const double elevation8 = 8;

  // ==================== ICON SIZES ====================
  static const double iconSmall = 16;
  static const double iconMedium = 24;
  static const double iconLarge = 32;
  static const double iconXLarge = 48;

  // ==================== THEME DATA ====================
  static ThemeData get theme {
    return ThemeData(
      colorScheme: const ColorScheme(
        primary: primaryIndigo,
        secondary: primaryIndigo,
        surface: backgroundLavender,
        error: error,
        onPrimary: textWhite,
        onSecondary: textWhite,
        onSurface: textPrimary,
        onError: textWhite,
        brightness: Brightness.light,
      ),

      primaryColor: primaryIndigo,
      scaffoldBackgroundColor: backgroundLavender,

      fontFamily: fontFamilyPrimary,

      textTheme: const TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        headlineLarge: headline1,
        headlineMedium: headline2,
        headlineSmall: headline3,
        titleLarge: headline4,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: button,
        labelSmall: caption,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundLavender,
        foregroundColor: textPrimary,
        elevation: elevation0,
        centerTitle: false,
        titleTextStyle: headline4,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryIndigo,
          foregroundColor: textWhite,
          minimumSize: const Size(double.infinity, spacing56),
          shape: buttonShape,
          textStyle: button,
          elevation: elevation0,
          padding: paddingHorizontal24,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryIndigo,
          side: const BorderSide(color: primaryIndigo, width: 2),
          minimumSize: const Size(double.infinity, spacing56),
          shape: buttonShape,
          textStyle: button.copyWith(color: primaryIndigo),
          padding: paddingHorizontal24,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryIndigo,
          textStyle: button.copyWith(color: primaryIndigo),
          padding: paddingHorizontal16,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundWhite,
        contentPadding: paddingAll16,
        border: OutlineInputBorder(
          borderRadius: borderRadiusMedium,
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadiusMedium,
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadiusMedium,
          borderSide: const BorderSide(color: borderFocus, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadiusMedium,
          borderSide: const BorderSide(color: error),
        ),
        labelStyle: const TextStyle(
          color: textSecondary,
          fontSize: fontSizeBodyMedium,
        ),
        hintStyle: TextStyle(
          color: textLight.withOpacity(opacityHint),
          fontSize: fontSizeBodyMedium,
        ),
      ),

      cardTheme: CardThemeData(
        color: backgroundLavender,
        elevation: elevation2,
        shadowColor: shadowColor.withOpacity(0.1),
        shape: cardShape,
        margin: marginAll16,
      ),

      dividerTheme: const DividerThemeData(
        color: primaryIndigo,
        thickness: 1,
        space: spacing24,
        indent: spacing16,
        endIndent: spacing16,
      ),

      iconTheme: const IconThemeData(
        color: primaryIndigo,
        size: iconMedium,
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryIndigo,
        linearTrackColor: backgroundLavender,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: backgroundLavender,
        selectedItemColor: primaryIndigo,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: elevation0,
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryIndigo;
          }
          return backgroundWhite;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryIndigo;
          }
          return backgroundWhite;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryIndigo.withOpacity(0.5);
          }
          return textSecondary.withOpacity(0.3);
        }),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryIndigo,
        foregroundColor: textWhite,
        shape: CircleBorder(),
        elevation: elevation0,
      ),

      listTileTheme: const ListTileThemeData(
        iconColor: primaryIndigo,
        textColor: textPrimary,
        tileColor: backgroundLavender,
        contentPadding: paddingHorizontal16,
      ),
    );
  }
}

// ==================== BACKWARD COMPATIBILITY ====================
// These allow old code using AppTheme.purplePrimary to still work

// Old color names mapped to new design system
extension OldAppTheme on DesignSystem {
  static Color get purplePrimary => DesignSystem.primaryIndigo;
  static Color get purpleBackground => DesignSystem.backgroundLavender;
  static Color get purpleLight => DesignSystem.backgroundLight;
  static Color get purpleSecondary => DesignSystem.primaryIndigo;
}

// ==================== EXTENSION FOR EASY ACCESS ====================
extension DesignSystemExtension on BuildContext {
  // Colors
  Color get primaryIndigo => DesignSystem.primaryIndigo;
  Color get backgroundLavender => DesignSystem.backgroundLavender;
  Color get textPrimary => DesignSystem.textPrimary;
  Color get textSecondary => DesignSystem.textSecondary;

  // Spacing
  double get spacing8 => DesignSystem.spacing8;
  double get spacing16 => DesignSystem.spacing16;
  double get spacing24 => DesignSystem.spacing24;

  EdgeInsets get paddingAll16 => DesignSystem.paddingAll16;
  EdgeInsets get paddingHorizontal16 => DesignSystem.paddingHorizontal16;

  // Gaps
  SizedBox get gap8 => DesignSystem.gap8;
  SizedBox get gap16 => DesignSystem.gap16;

  // Decorations
  BoxDecoration get cardDecoration => DesignSystem.cardDecoration;
  BoxDecoration get lavenderCardDecoration => DesignSystem.lavenderCardDecoration;

  // Text Styles
  TextStyle get bodyLarge => DesignSystem.bodyLarge;
  TextStyle get bodyMedium => DesignSystem.bodyMedium;
  TextStyle get headline4 => DesignSystem.headline4;

  // Radius
  BorderRadius get radiusLarge => DesignSystem.borderRadiusLarge;
  BorderRadius get radiusXLarge => DesignSystem.borderRadiusXLarge;
}