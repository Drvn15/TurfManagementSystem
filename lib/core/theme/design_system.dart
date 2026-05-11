import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DesignSystem {
  // Colors
  static const Color primaryEmerald = Color(0xFF19C37D);
  static const Color primaryGlow = Color(0xFF37E89B);
  static const Color accentLime = Color(0xFF5BFFB2);
  static const Color backgroundBase = Color(0xFF0B0F0C);
  static const Color backgroundSecondary = Color(0xFF101612);
  static const Color surfaceGlass = Color(0x261E2A24);
  static const Color surfaceElevated = Color(0xFF1A221E);
  static const Color surfaceMuted = Color(0xFF121816);
  static const Color textPrimary = Color(0xFFF5F7F6);
  static const Color textSecondary = Color(0xFF9FB0A7);
  static const Color textMuted = Color(0xFF73827A);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0x2E8CB59F);
  static const Color glassBorder = Color(0x4D9CC8B0);
  static const Color glassHighlight = Color(0x1AFFFFFF);
  static const Color glassShadow = Color(0x66060A08);
  static const Color success = Color(0xFF21D07A);
  static const Color error = Color(0xFFFF6B74);
  static const Color warning = Color(0xFFFFBC58);
  static const Color info = Color(0xFF60B5FF);
  static const Color overlayLight = Color(0x1419C37D);
  static const Color overlayMedium = Color(0x2E19C37D);

  // Legacy aliases
  static const Color primaryIndigo = primaryEmerald;
  static const Color primaryLight = primaryGlow;
  static const Color primaryDark = Color(0xFF108156);
  static const Color backgroundLavender = backgroundBase;
  static const Color backgroundLight = backgroundSecondary;
  static const Color backgroundWhite = surfaceMuted;
  static const Color borderFocus = accentLime;
  static const Color shadowColor = glassShadow;
  static const LinearGradient lavenderGradient = ambientGradient;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryEmerald,
      accentLime,
    ],
  );

  static const LinearGradient ambientGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0B0F0C),
      Color(0xFF101612),
      Color(0xFF121816),
    ],
    stops: [0, 0.45, 1],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF153126),
      Color(0xFF0F1713),
      Color(0xFF0B0F0C),
    ],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x2AFFFFFF),
      Color(0x140F1713),
    ],
  );

  // Typography
  static const double fontSizeDisplay1 = 36;
  static const double fontSizeDisplay2 = 30;
  static const double fontSizeH1 = 28;
  static const double fontSizeH2 = 24;
  static const double fontSizeH3 = 20;
  static const double fontSizeH4 = 18;
  static const double fontSizeH5 = 16;
  static const double fontSizeBodyLarge = 16;
  static const double fontSizeBodyMedium = 14;
  static const double fontSizeBodySmall = 12;
  static const double fontSizeCaption = 11;
  static const double fontSizeButton = 15;
  static const double fontSizeOverline = 10;
  static const double fontSizeStat = 24;

  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  static const double letterSpacingTight = -0.4;
  static const double letterSpacingNormal = 0;
  static const double letterSpacingWide = 0.35;
  static const double lineHeightTight = 1.15;
  static const double lineHeightNormal = 1.45;

  static TextStyle get displayLarge => GoogleFonts.inter(
        fontSize: fontSizeDisplay1,
        fontWeight: fontWeightBold,
        letterSpacing: letterSpacingTight,
        height: lineHeightTight,
        color: textPrimary,
      );

  static TextStyle get displayMedium => GoogleFonts.inter(
        fontSize: fontSizeDisplay2,
        fontWeight: fontWeightBold,
        letterSpacing: letterSpacingTight,
        height: lineHeightTight,
        color: textPrimary,
      );

  static TextStyle get headline1 => GoogleFonts.inter(
        fontSize: fontSizeH1,
        fontWeight: fontWeightBold,
        height: lineHeightTight,
        color: textPrimary,
      );

  static TextStyle get headline2 => GoogleFonts.inter(
        fontSize: fontSizeH2,
        fontWeight: fontWeightSemiBold,
        height: lineHeightTight,
        color: textPrimary,
      );

  static TextStyle get headline3 => GoogleFonts.inter(
        fontSize: fontSizeH3,
        fontWeight: fontWeightSemiBold,
        height: lineHeightTight,
        color: textPrimary,
      );

  static TextStyle get headline4 => GoogleFonts.inter(
        fontSize: fontSizeH4,
        fontWeight: fontWeightSemiBold,
        height: lineHeightTight,
        color: textPrimary,
      );

  static TextStyle get headline5 => GoogleFonts.inter(
        fontSize: fontSizeH5,
        fontWeight: fontWeightSemiBold,
        height: lineHeightTight,
        color: textPrimary,
      );

  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: fontSizeBodyLarge,
        fontWeight: fontWeightRegular,
        height: lineHeightNormal,
        color: textPrimary,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: fontSizeBodyMedium,
        fontWeight: fontWeightRegular,
        height: lineHeightNormal,
        color: textSecondary,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: fontSizeBodySmall,
        fontWeight: fontWeightRegular,
        height: lineHeightNormal,
        color: textMuted,
      );

  static TextStyle get button => GoogleFonts.inter(
        fontSize: fontSizeButton,
        fontWeight: fontWeightSemiBold,
        letterSpacing: letterSpacingWide,
        height: lineHeightTight,
        color: backgroundBase,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: fontSizeCaption,
        fontWeight: fontWeightMedium,
        letterSpacing: 0.2,
        height: lineHeightNormal,
        color: textMuted,
      );

  static TextStyle get overline => GoogleFonts.inter(
        fontSize: fontSizeOverline,
        fontWeight: fontWeightBold,
        letterSpacing: 1.4,
        color: accentLime,
      );

  static TextStyle get statValue => GoogleFonts.inter(
        fontSize: fontSizeStat,
        fontWeight: fontWeightBold,
        color: textPrimary,
      );

  // Spacing
  static const double spacing4 = 4;
  static const double spacing2 = 2;
  static const double spacing6 = 6;
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

  static const EdgeInsets paddingAll4 = EdgeInsets.all(spacing4);
  static const EdgeInsets paddingAll8 = EdgeInsets.all(spacing8);
  static const EdgeInsets paddingAll12 = EdgeInsets.all(spacing12);
  static const EdgeInsets paddingAll16 = EdgeInsets.all(spacing16);
  static const EdgeInsets paddingAll20 = EdgeInsets.all(spacing20);
  static const EdgeInsets paddingAll24 = EdgeInsets.all(spacing24);
  static const EdgeInsets paddingAll32 = EdgeInsets.all(spacing32);
  static const EdgeInsets paddingHorizontal16 = EdgeInsets.symmetric(horizontal: spacing16);
  static const EdgeInsets paddingHorizontal20 = EdgeInsets.symmetric(horizontal: spacing20);
  static const EdgeInsets paddingHorizontal24 = EdgeInsets.symmetric(horizontal: spacing24);
  static const EdgeInsets paddingVertical8 = EdgeInsets.symmetric(vertical: spacing8);
  static const EdgeInsets paddingVertical16 = EdgeInsets.symmetric(vertical: spacing16);
  static const EdgeInsets paddingVertical24 = EdgeInsets.symmetric(vertical: spacing24);
  static const EdgeInsets marginAll16 = EdgeInsets.all(spacing16);
  static const EdgeInsets marginBottom12 = EdgeInsets.only(bottom: spacing12);
  static const EdgeInsets marginBottom16 = EdgeInsets.only(bottom: spacing16);
  static const EdgeInsets marginBottom24 = EdgeInsets.only(bottom: spacing24);

  static const SizedBox gap4 = SizedBox(height: spacing4, width: spacing4);
  static const SizedBox gap8 = SizedBox(height: spacing8, width: spacing8);
  static const SizedBox gap12 = SizedBox(height: spacing12, width: spacing12);
  static const SizedBox gap16 = SizedBox(height: spacing16, width: spacing16);
  static const SizedBox gap24 = SizedBox(height: spacing24, width: spacing24);
  static const SizedBox gap32 = SizedBox(height: spacing32, width: spacing32);
  static const SizedBox gap40 = SizedBox(height: spacing40, width: spacing40);
  static const SizedBox gap48 = SizedBox(height: spacing48, width: spacing48);
  static const SizedBox gap64 = SizedBox(height: spacing64, width: spacing64);
  static const SizedBox gap56 = SizedBox(height: spacing56, width: spacing56);
  static const SizedBox gap80 = SizedBox(height: spacing80, width: spacing80);
  static const SizedBox gap96 = SizedBox(height: spacing96, width: spacing96);

  // Radius
  static const double radiusSmall = 12;
  static const double radiusMedium = 18;
  static const double radiusLarge = 22;
  static const double radiusXLarge = 28;
  static const double radiusRound = 999;

  static BorderRadius get borderRadiusSmall => BorderRadius.circular(radiusSmall);
  static BorderRadius get borderRadiusMedium => BorderRadius.circular(radiusMedium);
  static BorderRadius get borderRadiusLarge => BorderRadius.circular(radiusLarge);
  static BorderRadius get borderRadiusXLarge => BorderRadius.circular(radiusXLarge);
  static BorderRadius get borderRadiusRound => BorderRadius.circular(radiusRound);

  static const RoundedRectangleBorder cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(radiusXLarge)),
  );

  static const RoundedRectangleBorder buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(radiusLarge)),
  );

  static const RoundedRectangleBorder inputShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(radiusLarge)),
  );

  static Border borderLightBorder = Border.all(color: borderLight, width: 1);
  static Border borderFocusBorder = Border.all(color: accentLime, width: 1.4);
  static Border borderErrorBorder = Border.all(color: error, width: 1.2);

  static const double elevation0 = 0;
  static const double elevation1 = 1;
  static const double elevation2 = 2;
  static const double elevation4 = 4;
  static const double elevation8 = 8;

  static const double iconSmall = 16;
  static const double iconMedium = 24;
  static const double iconLarge = 32;
  static const double iconXLarge = 48;

  // Motion
  static const Duration animationFast = Duration(milliseconds: 180);
  static const Duration animationNormal = Duration(milliseconds: 320);
  static const Duration animationSlow = Duration(milliseconds: 520);
  static const Duration animationPage = Duration(milliseconds: 420);
  static const Curve curveStandard = Curves.easeOutCubic;
  static const Curve curveEmphasized = Curves.easeInOutCubicEmphasized;

  // Effects
  static List<BoxShadow> shadowSmall = const [
    BoxShadow(
      color: glassShadow,
      blurRadius: 18,
      offset: Offset(0, 8),
    ),
  ];

  static List<BoxShadow> shadowMedium = const [
    BoxShadow(
      color: glassShadow,
      blurRadius: 28,
      offset: Offset(0, 14),
    ),
  ];

  static List<BoxShadow> glowShadow = const [
    BoxShadow(
      color: Color(0x5C19C37D),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  static BoxDecoration glassDecoration({BorderRadius? radius}) {
    return BoxDecoration(
      borderRadius: radius ?? borderRadiusXLarge,
      gradient: glassGradient,
      border: Border.all(color: glassBorder),
      boxShadow: shadowMedium,
    );
  }

  static BoxDecoration elevatedDecoration({BorderRadius? radius}) {
    return BoxDecoration(
      color: surfaceElevated,
      borderRadius: radius ?? borderRadiusLarge,
      border: Border.all(color: borderLight),
      boxShadow: shadowSmall,
    );
  }

  static BoxDecoration primaryButtonDecoration = BoxDecoration(
    gradient: primaryGradient,
    borderRadius: borderRadiusLarge,
    boxShadow: glowShadow,
  );

  static BoxDecoration cardDecoration = elevatedDecoration();
  static BoxDecoration lavenderCardDecoration = glassDecoration();
  static BoxDecoration whiteCardDecoration = elevatedDecoration(
    radius: borderRadiusLarge,
  );
  static BoxDecoration inputDecoration = elevatedDecoration(
    radius: borderRadiusLarge,
  );
  static BoxDecoration inputFocusDecoration = BoxDecoration(
    color: surfaceElevated,
    borderRadius: borderRadiusLarge,
    border: borderFocusBorder,
    boxShadow: glowShadow,
  );
  static BoxDecoration circularIconDecoration = BoxDecoration(
    color: surfaceGlass,
    shape: BoxShape.circle,
    border: Border.all(color: glassBorder),
  );

  static ThemeData get theme {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.interTextTheme(base.textTheme).copyWith(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      headlineLarge: headline1,
      headlineMedium: headline2,
      headlineSmall: headline3,
      titleLarge: headline4,
      titleMedium: headline5,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: button,
      labelSmall: caption,
    );

    return base.copyWith(
      colorScheme: const ColorScheme.dark(
        primary: primaryEmerald,
        secondary: accentLime,
        surface: surfaceMuted,
        error: error,
        onPrimary: backgroundBase,
        onSecondary: backgroundBase,
        onSurface: textPrimary,
        onError: textWhite,
      ),
      scaffoldBackgroundColor: backgroundBase,
      primaryColor: primaryEmerald,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: headline4,
      ),
      cardTheme: CardThemeData(
        color: surfaceMuted,
        shadowColor: glassShadow,
        elevation: 0,
        shape: cardShape,
        margin: marginAll16,
      ),
      dividerTheme: const DividerThemeData(
        color: borderLight,
        thickness: 1,
        space: spacing24,
      ),
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 22,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: accentLime,
        linearTrackColor: surfaceElevated,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceElevated,
        contentTextStyle: bodyMedium.copyWith(color: textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: borderRadiusLarge),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacing20,
          vertical: spacing18,
        ),
        hintStyle: bodyMedium.copyWith(color: textMuted),
        labelStyle: bodyMedium.copyWith(color: textSecondary),
        prefixIconColor: textSecondary,
        suffixIconColor: textSecondary,
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadiusLarge,
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadiusLarge,
          borderSide: const BorderSide(color: accentLime, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadiusLarge,
          borderSide: const BorderSide(color: error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadiusLarge,
          borderSide: const BorderSide(color: error, width: 1.4),
        ),
        border: OutlineInputBorder(
          borderRadius: borderRadiusLarge,
          borderSide: const BorderSide(color: borderLight),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryEmerald,
          foregroundColor: backgroundBase,
          minimumSize: const Size(double.infinity, spacing56),
          shape: buttonShape,
          padding: paddingHorizontal24,
          textStyle: button,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          minimumSize: const Size(double.infinity, spacing56),
          shape: buttonShape,
          side: const BorderSide(color: glassBorder),
          textStyle: bodyMedium.copyWith(
            color: textPrimary,
            fontWeight: fontWeightSemiBold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentLime,
          textStyle: bodyMedium.copyWith(
            color: accentLime,
            fontWeight: fontWeightSemiBold,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: accentLime,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return accentLime;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(backgroundBase),
        side: const BorderSide(color: glassBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return accentLime;
          }
          return textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryEmerald.withValues(alpha: 0.35);
          }
          return surfaceElevated;
        }),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryEmerald,
        foregroundColor: backgroundBase,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: textPrimary,
        textColor: textPrimary,
        tileColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: borderRadiusLarge),
      ),
    );
  }
}

extension OldAppTheme on DesignSystem {
  static Color get purplePrimary => DesignSystem.primaryEmerald;
  static Color get purpleBackground => DesignSystem.backgroundBase;
  static Color get purpleLight => DesignSystem.backgroundSecondary;
  static Color get purpleSecondary => DesignSystem.accentLime;
}

extension DesignSystemExtension on BuildContext {
  Color get primaryIndigo => DesignSystem.primaryEmerald;
  Color get backgroundLavender => DesignSystem.backgroundBase;
  Color get textPrimary => DesignSystem.textPrimary;
  Color get textSecondary => DesignSystem.textSecondary;
  double get spacing8 => DesignSystem.spacing8;
  double get spacing16 => DesignSystem.spacing16;
  double get spacing24 => DesignSystem.spacing24;
  EdgeInsets get paddingAll16 => DesignSystem.paddingAll16;
  EdgeInsets get paddingHorizontal16 => DesignSystem.paddingHorizontal16;
  SizedBox get gap8 => DesignSystem.gap8;
  SizedBox get gap16 => DesignSystem.gap16;
  BoxDecoration get cardDecoration => DesignSystem.elevatedDecoration();
  BoxDecoration get lavenderCardDecoration => DesignSystem.glassDecoration();
  TextStyle get bodyLarge => DesignSystem.bodyLarge;
  TextStyle get bodyMedium => DesignSystem.bodyMedium;
  TextStyle get headline4 => DesignSystem.headline4;
  BorderRadius get radiusLarge => DesignSystem.borderRadiusLarge;
  BorderRadius get radiusXLarge => DesignSystem.borderRadiusXLarge;
}
